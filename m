Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A365406EC3
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhIJQIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:16 -0400
Received: from mail-dm6nam08on2067.outbound.protection.outlook.com ([40.107.102.67]:47841
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231781AbhIJQHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUJYlF9ab3logoViUHlIgmc+n7OvggGLKOWdzIUFvSlCSHjORSlqalFaxFkwE7Y1mtp6yuxNBmGGge3snSMEbUSO26LEPVMR2pGuY5MzXQoTNLAQcaKVqauFfXljNzh1xJmgTnnZtMSxayD5bLwFsq1uZcRUMuxUPIsuBAhoBJ2nOFmdS96iOMyW8sfSQqIlpCjT4NXXHacFCsRcIuWo+Eemw2B0VL6rNug5h6K9mRlvXP10Te06fz0juqZtAjDuC1rpVgRhcDcyCB5Gh/ghdmSDz7E/Y5LVvM9juHqDExPi89X9WNZmpfHZEo6s5ppPv38f7yRuHoj5tyk41MU04g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=62Px7Pc9Wfa37Yp8kwwCsox0dv9QXvJNMbI8fHPQiLQ=;
 b=JSt3/884O+HAPVpZmk02cDBf+dkX8cJpaVYQA13Xg9+AsSHpDQR6cUULVj69V73i8i751A5lIULzfwZZI8bazPmUJaUu8Spxz0FtN0WKagjPiIQVRwbtTpWcTPWrgfIUXXssxiXuK6iJ5jUT20d8sOcvFp96jMwPeZV47JGQsYArD5X1sWQ+i5GT8Kg8M5H+9oHdOCnXsY80DwqH0x8hU9Zsbc0ZC+DvRQjg0vlp9wx8yp/wvRnf52Z1bExhZQnUs5FTcW2458gaOhJewnGIvdqzvh6XT/1WHEaLAeKl7suTFY/fcL8t6qZ1Wd1UZBruDAXKN/GvyhZylnErR+vt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62Px7Pc9Wfa37Yp8kwwCsox0dv9QXvJNMbI8fHPQiLQ=;
 b=bbE79FzZKiQLuCoIz6/GQ1F1ws6s5mi/6qA+bmjIwsjqGzE6w4qm8YWgFRLRkWGyrbJxhG9Dm0ZvM1hhAeUTErfe4+baZedykafh6q4J53qpcW23Z51NNyV0aJZdLwQ2siS7TI5u94cVBsiM/wb2q7GS4DC9zjMKXhJTEdep69E=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:06:05 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:05 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/31] staging: wfx: simplify hif_join()
