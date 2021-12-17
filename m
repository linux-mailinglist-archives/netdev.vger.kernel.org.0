Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6264793B4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbhLQSRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:14 -0500
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com ([104.47.55.176]:6605
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229502AbhLQSRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfO7dwCcB9xkUhH4EGA44I9YpXV0ruptOfFoo2A+oFfcwArLqdppc7spb643nDiYzie1ZvDZYTkScLJ1v/roPwX6TQ2yL4fEkBEQA4iys/aNDrOTdpt4hALhnflgTNUFQy1nhyoaBIXYoJgx+OzyAonDk+6L6APg3S3C/7QsUvN3IlbyTm8mCxIUVK+RSRh61dIFuNDN6BPLrWJqAlnqnUpSx4DUzC13C7v38AQ2u5HOlFcwEi3mxacYawreeVM9/kWgO3ydHQdDUu+oTqulHO03HaRb86X5e8eC6ruhlhZjbuYzAplSCbEtnPgcPnqKbVhVYI/aa2XLIS27lTkvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rn5O01i419HJh9Y89KjhphnbQg7uoh4w1glS4FjXJrs=;
 b=A8PJKups1EZumKyOZzT31H16lsZiVuLsxkJ2gYsUPY+yJBvG/Ls7+aWLws8gQeM7T8/njAos5WmHkuuXXX8qsf76SEL/2JKG9gSG/NToX8zpyDmYIlJT0EwaY9UFTYVbegQstj0WRQGlKFOwOiWP+qUFz2gh5bEXn7sW1sPBkIsv/mxuAVAeXjiOaef8pW2GpqkFqU40JjG8xKJM9GVt1DIrvBlIb+yDAhfInu77wcALKp3QH/0I9dHUZFNkSQHdTtm4rFASgGN4EjJH3bifPBs9iufgnQBpHsJ2sqxtGtwrd+xpG92JM9kiZlfkkH7+43NrSAbtn8aFvaX+v1zHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rn5O01i419HJh9Y89KjhphnbQg7uoh4w1glS4FjXJrs=;
 b=bZiaNbSD3SxGdoBDBQj6unVtsnPQAvsczt47noyJ4pzSkkTOWMpRz3wM2XX4WiHCrexxx008cDfLE4POWLXMYLANBosijtoGRw6hHiUxyUJ5KwWVo/XRCeHJNxxRc72zAbbf1Mqp8xmD9dThUfcB0OgsJBEukgd6+83LSg2UyCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Fri, 17 Dec
 2021 18:17:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:11 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 01/13] flow_offload: fill flags to action structure
