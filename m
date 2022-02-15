Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1BB4B6015
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiBOBmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:42:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiBOBmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:42:03 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7CDDAAEB
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:41:53 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id a28so16325791qvb.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D2orAr4Qpxhe2Djolvt40N/0SVaVsENJC8e5cReQcl8=;
        b=naN9ibosANStiOjRxwXhyFrC2RGC2BTOJYOHEurpOF6S6GZBcGDOsqkq3cJsnlA0Tu
         ennpQTvNvkiB/7Ifupog8Q3v/s7YJJKFLarDWsBqp7dSB9iXjnN9Npgt9zJ6OpsgklMs
         xBL0IMbjRPIpEm02GsekLXmmiUPqUXTWOdjzej04KeVGBqrZYV4sZyUWA52enEAmBNGy
         RqCIy3U/ZwEmLH1WxJkH+YpzKm6s0Nk4LEq7UNrkwvDCOJFpKR2snn04JrbBwo0r7KsJ
         hIGLPJ5ibfH9oBoaA7f/svuZqM+NoIxf3JDrJjLI9dhRxCO/GausehOnOcSun6Oo+lYc
         ++7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D2orAr4Qpxhe2Djolvt40N/0SVaVsENJC8e5cReQcl8=;
        b=3WQ1tIMFXr7Dfx43R6fsD0qYAVRn6vpdo/XMXaISaHWjIkYia8y75dHxTOUAFfp1ih
         8AJEAK0LHsDUH9awv44OFyWx3qXii++iekoEl2ixmptuylfxTM+TfoWcDV6LlxT1KOAj
         BNruttT4DFAeNYVTrtyp3Y3EBkGZZyiJtJ42KK9NeX0Mc/nNEfw7bzLyfWZFs2i6x/6Y
         4UT/uV6/bwVPGpFpL7OUeV5NopsQZ2QfrJ5CewqLOroUXgUqzW0lUkxxokumGZNTsQXo
         lq6EEqXTAEgKBkiPVHSeJAQKi3KEKcWulJBuGhYf8T/zQVA5DP2X8B+LBPbwG91UQ0ci
         To/g==
X-Gm-Message-State: AOAM533hV65BnLhwwZHZO5xdksLPK91ablo9DiGNbjTq1odTZsxkvXaT
        dKeJ3/aZcN5DnBEmEoS8d1E=
X-Google-Smtp-Source: ABdhPJx/jDFivNy35SvdBEWnWp1lCcQQo0XrCnhbqmIKWIG+lgk3IyGcq/bYwOeZ+0/9ULnZu7ykEg==
X-Received: by 2002:a05:6214:19ec:: with SMTP id q12mr1065888qvc.44.1644889313034;
        Mon, 14 Feb 2022 17:41:53 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:1336:e323:f59d:db64])
        by smtp.gmail.com with ESMTPSA id t22sm228746qtq.29.2022.02.14.17.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:41:52 -0800 (PST)
Date:   Mon, 14 Feb 2022 17:41:51 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: sched: limit TC_ACT_REPEAT loops
Message-ID: <YgsE30gfoQkruTYS@pop-os.localdomain>
References: <20220214203434.838623-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214203434.838623-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 12:34:34PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 32563cef85bfa29679f3790599b9d34ebd504b5c..b1fb395ca7c1e12945dc70219608eb166e661203 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1037,6 +1037,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>  restart_act_graph:
>  	for (i = 0; i < nr_actions; i++) {
>  		const struct tc_action *a = actions[i];
> +		int repeat_ttl;
>  
>  		if (jmp_prgcnt > 0) {
>  			jmp_prgcnt -= 1;
> @@ -1045,11 +1046,17 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>  
>  		if (tc_act_skip_sw(a->tcfa_flags))
>  			continue;
> +
> +		repeat_ttl = 10;

Not sure if there is any use case of repeat action with 10+ repeats...
Use a sufficiently larger one to be 100% safe?

>  repeat:
>  		ret = a->ops->act(skb, a, res);
> -		if (ret == TC_ACT_REPEAT)
> -			goto repeat;	/* we need a ttl - JHS */
> -
> +		if (unlikely(ret == TC_ACT_REPEAT)) {
> +			if (--repeat_ttl != 0)
> +				goto repeat;
> +			/* suspicious opcode, stop pipeline */

This comment looks not match and unnecessary?

> +			pr_err_once("TC_ACT_REPEAT abuse ?\n");

Usually we use net_warn_ratelimited().

Thanks.
