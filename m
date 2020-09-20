Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D72711B6
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgITBsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:24 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:45178
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbgITBsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLMacE8QJA1u0NfwxsqNIkQq4sPENDffL9FHGs97i2P5fl+miRSr4GgDz6rbXXmCC/xgOjSgnRHxSWRkc/BT/Fcp+MEgOzhx5+zieIzziDGAH9OPFj5pgWcoBacSzgVjOTHsep2mgA7P/Uc3opq5TTFhkMhHaV8TJ3sb6jKUwMnijUhO1ukdOw0vO9inpABU031eya3XNjsR8INkrE5g6ngAvhYe9zekP0zEn0mflcDgZrjbF9TiMVcYvWP2wfZF9+6QzxyHoY1+XeSZux5nYgJxHFrKv5+S/+Y7Xg0wFXo2bdcUSYDYE5AjQWlwbwvHBKfwzqogqPy7uKHAhWDieA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhXJa2z688flA/EUM8GHfMFlWRmTlJr0O+DR17UsY7g=;
 b=lZnVe4FvX/L6Z/bsveV1NvJhkkwGgqR8fpTYQ/dnl7o5HhG86OK+VNC1bKPNqhra39KW9AC2FxOhdnEP0HbAJsilwdm+KFTdhMTlHurfJkTsgYHQcA1MopNbycCfsQh01lvgSnJDtP8CN44oKoUKURiKgZnKkQxNissmI50xH2JD9N5Y04zqrYbjEfZih/E7KcuSdGdQjFmvGq40z+8ouNub7uHIY2khSX0gc7xESyYEjzjOyqR4w2nfhwdLkRUMbz7Gqaxq4hKPb0UEpMr+c66uR8hLQ2JrFNC2+RFZmRIQTCT8g3YLxnOC6/hv2DBKKnhK5Lv8vxQgF945KL6P5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhXJa2z688flA/EUM8GHfMFlWRmTlJr0O+DR17UsY7g=;
 b=TBUyk2dgvF3NLpx9Sr/lu5mkFUDHyWzal62avHfdSk7Jo+oyyydEfqVcCFfrXWbdK+JckNa4aj7VH+aLaxXff0ATp945dvXWFbdC/ONQq2d9pieENEJPKYBi+9jl2KeBDdRmyXDeTijH6jrqqUkl7DStdT5DQ2z2ZUYoB0YtJeI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 5/9] net: dsa: refuse configuration in prepare phase of dsa_port_vlan_filtering()
Date:   Sun, 20 Sep 2020 04:47:23 +0300
Message-Id: <20200920014727.2754928-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2971fb87-b432-4e7e-f690-08d85d073a26
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26864AF707556979B49D982EE03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXmGxA9LFmq6I9Gs9290Pxb6pJqBeEImJN3u1VPHFRA27IomKvOJFRBmMP/Xb9bQLS5v0/cRRO5kGUGek7Rr3BCcG9RET/Btp2HtMEt1nhyrkbjUHgmGVDWYGaPFCXIE9SzDtOJ5+2f9w8PMtyAr5jhYSB+1CYo3+8K6cTJRNYezS9354xTWsDlHuZaoQeLbzzK/KonYvf9TyeaVajy2vU5HQhxA6qSRJQZ4PvnVJBUeD4ETzS7SUjYx1EiQPLvxWb0LZeIyq1PXsO//cT3il5x+ISU6cB9LAs1OnT1I+rQQNgbKSOwiQSJ45qqvSsGzG1k34VNA2c2x6ffZ8wbnBqvlxLJgvbCIqsfy0JO51eOa7MZdDnDv2iQPBaev+JDV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UcJcHv7bwBiKFfYF/g2B6tj32RfWD2g88RlJIvpDzTbq4z9DBNCDR/UfXEQWGkifHSbZg2ZC93K/HG6B1ixzq0MgbkI0ivFBAijIhuU24butuW+BdFs4rRLgaQjkv5YQiTIt1q5++mMlz/uqNeRDTDRyc9O15gLd/+Iy2fDbVi6ej6IQEgYF6fazojJ9RPtO4sZrFbqSmTzfwi2IxOB3VrEwgcSnUXTOKaXbFnftI4c+fFs9R2eSCb63JMOQsP8njy7wrxdfl84z2/SWrRU2pD0kpR9z1qC42P9DEwFFq3jKMYR1e+iUSTqVHFJOeGece3paVeFYI9X7V/qE9F2tF0qpVYRqibW7GqBg9hfeFgPv47TtJFkxMSR9Ya2sV+TZyjoJnQ/sm9xTv7+983dTmn2QfLFn9N5yG/GN4gUp7q8Ht/WGqgC/oiuct568PzK88n+AS5ePvgZm/u9Rh/+JQW0JQUtFCnjhs+cAg1HAC0FkQ8REZaqXVskATF33fP6cFuEA1ARIZZuBpwk6MNU9c3fcWWfdxYGbAq2EDRUGPOjYZm0+AdqaNq3YbIXtp457WDw2ImyesfWKuEAbdpY5D1jts08inNsLUoYeyDyLhX0efJmMHYDLMJ5EvIZFSnp+o9kY+LjD7KldsUQN63Tzcw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2971fb87-b432-4e7e-f690-08d85d073a26
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:09.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T22n7SJX0pN0iHvTvFMbpROme8FHGoAxLa1i+kCVe9va8Y1b6dIOonqz4Wb0BH0DmCAzJ8GqFnP0UsSbTx/MUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current logic beats me a little bit. The comment that "bridge skips
-EOPNOTSUPP, so skip the prepare phase" was introduced in commit
fb2dabad69f0 ("net: dsa: support VLAN filtering switchdev attr").

