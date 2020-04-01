Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0194319A9F9
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbgDALEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:04:46 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732006AbgDALEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg8qBwBTc1cAkmcmuKTtaz6nesFi3aAqY4HRF4FXLUZs6mQyr1rhnWAZrF+TRag3Ko8P3a1TeQh60BaXwinRaQrUq0nokFNUVGAJD5b618QmM4CULnMYSXHlNEGwmAYU0jUMVnqjjG09wenExR30wV6bCMcdg+ytpfkGMnTADoe2NavDjRezljI4pnCrOWRdgvq1FXmscNpKTXGUAsuVdehWGZURMKt/+UD/hAvuLGAgmf0Gh5rkAjjQIJnDkaZnfbGzbQ3Vp3yleqjlxgNXShTxZaBgtYJYB1vQCij1fHDebJa73tqzbP773KSIEQPrkhmVuQ1JgHv7Z3LI/rFSyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGM4LaUSzkuToWuyg8sMCdYGN32WYJxK4Mm/t0pV04M=;
 b=PhCBuTuQc7xGXzOkGh9jBohIFrImsX7K+gkLZIJorIgajuE3jDj7ff95dWCeCjpJXZn+XvfI+6xQFgKhl+f+DWMwdnbbik9+JB7vthHhUMTWwc2c0B0cUurXSVmO36hTW7EYesoZDUMzxY3byA2Ifn2+squgQue1sKLqFwzW5B8hXBNYlOBRsdqJMOyMwQr8zzjZScgDl4l10ikx8Qcl6dgV9VP/1rYy2irgl6f84PHN7BDtRRJYQwo7bsdcBor27iBR/wMnphVGllaO2NGnRnBTg+e9/0+i346Mh0262BOJGOU+o7rpVb0BYKYP2OpZEy0RpU4YNQvCWvMpWx5zZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGM4LaUSzkuToWuyg8sMCdYGN32WYJxK4Mm/t0pV04M=;
 b=c7MOUuXf1OA0Hlg4SI8AiorhmGrDQ6TfGDW4UnD/xsIqjtEGuM5oPHjJwtxy4cgfcpOikRhXDBKCPBZkakZt/vNpWB8uCzoEEghhfrGtyYGNpGfnIWD5xeSRpCcfdiRvq4l0S2qcBN/EZAE/T1tk4QMyRvs7u9dC35HMsVRdE34=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:24 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/32] staging: wfx: do not stop mac80211 queueing during tx_policy upload
