Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9823B33B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 05:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgHDDXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 23:23:18 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:55292 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729631AbgHDDXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 23:23:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id CD136182CED28;
        Tue,  4 Aug 2020 03:23:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:69:355:379:800:960:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2194:2195:2196:2199:2200:2201:2393:2538:2553:2559:2562:2693:2729:2828:2902:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4225:4250:4321:4385:4605:5007:6117:6119:7576:7875:7903:7904:8603:8957:9036:9121:9163:9165:9592:10004:10848:10967:11026:11232:11233:11473:11657:11658:11914:12043:12050:12294:12296:12297:12438:12555:12679:12683:12731:12737:12740:12760:12895:12986:13132:13231:13439:14394:14659:14877:21067:21080:21433:21451:21611:21627:21740:21939:21984:21990:30003:30012:30029:30045:30046:30054:30062:30067:30069:30070:30075:30080:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: pen96_411579d26fa3
X-Filterd-Recvd-Size: 17797
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Tue,  4 Aug 2020 03:23:14 +0000 (UTC)
Message-ID: <9f98b7a2c4ce56b9702597eab1349eaa5f1753bb.camel@perches.com>
Subject: [PATCH V2] via-velocity: Use more typical logging styles
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     romieu@fr.zoreil.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 03 Aug 2020 20:23:13 -0700
In-Reply-To: <20200803.154248.2020214547846261577.davem@davemloft.net>
References: <e45d15ad36a0c9a994b5a1136c72518215c99f7a.camel@perches.com>
         <20200803.154248.2020214547846261577.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_<level> in place of VELOCITY_PRT.
Use pr_<level> in place of printk(KERN_<LEVEL>.

Miscellanea:

o Add pr_fmt to prefix pr_<level> output with "via-velocity: "
o Remove now unused functions and macros
o Realign some logging lines
o Remove devname where pr_<level> is also used

Signed-off-by: Joe Perches <joe@perches.com>
---

OK, here...

On Mon, 2020-08-03 at 15:42 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sat, 01 Aug 2020 08:51:03 -0700
> 
> > Link status is emitted on multiple lines as it does not use
> > KERN_CONT.
> > 
> > Coalesce the multi-part logging into a single line output and
> > add missing KERN_<LEVEL> to a couple logging calls.
> > 
> > This also reduces object size.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> The real problem is the whole VELOCITY_PRT() private debug log
> control business this driver is doing.
> 
> It should be using the standard netdev logging level infrastructure.
> 
> > +                     VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "set Velocity to forced full mode\n");
> 
> You can't tell me that this "KERN_INFO blah blah blah" is really
> something we should add more of these days, right?
> 
> If you're going to improve this driver's logging code please do
> so by having it use the standard interfaces.

> Thanks.

 drivers/net/ethernet/via/via-velocity.c | 163 +++++++++++++++++---------------
 drivers/net/ethernet/via/via-velocity.h |  44 ---------
 2 files changed, 85 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 713dbc04b25b..6d2a31488a74 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -32,6 +32,8 @@
  * MODULE_LICENSE("GPL");
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
@@ -80,7 +82,6 @@ enum velocity_bus_type {
 };
 
 static int velocity_nics;
-static int msglevel = MSG_LEVEL_INFO;
 
 static void velocity_set_power_state(struct velocity_info *vptr, char state)
 {
@@ -405,24 +406,22 @@ static const char *get_chip_name(enum chip_type chip_id)
  *	@max: highest value allowed
  *	@def: default value
  *	@name: property name
- *	@dev: device name
  *
  *	Set an integer property in the module options. This function does
  *	all the verification and checking as well as reporting so that
  *	we don't duplicate code for each option.
  */
 static void velocity_set_int_opt(int *opt, int val, int min, int max, int def,
-				 char *name, const char *devname)
+				 char *name)
 {
 	if (val == -1)
 		*opt = def;
 	else if (val < min || val > max) {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: the value of parameter %s is invalid, the valid range is (%d-%d)\n",
-					devname, name, min, max);
+		pr_notice("the value of parameter %s is invalid, the valid range is (%d-%d)\n",
+			  name, min, max);
 		*opt = def;
 	} else {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "%s: set value of parameter %s to %d\n",
-					devname, name, val);
+		pr_info("set value of parameter %s to %d\n", name, val);
 		*opt = val;
 	}
 }
