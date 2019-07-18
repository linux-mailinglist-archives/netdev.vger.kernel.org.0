Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8356C723
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 05:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391403AbfGRDVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 23:21:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391108AbfGRDVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 23:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OLN2ssxBCi2lizosRARqkxg4FJwV5XL1VRdKvxZMwtI=; b=XSi6+rANtjY2xLgQwiZ6O3wERQ
        xzN1g2gJSam1Xn5NKXbgewSkTIlm6vmy9E2RJoTXvfr72v7zIXRv22wTvshVIcAN4uTho5va5hFwm
        LwIG5dmz4pclDxiZLxkBXZ+JxP0QBOzAIhKRHHiZfv6Jfqgl3ne4356s7xujBIF6Kzds=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hnwzB-0002xw-64; Thu, 18 Jul 2019 05:21:37 +0200
Date:   Thu, 18 Jul 2019 05:21:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190718032137.GG6962@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190709022703.GB5835@lunn.ch>
 <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <649f7e96-a76b-79f0-db25-d3ce57397df5@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:42:39PM -0700, Shannon Nelson wrote:
> On 7/8/19 7:27 PM, Andrew Lunn wrote:
> >>+static int ionic_get_module_eeprom(struct net_device *netdev,
> >>+				   struct ethtool_eeprom *ee,
> >>+				   u8 *data)
> >>+{
> >>+	struct lif *lif = netdev_priv(netdev);
> >>+	struct ionic_dev *idev = &lif->ionic->idev;
> >>+	struct xcvr_status *xcvr;
> >>+	u32 len;
> >>+
> >>+	/* copy the module bytes into data */
> >>+	xcvr = &idev->port_info->status.xcvr;
> >>+	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
> >>+	memcpy(data, xcvr->sprom, len);
> >Hi Shannon
> >
> >This also looks odd. Where is the call into the firmware to get the
> >eeprom contents? Even though it is called 'eeprom', the data is not
> >static. It contains real time diagnostic values, temperature, transmit
> >power, receiver power, voltages etc.
> 
> idev->port_info is a memory mapped space that the device keeps up-to-date.

Hi Shannon

It at least needs a comment. How frequently does the device update
this chunk of memory? It would be good to comment about that as
well. Or do MMIO reads block while i2c operations occur to update the
memory?

> >>+
> >>+	dev_dbg(&lif->netdev->dev, "notifyblock eid=0x%llx link_status=0x%x link_speed=0x%x link_down_cnt=0x%x\n",
> >>+		lif->info->status.eid,
> >>+		lif->info->status.link_status,
> >>+		lif->info->status.link_speed,
> >>+		lif->info->status.link_down_count);
> >>+	dev_dbg(&lif->netdev->dev, "  port_status id=0x%x status=0x%x speed=0x%x\n",
> >>+		idev->port_info->status.id,
> >>+		idev->port_info->status.status,
> >>+		idev->port_info->status.speed);
> >>+	dev_dbg(&lif->netdev->dev, "    xcvr status state=0x%x phy=0x%x pid=0x%x\n",
> >>+		xcvr->state, xcvr->phy, xcvr->pid);
> >>+	dev_dbg(&lif->netdev->dev, "  port_config state=0x%x speed=0x%x mtu=0x%x an_enable=0x%x fec_type=0x%x pause_type=0x%x loopback_mode=0x%x\n",
> >>+		idev->port_info->config.state,
> >>+		idev->port_info->config.speed,
> >>+		idev->port_info->config.mtu,
> >>+		idev->port_info->config.an_enable,
> >>+		idev->port_info->config.fec_type,
> >>+		idev->port_info->config.pause_type,
> >>+		idev->port_info->config.loopback_mode);
> >It is a funny place to have all the debug code.
> 
> Someone wanted a hook for getting some link info on the fly on request.

I would suggest deleting it all. Most of it is already available via
ethtool.

	Andrew
