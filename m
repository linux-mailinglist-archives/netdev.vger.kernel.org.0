Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8761D19AA32
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgDALE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:04:57 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732006AbgDALEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LV+GGhhN1PfZQVyarp2rAuF2N0/5pyOdkXKcasWfDZI0NrqUI1eskowd/IwqtdW6l5kkCZukkC0+HjBYpaXb2Ax3Z/W4aWqKhKr37/dYj1GP2RVBa4UALOsHNVYo6OPAhHLS7O1lyAlkMzBpV9Dg0Y11U68nK66OOwcm9nIhN2WO0tTyQAlCdlxhN3UMErzGEc+ncyi4wb0L6Fakp2p3J8J+dVXfPYUQ7htVK15d2Emyy8P6wyzb7Iu4ONnehO7Psh4GxKGFEQIUVgKg3jQMvyWx7uy06wPs0bMb+0ppWWD2OiD3kYCoEskZ3EPezkt/mGEubiRppov4GINyXUnzfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwzLi39Wa5dbbIqW+KIiPUyRPUxGUWTSuGfHKr1JGww=;
 b=BQ+gH+GiyEWrasPSNZnALUzI9TrPyyXoe08bPypf/4cTheRVbC3d3YBO5v1GwNZ+KGr4wiAlGcZf5y+9lfi1aZwXnylGDgON3ZKUH+l1NCytEl5DzpMVgQa4BE6YNnsv3mC0Ey0i+GvoOsk/ii3wmr80c9oQWgJ8l2HTjQbAYBCiH/nyL8KMVTf3+CpMKf8fAjjz6jN0woM70obxNFwL1ES+aJCU7VcZcOsY1RDoj560s+WstPUYm1ae+oa2vE+7H/gle496yvJTGgkHI3hUdVuECoeG9gNfLSi2DGc73I8jKT7xRA3/ETTnwFgRLqiZEg0SaYu3ezHYYat6aYZT7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwzLi39Wa5dbbIqW+KIiPUyRPUxGUWTSuGfHKr1JGww=;
 b=WSt+Ctn8mdWM5BsemkEDUyUzbswdAFV2OaPc/yRs/i3Y3MIpF5I8L5wD07P2Ef4AY61NwfIoHUDXkQ3pzW4QHU2n7oywMeNBc76HbpfNRHSW8DEq7MkPmGL7fg+zYcPA/aGIZPorJUf3TqLEXxpyBPw81K5PoU0wht2LoOPK9/Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/32] staging: wfx: uniformize queue_id retrieval
Date:   Wed,  1 Apr 2020 13:03:38 +0200
Message-Id: <20200401110405.80282-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:28 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd866c81-bd41-4c12-7423-08d7d62c7389
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB428561EEC0A29DF5569F8B5493C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VBwNRmTRajLY+BRz45GtG05M22OMZYBifqWQr9itaZYIK1DDVjkcXP14FHMJ+DCfd7/dN8VDkIjdTsxaFfmlwa+oVq/1KmuGgiUb4hps4qwzk8bZ4UcCnRTrif0WGagW1djejUTP6zDnfqKYGt6Yx9/esetp6t0bKOdTGJZ6UkIDs4celrcUEdO+6RfbhaWo2Xu+Q9iBj7/oHvxB8o4Jih+Ltisq2ymkuKjG4jcxADfZeK5rVtrnhJxU3WF75kxGkSuODbS1+F915VupWt5Dvfz8xX7cMv+V/LQ66lPuu92//65bO8IGQChh4fQxDlRhOb1LBreS5x4v9hg5ixi1+ja2BCmAWLYPJdXj3NG8DGrICCZ3bxboPfdcOxK5WBopWgs2/FBPb8FBohiCx1gX8jEssIYYpFn9G30CbTLU6uKCUORFmPUBWBegUyMx8Zq9
X-MS-Exchange-AntiSpam-MessageData: y8f3sTb/7OndmjxeMPrechCp6v96URdKMCmH47vvOKFiBaTT0cq0J+71P+nSSSULzh75W9gS7LXzK8j5T3Zpbl4hBxOniYUG1edAYEWJlj4kU5HEiWRLiTU+ryOSmQH19mK/3mGt1uSGDde+AwDLwAk9FNYJodjJYfAyfgpu4PsLkFhhApZHstDCLq5ThyOBPoCAJj4xaconXTwoJdt4Kg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd866c81-bd41-4c12-7423-08d7d62c7389
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:30.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJIgiSsRErFSIoUlGcfFJ/gbyj8S5HpuOog6O864WCKjICJlOKOZyyv+OP4uaF/7yCG7In5ks3briHD2DHoVuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKdHhf
aW5mby0+aHdfcXVldWUgY29udGFpbnMgInZpZi5od19xdWV1ZVtza2JfZ2V0X3F1ZXVlX21hcHBp
bmcoc2tiKV0iLgpGb3Igbm93LCBpdCBpcyBlcXVpdmFsZW50IG9mICJza2JfZ2V0X3F1ZXVlX21h
cHBpbmcoc2tiKSIuIEhvd2V2ZXIsIGl0CmlzIG5vdCB0aGUgc2FtZSBzZW1hbnRpYy4gSW4gd2Z4
X3R4X2lubmVyKCksIHdlIHdhbnQgdG8gZ2V0IHRoZSBtYWM4MDIxMQpxdWV1ZSBpbmRleCwgbm90
IHRoZSBoYXJkd2FyZSBxdWV1ZSBpbmRleC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggODg5ZWJjMmY1ZDgzLi44ZTRjM2UxYWFk
ZmQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC00MTcsNyArNDE3LDcgQEAgc3RhdGljIGludCB3
ZnhfdHhfaW5uZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpz
dGEsCiAJc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvID0gSUVFRTgwMjExX1NLQl9D
Qihza2IpOwogCXN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmh3X2tleSA9IHR4X2luZm8tPmNv
bnRyb2wuaHdfa2V5OwogCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4
MDIxMV9oZHIgKilza2ItPmRhdGE7Ci0JaW50IHF1ZXVlX2lkID0gdHhfaW5mby0+aHdfcXVldWU7
CisJaW50IHF1ZXVlX2lkID0gc2tiX2dldF9xdWV1ZV9tYXBwaW5nKHNrYik7CiAJc2l6ZV90IG9m
ZnNldCA9IChzaXplX3Qpc2tiLT5kYXRhICYgMzsKIAlpbnQgd21zZ19sZW4gPSBzaXplb2Yoc3Ry
dWN0IGhpZl9tc2cpICsKIAkJCXNpemVvZihzdHJ1Y3QgaGlmX3JlcV90eCkgKyBvZmZzZXQ7Ci0t
IAoyLjI1LjEKCg==
