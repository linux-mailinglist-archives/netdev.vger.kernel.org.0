Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B923E7E14
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhHJRRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhHJRQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 13:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ABD360EBD;
        Tue, 10 Aug 2021 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628615792;
        bh=JSZL0e4NclyDFSNzNmGpeWxp9VO4KgNeNMmFx3jjGG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lsWcNocO2695V/zQ5Q1GCglj67pSLVKLTwpLXBfjTbRp9EdMmoMOTfCR2YXazuQ4o
         VPgtJvmKYpv6QwpprDHJ779acSLSRLe57UOWu4AGV0b+1M1EUhX83p91nR1xhKP9T9
         7R4lXvbY34G75bvLALefPTws1SUTkKjwTR2GL7RLAOA+AKWWo6fXYShD5/XqToBIBk
         QbAvCp3GNekDfnIxnnRAQlVQG0huqSFdWyaiasQ4Vx5efVhsmJOR4yTjhVYvgJpkDB
         z8/visefC3Y3AtKmYSHOtuMB6RxVIaPy6hLV/ObubZQKH/zxkjCwJysgUhVjPvCX4w
         MUWSgKn3ODg5A==
Received: by pali.im (Postfix)
        id 9C19082D; Tue, 10 Aug 2021 19:16:26 +0200 (CEST)
Date:   Tue, 10 Aug 2021 19:16:26 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Chris Fowler <cfowler@outpostsentinel.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210810171626.z6bgvizx4eaafrbb@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 10 August 2021 16:38:32 Chris Fowler wrote:
> Isn't the UNIT ID the interface number?  As in 'unit 100' will give me ppp100?

If you do not specify pppd 'ifname' argument then pppd argument 'unit 100'
will cause that interface name would be ppp100.

But you are free to rename interface to any string which you like, even
to "ppp99".

But this ppp unit id is not interface number. Interface number is
another number which has nothing with ppp unit id and is assigned to
every network interface (even loopback). You can see them as the first
number in 'ip -o l' output. Or you can retrieve it via if_nametoindex()
function in C.


... So if people are really using pppd's 'unit' argument then I think it
really make sense to support it also in new rtnl interface.

> I have it running on over 1000 interfaces.  I use PPP in a P-t-P VPN scenario between a central server and remote network devices.  Iuse the unit id to identify a primary key in a database for that connection.  This is calculated as 1000+N = UNIT ID.
> 
> I use 1000 because I've also used PPP on the same system with modem boards for demand dial PPP connections.  The up and down scripts executed by PPP are written in C and allow a system where if the VPN link is down, the remote can dial and obtain the same IP addressing via modem.  We don't use modems that often now due to reliability issues.  It has been harder obtaining clean lines in the US.
> 
> The C program also applies routes that are defined in the database.  That search is based on the IP assigned, not the unit id.
> 
> Chris
> 
> ________________________________
> From: Guillaume Nault <gnault@redhat.com>
> Sent: Tuesday, August 10, 2021 11:39 AM
> To: Pali Rohár <pali@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>; Paul Mackerras <paulus@samba.org>; David S. Miller <davem@davemloft.net>; linux-ppp@vger.kernel.org <linux-ppp@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying ppp unit id
> 
> On Mon, Aug 09, 2021 at 09:31:09PM +0200, Pali Rohár wrote:
> > Better to wait. I would like hear some comments / review on this patch
> > if this is the correct approach as it adds a new API/ABI for userspace.
> 
> Personally I don't understand the use case for setting the ppp unit at
> creation time. I didn't implement it on purpose when creating the
> netlink interface, as I didn't have any use case.
> 
> On the other hand, adding the ppp unit in the netlink dump is probably
> useful.
> 
