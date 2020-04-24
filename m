Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61961B820B
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 00:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgDXW3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 18:29:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59681 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXW3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 18:29:46 -0400
Received: from Cyrus.lan ([80.189.87.161]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.163]) with ESMTPA (Nemesis) id
 1MIyiY-1jlHZZ34UE-00KSAw; Sat, 25 Apr 2020 00:29:39 +0200
Date:   Fri, 24 Apr 2020 23:29:38 +0100
From:   Darren Stevens <darren@stevens-zone.net>
To:     madalin.bacur@nxp.com, netdev@vger.kernel.org
Cc:     oss@buserror.net, chzigotzky@xenosoft.de,
        linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
Message-ID: <20200424232938.1a85d353@Cyrus.lan>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; powerpc-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:/BZt50zNv9G906G9ocwyBjQ0Zm7jz6707yp6I7hCFQP0H2xPe50
 i+WqNCC/IMSdkxn1rB/MXN+DmFqzerlaKe/T+aYwQ6+g6QQVg8COQdAcKpKy5jq2PbVM5eD
 AHTcNBhNf4LxJ8woGO1scFAK3AbPL6g2FgNuV1CF7HVl6pyesjyO1bDu/TlVV8tKL3gQnYC
 0AJnUzPNZ9QCNFJsaMfWQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tbmuuh/q0bs=:c+VUHSub+5M70yCAIOHORb
 DiO/gmmocwkPydIr3xGMtncPbQ+TrPSMKb4v2F9Q/advOHtVhLR9+bF0xnH9C9/CEluIO4Fpm
 z3u2Yiifyxe8Aw4M0p2ex3abApjri3oo9JZSfba48aLIaGfPInsUS+o17nN+tkNryot1nmHmH
 Ig+9SLMqvKhEZNsPqcIvJ7I3Es58fLT57uspq7YZiBS2hcK96IsSiaMJjJ/Z5Z39Pmx7GGhk1
 NHQw3LI4OdkG9EV35f0ERQ3H4Btwf79ZY0GL2pAu40NjSCyeao513bc9EDvx6RIvMGPcYc6LB
 1I3mTL769QYl7QcEoWJ58R1K9T2jP9pdmiH3jIbcf6xaGWh8bXBUVKe36/fmaB/cbyCv4UUfI
 h+3l/YEzifUb9c5TF1OYxOxKpyHRiHQgs6Hi+krQ7MHC8dMUYiqms9p9aCZVdhluMXr2b3L7v
 0tNrVu/QmUXZnwwCBUJxGMmlss4aMe2x26aKxqcnuL2BJ/Soom5ySKFfwtFdkT1YutY3hFceh
 O4GfdTb+iKkabD9cNaOwx/tjbgtEh644Dp9dgfuAIFRB+SF9Emoxuy8Ud+1H5MJyUjX/pIwtC
 XoRqsgFtEsUTje6eryUyFbwenQJq819Ir+BcBw6yRYILv7ZZnJym5zj97X/vdhq050FiShUqq
 RP7+3HUJVG1HHYp1QyIlZhT2WrzP9/Btolino3JDJt2EFfX5DI3qLQH5v2eT1a9rvuEJkHWE+
 lhWTRqJMyYy22aWaWWCDjjBRae3QAdVNtmqyoj3T/8pBnfWFExyp9r/DRvn57y2en7RbK/TtG
 DfI+KnG3YHY9HKtzBQizNiZ3JsIk3yKTMg+7Ci6SE43KI/0QJ9tPenPBzSXKADqgiPPdogi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since cbb961ca271e ("Use random MAC address when none is given")
Varisys Cyrus P5020 boards have been listing 5 ethernet ports instead of
the 2 the board has.This is because we were preventing the adding of the
unused ports by not suppling them a MAC address, which this patch now
supplies.

Prevent them from appearing in the net devices list by checking for a
'status="disabled"' entry during probe and skipping the port if we find
it. 

Signed-off-by: Darren Stevens <Darren@stevens-zone.net>

---

 drivers/net/ethernet/freescale/fman/mac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 43427c5..c9ed411 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -606,6 +606,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct resource		 res;
 	struct mac_priv_s	*priv;
 	const u8		*mac_addr;
+	const char 		*prop;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -628,6 +629,16 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->priv = priv;
 	priv->dev = dev;
 
+	/* check for disabled devices and skip them, as now a missing
+	 * MAC address will be replaced with a Random one rather than
+	 * disabling the port
+	 */
+	prop = of_get_property(mac_node, "status", NULL);
+	if (prop && !strncmp(prop, "disabled", 8) {
+		err = -ENODEV;
+		goto _return
+	}
+
 	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
 		setup_dtsec(mac_dev);
 		priv->internal_phy_node = of_parse_phandle(mac_node,
