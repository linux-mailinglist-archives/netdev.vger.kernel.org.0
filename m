Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7579147F938
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhLZWMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:12:22 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:46614 "EHLO
        mail.nucleusys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhLZWMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 17:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZVILQFOWbf1ty394RkPM2Kcc0SxzHvUAy/b09bHffYw=; b=UhId7hOrmdk89E+dXHI/rERY0a
        P0k/+3b6Kt3/XkCXdgTbm/lCm2UtzANPx5WT5LUHq5u1ItV+a1LTiYSQ8P/Z6R0zyKAQHNWjGGL6A
        NuThmqanXd+z/gvVTNvmewF3ymZOvx9adpjdFq0FoUHpK4txKvp7NZVGxHR1s6IDMT7I=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=karbon.k.g)
        by mail.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1n1bkW-001c4H-8l; Mon, 27 Dec 2021 00:12:18 +0200
Date:   Mon, 27 Dec 2021 00:12:15 +0200
From:   Petko Manolov <petkan@nucleusys.com>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Request Ethernet FCS from hardware
Message-ID: <Ycjov4ulEM3HqV/9@karbon.k.g>
Mail-Followup-To: Matthias-Christian Ott <ott@mirix.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226132502.7056-1-ott@mirix.org>
 <YciSJYMgyHtvyPc6@karbon.k.g>
 <6029432c-5f85-b727-ed90-dca1a52b3775@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6029432c-5f85-b727-ed90-dca1a52b3775@mirix.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zztop",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-12-26 17:12:24, Matthias-Christian Ott wrote: > On 26/12/2021
    17:02, Petko Manolov wrote: > > On 21-12-26 14:25:02, Matthias-Christian
   Ott wrote: > >> Commit 1a8deec09d12 ("pegasus: fixes report [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-12-26 17:12:24, Matthias-Christian Ott wrote:
> On 26/12/2021 17:02, Petko Manolov wrote:
> > On 21-12-26 14:25:02, Matthias-Christian Ott wrote:
> >> Commit 1a8deec09d12 ("pegasus: fixes reported packet length") tried to
> >> configure the hardware to not include the FCS/CRC of Ethernet frames.
> >> Unfortunately, this does not work with the D-Link DSB-650TX (USB IDs
> >> 2001:4002 and 2001:400b): the transferred "packets" (in the terminology
> >> of the hardware) still contain 4 additional octets. For IP packets in
> >> Ethernet this is not a problem as IP packets contain their own lengths
> >> fields but other protocols also see Ethernet frames that include the FCS
> >> in the payload which might be a problem for some protocols.
> >>
> >> I was not able to open the D-Link DSB-650TX as the case is a very tight
> >> press fit and opening it would likely destroy it. However, according to
> >> the source code the earlier revision of the D-Link DSB-650TX (USB ID
> >> 2001:4002) is a Pegasus (possibly AN986) and not Pegasus II (AN8511)
> >> device. I also tried it with the later revision of the D-Link DSB-650TX
> >> (USB ID 2001:400b) which is a Pegasus II device according to the source
> >> code and had the same results. Therefore, I'm not sure whether the RXCS
> >> (rx_crc_sent) field of the EC0 (Ethernet control_0) register has any
> >> effect or in which revision of the hardware it is usable and has an
> >> effect. As a result, it seems best to me to revert commit
> >> 1a8deec09d12 ("pegasus: fixes reported packet length") and to set the
> >> RXCS (rx_crc_sent) field of the EC0 (Ethernet control_0) register so
> >> that the FCS/CRC is always included.
> >>
> >> Fixes: 1a8deec09d12 ("pegasus: fixes reported packet length")
> >> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> >> ---
> >>  drivers/net/usb/pegasus.c | 15 ++++++++++++++-
> >>  1 file changed, 14 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> >> index c4cd40b090fd..140d11ae6688 100644
> >> --- a/drivers/net/usb/pegasus.c
> >> +++ b/drivers/net/usb/pegasus.c
> >> @@ -422,7 +422,13 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> >>  	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
> >>  	if (ret < 0)
> >>  		goto fail;
> >> -	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
> >> +	/* At least two hardware revisions of the D-Link DSB-650TX (USB IDs
> >> +	 * 2001:4002 and 2001:400b) include the Ethernet FCS in the packets,
> >> +	 * even if RXCS is set to 0 in the EC0 register and the hardware is
> >> +	 * instructed to not include the Ethernet FCS in the packet.Therefore,
> >> +	 * it seems best to set RXCS to 1 and later ignore the Ethernet FCS.
> >> +	 */
> >> +	data[0] = 0xc9; /* TX & RX enable, append status, CRC */
> >>  	data[1] = 0;
> >>  	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
> >>  		data[1] |= 0x20;	/* set full duplex */
> >> @@ -513,6 +519,13 @@ static void read_bulk_callback(struct urb *urb)
> >>  		pkt_len = buf[count - 3] << 8;
> >>  		pkt_len += buf[count - 4];
> >>  		pkt_len &= 0xfff;
> >> +		/* The FCS at the end of the packet is ignored. So subtract
> >> +		 * its length to ignore it.
> >> +		 */
> >> +		pkt_len -= ETH_FCS_LEN;
> >> +		/* Subtract the length of the received status at the end of the
> >> +		 * packet as it is not part of the Ethernet frame.
> >> +		 */
> >>  		pkt_len -= 4;
> >>  	}
> > 
> > Nice catch.  However, changing these constants for all devices isn't such a
> > good idea.  I'd rather use vendor and device IDs to distinguish these two
> > cases in the above code.
> 
> I don't think that it would hurt to include the FCS for all devices. I only
> have the datasheets for the ADM8511/X and the ADM8513 but it seems that all
> devices that are supported by the driver also include the RXCS field in EC0.
> This was also the previous behaviour before commit 1a8deec09d12 and seemed to
> have worked. It also only adds four octet that have to be transferred and it
> seems to avoid exceptions for different devices which seems to be a good idea,
> in particular, because it is not easy to acquire all of the supported devices
> as they are no longer sold or manufactured.

The fix that commit 1a8deec09d12 introduces is real (the commit message makes
sense) and i don't feel confident to revert it so lightly.  I think i have all
relevant datasheets somewhere, along with a couple of old "pegasus I" devices,
which i could use for testing. Not at home right now, the aforementioned testing
will have to wait a couple of days.

> That being said, if you are going to veto this change otherwise, I can of
> course just add the FCS back for the two USB IDs, even though it likely
> affects other devices as well.

Like i said, i don't want to hurry up and revert something that looks like a
valid fix.  Especially after five years worth of kernel releases and no
complaints related to 1a8deec09d12.  This should mean two things: a) the driver
isn't used anymore, or b) this commit fixes a real problem.

However, if it turn out that your fix is the right one, it goes in without fuss.
So lets see what it is...


cheers,
Petko
