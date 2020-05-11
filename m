Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442541CDF7A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgEKPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:12 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730610AbgEKPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4T5a4TPQjdKXa/UggiSqLvTa1Q9kQ2KUndvUvPNyICNxiGrkKS5bXypfno8aEqwcGPgwSsLb2U4A0fviP9ohWmFqqYqDLxXYaHkvBHuJc0WZyFvlcvLWC4hwQb4nUFa47MuCM7taef5ltMOMmoyJHQ1egRDWp4aaX2FreqNMrNxrcQs/w25ELFYwdtklX8gDzpC7KJ8VhrreSiE3wOSOlHqDsY5aEibBZeB5mnMDez50+oi+o4jGKfHnC5NKRup/yvzXGvSzn4cD7TM+SixEsdfivGJFPPFO7KJyr9O+B73cvE4xTfPAqDimuYH63dMBExhaMfkGwlCdyPBr8q76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt3E2OZVeFnb8bWFymkk46zKKa9H026w3su1lI1HuKI=;
 b=ihSo3+3hX3EkKOWlganB/mhyXrldf9ElXob+z6YdyhPMArpzet04B5ggM0Ibx9jq9zRvGo6LljHlwN8FK8+Gl7x9/dUHxN9m5jK0v3wkebne+YJ4phVxSIYLMmD8hQWD8n3URwyYV6M6thSKq59BYhpVI2e+BumGk0xudSYnlh8/x76agqgw2GiefjmuMUEm3XM6oYgw9Vow4fomtHyGjm9rhonLsPq2mh/aaiv6U0m2uh2j5cBSGlclN+a9xF9v6yPy5v5Pkyil59yZr/FAWzMktwnrUzejX6MoftdPaYAQDAI22Or/Al34VFDsu48HvOQ8Ktr2MFmJyDmTD3837g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt3E2OZVeFnb8bWFymkk46zKKa9H026w3su1lI1HuKI=;
 b=LqtQqBEwtIvF58AzOKpPbMIrBVQnFOPHF5qgT/Wb69cTZ71ZfsRQsU5+crFVWFBlnZMCa8u2bPTleDsN/k6nUHu/6915reWNkq698vkJXDGFG56+/uOxlJTL5fy0SH86o1ECSWCBpe7HEwT/n5TyjR0hFEg4gM8s1KDQ1+zbbrU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:04 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/17] staging: wfx: fix access to le32 attribute 'event_id'
