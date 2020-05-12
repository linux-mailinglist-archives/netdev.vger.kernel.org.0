Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770401CF886
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgELPFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:05 -0400
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:30085
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgELPFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GomczdWaa9Vm5omdaMzMG2+kDjzdeS2CYvoCGZ7IeslIzZ06axF/nGmzGj7zMFrclaHZfe7ZV58+DNsH73c1AQIMDnI3yAbnh0HIunzDfFfJEY0HgcVZsrw4WK2bVx3TwdeV1+kn+WiW1/cIdVWdSPOdBPuTvOH8Y5ajKywiBGBDKUtmtj15V8SbQs8I6HRJ5LcxwQyZ90U8xpRQIEDl+G5figT62OY/bA+j72JVUaH1JLEV7pbzBXj1xFiX2cDEighCIvZ7YYl60GUH7PEuhxRWgjoNLR8E1kZnB6dowOoredNfcIN1dmDQc0yEKWjntayG6WVTn877rN58f6S/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt3E2OZVeFnb8bWFymkk46zKKa9H026w3su1lI1HuKI=;
 b=SiHzjbQC60mvHdWcUniblOCWDW26H6c4CVNNPD0GgzatTiy1s+opHLwL/svboLeSTl1t2h0FH1CllfgSCvY9Jd2Q7TivmzNPoTdMVBHsdYzJ5mfmRcoZ/0vXSFce1p1DWTYA/FRB6eZ6gcZLWY4wlTMV+Zjpm2mrO/Ag4L2DP2f1BmyE1FGjxQbiHZEhpEaBiyO4BRDjEFhd9P6vOpUlAlMy1FM31Hw51NtiIJ0yZBO5v4zitoIHbzPf/2MtrsmjR8pYs8wjG8OoKlHklHW/LzpgdJANuC+mYsCIqnf3S3m+5xI2ar8SVSbhf4MjxK/0LDtholkak2/fU1UIwFg7oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt3E2OZVeFnb8bWFymkk46zKKa9H026w3su1lI1HuKI=;
 b=cYUiiCGACVm/nuYkJOOWhvz36WtxZZ1gL351txwLVy3KfO4u4zi6cFc1CNERDfKWce6VskUq4aCldQQcfj0iRg6PT0ix56Rn5zlCzREH/SikafN0l+qVo9D9vcENZb6ivWwfcl4kzkk4S3/ShibP6aky3GF5gs3qQ8VCwGZCwHI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:48 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:47 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 09/17] staging: wfx: fix access to le32 attribute 'event_id'
Date:   Tue, 12 May 2020 17:04:06 +0200
Message-Id: <20200512150414.267198-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f5db97e-4558-4364-b9ee-08d7f685cfe1
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB174130A9EEEE09571662F27593BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4unEOn39GUeZrOKCSF27EunVVe3wQhjUIZRI6Jt8c71CieyhEWCGnBLlAZ/F1gI+m4R5kca8vZplgUTGV6iqP3d/efNEji+XHlBIfg5tOBFPeJ8nAmIWeV1QYvTQcP5/cO4UFgWvDMTBCzT3dC2LJc80ECEX8zxsEqUizb1UFZyeWvbijZsFJDAaY/XgTlPNwStZYiZfJ8ehmXnv0EJnNWdBadWRWtAwljUbJbvXMCBkklvQ87A94RzdNZ7af1ZaLOyoWuV+HNWf8WRXXG8mCWZTf4UqXZSieluEBB2bepvvwKxV9d6MRW2YA8M+itHS9vjZqsqFnyDWQsq/wTJt7fVPrZw47A2zHigf7Ygk1e5h8CHyah1QVfAbg9uqtIKaaLCqPQs/dEcdVmsCav0f1tDoZT31VfjdD4Qv11SQyaVR0GL0QMPWoHAZ/4Bic3AhX5EVqxAW4Ou0FiUpnulPotHudoTTQ1MRLIiXtdd72g3Sr64BaeOJSctaGIfgP8hqqo2Q87F1XcZ1S95adyHt8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0H39U8S7l+1dWHoeghI2yyb6+2YzQzFRR7w/TvoAKVJm36RY0NIS1CVS6oglL+YPMBGJww815iBHyHFXYWu6KCpNWWhhdpsVTl3Gdo0498QRlqrsbAp17LYCCc/UYiADB3R7jFf9IDXffztdbhx4Rx26DR+YLkvjE6S/sgAq7yNOPMRFeKu/ZqoHvyMQIZy0AJbNpU9SxSd7BZAXOHlTMZ+4brIx4WxtXIHo+d0jmFVsaVKrMUqVwAo6/vu02DNr0hsu4XUdWP9U+ls6O93qkbIO936AORdviXs5Jx0Xx9AhqC+EYbex52FubHXCm5jzVoX4vfBtnv2aatT9yguDlx/LOkl2tfdw0b8LM4x8RBqgkV24+UGbG3SgPdgo3U6ENaP4dOV2cU/5S8FOhksQBmaqX1JBCOmvvGEg/oguLOKoFe9aNwZ+WRjBX3QAm69zs28gFAl4RCZ3EWt1aHCWShObgPKDHZ7nmfB3wPfDf98=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5db97e-4558-4364-b9ee-08d7f685cfe1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:47.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpiRRffPWpFmh5hjo70BlBPz4Y6rOArdjC9A5TxsWGmeRm/1XaqjewWRDoaNU5ysR3c6I0/z0bXeMfv3MjduAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
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
