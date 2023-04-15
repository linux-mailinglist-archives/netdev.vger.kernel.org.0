Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C066E2E1E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDOBNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDOBNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:13:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1745FF6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA8E60CEB
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0724AC433EF;
        Sat, 15 Apr 2023 01:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681521226;
        bh=y6Hw8u42Qkp4hPDeQ4pQNOqXkWHVxgf+3HbQvAzRSE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M1PnSyBn5fcqsxzSpNjDQIZ3Jcja+oPvVxFprmLsS9vUSAnnv4Lq2DOmMBvEyNa1W
         gOUb1BRz1HgwPjXc1n/jl9lkhItd6Evj7MeDUmSoIoye+TM21tQm7oubkZOyJIfT4k
         6tnjyc/js3j7J+xeLr7jk+u8Kj16wEZaKPSD/PhY6uKuEm5FhgmO14o5S7PV8pHupJ
         JJKyzIB805y8xm4ImPDIWf3Ex2KOYKxfieMT10qmvbz6Iz/uH0C99h4KVXm9egijmP
         51eYGjAbI2rE6aWKjXe8hj9GgZy53muu7FnI1eI+5p67YKVze34eUNcVgz59WYZsZr
         d3HaSO7lrO1mA==
Date:   Fri, 14 Apr 2023 18:13:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 1/2] net/sched: sch_htb: use extack on errors
 messages
Message-ID: <20230414181345.34114441@kernel.org>
In-Reply-To: <20230414185309.220286-2-pctammela@mojatatu.com>
References: <20230414185309.220286-1-pctammela@mojatatu.com>
        <20230414185309.220286-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 15:53:09 -0300 Pedro Tammela wrote:
> @@ -1917,8 +1917,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  			};
>  			err = htb_offload(dev, &offload_opt);
>  			if (err) {
> -				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
> -				       err);
> +				NL_SET_ERR_MSG_FMT_MOD(extack,

What's the ruling on using _MOD() in qdiscs ?
There are some extacks already in this file without _MOD().

> +						       "TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
> +						       err);

The formatting of an error into the message is unnecessary duplication.
The error value does not make it to dmesg so we need to print it there,
but it's already present at the netlink level.
