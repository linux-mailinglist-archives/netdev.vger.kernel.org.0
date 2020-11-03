Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B8B2A4B8D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgKCQaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgKCQaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:30:52 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B53272072C;
        Tue,  3 Nov 2020 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604421052;
        bh=LKI4N1fVLHi2H2rPCMGg8y/dxocDD5dWMprOfvkWL04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DogVLlc0U2UuCbO4aofA7OK245Sx9wfLbRWXtj8vse+IJOq/UT71xTYTdM2bigqQE
         8glZeeAzJslxhT5g92kUlWbXRBPd8StpGr4TN/GKOWxXmJjfpNVVh37wC8PN2S+e0u
         FebxYsNRDKIeJHAlsFH+zZ1DMythGvbf5M7A1bm0=
Date:   Tue, 3 Nov 2020 08:30:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, james.jurack@ametek.com
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103161319.wisvmjbdqhju6vyh@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201029081057.8506-1-claudiu.manoil@nxp.com>
        <20201103161319.wisvmjbdqhju6vyh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 18:13:19 +0200 Vladimir Oltean wrote:
> [14538.046926] PC is at skb_release_data+0x6c/0x14c
> [14538.051518] LR is at consume_skb+0x38/0xd8
> [14538.055588] pc : [<c10e439c>]    lr : [<c10e3fac>]    psr: 200f0013
> [14538.061817] sp : c28f1da8  ip : 00000000  fp : c265aa40
> [14538.067010] r10: 00000000  r9 : 00000000  r8 : c2f98000
> [14538.072204] r7 : c511d900  r6 : c3d3d900  r5 : c3d3d900  r4 : 00000000
> [14538.078693] r3 : 000000d3  r2 : 00000001  r1 : 00000000  r0 : 00000000

> [14538.263039] [<c10e439c>] (skb_release_data) from [<c10e3fac>] (consume_skb+0x38/0xd8)
> [14538.270834] [<c10e3fac>] (consume_skb) from [<c0d529bc>] (gfar_start_xmit+0x704/0x784)
> [14538.278714] [<c0d529bc>] (gfar_start_xmit) from [<c10fcdf8>] (dev_hard_start_xmit+0xfc/0x254)
> [14538.287198] [<c10fcdf8>] (dev_hard_start_xmit) from [<c1158524>] (sch_direct_xmit+0x104/0x2e0)

Looks like one of the error paths freeing a wonky skb.

Could you decode these addresses to line numbers?
