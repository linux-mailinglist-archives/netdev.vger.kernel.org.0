Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31474E3D94
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiCVLa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiCVLa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:30:28 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2106.outbound.protection.outlook.com [40.107.117.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA86BDC3;
        Tue, 22 Mar 2022 04:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezQRRbfxQz2hdK1k8L+dxHjPmxncROV5oMYY9nBD7GsQRaNnSbNwnPDwpnWMURQfiGn/KrppsLZ3mL/09w2nmpXqpPsWZAV+SlI4aUcCWrBKr46byf2/oGntk2B3WgPoTqca3eBa8CFwNnm4GQK11kdmhO3fu/u/1Tv8lmqFDl6HRFTPRMn5jlFMeY0SB55Qi8PywQ0Hc+D32GoEfrkbDJAwg5lEwqOCv0bOKskcoxBQLzdZJKazunLa160VDi/LlOAThCQ0Vt89QRJH8d6+M3ZyPdcLbpUlPtaAVSUoviGKPA4rD/X59xqQvwqAqoYXQn/hyNywArhRfKoJ35X1MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTtdTkg/3fOoFCJF/EaXFaHDdZMfoFjMhuTym2OpEOM=;
 b=GFIUZINwN936eSAXtGXsDrWhXB1L3N2fsrClg+DxDOAToP8nefWsg7cPdSY2mcAITyz4LySvAcj607uKg/22NHl74UpQKLQ/au6pJbOjjpyK6W2cbIiy2DS84KDMOUey7R5oN8qTR9/gnWLyn7jME7vp73TUOm+R1vjU7NH9QExpBVjQDUXkXWKTBvEg4dVQpI+QYHJjrmYYBBratGO25/7TANyoRqSlbDyAH8M3bZvpOZ/85u+qV0L16JaJhQvmaug7U1mKqFRXRYRppQ3XfStZArm+thua6j8EC2wIq4lFgdK78Oa0Mv4EEV5EomoxYdaaK+XOS6vuwFwXgk3liQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTtdTkg/3fOoFCJF/EaXFaHDdZMfoFjMhuTym2OpEOM=;
 b=mR1PqqN26ggjXUjdMGJX+aQL8qFfAPPjBdvEC6bEVARLTxXkQddRFR0PYixQcJvzxPSlRQPq3V3/y06uDb77DJLsUkd3W3fBcpkPKodhtvdrORyfnu4P2cn/QTG5xK1q5ocAwA1kG4SJ1QHVcYPn8OwZAB/3e0POIGwuR3hyOJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by KL1PR0601MB4784.apcprd06.prod.outlook.com (2603:1096:820:87::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Tue, 22 Mar
 2022 11:28:56 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::4005:4e49:1e4e:463c]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::4005:4e49:1e4e:463c%3]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 11:28:56 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] bpf: use vmemdup_user instead of kvmalloc and copy_from_user