Date:   Fri, 17 Dec 2021 19:16:17 +0100
Message-Id: <20211217181629.28081-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4db9bb3b-19be-456f-5c15-08d9c18971d1
X-MS-TrafficTypeDiagnostic: PH0PR13MB5004:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5004A6277AF4779CDFADE2DAE8789@PH0PR13MB5004.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:179;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34KUeSZ9GVa/VPMyg44bihwHp2zNRq5AmxGDRMNO87Q1+y3n+uCgK1sIOEKPL8YyDjdLUIJQMKJYnuX1RlydXjuujzKN1FzcS8WVRVS2qBkzB9rSTy6lx399f4M5I4u/npvN3THeXwhbchgeyZ6nq24p2+7J0jVhzvo4SA8pX100od2ZxsdkLjJdRJqhAj53r38YpoeRxVhoQe0AvQWrijCUykPiRStjLYtIqEpfDKoftoJronIR2uUmfSnT6DIkmLEI3gbKwZBRV6JYhMBOeeKaiHS5oLfeKnifjOHwIyMb2pFpaDKh5pzuEWqm+a7xaQ2P/aviPi1ERfNPU5VfmvvXyEEUn67px//aksyFFeVwMBFvvklbH8X4qSO4ArvWBkziVOrWBLh/WkbqPImXtrFSId8Tr0biG7frYUja6qWOw3YBP5R6Ccku3Ma+ERmOUcx6f5aRJ9H7cvmIE+Ll1t2y/+ZiwU7eKOrJgbhRTNozqvLYwDnbblg7jRTCSgzi9Xki465b5fDZvcUUK0de0aFCOu2HfFGrYtQzfvT4IiUjavFDWgYmMIEsVh7uMAKHcVCq0IxR4aixF216fN75gEJCAyQLud69QqsNmFqVKMff7UpQKbvR4R98Z7qBN+noyE2OHLF6ctSj9nsPvV8v8aqb4OL5xOBfhjbDfISlkvHHFATGo4O+WRwWnrp8tuTp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(346002)(39830400003)(376002)(366004)(508600001)(36756003)(6486002)(7416002)(5660300002)(186003)(6506007)(38100700002)(2906002)(44832011)(52116002)(6512007)(66476007)(83380400001)(8676002)(54906003)(110136005)(86362001)(107886003)(66556008)(1076003)(2616005)(4326008)(316002)(66946007)(8936002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLsNm6jpoE47K0Xe/POCQqQbKTS/Ohx2BzNxpqYu9mNyH2x2ALNd4ZHI5NEo?=
 =?us-ascii?Q?hCG9I59w40c5YIiVRlbXKkEdko6Cd/SeXKfspQu0H8moIDJAHMBGP34Ytsmf?=
 =?us-ascii?Q?uNIE7uMXvzsb2JXRhVQiXtW7vfGbW+BTK/kr3jz262x1GHApWNLfJrSSk8wA?=
 =?us-ascii?Q?MSlfrOhF2CQHd2/Ne2zyn6fAEUSYK60d24ATSglycD6/bY+f6tHGWgYqKtwx?=
 =?us-ascii?Q?y1FtN1Xc6sXyNsDLbSgUpfjO5Ol1kFgJ55GR410VSFXm+b1RaE4w5EnbX0Q4?=
 =?us-ascii?Q?ZwK1P/R8y8mKQvLuI7ijB4C5T4c5KW/t0Jb53PwGi5bBU7DbJ7CorOac7wML?=
 =?us-ascii?Q?7kAZXODSh6g4w2SWG7bT2jVOzalEgKiJIsjOUF87zJ5noGHuzglsD3m813RN?=
 =?us-ascii?Q?aR4pLBgrMYGX7YcttvEkfatKCOlzSQ9cW7d+rtAOrKmRe0/oIzmYIp6HcW4j?=
 =?us-ascii?Q?rUG/vPCRoYsPUcfRnR2cUN3gvwUG2Fby9UIaLTT7ylXlg0eMKjBB6bEWweZ2?=
 =?us-ascii?Q?SPr/Ol68nWyIIXt6iBhnafUjSC+69f18HN+lOscG958VrcWTlWFIZSzdrmkv?=
 =?us-ascii?Q?O8OmD7gDyL3ujhgYJvnJrfMeOAz8gMDjHb7aGUG+ERrxSERtQ0NYbmPyQ/xQ?=
 =?us-ascii?Q?DnIjV1usb3yye+uUeSEORCqgMULB9L7RGMHLvc6TWXQmjU6Rkv47tg4qs96L?=
 =?us-ascii?Q?DCbNKkcIAmFrmUSvD+afJrN7zDIcqT33a3RiqecHL2VDN3LIH8LAnV0wY6d+?=
 =?us-ascii?Q?ZC5A7HgYQrTjeYRvHGt6A4hbS5pmmKCx5w/ESTPyZsueq2pTptHYxCoJlSLU?=
 =?us-ascii?Q?rmD/IaWb66xEY6qq9mAKQsDu1mJFUFZOW51eLul5yfVF9PlpVmV2TOxsPGBK?=
 =?us-ascii?Q?1oXQLdz0Ek3NOdBGtu3nV8eMyQRWdDNx/Svp9vyaXyXfvxbvt5iaw+IaIEVB?=
 =?us-ascii?Q?Jkl9cbSEYAhWp67llNyO0GRnlQ/g4BoxKR33hBNSPv9Khbiii/lBONHKF6nx?=
 =?us-ascii?Q?au0ySumRklPgnejQ/eWvJ9m0jcEp6L5FTqqa1VDtX57xNr0le5MC0iPkcDWS?=
 =?us-ascii?Q?eKSKIu5+Q1dvnciiHMi2m7leq3+LxffGbxesmHZj35POKSuv6bnD7aMjv4u0?=
 =?us-ascii?Q?McUvAp7itjugW4ljR7dsh8JLgT9Hd0gc+Qj1ugwI+iaF9iyc+4dNhOTO38Jj?=
 =?us-ascii?Q?Ew3vinsNJudTeHSONGQfIv13dFjZX/DndO++IEKd8M8U5K99OnGYz7crzuFD?=
 =?us-ascii?Q?4ZWRjS6PWs1DPaIOncEzRt2pZ3vysfc5n30mh+2PDZ8XNAeTOm+0dT0k8uAp?=
 =?us-ascii?Q?VD+mUTk3xVYmbW72Qf5KEdILbkGegKuMTHBUuzZUOE2fnTT5+p/nz0mMwMck?=
 =?us-ascii?Q?eoct1WXthwxjEvE3Hlgk3Yt/mrM9eWJQZ1KM9x9z9eX5GGZHmwFKYaRRnKFd?=
 =?us-ascii?Q?PWWcg9qtYkD2Ta6S7AT1ILz0vRjBEmtd5h/2nhxSrI0JDdx4i+RFvWmRwzaz?=
 =?us-ascii?Q?GVI1ohlUZJLPS4mxwhn7C0RT1cR03VNd2H0p33ZvZTHYHa1NqZUaa6Z8ixSb?=
 =?us-ascii?Q?PkOAqfGGLgeU5ZYcw/arK0VPFSwwW+83TB+/0AzG6kzHepLeSuxOP+BgPXzp?=
 =?us-ascii?Q?Gsqm59/cDRgcO00no++SxF0R9L2ildxM9TKtpySTNnnmptgqNvKYab68cKny?=
 =?us-ascii?Q?pLUPSYFaVTZKQMsuBZGzwQGZojUHy/hSbBUKv3bXmsAtlMeg6RaJiIWmNTeh?=
 =?us-ascii?Q?gcGcpXqbObPiNK+OfG6vE8hPvvpTmFo=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db9bb3b-19be-456f-5c15-08d9c18971d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:11.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1TKGA1+N6/dMnLXhtXTSzNcTblP0O/Q3AB3stR/+OklQX7onOJD8hgRFylFei06Oe8RWsU4Ta/pZUGwa+9ztId80Ryt1WG7ddO8wBwuevk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Fill flags to action structure to allow user control if
