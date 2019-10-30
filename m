Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02684EA42D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfJ3TZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:25:28 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:40260
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbfJ3TZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:25:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmm0A61qdImNwerTualkzQN/zvhVSrtUOwxXB2wczEanUpOAMbZChn89o8piFxzLThNA9emZpjvEX25ocXMLQPh0vfPyxBpN7+TtfPngb1VZUf3fb2D3Zz+azpvv641iKD/jIHxNuwqfquj3sz6yOlDGE7bkoWv/NCUBLII6OTqJAwZetQSto5eYx4WI0lDvuHunHVKFuGKsL5rU6eUS+Qz63eSArUIymPsPtg8t5TOW3K0g7r/tcd7qGT7hHB1Oy0OewweijYnIISpMqUPW4R8oSqyUMW36QnVjErFUkeQnuzAnrCP2yIxhy+oYE8DAilRPSSlDn/u4x1WZYpMshA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoMrf1JtywxAJ8ifUC2cBt2/dWKjB1N0D2DAyVdj7CQ=;
 b=keotUm8u8dP5Xqv1+XZVSV/pvEFt60mgNVR48Gnq2zQtUOjNcg0JrjwZ4cjjX1CK39bo+suJBt09Ku9ndkgCXBcNwIPidYhFEVG6v22omACsdpK8KGR3O8GWa1PVFOl5hUbznjMNXdUV3LR6kpWlihWcfOSTeJErtyQKE5iJwzQWUE4Ym2rPY366xPtD3XyWPLVevaORL899ZPloHA7zYiB4k8O0x8bP+dauJErlt+abR/20ihApV5g4RN9/DNbDENQpBdJYmpXA35okoj9lKqVTwB+0tQK8IFaFgBhB5BpFL4oQgRhiHlCt2uN/u+bObXZQzxxbtUOoTSXJNkXBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoMrf1JtywxAJ8ifUC2cBt2/dWKjB1N0D2DAyVdj7CQ=;
 b=S2Me8RUEV03xqXvhISA/iqPuJpOV5kG4a8kEgorFDQNwz+HLqVqKBJJjHScoBC/2liADtbKsDVP4Xac0t/DUcJrryf8jGUen5K3mmtUE/Rk8XQAiLjfbcXKxj5f8glj8DJ2NL793Q0g3tQO9rpTrAhIpAiknpN/D42TLvKL5PjY=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3186.eurprd05.prod.outlook.com (10.171.191.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 19:25:22 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:25:21 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH v2 1/3] net: Support querying specific VF properties
Thread-Topic: [PATCH v2 1/3] net: Support querying specific VF properties
Thread-Index: AQHVj1fFOF/65qOMBk2I6881bQAAgg==
Date:   Wed, 30 Oct 2019 19:25:21 +0000
Message-ID: <1572463515-26961-2-git-send-email-lariel@mellanox.com>
References: <1572463515-26961-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572463515-26961-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94ddbc15-9283-46f9-3bc9-08d75d6ee80b
x-ms-traffictypediagnostic: AM4PR05MB3186:|AM4PR05MB3186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB318639C18157FA12B8715FCDBA600@AM4PR05MB3186.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(189003)(199004)(305945005)(7736002)(64756008)(66446008)(14444005)(25786009)(316002)(66556008)(256004)(6506007)(386003)(54906003)(71200400001)(4326008)(71190400001)(486006)(2351001)(2906002)(6486002)(6512007)(2616005)(6436002)(446003)(11346002)(86362001)(6916009)(5640700003)(107886003)(52116002)(476003)(50226002)(14454004)(8936002)(8676002)(1730700003)(81156014)(81166006)(99286004)(76176011)(186003)(66476007)(5660300002)(66946007)(2501003)(3846002)(478600001)(102836004)(4720700003)(66066001)(36756003)(6116002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3186;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8jh3ybDT1FNDeUvUOFntMQbQX8KTBIR+yQ9Gf89BLnMAW4Q0AfezmEFJ7rFVw9hBLdrxGpExj0JoIHRcY/Ggx/TJb1M8uGL1lCKPpG3Zf2U8aZvAlcM6Lbjl+lWmGw3zlBJ4TzS5djVa9nV+3tJR2TpalNA/ON85j/8knNA+Zq5Q7dUGG7yDdNz2WWeVMD/gsAMxQyyYVFbKFOhXmftMXO3yuQsbKQR+cE6NxnAutSoyIwpYiw1sgEvAfg1zZFpDNDsQwM3NIuJVvf3NoUTwr0RMN1u6bLcMKb63AI8bNllsOgMtiE5ctjTCG0asq7PEVgqcIHOtlMKtAyHj/kY/OFT8VRDO4A6ODw57siHb64bFs/0OGJe6IDmt8Vo0+SF9xupTPa1tc7LBXE47wiuekYtk9k27DH1goIlME3WUordh8M3apjJVJEyKWlXubXU
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ddbc15-9283-46f9-3bc9-08d75d6ee80b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:25:21.8829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5DFdM0P8mX8qVvqApqxdXKmZC1UjYvVoESB5/OyFLfxofs282jLKiherexRjDPxfhMqWUbTu/pVDqcFKK0bpnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying the link with its VFs information involves putting a
vfinfo struct per VF in the netlink message under the
IFLA_VFINFO_LIST attribute.

Since the attribute's length is limited by it's definition to u16,
this introduces a problem when we want to add new fields to the
vfinfo attribute.
With increasing the vfinfo attribute and running in an environment
with a large number of VFs, we may overflow the IFLA_VFINFO_LIST
attribute length.

To avoid that, this patch introduces a single VF query.
With single VF query, the kernel may include extended VF information
and fields, such that take up a significant amount of memory, in the
vfinfo attribute.
This information may not be included with VF list
query and prevent attribute length overflow.

The admin will be able to query the link and get extended VF info
using iptool and following command:
ip link show dev <ifname> vf <vf_num>

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  1 +
 net/core/rtnetlink.c           | 49 ++++++++++++++++++++++++++++++++------=
----
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aec876..797e214 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_VF_NUM, /* Get extended information for specific VF */
 	__IFLA_MAX
 };