Date:   Tue, 22 Mar 2022 04:28:43 -0700
Message-Id: <20220322112843.6687-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:203:d0::26) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7700f824-8ef5-4448-6bf4-08da0bf726ce
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4784:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB47845A648D4896735B583593A2179@KL1PR0601MB4784.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajNp69PLBSWL8+eixlPPgTay2U4cvmOwNYEX/CLfYcfA/IJdCPmlSqKyfypd40sDyLBWKqljoyTNMxKppnOzmOZPb5C8IfkZsjjcipFsJtFuyl2sziuXSnW564rgVW2PXNqxpfX1TYjcKthHfZFNEOCW4wZqZKzkDA27of/gcIq4fxfNpXjyhpRpIsJcTQ+NaSgiYsIj5fNIa+HPV4rD3rrnfciNwlDIxxcXtlNKABj7Di4QIdX90+tUM2VcGqXBNail9NSVSy/otWjcqKsgnKOVVLyHJmTaqfATEX0gUVutiHVvn7XZJrVMqcECvZHKazfUJvubekmltz/3fBx0X+Gh4gpMoCMdjJ1bJqSJCX/zYBlmN78DNNLAJRHlpZp0v1JF+RGyvUzEkRrOdk20XPrdKy+tgcsJj85uzTzOnRCd66O9XTUKkbqHuWJT2klrTNbdIvn9E8fI2lkmwaR6HLMDsROYKP91EKXRB4I1QtMyBD+IXl2FyS1ww4hE7E4u5jwz8ebLjgugJkAGLmlzeTJRHGS8QOpHJb2jgzgv3G2NqH3igiuRhRu9ZwbgT5wiwCP12SnKLvxTtNdc9PtrHRvCqu5bbt1vKoPFUSx3iXrrz2LnD245c2SYV4Itr4mdMPOElfN4AgE+ax0aKn5/sLeAUY5k6kJeaRKzSIXWfd7bEyHMyrKCmlIQZWxS5/uWLxQVlgdZj4p23Mgw3p5v3bSabmQPPCXPrDXfRMOPkdc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6486002)(66476007)(66556008)(66946007)(8936002)(5660300002)(4326008)(38350700002)(4744005)(7416002)(86362001)(38100700002)(921005)(8676002)(110136005)(316002)(36756003)(52116002)(6506007)(26005)(186003)(6512007)(2616005)(1076003)(6666004)(83380400001)(107886003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GiwhIRuGWW8pDAp4xcieSULyU+iZdVq2XHRGD8cqn8IOd/fcWNYDYpUPbkbj?=
 =?us-ascii?Q?nVgCHTnnQyvmuJnVu/0Gqe8SS7JLwnv6wvjP9drzt2el4Jssn5qWRVavLp0r?=
 =?us-ascii?Q?pFBJVJgKgogV3dMyGSJaDVOSyy1aOcVdylPU5Ax+NeFzQMDSH9o9/uvZObUF?=
 =?us-ascii?Q?8if4AsFnaSqnu0iIbQxN0A+VOZVXdpQDvEPDKqf9W07A2v/rqRoStir/kmcH?=
 =?us-ascii?Q?zaieb9ejoZ6mCztPlV6BK0JH2WtPYRdQEOvE69aLiVesVP4eBlCkF+9nc0HY?=
 =?us-ascii?Q?9IEd1eTFwirUXxnbmCKeEOIWFzoZkkL/1G83HCpVVpXRHPlPsA+qI/StjC1P?=
 =?us-ascii?Q?9nQ6sb0HZMI392xNzHrSrEmntBmmWyPPScIqehnA+Wdm3ssw0cHj7V0LsCWI?=
 =?us-ascii?Q?lzBhelt43Sz/PDq2+7CnuitZoZPYI4IcX0Uw9Wu/1gI0juGc4D5AT5EhWtQ9?=
 =?us-ascii?Q?ts1T0m0k9sl6Pc43Bc1RGkh7W8g2lNdoAhqa168n1D4vsp1TKaGHErzrZ/Vj?=
 =?us-ascii?Q?gQ8oFvuD9p6p1DzTlyOEC2INf6ofvvIbyaErFi0mQI8jqFH38ZxQ9J1qQTwX?=
 =?us-ascii?Q?NqdqkcPqI12wIPVf8W1tRBW64KRhkFR9jRF2vm3fZjHQaJncIa68m9SN7sj3?=
 =?us-ascii?Q?lm5r1o6E7zFxR4skOzEtjR7DhsiezCqxxSibn7t+BX1N75F7HkIhMbEsgNru?=
 =?us-ascii?Q?BCRX/tC0la44hWOhnEmfUXtZtNPGsTXFkd3UmUuuAyYTUDMnHDLKYvIY8Zwx?=
 =?us-ascii?Q?vQkA6D1q4I720IKnd8Qb5YRRZwrJ07VwYrzLCNbE3XFY46L9dDu4Zmdk52X4?=
 =?us-ascii?Q?HMlvoh5q6PGqkFiTCn2gc2frDXzWsCJPimz8xVLXyi48AWpgWC2PhZoQ1fm7?=
 =?us-ascii?Q?6Y1WuLvNZlz8rp9AyulNkfwS78A5ldprS1Qq7RQIxo4GNU6TY/okVke5FWG5?=
 =?us-ascii?Q?dG//dPiy9lGiBNPPZu6cbw5ysS9NjhKAFtLt207ywd8Ztc9wI2P20gi37vfK?=
 =?us-ascii?Q?sHxpZJdZ4Apvm6FdpoGpsKj/iU4fjYb+vSWLSaSXHmAybZWV73s8VEasSImz?=
 =?us-ascii?Q?QzCjbJ4BfVv+NzQX+xqvRKfrxEat3oX+GfAy4M5O+HsH4L7z2W/CILIgWcBu?=
 =?us-ascii?Q?N9tGeuG/c9CF5dlEDE8GK2vj21f//uee9cygY7PEfCjq9zvXBn42emygvedC?=
 =?us-ascii?Q?r3w5EQ7u/+YUJmxqT4f5ULKJ/H/MglsaiT9AfYMfKhwjy5aI3zST1GeiEVj+?=
 =?us-ascii?Q?pfx2Q7zZefCAxegGgXki7tVftiqMD12AEIX1BHV5TNZI76vfdcT8uyymq1eU?=
 =?us-ascii?Q?dEjIyoH3crvcnTcTOQ0aMrNs2+uw2asOZfbZQEgbdARGosU3x1oa2PG8MELL?=
 =?us-ascii?Q?fcYi4XHAEZJnRmNeHCocTh5Xj+Pet+zV92mKdGF4fTCXUTLWe4I/robOkOlX?=
 =?us-ascii?Q?+zCJtrOzlc1tUiRF3ZzQ2fKgUt8EN2je?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7700f824-8ef5-4448-6bf4-08da0bf726ce
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 11:28:56.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsR3HnL7VN1cT2DQOdlUEdesRGLiav/ydfm22RLJBKkxWUNnguQ0iwjmHcttb4vhmX8FDfUji5ny7xAnY8hWgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4784
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix memdup_user.cocci warning:
kernel/trace/bpf_trace.c:2450:12-20: WARNING opportunity
for vmemdup_user

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 kernel/trace/bpf_trace.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7fa2ebc07f60..aff2461c1ea2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2447,13 +2447,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (ucookies) {
-		cookies = kvmalloc(size, GFP_KERNEL);
-		if (!cookies) {
-			err = -ENOMEM;
-			goto error;
-		}
-		if (copy_from_user(cookies, ucookies, size)) {
-			err = -EFAULT;
+		cookies = vmemdup_user(ucookies, size);
+		if (IS_ERR(cookies)) {
+			err = PTR_ERR(cookies);
 			goto error;
 		}
 	}
-- 
2.17.1

