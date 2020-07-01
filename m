Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907D2210EAE
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbgGAPJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:09:12 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:60865
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731780AbgGAPIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S68QMCsToCvYzqlnINJY+6L6yb5TS+vlvaHc1vVRynLKZvNtMBp9pyD30dByIKE1SvN6P7V+mSz+rViXKaGjpmMSnuq55t7JSPu7aWbGnTkM3znD1IflzSNlfdunstKT1uhljvSq4GTdd/ytuCQb9ezXz1oLlkn0j+9u372PmhYFy8QV+TB/0rdPHd5t6lrTgjTiF7CJNzKXv4NllYqsgec6BiW5dNn2v1PNlew2N3oEBUIIEXOwF+btRufJmxGeZt/KD6/i+E0HagL95TcqJfiU5FPPWeCfyqwIzA2fozdFu7sUK2AEXg24Mzdu9YZFKhQIJDlDtm7btOVY0vD2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6b7vknL1fmLF2G45nV1ZuX4yW8ngc6jD/djmpaSsGo=;
 b=N0XAP0HcMqtZkb9+bclAVcxxzo0ITLUvou8Hdd0frhAswSsKjlzc5fQw2JGAUb6HAFiJWY5fC4YBCQBRFUuCHC0UxFyAJjylGDPrJ531/z4dVBsA8L+nLGSabB6nc63vEZshmw1fu4tDZZRWHoZ9RVvuwP7jfp+dXS/dP3f+xDW0z309vHjwvfoYXdYa/JkxV1Z2y0xAIdvRkcVrX51Q2N2Chx0zhgYFbVY7/avaMDT1sHiZEgewwKVvrWRS8I0LCKGsHEQo1lvvvN4O5muCJMOZCiXbyZ1Pll9ZBowz45WVqxKbm/HxZrGQpllh8i27bRH6yCfUn+HjNSPJ8y0rcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6b7vknL1fmLF2G45nV1ZuX4yW8ngc6jD/djmpaSsGo=;
 b=PESL5l14KSrMK/b0kwEzJdRYgHLJ282X7PmsI2xn1Jpi3LBds2asJIAEEX0Nllwjk5xLYQo1hl5I8BEvqMP8RAJTMXKywFelIz0CAVYs+MvDMg+pOVZPod7+iMS3/ZSdHvY9e9A1uhr/iFrGaMJy/GW5bhV7dRHuhpLm3kI6Lbg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:08:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:08:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/13] staging: wfx: simplify handling of encrypted frames
