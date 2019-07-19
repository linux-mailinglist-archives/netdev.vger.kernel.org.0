Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0426D925
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 04:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfGSCkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 22:40:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfGSCkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 22:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vy3RMdEhwTMYHA1sUcTKGGV44fIglKcfIU22XM7k9Es=; b=fhXAuZHu87sBV62Fd1SaWs7Mte
        qdEn55wQtjaGw4Le2U+lTkvs6gKUce69TmIUkeldzjD+vuCkWfGpttHkpBNiTDWcnkAi0Ox5q4haN
        i34k86+D4UoUJfxqW+bX1NPbNPuXdcQprPA5XcAg06DVRtkUPP6wMupgtMWXjOi9Gq54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoIof-0004uZ-AB; Fri, 19 Jul 2019 04:40:13 +0200
Date:   Fri, 19 Jul 2019 04:40:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190719024013.GC24765@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190709021426.GA5835@lunn.ch>
 <10c66ecf-6d67-d206-b496-6f8139f218a8@pensando.io>
 <20190718032814.GH6962@lunn.ch>
 <00a22345-4904-57b4-f40b-9ddd2e7398ec@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00a22345-4904-57b4-f40b-9ddd2e7398ec@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 05:12:07PM -0700, Shannon Nelson wrote:
> On 7/17/19 8:28 PM, Andrew Lunn wrote:
> >On Fri, Jul 12, 2019 at 10:16:31PM -0700, Shannon Nelson wrote:
> >>On 7/8/19 7:14 PM, Andrew Lunn wrote:
> >>>>+static int ionic_set_pauseparam(struct net_device *netdev,
> >>>>+				struct ethtool_pauseparam *pause)
> >>>>+{
> >>>>+	struct lif *lif = netdev_priv(netdev);
> >>>>+	struct ionic *ionic = lif->ionic;
> >>>>+	struct ionic_dev *idev = &lif->ionic->idev;
> >>>>+
> >>>>+	u32 requested_pause;
> >>>>+	u32 cur_autoneg;
> >>>>+	int err;
> >>>>+
> >>>>+	cur_autoneg = idev->port_info->config.an_enable ? AUTONEG_ENABLE :
> >>>>+								AUTONEG_DISABLE;
> >>>>+	if (pause->autoneg != cur_autoneg) {
> >>>>+		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
> >>>>+		return -EOPNOTSUPP;
> >>>>+	}
> >>>>+
> >>>>+	/* change both at the same time */
> >>>>+	requested_pause = PORT_PAUSE_TYPE_LINK;
> >>>>+	if (pause->rx_pause)
> >>>>+		requested_pause |= IONIC_PAUSE_F_RX;
> >>>>+	if (pause->tx_pause)
> >>>>+		requested_pause |= IONIC_PAUSE_F_TX;
> >>>>+
> >>>>+	if (requested_pause == idev->port_info->config.pause_type)
> >>>>+		return 0;
> >>>>+
> >>>>+	idev->port_info->config.pause_type = requested_pause;
> >>>>+
> >>>>+	mutex_lock(&ionic->dev_cmd_lock);
> >>>>+	ionic_dev_cmd_port_pause(idev, requested_pause);
> >>>>+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
> >>>>+	mutex_unlock(&ionic->dev_cmd_lock);
> >>>>+	if (err)
> >>>>+		return err;
> >>>Hi Shannon
> >>>
> >>>I've no idea what the firmware black box is doing, but this looks
> >>>wrong.
> >>>
> >>>pause->autoneg is about if the results of auto-neg should be used or
> >>>not. If false, just configure the MAC with the pause settings and you
> >>>are done. If the interface is being forced, so autoneg in general is
> >>>disabled, just configure the MAC and you are done.
> >>>
> >>>If pause->autoneg is true and the interface is using auto-neg as a
> >>>whole, you pass the pause values to the PHY for it to advertise and
> >>>trigger an auto-neg. Once autoneg has completed, and the resolved
> >>>settings are available, the MAC is configured with the resolved
> >>>values.
> >>>
> >>>Looking at this code, i don't see any difference between configuring
> >>>the MAC or configuring the PHY. I would expect pause->autoneg to be
> >>>part of requested_pause somehow, so the firmware knows what is should
> >>>do.
> >>>
> >>>	Andrew
> >>In this device there's actually very little the driver can do to directly
> >>configure the mac or phy besides passing through to the firmware what the
> >>user has requested - that happens here for the pause values, and in
> >>ionic_set_link_ksettings() for autoneg.  The firmware is managing the port
> >>based on these requests with the help of internally configured rules defined
> >>in a customer setting.
> >I get that. But the firmware needs to conform to what Linux
> >expects. And what i see here does not conform. That is why i gave a
> >bit of detail in my reply.
> >
> >What exactly does the firmware do? Once we know that, we can figure
> >out when the driver should return -EOPNOTSUPP because of firmware
> >limitations, and what it can configure and should return 0.
> 
> Because this is fairly smart FW, it handles this as expected.  I can add
> this as another comment in the code.

Hi Shannon

Looking at the code, i don't see how it can handle this
correctly. Please look at my comments, particularly the meaning of
pause->autoneg and describe how the firmware does the right thing,
given what information it is passed.

       Andrew
