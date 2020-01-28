Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C7314BAC8
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 15:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgA1OOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 09:14:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbgA1OOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 09:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580220859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1TT+QoDrDwn4Has4Pl8Zj6cAkxwn/5nCKkHuYuA4YJw=;
        b=ie63clTFg4g+h4t1H2bSCW3GaG0nSonyeiEgAQrtJfHgodgNeMSGY3g088F8edMlPDkBQB
        rGGrP71xSICRx/QS5hr+SskeOGzfUgCbalxeBcjtD+q9JiU4IvicnEuhSvO5jR9yWnTQ9g
        MTlECjljCKC71TcrStsvih2FK06VHns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-fe3j9RyFPd6_wlhX5NO4vA-1; Tue, 28 Jan 2020 09:14:01 -0500
X-MC-Unique: fe3j9RyFPd6_wlhX5NO4vA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1F6280568F;
        Tue, 28 Jan 2020 14:13:57 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6465284BAF;
        Tue, 28 Jan 2020 14:13:47 +0000 (UTC)
Date:   Tue, 28 Jan 2020 15:13:43 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <20200128151343.28c1537d@carbon>
In-Reply-To: <20200126141701.3f27b03c@cakuba>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126134933.2514b2ab@carbon>
        <20200126141701.3f27b03c@cakuba>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 14:17:01 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sun, 26 Jan 2020 13:49:33 +0100, Jesper Dangaard Brouer wrote:
> > Yes, please. I want this NIC TX hook to see both SKBs and xdp_frames.  
> 
> Any pointers on what for? Unless we see actual use cases there's
> a justifiable concern of the entire thing just being an application of
> "We can solve any problem by introducing an extra level of indirection."

I have two use-cases:

(1) For XDP easier handling of interface specific setting on egress,
e.g. pushing a VLAN-id, instead of having to figure this out in RX hook.
(I think this is also David Ahern's use-case)


(2) I want this egress XDP hook to have the ability to signal
backpressure. Today we have BQL in most drivers (which is essential to
avoid bufferbloat). For XDP_REDIRECT we don't, which we must solve.

For use-case(2), we likely need a BPF-helper calling netif_tx_stop_queue(),
or a return code that can stop the queue towards the higher layers.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

