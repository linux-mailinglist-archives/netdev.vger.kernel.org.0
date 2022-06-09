Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29CF544665
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiFIIur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiFIIuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:50:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2113.outbound.protection.outlook.com [40.107.93.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D393E2914C1
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 01:47:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9rgielCpM8S6gpFK3lqCoUBX17rCS+r3qrAoCx0EHNfGsscmuSPdUmP3TaSgFjT98CcAAsj0mDLkISVJgqTrYM3T4nRBgqjoVFqU2zwpAD4pstjt0W0PNsyxiOxYL4Oq20bLoaUeE/3M3eiIdYuk8303EwEqxJmppyP9ECq4WYe3mZ3T6TYrgIzDmjdHbHTr3/6L+xAS6poa/G2EEIUx0XKrGbEQ27CliaCkd3wsGoIeD9LhKX0BZZFcZO5yMmaFlEfrcMlpzpbq4LDxo9OGBLQ8zic3BU1AWBMhGXyz1Q5sMtyyXlG2WEDmlVRXeRTShFy7moIK3Rv4BcGeOD4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvFcQNbX+v1+tAOIrmC3eFwDbivjSmLz5FbuZ0eH5hA=;
 b=EZDXERutbC+U8YmTOvhFXNRX19msTbKjj4G1Yat9qrdIYTq/FJQj9umDtavmn8Me7qmCLZOC56G315Turz81cOS2gmbHkZXAxheq6bzUP+qFBQZuBFOHLtUvtJSCTbQChkqGo00kkY35N1pdJL7AAkomDQqYzEppERHQHtavt9sdz682pEo+Pv4pU7TMqMO5t+pV8GXdVMcOpmfDxOXHjGyzvIhEDTLQ8UZeISE+H60974qDYpFVIC+F9IwY6S2srWxQF8aADXNk35aNV0zAgWCHQ8JOSe+Cun1BOoWBidsJ0HwHF0WhW7zrcsnSS1KVr1oQHXWJBEG8F0BPOhEUWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvFcQNbX+v1+tAOIrmC3eFwDbivjSmLz5FbuZ0eH5hA=;
 b=LAqsT7zAAM1mhbb87xX4X1EMWFPw84Bi5E+AAqw65dnJVqNF10kDg+CqpZgRQYkyz6ZeqcWmV/lsYh1Pv4B9j3kRuEZiRp5G8Lh447FUbOM/OdSkVGQ69Z4GUB8/ClY2V1TgV3ijYTdyilpOakyRJjUt7QaxEa3A0NBLPS/n61Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3240.namprd13.prod.outlook.com (2603:10b6:a03:192::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Thu, 9 Jun
 2022 08:47:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%8]) with mapi id 15.20.5332.011; Thu, 9 Jun 2022
 08:47:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Bin Chen <bin.chen@corigine.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] ethernet: Remove vf rate limit check for drivers