the action should be offloaded to hardware or not.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_bpf.c      | 2 +-
 net/sched/act_connmark.c | 2 +-
 net/sched/act_ctinfo.c   | 2 +-
 net/sched/act_gate.c     | 2 +-
 net/sched/act_ife.c      | 2 +-
 net/sched/act_ipt.c      | 2 +-
 net/sched/act_mpls.c     | 2 +-
 net/sched/act_nat.c      | 2 +-
 net/sched/act_pedit.c    | 2 +-
 net/sched/act_police.c   | 2 +-
 net/sched/act_sample.c   | 2 +-
 net/sched/act_simple.c   | 2 +-
 net/sched/act_skbedit.c  | 2 +-
 net/sched/act_skbmod.c   | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index f2bf896331a5..a77d8908e737 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -305,7 +305,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true, 0);
+				     &act_bpf_ops, bind, true, flags);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 94e78ac7a748..09e2aafc8943 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -124,7 +124,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false, 0);
+				     &act_connmark_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 549374a2d008..0281e45987a4 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -212,7 +212,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, 0);
+				     &act_ctinfo_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 7df72a4197a3..ac985c53ebaf 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -357,7 +357,7 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gate_ops, bind, false, 0);
+				     &act_gate_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index b757f90a2d58..41ba55e60b1b 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -553,7 +553,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true, 0);
+				     bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 265b1443e252..2f3d507c24a1 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -145,7 +145,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false, 0);
+				     false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8faa4c58305e..2b30dc562743 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -248,7 +248,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, 0);
+				     &act_mpls_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 7dd6b586ba7f..2a39b3729e84 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false, 0);
+				     &act_nat_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c6c862c459cc..cd3b8aad3192 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -189,7 +189,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, 0);
+				     &act_pedit_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 9e77ba8401e5..c13a6245dfba 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -90,7 +90,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true, 0);
+				     &act_police_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index ce859b0e0deb..91a7a93d5f6a 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -70,7 +70,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true, 0);
+				     &act_sample_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index e617ab4505ca..8c1d60bde93e 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -129,7 +129,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false, 0);
+				     &act_simp_ops, bind, false, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index d30ecbfc8f84..f6df717b9f17 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -176,7 +176,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true, 0);
+				     &act_skbedit_ops, bind, true, act_flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 9b6b52c5e24e..2083612d8780 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -168,7 +168,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true, 0);
+				     &act_skbmod_ops, bind, true, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.20.1