Date:   Fri, 10 Sep 2021 18:04:50 +0200
Message-Id: <20210910160504.1794332-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87b87beb-d28b-4297-8f1d-08d97474e497
X-MS-TrafficTypeDiagnostic: SA0PR11MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB45922314C559E40447BD4D0493D69@SA0PR11MB4592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WC+xBuLWmtV6j0Q2lSSjm7WrPIFyM5w1NOVsx9RKwpfUzDEX8doIQrzdsYEOzOm10qMsyXGhVFNj/cra3hcO8FS6Gr5F4om20PKheCzghtDe1OEVBkO/HWexa+khIY7ZqW8AZh1mNS8ps0rOw/2cTeFoDyY4vsGPthUaIdBVAspX8pGVva/DVg3JTb72pG5A8NE9FZ2IShkWAwmQwxzQA2X9ay7T/r8iMzLCZkd+FjddiNCl+s7Bg0f4oUaesgeKnpyqgfAjdQzE+iIr8dT/bqPSDsVgNpoGyOMTJBhWLWfZUuJsM4PzsiKXsnLfabLgVl/eQjEgrF6gU+J4D59o+0HMvLF9XT6ll0TPNg7pixMnJqkIn8aPyxWQIGLrZkDetUQrxfedG6VkYua6bLFiC8EJ/6rifPjKHKc2hIU+rpkEiplLMpolD0Mxn56ebs2tIVXjfhwIawWgcAPNTcorDsDe2d6yueDKD/TvT1JpnjktBm5IQGJoq1YabK3i/gspNTWi35Kl/XULXPneFvkxFOrYUZ0rz70J4fTatBuZ2fGfTMUbowAp01gXvZnrOeI8g970Xp9t02HGcYDdRlFHvlyKrmOnTAgbFWsj1J7jZYO4i5vFzt/5FLyIzJa2xrBsoM7yYAI/DoNgeDGw856tTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(66556008)(6666004)(66476007)(316002)(66946007)(83380400001)(8676002)(8936002)(36756003)(86362001)(6486002)(107886003)(4744005)(7696005)(52116002)(54906003)(2616005)(5660300002)(4326008)(38100700002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnlVWlJJWkx4SEJ1VDdRTFJpeUN6MVF1RVNKYWRqSFkvbTY2bzVJQjVCS1Bs?=
 =?utf-8?B?dDVDdFUrS1hnZE5pWlRUc3BTa1pWZWdDWm53WTg3TjdpUElCRG15Sk9MVnE4?=
 =?utf-8?B?OWxSRHExS0hNbGdyYzlFOXNJUjd5UnIxMUQwdmdCNTc1Z0FQZy9LeTFxVDdP?=
 =?utf-8?B?bWNhU01McTZjSXFtSEhaMkJlR3g2Qk5XTW5hVWZJYVZwRVlxSzJDMkg0YUI5?=
 =?utf-8?B?YnEwUU0wVnhyL2Y4bVJuWnlPL253K29ReFg1R3IrUThFUjVMYUNJZWV4WkRo?=
 =?utf-8?B?QWJ3NktsSllZTXgyRTYrelBXL2hpdTd0VWJHWlZwWllrWlMwRDlROGw2Skh2?=
 =?utf-8?B?ekdtNlFmQkRkeTVrdFlMK0docFQ3MW4zSHpkQ1Y5R0RzUzBNdkF6cXgveWg4?=
 =?utf-8?B?ckROWmN4bzBaYmFqUTNsRDN1VjdKbktDTlg0eUFZdE5ma3dQdi9oOVYxWWtJ?=
 =?utf-8?B?bjhtQ1RwajJPZ1JaeTk5SUFsbFdpbG5xenZ4SjBrSkJBVW15c1RwNE0wOHBj?=
 =?utf-8?B?blNlOFdBT2FzOWxNR1lRdGh4UldtOWk0NXUvQU9ET3FXSXVsZkhxMmJVZUF5?=
 =?utf-8?B?R3BUQW5Day8xamtnUHd0ZnRKN09PUzRENmlVeStURWh4WnZLTS94RUY0RGVw?=
 =?utf-8?B?am4vRFMvbGpST3BOTW1xZkdsaFJNR0l6YWl5OXVuR1VSbUd6ektadWhGbndx?=
 =?utf-8?B?NURhNkJZeUFMdXBkakxKY091dWlCdExBbXI1a0w5MFczZ2pmV1RVVUU5VlBE?=
 =?utf-8?B?TnpITzZyWnJGT3hqaU10aFJSRlJCRkFmOUljQmhKRHY4ditFNzFPUUt2ZTRL?=
 =?utf-8?B?UlZTZUpRQTdLRGVMb2EwaTJ6RVVLSHBWdmQ2QjR2NGl4djIzMndqVE43MlBE?=
 =?utf-8?B?a1RRWTZpcEY3c2xEa01nTVFZNXpTMVVmTTFKWHYzenpuckxpTmpTd2pKTElh?=
 =?utf-8?B?Z01WbVZaSnhGWGFJZi9NUEh5RVduTjVUTEkyR3ljb0JPTGp3dHJ3cTJkcGlX?=
 =?utf-8?B?dWNkeEYwZE5kelh4V0tYRUR6N1JsMFZPbE93SHVPelorL3hXSXNlYVM2d09w?=
 =?utf-8?B?WFc2TVRGTDZSZWRMZHc5VDZPYlYyOVJVakMxRjhhUk9xZDhxeUJTWmFITWRL?=
 =?utf-8?B?SEUrT0RWYy9mYVdkZ3Z3ZzVqQk5XRlYwaE85YnhBbDVzUDN5QzJhVXMzaDNM?=
 =?utf-8?B?akEwdS9xK1pBeitiZGNaLzM1aDQyaFJPM0U4c1FDejFnUEpyWnMzMjBHZVVE?=
 =?utf-8?B?d2FoTmhGOG5RRnREcUtnRC9ERCtMN1RGWGN3eUZYeFJOUzAxU3BFZE04ZTVB?=
 =?utf-8?B?TkN5bFl2SGhnZHlBTVNvN3J1ckhZaTlONFU3VCtGQ1ZOL2JyTUp1emFPc25p?=
 =?utf-8?B?ODhHYUcvMTNqRHJWRHIrYnZOZ3JxQUl5NzBrRHhWankzN0NIcmZTZExsYmhn?=
 =?utf-8?B?d3Bmd3U5dHdtQ2M1YU9sOXErbEtKTHIycHFyM0dqTVhBTTNZb04zbFJMckNR?=
 =?utf-8?B?elJEbU94WS8rRmdTbEo0QjZSQWZTSHp2cE9RcVRzc2k0Nm1XMGZFYklBN0I5?=
 =?utf-8?B?bmd0bno0VVBKbVhQRVFwQm9rcTdPeEk4MmZBT1lNdVNSaHlMTDRSZmVIWkc4?=
 =?utf-8?B?WnhNblpoaHp4ei9zelRRK1BUR251N2VxZjNkUGNaQ0FMeUx6M2FzUFk0UG1M?=
 =?utf-8?B?N0hQckFiN3JwRi90NGNzZU95UUtobEZmbE1TNjRFdTBVUHZjN0VUWjA4UWFw?=
 =?utf-8?B?a0RxczVZbmQ1N0R2WVFWc1NjNUhWSXNiOW11cFlrME5oRVhmQlF3Ly9kalVX?=
 =?utf-8?B?ZkVpdmk2bEdLTnRqUStvT2xZcVB6MTh2dDVRNzdrT3ZrWWUzMDZ6WEY3TGVC?=
 =?utf-8?Q?Q1sZyCBDqvqJk?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b87beb-d28b-4297-8f1d-08d97474e497
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:05.2110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTYzA2fyPMwj0kcQJIDMt7l/6duCn4IGQQhSkcdrCCKMs4TG39xB/IYlRvpx/Y3DZmQBSgcI+BVOq745jUgwEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5ldyBjb2RlIGlzIHNtYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguYyB8IDUgKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCA2ZmZiYWUzMjAyOGIuLmFlYTBlZDU1ZWRjNiAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0zMDYsMTAgKzMwNiw3IEBAIGludCBoaWZfam9pbihzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiwK
IAkJcmV0dXJuIC1FTk9NRU07CiAJYm9keS0+aW5mcmFzdHJ1Y3R1cmVfYnNzX21vZGUgPSAhY29u
Zi0+aWJzc19qb2luZWQ7CiAJYm9keS0+c2hvcnRfcHJlYW1ibGUgPSBjb25mLT51c2Vfc2hvcnRf
cHJlYW1ibGU7Ci0JaWYgKGNoYW5uZWwtPmZsYWdzICYgSUVFRTgwMjExX0NIQU5fTk9fSVIpCi0J
CWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKLQllbHNlCi0JCWJvZHktPnByb2JlX2Zvcl9qb2lu
ID0gMTsKKwlib2R5LT5wcm9iZV9mb3Jfam9pbiA9ICEoY2hhbm5lbC0+ZmxhZ3MgJiBJRUVFODAy
MTFfQ0hBTl9OT19JUik7CiAJYm9keS0+Y2hhbm5lbF9udW1iZXIgPSBjaGFubmVsLT5od192YWx1
ZTsKIAlib2R5LT5iZWFjb25faW50ZXJ2YWwgPSBjcHVfdG9fbGUzMihjb25mLT5iZWFjb25faW50
KTsKIAlib2R5LT5iYXNpY19yYXRlX3NldCA9Ci0tIAoyLjMzLjAKCg==
