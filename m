Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE41CDF6C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgEKPtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:49:51 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728089AbgEKPtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:49:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTXov7FWMvgSnf3ii3KMWJkZj9l+HmE31FeV9W4Dwx2tqGY0wmYee2O0te9gQLEGeC5lWHRdINOgJLtkdKb8//AfzoHfe91HLggt+GmbBlHiM/alQgB438mOaoPCrq3e6ouLr+UEer6cmua2YpGjULTPI4btIzSRAO/9rqvf+MdtDrny5SmvMiuEtImGaoS8V2VtUjqFAR1a8uUsg6+Pj+E08ohjfwiGzsT/oaAck7+NSOBuyNXDluRev/qaRAXNhYFFuAg5ttdbkrz9vHWHF55VD0xdQJrf2S98IqfPEGOxJetxJgKEEkB+OoPiqmDQcOOXBnry3RUDf+jxhTuqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IExWWVHKF2XqSi+Sp12AMWU3WVMr+CLo4qZB9OwghaE=;
 b=oapNInFvGn1U0hlz0dEsj8n1uPKOq3Fep1/XGlGWr3GlA1d7E+AG4D+8AbK0WJlTgUUNV5g9SZRM/z/OkhRXDq6IV0esqgI5lyDj5k682qbfI/0k+OfM2SH+g7QKTKlTZqQB/Bs7sS7sQRfdgDQY4NdNUwhDLxpuvVULFzZOpZUxezauuVvvSmGXtGNMmvXFeIh0nkPos3b8WUaWLkOAvE11i4yxwN6rtweyI7Y/xbuUNW0XkMnI99sinQaRO+yDgbvkNuJfnB4JQz4uq+ELdwnvrd/5rraGDICzK8yGTf0xGJhk27k9F8TrV3F4ozQN1NKSZY4hKo2REMZdxgMlzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IExWWVHKF2XqSi+Sp12AMWU3WVMr+CLo4qZB9OwghaE=;
 b=TWm7wSw0ust0tFIqFLVhd6hnfMMqjQTWUFIlTaW/YWl5JnfwQL5bJ3lXO1yDRZk09NEFSACCokwywPLNDpTPkwW+YVgjDezTh5Zgz39cnnlUOTIcxRhYm6m5ujiQBuyyiSLDpUforW9BT1V8JjUTpCAUId+p2RXGtF5OcISPVU8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:49:46 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:49:46 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/17] staging: wfx: fix use of cpu_to_le32 instead of le32_to_cpu
Date:   Mon, 11 May 2020 17:49:14 +0200
Message-Id: <20200511154930.190212-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:49:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd44173f-bb72-430b-e469-08d7f5c2ee22
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB196839D5087154ABCB6C0CCE93A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHATkri2wqZWY2qyiAZkUGoFIBqP0agxxxLygnaFAEqWTLsSZTWOLBonNAdoUgaoujOU9H8khh3NNs2UTWt56MOF3nLVVtH7m06g/Mu4rXfsFm3Tjb3eayIBEbSpgeVDIJkK1tGMMmvZReHTnfsm4UtfhD07jylLY09vTMuo57uHcSCwttFdaHocGJy70PbmdldZqQbQiY/WiztKBkvQ7To/0In9a8uMM1F0pugst4bVRYLBlo/OZAfqa6KNMysJ5RJBVJnb/QeNHRvDW7/TX96xYZE1nePSByEQw7B0p9TNU3+PWAUmNg9wqT8oEJN9jYWqB7FnQp3uZwoQGXm8dk4/LFiPISM7HrIpHK8rRwc3pRGloSAtDr5QvSXiUT3QjgF+PSNcWGBYQREz3L5pvcffmF9nVc3wVrj4Ei8IXj1lzvbsMtdT57oTm9uM1N37n2Hf01qHfdOwg8BQrCyFYaBUwTDRNWymAdTK9sElYrSSw9YoTjO8pSeuk2a/uhVbkhR5eXzJ1oGjHLb4K8I8Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: n4T0EIo36DyHjFsmeph39YAIauAQgTQLFGWBknHB6GGyYV+WOszOlJW6YBaBI8q7GEK9Lif+lU+nKqv95z++BTsj3RxETlT/u0wDSrHjQ5QnCQ7nbDUoIncC7Rntowv5mpsvzo1wXmZ7XGXTA9XkZZnCGBsLvZaY3hkTtubWLqJRHjAbQcMI+wI0BOzShuBqqJZmgml5juKbFZsYlxpsSSnvz9x97JRstgDmzmAeI+1YJERB5YVsXrz9Dn2tL6jYf+GksfFVmwzBplBsEw1N09MvT34l7kynpSAb2QPRY9VOtQSNPiNVbI9kQl9Zh0LETPzxFNUpvyBDWamm7FVjnK04k9pSCgZA3T/imwc6O3Di9W4SSqfD1QgwfBLRavcepYdH3HdcQiJ4yywRho5QU06cAVWgAwrM8cDSlF8Mh0tmAFm733J+5Vq2tICuYJhqY1yAOWHuGU9E2FrsKMr6qDrAKqhVPksWAGYCsOFPSHo=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd44173f-bb72-430b-e469-08d7f5c2ee22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:49:46.6817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R59VFl99BoLFAGCdeU46BZ1HBtJPu+sUbVFUmvbWpkB5B7v+MjYARlBQnY102+wGrGxx6iGxhMpFd2UtpPQvog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Bh
cnNlIGRldGVjdGVkIHRoYXQgbGUzMl90b19jcHUgc2hvdWxkIGJlIHVzZWQgaW5zdGVhZCBvZiBj
cHVfdG9fbGUzMi4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91
aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYyB8IDIgKy0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lv
LmMKaW5kZXggZDg3OGNiM2U4NGZjLi43NzcyMTdjZGY5YTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvaHdpby5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5jCkBAIC0y
MDUsNyArMjA1LDcgQEAgc3RhdGljIGludCBpbmRpcmVjdF9yZWFkMzJfbG9ja2VkKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LCBpbnQgcmVnLAogCQlyZXR1cm4gLUVOT01FTTsKIAl3ZGV2LT5od2J1c19v
cHMtPmxvY2sod2Rldi0+aHdidXNfcHJpdik7CiAJcmV0ID0gaW5kaXJlY3RfcmVhZCh3ZGV2LCBy
ZWcsIGFkZHIsIHRtcCwgc2l6ZW9mKHUzMikpOwotCSp2YWwgPSBjcHVfdG9fbGUzMigqdG1wKTsK
KwkqdmFsID0gbGUzMl90b19jcHUoKnRtcCk7CiAJX3RyYWNlX2lvX2luZF9yZWFkMzIocmVnLCBh
ZGRyLCAqdmFsKTsKIAl3ZGV2LT5od2J1c19vcHMtPnVubG9jayh3ZGV2LT5od2J1c19wcml2KTsK
IAlrZnJlZSh0bXApOwotLSAKMi4yNi4yCgo=