@@ -434,25 +433,24 @@ static void velocity_set_int_opt(int *opt, int val, int min, int max, int def,
  *	@def: default value (yes/no)
  *	@flag: numeric value to set for true.
  *	@name: property name
- *	@dev: device name
  *
  *	Set a boolean property in the module options. This function does
  *	all the verification and checking as well as reporting so that
  *	we don't duplicate code for each option.
  */
 static void velocity_set_bool_opt(u32 *opt, int val, int def, u32 flag,
-				  char *name, const char *devname)
+				  char *name)
 {
 	(*opt) &= (~flag);
 	if (val == -1)
 		*opt |= (def ? flag : 0);
 	else if (val < 0 || val > 1) {
-		printk(KERN_NOTICE "%s: the value of parameter %s is invalid, the valid range is (0-1)\n",
-			devname, name);
+		pr_notice("the value of parameter %s is invalid, the valid range is (%d-%d)\n",
+			  name, 0, 1);
 		*opt |= (def ? flag : 0);
 	} else {
-		printk(KERN_INFO "%s: set parameter %s to %s\n",
-			devname, name, val ? "TRUE" : "FALSE");
+		pr_info("set parameter %s to %s\n",
+			name, val ? "TRUE" : "FALSE");
 		*opt |= (val ? flag : 0);
 	}
 }