Date:   Wed,  1 Apr 2020 13:03:35 +0200
Message-Id: <20200401110405.80282-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cbcb3bf-019b-461b-4a1e-08d7d62c6fe6
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB428503059972D33027D7E49C93C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLOTzXVBTgigxc+OSBOA2VrCqEVsYglHdCb3CT02YkokFpBuDWPkxqmnu7Rt3kwXKB2NqM0h9bzKXM39EOvLJxfO+ppH8BJedjARqlyARGXn57EWbMPKX3wjf5mQC34acEktjjIIbct8soYzglvLg5Rjpq3afDiW02K/k/Mp8UvFhgVXB2gl7HavBroI/rtEyf72xzh6PxEQ89t7slstpTh/m7T+a7CwopO8c+Burj/RkbktJ5WHJkjuSqCJF0YHzsnSahS5ZAFz9dyXTnUuUQ76U6rYCx8hZt4sr9wzA9X3KI0ji9k1crB3j8dWkmC9Zc41iSqpIMApVahRmNh6oDfxyFQkiyAjCI2b5B/fxmJ7rKEqG5ZehaQW2C7I1QJtJSPB4WCE9MCpDTuN5DdJ1t040cWs2B+8Ey8uDlUIPH9kHXgjnlrv0mgGQtgC9hfw
X-MS-Exchange-AntiSpam-MessageData: EeBVRa+tU8VKDBSXqi1Wi2J4b2+lfI93NywDoOg6qHeFI6fFwB8yKiCGDBazNGuXmJW00X3u9gnoyYoQsEouBjVDjGXzF1p8H+9Aey3weIkuv9tUdB7mtVC92J8pEtygnE5naGi0DrBU4Neki07+/elpuksGtyIlbH0vRsNMupTwSKVYRXRefmegHeUf7EC26RclwMhcVmoR0DpkwoOL/g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbcb3bf-019b-461b-4a1e-08d7d62c6fe6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:24.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjTAoAcXVPHktbHSsst/XcRONJHO6OOrGGVPu/YRfKXQGWMnplVAz8V6fM1TRE8kiLT+sEJNb78cY/4xaljMaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBhIG5ldyB0eF9wb2xpY3kgaGFzIHRvIGJlIHVwbG9hZGVkLCBpdCBpcyBuZWNlc3NhcnkgdG8g
YXZvaWQgYW55CnJhY2UgYmV0d2VlbiB0aGUgZnJhbWUgYW5kIHRoZSBwb2xpY3kuIFNvLCB0aGUg
ZHJpdmVyIHN0b3BzIHRoZSB0eCBxdWV1ZQpkdXJpbmcgdHhfcG9saWN5IHVwbG9hZC4gSG93ZXZl
ciwgaXQgaXMgbm90IG5lY2Vzc2FyeSB0byBzdG9wIG1hYzgwMjExCnF1ZXVpbmcuCgpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAxMCArLS0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHgu
YwppbmRleCA0MjE4M2M3MGQ0ZGYuLjdhN2MyNTE4ZjZjZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMK
QEAgLTI0NCw5ICsyNDQsNyBAQCB2b2lkIHdmeF90eF9wb2xpY3lfdXBsb2FkX3dvcmsoc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQogCQljb250YWluZXJfb2Yod29yaywgc3RydWN0IHdmeF92aWYs
IHR4X3BvbGljeV91cGxvYWRfd29yayk7CiAKIAl3ZnhfdHhfcG9saWN5X3VwbG9hZCh3dmlmKTsK
LQogCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7Ci0Jd2Z4X3R4X3F1ZXVlc191bmxvY2sod3Zp
Zi0+d2Rldik7CiB9CiAKIHZvaWQgd2Z4X3R4X3BvbGljeV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3
dmlmKQpAQCAtMzc5LDE1ICszNzcsOSBAQCBzdGF0aWMgdTggd2Z4X3R4X2dldF9yYXRlX2lkKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLAogCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJ1bmFibGUg
dG8gZ2V0IGEgdmFsaWQgVHggcG9saWN5Iik7CiAKIAlpZiAodHhfcG9saWN5X3JlbmV3KSB7Ci0J
CS8qIEZJWE1FOiBJdCdzIG5vdCBzbyBvcHRpbWFsIHRvIHN0b3AgVFggcXVldWVzIGV2ZXJ5IG5v
dyBhbmQKLQkJICogdGhlbi4gIEJldHRlciB0byByZWltcGxlbWVudCB0YXNrIHNjaGVkdWxpbmcg
d2l0aCBhIGNvdW50ZXIuCi0JCSAqLwogCQl3ZnhfdHhfbG9jayh3dmlmLT53ZGV2KTsKLQkJd2Z4
X3R4X3F1ZXVlc19sb2NrKHd2aWYtPndkZXYpOwotCQlpZiAoIXNjaGVkdWxlX3dvcmsoJnd2aWYt
PnR4X3BvbGljeV91cGxvYWRfd29yaykpIHsKLQkJCXdmeF90eF9xdWV1ZXNfdW5sb2NrKHd2aWYt
PndkZXYpOworCQlpZiAoIXNjaGVkdWxlX3dvcmsoJnd2aWYtPnR4X3BvbGljeV91cGxvYWRfd29y
aykpCiAJCQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOwotCQl9CiAJfQogCXJldHVybiByYXRl
X2lkOwogfQotLSAKMi4yNS4xCgo=
