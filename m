Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03594D3C21
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiCIVhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiCIVhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:37:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2510CFA231;
        Wed,  9 Mar 2022 13:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B60D261B0E;
        Wed,  9 Mar 2022 21:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8DEC340E8;
        Wed,  9 Mar 2022 21:36:13 +0000 (UTC)
Date:   Wed, 9 Mar 2022 16:36:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net v2] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <20220309163611.3c6e2beb@gandalf.local.home>
In-Reply-To: <YikSav7Y1iEQv8sq@linutronix.de>
References: <YikSav7Y1iEQv8sq@linutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 21:47:38 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -357,7 +357,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  	if (IS_ERR(xdp_alloc))
>  		return PTR_ERR(xdp_alloc);
>  
> -	trace_mem_connect(xdp_alloc, xdp_rxq);
> +	if (xdp_alloc)

Eliminate the check when tracing is disabled:

	if (trace_mem_connect_enabled() && xdp_alloc)

-- Steve


> +		trace_mem_connect(xdp_alloc, xdp_rxq);
>  	return 0;
>  }
>  
