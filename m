Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE3210E9A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbgGAPIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:32 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:60865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731822AbgGAPIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVHR03frRMjauhD5R0fOgoU4a6YK0ZFf17f5lHQ8WWK3Ne81vg7mOd4kWwi8Msym6IqPmV+R1QjcYOMKF6xugiGxkXbjZdmSMvL54HwVhWl8B7CULy6O62SlkTYsvYThHHiGnfgWV3VokbkTTcxwI5n25exLdP6wybp+0lobHzUgVLruEzwigL/rffhXWe/tUBObu1ZqPtaG4JxkZ8y6IB1atiKgiRWVfJ3yJB6l7zHxVERrmbBSJfqkWri62kXr9fmIRZ8sPZEn5IdwI4NephXg1+0yn0VxwbN9bqzMtC0Mhod4hq4DbY8I+p9qezl/Glg653L0+8BwA2pzm2Bq1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hB/6Xa6eeRnTz1L+897aJzexVnayVWpXMV1KfAnJI7E=;
 b=liDkTAuvaSa0jhXCUwTBEbQACiYTiqna6EUhdHRmmNKo4jzqAdFoF0QmF/maMJinVo1HELf4/KZBKPKDYt94zTpLpMwzUu4mufwSkRxyO6Zn4MnkplEGHL9ce6/LQIfGzdMlHzGydTEfFyS3STliJc3arfeuI21D+DohmjnzDK9S0QVU1LwXrDiMc8014f2t6cyKj/faF0rpYB7mUdsmE75LZyKh3N9GSYsNpWLd6C0WENahVHSsmdCySIAbD2+3F7ODZ271hegZrmzq7ctKO/q1NTqxCgQ3trGLHl0AethR6vjJFyfW/46Bvo0J5CCBwO1+n032PG3R1/423VdouQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hB/6Xa6eeRnTz1L+897aJzexVnayVWpXMV1KfAnJI7E=;
 b=jJFP0WAMUaRBb4V8Tw8nHX61dotOaB6K1saLvhhTCg35HowWYXc856ShfIg5umuLrZW9T5iMu8SVa2ww7Axj6lEaor8URV6coLGCLX0xrV/CkiOfdtSwjK6/1D+1a+O1A1nQY0TREIEvdVUOaTl4AJ2d9HYdU2gNZiPdvn4+Ty8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/13] staging: wfx: fix unexpected calls to ieee80211_sta_set_buffered()
