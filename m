Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5606D3E7D1C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhHJQFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhHJQFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E339610A7;
        Tue, 10 Aug 2021 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628611492;
        bh=+316AHpG9CS+wzcSKZ4Rrgf6d+Pn0mavPMcpIrPJE4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RHD6VhtS681YYMqTJ2ZVjc3exxc4yhPhpEXu2AM6Mb4Aw0FHcJ1EI9CcptqvGsp4y
         AnniMXJhUSlT5DdPdBXIV/F5U48oDXXcVz3RsQ456W9SvoOUwicw8T4X3wXPY0UdoE
         ghtavwJt9fRA9dsdHSUTOqgeQgpZL1IwtTxzh869EKBn0yDc8zpv8XZBPXIT4AFwJf
         QfczOAeKjRTYHi5A9YqhXkkl5dHZcaRqiq4akFtBOpXpN4FNwh6VREp8O9zEnRYyRi
         j5AyBswZFK0Uor6d1otCRI/zk69c9nSHimb3sJNKvfbHbFfrmG9xMwZa25bwnMHV6r
         6h0fbtbtOa1CA==
Received: by pali.im (Postfix)
        id 649BC82D; Tue, 10 Aug 2021 18:04:50 +0200 (CEST)
Date:   Tue, 10 Aug 2021 18:04:50 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210810160450.eluiktsp7oentxo3@pali>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210810153941.GB14279@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 10 August 2021 17:39:41 Guillaume Nault wrote:
> On Mon, Aug 09, 2021 at 09:31:09PM +0200, Pali Rohár wrote:
> > Better to wait. I would like hear some comments / review on this patch
> > if this is the correct approach as it adds a new API/ABI for userspace.
> 
> Personally I don't understand the use case for setting the ppp unit at
> creation time.

I know about two use cases:

* ppp unit id is used for generating network interface name. So if you
  want interface name ppp10 then you request for unit id 10. It is
  somehow common that when ppp interface has prefix "ppp" in its name
  then it is followed by unit id. Seems that existing ppp applications
  which use "ppp<num>" naming expects this. But of course you do not
  have to use this convention and rename interfaces as you want.

* Some of ppp ioctls use unit id. So you may want to use some specific
  number for some network interface. So e.g. unit id 1 will be always
  for /dev/ttyUSB1.

> I didn't implement it on purpose when creating the
> netlink interface, as I didn't have any use case.
> 
> On the other hand, adding the ppp unit in the netlink dump is probably
> useful.

Yes, this could be really useful as currently if you ask netlink to
create a new ppp interface you have to use ioctl to retrieve this unit
id. But ppp currently does not provide netlink dump operation.

Also it could be useful for this "bug":
https://lore.kernel.org/netdev/20210807132703.26303-1-pali@kernel.org/t/#u

And with unit id there also another issue:
https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/t/#u

But due to how it is used we probably have to deal with it how ppp unit
id are defined and assigned...
