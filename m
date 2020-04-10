Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C431A46E8
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgDJNeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:34:05 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbgDJNdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Do9wm2Ed6CXC9vk9B+ydY/AFSGCyAq6zkUZ9iKMjxM6j338xhOpfmN+4RkauGFVU+DV7AcZXPMthrL4YgnIpSyhYW/TOCMPc9apK9xas7zReNVlMkYtDXoIPl5F93gN3Iq71jpBVZgiiZWJk/qRaBNxuxDWDYcSpcS8EtdLf7PzFCqPe0IxIv9DNjz385ox5dvzwJOVY9ZB+HTzQWjgLWEOmVe/rUylt3nUR1GgoLqkGNW57X3yctE2omP9pwXJDsonHWrREfC0sKj61i30WTl08nzNzyCeQkux6Cidc1rbIKTDUWMUv4+/DtTyPIRHjvRw7F6dwIeHbGrMp7D/NSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8AN5xT7IguMhQFKKbm8f6euP1V+PzcY6ax0tLhh4Yc=;
 b=W5sDlwfm7H9uuIxg4BZeHnrT00IV+dLdGG2i8K6O7G6jQQFdppUzLDhBViZNZxzm/dKLW/9Y7I0jYgj8zDqv6EH+2iWNIWcT6XppeGL2iy65yCSHGTeaz/8wKweIFeAjkpRptIzw270+WyqyydM0oMiV2VjqNjXNZOKGhTvaiPsRPPnumEbQOsiMzo1agIQby6ZuYJJ7BdVK98ltHctXjnQJj+4zVYfdXBPeAkiQZ94hbfncqlbj0C514YM0CvreUs+jsSjNQ3odjNz/DAE6vvtwPo73nZe4BH1XCZ6mm48c1Tpa0+hxm650lw39bBR9Q8lOk9lgPYOOb9fgCFp8Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8AN5xT7IguMhQFKKbm8f6euP1V+PzcY6ax0tLhh4Yc=;
 b=hLST5vOlGHkn7CPSqY75SDrSRhX7v+7BYagqH7XTKNoFIbAeJWjFT62OD7/jAwH3PbTcamwWDALG6Lw1900kToNKauhOtMS2VQVmpQa15F74lP9WVnlXqbLDEiRZF1VaYESBGzYFGwfMNeOajArrdfbHFEFk3fL6lc1b+lr7UbQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:29 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:29 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/19] staging: wfx: re-enable BA after reset
