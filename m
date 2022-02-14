Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929F24B574F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346197AbiBNQof convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Feb 2022 11:44:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiBNQoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:44:34 -0500
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879FB4DF73
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:44:25 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id BFB9E15360
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:44:22 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id ABA1D219C0A; Mon, 14 Feb 2022 16:44:22 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     netdev@vger.kernel.org
Subject: DSA using cpsw and lan9303
Date:   Mon, 14 Feb 2022 16:44:22 +0000
Message-ID: <yw1x8rud4cux.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware I'm working on has a LAN9303 switch connected to the
Ethernet port of an AM335x (ZCE package).  In trying to make DSA work
with this combination, I have encountered two problems.

Firstly, the cpsw driver configures the hardware to filter out frames
with unknown VLAN tags.  To make it accept the tagged frames coming from
the LAN9303, I had to modify the latter driver like this:

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 2de67708bbd2..460c998c0c33 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1078,20 +1079,28 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
                               struct phy_device *phy)
 {
        struct lan9303 *chip = ds->priv;
+       struct net_device *master;
 
        if (!dsa_is_user_port(ds, port))
                return 0;
 
+       master = dsa_to_port(chip->ds, 0)->master;
+       vlan_vid_add(master, htons(ETH_P_8021Q), port);
+
        return lan9303_enable_processing_port(chip, port);
 }
 
Secondly, the cpsw driver strips VLAN tags from incoming frames, and
this prevents the DSA parsing from working.  As a dirty workaround, I
did this:

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 424e644724e4..e15f42ece8bf 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -235,6 +235,7 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
 
        /* Remove VLAN header encapsulation word */
        skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
+       return;
 
        pkt_type = (rx_vlan_encap_hdr >>
                    CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &

With these changes, everything seems to work as expected.

Now I'd appreciate if someone could tell me how I should have done this.
Please don't make me send an actual patch.

-- 
Måns Rullgård