Date:   Wed,  1 Jul 2020 17:07:01 +0200
Message-Id: <20200701150707.222985-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
References: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:13 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb401ad-bf63-4981-74b4-08d81dd093dd
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4736E5610BC230B9C0C8D54C936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPQpSyuN2akS9BlpB14TBMDOtq6c8LcNAg8n3vshyAFiXEfR63UuHyb7HEY99Io/NHzMr4QM09bDU5VK97dKqDv2IQKg1jNBRZlxqK2nphAYFXFiStA+8mIgErnOyhjGJJs0mF07s1T2146uGR6srrRDmFBj+uQKX9AurB0HtJuAGVw9c5q9yK183hVueVHQZO6IkhGz0Xu9GbWgrfrNeKMzLVihZn4FP6PoLoTG+jR4qx9kpRzWvxwpNKBJaLsXNSDU/38oDA2l0tjk2ZYQJFBvEHQrxRzhZ47wdtbBkAqITpNjaCEp0S7D+3iuBjYjCA6vPemyWV0WA97tjcQ3Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oljQrsq0FdVWeAwooJyuI7F5NTfEtVxBt8Bzl1JsiMrTCGShC6Y88LxUtJigihf/uQgh097E6lmAhiOzi15sRSZidpQec8GPDpIF5IYxlQ6cZYNPFTXzCfLl53vQJlfWivb+dedy/7QiMrmTG0/Mfpgmaiuz9MCi2kci1G301RjaDqbmxEguBeTaQaHKoXWIxAEi2ItqZZxD2Mb+PddFwWf1UgRs4WTroP9dlBhrW1TPgcGNa1qIT/ZlcVHmGe+AUcHJw8EbBuRhgIyVXHpEKUmeWwf2U5Gp055m9+jAHS1nIh9nqB3OVpcUd/Cb0rQUvkoxQ71bOS3RvccuYJlsmGRrvCz+nlNFxjbE5Dnf6oHfYEqSPkXjFijxyx6K406bFl9PHyD8QSUD+InDG8/z15/5LFeCej06HMXNF2ebNVlzIO+5GjOgFeoe1vRFHDXVGGIrYjThhEoZQzLPL4MPMvi1LEXwAQoCtS4qD969AMtHdl3w/3+0iR9B273EikAhH9dAp2RFVmEEalQ4kZXldwTlZGFaunVj7SEFMav6eqs=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb401ad-bf63-4981-74b4-08d81dd093dd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:14.8030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5tCI/GPyv6VQROsWbCV/qZrtG6huFxYwnirNIcFjvL6RalwsLApCJ9wPgdRBWO51WoVWT7qNi880vO5De9CDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBhIHN0YXRpb24gZ28gdG8gc2xlZXAsIHRoZSBkcml2ZXIgcmVjZWl2ZSB0aGUgc3RhdHVzIFJF
UVVFVUUgYW5kCmZvcndhcmQgdGhpcyBhbnN3ZXIgdG8gbWFjODAyMTEuIFNvLCBuZWl0aGVyIHRo
ZSBkcml2ZXIsIG5laXRoZXIgdGhlCmhhcmR3YXJlIGJ1ZmZlciB0aGUgZnJhbWVzLiBTbyB0aGUg
Y2FsbCB0byBpZWVlODAyMTFfc3RhX3NldF9idWZmZXJlZCBpcwp1c2VsZXNzLgoKSW4gYWRkLCBp
dCBzZWVtcyB0aGF0IG1hYzgwMjExIGRvZXMgbm90IGV4cGVjdCB0byByZWNlaXZlCmllZWU4MDIx
MV9zdGFfc2V0X2J1ZmZlcmVkKGZhbHNlKSBhZnRlciB0aGUgc3RhdGlvbiBpcyBhc2xlZXAoKS4g
V2hlbgp0aGUgZGV2aWNlIHNlbmQgZGF0YSB0byBhIHN0YXRpb24sIHRoZSBmb2xsb3dpbmcgc2Vx
dWVuY2UgY2FuIGJlCm9ic2VydmVkOgoKICAgLSBNYWM4MDIxMSBjYWxsIHdmeF9zdGFfbm90aWZ5
KGF3YWtlKS4KICAgLSBUaGUgZHJpdmVyIGNhbGxzIGllZWU4MDIxMV9zdGFfc2V0X2J1ZmZlcmVk
KHRydWUpLiBTaW5jZSB0aGUKICAgICBzdGF0aW9uIGlzIGF3YWtlLCBpdHMgVElNIGlzIG5vdCBz
ZXQuCiAgIC0gTWFjODAyMTEgcmVjZWl2ZSBhIHBvd2VyIHNhdmUgbm90aWZpY2F0aW9uIGZyb20g
dGhlIHN0YXRpb24sIHNvIGl0CiAgICAgY2FsbHMgd2Z4X3N0YV9ub3RpZnkoYXNsZWVwKS4KICAg
LSBUaGVuLCBzaW5jZSB0aGUgZHJpdmVyIGhhcyBkZWNsYXJlZCBpdCBoYXMgYnVmZmVyZWQgc29t
ZSBmcmFtZXMsCiAgICAgdGhlIFRJTSBvZiB0aGUgc3RhdGlvbiBzaG91bGQgYmUgc2V0LiBUaGlz
IGFjdGlvbiBpcyBkZWxheWVkIGJ5CiAgICAgbWFjODAyMTEuCiAgIC0gVGhlIGRldmljZSBhbHNv
IG5vdGljZSB0aGUgc3RhdGlvbiBnbyB0byBzbGVlcC4gSXQgcmVwbGllcyB0aGUKICAgICBSRVFV
RVVFIHN0YXR1cyBmb3IgdGhlIGJ1ZmZlcmVkIGZyYW1lcy4gVGhlIGRyaXZlciBmb3J3YXJkIHRo
aXMKICAgICBzdGF0dXMgdG8gbWFjODAyMTEuCiAgIC0gVGhlcmUgaXMgbm8gbW9yZSBmcmFtZXMg
aW4gcXVldWVzLCBzbyB0aGUgZHJpdmVyIGNhbGwKICAgICBpZWVlODAyMTFfc3RhX3NldF9idWZm
ZXJlZChmYWxzZSkuCiAgIC0gTWFjODAyMTEgdXBkYXRlcyB0aGUgVElNIGJ1dCBzaW5jZSB0aGVy
ZSBpcyBubyBmcmFtZXMgYnVmZmVyZWQgYnkKICAgICB0aGUgZHJpdmVyLCBpdCBzZXQgdGhlIFRJ
TSBmb3IgdGhlIHN0YXRpb24gdG8gMC4KCkFueXdheSwgY29ycmVjdGx5IHVzZSB0aGUgaWVlZTgw
MjExX3N0YV9zZXRfYnVmZmVyZWQoKSBBUEkgc29sdmVzIHRoZQpwcm9ibGVtLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgMyAtLS0KIDEgZmlsZSBjaGFuZ2VkLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggZGNlYzcyMmFmYjE3NC4uMzI0
NGE3NjgzNDVjNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTIyNSw3ICsyMjUsNiBAQCBzdGF0
aWMgdm9pZCB3ZnhfdHhfbWFuYWdlX3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVl
ZTgwMjExX2hkciAqaGRyLAogCQlzdGFfcHJpdiA9IChzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICopJnN0
YS0+ZHJ2X3ByaXY7CiAJCXNwaW5fbG9ja19iaCgmc3RhX3ByaXYtPmxvY2spOwogCQlzdGFfcHJp
di0+YnVmZmVyZWRbdGlkXSsrOwotCQlpZWVlODAyMTFfc3RhX3NldF9idWZmZXJlZChzdGEsIHRp
ZCwgdHJ1ZSk7CiAJCXNwaW5fdW5sb2NrX2JoKCZzdGFfcHJpdi0+bG9jayk7CiAJfQogfQpAQCAt
NDcxLDggKzQ3MCw2IEBAIHN0YXRpYyB2b2lkIHdmeF90eF91cGRhdGVfc3RhKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyKQogCQlzcGluX2xvY2tfYmgoJnN0
YV9wcml2LT5sb2NrKTsKIAkJV0FSTighc3RhX3ByaXYtPmJ1ZmZlcmVkW3RpZF0sICJpbmNvbnNp
c3RlbnQgbm90aWZpY2F0aW9uIik7CiAJCXN0YV9wcml2LT5idWZmZXJlZFt0aWRdLS07Ci0JCWlm
ICghc3RhX3ByaXYtPmJ1ZmZlcmVkW3RpZF0pCi0JCQlpZWVlODAyMTFfc3RhX3NldF9idWZmZXJl
ZChzdGEsIHRpZCwgZmFsc2UpOwogCQlzcGluX3VubG9ja19iaCgmc3RhX3ByaXYtPmxvY2spOwog
CX0gZWxzZSB7CiAJCWRldl9kYmcod3ZpZi0+d2Rldi0+ZGV2LCAiJXM6IHN0YSBkb2VzIG5vdCBl
eGlzdCBhbnltb3JlXG4iLAotLSAKMi4yNy4wCgo=
