Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC9763CE74
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiK3EsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiK3EsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:48:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79DF64556;
        Tue, 29 Nov 2022 20:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F73661A01;
        Wed, 30 Nov 2022 04:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1A1C433D7;
        Wed, 30 Nov 2022 04:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669783699;
        bh=FcnFgEt9daWUg1bE7GqdiCvcyu5jFWhYlabzDjVQ+GE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fV8Mok3GzjYqRgeg/stgUH0bdwVMv3WEzbbANKJPw4HktVwaKQ9GKO458J8gtwYt8
         GcQ+hwgXcUGAALlcUekOJuSbbPIIVde/w5zaHHjKvqZY+x/izyKBpsz4h1aHMkayVR
         qiNvkAmChWcYYwObYAicHiZXQYO0uSV7TIYes4MFp/gqJ45XmUyXaut+v0nqyF5xDR
         /JIxScQlnKi3+6fFvInNsLszfNL1UNj8zHzLBhusGuUp6FNYthsdi/BBVs+PSmYiIu
         2oYvGoqC6MSOqLWE6nnKrxDmksWHNh0jSGfP5nJQo0VU8KIc8xIWKrMRsg3tPdueU5
         W7uCmK4rhgKcQ==
Date:   Tue, 29 Nov 2022 20:48:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Firo Yang <firo.yang@suse.com>
Cc:     marcelo.leitner@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com, mkubecek@suse.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH v2 1/1] sctp: sysctl: make extra pointers netns aware
Message-ID: <20221129204818.7d8204b4@kernel.org>
In-Reply-To: <20221125121127.40815-1-firo.yang@suse.com>
References: <20221125121127.40815-1-firo.yang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Nov 2022 20:11:27 +0800 Firo Yang wrote:
> +#define SCTP_RTO_MIN_IDX       1
> +#define SCTP_RTO_MAX_IDX       2
> +#define SCTP_PF_RETRANS_IDX    3
> +#define SCTP_PS_RETRANS_IDX    4

Use these to index the entries, please, like this:

struct bla table[] = {
	[MY_INDEX_ONE] = {
		.whatever = 1,
	},
	[MY_INDEX_TWO] = {
		.fields = 2,
	},
	{
		.there = 3,
	},
	{
		.are = 4,
	},
};

I think that works even without all entries in the table having the
index.. ?

>  static struct ctl_table sctp_net_table[] = {
>  	{
>  		.procname	= "rto_initial",
> @@ -112,6 +122,24 @@ static struct ctl_table sctp_net_table[] = {
>  		.extra1         = &init_net.sctp.rto_min,
>  		.extra2         = &timer_max
>  	},
> +	{
> +		.procname	= "pf_retrans",
> +		.data		= &init_net.sctp.pf_retrans,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= &init_net.sctp.ps_retrans,
> +	},
> +	{
> +		.procname	= "ps_retrans",
> +		.data		= &init_net.sctp.ps_retrans,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &init_net.sctp.pf_retrans,
> +		.extra2		= &ps_retrans_max,
> +	},
