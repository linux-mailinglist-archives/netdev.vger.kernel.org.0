Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14B7DBA15
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441726AbfJQXPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 19:15:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:43186 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438437AbfJQXPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 19:15:30 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9HNEmef019088;
        Thu, 17 Oct 2019 18:14:49 -0500
Message-ID: <071cf1eeefcbfc14633a13bc2d15ad7392987a88.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Date:   Fri, 18 Oct 2019 10:14:47 +1100
In-Reply-To: <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
         <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
         <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-17 at 22:01 +0000, Vijay Khemka wrote:
> 
> ﻿On 10/16/19, 6:29 PM, "Benjamin Herrenschmidt" <benh@kernel.crashing.org> wrote:
> 
>     On Fri, 2019-10-11 at 14:30 -0700, Vijay Khemka wrote:
>     > HW checksum generation is not working for AST2500, specially with
>     > IPV6
>     > over NCSI. All TCP packets with IPv6 get dropped. By disabling this
>     > it works perfectly fine with IPV6. As it works for IPV4 so enabled
>     > hw checksum back for IPV4.
>     > 
>     > Verified with IPV6 enabled and can do ssh.
>     
>     So while this probably works, I don't think this is the right
>     approach, at least according to the comments in skbuff.h
> 
> This is not a matter of unsupported csum, it is broken hw csum. 
> That's why we disable hw checksum. My guess is once we disable
> Hw checksum, it will use sw checksum. So I am just disabling hw 
> Checksum.

I don't understand what you are saying. You reported a problem with
IPV6 checksums generation. The HW doesn't support it. What's "not a
matter of unsupported csum" ?

Your patch uses a *deprecated* bit to tell the network stack to only do
HW checksum generation on IPV4.

This bit is deprecated for a reason, again, see skbuff.h. The right
approach, *which the driver already does*, is to tell the stack that we
support HW checksuming using NETIF_F_HW_CSUM, and then, in the transmit
handler, to call skb_checksum_help() to have the SW calculate the
checksum if it's not a supported type.

This is exactly what ftgmac100_prep_tx_csum() does. It only enables HW
checksum generation on supported types and uses skb_checksum_help()
otherwise, supported types being protocol ETH_P_IP and IP protocol
being raw IP, TCP and UDP.

So this *should* have fallen back to SW for IPV6. So either something
in my code there is making an incorrect assumption, or something is
broken in skb_checksum_help() for IPV6 (which I somewhat doubt) or
something else I can't think of, but setting a *deprecated* flag is
definitely not the right answer, neither is completely disabling HW
checksumming.

So can you investigate what's going on a bit more closely please ? I
can try myself, though I have very little experience with IPV6 and
probably won't have time before next week.

Cheers,
Ben.

>     The driver should have handled unsupported csum via SW fallback
>     already in ftgmac100_prep_tx_csum()
>     
>     Can you check why this didn't work for you ?
>     
>     Cheers,
>     Ben.
>     
>     > Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
>     > ---
>     > Changes since v1:
>     >  Enabled IPV4 hw checksum generation as it works for IPV4.
>     > 
>     >  drivers/net/ethernet/faraday/ftgmac100.c | 13 ++++++++++++-
>     >  1 file changed, 12 insertions(+), 1 deletion(-)
>     > 
>     > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
>     > b/drivers/net/ethernet/faraday/ftgmac100.c
>     > index 030fed65393e..0255a28d2958 100644
>     > --- a/drivers/net/ethernet/faraday/ftgmac100.c
>     > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>     > @@ -1842,8 +1842,19 @@ static int ftgmac100_probe(struct
>     > platform_device *pdev)
>     >  	/* AST2400  doesn't have working HW checksum generation */
>     >  	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
>     >  		netdev->hw_features &= ~NETIF_F_HW_CSUM;
>     > +
>     > +	/* AST2500 doesn't have working HW checksum generation for IPV6
>     > +	 * but it works for IPV4, so disabling hw checksum and enabling
>     > +	 * it for only IPV4.
>     > +	 */
>     > +	if (np && (of_device_is_compatible(np, "aspeed,ast2500-mac")))
>     > {
>     > +		netdev->hw_features &= ~NETIF_F_HW_CSUM;
>     > +		netdev->hw_features |= NETIF_F_IP_CSUM;
>     > +	}
>     > +
>     >  	if (np && of_get_property(np, "no-hw-checksum", NULL))
>     > -		netdev->hw_features &= ~(NETIF_F_HW_CSUM |
>     > NETIF_F_RXCSUM);
>     > +		netdev->hw_features &= ~(NETIF_F_HW_CSUM |
>     > NETIF_F_RXCSUM
>     > +					 | NETIF_F_IP_CSUM);
>     >  	netdev->features |= netdev->hw_features;
>     >  
>     >  	/* register network device */
>     
>     
> 

