Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F7E2B8B02
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgKSF3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:29:13 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:59468 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgKSF3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 00:29:13 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4Cc7X511J9z41q6;
        Thu, 19 Nov 2020 06:29:09 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cc7Wr39GZz2xGP;
        Thu, 19 Nov 2020 06:28:56 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 06:28:19 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Jacob Keller <jacob.e.keller@intel.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net-next v2 3/3] ptp: ptp_ines: use new PTP_MSGTYPE_* define(s)
Date:   Thu, 19 Nov 2020 06:28:00 +0100
Message-ID: <5337022.CNZMXmNBYT@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <5809d8e0-4848-004c-1551-691cd8bfbd67@intel.com>
References: <20201118162203.24293-1-ceggers@arri.de> <20201118162203.24293-4-ceggers@arri.de> <5809d8e0-4848-004c-1551-691cd8bfbd67@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201119-062858-4Cc7Wr39GZz2xGP-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, 18 November 2020, 22:03:56 CET, Jacob Keller wrote:
> On 11/18/2020 8:22 AM, Christian Eggers wrote:
> > Remove driver internal defines for this.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Cc: Kurt Kanzenbach <kurt@linutronix.de>
> > ---
> > 
> >  drivers/ptp/ptp_ines.c | 19 +++++++------------
> >  1 file changed, 7 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
> > index 4700ffbdfced..6c7c2843ba0b 100644
> > --- a/drivers/ptp/ptp_ines.c
> > +++ b/drivers/ptp/ptp_ines.c
> > @@ -108,11 +108,6 @@ MODULE_LICENSE("GPL");
> > 
> >  #define MESSAGE_TYPE_P_DELAY_RESP	3
> >  #define MESSAGE_TYPE_DELAY_REQ		4
> > 
> > -#define SYNC				0x0
> > -#define DELAY_REQ			0x1
> > -#define PDELAY_REQ			0x2
> > -#define PDELAY_RESP			0x3
> > -
> > 
> >  static LIST_HEAD(ines_clocks);
> >  static DEFINE_MUTEX(ines_clocks_lock);
> > 
> > @@ -683,9 +678,9 @@ static bool is_sync_pdelay_resp(struct sk_buff *skb,
> > int type)> 
> >  	msgtype = ptp_get_msgtype(hdr, type);
> > 
> > -	switch ((msgtype & 0xf)) {
> > -	case SYNC:
> > -	case PDELAY_RESP:
> > +	switch (msgtype) {
> > +	case PTP_MSGTYPE_SYNC:
> 
> > +	case PTP_MSGTYPE_PDELAY_RESP:
> This has a functional change of no longer discarding the higher bits of
> msgtype. While this may be correct, I think it should at least be called
> out as to why in the commit message.

The "& 0xf" is already done within ptp_get_msgtype(). I will add this to the
commit description for the next series.

regards
Christian



