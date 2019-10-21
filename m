Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE0FDE5F4
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 10:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfJUIJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 04:09:55 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50794 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfJUIJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 04:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0/4Bj8FGSPKXQQdqoqW4IO1yJqZdxsZ9TnmjOcnGYq8=; b=rUXjf348ZCVHvAyjk0tBPOMrU
        LjgkhQYAJyCaLPYM+RlXUvOPUG2yYm8vaM3cxV+YCGPHLP/5i/Wu9nJABhF6F1JIReGO+xbb8IRp3
        ttXmCEoY4udKTbRyzP+J7C00U2/6K57EMIQoW1Sm+LmEo0R2wOUtR0nzy95Y7cbmDrOiTeiMIxH2r
        h3PuQkCZNRtrnuOBd6AmtQBmYbW8VktIK2azFGbldTpumQTLxL12SpPzh86q+/R5zIKRMdxrch6aM
        /RtB/1IPw7I3M63o8qTkOnyhJRifnyqZnhVLzCiv+IeRRD/CFpSIXe7DlOdfWKsxwQ98wzrZY/4hF
        yL2rLjE0g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45474)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iMSl9-0007vP-QO; Mon, 21 Oct 2019 09:09:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iMSl6-0003Rp-V0; Mon, 21 Oct 2019 09:09:45 +0100
Date:   Mon, 21 Oct 2019 09:09:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
Message-ID: <20191021080944.GL25745@shell.armlinux.org.uk>
References: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
 <20191021074030.GB4486@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021074030.GB4486@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 09:40:31AM +0200, Simon Horman wrote:
> On Fri, Oct 18, 2019 at 09:31:13PM +0100, Russell King wrote:
> > From: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > A bitrate of 255 is special, it means the bitrate is encoded in
> > byte 66 in units of 250MBaud.  Add support for parsing these bit
> > rates.
> 
> Hi Russell,
> 
> it seems from the code either that 0 is also special or its
> handling has been optimised. Perhaps that would be worth mentioning
> in the changelog too.

The text of SFF8472 rev 12.2:

5.7     BR, nominal [Address A0h, Byte 12]
The nominal bit (signaling) rate (BR, nominal) is specified in units of
100MBd, rounded off to the nearest 100MBd. The bit rate includes those
bits necessary to encode and delimit the signal as well as those bits
carrying data information. A value of FFh indicates the bit rate is
greater than 25.0Gb/s and addresses 66 and 67 are used to determine
bit rate. A value of 0 indicates that the bit rate is not specified and
must be determined from the transceiver technology. The actual
information transfer rate will depend on the encoding of the data, as
defined by the encoding value.

8.4    BR, max [Address A0h, Byte 66]
If address 12 is not set to FFh, the upper bit rate limit at which the
transceiver will still meet its specifications (BR, max) is specified
in units of 1% above the nominal bit rate. If address 12 is set to FFh,
the nominal bit (signaling) rate (BR, nominal) is specified in units of
250 MBd, rounded off to the nearest 250 MBd. A value of 00h indicates
that this field is not specified.

8.5    BR, min [Address A0h, Byte 67]
If address 12 is not set to FFh, the lower bit rate limit at which the
transceiver will still meet its specifications (BR, min) is specified in
units of 1% below the nominal bit rate. If address 12 is set to FFh, the
limit range of bit rates specified in units of +/- 1% around the nominal
signaling rate. A value of zero indicates that this field is not
specified.

So I guess you could have a br_nom == 0 (meaning it should be derived
from other information) but max/min != 0 - which would be complex to
implement, and means that we're doing significant interpretation of
the contents.

> 
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  sfpid.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/sfpid.c b/sfpid.c
> > index a1753d3a535f..71f0939c6282 100644
> > --- a/sfpid.c
> > +++ b/sfpid.c
> > @@ -328,11 +328,24 @@ void sff8079_show_all(const __u8 *id)
> >  {
> >  	sff8079_show_identifier(id);
> >  	if (((id[0] == 0x02) || (id[0] == 0x03)) && (id[1] == 0x04)) {
> > +		unsigned int br_nom, br_min, br_max;
> > +
> > +		if (id[12] == 0) {
> > +			br_nom = br_min = br_max = 0;
> > +		} else if (id[12] == 255) {
> > +			br_nom = id[66] * 250;
> > +			br_max = id[67];
> > +			br_min = id[67];
> > +		} else {
> > +			br_nom = id[12] * 100;
> > +			br_max = id[66];
> > +			br_min = id[67];
> > +		}
> >  		sff8079_show_ext_identifier(id);
> >  		sff8079_show_connector(id);
> >  		sff8079_show_transceiver(id);
> >  		sff8079_show_encoding(id);
> > -		sff8079_show_value_with_unit(id, 12, "BR, Nominal", 100, "MBd");
> > +		printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
> >  		sff8079_show_rate_identifier(id);
> >  		sff8079_show_value_with_unit(id, 14,
> >  					     "Length (SMF,km)", 1, "km");
> > @@ -348,8 +361,8 @@ void sff8079_show_all(const __u8 *id)
> >  		sff8079_show_ascii(id, 40, 55, "Vendor PN");
> >  		sff8079_show_ascii(id, 56, 59, "Vendor rev");
> >  		sff8079_show_options(id);
> > -		sff8079_show_value_with_unit(id, 66, "BR margin, max", 1, "%");
> > -		sff8079_show_value_with_unit(id, 67, "BR margin, min", 1, "%");
> > +		printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
> > +		printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
> >  		sff8079_show_ascii(id, 68, 83, "Vendor SN");
> >  		sff8079_show_ascii(id, 84, 91, "Date code");
> >  	}
> > -- 
> > 2.7.4
> > 
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
