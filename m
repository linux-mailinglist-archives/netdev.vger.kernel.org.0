Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BFF4DD71F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiCRJdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiCRJdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:33:52 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2111.outbound.protection.outlook.com [40.107.255.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A9F2E711A;
        Fri, 18 Mar 2022 02:32:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SasJ1egRy/xkYptQxi9qKzmy34ipYHkTE0wfqe5V5g2voumx6pgl32izEzacFnKweus4ZU8WlkHq2ZxSSFYgAx6ScNt3uwCpfVu/D2K/rIJ6PbLmxfzVtyESd+NIXpstM/uMqdQjU0UYky83imd4RZIPSwX8kypSfHIDQkjWpuHe18lauepFxp7Ggrvnz1FyBZ6hVX4cYD5w9xUviaiByIqQvbb2mh/gkH+926oKU345uPEPVujEPxsw/BGe2MuLiSdQ4CESJYnjIhW+hj9+vKW1DHm5TMNbVPiMtsdBFGWOgGSsMNXG7xHCTGvvZubjn0hNJrzGvTI3SRv0/iVJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJ8JUXRC9splI7l+/I8k91c1zBltbWQpfTxc6o5vR8Y=;
 b=hrZaED3qH02egVO13W5FXFMsgR1Sbu0eG19fP/iGgv6zU6dkDQq3vWLsjztfLhQzp8SXm5fghcoVE0kzK3EEN+pRFH01tZLMOBgXdxBc4lHB70U5VmvGwo+7/W52x/gzqZzlLO3gRqiDCi3PygQvInW3Hls3kMhdv3o02BNuP8OSqc2RFzXYYNdSEGHw/0AtoBdVJ1NFgzRf3WCPUfAMcIjUaCPGXrugmVl6FAOXaBhwEFly3DKk7p7pSGGso48znzGIWbaElzBuHevDnVFDvg6Q50CaNkbIzEEKmnh7JRhXEdlIQxXXMmIvdF9yg5Jm6HSOdI3h3R76BjMSsn8xrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJ8JUXRC9splI7l+/I8k91c1zBltbWQpfTxc6o5vR8Y=;
 b=GCHrOykGJ+3dfm6kjQ6hYn1gTtBBzVLkmQq/KVChWr0WjwLrAeDcHfXG0exhAnvc0NkOmQiOdMcqyJaSJC+PzinSqbkEibDYnrfrCAtzjsioNKS1/foA0WXchmae7PgkKl3HO6qr6MGcqOnLnd/9K8oVaK5CyTjNCoDCtuqAEh0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 KL1PR0601MB4514.apcprd06.prod.outlook.com (2603:1096:820:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 09:32:26 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 09:32:26 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] qed: remove unnecessary memset in qed_init_fw_funcs
Date:   Fri, 18 Mar 2022 17:31:53 +0800
Message-Id: <20220318093153.521634-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:203:d0::21) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9d3162a-fd7c-4f98-2c39-08da08c236d6
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4514:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4514722A541A7DF37E17E68EAB139@KL1PR0601MB4514.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ba6KMHix/Hb+4ODpDe5w0kIQCTqE2AQE8C8NhgCdLgwxBdlcB9Uu4QVw30rv6bSAlLbOaLb8O+71yojbugjtdTpBhoZAeFT/VCMGd8+OaGdDGC2ks5vnlpns2OwGTuIQVipu5Jd5Ta1GaD3hx0+/lzZ1Hguz+ga8T0UiaYeo5evIU/InC0ajcAJQmNJgnICNrOVPuI7t6D8GTa3RX8pKm6qz7bvIkTMABSYrM9KUUpfiiu9u+mfmthRlmKsJAg/v/vuLnLQgtkCnNHr5iWYcXrTfE0E9R3pFM1iATpydTXBTrQYiBxeTec19rZtnsQaydcERROeCKnvfJGYpbFuYaVX2MFvDGjh8itlKEgaz+a9imAPsKGH/GXf0X1ONNmYu0XcI7lV0eP2oLqK+C+3mqJDJWlE3O97eAqTtfn7h2MOQ7qA/g6HQIQVpaftjnCDGostmJJh4avAlP171FxBLSMENOxPwZs97CdHlQwmUixLYaTFgCgm8O1ieXIWCE+LoEz8f92lNtMc44SiezCk+ENWwBhzZGiu7A60UXp9eq6N7iG6oW9isiYhgqH0boU+2McNqM3SZo5XecVmsYvCDsbzTf+ilZ9TPjhZKvytpelQ76Z+NrumITLSrzqilmOxUTO8PsOj/qk25JKEHD1rsA+3PooPzf6Wk8oAs2IgWwBsu0j0m/ufq0f99b9ZvBG8BOrBX3Aed1fUjy1pnR+yoQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(6666004)(8936002)(4744005)(6486002)(316002)(5660300002)(110136005)(38350700002)(38100700002)(86362001)(2906002)(186003)(1076003)(2616005)(26005)(36756003)(52116002)(107886003)(66946007)(66556008)(66476007)(4326008)(8676002)(508600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XeLIC9M/d9vQ/mmJFY17775mlOrFD10APym1bQkp+3cgs17YeZFOPQBI8Jjv?=
 =?us-ascii?Q?8FQw3gMXtkaIk5SD74pKp9mNXsfb/x4osyxX2aOruhwaouwJF8GMzWU90OIp?=
 =?us-ascii?Q?/oLJi55OKD5SWPQPgb+gD83IZY1NEJ5glAGc78SfmskMqUMsRtDMrRBe1lvo?=
 =?us-ascii?Q?15BhJMOyLHd284lP3gxYd5Fva3+zY3B22Ale+toUeSqbqjA5EHRLSNiNX+nL?=
 =?us-ascii?Q?0ORp2Dfriy54wVmDx24BE583k7nEu1rZ0aZBxajFHBSRasysRtxs8OjH7OUL?=
 =?us-ascii?Q?UjAx6wGStFQH2PCNFHFbwlBRLVVfdKmqNhC+Nzt1/C+buZz8keBl0uvxHmIA?=
 =?us-ascii?Q?7W5juzKdKL2c91rUG5A+UP9B7OlwVGxkGA5b3ec3UKfOb8rga/BGKSUZBKLM?=
 =?us-ascii?Q?iWf01SjNFpxmKjkgMcieZB5fO0fktvPcxvz7kKMf+xJFyiEpp9e0p5kQe3hd?=
 =?us-ascii?Q?bTUcaivHkoNJRoJbMyAKtpu7cdY+NHQjKwtWvDEQums7gtUM/Pd9qRMqLrqT?=
 =?us-ascii?Q?Y2pJIkB48qQ6ppnG0c7KivbSddegrJfWcZs8AcTZ9B3DrShSBRwuZMMpRBRT?=
 =?us-ascii?Q?n4aKBaI/lfUVj4FAdXNMlL+FoLsyHhcaU69tcJxpEKfqfv5/mortnEQeD4+f?=
 =?us-ascii?Q?0+6+41fqQjOmYTlBbIFKCJLoBFoXlDT/jMGBD/lxQt8S4D5+s7b1H3kzUymU?=
 =?us-ascii?Q?hytv9iuz6Lnix0ClBiMn+sSPQjYHw+4WWhEvXn4kqaaDBl80Fd0tqxLZ5LMb?=
 =?us-ascii?Q?NJoaqwfWB1oZliV1/VAXUW3jqns98BaotydZV/j5/aCFvk/KJtvMNKy1g7a9?=
 =?us-ascii?Q?R2LxSNvZ+p/KRh3uUvN4iyTHEv8gr9UDEobz0xIpvL9ZVp8+gPDeNGwJk5jM?=
 =?us-ascii?Q?OGGp2nr3LVEMDcAWo5/qjJbpkneKHM/llciHuSf+LXvVNVPjUhHmEnuh/dQH?=
 =?us-ascii?Q?MnCPzhYpAt7AvZVGnVnLD4eJ/mmpRxdYRbre3gv1bR8d7f/DWkd4ANhF/nTB?=
 =?us-ascii?Q?rO186EcHMJ/XvX/ueR6L21nXsDNwuED5vKxHr2RD44VyxkhuTol9X949tNbe?=
 =?us-ascii?Q?hFq+p9jJzJWDXBtS8DN+3XKWvaa5VOIwNwBT93zzClh4/YXASPULyTX5oKPZ?=
 =?us-ascii?Q?n5a/0bY9d7pmGgOh52ySColLg4+r/a5LJT5Y4Pd1Xsj91hWeccY7jt8xroeV?=
 =?us-ascii?Q?ymQpPNKyK3wXnHaQ+CDOs7FGPDm5vapAQZDf0gI6k/JRUHksbBHMX3xB5h0K?=
 =?us-ascii?Q?e4Sv3BLprdnihZWEtbWv4qXBMga5iF78Y/eVyA/N001iit8CSi2MuQgM4rQX?=
 =?us-ascii?Q?UDQkQDKY6tKP3Rql8YkJIK6XytCevF5YVChuZwaWu3ublr/XTG7DEOVF2hNl?=
 =?us-ascii?Q?Dxpxw85CwWmtfCbi2s4Kez5cV0WORkDbzPj+sODg1rXs6h3t4oLRbzJQdrF3?=
 =?us-ascii?Q?2U/WwTnDt8oUH5U2xwRkHE3rCsshtGWp?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d3162a-fd7c-4f98-2c39-08da08c236d6
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 09:32:26.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEUmcQguyZIYOHTU2Xyw2nE5737OB8tmbvrwW7ofKK3hanFzZ/nHF5ICEJe0nn3tyur+0NQxVWSKEDskUZJpeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4514
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

allocated_mem is allocated by kcalloc(). The memory is set to zero.
It is unnecessary to call memset again.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 0ce37f2460a4..407029a36fa1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1835,8 +1835,6 @@ struct phys_mem_desc *qed_fw_overlay_mem_alloc(struct qed_hwfn *p_hwfn,
 	if (!allocated_mem)
 		return NULL;
 
-	memset(allocated_mem, 0, NUM_STORMS * sizeof(struct phys_mem_desc));
-
 	/* For each Storm, set physical address in RAM */
 	while (buf_offset < buf_size) {
 		struct phys_mem_desc *storm_mem_desc;
-- 
2.35.1

