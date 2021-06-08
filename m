Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156AA3A05A5
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhFHVYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhFHVYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:24:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466A9C061574;
        Tue,  8 Jun 2021 14:22:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z26so16714645pfj.5;
        Tue, 08 Jun 2021 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQwh626zfM0U1fcFtkvnbbFBBL2HeKYCTc8Ov3QqP4A=;
        b=aO5hFuRGR1anoQtTg6g+Xh4RC5Ct7CDwYxsSrcax/gaL+kw8x4qfCrYu2dTZaqpYVi
         NPBX2NDoYvFj3gQ/b4CNsTg+Qr2eo+HY3IMqp0Bu3NnHuQpnXm4diChYCMJM6ELLHuvD
         CuwojhVjtdpQ8ImzmwDob1rcEu+B03DRd2navJ+1mPlI71wCO8VKAa0U9tK5ettU2d3l
         IrgqtTvIDMNI/IMVBuSYLy9vrJdu113KMlSYn6b/k5Wfl05gFprAfYJEVH3FJUc5q+YJ
         NJ6n6cWAsAAObUhmOhbQgFegtC7MJtHIIZ4ru7QQt4fd6DM4t5IFGP9/KdF8rSC6De92
         z0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQwh626zfM0U1fcFtkvnbbFBBL2HeKYCTc8Ov3QqP4A=;
        b=a0gZCLFQVY1WxKWFfD0fvc/W92gLMSUEjEpSYbMNVr4skZLpgzhVbZhTsLKoESUMo9
         69yoyr4H8PrzqPt3Vfv2AheO2/94JvkA8aLillIsrSBZCQQwLZsh4ncQstVRCEzJBDkM
         +fMryvp/24NTvDUDl1EGkOEjfryyxrBKp3FRy35ChirB/2UWXeypd6xxF/zILG8yYuck
         Cc4oBsUp0Vjt0/7W4Yg3AhoUqceLnZVYT6LstPI8VetOU7c3j9cUucAaB2+NR2mHYUk8
         T2n2lBgP7ypYb+af5TRfkWaWR+a1RJy86pmSfGwWKK6vFEcIR7zo3tf49fZPexX0ptEo
         kPQg==
X-Gm-Message-State: AOAM531q63rVJmMAIMvan0HuiqDA8GvDuo/TPu5bVq9Ty23mNnxtjzFE
        +gA3Z9hGy0EBzHj6yCdCytj/W5+/25k=
X-Google-Smtp-Source: ABdhPJw4BDJrjghMKA8M/gtB5RjOfdHfw9xvPCslbUEKdnh7UPbmGKhwWkELmfVnmQHgNcFVM8jW3w==
X-Received: by 2002:a63:b507:: with SMTP id y7mr242354pge.74.1623187334332;
        Tue, 08 Jun 2021 14:22:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g4sm12526696pgu.46.2021.06.08.14.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:22:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mnhagan88@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always tagged
Date:   Tue,  8 Jun 2021 14:22:04 -0700
Message-Id: <20210608212204.3978634-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
VLANs") forced the CPU port to be always tagged in any VLAN membership.
This was necessary back then because we did not support Broadcom tags
for all configurations so the only way to differentiate tagged and
untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
port into being always tagged.

With most configurations enabling Broadcom tags, especially after
8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
families") we do not need to apply this unconditional force tagging of
the CPU port in all VLANs.

A helper function is introduced to faciliate the encapsulation of the
specific condition requiring the CPU port to be tagged in all VLANs and
the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
dsa_switch_ops::setup is called when we have already determined the
tagging protocol we will be using.

Reported-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- properly deal with DSA_TAG_PROTO_NONE so we continue to support
  that mode on older chips like 5325 and 5365 until they gain Broadcom
  tag support

 drivers/net/dsa/b53/b53_common.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..6e199454e41d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1084,6 +1084,11 @@ static int b53_setup(struct dsa_switch *ds)
 	unsigned int port;
 	int ret;
 
+	/* Request bridge PVID untagged when DSA_TAG_PROTO_NONE is set
+	 * which forces the CPU port to be tagged in all VLANs.
+	 */
+	ds->untag_bridge_pvid = dev->tag_protocol == DSA_TAG_PROTO_NONE;
+
 	ret = b53_reset_switch(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
@@ -1455,6 +1460,13 @@ static int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static bool b53_vlan_port_needs_forced_tagged(struct dsa_switch *ds, int port)
+{
+	struct b53_device *dev = ds->priv;
+
+	return dev->tag_protocol == DSA_TAG_PROTO_NONE && dsa_is_cpu_port(ds, port);
+}
+
 int b53_vlan_add(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan,
 		 struct netlink_ext_ack *extack)
@@ -1477,7 +1489,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 		untagged = true;
 
 	vl->members |= BIT(port);
-	if (untagged && !dsa_is_cpu_port(ds, port))
+	if (untagged && !b53_vlan_port_needs_forced_tagged(ds, port))
 		vl->untag |= BIT(port);
 	else
 		vl->untag &= ~BIT(port);
@@ -1514,7 +1526,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	if (pvid == vlan->vid)
 		pvid = b53_default_pvid(dev);
 
-	if (untagged && !dsa_is_cpu_port(ds, port))
+	if (untagged && !b53_vlan_port_needs_forced_tagged(ds, port))
 		vl->untag &= ~(BIT(port));
 
 	b53_set_vlan_entry(dev, vlan->vid, vl);
@@ -2660,7 +2672,6 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
-	ds->untag_bridge_pvid = true;
 	dev->vlan_enabled = true;
 	/* Let DSA handle the case were multiple bridges span the same switch
 	 * device and different VLAN awareness settings are requested, which
-- 
2.25.1