Date:   Mon, 11 May 2020 17:49:22 +0200
Message-Id: <20200511154930.190212-10-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45edf3fc-7bc9-411c-a1a3-08d7f5c2f84f
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19687B034A6F0A7DD22D633893A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNkIkl3NeiRXulrps/JJdGL/pbfbahCfnV9X2Yy0kNzT0l2KypOlgzKxMw1dH50iTq3Q0d4Wu3VH63WTeU6dBliCLf1jjBFIwcuMU51Lx6o3aBRx/BrmRBk4EsGWuZf+mpfLmh561EYWqPKzMvXH0VYiPeWNdTyN6t5BSpmtJIkuZK9GkA2dFWUiN37S3S+O/JEoqgataYwY1pw0LqeT6ByU5lyyS6wmXjNMf3Bz7Gj/JXT8QHSNM2osRc3jx+7F/y4pQuc0hpo+1W3eO6nZN41EWIiXkbIyz/OZnMnSo0zavMXRX35c6Tj9FpTxh8SJwapcCDb3dT3Ee6koAouoYmiToFQhWTqExFJmXHrtJG7E0UJn0uEWVyMxAR4lqAERIBnqqj44QWMkt97tIxsp8BCMHEs3jpJCk1kwPh9UI5n+RpKrUCgN7TUzxIcYXmScIj+tr/vBABvJsvRt67QIRKuMwBn5umJinkDorzzTCJ/fu6v3+uPr0JjFqOHlTDL1r6Z7CVcIAi/cdo/FQ20CSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LqBmWiZcP+hM2KsFYyrt1TT9o0G9DjQQe6yCZkDsvhCiGt0+DAtnF5h+r91WuAd2zDoSdJlgoznLSmOydKYJA6EnYjno8Vsduu+XpJM0sYo/jiuHMFl6OfSZaa2UYVUL8rwjtGN8hyPIMPHoL3/6haWN+SXUp6VUWDgS6NPH0sqxKM0ELrr5SJS1TpZuiQXqIm/ZAqIzIu2JoGuYye2jbUH/i9bl48bCm7yaEyZ+RV81nbHuEd05c2kJxYBipQk7jTf4UtA9ajyuffHWKPb69QBYyUo77S2QWlA2oucQCdnrbCTO84IK/2x/24hquk7zskiLd7lJEtA8ZLpipmQGOpBx3/1TLhOKKFykOj1+4+sRlDrSW9uaPi8F1j2kg1oab9SSujQBjFtyAzklH+pFi+uzbVFpHimff4K1ujABLQJs1cZill8vqsD3OyZBL77pKtP7y0J+XG1ndJe2SmQ/FXzOZrRR3wJgQ0vayg/juEQ=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45edf3fc-7bc9-411c-a1a3-08d7f5c2f84f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:03.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/GTqtj8JecA6YXKLxK0N6TY4vIKu3+HEORSpwhsmh/HcbFfPkOOcxfyxGmXFepBXB1RzjEHUsUmp5Lg2RbvIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGF0dHJpYnV0ZSBldmVudF9pZCBpcyBsaXR0bGUtZW5kaWFuLiBXZSBoYXZlIHRvIHRha2UgdG8g
dGhlCmVuZGlhbm5lc3Mgd2hlbiB3ZSBhY2Nlc3MgaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7Rt
ZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfcnguYyB8IDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXggODdkNTEwN2E3NzU3Li45
NjYzMTVlZGJhYjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtMTU4LDYgKzE1OCw3IEBAIHN0YXRp
YyBpbnQgaGlmX2V2ZW50X2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYgKndkZXYsCiB7CiAJc3Ry
dWN0IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgaGlmLT5pbnRlcmZhY2UpOwog
CWNvbnN0IHN0cnVjdCBoaWZfaW5kX2V2ZW50ICpib2R5ID0gYnVmOworCWludCB0eXBlID0gbGUz
Ml90b19jcHUoYm9keS0+ZXZlbnRfaWQpOwogCWludCBjYXVzZTsKIAogCWlmICghd3ZpZikgewpA
QCAtMTY1LDcgKzE2Niw3IEBAIHN0YXRpYyBpbnQgaGlmX2V2ZW50X2luZGljYXRpb24oc3RydWN0
IHdmeF9kZXYgKndkZXYsCiAJCXJldHVybiAwOwogCX0KIAotCXN3aXRjaCAoYm9keS0+ZXZlbnRf
aWQpIHsKKwlzd2l0Y2ggKHR5cGUpIHsKIAljYXNlIEhJRl9FVkVOVF9JTkRfUkNQSV9SU1NJOgog
CQl3ZnhfZXZlbnRfcmVwb3J0X3Jzc2kod3ZpZiwgYm9keS0+ZXZlbnRfZGF0YS5yY3BpX3Jzc2kp
OwogCQlicmVhazsKQEAgLTE4Nyw3ICsxODgsNyBAQCBzdGF0aWMgaW50IGhpZl9ldmVudF9pbmRp
Y2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQlicmVhazsKIAlkZWZhdWx0OgogCQlkZXZf
d2Fybih3ZGV2LT5kZXYsICJ1bmhhbmRsZWQgZXZlbnQgaW5kaWNhdGlvbjogJS4yeFxuIiwKLQkJ
CSBib2R5LT5ldmVudF9pZCk7CisJCQkgdHlwZSk7CiAJCWJyZWFrOwogCX0KIAlyZXR1cm4gMDsK
LS0gCjIuMjYuMgoK
