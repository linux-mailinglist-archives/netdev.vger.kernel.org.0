Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1368140460C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350893AbhIIHVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 03:21:45 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:58638 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232549AbhIIHVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 03:21:43 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DDEC98008D;
        Thu,  9 Sep 2021 07:20:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PsVhrvoFErr7l3pQm4vjnF+c2ibHdnTsgUL72XsWGOBmFR4eXqqbcLw4HSwi+0o0MvCy2wHcV49UBIWzyZlv5XAnY+aAYkX3nSjO8NnekFy+r4eyUVNyxT7hj750Bws/C5nxcHt4uIogiZ+rXh5UCet0xMt/cXWZ9JM0mp+36B75SlihNuQYIMXpVj6HuiG60D2lDm5VcRvwLMja2ToZWfh5n7DwcOt4uOkwwcqdxISJgyws7lGvymGQqVcnGbidXSR5NQh929qjl8zIIwys9KcifMG3owgGMCDfipW07rVRrssgdbwMl4xKykxg9B5p0P8Yj/6HSN/1p3KmVLEnOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0GCAvVHTsRApRyq7KIhNCuLhZ9LI6pmQ/e945zeu7lc=;
 b=RWoPO55t3p7Hmz1U2SyJbawl+a4ROzOjpcF7pSyPNFb7GYCwpHPkWOY5FoFBJQu5iNiW43LLErAzJ0P9cxWgMcE8uQ3mei3adrrVCwTb67uxLHmiAD+LRolklinVsEyoTI5tdEbi4EKyR5ZxrQ31SzBO+bpIoKpzkbEyri113IuTsu6g6wUZg0IpeTmBGWaD1/fRU3Sf8sIUs1nBOkXKvVHSFQ4x2Jq0VfDPM3JqVFK+4pnggY1FiDLhp8ykJlELSbKBcm6t/O5ajnER87M7ki9JL8r69PNrMGXW74PP+qb/w4xsli7Zl4X86YlIYWlQIA6FIEY8sD1krD7ILj6r6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GCAvVHTsRApRyq7KIhNCuLhZ9LI6pmQ/e945zeu7lc=;
 b=IqMB4gkuAonKfwGaWlXu4qxlJQnkIZW2uKWTIEAtexBu4P07HyvFK3qXFrY8eCC93Ce8Kj01r2yzK/xhaUOK6NmbosUOlfcvogtagmdj5oWZTWgKuQd+l+jaA1oHjkSFahfKh9SV0YMc53+MtqujJv7gKWMtqyvOr9mUehgyiok=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB5424.eurprd08.prod.outlook.com (2603:10a6:803:136::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 07:20:31 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 07:20:30 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org
Subject: [PATCH v2] ip: Support filter links/neighs with no master
Date:   Thu,  9 Sep 2021 10:20:19 +0300
Message-Id: <20210909072019.8220-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:200:89::24) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc.dev.drivenets.net (199.203.244.232) by AM4PR0202CA0014.eurprd02.prod.outlook.com (2603:10a6:200:89::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 07:20:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0c1767f-39cf-4365-e248-08d973624e1f
X-MS-TrafficTypeDiagnostic: VI1PR08MB5424:
X-Microsoft-Antispam-PRVS: <VI1PR08MB5424E3EFDA34D39DDAD3EFDBCCD59@VI1PR08MB5424.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGntXX94Ni9a5XprF7sg4FRT9eSVliaJxB83extaB2p9sx/MkFi9IXF3Hx1YPpgzpSuL2A2LkYlGh2FAt2WOFocVW/KRD+B9BzbR8kVnnoVwVWeIPJwGyHh9w+QCYX53y/3h5hEw7O/v0KGSMaZsO6Bf/VIsIKKJQCJvos6gYv75LMRbm+6EcEOOCcd+s8qQv/keAwvx6WatsNhRv3mifA6bp28vL5IICmtS6kADVEa5xdNutvVFG+pwjBv6hRJhBIl5ibP7DcJnsSpBDijLFNQZAaMBzjoso6A+wTTzF+Duja45NSi+2H+t823lMnOupDzgSyzR9gXp98lhlX0rRLVP45f7iKDgZY8KgsXKE/N0cW0YWHo9OFN8gaQy9+qz3vCTvH4B2HXP7faDGeo7pGPO8ZGTbuzRudCbuKfIcgUvcv3I+n+CJVKuh1Awh2oJBatUtf/WP671tC+/VDQ5ItizBEkm60oYzsZamyqjtDViMPrmA1x5bGooZ8Sik1q8IhFexOAp3MsOggBVObhdyc+qtOE0TfCj9uHTmgyPt9BXTytNf+0KaaTHJ2KqmhRXMYp0RsuI3MJ9ZBmhqwy2ZXFPBtt9d3gUmD7eyZ1uqga8IixGzzEHvDiDZl7Sz4wKw75FyFvDk5L2eJOyaAhozKpNh/NvA26ORaC35b2GV7+950X5WpQbiGgnUQQg9jC+RxH+kKRMUQ/BV22IzoL1zsiTZENMbq3FYdGnm5s1FsE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39840400004)(366004)(376002)(136003)(2906002)(1076003)(316002)(6916009)(956004)(26005)(2616005)(186003)(83380400001)(8676002)(38100700002)(6512007)(38350700002)(5660300002)(86362001)(4326008)(478600001)(8936002)(6486002)(66476007)(66556008)(52116002)(66574015)(66946007)(6666004)(36756003)(6506007)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48r/c7fRqBLzrrxeQf9b93BjeikO6bDpIveRBN3mwQq0Zf9Lg3bmqt1mjywX?=
 =?us-ascii?Q?FmcTPzRDjMHNATlng6QOGNvynLZ2Z8hILAmvpRAuUIGn2ZDKbh+C/fSVVQka?=
 =?us-ascii?Q?p2zuBbiRD+Q6VXJaCjmI8MsgZNJxSS+O6+ICx+ocmr0pK9lp7eBoUIIWBIig?=
 =?us-ascii?Q?1xdX88enp7ix7Vj6TdZJxqSndxD9XTkM4EmJjSWSHSJB2XCcIsTpcnE3AMwk?=
 =?us-ascii?Q?AoSVSmgbTKuJsD7HRT0m5fruGJRpWPN5HOJvhhEHjPd7/uLGdHLTM/Fgayje?=
 =?us-ascii?Q?cSi7S4s7U77XCL6LVhb0aIdAfBaKUOLEBSNp1xk/hFlp9KC5NH4hJRMz5Sh0?=
 =?us-ascii?Q?6y/1jiveXY3h7rzD3Pvr5s09+SMuOFQtjjS5BDia4rveSvSmsDuaDe7EKnpN?=
 =?us-ascii?Q?6yGkxPiFGgOQwr6K/UoGbjk1+AeHDz823wwwarqsw/1rm2pdkj8XNjSQuLgT?=
 =?us-ascii?Q?ETFi6F4a44w1GUuzFRP4TLMLyoalTRIz9etQCk5M+7gH6T8cEXcxQWIih2KP?=
 =?us-ascii?Q?Q1tqEQDSVd6HZaNrfi3e1IG5D/M6WpL10IAj4eTGw6ciSu7jySlgqVVD5Ugp?=
 =?us-ascii?Q?Og3TuuNLoaqo1T+CI/6/BXF1ZVVHYz105JNC+YWSjpx6XeKRdx6DrLkF6m9D?=
 =?us-ascii?Q?jJ5QWKcFrEwWsW6q5/7MiDFzRflNNFTL2tpe4xG2v5QNo9zSeS/utBm3AjdN?=
 =?us-ascii?Q?PzkC0082c279nb3+gYDKOWUaQjnjZhZoKxv5QL8v7Db2GLXsjHZzLutSDJDx?=
 =?us-ascii?Q?fXd4J5DYAVD7FIyCsbLR99IItPypBcpHYzWP4qNdy3W/iFOe1/jc4acqLY5X?=
 =?us-ascii?Q?2gFhrrkwc4oCvAnvUjyx3tbAmSKqqrZ1QOcJcfPUGYxkq6s1S+Uf8gFbgVUQ?=
 =?us-ascii?Q?+0C666Q0USG7o+5JLyrfDUXHsBz3IF+sK7bRAD3BTy7ttbfz4LwF25bHLxdv?=
 =?us-ascii?Q?9zUHTgATJcOcI+4xwCBfmiq4ucXp2pOe7sV8Ps+gWCKoTXXWXJkxhH2bcUZ8?=
 =?us-ascii?Q?afKMKamZQBNCdWgxboKu7QLsLr8EZ8ebO3ZrvwauDZQxYXyVU6M94GFWHLRf?=
 =?us-ascii?Q?VA4FEr75wW4gnbj5nVwdIpakYSEhUkprsosRrDn4ISy54Cni9Jnw3nz9bOhO?=
 =?us-ascii?Q?lH8O/eddfxZ3MKsEK4m/gZ262p3BXWvVBnGEDtYp9ha1eELoJfsxFZR6XJdI?=
 =?us-ascii?Q?v7QZbDNYX0Dagk4/RURvp04jiKaB2VLafmhxwzflCOq6ZHCviH+KWrNKBawt?=
 =?us-ascii?Q?gCbmUKK6FOJh/+Z3/eWr5K7wX/fnVQRvOteyrt3EHIxrhQB4godKmHo2uCEp?=
 =?us-ascii?Q?KgambCR4r7jTYJOhunFJcTxW?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c1767f-39cf-4365-e248-08d973624e1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 07:20:30.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mog1gOs3VIX6OBHJK7pG6+EGxPO7pkLLEils9Q5UG5UCNFXF8gCeoFC9a3dBe01ZYB6FCz7qwALziMrpr82MWimqi6OZC18VK8QnW8ID83Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5424