I'm not sure:
(a) ok, the bridge skips -EOPNOTSUPP, but, so what, where are we
    returning -EOPNOTSUPP?
(b) even if we are, and I'm just not seeing it, what is the causality
    relationship between the bridge skipping -EOPNOTSUPP and DSA
    skipping the prepare phase, and just returning zero?

One thing is certain beyond doubt though, and that is that DSA currently
refuses VLAN filtering from the "commit" phase instead of "prepare", and
that this is not a good thing:

ip link add br0 type bridge
ip link add br1 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp3 master br1
[ 3790.379389] 001: sja1105 spi0.1: VLAN filtering is a global setting
[ 3790.379399] 001: ------------[ cut here ]------------
[ 3790.379403] 001: WARNING: CPU: 1 PID: 515 at net/switchdev/switchdev.c:157 switchdev_port_attr_set_now+0x9c/0xa4
[ 3790.379420] 001: swp3: Commit of attribute (id=6) failed.
[ 3790.379533] 001: [<c11ff588>] (switchdev_port_attr_set_now) from [<c11b62e4>] (nbp_vlan_init+0x84/0x148)
[ 3790.379544] 001: [<c11b62e4>] (nbp_vlan_init) from [<c11a2ff0>] (br_add_if+0x514/0x670)
[ 3790.379554] 001: [<c11a2ff0>] (br_add_if) from [<c1031b5c>] (do_setlink+0x38c/0xab0)
[ 3790.379565] 001: [<c1031b5c>] (do_setlink) from [<c1036fe8>] (__rtnl_newlink+0x44c/0x748)
[ 3790.379573] 001: [<c1036fe8>] (__rtnl_newlink) from [<c1037328>] (rtnl_newlink+0x44/0x60)
[ 3790.379580] 001: [<c1037328>] (rtnl_newlink) from [<c10315fc>] (rtnetlink_rcv_msg+0x124/0x2f8)
[ 3790.379590] 001: [<c10315fc>] (rtnetlink_rcv_msg) from [<c10926b8>] (netlink_rcv_skb+0xb8/0x110)
[ 3790.379806] 001: ---[ end trace 0000000000000002 ]---
[ 3790.379819] 001: sja1105 spi0.1 swp3: failed to initialize vlan filtering on this port

So move the current logic that may fail (except ds->ops->port_vlan_filtering,
that is way harder) into the prepare stage of the switchdev transaction.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 46c9bf709683..794a03718838 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -232,15 +232,15 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	struct dsa_switch *ds = dp->ds;
 	int err;
 
-	/* bridge skips -EOPNOTSUPP, so skip the prepare phase */
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
+	if (switchdev_trans_ph_prepare(trans)) {
+		if (!ds->ops->port_vlan_filtering)
+			return -EOPNOTSUPP;
 
-	if (!ds->ops->port_vlan_filtering)
-		return 0;
+		if (!dsa_port_can_apply_vlan_filtering(dp, vlan_filtering))
+			return -EINVAL;
 
-	if (!dsa_port_can_apply_vlan_filtering(dp, vlan_filtering))
-		return -EINVAL;
+		return 0;
+	}
 
 	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
 		return 0;
-- 
2.25.1