Date:   Thu,  9 Jun 2022 10:47:17 +0200
Message-Id: <20220609084717.155154-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd0239fd-74e0-4cd3-a15c-08da49f4b111
X-MS-TrafficTypeDiagnostic: BY5PR13MB3240:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB3240545D2D89C909E3875E93E8A79@BY5PR13MB3240.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjFpdz25il/UMk1rLsFCphCUlk1FaXtn1x+6mzxKJv+yvMOfXv3coR5CoxrkQCaq/QO03ckPnZOWh6KuIXccSHiOqbpExg70lgzmHspNYp4ZJdk8FT0R9Z9Ia8w24msoqXOz6OQnC6JV0nTE4h1yXgrmtimtdbe3H0NmTOUxQL0OiNfvSb49Ya5pmLKVDfeBHOAbL0Cn31yiBGVp1mjVHpro2I4NIzJH1jIWyHwpDLTz4egk6gbdFUXoIPkszLE7DEm+ItQGteUDBWgpO1PPw+3VhZJJO2x2S1qccSsQMlxRPOG6XOsFVWWUms2Q5ogmZyaiJSsS7YM6cX7MRgWXx9qCyytb+YSSO7Jbk5MjIYwYrKnB0oCX2cQP5JEsU09Kjm2RGPSUCLufDtkFNnU+5yQmOA93S2nBUFP0k6rvEWGhKk66WkY+D8Dz+C1kHoh1qr2JCIEQHjRHYXgjbT6zKcg0BVKME3t6S8FLUI5nQage43PIadxWxNF2IKa7F6SLKZJA/cOvNq3XIhDuaKAWwMotiYfMP2kIyLgM9rTy6NHomSf5dgFa/YKwO8FqTQM2rLIMDDo+E1GRT/RnnDOqQzILbnGG+9s+Q0/fUJTnf+8WUbxGOM4j/Ooxbc+oG2nwczjE0+0eJ6QoxHoQuS6+nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(136003)(39840400004)(396003)(346002)(7416002)(86362001)(66556008)(66476007)(508600001)(6506007)(44832011)(66946007)(52116002)(5660300002)(4326008)(8676002)(6666004)(2906002)(6486002)(186003)(36756003)(8936002)(38100700002)(316002)(1076003)(54906003)(41300700001)(2616005)(107886003)(110136005)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dMi4zVWOO2WU5d6f0LK+agL1wjDF7mlXRzptgNwjz10Exl5cQz7Yk/3vLEsK?=
 =?us-ascii?Q?8gY8ZbQWiBD5+7HxXmO6FNkR/fhy4Cdv+5fefRAetgOb7mnRVr4NbHaLZ4K3?=
 =?us-ascii?Q?qlKOh6NDUHrYG3+ZfyvCShVepJCshOfARa0g1Gvg2VbB6DNAVAv1v/AWV6XK?=
 =?us-ascii?Q?e13GZZuP25cP/FypLQDKeOYQKaQGZXXwQCRAmrNQuYwaObFGugLjvE8+Et+t?=
 =?us-ascii?Q?lKTLDbhmCglarqakK4Iu9277A3EZUtOKEOZ0N9Q/rW1Lb9BSOP8M9yWi4h8J?=
 =?us-ascii?Q?NIQX2NzSOpOovXMZrwvy2ZlqgMTM8WO9DRe6ugjYxG+cSLOP5KylwRWWWVIR?=
 =?us-ascii?Q?mEBMGhh7kNxTtPfCMzXOPAK+UsSysF8aY2qjCbhMngHhHG7PQkkTxiSFuuia?=
 =?us-ascii?Q?2Hf0Qhb4dwxy0c4tfVHjxbSN6klCF+4l7iau4QzotnG2pZal8Sayk2Wwefm0?=
 =?us-ascii?Q?6KQdSRxZmUChHBck+Kdxryly7YWwLs6ViI1lQJkU8ztXZ2VZGd4YAnN5zSwJ?=
 =?us-ascii?Q?DN+9vnL9UDMTWapPGuoxV0tqjqgVmcaM8ZwKdE2Zku403Qq2hv7ilQE6NWUi?=
 =?us-ascii?Q?pUd77CZ7H8mY6bnP3/cn6klEo/QVxkNKVs+pDZf+a9tJbvegVutlzhvLRW9u?=
 =?us-ascii?Q?iwFjhRTAvNW2ZaMqB1dvcxsxD3TVYbKXz4lUlnmTsEQki70BF0t2HD+acwhh?=
 =?us-ascii?Q?Ly24Vcl8VLGQO+jTM4y1yJY/C9TdOBOF0vRZGJIYOxrabgE4g44qUyBa5cx2?=
 =?us-ascii?Q?jITOsHVV8Mg/du9SspRhCe/aqNzZddsDPiAYiLbJu3O51nnvRXtR3l2WLD/h?=
 =?us-ascii?Q?OFTouT2oi3JrB/b6m0yk1CjdJqGBLpWn77MgeJepkLdg1hCQcloagamfNAMQ?=
 =?us-ascii?Q?qBp/y7aeEGE2OHasSjQcFyzRzwBOjXTFLlT9WaAGRZYZEGjcunwszbmetbHJ?=
 =?us-ascii?Q?7uWJ+c65uucg+8q90lAqtCI3RtryHnEXsWOEDb/KunK0+aquH03LY1VdrmDQ?=
 =?us-ascii?Q?vAtYjLdM587gwovQHG+4feh6mmrW0gOcs/eNcc+BF6suL+7WblJBrgOgEXmg?=
 =?us-ascii?Q?vbgVY37OtpRqM5YFIRHG2iqao8xja2RyUtTM2OpFqmy/tmD6gFpeO/+Z5dXg?=
 =?us-ascii?Q?C5WfFW+NED+1La+69diAW75gGV69l7U/xuINywXJs67PupP0dt4rg1XrwCbQ?=
 =?us-ascii?Q?NDDEBhyKYhwfxBgBAGjThPM57UDhDzHIG1djQcqBZT9uQUQJxXO9jVkXLY/O?=
 =?us-ascii?Q?s/TyLF9iNub4Hylg41pkSZYUSQZAPkpDPM/qIfuFWU1xj4ZmFyWbJ0nWPriq?=
 =?us-ascii?Q?rfT/Id61FmVMzr5iYFuABfwoynprMFymtwSxdHlzlmm2zY1YPclO0qSgaJXa?=
 =?us-ascii?Q?ibYlOrKhjnDCcbUI1b/hqo+bO97CzA59aIogRUo10R6Guqm87sNWEQKGmgSS?=
 =?us-ascii?Q?1DdPU1yJeTEEL7mSNGGUqgFfVr7kfqmVF+NZBCrTzaodl2CUxIwMH1fp6XA9?=
 =?us-ascii?Q?HLQjfKR/F0TQZVkVhpFihPW3HMqeh7ncqfoq7y1HNc0D0kLQ4p+RHlRe6lni?=
 =?us-ascii?Q?2iI0m+t2pVY3UnARuHzIIOW6utyTHlRT8bQ/SJ5aLGzSvj4lucHA+C27uP4R?=
 =?us-ascii?Q?PNaLCnGalvX7WIIZI/3Emw6kywIdj7uryfOZipqj1RzzqtisbGdlXubQN1ue?=
 =?us-ascii?Q?hgNuRSTtTqgy7fPvd560cvyKQU28zU5e41k6gwaNdLBPR/Rr3XeoQz0OWIPB?=
 =?us-ascii?Q?SAgVS0JQRyxQFXzrv3W8y5SqSsfD/1dTr0lS7Iu+GE/vLBxjOpuNEXNx7iwi?=
