Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0566E68726B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBBAhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjBBAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:18 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D82B74A52
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsiNOuT8R3MaFDA56o/3f987D4pAwqAamf+TOUdEdmbydV7LP3i3v6J5Oe2Fc2ZfIf/fu3dGQoLcai4EZN+IS8skmyNMZiWCwQ+LssaAIa6touljDkf89g49zT4D6H96JrnPTn+Sbs7WY8899YeqxHqGzi2rVkFP9yZiEx/oPTooMb1lRIKz+sBH4o563bXt63Xx1lZWtWPoNOKUravJl/uatg0Cloji0EOav8uJxKiQv+VXxgVHyTRAxD8faP9fXnvBQcaQfzDRDrlMi+RcW2xIHGYjfl3osyqZu8Ehrd9xnSbVKj4WEDWTdRALeYvsLR2FDKlR1mPHoLW6sI/0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMV/ySYwawjmBB8IVm+8r9nGNX+h+koTQwiiBtQnjd4=;
 b=VpB9raOL6R1zexxOfPT2twys3fPADdOVCKDJ7uTOvWgA54ChVFdnaitlfNdUOW9Z4oGZp0i1by5aEtyC50P5Mehnz3FFcmBGQwDq4kN4L+3MtfFNM1zHCKym2vX58H25xTy7xw0NxKqlAzGXyl8OEttVhyyJOaz1KQKYfLRtjjuNT0QyzblQlg77ovn1UgvDs+vDpoU9rLSoCP6kwNRWFAV/mVOiylCyVgkhV0e3zJ0JTPDxk7tDtvz9pbHKdaia+DvNri9zaM3rc1H4Fxfah1zEzl+dUGATy14xLxmm7PZ3yP2k/GaFT7DvniCwljoDlk2XKlF3NQeHev8f11TJvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMV/ySYwawjmBB8IVm+8r9nGNX+h+koTQwiiBtQnjd4=;
 b=F9vNOOXErVBz+U7/PEFud+0TdOwZ/O9JtmqLOf7KD3Le3a+wjfdSpT8meuUvv0Dg93+iIGXddsW7c8zaNLeU3XsxTc08uyyGKPfiYi2ykRxjx+CTDySgRNiqR7fe9amALk/ZTU44kilgGGBtn5utdzl7UMP4fUGcug41R/QHVZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:37:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:37:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 13/17] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Thu,  2 Feb 2023 02:36:17 +0200
