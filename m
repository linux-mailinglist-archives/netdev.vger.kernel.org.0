Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9429818460E
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgCMLkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:40:06 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:34528
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbgCMLkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 07:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHj+uOxoDmrvfTu4Z4CxkyPBareX+iSbzKQz92Sy7gCdm9du4qT8t7BtNB5k6X/FjIirodwAO8oKZYCRPo+NwxD1YcumIQ9595e0QEXzRghyG/CcMEezsGsTVInhLtVTMlGaLi8Lb0wc12J+gN1A2TdYutFkBPnLsSDv57Eve0pZvuH/CPwIjj9ORRlKmQUIxnv6P06KGFuPrb+auWZlqaYsU5I513I5UGS23qaxd99pXxOFP29MPZqe15OiJCiTqxhKYSqhUvpnaQMghjEqEW21CH0pIN8Mf1qriRdjvhkp8Vd6DE+tSbFniDDyeOeBcN9b7fQB1kk7Jn0vs37RgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoCzBm2u9iCFJLq8aaGd9Lt2GH9WyKZZushDgrF7ZFA=;
 b=U9A+18Iy+CY1ePoKHZwrBXtFqrchBtf48/hd/kRDC55kizzC5qCik2hcDMy7jXSq0PQTYP/kA6RFFyWwjWXtjrcWoRTKBWAwc8Hn8FAuCi86fUTJ1uLd/KH4z0rThlM7iFDQYAD6Rokcyjdy5/pmdNvAAq8t2Hd2GiVh+uy/DcbSqqHRP8GXB3ChAXjI8W20lR+xbfJWJzrWCQfXmo3gjaTOM0mU9c/NzqJ4rtAcVKLfZEaurxJXuA5JGgfyElUFGp/fCyOCfnVraMLXd40Yaz7B65VgbOtMM7tS3i0DHHv9+90mswuzPdowuJ9ux9mJY0ugWKj4VVwo/0DEZt2CVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoCzBm2u9iCFJLq8aaGd9Lt2GH9WyKZZushDgrF7ZFA=;
 b=cycqstVapfXX5HfPSAM4uBpLkZHYGd62KQlyjzO5mICWyuh3t8+GBHnNTZiio5J6BzkAB4ecZJ/vHVwStIKnwNjUiJvaUcmd8bxrmV9MA/btflu8+ScWXPj2OW3ZjqMEuzI51xPYeHjCrGYF5mH/CGgJQSKWORrCq2PIaFvANNw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4714.eurprd05.prod.outlook.com (20.176.163.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 13 Mar 2020 11:39:58 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 11:39:58 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, William Tu <u9012063@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Meenakshi Vohra <mvohra@vmware.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] net: ip_gre: Separate ERSPAN newlink / changelink callbacks
