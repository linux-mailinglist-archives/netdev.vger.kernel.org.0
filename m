Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44E4542C7D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbiFHKDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbiFHKCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:02:51 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2122.outbound.protection.outlook.com [40.107.100.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9851451CB
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 02:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZAD4ipjnCDsdb0imuR46bUVRwfxmGRpG3R25bfq+zwsvz5YB9uyMhPSNlKIe8L2mquxgKxoSMg81faCP/XoRjdAWkEhbKyiXOLa+k/PSvrVYQ1iBReGEVTrvTXkgGVW8CXDGgLQsdnPHHfmF/OeofGXY/a3mEgJdb0u4ctKT4+EWpznDfN/QSt+wNNngycbJv3wMKmKdo9xFHK1afpL4aDvjmxwH7H7gtmPTQSGW78a7MxYmh/fy6J0sRIYGvx9CCt0skShKfUZ4RhfzBePEika0e90AIAoNDTkMUkzrUUz8Lqx2y81+Ap0Vxu7N+3/hHEm03e/8NgNz3nER6/1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rstB7Nf5Y3W5vCoC/tuNY1YReZNxbPamTP9T0FYxnwA=;
 b=dnt5w04PoPpGPrt/IKtH9XwgbBS0YM7ul85Fiyqg4YSbwefg1aViTURHGRuWGPIUPn+6qTkROy2hIl+xfRZq8Uv+bx3GPnVI3HHXFU0vVoLMEfqsuXVZf+5BiLNutTvGYpv8VaQXJNRoj1wWnNh1VnX/dOjdotaG5Tr6u0EzlSwiOWLooB53SyU9jxevkDTGdZFzWhlD9AmDLsFfmtZIAEtAWjW2rvjrSPXiW6Y82ez90+vx4M8Bv9wYL+VEbXc60fbXi2fJYcjf34dCILrInD2c82vqH3c5Du2lGaLG9/tP0oigGIC4V0L16w8QtA5Q2VW8N7Ea9WloI3ivkq8t7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rstB7Nf5Y3W5vCoC/tuNY1YReZNxbPamTP9T0FYxnwA=;
 b=POwngO9RxcciEJ893BendN+cs3iMy60eWCMqAp4UNWP3JYrt9jocMl2FH9zuXPtnQA6i+ermmu2b1qHir1maXA8pAqbqOK/6CSlzMAewq647oJGLpcz3Id+4JOdLPoefZmRkjiXhltLvM7g7nDa/zuu9EoI+2EizT/3G28b4w78=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3606.namprd13.prod.outlook.com (2603:10b6:610:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 09:43:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Wed, 8 Jun 2022
 09:43:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 ethtool] ethtool: fec: Change the prompt string to adapt to current situations
Date:   Wed,  8 Jun 2022 11:43:12 +0200
Message-Id: <20220608094312.126306-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0157.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871ab685-ce93-4ebc-edeb-08da4933588e
X-MS-TrafficTypeDiagnostic: CH2PR13MB3606:EE_
X-Microsoft-Antispam-PRVS: <CH2PR13MB360612B948D4F2D421A65D4BE8A49@CH2PR13MB3606.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FcbAIuig+pQ8eGC4BgaR/vklCByHXC5K0Bid2YkaaeUPPCeDVxLRaPWDpiDJr1vQD+Rz1IOBYYdjk6ujjTyUHUUq2wIvOImHdjssPiRJ0F8c6Bj7SVilTmY1EOPta+0+MHUGS1LXW5SbwCKGQBvxSFQ5VMt24wMaS2iFYuyTqYEFgcTwiqGV+kVvVxflmKKaoV16ynGfNmAqKyPLnkL2naa7rBt2hb7rXeOWFOtM+CyuYYGRk8TB3GLAbYtvU8Ba+XM3EKRBO7hjH18voYPVvgemnCJAJ3SRjWnQyH6qwPtF+u8jzV+RFygSX62p6VwX1VDyl8tMzFklCPLFxqL03Qe0G1wXq+DNcXdwdiq58l+Ld/2oYEdSdE2f5agzVwIwxdFgmNhuroNHZI4pLahvwKfxR6WRITUdSHXpGrpvM/n9zbz9ipAnWUmOmv9GFgNhKhypsBvx4pjcrUoujoONYRTFAwVbG7aIBE6yGhZSAE48EStCj38t6PegUfrz/AnD3sJXDPZLzSUj7VS+qEO4abeckYwMDzH2lqZ8VvsvuqyHWR/KA764M/NlF/O01Z3YJ0EFpbib9S/TjkMF/J/Y9Q+FOZk7lJZ6LisH7WGvJPxuDcxne8Lf5TsfxsdaXExHyC1vRbNuIEd23TlDGr12TPbwdL+Ehj1l1AvzTnDavQvcdn70jWdga2yHzpGrCxYk+b/USsyUXG8bO31HvehcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(396003)(346002)(366004)(39830400003)(1076003)(6512007)(8936002)(107886003)(86362001)(44832011)(41300700001)(2616005)(8676002)(54906003)(6916009)(38100700002)(186003)(4326008)(66946007)(2906002)(5660300002)(66556008)(66476007)(83380400001)(52116002)(6486002)(508600001)(6666004)(6506007)(36756003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmSdyUtm6Fn9QbqRoeRSC/ulwollI/3FFwgrJslTnTrcERj+Uv6A2Ysj/Xtb?=
 =?us-ascii?Q?28hBlUG+uXDCDmQC1AXVhfl9kl/BPWi7XYkpSmKeO0IwoR1U3zmyxN0gArpT?=
 =?us-ascii?Q?/zQahSobhJzipE5zvIsLngqvEQwTBeAFEa/ruzIHoXxnL0ZnzHJ9fTma7n6p?=
 =?us-ascii?Q?WU9wFnekW4Chu03LcurS2fof2Dfkfy4k0nl6Ghhg9Qm5MVedEIoIIANMv7hr?=
 =?us-ascii?Q?L1K+U+3BNKY8WDRgVBKIQql9J8w/OuVIV+Did8clxgBU+Jwa227YFl0Jvai7?=
 =?us-ascii?Q?8Jg/OYSinTDvdNB3uSy5HtpOtrco2i2muvWC3zWeuoDg12awZ3PPEi5u6Y2O?=
 =?us-ascii?Q?CSyfvmvM5j/pw8XJDGtGP5VfGK86DFH1bXHX+GDBM7g7YAizPG74j5anRn6d?=
 =?us-ascii?Q?+Hkh2eOfG+Uyi73RerWfyptHwuIxXqC7JtQKLpqLu/43LoN5SrXFJj4GnNbb?=
 =?us-ascii?Q?FFIeCN2tTJljgMFCsNppOYDA/I4OTMvYERpsQRg9mHWDY3Z7PMP1GIIOd0hA?=
 =?us-ascii?Q?BHqnB/8JdhTTOdplWv5qCYfRi0mHpQL6MaCL6qAziXsqYTMB41KJ5yWmK0Hw?=
 =?us-ascii?Q?fCiqNXnaNOOwyOJR7Lf7eT7AQuorpsM63SpktwCvzJwDbMnqDE05TbmVHy5r?=
 =?us-ascii?Q?yB05cdn2N3rc3lsJoQbJGvvwb/hn1GGRf51MWEcynUo9Exy6suYvIeU4Gx0v?=
 =?us-ascii?Q?EXM/tslUCLdlw2lsRe+EOZ2JwnCTWNeqCL914OFllnVTeamLcx9VCrkvF/uj?=
 =?us-ascii?Q?fUmS3EX0XxctkBhKBaYir6pMvReRGiUB+3+/t+KiwwzAoyvfNbeYciBYCZr7?=
 =?us-ascii?Q?rXX1JCp4yEzMIWQMkdX/bqhvWlrMPc2iIzALeip1uhAvS/KFK5lkON62QReG?=
 =?us-ascii?Q?+apYVDRhZdgpPvRk/J2IN0xMeq3TLla9Y3atfnX8B7QixQvMGanx+4D5BqCk?=
 =?us-ascii?Q?5rxb42OMT6PlAiyGWBX4jYbYOe3naHT2ySC1tGCkM1JXdzT0Yf+fO06MNZpi?=
 =?us-ascii?Q?R2Xp2Mc2/QbUYljNe/isM4Twb+9SFzsmoO5CIFuYw2l73zLWBEYiQa02EQDM?=
 =?us-ascii?Q?/cHWGCpeAukLEdZlIq7cCYnoRUhXVZZmLkjCae7y7/HF34NA0S/4D/KUD0wB?=
 =?us-ascii?Q?lhNdqQHkpYKM7BFYotV3a2PPI6XSqL81/zfi6+N4rdTJc5Yyol+x0mgANRAk?=
 =?us-ascii?Q?EOUeX1ecDKpivqDiNAt9u54yrdFdr18pIj42wSDDh5IreuWJe8ZlBxpTSX0v?=
 =?us-ascii?Q?fKqK1ATi+NgT88wE2JoFs0IUVXo+FUcI34GGFKFdZ5PGmoR1q0QG8CFW4GRh?=
 =?us-ascii?Q?VHURgyVG3oE4CwZ7JtHjgH4LVQgIFzxcTQB3aWf4BtFxqi9Hhf3wdeS9AbZF?=
 =?us-ascii?Q?adgdE+ldviuZc7sN82ClzNlrpLu0euaH7dVJ0qiBdPl11nRqGzV8XRRYeI0l?=
 =?us-ascii?Q?I6fWMHv8tb6rHtIpiyNl2Yerq1xwwvRXBYhQ67nbuESEzbpgYYyGZPJ7Tsbm?=
 =?us-ascii?Q?pMyjv+KZdxxuxd85TfVOL6bfmB6YNi7b1E+a64hWNAl7MPNtCGIhdyap9mRn?=
 =?us-ascii?Q?bPEiB8vq5NOUJ60e0r7fRpyD1L6fDFf8pZ+XjqUoihWAuKTrd7UVefyOTW0H?=
 =?us-ascii?Q?vMDs3YSVYeU9gr2YY0RHR8vBlfjTdmz4GeKvF2QtAKR+68RvDYX3w+JmnFrE?=
 =?us-ascii?Q?TiBueoNrezIQYC8cbVrJkyXG+WfvduESWbXVvAEPefJKzqKvlYwwJ+bHCGQE?=
 =?us-ascii?Q?AE8qvmxSSvkZs2DZhAPjwMCU0NMFImVPvZNccje4mbUrjwlpRzcSx+AIv1LE?=
X-MS-Exchange-AntiSpam-MessageData-1: 1FDTwzvWq0briskHnw4FltDY4a3YnKHQOq4=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871ab685-ce93-4ebc-edeb-08da4933588e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:43:30.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCTH1vr3Vl7fx+4rtgVL6gVw/BXR8IA+/w8c2sAWRiloWKyfLfL5Rv0kTHCzQPK5ULN89zIIdDzZZt5YKuGCpTQtiftwx4vCWc9iIAGYMv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Majority upstream drivers uses `Configured FEC encodings` to report
supported modes. At which point it is better to change the text in
ethtool user space that changes the meaning of the field, which is
better to suit for the current situations.

So changing `Configured FEC encodings` to `Supported/Configured FEC
encodings` to adapt to both implementations.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>

---
v2: Do not update first parameter to open_json_array.
    This means that the output of the following command
    unchanged by this patch:

    ethtool --json --show-fec $DEV
---
 ethtool.c     | 2 +-
 netlink/fec.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 277253090245..8654f70de03b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5567,7 +5567,7 @@ static int do_gfec(struct cmd_context *ctx)
 	}
 
 	fprintf(stdout, "FEC parameters for %s:\n", ctx->devname);
-	fprintf(stdout, "Configured FEC encodings:");
+	fprintf(stdout, "Supported/Configured FEC encodings:");
 	dump_fec(feccmd.fec);
 	fprintf(stdout, "\n");
 
diff --git a/netlink/fec.c b/netlink/fec.c
index f2659199c157..695724eff896 100644
--- a/netlink/fec.c
+++ b/netlink/fec.c
@@ -153,7 +153,7 @@ int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	print_string(PRINT_ANY, "ifname", "FEC parameters for %s:\n",
 		     nlctx->devname);
 
-	open_json_array("config", "Configured FEC encodings:");
+	open_json_array("config", "Supported/Configured FEC encodings:");
 	fa = tb[ETHTOOL_A_FEC_AUTO] && mnl_attr_get_u8(tb[ETHTOOL_A_FEC_AUTO]);
 	if (fa)
 		print_string(PRINT_ANY, NULL, " %s", "Auto");
-- 
2.30.2

