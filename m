Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEA19AA67
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbgDALHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:07:35 -0400
Received: from mail-eopbgr750070.outbound.protection.outlook.com ([40.107.75.70]:46082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732355AbgDALFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVZ2WkU3+oZ/Etyshh7qNrv6oMtMf+E83o6ZJA6sQC0zO4b9bnffQnrQilLN6FlEEUYh7+5FTJNdUe7CGpALDWbITv735Fq9CBE9qpPUFqcHKTw690x9l3cCPhr6EKsrEOTdFMcB7qJ2zlu8RHvIbmxE7NRFuxM4iLkILpZcpVsXTbB9jV3lZBD5ueD2fPR7n+bEIFCmereCYs3cfoOElWG+WU/MSklE6Q+4dA+o7zZapyIjojxkm/VwIQCzgoD2HveR/Z22qxC7PrpgrYAnf9f4dZl2V6bvQYO815tYYy/I2Kn8o9/r42054o7ZANSkDgHJjueNqVKivi/OB2FhTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbnuxLmWt0iP2LUq7bC8yC8POuBwjQxzXFwbeIfTZ7g=;
 b=VdyPbXIPoIyWKCDqulbzn+ilaFfNG5vVBnjY/hq9kg4+TaokLq/cP3nd+yiGc2TUDihBUC8Pc9QzENtDfbOdQgR7HHwEaJLHJPzwRzkS7uL0GI+Di0TTIVQANETTggAEI401sBpDmhZG3rPJhITfv62qBvGAshJ1IK7zfqme8i21XSgWtLq6M1SKJqAMHMlUslR8+80ILOewwpqE1BOl81Wev1vcT079mB+WHK4bLfsN+LuD+TZI8blHb0Mtq/pu6kPuXcepQkEYDDXnd7VcoNIiuldd/49LB8SKtLVE5tUApDdtuJtDaky1icTVQm1Sui0Lbr1b22JHMnJAXmLsAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbnuxLmWt0iP2LUq7bC8yC8POuBwjQxzXFwbeIfTZ7g=;
 b=HKlUuyyBsEAnZXoQ2GaA8RECA3p+QDHlPwQTW2xhNEp83mABmdOj3MqqIhpqcO1ywS9l6OVpeYin14VprWjJGZKBtqcunuCEzdcBVtWf6OElg1htkoDO8dUxy4ryp1lcrxrvVPyyPTR+i688A+KBeulFv1+xBoSb93sjYR8nQ34=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:48 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/32] staging: wfx: do not use link_map_cache to track CAB
Date:   Wed,  1 Apr 2020 13:03:47 +0200
Message-Id: <20200401110405.80282-15-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:46 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0341eeeb-cb58-4f04-3813-08d7d62c7e31
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB42857113DC71E49DBAF5782593C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78+wAF+ciFFoFdDotlwHqDguclQmPp09Y+nyOV8kFVaS5kjEthyK8rGS2XaprJvMT5bNqXUogzKyh1yGe64AOi0BifUPHwuBMLxdL+Rn7vymXen+CSbw98GtnWXVrEc9mqq7EOrfdQRZbN4vUwJ9QIAei19AUKB88Rl3OpehUyDAjVA+8+kBzttPU973vtjnwFWsBASfxY7su5pOPhwa5dHI/Z3F57hIy9pzrtTpdm+uT8u6gUm32Gh+fD1fmjIxKPgd5N9hhlLZLb6i6m4Cwx2gyyY7Nwjl4Wx0uzEsaW2baKi66It5xk4giFH2q+/WN+VyJkOkqXfuXcwfcNl2E0sp9eDbGClI41RC/Dl6n1HuZ8iPjBVpeeFflRpGQ/2suG1J9OHQO0sCi5oms79Cj+cduL0rudKshH369anhGFpakNyOzt7YNWLZSYbCaIB2
X-MS-Exchange-AntiSpam-MessageData: IMmLxwnemGja3xtPGfqg3og1MDGS73uZzdUqdE9YL8DTsqHSsR289wvbOSgj3Z5pKJf9PgZ795ePPNpMU9ONgmEZbol+8BLK6g0Fjg9WsATY5pKm331fMjX4R8tN3+2Yaq1jVlduILvHkv5DEBLw9hzU/zC5PaY4MWS7AiYov3iO6NsAtddF7AlpEA1vt2HQJUdnh+S6evYZsz6QdyPMKA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0341eeeb-cb58-4f04-3813-08d7d62c7e31
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:48.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hpk/YpQ2Nxe+lw29/IayF67oEQjjcJAFEmaW7x7iLADta44LSANfMedxqWi+ug0phvoGl2wR9Jqm9gHAAql0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2Ugd2UgZG8gbm90IHRyYWNrIHBvd2VyIHNhdmUgc3RhdHVzIG9mIHRoZSBzdGF0aW9ucyBhbnlt
b3JlLApsaW5rX21hcF9jYWNoZSBpcyBub3cgb25seSB1c2VkIHRvIHRyYWNrICJDb250ZW50IEFm
dGVyIChEVElNKSBCZWFjb24iLgpXZSBwcmVmZXIgdG8gcmVseSBvbiBmbGFncyBmcm9tIHR4X2lu
Zm8uIFNvIHdlIHdpbGwgYmUgYWJsZSB0byBkcm9wCmxpbmtfbWFwX2NhY2hlLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyB8IDEzICsrKysrKysrLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmlu
ZGV4IGNlY2Y5YWE3YjNjYS4uNmZhOGY0ZTA4M2QzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0xNDYs
MTMgKzE0NiwxNiBAQCB2b2lkIHdmeF90eF9xdWV1ZXNfZGVpbml0KHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2KQogCiBpbnQgd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKHN0cnVjdCB3ZnhfcXVldWUg
KnF1ZXVlKQogewotCWludCByZXQsIGk7CisJc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9p
bmZvOworCXN0cnVjdCBza19idWZmICpza2I7CisJaW50IHJldCA9IDA7CiAKLQlyZXQgPSAwOwog
CXNwaW5fbG9ja19iaCgmcXVldWUtPnF1ZXVlLmxvY2spOwotCWZvciAoaSA9IDA7IGkgPCBBUlJB
WV9TSVpFKHF1ZXVlLT5saW5rX21hcF9jYWNoZSk7IGkrKykKLQkJaWYgKGkgIT0gV0ZYX0xJTktf
SURfQUZURVJfRFRJTSkKLQkJCXJldCArPSBxdWV1ZS0+bGlua19tYXBfY2FjaGVbaV07CisJc2ti
X3F1ZXVlX3dhbGsoJnF1ZXVlLT5xdWV1ZSwgc2tiKSB7CisJCXR4X2luZm8gPSBJRUVFODAyMTFf
U0tCX0NCKHNrYik7CisJCWlmICghKHR4X2luZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9T
RU5EX0FGVEVSX0RUSU0pKQorCQkJcmV0Kys7CisJfQogCXNwaW5fdW5sb2NrX2JoKCZxdWV1ZS0+
cXVldWUubG9jayk7CiAJcmV0dXJuIHJldDsKIH0KLS0gCjIuMjUuMQoK
