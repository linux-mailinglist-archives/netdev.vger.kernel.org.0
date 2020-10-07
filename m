Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03318285CC2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgJGKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:20:16 -0400
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:13506
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727527AbgJGKUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:20:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkdEBkfoFkfx1Md3wFg1dOoig328oJ5v/4oH8K+uASHoWl274Kq1cDCPn+DeIr8qFWovx02+scBebPx0BIBs1vJLnaFys9mGx95pe5vwUTtNVfUhyJu7lm8F1xmOu2nCOuckAILuWUTuFyShKZ6rnRKQXQeyR0JAVZHr9Se8jN2a1UO+vE6HGQTk3giWLuu9JUdNg++KfImEHz+zg7pH6EEU7ZzQ11PRN+8RaNqG0oFuFFGIW4At8GazFHz1926NTBfB4VyBdkmKk+JPhP4DBJBJgCinmet1VJTVdEVIdBNrqoOlP8/6bxjyg6wVy4hBLE4cb3FI/NkyMWM8afyVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YJVambf0o+sPW9rei/7XbS5sUYTZmIjQNXI9rbr5kM=;
 b=DMDNzHYYsoPPGnC1Z1JvUgU3F20pZSOvOqoz5HdBE5mS+wYLprDPVPkB5dP9zvOcHPoK4yM3dd1HbGcwxyNRdxd3mN4qtzEWmfgMrPj7BzZXDoduRWjwcwvvLoxgucUrvGl3QT39q/Glu+K2a2gIXCEOcjXkZggMh485CyFg0lTTv9xRWbBH0PQTN0qpL2CdlqgNY+AHqyX514SnEZuflWYGaSed6yfAy4QQ1Xi4xXk4NPniCofbChiSfSY+X3nHntLVPbjmXrTcU9K7yhNMVebjwf2QYCAnNmg1w6jSr7W1EbM57vCRISXL9wRsw8zWxyX5VdXUYfKc87VD55eAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YJVambf0o+sPW9rei/7XbS5sUYTZmIjQNXI9rbr5kM=;
 b=PewbHmVnYV5/Y3xPNdCj2kn/W9m0c73kPJ37VlKfXKbSNTtU92zUkVAF4ANXkz+IIyY1kumLlkiwD9UWQ98QnSiJfhQ66O6dWLSwQH0y6XfXv9CoFRN4vnuQE6+iL09siL/WFnFcuBDm6JqZDYBxJtrdec0uKWZGeqh5PbFtVPQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4670.namprd11.prod.outlook.com (2603:10b6:806:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Wed, 7 Oct
 2020 10:20:04 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:20:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/7] staging: wfx: fix handling of MMIC error