Date:   Fri, 13 Mar 2020 13:39:36 +0200
Message-Id: <557d411272605c1611a209389ee198c534efde56.1584099517.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::18)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 11:39:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ecac48e2-fb88-4cb2-0fec-08d7c74341d3
X-MS-TrafficTypeDiagnostic: HE1PR05MB4714:|HE1PR05MB4714:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB47143F1D2D1EEAD99EB67500DBFA0@HE1PR05MB4714.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(199004)(36756003)(66556008)(86362001)(52116002)(6512007)(6666004)(2906002)(54906003)(316002)(478600001)(6506007)(81166006)(8936002)(5660300002)(16526019)(186003)(8676002)(66476007)(6486002)(2616005)(6916009)(81156014)(26005)(4326008)(956004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4714;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prqMDUL/mDgu/yiV98q5hNrWthOPpGt2xy87W0C0N+6W4Mb1B0Y74AwtAxrw4KD/V42ti3VmUXfl4NJKyqPxGm5g2r94ZZBMkoDse3mXEe/SFy11tTGvSSIeVRljbMCWLMEA8W3VAgBLD/XtTkl88BJuEQbPa6JjaXarVuOKs9T0T2RllH3g4jwjYxCbjen9ujIvQ/HQE9MqFGxsnRvIKsFcKwAxTcewCJxr6dmyNNq0twwx46TQkNq/5lqIyrcKCr7iFtzprTvk816If7GivHUqvEig2za65sbavgpUDXnrW7P9zSvz2KDEXfEN1utaoLdnznFtu8zs61AKy+GaVO2k3VySR9EkGNIibsTnBRGWEY024D8J6NSeIn96k+8tCoTQs2GKpexmTuMY7dPrh9eulrE14SeP5dv2LzyQJW3buiNbcSjASOKvci5sOOh3
X-MS-Exchange-AntiSpam-MessageData: blPMnDeo0s9CD5YAIpEGJ6VU9lrvVQq2Oo7VLcrze7w5dRVOZbFGMPeGP9vLCnfnptmgseJHt9gJXBzUUL+3fXX5ej3p5I5NQ57nyOgv1LxJxt2UlR0ioLuMm+s1FhR79FGQjwagCt47CeBU03qmdg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecac48e2-fb88-4cb2-0fec-08d7c74341d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 11:39:57.9970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/vCB3UspSo3prufwZL2bjowSDwoirndLYCzbTdJtKvtIae6k+pOeuvc/aRtKgd6Si+BFc5OqZcS2raC173duw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ERSPAN shares most of the code path with GRE and gretap code. While that
helps keep the code compact, it is also error prone. Currently a broken
userspace can turn a gretap tunnel into a de facto ERSPAN one by passing
IFLA_GRE_ERSPAN_VER. There has been a similar issue in ip6gretap in the
past.

To prevent these problems in future, split the newlink and changelink code
paths. Split the ERSPAN code out of ipgre_netlink_parms() into a new
function erspan_netlink_parms(). Extract a piece of common logic from
ipgre_newlink() and ipgre_changelink() into ipgre_newlink_encap_setup().
Add erspan_newlink() and erspan_changelink().

Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/ipv4/ip_gre.c | 105 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 8274f98c511c..7765c65fc7d2 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1153,6 +1153,22 @@ static int ipgre_netlink_parms(struct net_device *dev,
 	if (data[IFLA_GRE_FWMARK])
 		*fwmark = nla_get_u32(data[IFLA_GRE_FWMARK]);
 
+	return 0;
+}
+
+static int erspan_netlink_parms(struct net_device *dev,
+				struct nlattr *data[],
+				struct nlattr *tb[],
+				struct ip_tunnel_parm *parms,
+				__u32 *fwmark)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	int err;
+
+	err = ipgre_netlink_parms(dev, data, tb, parms, fwmark);
+	if (err)
+		return err;
+
 	if (data[IFLA_GRE_ERSPAN_VER]) {
 		t->erspan_ver = nla_get_u8(data[IFLA_GRE_ERSPAN_VER]);
 
@@ -1276,22 +1292,33 @@ static void ipgre_tap_setup(struct net_device *dev)
 	ip_tunnel_setup(dev, gre_tap_net_id);
 }
 
+static int
+ipgre_newlink_encap_setup(struct net_device *dev, struct nlattr *data[])
+{
+	struct ip_tunnel_encap ipencap;
+
+	if (ipgre_netlink_encap_parms(data, &ipencap)) {
+		struct ip_tunnel *t = netdev_priv(dev);
+		int err = ip_tunnel_encap_setup(t, &ipencap);
+
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int ipgre_newlink(struct net *src_net, struct net_device *dev,
 			 struct nlattr *tb[], struct nlattr *data[],
 			 struct netlink_ext_ack *extack)
 {
 	struct ip_tunnel_parm p;
-	struct ip_tunnel_encap ipencap;
 	__u32 fwmark = 0;
 	int err;
 
-	if (ipgre_netlink_encap_parms(data, &ipencap)) {
-		struct ip_tunnel *t = netdev_priv(dev);
-		err = ip_tunnel_encap_setup(t, &ipencap);
-
-		if (err < 0)
-			return err;
-	}
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
 
 	err = ipgre_netlink_parms(dev, data, tb, &p, &fwmark);
 	if (err < 0)
@@ -1299,22 +1326,36 @@ static int ipgre_newlink(struct net *src_net, struct net_device *dev,
 	return ip_tunnel_newlink(dev, tb, &p, fwmark);
 }
 
+static int erspan_newlink(struct net *src_net, struct net_device *dev,
+			  struct nlattr *tb[], struct nlattr *data[],
+			  struct netlink_ext_ack *extack)
+{
+	struct ip_tunnel_parm p;
+	__u32 fwmark = 0;
+	int err;
+
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
+
+	err = erspan_netlink_parms(dev, data, tb, &p, &fwmark);
+	if (err)
+		return err;
+	return ip_tunnel_newlink(dev, tb, &p, fwmark);
+}
+
 static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
 			    struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_encap ipencap;
 	__u32 fwmark = t->fwmark;
 	struct ip_tunnel_parm p;
 	int err;
 
-	if (ipgre_netlink_encap_parms(data, &ipencap)) {
-		err = ip_tunnel_encap_setup(t, &ipencap);
-
-		if (err < 0)
-			return err;
-	}
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
 
 	err = ipgre_netlink_parms(dev, data, tb, &p, &fwmark);
 	if (err < 0)
@@ -1327,8 +1368,34 @@ static int ipgre_changelink(struct net_device *dev, struct nlattr *tb[],
 	t->parms.i_flags = p.i_flags;
 	t->parms.o_flags = p.o_flags;
 
-	if (strcmp(dev->rtnl_link_ops->kind, "erspan"))
-		ipgre_link_update(dev, !tb[IFLA_MTU]);
+	ipgre_link_update(dev, !tb[IFLA_MTU]);
+
+	return 0;
+}
+
+static int erspan_changelink(struct net_device *dev, struct nlattr *tb[],
+			     struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	__u32 fwmark = t->fwmark;
+	struct ip_tunnel_parm p;
+	int err;
+
+	err = ipgre_newlink_encap_setup(dev, data);
+	if (err)
+		return err;
+
+	err = erspan_netlink_parms(dev, data, tb, &p, &fwmark);
+	if (err < 0)
+		return err;
+
+	err = ip_tunnel_changelink(dev, tb, &p, fwmark);
+	if (err < 0)
+		return err;
+
+	t->parms.i_flags = p.i_flags;
+	t->parms.o_flags = p.o_flags;
 
 	return 0;
 }
@@ -1519,8 +1586,8 @@ static struct rtnl_link_ops erspan_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct ip_tunnel),
 	.setup		= erspan_setup,
 	.validate	= erspan_validate,
-	.newlink	= ipgre_newlink,
-	.changelink	= ipgre_changelink,
+	.newlink	= erspan_newlink,
+	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
 	.fill_info	= ipgre_fill_info,
-- 
2.20.1

