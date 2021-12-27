Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA0A47FC1B
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhL0LLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:11:48 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:46730 "EHLO
        mail.nucleusys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhL0LLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cs08TYrM1R93Z2rRsqv28gVc3mSRm3OZZCgukFf8y9g=; b=GbRi0d1Aieexvbx6wvYXjzEHqZ
        HThxOFyXg/v8UbFMxVsWFcpsnHvdFC32x87GgyqAWN4AIGtMA3faewQTXb/8NikTbcB5wlXaBC8uB
        faHQxOBiiBrdDfSQ+N4C0/d/WLJUdZyBAa92lqfwLBhlFlXHcaSMSzeWaFmIkZ2924jY=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=karbon.k.g)
        by mail.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1n1nuo-001cPn-VF; Mon, 27 Dec 2021 13:11:44 +0200
Date:   Mon, 27 Dec 2021 13:11:41 +0200
From:   Petko Manolov <petkan@nucleusys.com>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet
 frames
Message-ID: <YcmfbX5o0XHn1Uhx@karbon.k.g>
References: <20211226221208.2583-1-ott@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226221208.2583-1-ott@mirix.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zztop",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-12-26 23:12:08, Matthias-Christian Ott wrote: > The
   D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames that are
    > longer than 1518 octets, for example, Ethernet frames that contai [...]
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-12-26 23:12:08, Matthias-Christian Ott wrote:
> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames that are
> longer than 1518 octets, for example, Ethernet frames that contain 802.1Q VLAN
> tags.
> 
> The frames are sent to the pegasus driver via USB but the driver discards them
> because they have the Long_pkt field set to 1 in the received status report.
> The function read_bulk_callback of the pegasus driver treats such received
> "packets" (in the terminology of the hardware) as errors but the field simply
> does just indicate that the Ethernet frame (MAC destination to FCS) is longer
> than 1518 octets.
> 
> It seems that in the 1990s there was a distinction between "giant" (> 1518)
> and "runt" (< 64) frames and the hardware includes flags to indicate this
> distinction. It seems that the purpose of the distinction "giant" frames was
> to not allow infinitely long frames due to transmission errors and to allow
> hardware to have an upper limit of the frame size. However, the hardware
> already has such limit with its 2048 octet receive buffer and, therefore,
> Long_pkt is merely a convention and should not be treated as a receive error.
> 
> Actually, the hardware is even able to receive Ethernet frames with 2048
> octets which exceeds the claimed limit frame size limit of the driver of 1536
> octets (PEGASUS_MTU).

2048 is not mentioned anywhere in both, adm8511 and adm8515 documents.  In the
latter I found 1638 as max packet length, but that's not the default.  The
default is 1528 and i don't feel like changing it without further investigation.

Thus, i assume it is safe to change PEGASUS_MTU to 1528 for the moment.  VLAN
frames have 4 additional bytes so we aren't breaking neither pegasus I nor
pegasus II devices.

If you're going to make ver 3 of this change, you might as well modify
PEGASUS_MTU in pegasus.h as a separate patch within the same series.


		Petko


> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> ---
> V1 -> V2: Included "Fixes:" tag
> 
>  drivers/net/usb/pegasus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 140d11ae6688..2582daf23015 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -499,11 +499,11 @@ static void read_bulk_callback(struct urb *urb)
>  		goto goon;
>  
>  	rx_status = buf[count - 2];
> -	if (rx_status & 0x1e) {
> +	if (rx_status & 0x1c) {
>  		netif_dbg(pegasus, rx_err, net,
>  			  "RX packet error %x\n", rx_status);
>  		net->stats.rx_errors++;
> -		if (rx_status & 0x06)	/* long or runt	*/
> +		if (rx_status & 0x04)	/* runt	*/
>  			net->stats.rx_length_errors++;
>  		if (rx_status & 0x08)
>  			net->stats.rx_crc_errors++;
> -- 
> 2.30.2
> 
> 
