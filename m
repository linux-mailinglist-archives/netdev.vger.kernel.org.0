Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFB44B126F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbiBJQMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:12:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243950AbiBJQMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:12:19 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFE1D44
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:12:20 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id k25so16534437ejp.5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6XOmJ1UyDycHY5UdXxbxQV9PiD6uahh2GB1VgE0rPWQ=;
        b=Uk31OHHaY3cTgy1cyklnKlTpuFR/pYqI1EJe0bJjtjS423GFlMs3i8LYSs/PKHvj/X
         ECdFCydpEErDpoDIRBKrvu4oigDZss5VGLJQgV849EepGwBYMd4+r9Uzv0E7kyvyhICg
         AL+n7UQC3OsBl4da1fXsydHFp1m/Ivy3ARj9S4PmomBtKzBjF2eTESrwzMjMRak2J9q/
         SDl/ScudH5rfPC2IMeebS1547SJG65JgQKnWwxNmN6r/2Wq64QSf+97r1ZwDB6vRbq5K
         XbvIJmRgFiVnnDlqWMTl1V/1dVjLwe4HM47T8vhn5HjXw84+wWeDUdyX7kcUYJJEDWSz
         uUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6XOmJ1UyDycHY5UdXxbxQV9PiD6uahh2GB1VgE0rPWQ=;
        b=DZwgrnzMylQPZ/X7FVrg0vMGoSPBxfVd2VlRmsNTLRIEdrCUf6s5ILEJ/hXRkw4gQB
         XVOV5Pg75ay9Vq6hWShmcxLLWEqJtC97QyU1TiDyw1HrOp/fA1BsnfmNwUyzrUznmhAt
         hGOqs+nvqRotOb7Xngf6qdsaqoJHj+6rJ3Z7X78Q/ncx2Y39o6uHJoGCmoEngxFmO2Ty
         GB8TSCXHvOlXXttcMnbHjKqjtPScbyZCNjpBTFmO1zyUdVgNPyE1Rrv9kOKZolynR3zx
         +tAvCF6Gn7YE6C181UUAPLcTTjSludMpFD9jNmfGVwpd+RFqpkKYm6QdXWsmlesI3hre
         Gkwg==
X-Gm-Message-State: AOAM5335Icv1GAUmLxk8Y+8uSsjK2FgErR0C8qwmWd5C699i8RIGAsbP
        HYZmK0+RcJbDlHjMhlrYKzI=
X-Google-Smtp-Source: ABdhPJzMDIGGrTfTdHnMmdLdlDQWi1gS1STPTY0SbOXn7+80Y93FU5H30DBjxM9uPV2OeY2yYttWJQ==
X-Received: by 2002:a17:906:4f0c:: with SMTP id t12mr7054444eju.191.1644509539250;
        Thu, 10 Feb 2022 08:12:19 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id k13sm4507263ejz.167.2022.02.10.08.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:12:18 -0800 (PST)
Date:   Thu, 10 Feb 2022 18:12:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: hsr: fix suspicious usage in hsr_node_get_first
Message-ID: <20220210161216.jc5hydc2sb5nyamo@skbuf>
References: <20220210154912.5803-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210154912.5803-1-claudiajkang@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 03:49:12PM +0000, Juhee Kang wrote:
> Currently, to dereference hlist_node which is result of hlist_first_rcu(),
> rcu_dereference() is used. But, suspicious RCU warnings occur because
> the caller doesn't acquire RCU. So it was solved by adding rcu_read_lock().
> 
> The kernel test robot reports:
>     [   53.750001][ T3597] =============================
>     [   53.754849][ T3597] WARNING: suspicious RCU usage
>     [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
>     [   53.766947][ T3597] -----------------------------
>     [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
>     [   53.780129][ T3597] other info that might help us debug this:
>     [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
>     [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:
> 
> Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  net/hsr/hsr_framereg.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index b3c6ffa1894d..92abdf855327 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct hlist_head *head)
>  {
>  	struct hlist_node *first;
>  
> +	rcu_read_lock();
>  	first = rcu_dereference(hlist_first_rcu(head));
> +	rcu_read_unlock();

Why wasn't this an issue when when hsr_node_get_first() was just list_first_or_null_rcu()?
Full stack trace please?

I am not familiar with the hsr code base, but I don't need more context
than given to realize that this isn't the proper solution. You aren't
really "fixing" anything if you exit the RCU critical section but still
use "first" afterwards. The driver probably needs some proper accessors
from the writer side, with
rcu_dereference_protected(..., lockdep_is_held(&hsr->list_lock));

> +
>  	if (first)
>  		return hlist_entry(first, struct hsr_node, mac_list);
>  
> -- 
> 2.25.1
> 
