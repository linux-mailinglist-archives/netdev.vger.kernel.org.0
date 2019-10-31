Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAD4EB827
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfJaTzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:55:38 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:24827
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727648AbfJaTzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:55:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8odeb/NbqiZ+wnrS/k++mbjYksylANdewxj20FtV1mzhZjSJiRX9s2qywvzAGvdG8cKkOMsXJ31l77+9vKr/Ndz9+sszJwUXm93Mhp9JLYVLw2b70zGyryQ/sBsr2sY0TzRZnljxfV4zib2puipthQj+Rww12leBnsW8v+dbRL+UA927nVn7kWO5uVeKyAgfYdEr7pY2sGVX/zVP/ld/MHQu/zdi0Sdeh0fkUcDoN4MtD5m01iaZHab6evWic5J+tmasPQv3bktJmfjadGkdbp2gG8qDeUSD8FZw2Aaep0nZScxwD6ws04kpKPVRNuxioMJBRzeNcuBoH2JPCvjIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsRq35wOKzSCQJXicXSeG9LgN+tLrzBA/2cLQSgtyWc=;
 b=nH4u/5QmphUcng6OdcCfIrWnhoJPrS2n69IR0PfDqLOes+6Iiyyjw9+rlpYexBMjNfj7hLzqABrrrBwvZ3jNKvFKcD9rGVmW7PyWAeq7Vmp8ne4Q6CEe+yeT2YYomMGXXz3pAvc+ndg7X04Ve/jgFeu/nO6vrOof6dhEvXAYGJFp6LdUMoQeQhFYitjGbTB96srCYd1mzmxqntW6i2rgtOYKPV3Y4I3cf6B8A4cG13A5CTKYJiwr9qcp+4+qO3E49rRTA/qOs6T13ETJcBRhBLfZTuHnmKT3RWe6m9I3pM+I0MP23IkfBq4ksjrgHzl8jNhYGJ2ligX10VurpLKwqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsRq35wOKzSCQJXicXSeG9LgN+tLrzBA/2cLQSgtyWc=;
 b=Q1wQtoeDQsydhrn6wazrCjoCxUe+4d+mVAN4yyl0344ugOnBLhD/5NiAsQRK4iBNpOaRje9MTTydnUMvrwEEHtzJ/uV1Dq3P4EaaumfNDlzHplqU3OUg1VM+WrbLlbcnuaYpP2AIZBtMx93PV/wUEVYWjMU3QFLuFJY/3qw+VPQ=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:55:32 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:55:32 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH iproute2-next v2 1/3] ip: Allow query link with extended vf
 properties
Thread-Topic: [PATCH iproute2-next v2 1/3] ip: Allow query link with extended
 vf properties
Thread-Index: AQHVkCUnol9zsatg/0qlzBB3v2ZNnw==
Date:   Thu, 31 Oct 2019 19:55:32 +0000
Message-ID: <1572551722-9520-2-git-send-email-lariel@mellanox.com>
References: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7fb74083-38a6-4210-075e-08d75e3c499d
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB332424F919399A4D0B76D7A5BA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(76176011)(71190400001)(305945005)(186003)(66556008)(6512007)(7736002)(66476007)(66446008)(66946007)(3846002)(52116002)(14454004)(6486002)(6116002)(64756008)(316002)(4720700003)(26005)(5640700003)(71200400001)(2906002)(54906003)(256004)(14444005)(66066001)(6436002)(6506007)(86362001)(2501003)(99286004)(11346002)(486006)(5660300002)(8936002)(107886003)(386003)(446003)(1730700003)(36756003)(476003)(8676002)(2616005)(2351001)(81156014)(81166006)(478600001)(50226002)(6916009)(102836004)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PL3tIvjkbdeMeYcnVRyjrTNrwbWQI21ymw1+IqFm1nAX7061dQWIKqqJIr8AEB8Nz8xiln2AUhPcTbOZhP3ZMgY9RbUc3t08Lt60Pa7MYqk6alLwDLjMRLGsQvaDOcU8A6XsZhGrio3f6yw7u3fzdfKltgCc4Bkh2FBLNPRHMCqaJPtsIU2FksVSQTicoVfY0K5SIEEWHRE0dnAQD4lJ89vRpimg65lMPmgQav1PZ7kRkOvwsoIZVgzwd8jpn7w9IA+U+vn0RLlbEOtnyw0LOzG0U3CCrnRJCcGHc5q7VylQgPcLb3o7UYZoLsj3BSqEVsIJAnwxavECrVW0ytUWwErGjBZQ7rbdOn2LmHF7khpEC4M2Bh/KJ19y7F412lUha3Fme3v1l3Yhmvwsenl+dc16QQGXWxv58NukkTiyAQ2lJNoqc9K66c6ZVHr0j/gZ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb74083-38a6-4210-075e-08d75e3c499d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:55:32.4809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dM9jEZERf/ey+RfGkigiWe0T+GV2OcSMvTVQ4a9l5stoMxi8odpim4xFKjN/4XiwDqgT8Oq0d3Q/P5I8ECwjkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding vf num filter to ip link show command for querying
extended information of a specific vf.

