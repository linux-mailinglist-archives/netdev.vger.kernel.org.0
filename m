Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0703D6832BD
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjAaQbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjAaQbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:31:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E401372B1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:30:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhVOp5Iyyadw0l36gwPnaPCUGqJxBm935+HLwc0umQOU4RbB5JlIjmnj4lSd9zFU7Ri/zJgCPU9il6rDdJB16QJ2RIo7E01l+UKhmoy7x/yPlF07LPiIYq15AH82IGRB3CgTjhYD6zuVLN8X1a+N77/PeasOjx0EO16b4LUWKCKbNnqMIPlY4kTxYqy//wPl/X01X5bsIWhFuOiUoKO9meWZ9XyewpHSCYMasF/Pp/8VF/VBOjvMEGOdWaBwmZ94oAIFdX9/ZFqDMNysP0q5GZI6zW04Of90zxNTKlOAtzMgdniyn6xZQGAutTMspkaD/eQvJapjC/TDoJG0hetHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57ylOHnP9SqzkLGk5KPc8MZmcdSXRdjQtdvqMc+keFk=;
 b=kGtFlAjeZi4xNa0g+SzaNaXC61KuF+ZbrAfK8oSdqBMmO/LU8tTdNE0vLPPgPpUp5B15wa0ZRhR2D8GM7bC37DJJKqLaUpErYITXIVJZOOUNT35GdqtCf70P/1t0SPVNR4qwK4yL8PKTbfHqNot7J/pTyyBDBcVRKLcSkvsWqgS8dh11VLAe+V3tdFfGfw+wZ1Hz03ozhLyxVAZdfZjXdqkcOFHiNDtJ+twSGttS+aBSuKWaMsLMdSKZcvmUtiE4CCypDnKqJd8tiB09SUIUvVtAc9DP3i2DNFhTrv+n/umYhzVdeFJ3+aZ+4MdeBF0j+09m5WUy+VwFosYvKLkO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57ylOHnP9SqzkLGk5KPc8MZmcdSXRdjQtdvqMc+keFk=;
 b=eL9mGyM1NCyGhn1MKHdb+gY8FTBrbhsaaVaI6LLhTL6Z9xKgDQLVAU8mYGTX9bk0bGs9l3lyYj7HVHtIvIBI4SD1/drD0JznarR26EUiYz6ZY/sRhwhu08j0rgnfdcceBaYfJfUsoojQ4Zc6U6fh7tC3309G7JSYMnYLZghZ5xo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3897.namprd13.prod.outlook.com (2603:10b6:5:22a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Tue, 31 Jan
 2023 16:30:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 16:30:50 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huayu Chen <huayu.chen@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: correct cleanup related to DCB resources
Date:   Tue, 31 Jan 2023 17:30:33 +0100
Message-Id: <20230131163033.981937-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0115.eurprd05.prod.outlook.com
 (2603:10a6:207:2::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3897:EE_
X-MS-Office365-Filtering-Correlation-Id: 435002cd-dd20-4889-a51c-08db03a883c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VveIdNFObhvHhF9hu0hjJS1S+qv1SH7PPbVQjqPDTjnHAZWs70mThDOtKqbAJt3Vv3ukIagnlj4IVcyPAaztki3FJt4gj/9BV4DyIiZctKOOSE4TgnogP37wqEVf88zh0Yb5TwxyzlxrzGJPQj6sFyMLqBy/fSZsQX5j+4y7p8M3euvH9fbWeOk3SMwB7+WH+AhyUUbp5m5Rs/jl/J07Ubl0GD1o3s5ENf/mrrs/H48WscS2mg9HLSo8FMD5CydnGEEofqz12uuw1Im60kmQerMVFc9BSmNRNr1x338PeqrYVexMHRzblb2k3utoevioRB9PrHX6WAHSIrdv4j+MzJbH5rthgZqiEHGjfEVchJWUymQ7k5RyL6sRWQ+MnWRXAHqzEzXV3CbE3UWK/Ru9bV5n39Q9am1Z92Toe6hIyiY1e2bC9USYBpIxAP/erlljm2GiQOncs0gmCElNxNMXA4MCioY7DemWbqYCbBTnSMpFMD4DGgNJjdwXzolkgPfLE7S2OkHpRCHvj3MERrSO+5wN2oTbflGklYWoXnXGqDf3JXOqUUAny8UmnIsmKJRCb+K8Lz2q5AuoA0NXiqRwaiR41AF0oPpgl9BQfreGsqZyHZnWKPrWUiEnLch3djuguijIQXBGFnOX3ppAAoAB2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199018)(54906003)(6486002)(4326008)(316002)(110136005)(8936002)(66556008)(8676002)(41300700001)(6666004)(66946007)(66476007)(107886003)(6506007)(6512007)(478600001)(186003)(1076003)(52116002)(2616005)(83380400001)(44832011)(36756003)(5660300002)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDJGdklKWVdMWWJVaWRhVFFZUTZTeFk1c2RoQWVhaUFhSUZrYkRkQzZBSlpO?=
 =?utf-8?B?MXY0NGpRcENqMzlsOUtNV1hoMWswYkJtTUNiRnpVOXpQSm5MWG42eG0yY1hx?=
 =?utf-8?B?T1RxUnYvWmRVek1JYlJqYjcyVHc1WnhpWWdYblQ5QmZmY1JBbFBaUlpMdHdo?=
 =?utf-8?B?NzQ0T1NYOWFtcEN4NFhTYzAvVlZaY2pvN2FxSmJyTW1NMThhVG5RZ2pSVjhP?=
 =?utf-8?B?RFF5L2JnYTZURkRjUFg5T1BZWmZtazVhelhSOXNxYkx6cEcxVzB4ZUFPWTBS?=
 =?utf-8?B?L0N5M2ZLSThDTS9nY3RwOVIwLytTZWdhdFR4S0tQVVl3cVBrMUJwZ1JxdDJm?=
 =?utf-8?B?REs4bFlzZ1oxdVFSdE44VjBuSDJ5bThYQkdGMHlnZTMxRzN5djhXaURsMkNQ?=
 =?utf-8?B?djM0aGNDM1lwcllCeFpTd3UrWkJTQnlZbWNPTXB4dS9PNW9hVnN5a3hkREo4?=
 =?utf-8?B?MmRlVGE3TmxTOE9URVN3aW5EbHRwMWpCakVPcUh3VVRQRVNmdjV3UTAvdjV4?=
 =?utf-8?B?WVpCdFpCemwrYVovOHFzWlF4OW9GcUZhdG1KbldpNEZEMEd5cDVRWDNKOXZM?=
 =?utf-8?B?VG9jVkVETXlBU21BQjNkK2FLNjJxbmNDb1BKUVpLMi9QdXQ4TUVoMnZROTli?=
 =?utf-8?B?ZTlkdFdVU2FBY2FZMERZNnFoSlJDN0t2cHpoZ3M5Zi9qdWxnZFFJalNKVWpx?=
 =?utf-8?B?QVpiSldVaVpVcEZabXE2Q0Q5WUVlQUxsbHdrYmpnbStFVnB5T1FJdUFTOURR?=
 =?utf-8?B?dDY4SFY2eFd4TStuTkZ3WWI5dHBHajl1UWdZSjdFTGZTWnpRUDVXdk5rTVMy?=
 =?utf-8?B?VG4rYlZHd3BRSXpyWklTNXBIV0o5U0hxTjZMN2FQODVEakZlbUtIVi9FaCto?=
 =?utf-8?B?ZnlGd1JhYnZjQytNcnVhYzY1eFFzeUxLSElKSFlWcThMN1lNTngxRVE3UVhX?=
 =?utf-8?B?anhjMzJ3WDVYMHJyYW82V1dWWUNJeFA5dXZSRzhkODl0K25BU1VZK05pZVJK?=
 =?utf-8?B?UVJTZEtFMGdTKzBManB1NDBrRE5JWGg1Y2RZcUgybG1DcUJFSVVIdjZMQUJE?=
 =?utf-8?B?OHJxdzluTDhWcTlGYU1iVVluRHFpa05KUWNWV0kvTVZLUkNkWkV4L3BoY3pp?=
 =?utf-8?B?clBYTUlvVTM0dTdCUmVYRE9PenlEeHI2eURpdXFLQ2lLS21ZV0loaWIrQnNQ?=
 =?utf-8?B?ZzBrSjNFSStJT1RwWmVZakRiNWVHdVhpcnMvak9pR0FrWFFvdEJpSnZpN3hr?=
 =?utf-8?B?TW1nU1E5M0s3VFF4TFc2WkhZOXkya3B3cE5HV1pVVzhkTTJOTVNEenVzVVcz?=
 =?utf-8?B?SkhmZlN4U1Nud0ttS2RuNXpndG83K0dpWWJNc01GeDNZYXVNMkt1OWFnNHVm?=
 =?utf-8?B?a1h3ckp1dk44dHNYRHJoTDBxNDVBMWJnSTIraC9hSCt1dTI3ZjlyS2hNNmxI?=
 =?utf-8?B?cmZBVjZlS1MvWGlHZ0o4S1IyaWkyTlMwdGYrR2FFVDB6andGcy9LQ1JQd05P?=
 =?utf-8?B?aG8xTzVTbU0yMFVFYldrWmlrbjE5aFF4RTVWS2U1anBFNTBMenZveUd3RFQv?=
 =?utf-8?B?Um9iTW1ucUJBcE5lQzA4blhBVTluRGNsbVQ0ZWc3MWphNFFNQkI3amRLUHlW?=
 =?utf-8?B?bWRiR2tnQU1sRCtxUWxvdGRGUXh3N3dEdXhkbjJuRzg2TStCcldZQ3dOTVRV?=
 =?utf-8?B?QzJ2YXFxN3dqZWh4aUduOWE4c0FFQWJEMFpPNFNhenAzblJHOEZYTHR0YTI2?=
 =?utf-8?B?VWVnQ1Y0bmZtb0RrZnpjZEI2QXZkUTdhZVJabkhDM0NZQno0TGNpcFNrRHE1?=
 =?utf-8?B?OHRRdmtnVTZqc3RRd2l0ZTh5QWxRQmVpSnRmU05xbGx1ZEtjSVFwNldrc3B0?=
 =?utf-8?B?S3BCbzdmVUpGYng3Vmh1UGN5MEZMWVd0aHMxREpwcFJMMTB6UzFnRUUxR3R3?=
 =?utf-8?B?WE9NanlRWUQyUS9WRGdsRGcxdW8vT1U4dWg4N3lyNUhES3R0cjVlR0N6Snp4?=
 =?utf-8?B?bVNHWDVjckhmOWIxVzFyam53ZFZyaloxUXMyWXFidndLeEJ5enlCWHNRZldQ?=
 =?utf-8?B?M2Vkc2NOR1NzS3dsV0FjY3pRKzJoUzZKZHVOWmptOVU5UThzaTB1SWFXQ2J6?=
 =?utf-8?B?aEl3MnpZa2l4YThLb0NaQlJwWU42S2UyVXdtRU5ZUUtkTjZ0ZE1nMWhob0ds?=
 =?utf-8?B?TFBFOVdjVjhtM0RkSmNGTmRRTTNrNDl6VXVZVzJKNzA5eU9OQUdQVVRPclFa?=
 =?utf-8?B?VTM0NnNYK2xxMjNUS3I5KzhScmJBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435002cd-dd20-4889-a51c-08db03a883c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 16:30:50.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EBRRFHk8WNeLD7EX9G3ORC0aUiMrsMfkWl76R4d14ofGgR827uuV/wPS6SeEES9RzXCpVtpvnH4ylwkcqakmMbF+WUI/EnheYKGtrUmFwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3897
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huayu Chen <huayu.chen@corigine.com>

This patch corrects two oversights relating to releasing resources
and DCB initialisation.

1. If mapping of the dcbcfg_tbl area fails: an error should be
   propagated, allowing partial initialisation (probe) to be unwound.

2. Conversely, if where dcbcfg_tbl is successfully mapped: it should
   be unmapped in nfp_nic_dcb_clean() which is called via various error
   cleanup paths, and shutdown or removal of the PCIE device.

Fixes: 9b7fe8046d74 ("nfp: add DCB IEEE support")
Signed-off-by: Huayu Chen <huayu.chen@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nic/main.c | 8 ++++++--
 drivers/net/ethernet/netronome/nfp/nic/main.h | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
index f78c2447d45b..9dd5afe37f6e 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.c
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
@@ -32,9 +32,12 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
 
 static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
 {
-	nfp_nic_dcb_init(nn);
+	return nfp_nic_dcb_init(nn);
+}
 
-	return 0;
+static void nfp_nic_vnic_clean(struct nfp_app *app, struct nfp_net *nn)
+{
+	nfp_nic_dcb_clean(nn);
 }
 
 static int nfp_nic_vnic_alloc(struct nfp_app *app, struct nfp_net *nn,
@@ -72,4 +75,5 @@ const struct nfp_app_type app_nic = {
 	.sriov_disable	= nfp_nic_sriov_disable,
 
 	.vnic_init      = nfp_nic_vnic_init,
+	.vnic_clean     = nfp_nic_vnic_clean,
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
index 7ba04451b8ba..094374df42b8 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.h
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -33,7 +33,7 @@ struct nfp_dcb {
 int nfp_nic_dcb_init(struct nfp_net *nn);
 void nfp_nic_dcb_clean(struct nfp_net *nn);
 #else
-static inline int nfp_nic_dcb_init(struct nfp_net *nn) {return 0; }
+static inline int nfp_nic_dcb_init(struct nfp_net *nn) { return 0; }
 static inline void nfp_nic_dcb_clean(struct nfp_net *nn) {}
 #endif
 
-- 
2.30.2