Date:   Wed,  7 Oct 2020 12:19:37 +0200
Message-Id: <20201007101943.749898-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 10:20:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86fd68d7-d78f-4a36-44e6-08d86aaa8ed6
X-MS-TrafficTypeDiagnostic: SA0PR11MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4670D609D6EAF52D3479F426930A0@SA0PR11MB4670.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayzdFoTbbW55tlYIFvKc206LHh2zCJF0lJr1sGzoHbIJG1O2mWpvvK29jRg2uIo8Q2HrX+jWpWllo/RhaA/epfaJriLUNlPXLKjr29r8xiN9uZB/L09wWfEoqR2plEy+r/xB+ruZPWK0eAL/Sn9uUREuwcHKw4UPGWPPFjukNIKRdwHKiA4WkAeS4XO/MtM+27+MWRmBhwlJE7vwbl+0EwfDsUkbW1jabmu+EjYd/e27CNxyDQ5PbcUmGStMf0RwFnNAwR9/CW48K4jOLSfQk6/VXz2Brlj7TAycCzdG5FguQ3t/Xu0od1cD/zNbOHYFrPxYmSKTfTnFYJAnK7cDdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(136003)(376002)(366004)(396003)(66556008)(66476007)(6486002)(66946007)(316002)(54906003)(4326008)(478600001)(2906002)(1076003)(5660300002)(186003)(8936002)(8676002)(16526019)(52116002)(83380400001)(26005)(6506007)(66574015)(2616005)(86362001)(956004)(107886003)(8886007)(36756003)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WTongtvW8dCb5qKhABwfQJkU8rQsUKllyq7r+hfg6c/1isYoyvDlogCoh0wjBpkArCqE9E07pLcy/mME0W1/Uz/qyNFJI+PGcYRZvM0lwBWioURt0jwPuHc6skwL3v2mqm+wSwFI1Y8QKKuq7BWfqZvV2LVK3fI4cDNz50aPgWywwLF7gu83XJTbHyoxcdKT+cD34eh4IoiD3SN3pS8RwbeM4kAEpd6j/bqyGyZ65OoVi2Ysa6y8g09vGf3iWQD8W3Buv9KD+RQdm0GnqCo58NJwjriMJIoE0nbWtEydWrU0ABTD7od24Fcvo5wX7fAcNhEXZZieHEwn4IRhqddArwl1zf/POxVwZJjK1XIacrq+EWAe+zIqIv5B/plf58PdQRHRFQguZVjZZPe+wtNr2ZX85dpkC7+DYR86Vx3HZAqxWhgPRuHv40TvNg5Cc1R8SaSbZj1rXbP1yOpiNB2eQCyw3Nl5JtHeQEcBXhf0xMjljxL7H5OUvmXfVuSqtEZxwyuadIR7trfiVKMWw23Dc+QRKTGdEeTtWX3MY1SWCG6TDoqDWHxvhq01MgMZsuO7Ja0vNBx1n7Bv1XtVEsR8E2afv8BdvMGFsX+BdxHnproMRYTogK4OPQJsa6+WLtnvfl5sv4jbsMez+KQw28dnqg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fd68d7-d78f-4a36-44e6-08d86aaa8ed6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 10:20:04.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1C74Y0G68pxu97llWSz4gaHaCdZmcEad/G9ccOpdmPczBk4vEngPMmHx+bdJ5W5akqngZT4n55w6Hn0USWsPZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4670
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXMg
ZXhwZWN0ZWQsIHdoZW4gdGhlIGRldmljZSBkZXRlY3QgYSBNTUlDIGVycm9yLCBpdCByZXR1cm5z
IGEgc3BlY2lmaWMKc3RhdHVzLiBIb3dldmVyLCBpdCBhbHNvIHN0cmlwIElWIGZyb20gdGhlIGZy
YW1lIChkb24ndCBhc2sgbWUgd2h5KS4KClNvLCB3aXRoIHRoZSBjdXJyZW50IGNvZGUsIG1hYzgw
MjExIGRldGVjdHMgYSBjb3JydXB0ZWQgZnJhbWUgYW5kIGl0CmRyb3BzIGl0IGJlZm9yZSBpdCBo
YW5kbGUgdGhlIE1NSUMgZXJyb3IuIFRoZSBleHBlY3RlZCBiZWhhdmlvciB3b3VsZCBiZQp0byBk
ZXRlY3QgTU1JQyBlcnJvciB0aGVuIHRvIHJlbmVnb3RpYXRlIHRoZSBFQVAgc2Vzc2lvbi4KClNv
LCB0aGlzIHBhdGNoIGNvcnJlY3RseSBpbmZvcm1zIG1hYzgwMjExIHRoYXQgSVYgaXMgbm90IGF2
YWlsYWJsZS4gU28sCm1hYzgwMjExIGNvcnJlY3RseSB0YWtlcyBpbnRvIGFjY291bnQgdGhlIE1N
SUMgZXJyb3IuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMgfCAyICst
CiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV9yeC5jCmluZGV4IGZlMTExZDBhYWI2My4uODY3ODEwOThlZGMwIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfcnguYwpAQCAtNDEsNyArNDEsNyBAQCB2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwKIAltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhkcikpOwogCiAJaWYgKGFyZy0+c3RhdHVz
ID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCi0JCWhkci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNf
RVJST1I7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NU
UklQUEVEOwogCWVsc2UgaWYgKGFyZy0+c3RhdHVzKQogCQlnb3RvIGRyb3A7CiAKLS0gCjIuMjgu
MAoK