X-MDID: 1631172032-vdOzkswCGyEb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3432bf10f17 ("net: Support filtering interfaces on no master")
in the kernel added support for filtering interfaces/neighbours that
have no master interface.

This patch completes it and adds this support to iproute2:
1. ip link show nomaster
2. ip address show nomaster
3. ip neighbour {show | flush} nomaster

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
v1 -> v2
    Break long lines
---
 ip/ipaddress.c           | 3 +++
 ip/iplink.c              | 1 +
 ip/ipneigh.c             | 4 +++-
 man/man8/ip-address.8.in | 7 ++++++-
 man/man8/ip-link.8.in    | 7 ++++++-
 man/man8/ip-neighbour.8  | 7 ++++++-
 6 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 85534aaf..4109d8bd 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -60,6 +60,7 @@ static void usage(void)
 		"       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]\n"
 		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
 		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
+		"                         [ nomaster ]\n"
 		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
 		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
 		"       ip address {showdump|restore}\n"
@@ -2123,6 +2124,8 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			if (!name_is_vrf(*argv))
 				invarg("Not a valid VRF name\n", *argv);
 			filter.master = ifindex;
+		} else if (strcmp(*argv, "nomaster") == 0) {
+			filter.master = -1;
 		} else if (strcmp(*argv, "type") == 0) {
 			int soff;

diff --git a/ip/iplink.c b/ip/iplink.c
index 18b2ea25..bce3da49 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -120,6 +120,7 @@ void iplink_usage(void)
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
+ 		"		[nomaster]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index b778de00..c29325e1 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -54,7 +54,7 @@ static void usage(void)
 		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
 		"\n"
 		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
-		"				  [ vrf NAME ]\n"
+		"				  [ vrf NAME ] [ nomaster ]\n"
 		"	ip neigh get { ADDR | proxy ADDR } dev DEV\n"
 		"\n"
 		"STATE := { delay | failed | incomplete | noarp | none |\n"
@@ -535,6 +535,8 @@ static int do_show_or_flush(int argc, char **argv, int flush)
 			if (!name_is_vrf(*argv))
 				invarg("Not a valid VRF name\n", *argv);
 			filter.master = ifindex;
+		} else if (strcmp(*argv, "nomaster") == 0) {
+			filter.master = -1;
 		} else if (strcmp(*argv, "unused") == 0) {
 			filter.unused_only = 1;
 		} else if (strcmp(*argv, "nud") == 0) {
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index fe773c91..65f67e06 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -49,7 +49,8 @@ ip-address \- protocol address management
 .IR TYPE " ] [ "
 .B vrf
 .IR NAME " ] [ "
-.BR up " ] ]"
+.BR up " ] ["
+.BR nomaster " ] ]"

 .ti -8
 .BR "ip address" " { " showdump " | " restore " }"
@@ -340,6 +341,10 @@ output.
 .B up
 only list running interfaces.

+.TP
+.B nomaster
+only list interfaces with no master.
+
 .TP
 .BR dynamic " and " permanent
 (IPv6 only) only list addresses installed due to stateless
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 41efc6d4..c0cbb5e8 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -179,7 +179,8 @@ ip-link \- network device configuration
 .B type
 .IR ETYPE " ] ["
 .B vrf
-.IR NAME " ]"
+.IR NAME " ] ["
+.BR nomaster " ]"

 .ti -8
 .B ip link xstats
@@ -2536,6 +2537,10 @@ interface list by comparing it with the relevant attribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to empty
 output.

+.TP
+.B nomaster
+only show devices with no master
+
 .SS  ip link xstats - display extended statistics

 .TP
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index a27f9ef8..02862964 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -35,7 +35,8 @@ ip-neighbour \- neighbour/arp tables management.
 .B  nud
 .IR STATE " ] [ "
 .B  vrf
-.IR NAME " ] "
+.IR NAME " ] ["
+.BR nomaster " ]"

 .ti -8
 .B ip neigh get
@@ -191,6 +192,10 @@ only list the neighbours attached to this device.
 .BI vrf " NAME"
 only list the neighbours for given VRF.

+.TP
+.BI nomaster
+only list neighbours attached to an interface with no master.
+
 .TP
 .BI proxy
 list neighbour proxies.
--
2.17.1
