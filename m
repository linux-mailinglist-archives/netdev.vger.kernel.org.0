Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADD5173FA
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383294AbiEBQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbiEBQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A232BC93
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 09:13:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D802B612B2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 16:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9789C385B0;
        Mon,  2 May 2022 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651507993;
        bh=s67MTpM3PYGg6ltmkONqjZbqPNKoz4HiuhXReKmm17Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m+KuBwcAFuLFr5n3D5MaDUwrXXHTRfPL3/rIncezE/QvSHudqMok7lf7pFNOUrFoC
         vELt7NQSKRJxNIPADRjh9Imc5VAhv6IOzgDEQOPz+OUtPhiVmvuFECQu8ikgIk/AGV
         9s0tJgXPJgp2ZU5/U4orJZj8NVrcY11lacbAeTvvba0cguBy4NgkC2PY5rHbDHcQmp
         pS65a2XfFcAgbmfDI6x8u9UuLIcy2SS2MrsCLmDbRCwurewolOPhiEJ6SN0a3L/+s6
         n4pS9pLBngPy3C5BJy59Pd7KYrMFz/8jNgcwVOverr0OEATwxBcYdCGC0vQrhvfyYf
         BRpYFo5KDXMlg==
Date:   Mon, 2 May 2022 09:13:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
Message-ID: <20220502091311.2cbc2c32@kernel.org>
In-Reply-To: <CAM_iQpX0Ej+dCCum8mpVM+dYmi=dxmDa+OhnVEQhoB9av_yGDQ@mail.gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
        <20220410161042.183540-2-xiyou.wangcong@gmail.com>
        <20220425120724.32af0cc3@kernel.org>
        <CAM_iQpX0Ej+dCCum8mpVM+dYmi=dxmDa+OhnVEQhoB9av_yGDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Apr 2022 10:22:33 -0700 Cong Wang wrote:
> > I started prototyping a similar patch for TLS a while back but I have
> > two functions - one to get the skb and another to consume it. I thought
> > that's better for TLS, otherwise skbs stuck in the middle layer are not
> > counted towards the rbuf. Any thoughts on structuring the API that way?
> > I guess we can refactor that later, since TLS TCP-only we don't need
> > proto_ops plumbing there.  
> 
> Do you have a pointer to the source code? I am not sure how TLS uses
> ->read_sock() (or which interface is relevant).  

Nothing useful, I started hacking on removing strparser but then got
distracted with functional optimizations. TLS calls ->read_sock() thru
strparser.

With a little bit of code duplication TLS should be able to avoid 
the strparser's heavy machinery and cloning each skb.