Message-Id: <20230202003621.2679603-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: cd14cc1e-d8fb-4db3-688e-08db04b598da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDhTX2FXlDUcxWnCusi/gXDW7V6BeOfSUmfzdL+rTLxM5wTvvcdCUziJ88rDPTKH26hPiIkTf8SIkWsGvLxJ6W5fCp+4oTtpsMQDQGvCo6GiIQj4MaV/gEHBgKEbCm6PaUlfc+Oq0TNuPyG7u5Vzqr44zTm0Bh4gohAWNU6DM2yODIlQ4E9y1n72wKF9duI7ZC9dVBAlxVeeo89IUgx94ZmeFlq6YBw5ybOduyAjENg3nYMh6krhL5ip2sT8fKmDfr1SwCBSwXedJiZ0chqY/SfEQOysnm9U8dYDyp2P9cvbKNeHEOONww6H5BLkdBQQU19nLE11RTcHcFxxie5kzbxbQ4mbRFBYtExIGaxqoZZd17eM/3jvx9iHz4T1SLcHD4CW8T34wgDvMz12sr97gR/M82cDkwbgbtVYyDpEdUPdfxUoY1zA0qBtXVqPXlutzZDn7mAm2IlGHB56NqdvCCD3lkVUpQMU0sEwQuJovpAuXYMwSDMB2RZSUwOa8h8NvJUlGBepeJv45R1Zo0+ikK8yweM8aspgfkVA3tl9vMrpPmM0xmKH4UK1btJ/8pzr2ZF4TnI6YvxvflD2qoEoeUyFVTTF30ifBrRD9SVtlb98i7WkMrIKo2dMv2wOs8J7ANGN/vBebdnfg3VGAtSstIIwBLkg955SKeBkJbqOStixGFP1IoJYeacJJBQd3aor5OrHXE19b7WNG1qvimgTLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bsp6e1t67bZmJWa1fzgAThf1KiqaNHXzJCx9hJdjEKt/rvpBJ0h/PW5usEwA?=
 =?us-ascii?Q?8TfyrEYp4RY4AZyjUd4BJBJePvinDjP8iW4Qc3VqTjoKyo71YQ7b2gdHSs72?=
 =?us-ascii?Q?xkiuyr6g2d+jUfGgLTXGl6GBwo3lePMlog051eDmHmkgCV1sYcyLTzHQGMlP?=
 =?us-ascii?Q?O/S4QfJSo5ab6NGiA6zqu5AuJY3SFj15VS3+lQUtwzHW7bZl0EK0QnuTomZ+?=
 =?us-ascii?Q?cqpjHAUzV+L4pwatCnBhRJuprJpjNILUsysUFaacd/LEI3NTHvl5LQATNMSz?=
 =?us-ascii?Q?y+4TOnhmejjkcxJaVPRSHPHjYnPtaQB4J9NHzUNUHvnpYL9RYc5v6eNvJb04?=
 =?us-ascii?Q?nAJHC4hJ8wvNGXCB2bKAgfXOBYhwz76ddDa/BVr7osEaHimK388F6NZzQQsY?=
 =?us-ascii?Q?Tbi9mZsYUUTwY+1+cw/KMpEJdvTYEHhdsTXQYNIPwfjMBTjzV0IyeMoiERyc?=
 =?us-ascii?Q?5KYfE28Hq067c26IIpjcD3aLnc1Uwsb9ceGmLaSRypy/o2j+V1e7KWrLtbAL?=
 =?us-ascii?Q?aE7A60ZURXm2qoV1k70fgDYwycK4+VISGn3FN+E+QxipM3b77Y7o8d7T0GvD?=
 =?us-ascii?Q?cnvcPqZ1b1vo0zDDNuqf09bmywLYgR8Wa44LypcBlNC4JORoMJU1IOrosKc7?=
 =?us-ascii?Q?Bk54lgLBpQjI2k9hbEVQ4dULdmrNPjt6QHYGylafD4cqGKyNp8fhY2mJBJf9?=
 =?us-ascii?Q?4T1Mcr4aPVu57CTQthB6ZHcEdOxN2Rvbnm/kLp4rKK5bUaTmyXb78fbHbjyS?=
 =?us-ascii?Q?P0ikiCvGML1ECcCsi2KjkAe/4uB3O3HMG7LkwvX2VPIev8tbF7ryTmNcN1xq?=
 =?us-ascii?Q?CTms7ioPcg0dHE6y4qjg5fzHLzMe/eCsv3qQyhugtG0ubAF7j3MbBhyZF7dP?=
 =?us-ascii?Q?c4kZwWIEDPzfzUvihi0HyHpkz1etLRWPlUK50wPsZ2ypXPcLgkCqNyrwyYwl?=
 =?us-ascii?Q?AP1bRXG1bf2v+8F0tXxqKaLgI9BWWdN7MTmnRQKntTmQIl8792OgPZwHOrN8?=
 =?us-ascii?Q?K4+sQp27Bj3nP+Cu0X8El//A3pvgFyRThbYehndCASgApNfrFXRNLAnpUWgy?=
 =?us-ascii?Q?ZgSrG+r8Dkmy0JaynQlXhQ0EsoLxjEr91nTRLY+Z/Du9VXnIOZQtHfO5Qfp0?=
 =?us-ascii?Q?NDTp4AUD+CwjHS1iEQhnx2KOcIbmSiE4UFw9QdahIivrQeWDd+AAsdyxEIPw?=
 =?us-ascii?Q?gOONAGqbYzI9qiChB80RCKisto0IXfkRbBOwbHmjIC4BUVHzorh1foEVWKUY?=
 =?us-ascii?Q?mokvO1EdeWNbA1FOl7fMRDeiocur5bwcU4dYH4kt24BVWTvH7zmOQea0Jlv3?=
 =?us-ascii?Q?M/0lJ7mdVYsoyE+GVrAhjEa0WLOVidS/iaJIBHLDbg5fe8te3pQh9V7TzhpI?=
 =?us-ascii?Q?V3vyh2jzzpEnSWZAbxVLr/GrfCsrIEHDwG42phH0xxtx8CnW92k6NKN7QPnc?=
 =?us-ascii?Q?wGDSMfUNED6lWEEiBzCOvaEt1Q5UYbXoHIXZoi0IXsieC0mw99JoY9P4OIiy?=
 =?us-ascii?Q?y+k+QgSugY8VLeGH36Nv4X1cgcwIUiasFlwMwFBYEBjgzbSXXaPqtDnKpz87?=
 =?us-ascii?Q?TratG2bCJ/6y7k5GbfN+aD4lxBLk5IJJwIr3r27NqrklC/Y+Ro7zVcJOXTFK?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd14cc1e-d8fb-4db3-688e-08db04b598da
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:37:00.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLAqybU8KgV5M2A15L3lv4OqLU/qLmmQ5j085mPRnI8g4wvbCRFEtFKIvi2u/ZOlUVlWNbLE73Y4QC7l0Fy0lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio qdisc does not currently pass the mqprio queue configuration
down to the offloading device driver. So the driver cannot act upon the
TXQ counts/offsets per TC, or upon the prio->tc map. It was probably
assumed that the driver only wants to offload num_tc (see
TC_MQPRIO_HW_OFFLOAD_TCS), which it can get from netdev_get_num_tc(),
but there's clearly more to the mqprio configuration than that.

