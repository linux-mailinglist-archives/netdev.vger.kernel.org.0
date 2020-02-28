Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D080317400C
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgB1TAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:00:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgB1TAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:00:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F36524650;
        Fri, 28 Feb 2020 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582916446;
        bh=oiN+vw82YC4G4dBMZGD38IagIMDTKxtFX6jGuP0tb6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pMdtxamovopKTBN62+q0WVmLlpprDYml/AU8/iI8elWqiwRvEZxmLjm2B4AcPvVmQ
         gBYfsC3iu4AIzFCo/KPmIrub9jW+/yEHh4kYd0axrhgz21DvYKMixc+TqBdfqdgs3H
         ggckDU2LVhyDEdlGdX+fwmB2GH86Ra/j4sgTjv2c=
Date:   Fri, 28 Feb 2020 11:00:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     netdev@vger.kernel.org, toke@redhat.com, davem@davemloft.net,
        hawk@kernel.org, sameehj@amazon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
Message-ID: <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228105435.75298-1-lrizzo@google.com>
References: <20200228105435.75298-1-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 02:54:35 -0800 Luigi Rizzo wrote:
> Add a netdevice flag to control skb linearization in generic xdp mode.
> 
> The attribute can be modified through
> 	/sys/class/net/<DEVICE>/xdpgeneric_linearize
> The default is 1 (on)
> 
> Motivation: xdp expects linear skbs with some minimum headroom, and
> generic xdp calls skb_linearize() if needed. The linearization is
> expensive, and may be unnecessary e.g. when the xdp program does
> not need access to the whole payload.
> This sysfs entry allows users to opt out of linearization on a
> per-device basis (linearization is still performed on cloned skbs).
> 
> On a kernel instrumented to grab timestamps around the linearization
> code in netif_receive_generic_xdp, and heavy netperf traffic with 1500b
> mtu, I see the following times (nanoseconds/pkt)
> 
> The receiver generally sees larger packets so the difference is more
> significant.
> 
> ns/pkt                   RECEIVER                 SENDER
> 
>                     p50     p90     p99       p50   p90    p99
> 
> LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
> 
> v1 --> v2 : added Documentation
> v2 --> v3 : adjusted for skb_cloned
> v3 --> v4 : renamed to xdpgeneric_linearize, documentation
> 
> Signed-off-by: Luigi Rizzo <lrizzo@google.com>

Just load your program in cls_bpf. No extensions or knobs needed.

Making xdpgeneric-only extensions without touching native XDP makes 
no sense to me. Is this part of some greater vision?
