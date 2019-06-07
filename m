Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF72387E4
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 12:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfFGK0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 06:26:09 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59280 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfFGK0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 06:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F+cmx8U5n/8qEwqbQeTYX++kAzFG2c+MvGfMXR4iJU4=; b=AwB2SMaPuA4QDOmbhfNmisJqj
        1/UABtXOANTjtRgQMJGws2VS0U8lxCMQS8ZU+Tt2WdDlrxWJRmjzGT0R37HmQJGrc5uBNyaU42npg
        sH4UPEy3urwwGgAQyvgywfvRc9GT3PytJ60DSBLo72Zh7qviMpR/2xaZWIXIqyeHg384sfWqyTxwb
        0nbRbCpWHkOsIBmbrkOrGRZ27ZhxwXW744Hix+4V1abOD0TRSzjZaMM2CDBE0YxykrimsV1EGXCxs
        /4cfeZmBbxSP24GIsOT2wwtfyBwO/56T5kMORCpfq2Pa4A0B7IDkntnSht25c9blwqjxyBQaWg8pT
        7EXvfwWWw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56256)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hZC4T-0003bc-L4; Fri, 07 Jun 2019 11:26:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hZC4R-0004Ew-CM; Fri, 07 Jun 2019 11:26:03 +0100
Date:   Fri, 7 Jun 2019 11:26:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: sfp: Stop SFP polling and interrupt
 handling during shutdown
Message-ID: <20190607102603.4fp4v5pidkhjcygt@shell.armlinux.org.uk>
References: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
 <20190606180908.ctoxi7c4i2uothzn@shell.armlinux.org.uk>
 <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:57:22PM -0600, Robert Hancock wrote:
> It may also be helpful that the lock is now held for the subsequent code
> in sfp_check_state that's comparing the previous and new states - it
> seems like you could otherwise run into trouble if that function was
> being concurrently called from the polling thread and the interrupt
> handler (for example if you had an SFP where some GPIOs supported
> interrupts and some didn't).

That's a good point, one that we should address separately.  Rather
than re-using the existing mutex (which would be difficult to hold
across calling the state machine due to locking inversion) how about
this:

 drivers/net/phy/sfp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 8a21294d1ce8..5ff427dcbb31 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -190,6 +190,7 @@ struct sfp {
 	struct delayed_work poll;
 	struct delayed_work timeout;
 	struct mutex sm_mutex;
+	struct mutex st_mutex;
 	unsigned char sm_mod_state;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
@@ -1976,6 +1977,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -2001,6 +2003,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -2031,6 +2034,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
