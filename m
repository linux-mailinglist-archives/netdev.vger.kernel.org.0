Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4615BF8B
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgBMNiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:38:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgBMNiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 08:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qWFSpCylMGQmY/IGBMUJ9w6UE5CnelrSWu4xDJdh0pA=; b=vx3ZPYZM8idczLfWeHtaqAdkq
        /vyBO7pwVn6RcoQwFr+lR9RQkVtyNTL8Na6xRL10QJHssFIK1RlNqobtrVeG3C01TIVmd3Ll0Gj+u
        pN1tywsnV82MsFJdqOp9klj40NW5s1eOPPM8EB26JzzMObR22EcHkkqOOLsj0a5wZ2S7BXl/4EK32
        7YYyEJclLkVav8ZWTBJaH5SNkVPn2ALqqIRTjbn/wzKaSUgE0VvbJbjUEy/RXyAxWz1KlrUAshVTW
        sbjLYSywzRzNgMnBzHo4mFx2YJyNNrxDiPo+FYLuvyswJkb9bG0Ocy26tUVSuNDueUNDbagBz3LE9
        eUMYwKGZg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47306)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2EhT-0000rw-1H; Thu, 13 Feb 2020 13:38:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2EhL-0002P7-RA; Thu, 13 Feb 2020 13:38:31 +0000
Date:   Thu, 13 Feb 2020 13:38:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Heads up: phylink changes for next merge window
Message-ID: <20200213133831.GM25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

During the next round of development changes, I wish to make some
changes to phylink which will affect almost every user out there,
as it affects the interfaces to the MAC drivers.

The reason behind the change is to allow us to support situations
where the MAC is not closely coupled with its associated PCS, such
as is found in mvneta and mvpp2.  This is necessary to support
already existing hardware properly, such as Marvell DSA and Xilinx
AXI ethernet drivers, and there seems to be a growing need for this.

What I'm proposing to do is to move the MAC setup for the negotiated
speed, duplex and pause settings to the mac_link_up() method, out of
the existing mac_config() method.  I have already converted the
axienet, dpaa2-mac, macb, mvneta, mvpp2 and mv88e6xxx (dsa) drivers,
but I'm not able to test all those.  Thus far, I've tested dpaa2-mac,
mvneta, and mv88e6xxx.  There's a bunch of other drivers that I don't
know enough about the hardware to do the conversion myself.

The other benefit this has is that mac_config() called with
SPEED_UNKNOWN and DUPLEX_UNKNOWN has been a pain point for some;
mac_link_up() should never be called with speed or duplex set to these
- if it is, something is wrong with phylib or the mac_pcs_get_state()
implementation.  Hence, this pain point should be gone with this
proposal.

Once net-next has opened, and when the pre-requisit patches have been
reviewed, I'll post the series that includes these conversions.

The queued work can be found in my "phy" branch, viewable at:

  http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=phy

which I maintain as a re-sortable queue of pending patches; it is
based on v5.5 but I track most commits that impact on the pending
patches through a merge window.  Essentially, "net: phylink: allow
in-band AN for USXGMII" and preceding patches are in 5.6-rc1.

The initial plan will be to send:

- Batch 1:
   net: linkmode: make linkmode_test_bit() take const pointer
   net: add helpers to resolve negotiated flow control
   net: add linkmode helper for setting flow control advertisement
   net: phylink: remove pause mode ethtool setting for fixed links
   net: phylink: ensure manual flow control is selected appropriately
   net: phylink: use phylib resolved flow control modes
   net: phylink: resolve fixed link flow control
   net: phylink: allow ethtool -A to change flow control advertisement
   net: phylink: improve initial mac configuration
   net: phylink: clarify flow control settings in documentation
- Batch 2:
   net: phy: marvell10g: read copper results from CSSR1
   net: phy: marvell: don't interpret PHY status unless resolved
   net: phy: add resolved pause support
   net: phy: marvell*: add support for hw resolved pause modes