=20
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.=
h
index 1418a83..09df2f4 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -760,6 +760,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define RTEXT_FILTER_VF_EXT  (1 << 4)
=20
 /* End of information exported to user level */
=20
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 49fa910..31fa0af 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -906,9 +906,14 @@ static void copy_rtnl_link_stats(struct rtnl_link_stat=
s *a,
 static inline int rtnl_vfinfo_size(const struct net_device *dev,
 				   u32 ext_filter_mask)
 {
-	if (dev->dev.parent && (ext_filter_mask & RTEXT_FILTER_VF)) {
+	if (dev->dev.parent &&
+	    (ext_filter_mask & (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT))) {
 		int num_vfs =3D dev_num_vf(dev->dev.parent);
 		size_t size =3D nla_total_size(0);
+
+		if (num_vfs && (ext_filter_mask & RTEXT_FILTER_VF_EXT))
+			num_vfs =3D 1;
+
 		size +=3D num_vfs *
 			(nla_total_size(0) +
 			 nla_total_size(sizeof(struct ifla_vf_mac)) +
@@ -1022,7 +1027,8 @@ static noinline size_t if_nlmsg_size(const struct net=
_device *dev,
 	       + nla_total_size(4) /* IFLA_LINK_NETNSID */
 	       + nla_total_size(4) /* IFLA_GROUP */
 	       + nla_total_size(ext_filter_mask
-			        & RTEXT_FILTER_VF ? 4 : 0) /* IFLA_NUM_VF */
+				& (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT) ?
+				4 : 0) /* IFLA_NUM_VF */
 	       + rtnl_vfinfo_size(dev, ext_filter_mask) /* IFLA_VFINFO_LIST */
 	       + rtnl_port_size(dev, ext_filter_mask) /* IFLA_VF_PORTS + IFLA_POR=
T_SELF */
 	       + rtnl_link_get_size(dev) /* IFLA_LINKINFO */
@@ -1203,7 +1209,8 @@ static noinline_for_stack int rtnl_fill_stats(struct =
sk_buff *skb,
 static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 					       struct net_device *dev,
 					       int vfs_num,
-					       struct nlattr *vfinfo)
+					       struct nlattr *vfinfo,
+					       int vf_ext)
 {
 	struct ifla_vf_rss_query_en vf_rss_query_en;
 	struct nlattr *vf, *vfstats, *vfvlanlist;
@@ -1332,15 +1339,21 @@ static noinline_for_stack int rtnl_fill_vfinfo(stru=
ct sk_buff *skb,
=20
 static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 					   struct net_device *dev,
-					   u32 ext_filter_mask)
+					   u32 ext_filter_mask,
+					   int vf)
 {
+	int vf_ext =3D (ext_filter_mask & RTEXT_FILTER_VF_EXT) && (vf >=3D 0);
 	struct nlattr *vfinfo;
 	int i, num_vfs;
=20
-	if (!dev->dev.parent || ((ext_filter_mask & RTEXT_FILTER_VF) =3D=3D 0))
+	if (!dev->dev.parent ||
+	    ((ext_filter_mask & (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT)) =3D=3D 0=
))
 		return 0;
=20
 	num_vfs =3D dev_num_vf(dev->dev.parent);
+	if (vf_ext && num_vfs)
+		num_vfs =3D 1;
+
 	if (nla_put_u32(skb, IFLA_NUM_VF, num_vfs))
 		return -EMSGSIZE;
=20
@@ -1352,7 +1365,7 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_=
buff *skb,
 		return -EMSGSIZE;
=20
 	for (i =3D 0; i < num_vfs; i++) {
-		if (rtnl_fill_vfinfo(skb, dev, i, vfinfo))
+		if (rtnl_fill_vfinfo(skb, dev, vf_ext ? vf : i, vfinfo, vf_ext))
 			return -EMSGSIZE;
 	}
=20
@@ -1639,7 +1652,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    int type, u32 pid, u32 seq, u32 change,
 			    unsigned int flags, u32 ext_filter_mask,
 			    u32 event, int *new_nsid, int new_ifindex,
-			    int tgt_netnsid)
+			    int tgt_netnsid, int vf)
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
@@ -1717,7 +1730,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_stats(skb, dev))
 		goto nla_put_failure;
=20
-	if (rtnl_fill_vf(skb, dev, ext_filter_mask))
+	if (rtnl_fill_vf(skb, dev, ext_filter_mask, vf))
 		goto nla_put_failure;
=20
 	if (rtnl_port_fill(skb, dev, ext_filter_mask))
@@ -1806,6 +1819,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	[IFLA_PROP_LIST]	=3D { .type =3D NLA_NESTED },
 	[IFLA_ALT_IFNAME]	=3D { .type =3D NLA_STRING,
 				    .len =3D ALTIFNAMSIZ - 1 },
+	[IFLA_VF_NUM]		=3D { .type =3D NLA_U32 },
 };
=20
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =3D {
@@ -2057,7 +2071,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 					       NETLINK_CB(cb->skb).portid,
 					       nlh->nlmsg_seq, 0, flags,
 					       ext_filter_mask, 0, NULL, 0,
-					       netnsid);
+					       netnsid, -1);
=20
 			if (err < 0) {
 				if (likely(skb->len))
@@ -3365,6 +3379,7 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb=
,
 		case IFLA_ALT_IFNAME:
 		case IFLA_EXT_MASK:
 		case IFLA_TARGET_NETNSID:
+		case IFLA_VF_NUM:
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in get link request");
@@ -3385,6 +3400,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr *nlh,
 	struct net_device *dev =3D NULL;
 	struct sk_buff *nskb;
 	int netnsid =3D -1;
+	int vf =3D -1;
 	int err;
 	u32 ext_filter_mask =3D 0;
=20
@@ -3407,6 +3423,17 @@ static int rtnl_getlink(struct sk_buff *skb, struct =
nlmsghdr *nlh,
 		ext_filter_mask =3D nla_get_u32(tb[IFLA_EXT_MASK]);
=20
 	err =3D -EINVAL;
+	if ((ext_filter_mask & RTEXT_FILTER_VF) &&
+	    (ext_filter_mask & RTEXT_FILTER_VF_EXT))
+		goto out;
+
+	if (ext_filter_mask & RTEXT_FILTER_VF_EXT) {
+		if (tb[IFLA_VF_NUM])
+			vf =3D nla_get_u32(tb[IFLA_VF_NUM]);
+		else
+			goto out;
+	}
+
 	ifm =3D nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev =3D __dev_get_by_index(tgt_net, ifm->ifi_index);
@@ -3428,7 +3455,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr *nlh,
 	err =3D rtnl_fill_ifinfo(nskb, dev, net,
 			       RTM_NEWLINK, NETLINK_CB(skb).portid,
 			       nlh->nlmsg_seq, 0, 0, ext_filter_mask,
-			       0, NULL, 0, netnsid);
+			       0, NULL, 0, netnsid, vf);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size */
 		WARN_ON(err =3D=3D -EMSGSIZE);
@@ -3634,7 +3661,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, stru=
ct net_device *dev,
=20
 	err =3D rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, 0, 0, change, 0, 0, event,
-			       new_nsid, new_ifindex, -1);
+			       new_nsid, new_ifindex, -1, -1);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
 		WARN_ON(err =3D=3D -EMSGSIZE);
--=20
1.8.3.1

