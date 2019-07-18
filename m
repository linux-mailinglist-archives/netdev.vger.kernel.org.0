Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAA76D2C2
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfGRR2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:28:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbfGRR2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 13:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ROZvNkyx08i9Y29CgpPCBA8kNmjXwd8YUEojmJ6Pkjo=; b=TDDJhHTzoY4LBTJdlxprgjXBD9
        bJZ3cvZx0J2L6yqRRGUL41k6cmVvspp5AmZyjaEJIK4z0I8HRuOzOhpNLqd5GuMeBFWnvYIiQkk51
        fG2iaCehjJ5tLwWvQoYiLV+e3bh4hbJx+QsW1AV+32ree8GSG14SBrchUU954mX0/l/Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoACd-0000Fm-Rs; Thu, 18 Jul 2019 19:28:23 +0200
Date:   Thu, 18 Jul 2019 19:28:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190718172823.GH25635@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190709022703.GB5835@lunn.ch>
 <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
 <20190718032137.GG6962@lunn.ch>
 <35761cbb-aa2d-d698-7368-6ebe25607fe0@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35761cbb-aa2d-d698-7368-6ebe25607fe0@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:05:23AM -0700, Shannon Nelson wrote:
> On 7/17/19 8:21 PM, Andrew Lunn wrote:
> >On Tue, Jul 09, 2019 at 03:42:39PM -0700, Shannon Nelson wrote:
> >>On 7/8/19 7:27 PM, Andrew Lunn wrote:
> >>>>+static int ionic_get_module_eeprom(struct net_device *netdev,
> >>>>+				   struct ethtool_eeprom *ee,
> >>>>+				   u8 *data)
> >>>>+{
> >>>>+	struct lif *lif = netdev_priv(netdev);
> >>>>+	struct ionic_dev *idev = &lif->ionic->idev;
> >>>>+	struct xcvr_status *xcvr;
> >>>>+	u32 len;
> >>>>+
> >>>>+	/* copy the module bytes into data */
> >>>>+	xcvr = &idev->port_info->status.xcvr;
> >>>>+	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> >>>>+	memcpy(data, xcvr->sprom, len);
> >>>Hi Shannon
> >>>
> >>>This also looks odd. Where is the call into the firmware to get the
> >>>eeprom contents? Even though it is called 'eeprom', the data is not
> >>>static. It contains real time diagnostic values, temperature, transmit
> >>>power, receiver power, voltages etc.
> >>idev->port_info is a memory mapped space that the device keeps up-to-date.
> >Hi Shannon
> >
> >It at least needs a comment. How frequently does the device update
> >this chunk of memory? It would be good to comment about that as
> >well. Or do MMIO reads block while i2c operations occur to update the
> >memory?
> 
> The device keeps this updated when changes happen internally so that there
> is no need to block on MMIO read. 

Hi Shannon

I'm thinking about the diagnostic page. RX and TX power, temperature,
alarms etc. These are real time values, so you should read them on
demand, or at last only cache them for a short time.

	Andrew
