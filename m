Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F834C97CD
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiCAVcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiCAVcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:32:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E781190;
        Tue,  1 Mar 2022 13:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5VVuLOyzVojFtdlB1wdXu5nu6vPydR5gopX9RTl4ymY=; b=hzHwr/X84crorF5eqeeLqMG9h0
        8LdN1r0CUxK5OhHZJsKcqS4ut++icTOMJ/PjT8hnPOWsG133TDvYyNtY9qzdxcZtFA7ZHHvbXFeXp
        LWduIdbEN4fCsup6Io73V7hKDAGPcqZ20fAim9GmOmSC1lg03UgsDCAABTY2BiAM4pnYTaWE35Pmw
        CtJepFr99HGihM7nUoyJ2gICUJjdtkCKLsy2vEerFGML6tLQTB301uh/SBSfSOFF92Ig/IqWdc3ax
        nV521LwOTFx7jzMNoonpPUABoLOliEKFruuxE50hMt4zv2TTLbygsnAIIcbodwzUNFKdoLd1ZnzOV
        PS5oyBGg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPA5Y-000dS7-1r; Tue, 01 Mar 2022 21:31:20 +0000
Date:   Tue, 1 Mar 2022 13:31:20 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
Message-ID: <Yh6QqEFTxUuDEst2@bombadil.infradead.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
 <YhzeCkXEvga7+o/A@bombadil.infradead.org>
 <20220301180917.tkibx7zpcz2faoxy@google.com>
 <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
 <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
 <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 01:25:16PM -0800, Luis Chamberlain wrote:
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 4f5613dac227..980ffaba1ac5 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -238,6 +238,8 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
>  		long max;
>  		tns = iter->ns;
>  		max = READ_ONCE(tns->ucount_max[type]);
> +		if (atomic_long_read(&iter->ucount[type]) > max/16)
> +			cond_resched();
>  		if (!atomic_long_inc_below(&iter->ucount[type], max))
>  			goto fail;

You can of course ignore this, it was just a hack to try to avoid
a soft lockup on the workqueues.

  Luis
