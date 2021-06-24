Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613613B2FC0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhFXNIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFXNIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 09:08:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D974C613C3;
        Thu, 24 Jun 2021 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624539971;
        bh=X5fgruXZAH6/dwtIj9BUqyJ6jlUiiRQEvoljwULOpAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OGYINAbuGasSG7nLZAa1F5HYrm1MRw/U0QA6imTs9s2BE2lPupOdkJkq0gZ87x0Sb
         yesHqPbqTj80zcQ+MmgtI5bRE7sFF0bQV4SBJdQRyd99mOxV4POTAfrCs9pMok1y/Q
         M8IzFW4pQrZMldEaFQlwECzz5es9sGGbKy5izkaY=
Date:   Thu, 24 Jun 2021 15:06:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Message-ID: <YNSDQbp/h/aadpmV@kroah.com>
References: <YNRKhJB9/K4SKPdR@kroah.com>
 <20210624122435.11887-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624122435.11887-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 08:24:35PM +0800, Rocco Yue wrote:
> On Thu, 2021-06-24 at 11:04 +0200, Greg KH wrote:
> On Thu, Jun 24, 2021 at 02:13:10PM +0800, Rocco Yue wrote:
> >> On Thu, 2021-06-24 at 07:29 +0200, Greg KH wrote:
> >>> 
> >>> Thanks for the explaination, why is this hardware somehow "special" in
> >>> this way that this has never been needed before?
> >>> 
> >>> thanks,
> >>> 
> >>> greg k-h
> >>> 
> >> 
> >> Before kernel-4.18, RAWIP was the same as PUREIP, neither of them
> >> automatically generates an IPv6 link-local address, and the way to
> >> generate an IPv6 global address is the same.
> >> 
> >> After kernel-4.18 (include 4.18 version), the behavior of RAWIP had
> >> changed due to the following patch:
> >> @@  static int ipv6_generate_eui64(u8 *eui, struct net_device *dev)
> >> +	case ARPHRD_RAWIP:
> >> +		return addrconf_ifid_rawip(eui, dev);
> >>  	}
> >>  	return -1;
> >> }
> >> 
> >> the reason why the kernel doesn't need to generate the link-local
> >> address automatically is as follows:
> >> 
> >> In the 3GPP 29.061, here is some description as follows:
> >> "in order to avoid any conflict between the link-local address of
> >> MS and that of the GGSN, the Interface-Identifier used by the MS to
> >> build its link-local address shall be assigned by the GGSN. The GGSN
> >> ensures the uniqueness of this Interface-Identifier. Then MT shall
> >> then enforce the use of this Interface-Identifier by the TE"
> >> 
> >> In other words, in the cellular network, GGSN determines whether to
> >> reply to the Router Solicitation message of UE by identifying the
> >> low 64bits of UE interface's ipv6 link-local address.
> >> 
> >> When using a new kernel and RAWIP, kernel will generate an EUI64
> >> format ipv6 link-local address, and if the device uses this address
> >> to send RS, GGSN will not reply RA message.
> >> 
> >> Therefore, in that background, we came up with PUREIP to make kernel
> >> doesn't generate a ipv6 link-local address in any address generate
> >> mode.
> > 
> > Thanks for the better description.  That should go into the changelog
> > text somewhere so that others know what is going on here with this new
> > option.
> >
> 
> Does changelog mean adding these details to the commit message ?

Yes please.

> > And are these user-visable flags documented in a man page or something
> > else somewhere?  If not, how does userspace know about them?
> > 
> 
> There are mappings of these device types value in the libc:
> "/bionic/libc/kernel/uapi/linux/if_arp.h".
> userspace can get it from here.

Yes, they will show up in a libc definition, but where is it documented
in text form what the flag does?

thanks,

greg k-h