Date:   Wed,  1 Jul 2020 17:07:04 +0200
Message-Id: <20200701150707.222985-11-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:08:18 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfce7e93-f286-4fe7-fd6d-08d81dd0974d
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB47364E5BFB4D78BD239659E6936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyoaaWMzB8yML1Av7vf5WlIQdyH2lYiACo8UWyKlfSwrQgBjogxft9jKRDFtMYsbRRA9Amy7LAxF6NuUs0CLm1wLNY/UA/ife3Qnyq2LC6NgmuzPbmj8ya0OICh8eUw72BbXsy672eGcOtbyHMcYb3a+RlWbdpgjJn4RgA8U8p5ID3ErtA+Wk6rOE5WVjKE0BKJNMVU2NNk7d2IBFLDqGClynqM0bB1b696Z1XbARCGe04237yIZS4plB7rIisggy+/ssL4d4ziCVWnlQF9DQMwMhF7ig58C8uCN4uQpQZf1KULqRFkRcAnqbrj0Csxm4oa/67L+GCgB2bB3y5Ym8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(6666004)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lzCiDyUbt6pmgFrZks+GLAfgb86XMc95iz/B5x0y3kw+jT0w53MTXN229bX+A/tG5uvH1QnuG4y554yPTcQJkb0/6o+so0ZZdKu1H1Ro9hxvaoSRQNv66yu2slBsGsc6zGoIISWjiijdISoV7DSpoKIUZDKQkDc6Hy/jZYpsOS6PRZXTEiCxARhdeJcanOLphLwHoA2nssHtcFeSnx5UZ6DIHkp6UoLi23hRmUJUpYOxKpi7ZF0H9aUNmLD6h1/VlCtZxAZwY/2Z4CM5PdGs9qGtDbB+9P8c+nmWzXJCABBsvZsDDjcTN2JCt3D1bk9K/5obZdDaDCMMF3p5GPOjTymPtneeSp69lFExjH0Pr9IBETd4nsLGIM139vWHQPdrhswIwqKenBP+gMmDhb9ij5Qg5bw+yJm/SAqNS3HeQDAYsbNpGyEa6RDEHq59s7DFM+tC/xlvL/eS+DRrQgGRjOHsPyP7j7eXOaVVcihxl3Qoc1O0V3FsTqZvags6Ep3CjFjbOZfN8OHK5Ul+KYJHyrx/SfCAvM39uR55WEFCQOw=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfce7e93-f286-4fe7-fd6d-08d81dd0974d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:08:20.4207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPYS8KUGYq1340NlcQQjho7HEEYeKxnWectYjoZxjCUvoVWZovEKYgXdIyrDwVtmDsQOR00w2SXIUytY4cbhvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2Ug
ZG9uJ3Qgd2FudCBtYWM4MDIxMSB0cnkgdG8gY2hlY2sgTU1JQyBhbmQgb3RoZXIgc2VjdXJpdHkg
bWVjaGFuaXNtcy4KU28sIHRoZSBkcml2ZXIgcmVtb3ZlIGFsbCB0aGUgZGF0YSByZWxhdGVkIHRv
IHRoZSBlbmNyeXB0aW9uIChJViwgSUNWLApNTUlDKS4KCkhvd2V2ZXIsIGVuYWJsaW5nIFJYX0ZM
QUdfUE5fVkFMSURBVEVEIGlzIHN1ZmZpY2llbnQgZm9yIHRoYXQuCgpTbywgZHJvcCB0aGUgdXNl
bGVzcyBmdW5jdGlvbiB3ZnhfZHJvcF9lbmNyeXB0X2RhdGEoKSBhbmQgZW5hYmxlClJYX0ZMQUdf
UE5fVkFMSURBVEVELgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jIHwg
NjAgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDU4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKaW5kZXgg
MzE2YzJmMTUzN2ZlNS4uNjBlMmU1Y2I0NjU2YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKQEAgLTEz
LDU3ICsxMyw2IEBACiAjaW5jbHVkZSAiYmguaCIKICNpbmNsdWRlICJzdGEuaCIKIAotc3RhdGlj
IGludCB3ZnhfZHJvcF9lbmNyeXB0X2RhdGEoc3RydWN0IHdmeF9kZXYgKndkZXYsCi0JCQkJIGNv
bnN0IHN0cnVjdCBoaWZfaW5kX3J4ICphcmcsCi0JCQkJIHN0cnVjdCBza19idWZmICpza2IpCi17
Ci0Jc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICop
c2tiLT5kYXRhOwotCXNpemVfdCBoZHJsZW4gPSBpZWVlODAyMTFfaGRybGVuKGZyYW1lLT5mcmFt
ZV9jb250cm9sKTsKLQlzaXplX3QgaXZfbGVuLCBpY3ZfbGVuOwotCi0JLyogT29wcy4uLiBUaGVy
ZSBpcyBubyBmYXN0IHdheSB0byBhc2sgbWFjODAyMTEgYWJvdXQKLQkgKiBJVi9JQ1YgbGVuZ3Ro
cy4gRXZlbiBkZWZpbmVhcyBhcmUgbm90IGV4cG9zZWQuCi0JICovCi0Jc3dpdGNoIChhcmctPnJ4
X2ZsYWdzLmVuY3J5cCkgewotCWNhc2UgSElGX1JJX0ZMQUdTX1dFUF9FTkNSWVBURUQ6Ci0JCWl2
X2xlbiA9IDQgLyogV0VQX0lWX0xFTiAqLzsKLQkJaWN2X2xlbiA9IDQgLyogV0VQX0lDVl9MRU4g
Ki87Ci0JCWJyZWFrOwotCWNhc2UgSElGX1JJX0ZMQUdTX1RLSVBfRU5DUllQVEVEOgotCQlpdl9s
ZW4gPSA4IC8qIFRLSVBfSVZfTEVOICovOwotCQlpY3ZfbGVuID0gNCAvKiBUS0lQX0lDVl9MRU4g
Ki8KLQkJCSsgOCAvKk1JQ0hBRUxfTUlDX0xFTiovOwotCQlicmVhazsKLQljYXNlIEhJRl9SSV9G
TEFHU19BRVNfRU5DUllQVEVEOgotCQlpdl9sZW4gPSA4IC8qIENDTVBfSERSX0xFTiAqLzsKLQkJ
aWN2X2xlbiA9IDggLyogQ0NNUF9NSUNfTEVOICovOwotCQlicmVhazsKLQljYXNlIEhJRl9SSV9G
TEFHU19XQVBJX0VOQ1JZUFRFRDoKLQkJaXZfbGVuID0gMTggLyogV0FQSV9IRFJfTEVOICovOwot
CQlpY3ZfbGVuID0gMTYgLyogV0FQSV9NSUNfTEVOICovOwotCQlicmVhazsKLQlkZWZhdWx0Ogot
CQlkZXZfZXJyKHdkZXYtPmRldiwgInVua25vd24gZW5jcnlwdGlvbiB0eXBlICVkXG4iLAotCQkJ
YXJnLT5yeF9mbGFncy5lbmNyeXApOwotCQlyZXR1cm4gLUVJTzsKLQl9Ci0KLQkvKiBGaXJtd2Fy
ZSBzdHJpcHMgSUNWIGluIGNhc2Ugb2YgTUlDIGZhaWx1cmUuICovCi0JaWYgKGFyZy0+c3RhdHVz
ID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCi0JCWljdl9sZW4gPSAwOwotCi0JaWYgKHNrYi0+
bGVuIDwgaGRybGVuICsgaXZfbGVuICsgaWN2X2xlbikgewotCQlkZXZfd2Fybih3ZGV2LT5kZXYs
ICJtYWxmb3JtZWQgU0RVIHJlY2VpdmVkXG4iKTsKLQkJcmV0dXJuIC1FSU87Ci0JfQotCi0JLyog
UmVtb3ZlIElWLCBJQ1YgYW5kIE1JQyAqLwotCXNrYl90cmltKHNrYiwgc2tiLT5sZW4gLSBpY3Zf
bGVuKTsKLQltZW1tb3ZlKHNrYi0+ZGF0YSArIGl2X2xlbiwgc2tiLT5kYXRhLCBoZHJsZW4pOwot
CXNrYl9wdWxsKHNrYiwgaXZfbGVuKTsKLQlyZXR1cm4gMDsKLX0KLQogdm9pZCB3ZnhfcnhfY2Io
c3RydWN0IHdmeF92aWYgKnd2aWYsCiAJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5kX3J4ICph
cmcsIHN0cnVjdCBza19idWZmICpza2IpCiB7CkBAIC0xMDMsMTMgKzUyLDggQEAgdm9pZCB3Znhf
cnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNz
aSAvIDIgLSAxMTA7CiAJaGRyLT5hbnRlbm5hID0gMDsKIAotCWlmIChhcmctPnJ4X2ZsYWdzLmVu
Y3J5cCkgewotCQlpZiAod2Z4X2Ryb3BfZW5jcnlwdF9kYXRhKHd2aWYtPndkZXYsIGFyZywgc2ti
KSkKLQkJCWdvdG8gZHJvcDsKLQkJaGRyLT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEIHwgUlhf
RkxBR19JVl9TVFJJUFBFRDsKLQkJaWYgKGFyZy0+cnhfZmxhZ3MuZW5jcnlwID09IEhJRl9SSV9G
TEFHU19US0lQX0VOQ1JZUFRFRCkKLQkJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfU1RSSVBQ
RUQ7Ci0JfQorCWlmIChhcmctPnJ4X2ZsYWdzLmVuY3J5cCkKKwkJaGRyLT5mbGFnIHw9IFJYX0ZM
QUdfREVDUllQVEVEIHwgUlhfRkxBR19QTl9WQUxJREFURUQ7CiAKIAkvKiBGaWx0ZXIgYmxvY2sg
QUNLIG5lZ290aWF0aW9uOiBmdWxseSBjb250cm9sbGVkIGJ5IGZpcm13YXJlICovCiAJaWYgKGll
ZWU4MDIxMV9pc19hY3Rpb24oZnJhbWUtPmZyYW1lX2NvbnRyb2wpICYmCi0tIAoyLjI3LjAKCg==
