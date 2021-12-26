Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCFE47F835
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 17:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhLZQZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 11:25:07 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:46564 "EHLO
        mail.nucleusys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhLZQZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 11:25:07 -0500
X-Greylist: delayed 1335 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Dec 2021 11:25:06 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BqoF6YmajCOcmtPAa/sWQfS/yAhq10wHNsmBgrksCTo=; b=WS+k3vvtnc1l6VtkC43CQd3ua4
        plDGbWckaKwKiyi+AHy+tstvTJWsomuwex91PeWgvdYxJybteSJh12VOl2bpyySqFqSafaz5RvAJa
        7O6NUwJ4cJforE1gg8peTSXHkM+XMTmIP8F5GoKtGR/GAVulhzYCX+NaJjYEwoWbfXI0=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=karbon.k.g)
        by mail.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1n1Vyw-001bsb-BI; Sun, 26 Dec 2021 18:02:48 +0200
Date:   Sun, 26 Dec 2021 18:02:45 +0200
From:   Petko Manolov <petkan@nucleusys.com>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Request Ethernet FCS from hardware
Message-ID: <YciSJYMgyHtvyPc6@karbon.k.g>
References: <20211226132502.7056-1-ott@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226132502.7056-1-ott@mirix.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zztop",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-12-26 14:25:02, Matthias-Christian Ott wrote: > Commit
    1a8deec09d12 ("pegasus: fixes reported packet length") tried to > configure
    the hardware to not include the FCS/CRC of Ethernet frames. > U [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-12-26 14:25:02, Matthias-Christian Ott wrote:
> Commit 1a8deec09d12 ("pegasus: fixes reported packet length") tried to
> configure the hardware to not include the FCS/CRC of Ethernet frames.
> Unfortunately, this does not work with the D-Link DSB-650TX (USB IDs
> 2001:4002 and 2001:400b): the transferred "packets" (in the terminology
> of the hardware) still contain 4 additional octets. For IP packets in
> Ethernet this is not a problem as IP packets contain their own lengths
> fields but other protocols also see Ethernet frames that include the FCS
> in the payload which might be a problem for some protocols.
> 
> I was not able to open the D-Link DSB-650TX as the case is a very tight
> press fit and opening it would likely destroy it. However, according to
> the source code the earlier revision of the D-Link DSB-650TX (USB ID
> 2001:4002) is a Pegasus (possibly AN986) and not Pegasus II (AN8511)
> device. I also tried it with the later revision of the D-Link DSB-650TX
> (USB ID 2001:400b) which is a Pegasus II device according to the source
> code and had the same results. Therefore, I'm not sure whether the RXCS
> (rx_crc_sent) field of the EC0 (Ethernet control_0) register has any
> effect or in which revision of the hardware it is usable and has an
> effect. As a result, it seems best to me to revert commit
> 1a8deec09d12 ("pegasus: fixes reported packet length") and to set the
> RXCS (rx_crc_sent) field of the EC0 (Ethernet control_0) register so
> that the FCS/CRC is always included.
> 
> Fixes: 1a8deec09d12 ("pegasus: fixes reported packet length")
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> ---
>  drivers/net/usb/pegasus.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index c4cd40b090fd..140d11ae6688 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -422,7 +422,13 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>  	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
>  	if (ret < 0)
>  		goto fail;
> -	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
> +	/* At least two hardware revisions of the D-Link DSB-650TX (USB IDs
> +	 * 2001:4002 and 2001:400b) include the Ethernet FCS in the packets,
> +	 * even if RXCS is set to 0 in the EC0 register and the hardware is
> +	 * instructed to not include the Ethernet FCS in the packet.Therefore,
> +	 * it seems best to set RXCS to 1 and later ignore the Ethernet FCS.
> +	 */
> +	data[0] = 0xc9; /* TX & RX enable, append status, CRC */
>  	data[1] = 0;
>  	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
>  		data[1] |= 0x20;	/* set full duplex */
> @@ -513,6 +519,13 @@ static void read_bulk_callback(struct urb *urb)
>  		pkt_len = buf[count - 3] << 8;
>  		pkt_len += buf[count - 4];
>  		pkt_len &= 0xfff;
> +		/* The FCS at the end of the packet is ignored. So subtract
> +		 * its length to ignore it.
> +		 */
> +		pkt_len -= ETH_FCS_LEN;
> +		/* Subtract the length of the received status at the end of the
> +		 * packet as it is not part of the Ethernet frame.
> +		 */
>  		pkt_len -= 4;
>  	}

Nice catch.  However, changing these constants for all devices isn't such a good
idea.  I'd rather use vendor and device IDs to distinguish these two cases in
the above code.


cheers,
Petko