@@ -461,24 +459,38 @@ static void velocity_set_bool_opt(u32 *opt, int val, int def, u32 flag,
  *	velocity_get_options	-	set options on device
  *	@opts: option structure for the device
  *	@index: index of option to use in module options array
- *	@devname: device name
  *
  *	Turn the module and command options into a single structure
  *	for the current device
  */
-static void velocity_get_options(struct velocity_opt *opts, int index,
-				 const char *devname)
-{
-
-	velocity_set_int_opt(&opts->rx_thresh, rx_thresh[index], RX_THRESH_MIN, RX_THRESH_MAX, RX_THRESH_DEF, "rx_thresh", devname);
-	velocity_set_int_opt(&opts->DMA_length, DMA_length[index], DMA_LENGTH_MIN, DMA_LENGTH_MAX, DMA_LENGTH_DEF, "DMA_length", devname);
-	velocity_set_int_opt(&opts->numrx, RxDescriptors[index], RX_DESC_MIN, RX_DESC_MAX, RX_DESC_DEF, "RxDescriptors", devname);
-	velocity_set_int_opt(&opts->numtx, TxDescriptors[index], TX_DESC_MIN, TX_DESC_MAX, TX_DESC_DEF, "TxDescriptors", devname);
-
-	velocity_set_int_opt(&opts->flow_cntl, flow_control[index], FLOW_CNTL_MIN, FLOW_CNTL_MAX, FLOW_CNTL_DEF, "flow_control", devname);
-	velocity_set_bool_opt(&opts->flags, IP_byte_align[index], IP_ALIG_DEF, VELOCITY_FLAGS_IP_ALIGN, "IP_byte_align", devname);
-	velocity_set_int_opt((int *) &opts->spd_dpx, speed_duplex[index], MED_LNK_MIN, MED_LNK_MAX, MED_LNK_DEF, "Media link mode", devname);
-	velocity_set_int_opt(&opts->wol_opts, wol_opts[index], WOL_OPT_MIN, WOL_OPT_MAX, WOL_OPT_DEF, "Wake On Lan options", devname);
+static void velocity_get_options(struct velocity_opt *opts, int index)
+{
+
+	velocity_set_int_opt(&opts->rx_thresh, rx_thresh[index],
+			     RX_THRESH_MIN, RX_THRESH_MAX, RX_THRESH_DEF,
+			     "rx_thresh");
+	velocity_set_int_opt(&opts->DMA_length, DMA_length[index],
+			     DMA_LENGTH_MIN, DMA_LENGTH_MAX, DMA_LENGTH_DEF,
+			     "DMA_length");
+	velocity_set_int_opt(&opts->numrx, RxDescriptors[index],
+			     RX_DESC_MIN, RX_DESC_MAX, RX_DESC_DEF,
+			     "RxDescriptors");
+	velocity_set_int_opt(&opts->numtx, TxDescriptors[index],
+			     TX_DESC_MIN, TX_DESC_MAX, TX_DESC_DEF,
+			     "TxDescriptors");
+
+	velocity_set_int_opt(&opts->flow_cntl, flow_control[index],
+			     FLOW_CNTL_MIN, FLOW_CNTL_MAX, FLOW_CNTL_DEF,
+			     "flow_control");
+	velocity_set_bool_opt(&opts->flags, IP_byte_align[index],
+			      IP_ALIG_DEF, VELOCITY_FLAGS_IP_ALIGN,
+			      "IP_byte_align");
+	velocity_set_int_opt((int *) &opts->spd_dpx, speed_duplex[index],
+			     MED_LNK_MIN, MED_LNK_MAX, MED_LNK_DEF,
+			     "Media link mode");
+	velocity_set_int_opt(&opts->wol_opts, wol_opts[index],
+			     WOL_OPT_MIN, WOL_OPT_MAX, WOL_OPT_DEF,
+			     "Wake On Lan options");
 	opts->numrx = (opts->numrx & ~3);
 }
 
@@ -880,7 +892,7 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 	       (mii_status==curr_status)) {
 	   vptr->mii_status=mii_check_media_mode(vptr->mac_regs);
 	   vptr->mii_status=check_connection_type(vptr->mac_regs);
-	   VELOCITY_PRT(MSG_LEVEL_INFO, "Velocity link no change\n");
+	   netdev_info(vptr->netdev, "Velocity link no change\n");
 	   return 0;
 	   }
 	 */
@@ -892,7 +904,7 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 	 *	If connection type is AUTO
 	 */
 	if (mii_status & VELOCITY_AUTONEG_ENABLE) {
-		VELOCITY_PRT(MSG_LEVEL_INFO, "Velocity is AUTO mode\n");
+		netdev_info(vptr->netdev, "Velocity is in AUTO mode\n");
 		/* clear force MAC mode bit */
 		BYTE_REG_BITS_OFF(CHIPGCR_FCMODE, &regs->CHIPGCR);
 		/* set duplex mode of MAC according to duplex mode of MII */
@@ -927,12 +939,14 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 		if (mii_status & VELOCITY_DUPLEX_FULL) {
 			CHIPGCR |= CHIPGCR_FCFDX;
 			writeb(CHIPGCR, &regs->CHIPGCR);
-			VELOCITY_PRT(MSG_LEVEL_INFO, "set Velocity to forced full mode\n");
+			netdev_info(vptr->netdev,
+				    "set Velocity to forced full mode\n");
 			if (vptr->rev_id < REV_ID_VT3216_A0)
 				BYTE_REG_BITS_OFF(TCR_TB2BDIS, &regs->TCR);
 		} else {
 			CHIPGCR &= ~CHIPGCR_FCFDX;
-			VELOCITY_PRT(MSG_LEVEL_INFO, "set Velocity to forced half mode\n");
+			netdev_info(vptr->netdev,
+				    "set Velocity to forced half mode\n");
 			writeb(CHIPGCR, &regs->CHIPGCR);
 			if (vptr->rev_id < REV_ID_VT3216_A0)
 				BYTE_REG_BITS_ON(TCR_TB2BDIS, &regs->TCR);
@@ -985,45 +999,61 @@ static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
  */
 static void velocity_print_link_status(struct velocity_info *vptr)
 {
+	const char *link;
+	const char *speed;
+	const char *duplex;
 
 	if (vptr->mii_status & VELOCITY_LINK_FAIL) {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: failed to detect cable link\n", vptr->netdev->name);
-	} else if (vptr->options.spd_dpx == SPD_DPX_AUTO) {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: Link auto-negotiation", vptr->netdev->name);
+		netdev_notice(vptr->netdev, "failed to detect cable link\n");
+		return;
+	}
+
+	if (vptr->options.spd_dpx == SPD_DPX_AUTO) {
+		link = "auto-negotiation";
 
 		if (vptr->mii_status & VELOCITY_SPEED_1000)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 1000M bps");
+			speed = "1000";
 		else if (vptr->mii_status & VELOCITY_SPEED_100)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps");
+			speed = "100";
 		else
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps");
+			speed = "10";
 
 		if (vptr->mii_status & VELOCITY_DUPLEX_FULL)
-			VELOCITY_PRT(MSG_LEVEL_INFO, " full duplex\n");
+			duplex = "full";
 		else
-			VELOCITY_PRT(MSG_LEVEL_INFO, " half duplex\n");
+			duplex = "half";
 	} else {
-		VELOCITY_PRT(MSG_LEVEL_INFO, KERN_NOTICE "%s: Link forced", vptr->netdev->name);
+		link = "forced";
+
 		switch (vptr->options.spd_dpx) {
 		case SPD_DPX_1000_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 1000M bps full duplex\n");
+			speed = "1000";
+			duplex = "full";
 			break;
 		case SPD_DPX_100_HALF:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps half duplex\n");
+			speed = "100";
+			duplex = "half";
 			break;
 		case SPD_DPX_100_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 100M bps full duplex\n");
+			speed = "100";
+			duplex = "full";
 			break;
 		case SPD_DPX_10_HALF:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps half duplex\n");
+			speed = "10";
+			duplex = "half";
 			break;
 		case SPD_DPX_10_FULL:
-			VELOCITY_PRT(MSG_LEVEL_INFO, " speed 10M bps full duplex\n");
+			speed = "10";
+			duplex = "full";
 			break;
 		default:
+			speed = "unknown";
+			duplex = "unknown";
 			break;
 		}
 	}
+	netdev_notice(vptr->netdev, "Link %s speed %sM bps %s duplex\n",
+		      link, speed, duplex);
 }
 
 /**
@@ -1621,8 +1651,7 @@ static int velocity_init_rd_ring(struct velocity_info *vptr)
 	velocity_init_rx_ring_indexes(vptr);
 
 	if (velocity_rx_refill(vptr) != vptr->options.numrx) {
-		VELOCITY_PRT(MSG_LEVEL_ERR, KERN_ERR
-			"%s: failed to allocate RX buffer.\n", vptr->netdev->name);
+		netdev_err(vptr->netdev, "failed to allocate RX buffer\n");
 		velocity_free_rd_ring(vptr);
 		goto out;
 	}
@@ -1805,7 +1834,8 @@ static void velocity_error(struct velocity_info *vptr, int status)
 	if (status & ISR_TXSTLI) {
 		struct mac_regs __iomem *regs = vptr->mac_regs;
 
-		printk(KERN_ERR "TD structure error TDindex=%hx\n", readw(&regs->TDIdx[0]));
+		netdev_err(vptr->netdev, "TD structure error TDindex=%hx\n",
+			   readw(&regs->TDIdx[0]));
 		BYTE_REG_BITS_ON(TXESR_TDSTR, &regs->TXESR);
 		writew(TRDCSR_RUN, &regs->TDCSRClr);
 		netif_stop_queue(vptr->netdev);
@@ -2036,7 +2066,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 
 	if (unlikely(rd->rdesc0.RSR & (RSR_STP | RSR_EDP | RSR_RL))) {
 		if (rd->rdesc0.RSR & (RSR_STP | RSR_EDP))
-			VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame spans multiple RDs.\n", vptr->netdev->name);
+			netdev_err(vptr->netdev, "received frame spans multiple RDs\n");
 		stats->rx_length_errors++;
 		return -EINVAL;
 	}
@@ -2721,11 +2751,8 @@ static int velocity_get_platform_info(struct velocity_info *vptr)
  */
 static void velocity_print_info(struct velocity_info *vptr)
 {
-	struct net_device *dev = vptr->netdev;
-
-	printk(KERN_INFO "%s: %s\n", dev->name, get_chip_name(vptr->chip_id));
-	printk(KERN_INFO "%s: Ethernet Address: %pM\n",
-		dev->name, dev->dev_addr);
+	netdev_info(vptr->netdev, "%s - Ethernet Address: %pM\n",
+		    get_chip_name(vptr->chip_id), vptr->netdev->dev_addr);
 }
 
 static u32 velocity_get_link(struct net_device *dev)
@@ -2748,10 +2775,8 @@ static int velocity_probe(struct device *dev, int irq,
 			   const struct velocity_info_tbl *info,
 			   enum velocity_bus_type bustype)
 {
-	static int first = 1;
 	struct net_device *netdev;
 	int i;
-	const char *drv_string;
 	struct velocity_info *vptr;
 	struct mac_regs __iomem *regs;
 	int ret = -ENOMEM;
@@ -2773,13 +2798,9 @@ static int velocity_probe(struct device *dev, int irq,
 	SET_NETDEV_DEV(netdev, dev);
 	vptr = netdev_priv(netdev);
 
-	if (first) {
-		printk(KERN_INFO "%s Ver. %s\n",
-			VELOCITY_FULL_DRV_NAM, VELOCITY_VERSION);
-		printk(KERN_INFO "Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.\n");
-		printk(KERN_INFO "Copyright (c) 2004 Red Hat Inc.\n");
-		first = 0;
-	}
+	pr_info_once("%s Ver. %s\n", VELOCITY_FULL_DRV_NAM, VELOCITY_VERSION);
+	pr_info_once("Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.\n");
+	pr_info_once("Copyright (c) 2004 Red Hat Inc.\n");
 
 	netdev->irq = irq;
 	vptr->netdev = netdev;
@@ -2815,9 +2836,7 @@ static int velocity_probe(struct device *dev, int irq,
 		netdev->dev_addr[i] = readb(&regs->PAR[i]);
 
 
-	drv_string = dev_driver_string(dev);
-
-	velocity_get_options(&vptr->options, velocity_nics, drv_string);
+	velocity_get_options(&vptr->options, velocity_nics);
 
 	/*
 	 *	Mask out the options cannot be set to the chip
@@ -3469,16 +3488,6 @@ static int velocity_ethtool_set_wol(struct net_device *dev, struct ethtool_wolin
 	return 0;
 }
 
-static u32 velocity_get_msglevel(struct net_device *dev)
-{
-	return msglevel;
-}
-
-static void velocity_set_msglevel(struct net_device *dev, u32 value)
-{
-	 msglevel = value;
-}
-
 static int get_pending_timer_val(int val)
 {
 	int mult_bits = val >> 6;
@@ -3653,8 +3662,6 @@ static const struct ethtool_ops velocity_ethtool_ops = {
 	.get_drvinfo		= velocity_get_drvinfo,
 	.get_wol		= velocity_ethtool_get_wol,
 	.set_wol		= velocity_ethtool_set_wol,
-	.get_msglevel		= velocity_get_msglevel,
-	.set_msglevel		= velocity_set_msglevel,
 	.get_link		= velocity_get_link,
 	.get_strings		= velocity_get_strings,
 	.get_sset_count		= velocity_get_sset_count,
diff --git a/drivers/net/ethernet/via/via-velocity.h b/drivers/net/ethernet/via/via-velocity.h
index f196e71d2c04..d3f960cc7c6e 100644
--- a/drivers/net/ethernet/via/via-velocity.h
+++ b/drivers/net/ethernet/via/via-velocity.h
@@ -1286,50 +1286,6 @@ struct velocity_context {
     velocity_mii_read((p),MII_PHYSID1,((u16 *) &id)+1);\
     (id);})
 
-/*
- * Inline debug routine
- */
-
-
-enum velocity_msg_level {
-	MSG_LEVEL_ERR = 0,	//Errors that will cause abnormal operation.
-	MSG_LEVEL_NOTICE = 1,	//Some errors need users to be notified.
-	MSG_LEVEL_INFO = 2,	//Normal message.
-	MSG_LEVEL_VERBOSE = 3,	//Will report all trival errors.
-	MSG_LEVEL_DEBUG = 4	//Only for debug purpose.
-};
-
-#ifdef VELOCITY_DEBUG
-#define ASSERT(x) { \
-	if (!(x)) { \
-		printk(KERN_ERR "assertion %s failed: file %s line %d\n", #x,\
-			__func__, __LINE__);\
-		BUG(); \
-	}\
-}
-#define VELOCITY_DBG(p,args...) printk(p, ##args)
-#else
-#define ASSERT(x)
-#define VELOCITY_DBG(x)
-#endif
-
-#define VELOCITY_PRT(l, p, args...) do {if (l<=msglevel) printk( p ,##args);} while (0)
-
-#define VELOCITY_PRT_CAMMASK(p,t) {\
-	int i;\
-	if ((t)==VELOCITY_MULTICAST_CAM) {\
-        	for (i=0;i<(MCAM_SIZE/8);i++)\
-			printk("%02X",(p)->mCAMmask[i]);\
-	}\
-	else {\
-		for (i=0;i<(VCAM_SIZE/8);i++)\
-			printk("%02X",(p)->vCAMmask[i]);\
-	}\
-	printk("\n");\
-}
-
-
-
 #define     VELOCITY_WOL_MAGIC             0x00000000UL
 #define     VELOCITY_WOL_PHY               0x00000001UL
 #define     VELOCITY_WOL_ARP               0x00000002UL