Date:   Fri, 10 Apr 2020 15:32:36 +0200
Message-Id: <20200410133239.438347-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:27 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9eba5aa-0f4a-45bd-8741-08d7dd53c14b
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43984058C1DA6E92B6F8BAA193DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:466;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AzICaktitYAJdEPNOKM9VUcnrZEAx+prlsUnKjQcOn6+WesOzesmfrN7KNMwffmBUX1ZZ/gd7mSWAW6KD4Ee5UCZOtg5HXBCmA1lcfzfQGSsWvO1x3wzniKO/Cy9azqasQSS+PuODIShj2v7YENzTh/+NYeax9y8EoQcNt+h2EmUWD6bfAV0GETBG3XIeJlfXCyJl4nojLUy7buHTNogQ4PiNEAHJtclDsdRseVWtdfB/Z0h/DSZuX7V2UbiMxfYDJX4ro9ZrA+2XDcrrjDNUXAX2V1jhXsP4HhmpdYfTgs8mRZ+S2bZyRtI9ExmS7yz0nvQrsFLI3pTH2ueGO7IC76dVlzRWpBUK0xj1BMLmeHzbCRSqt2C3/2JO1HhbsKvp+IW7ZA0urXfyGzHYdFZzc1qcEQD683sxz1GyOGMMN0V3UerAw5N/cYGzpVMoNu
X-MS-Exchange-AntiSpam-MessageData: Byf+8mTT61DGtMMp3IaIrI5vyy1/qXQUhQxj6UUzL3kHgEnd/k+FySUwrt8Ag+M0HYsRjL02cKjPBYwrC0UwH5tzM+mIkBVmi5NAU/MGRb+riv2p+mVLD6eaSxKe+hn1tQBkRjGjJx6nEw3eHrYOs6c33965TQCuC/SjcfoTnIcU+5qJKsp1Qq/lzmMouQP59Aa9o0UJ37lCTMTiybOiWA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9eba5aa-0f4a-45bd-8741-08d7dd53c14b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:29.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DPcqjRyX5yNc2jKSzsw1oN51eP2ZA9lL2tPVIe/EbngtTONHH9CKC7IbQyMTlTLhFBPbh63owIOpzFTHN6LUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmly
bXdhcmUgZG9lcyBub3Qgc3VwcG9ydCBCbG9jayBBY2tzIHdoZW4gbXVsdGlwbGUgdmlmIGFyZSBy
dW5uaW5nLgpUaHVzLCB3ZnhfYWRkX2ludGVyZmFjZSgpIGFuZCB3ZnhfcmVtb3ZlX2ludGVyZmFj
ZSgpIGVuYWJsZSBhbmQgZGlzYWJsZQpCbG9jayBBY2tzIGFzIG5lY2Vzc2FyeS4KCkJsb2NrIEFj
ayBwb2xpY3kgaXMgYWxzbyByZXNldCBhZnRlciBoaWZfcmVzZXQoKS4gRHJpdmVyIGhhdmUgdG8K
cmUtZW5hYmxlIGl0IGFmdGVyIGVhY2ggY2FsbCB0byBoaWZfcmVzZXQoKS4KClRoaXMgcGF0Y2gg
cmVmbGVjdHMgdGhpcyBiZWhhdmlvci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIHwgMTIgKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDIxZWNlYWZjOWE5NS4uOTFiNGNlOTQ1NTk4
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKQEAgLTQxNiwxMyArNDE2LDEyIEBAIHN0YXRpYyB2b2lkIHdmeF9kb191
bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJaGlmX3Jlc2V0KHd2aWYsIGZhbHNlKTsKIAl3
ZnhfdHhfcG9saWN5X2luaXQod3ZpZik7CiAJaGlmX3NldF9tYWNhZGRyKHd2aWYsIHd2aWYtPnZp
Zi0+YWRkcik7CisJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPD0gMSkKKwkJaGlmX3NldF9i
bG9ja19hY2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4RkYpOwogCXdmeF9mcmVlX2V2ZW50X3F1ZXVl
KHd2aWYpOwogCWNhbmNlbF93b3JrX3N5bmMoJnd2aWYtPmV2ZW50X2hhbmRsZXJfd29yayk7CiAJ
d2Z4X2NxbV9ic3Nsb3NzX3NtKHd2aWYsIDAsIDAsIDApOwogCi0JLyogRGlzYWJsZSBCbG9jayBB
Q0tzICovCi0JaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHd2aWYsIDAsIDApOwotCiAJd3ZpZi0+
ZGlzYWJsZV9iZWFjb25fZmlsdGVyID0gZmFsc2U7CiAJd2Z4X3VwZGF0ZV9maWx0ZXJpbmcod3Zp
Zik7CiAJbWVtc2V0KCZ3dmlmLT5ic3NfcGFyYW1zLCAwLCBzaXplb2Yod3ZpZi0+YnNzX3BhcmFt
cykpOwpAQCAtNDkyLDkgKzQ5MSw2IEBAIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQogCX0KIAlyY3VfcmVhZF91bmxvY2soKTsKIAotCWlmICh3dmlmX2NvdW50
KHd2aWYtPndkZXYpIDw9IDEpCi0JCWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZG
LCAweEZGKTsKLQogCXdmeF9zZXRfbWZwKHd2aWYsIGJzcyk7CiAJY2ZnODAyMTFfcHV0X2Jzcyh3
dmlmLT53ZGV2LT5ody0+d2lwaHksIGJzcyk7CiAKQEAgLTU5MSw4ICs1ODcsNiBAQCBpbnQgd2Z4
X3N0YXJ0X2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAq
dmlmKQogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZf
cHJpdjsKIAogCXdmeF91cGxvYWRfa2V5cyh3dmlmKTsKLQlpZiAod3ZpZl9jb3VudCh3dmlmLT53
ZGV2KSA8PSAxKQotCQloaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHhGRiwgMHhGRik7
CiAJd3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfQVA7CiAJd2Z4X3VwZGF0ZV9maWx0ZXJpbmcod3Zp
Zik7CiAJd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMod3ZpZik7CkBAIC02MDcsNiArNjAxLDggQEAg
dm9pZCB3Znhfc3RvcF9hcChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIx
MV92aWYgKnZpZikKIAogCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7CiAJd2Z4X3R4X3BvbGljeV9p
bml0KHd2aWYpOworCWlmICh3dmlmX2NvdW50KHd2aWYtPndkZXYpIDw9IDEpCisJCWhpZl9zZXRf
YmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKIAl3dmlmLT5zdGF0ZSA9IFdGWF9T
VEFURV9QQVNTSVZFOwogfQogCi0tIAoyLjI1LjEKCg==