- Maybe some others from there, and then a series which starts the ball
  rollong on this:
   net: mii: convert mii_lpa_to_ethtool_lpa_x() to linkmode variant
   net: mii: add linkmode_adv_to_mii_adv_x()
   net: phylink: propagate resolved link config via mac_link_up()
   net: dsa: propagate resolved link config via mac_link_up()
   net: mv88e6xxx: use resolved link config in mac_link_up()
   net: axienet: use resolved link config in mac_link_up()
   net: dpaa2-mac: use resolved link config in mac_link_up()
   net: macb: use resolved link config in mac_link_up()
   net: mvneta: use resolved link config in mac_link_up()
   net: mvpp2: use resolved link config in mac_link_up()

When all drivers have been converted, I propose to make phylink stop
calling mac_config() just before a link-up event for the MLO_AN_PHY
and MLO_AN_FIXED cases, unless a major reconfiguration of the MAC is
required (e.g. the PHY_INTERFACE_MODE has changed.)  Hence why all
existing drivers will need to be converted before this step.

I have a Coccinelle script that finds unconverted drivers, which I've
attached, runnable with:

spatch -D report --very-quiet --sp-file phylink-config.cocci drivers/net

The script will warn about the use of deprecated phylink_link_state
members, and error about use of ->link which has never been guaranteed
to be correct (there are code paths where it is definitely not correct,
particularly through the ethtool code paths, so it's use by drivers is
already buggy - bcm_sf2 seems to be the only user.)

I'm considering adding this coccinelle script to scripts/coccinelle so
that 0-day can catch any future inappropriate uses, although I would
like to eventually revise mac_config() sometime in the future so that it's
not possible for this to happen in the first place.

The remaining files are:

drivers/net/dsa/b53/b53_common.c
drivers/net/dsa/bcm_sf2.c
drivers/net/dsa/mt7530.c
drivers/net/dsa/sja1105/sja1105_main.c
drivers/net/ethernet/mediatek/mtk_eth_soc.c
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="phylink-config.cocci"

// spatch -D report --very-quiet --sp-file phylink-link.cocci \
//    drivers/net/ethernet net/dsa

virtual report

@ ops @
identifier I, func;
@@
(
  struct phylink_mac_ops I = { 
  	.mac_config = func,
  };
|
  struct dsa_switch_ops I = {
  	.phylink_mac_config = func,
  };
)

@ mac_config_link @
identifier ops.func, S;
position p;
@@
  func(..., const struct phylink_link_state *S)
  {
  ... when exists
    S->link @p
  ... when exists
  }

@ mac_config_spd_dpx @
identifier ops.func, S;
identifier member =~ "^(speed|duplex)$";
position p;
@@
  func(..., const struct phylink_link_state *S)
  {
  ... when exists
    S->member @p
  ... when exists
  }

@ mac_config_pause @
identifier ops.func, S;
identifier mask =~ "^MLO_PAUSE_(TX|RX|TXRX_MASK)$";
position p;
@@
  func(..., const struct phylink_link_state *S)
  {
  ... when exists
    S->pause & mask @p
  ... when exists
  }


@ script:python depends on report @
func << ops.func;
pos << mac_config_spd_dpx.p;
var << mac_config_spd_dpx.S;
memb << mac_config_spd_dpx.member;
@@
coccilib.report.print_report(pos[0],
	"WARNING: use of %s->%s in %s is deprecated" % (var, memb, func))

@ script:python depends on report @
func << ops.func;
pos << mac_config_pause.p;
var << mac_config_pause.S;
mask << mac_config_pause.mask;
@@
coccilib.report.print_report(pos[0],
	"WARNING: use of %s->pause %s flag in %s is deprecated" % (var, mask, func))

@ script:python depends on report @
func << ops.func;
pos << mac_config_link.p;
var << mac_config_link.S;
@@
coccilib.report.print_report(pos[0],
	"ERROR: use of %s->link in %s is unreliable and should never be used" % (var, func))

--DiL7RhKs8rK9YGuF--
