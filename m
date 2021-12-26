Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041C047F95F
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhLZW2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:28:50 -0500
Received: from lan.nucleusys.com ([92.247.61.126]:46628 "EHLO
        mail.nucleusys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhLZW2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 17:28:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HI+Qf9u7F/q40qW9UU+ahm2dRDMyORav6QQuDyhvlDo=; b=YERA0znYLwZ+YqRXtqBukRXgSn
        UdL+D96otXFApuTDrCY7R9xzYg1IjpEEBow0w8Cy8ptSLuY+YpaVAsckiQhTq9cmdPFHs4bYBWSxw
        NotjFn3JkisJnVUPeLS/wXAD/uP1m447ZpzjWa/kgapddjT1vR/ZVUyBHqspAg5T2eH8=;
Received: from 78-83-68-78.spectrumnet.bg ([78.83.68.78] helo=karbon.k.g)
        by mail.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1n1c0R-001c58-4v; Mon, 27 Dec 2021 00:28:44 +0200
Date:   Mon, 27 Dec 2021 00:28:42 +0200
From:   Petko Manolov <petkan@nucleusys.com>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
Message-ID: <YcjsmvZdFsbBLDYK@karbon.k.g>
Mail-Followup-To: Matthias-Christian Ott <ott@mirix.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211226132930.7220-1-ott@mirix.org>
 <YciMrJBDk6bA5+Nv@lunn.ch>
 <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zztop",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-12-26 17:01:24, Matthias-Christian Ott wrote: > On 26/12/2021
    16:39, Andrew Lunn wrote: > > On Sun, Dec 26, 2021 at 02:29:30PM +0100, Matthias-Christian
    Ott wrote: > >> The D-Link DSB-650TX (200 [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
  0.0 TVD_RCVD_IP            Message was received from an IP address
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-12-26 17:01:24, Matthias-Christian Ott wrote:
> On 26/12/2021 16:39, Andrew Lunn wrote:
> > On Sun, Dec 26, 2021 at 02:29:30PM +0100, Matthias-Christian Ott wrote:
> >> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames that
> >> are longer than 1518 octets, for example, Ethernet frames that contain
> >> 802.1Q VLAN tags.
> >>
> >> The frames are sent to the pegasus driver via USB but the driver discards
> >> them because they have the Long_pkt field set to 1 in the received status
> >> report. The function read_bulk_callback of the pegasus driver treats such
> >> received "packets" (in the terminology of the hardware) as errors but the
> >> field simply does just indicate that the Ethernet frame (MAC destination to
> >> FCS) is longer than 1518 octets.
> >>
> >> It seems that in the 1990s there was a distinction between "giant" (> 1518)
> >> and "runt" (< 64) frames and the hardware includes flags to indicate this
> >> distinction. It seems that the purpose of the distinction "giant" frames
> >> was to not allow infinitely long frames due to transmission errors and to
> >> allow hardware to have an upper limit of the frame size. However, the
> >> hardware already has such limit with its 2048 octet receive buffer and,
> >> therefore, Long_pkt is merely a convention and should not be treated as a
> >> receive error.
> >>
> >> Actually, the hardware is even able to receive Ethernet frames with 2048
> >> octets which exceeds the claimed limit frame size limit of the driver of
> >> 1536 octets (PEGASUS_MTU).
> >>
> >> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
> >> ---
> >>  drivers/net/usb/pegasus.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> >> index 140d11ae6688..2582daf23015 100644
> >> --- a/drivers/net/usb/pegasus.c
> >> +++ b/drivers/net/usb/pegasus.c
> >> @@ -499,11 +499,11 @@ static void read_bulk_callback(struct urb *urb)
> >>  		goto goon;
> >>  
> >>  	rx_status = buf[count - 2];
> >> -	if (rx_status & 0x1e) {
> >> +	if (rx_status & 0x1c) {
> >>  		netif_dbg(pegasus, rx_err, net,
> >>  			  "RX packet error %x\n", rx_status);
> >>  		net->stats.rx_errors++;
> >> -		if (rx_status & 0x06)	/* long or runt	*/
> >> +		if (rx_status & 0x04)	/* runt	*/
> > 
> > I've nothing against this patch, but if you are working on the driver, it
> > would be nice to replace these hex numbers with #defines using BIT, or
> > FIELD. It will make the code more readable.
> 
> Replacing the constants with macros is on my list of things that I want to do.
> In this case, I did not do it because I wanted to a have small patch that gets
> easily accepted and allows me to figure out the current process to submit
> patches after years of inactivity.

To be honest, that's due to the fact the original code was submitted more than
20 years ago, when the driver acceptance criteria were a lot more relaxed than
they are now.  Ideally, these constants should be replaced with human readable
macros, something which i never got around doing.

If you are in the mood, you could send two patch series, one that fixes the
constants and another that fixes the packet size bug.  As is often the case, one
of them may get mainlined right away, while the other is being debated for a
while.


cheers,
Petko
