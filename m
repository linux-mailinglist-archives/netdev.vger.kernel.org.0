Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67426EA4EF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJ3Uou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:44:50 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:61631
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbfJ3Uou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 16:44:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdZxcKSA1BSzZGbPnRNzCWTLQQlUpR/oG5x0llsNFcSEkyoSGx53Wf/YCmONvAXWXmN9IFQdSwS5kNrfueFjslnC20gy0MIGCvNJKmD0i0yuaiTRs3YNyzTfESxUpNwVU/sp4fjrd7wcHtScqnkJj3VBqzQPEO48zKkr/K/mzXCDSfiYszX4zrZwgoMc7aZ9p6pymFAVU400gSoEdqJbIlmeOC+dlWPf+xVrEwBrE/R493mt1PoZ//ILYw5HEp+jYvLVbSqSNjbkJHjHzNDKhJcgpXoO76O3MK2I25OHlFFc6nFJ2/uFkg5srlymdewMuYRy2O1lrqTaXV2VVwmtow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoMrf1JtywxAJ8ifUC2cBt2/dWKjB1N0D2DAyVdj7CQ=;
 b=X0eGyS/n0pWGRGyqN9sapzfc+WBQvo+Nmy58gUQhtOx7n0zuMMMlugeopnGhrT5YVlTQ9fpoelmwcui1JJtkFiHQAn8xsNJGO5j0Q7lGH7dRnf6y4tilSdpT2aR5KI9XtfbHTkA93i24XklkFfhNZCNAdIfHwaDWJ1FXET3G/ylZqJUdXWNlv3IZbUNE4yvrvPr/yiXkLxg2WbQA5RkrNQlJ1Yz2+DMeZMRhtrGBKsTDoflG2tAAFuIe/EVBBY4I3AMcEpwlcpiDoCGzkaWG3XcTpeIN6resF2XMQ9VlV7aR3Z1YntJ3UlUvrFYlj9CvPppX/BkQ6cuJz0gbyy1fiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoMrf1JtywxAJ8ifUC2cBt2/dWKjB1N0D2DAyVdj7CQ=;
 b=BkOJFhdELPUfylFlgJY9WBOM2C1zJhSViSIpIoJByM8PwU7dkHTY6lTf6GnLAvnX8bUsOwwkXuKn/J1qaJBcQXzgnoTpt+1VqgWDWGdTPtXrKtDEs0tnk+ADw0jGFZ41DXvWdaFvPJmpuzMVn25gRwmC5XN6ID9IfjDI9ssiZQI=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3267.eurprd05.prod.outlook.com (10.171.188.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 30 Oct 2019 20:44:44 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 20:44:44 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next 1/3] net: Support querying specific VF properties
Thread-Topic: [PATCH net-next 1/3] net: Support querying specific VF
 properties
Thread-Index: AQHVj2LchXTLIqhq20GX4fRo53UDjw==
Date:   Wed, 30 Oct 2019 20:44:43 +0000
Message-ID: <1572468274-30748-2-git-send-email-lariel@mellanox.com>
References: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR06CA0066.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::43) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 338f7019-01fa-426c-198d-08d75d79fe58
x-ms-traffictypediagnostic: AM4PR05MB3267:|AM4PR05MB3267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3267ED9F2B79468561CFF159BA600@AM4PR05MB3267.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(199004)(189003)(14454004)(1730700003)(6486002)(476003)(486006)(8936002)(186003)(11346002)(6512007)(446003)(478600001)(316002)(26005)(54906003)(81166006)(2616005)(6436002)(81156014)(8676002)(50226002)(5640700003)(86362001)(107886003)(25786009)(99286004)(52116002)(386003)(2906002)(102836004)(2501003)(6116002)(14444005)(71200400001)(36756003)(71190400001)(76176011)(6506007)(64756008)(66556008)(4720700003)(2351001)(66446008)(66476007)(3846002)(7736002)(6916009)(5660300002)(66066001)(305945005)(256004)(4326008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3267;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HkVhmF6l0VfijI8rLtqtUVJiJNI483Lwvlb4t/h5J8c40vK5oVCVkhnwNJo50zKB5FMgrOhQZen8tEB4toDwuK1f867KzoeW3CuZ9Qo1TfrH9Nsf2Xaw4bEX6UZfCTsBkxSAcug75Q1tkkG0V/lI+8ZBjn9zgYVxQrXArqK+WwEqBuQwygyjD/qyZvM3mu8tvPUHmTndOAgISxpDXui4N4Zl1qRH9pdT4ZKyCdrRC86zuhmKbdANcVih7tswVcTolLoisl4JC4AVftK7qlanObABmncKzJM6Gfxq2Cba8ObzM/AYLFVjMqZ2pDT67WGoHaoImEm/L54kEMR+mcGQ+KcgjkPawlghMIipC1MPYlVX9/nKU37l94cCkQt2HItceWyD1i7jVQW2aGjuZW35lTau1uUFnxHu0iZh9x2g0izX15viLS5esrenaMp30B3Z
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 338f7019-01fa-426c-198d-08d75d79fe58
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 20:44:43.9385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SBbLkC0DILURUD2BiEZSwVrS8bZTpAxIRogFOXxk1OSrzc0F2n6PHoW01hwXKJo8XTcCPzGLxJNZravgcVf02w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3267
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

