Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2123B26C9
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 07:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFXFbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 01:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhFXFbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 01:31:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA203613E1;
        Thu, 24 Jun 2021 05:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624512545;
        bh=CrNTDEASE0hOIuPiLp9bEqtZG5PdJqBwgm5EWk5Moa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dgkCqd8aSzCz5aPuT31Q+mRsU5exsL1ljJgUFfQi1UaKhFhMNgCPbvd2piVCS2QJD
         /TxeTOJJI+Kz76WmLScOvrnbQGQPgwft+l+HDUb1zXiHT/iJve3J8w26JMyoe/lt2L
         8W1qbhYXfcSDiKszMprXGq2cKMnjyHpJGXMVFcyI=
Date:   Thu, 24 Jun 2021 07:29:01 +0200
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
Message-ID: <YNQYHfE09Dx5kWyg@kroah.com>
References: <YNNtN3cdDL71SiNt@kroah.com>
 <20210624033353.25636-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624033353.25636-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:33:53AM +0800, Rocco Yue wrote:
> On Wed, 2021-06-23 at 19:19 +0200, Greg KH wrote:
> On Wed, Jun 23, 2021 at 07:34:49PM +0800, Rocco Yue wrote:
> >> This patch add the definition of ARPHRD_PUREIP which can for
> >> example be used by mobile ccmni device as device type.
> >> ARPHRD_PUREIP means that this device doesn't need kernel to
> >> generate ipv6 link-local address in any addr_gen_mode.
> >> 
> >> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> >> ---
> >>  include/uapi/linux/if_arp.h | 1 +
> >>  1 file changed, 1 insertion(+)
> >> 
> >> diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
> >> index c3cc5a9e5eaf..4463c9e9e8b4 100644
> >> --- a/include/uapi/linux/if_arp.h
> >> +++ b/include/uapi/linux/if_arp.h
> >> @@ -61,6 +61,7 @@
> >>  #define ARPHRD_DDCMP    517		/* Digital's DDCMP protocol     */
> >>  #define ARPHRD_RAWHDLC	518		/* Raw HDLC			*/
> >>  #define ARPHRD_RAWIP    519		/* Raw IP                       */
> >> +#define ARPHRD_PUREIP	520		/* Pure IP			*/
> > 
> > In looking at the patches, what differs "PUREIP" from "RAWIP"?  It seems
> 
> Thanks for your review.
> 
> The difference between RAWIP and PUREIP is that they generate IPv6
> link-local address and IPv6 global address in different ways.
> 
> RAWIP:
> ~~~~~~
> In the ipv6_generate_eui64() function, using RAWIP will always return 0,
> which will cause the kernel to automatically generate an IPv6 link-local
> address in EUI64 format and an IPv6 global address in EUI64 format.
> 
> PUREIP:
> ~~~~~~~
> After this patch set, when using PUREIP, kernel doesn't generate IPv6
> link-local address regardless of which IN6_ADDR_GEN_MODE is used.
> 
> @@  static void addrconf_dev_config(struct net_device *dev)
> +       if (dev->type == ARPHRD_PUREIP)
> +               return;
> 
> And after recving RA message, kernel iterates over the link-local address
> that exists for the interface and uses the low 64bits of the link-local
> address to generate the IPv6 global address.
> The general process is as follows:
> ndisc_router_discovery() -> addrconf_prefix_rcv() -> ipv6_generate_eui64() -> ipv6_inherit_eui64()

Thanks for the explaination, why is this hardware somehow "special" in
this way that this has never been needed before?

thanks,

greg k-h
