Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA414DCFD
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 15:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgA3OpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 09:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgA3OpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 09:45:19 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507F3206D3;
        Thu, 30 Jan 2020 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580395518;
        bh=sTH5KNRveQiyXDTvS+sO3sORXmNj2mmdy3oqEwBSqCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zX8AdjY0ewUC9bFP4esdGPlZSgIcgra94Pl0W4rPgk241axCVQ1S2hNN9G0m/DvBs
         IajwNJPg4ZFI8+ASpSytf1vdJ/Y8edbZRKs13klgBzvJaLBivKVGVtVUIVh7QWiGCk
         rzC4F9m4A9yI//p2Uizp2/EHAGXjDlIbK57hmKGo=
Date:   Thu, 30 Jan 2020 06:45:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200130064517.43f2064f@cakuba>
In-Reply-To: <20200128151343.28c1537d@carbon>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126134933.2514b2ab@carbon>
        <20200126141701.3f27b03c@cakuba>
        <20200128151343.28c1537d@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020 15:13:43 +0100, Jesper Dangaard Brouer wrote:
> On Sun, 26 Jan 2020 14:17:01 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Sun, 26 Jan 2020 13:49:33 +0100, Jesper Dangaard Brouer wrote:  
> > > Yes, please. I want this NIC TX hook to see both SKBs and xdp_frames.    
> > 
> > Any pointers on what for? Unless we see actual use cases there's
> > a justifiable concern of the entire thing just being an application of
> > "We can solve any problem by introducing an extra level of indirection."  
> 
> I have two use-cases:
> 
> (1) For XDP easier handling of interface specific setting on egress,
> e.g. pushing a VLAN-id, instead of having to figure this out in RX hook.
> (I think this is also David Ahern's use-case)

Is it really useful to have a hook before multi-buffer frames are
possible and perhaps TSO? The local TCP performance is going to tank
with XDP enabled otherwise.

> (2) I want this egress XDP hook to have the ability to signal
> backpressure. Today we have BQL in most drivers (which is essential to
> avoid bufferbloat). For XDP_REDIRECT we don't, which we must solve.
> 
> For use-case(2), we likely need a BPF-helper calling netif_tx_stop_queue(),
> or a return code that can stop the queue towards the higher layers.

Agreed, although for that use case, I'm not sure if non-XDP frames 
have to pass trough the hook. Hard to tell as the current patches 
don't touch on this use case.