I've considered 2 mechanisms to remedy that. First is to pass a struct
tc_mqprio_qopt_offload as part of the tc_taprio_qopt_offload. The second
is to make taprio actually call TC_SETUP_QDISC_MQPRIO, *in addition to*
TC_SETUP_QDISC_TAPRIO.

The difference is that in the first case, existing drivers (offloading
or not) all ignore taprio's mqprio portion currently, whereas in the
second case, we could control whether to call TC_SETUP_QDISC_MQPRIO,
based on a new capability. The question is which approach would be
better.

I'm afraid that calling TC_SETUP_QDISC_MQPRIO unconditionally (not based
on a taprio capability bit) would risk introducing regressions. For
example, taprio doesn't populate (or validate) qopt->hw, as well as
mqprio.flags, mqprio.shaper, mqprio.min_rate, mqprio.max_rate.

In comparison, adding a capability is functionally equivalent to just
passing the mqprio in a way that drivers can ignore it, except it's
slightly more complicated to use it (need to set the capability).

Ultimately, what made me go for the "mqprio in taprio" variant was that
it's easier for offloading drivers to interpret the mqprio qopt slightly
differently when it comes from taprio vs when it comes from mqprio,
should that ever become necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5:
- reword commit message
- mqprio_qopt_reconstruct() has been added in a previous patch, to
  consolidate existing code
v2->v4: none
v1->v2: reconstruct the mqprio queue configuration structure

 include/net/pkt_sched.h | 1 +
 net/sched/sch_taprio.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 02e3ccfbc7d1..ace8be520fb0 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -187,6 +187,7 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
+	struct tc_mqprio_qopt_offload mqprio;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6b3cecbe9f1f..aba8a16842c1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1228,6 +1228,7 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	taprio_sched_to_offload(dev, sched, offload);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
-- 
2.34.1