X-MS-Exchange-AntiSpam-MessageData-1: XNeREnTS6Z/e2k4bZnyG8XX//ODBv3/qByE=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0239fd-74e0-4cd3-a15c-08da49f4b111
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 08:47:31.9010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ie9xOBe+5n2rY+ILVO32sIuzpyPAKok0jhc1PBMWdlGTkKHzkevqVlfCab0KrqklnixWRdHnJetKGS856Cc/UR/c284d/iL/U1F8eC4FUbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3240
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

The commit a14857c27a50 ("rtnetlink: verify rate parameters for calls to
ndo_set_vf_rate") has been merged to master, so we can to remove the
now-duplicate checks in drivers.

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c      |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c      |  6 ------
 drivers/net/ethernet/intel/ice/ice_sriov.c           | 10 ----------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c |  6 ++----
 4 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index ddf2f3963abe..c4ed43604ddc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -307,7 +307,7 @@ int bnxt_set_vf_bw(struct net_device *dev, int vf_id, int min_tx_rate,
 		return -EINVAL;
 	}
 
-	if (min_tx_rate > pf_link_speed || min_tx_rate > max_tx_rate) {
+	if (min_tx_rate > pf_link_speed) {
 		netdev_info(bp->dev, "min tx rate %d is invalid for VF %d\n",
 			    min_tx_rate, vf_id);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 01e7d3c0b68e..df555847afb5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -852,12 +852,6 @@ int hinic_ndo_set_vf_bw(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	if (max_tx_rate < min_tx_rate) {
-		netif_err(nic_dev, drv, netdev, "Max rate %d must be greater than or equal to min rate %d\n",
-			  max_tx_rate, min_tx_rate);
-		return -EINVAL;
-	}
-
 	err = hinic_port_link_state(nic_dev, &link_state);
 	if (err) {
 		netif_err(nic_dev, drv, netdev,
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index bb1721f1321d..86093b2511d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1593,16 +1593,6 @@ ice_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
 		goto out_put_vf;
 	}
 
-	/* when max_tx_rate is zero that means no max Tx rate limiting, so only
-	 * check if max_tx_rate is non-zero
-	 */
-	if (max_tx_rate && min_tx_rate > max_tx_rate) {
-		dev_err(dev, "Cannot set min Tx rate %d Mbps greater than max Tx rate %d Mbps\n",
-			min_tx_rate, max_tx_rate);
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
-
 	if (min_tx_rate && ice_is_dcb_active(pf)) {
 		dev_err(dev, "DCB on PF is currently enabled. VF min Tx rate limiting not allowed on this PF.\n");
 		ret = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
index e90fa97c0ae6..8dd7aa08ecfb 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
@@ -1869,8 +1869,7 @@ int qlcnic_sriov_set_vf_tx_rate(struct net_device *netdev, int vf,
 	if (!min_tx_rate)
 		min_tx_rate = QLC_VF_MIN_TX_RATE;
 
-	if (max_tx_rate &&
-	    (max_tx_rate >= 10000 || max_tx_rate < min_tx_rate)) {
+	if (max_tx_rate && max_tx_rate >= 10000) {
 		netdev_err(netdev,
 			   "Invalid max Tx rate, allowed range is [%d - %d]",
 			   min_tx_rate, QLC_VF_MAX_TX_RATE);
@@ -1880,8 +1879,7 @@ int qlcnic_sriov_set_vf_tx_rate(struct net_device *netdev, int vf,
 	if (!max_tx_rate)
 		max_tx_rate = 10000;
 
-	if (min_tx_rate &&
-	    (min_tx_rate > max_tx_rate || min_tx_rate < QLC_VF_MIN_TX_RATE)) {
+	if (min_tx_rate && min_tx_rate < QLC_VF_MIN_TX_RATE) {
 		netdev_err(netdev,
 			   "Invalid min Tx rate, allowed range is [%d - %d]",
 			   QLC_VF_MIN_TX_RATE, max_tx_rate);
-- 
2.30.2