When specifying a vf num, the kernel may return additional
vf information that takes up large amount of memory and
can't be included when querying the entire list of vfs
due to attribute size limitation.

The usage is:
ip link show dev <ifname> vf <vf_num>

Only the specified VF's information will be returned
and presented in this case.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  1 +
 ip/ip_common.h                 |  2 +-
 ip/ipaddress.c                 | 16 +++++++++++++++-
 ip/iplink.c                    |  6 ++++--
 man/man8/ip-link.8.in          | 13 ++++++++++++-
 6 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1c49f43..d39017b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_VF_NUM,
 	__IFLA_MAX
 };
=20
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.=
h
index 4b93791..8fc7f5d 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -758,6 +758,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define	RTEXT_FILTER_VF_EXT	(1 << 4)
=20
 /* End of information exported to user level */
=20
diff --git a/ip/ip_common.h b/ip/ip_common.h
index cd916ec..4151232 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -83,7 +83,7 @@ int netns_identify_pid(const char *pidstr, char *name, in=
t len);
 int do_seg6(int argc, char **argv);
 int do_ipnh(int argc, char **argv);
=20
-int iplink_get(char *name, __u32 filt_mask);
+int iplink_get(char *name, __u32 filt_mask, int vf);
 int iplink_ifla_xstats(int argc, char **argv);
=20
 int ip_link_list(req_filter_fn_t filter_fn, struct nlmsg_chain *linfo);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index bc8f5ba..0521fdc 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1874,9 +1874,11 @@ static int ipaddr_list_flush_or_save(int argc, char =
**argv, int action)
 {
 	struct nlmsg_chain linfo =3D { NULL, NULL};
 	struct nlmsg_chain _ainfo =3D { NULL, NULL}, *ainfo =3D &_ainfo;
+	int filter_mask =3D RTEXT_FILTER_VF;
 	struct nlmsg_list *l;
 	char *filter_dev =3D NULL;
 	int no_link =3D 0;
+	int vf =3D -1;
=20
 	ipaddr_reset_filter(oneline, 0);
 	filter.showqueue =3D 1;
@@ -1953,6 +1955,18 @@ static int ipaddr_list_flush_or_save(int argc, char =
**argv, int action)
 			} else {
 				filter.kind =3D *argv;
 			}
+		} else if (strcmp(*argv, "vf") =3D=3D 0) {
+			if (vf >=3D 0)
+				duparg2("vf", *argv);
+
+			if (!filter_dev)
+				missarg("dev");
+
+			NEXT_ARG();
+			if (get_integer(&vf,  *argv, 0))
+				invarg("Invalid \"vf\" value\n", *argv);
+			else
+				filter_mask =3D RTEXT_FILTER_VF_EXT;
 		} else {
 			if (strcmp(*argv, "dev") =3D=3D 0)
 				NEXT_ARG();
@@ -2006,7 +2020,7 @@ static int ipaddr_list_flush_or_save(int argc, char *=
*argv, int action)
 	 * the link device
 	 */
 	if (filter_dev && filter.group =3D=3D -1 && do_link =3D=3D 1) {
-		if (iplink_get(filter_dev, RTEXT_FILTER_VF) < 0) {
+		if (iplink_get(filter_dev, filter_mask, vf) < 0) {
 			perror("Cannot send link get request");
 			delete_json_obj();
 			exit(1);
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088..ef33232 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -107,7 +107,7 @@ void iplink_usage(void)
 		"			[ protodown { on | off } ]\n"
 		"			[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
-		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [ty=
pe TYPE]\n"
+		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [ty=
pe TYPE] [vf VF_NUM]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
@@ -1092,7 +1092,7 @@ static int iplink_modify(int cmd, unsigned int flags,=
 int argc, char **argv)
 	return 0;
 }
=20
-int iplink_get(char *name, __u32 filt_mask)
+int iplink_get(char *name, __u32 filt_mask, int vf)
 {
 	struct iplink_req req =3D {
 		.n.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg)),
@@ -1107,6 +1107,8 @@ int iplink_get(char *name, __u32 filt_mask)
 			  IFLA_IFNAME, name, strlen(name) + 1);
 	}
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
+	if (filt_mask & RTEXT_FILTER_VF_EXT)
+		addattr32(&req.n, sizeof(req), IFLA_VF_NUM, vf);
=20
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
 		return -2;
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d..29744d4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -176,7 +176,9 @@ ip-link \- network device configuration
 .B type
 .IR ETYPE " ] ["
 .B vrf
-.IR NAME " ]"
+.IR NAME " ] ["
+.B vf
+.IR NUM " ]"
=20
 .ti -8
 .B ip link xstats
@@ -2396,6 +2398,15 @@ interface list by comparing it with the relevant att=
ribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to e=
mpty
 output.
=20
+.TP
+.BI vf " NUM "
+.I NUM
+specifies a Virtual Function device to be configured.
+
+The associated PF device must be specified using the
+.B dev
+parameter.
+
 .SS  ip link xstats - display extended statistics
=20
 .TP
--=20
1.8.3.1

