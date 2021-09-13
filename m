Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217A54086D0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhIMIew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:52 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:38689
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238492AbhIMIeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHjxPSyWhnOJFquFjpZmrJZADrwRN/kkJBjLLcdSy+fQXkCQVpGFfZtcRGMQILUOmF20q4nndYrxQBX922cZ8i1vcqeu9noA83NLdZ3N3cFIb4lJL0+/f0uNOwzEm+tyCgdGOEGKouA3oqzedYjizrO01P84J7CoYI6NJvfgPuN98ibGpi/FIZZ7s97dOiRTpfpJp8zgdUGl5D8GuFj7uOxOfBxCsEL6C1C5q/cs9XsvwZEtzQCklKq0qwhhDqWWG63Bp61M+L0BIGGg9328tdIje++8faqrfL9yArZwy7JpxLMm8a0/OxR/VZPIy8IeHawrtb/XEh2qNNNiGyZOsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=oO9BPzLSre2iYvnNlGZ7W2bjporWmGTvb3BHUg8tVwCnPUnRZGoUs7KyoAuHwqY+WZ2BK559RspWrzV5k01kYB3BlkAzIo/pn3Vs5TSPDwBBU8S5oGnr8z63bEHWiv0mB5D1heHq9Pwd+AdZKZytqUVygWWT8j088lYXZmb0+rQyQOn6yPHbT/sxpPNZMD6UOnGjIOMwoQ0D/B2OxQalwKomYI65CEfBAuDf95gwMA9rjZPurXgAySIG65tTWUiz0H2m6SOJeooH9+ONHudZSY+wEnMvIBQi7wlWfz2bETGfyaKXP1/1X4ppnQDhzfuQgNpKajfLjQHfzOmGssB20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWqshuUJt4MwYDZxaRfz3PfeusUa7v9Ig5zzMvV5bCw=;
 b=AScfunU90kECODd5ks4Z7M5pnirrg8I52vlXLGORTKk5YtkX3h1/HGMfIfWWS0+n5s04tM9YjPtaxuigVvb+XHD5ltDEOAKpEzqt9Hutrnef7KPgs4/osmyqr9gGx4wMBOW6QM3Nyq3b1Ddx3cdl0dhE3Pw/p/vEv8C8h2EAV3E=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:53 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:53 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 15/33] staging: wfx: fix misleading 'rate_id' usage
Date:   Mon, 13 Sep 2021 10:30:27 +0200
Message-Id: <20210913083045.1881321-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3ad9465-56d6-4f61-45f9-08d97690e32d
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32630FD664AC9EBC216E5C0B93D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKfh30aoSfjfnBuBF/RRTUP95MK4kW3q9T53OpHnJ5IGv/G5OSaGPSYmTRx37ofABM9i3I4xUrwycg9tHFDwrjGYrtx+1/l3W8DL0B2kmkwFRPMURRLwXTABH9QBKa8/dlAjYiMwEAQWyFLWUB+ajm7wMdguH30ZXIwvh39DoY8sp1aAksUQuFuH9cD3vsE3Gg41OYIhDguCSrsGkCjUyf/6jXgsxU3F1T539D2vgDBukomEt4VPD6nEbC1/i6/XOTvEThkCx9YvGHoc/44CdqSvoXrflB7+HPf5ky9wYfE5kdK0ME7c0vQIUTwtOpth8LnBWgYYRg846VoAp/SO3UMA3g45jcj4y2N0OAaFlr7zphPsw2sA7S4EAGcbtY8LAWdXw1dsn/BC2JZTOLpmGgHDC5Fmt3YniGzChaZctZ6v1u2sVwVPA4sUH0tOaL0h1srcdp0DRDcbxVcEPgl1AjbWDqjmnrXmAuEx69m+2NWSJYn+/9UH+WtxrUsfA6A0v3pSzIQIsDvAql9EO2ykecLmLfu3Z68BJN4qd9oBB0W4aQ/KBao49fstZM3ds4OFpXZeuPs2VardtzHNUgE5xZIfxUiRlihvEn+MS2uR8eQCSIWUa6VM9YR+/3C4v0ge+y8kOqtZY8S7LfhR4sg/PmmvZ6YEvjAWncfHhWSRrdAtDZN+bL4lFigVwh4PtQ6wvNpaiwrpykM1HR+BgBIGNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHREVllvbjVrMGEvbzVCUUtDZFVrdDJPWnNGUUpyMlNPV3BDRFIyWGQ3bHN6?=
 =?utf-8?B?cmN2MWJETzRNMmgycUFFL2JWOTdUYWd1MVE1Y3VnZjBnMldvYnlIUkV4NVdz?=
 =?utf-8?B?M1FKbXRTWERyZU1aSzRraW5aSjZiSUlqMzdzajE4b1UrRkp3RXhoeXIxNFZI?=
 =?utf-8?B?YUdSTGNmMCtwNGhXYjVMWGZkWDVWc0VpUjM0VVV6U0JQWC9OL1JVaVZLQnJ3?=
 =?utf-8?B?Q0x1RWN2N3h4eHl3TVJSZThZZk1NTGZsN3ZtVTEvUDNTdGN0SWVOaTV3K3V6?=
 =?utf-8?B?VytYRUoxNitjSlFYeVcvOStuVVFsTzhrVURuRXYydFY1NzJaZ1NRVHBlaXo2?=
 =?utf-8?B?dDZFWFZHSU5JNGFuamdvcmZzak9WV21SZVczK3FFRTR2dHBWU0dhL0tJdEd4?=
 =?utf-8?B?VkltZ1IzNG1tWU9YdEtSakIxdldUSi9Rc01DWkNvRVdjTmxnSExwa3pqWlhh?=
 =?utf-8?B?SkJMWjQvRENFb3liejBrU255NXZDQThkU2IwazViUXpReEh1dzRzbGt0Tmps?=
 =?utf-8?B?OVhQYjdOcG5sSDlkOWlZd0Rva01BWE10azhOLzJ3ZkkrMnRZVlpiSm8vVk9o?=
 =?utf-8?B?ZnJUQkxHazgzNVpWWE5ZeWlUV1Uza0puZEo0RlpnVHU5MmR0bjRTREthdXZ3?=
 =?utf-8?B?SlV4ZUd2Q0xwQmJQMnJhcFQwU3VlN3NDL2liVHczcFR5RWJLQWcyK1RHeGNm?=
 =?utf-8?B?ZkVONHBpOGxCN2hSSTRieHIzcmRSMnRZc3dIVElEeXVnZGVBeFJoWG9rT1JM?=
 =?utf-8?B?eXVyc2Q0dnpVQ3VmWUJwN3g2eWdqZWtYcVZFRnZNTGtiUFFpbjZscnZrQldM?=
 =?utf-8?B?d2IxSGFnd2dZNUNPMlR5OXliSE4vaEZhQ2xCMzMyaC95bldBbUpyeURqTjRr?=
 =?utf-8?B?T0dZZU0vU1RnR09zZnNEZUQzS3dDSjk0NkRYTXlCQVRkNUVQMlVFSzdaZEhv?=
 =?utf-8?B?MWlQTjAwSWUzQkNGeDc3MlQxeFFOVVBzTmh5SnFZKzd3aGlPM0JvOWJpYUt3?=
 =?utf-8?B?akI2VFN5U2VUMDBHSTZoelB1d0xXQ3g3VnJqdDVmZWRmTFFmS2krL0lMMU1U?=
 =?utf-8?B?bmN5R2hrSENqUTAxcHpFMm5BUnZ0L0tVMGJ6ZHIyR0d3UXBNUjRVejRWOVox?=
 =?utf-8?B?ejN0TU45dHFKeW92WTRNTjh1WGI1OXlHSHMzRjY4elZsdHAzV3hVOU95Yzlz?=
 =?utf-8?B?eFkvWUtTS0RqVHBhNFlqQ0pUWEExRDFDamtIalhoNHpVT0VucUJsU3grUjJD?=
 =?utf-8?B?M1NVSHQ4WVJYaTd1Rmk0WXlvVmRyaGJDN2NSdmVtU0lNVCtjUVNiZnZUU2NY?=
 =?utf-8?B?WGlCeFI4UVRDNmo1c0lEL1Y2MEwreTFQVVdST2h1SnZlZ2pYTWxEc1EyVHZt?=
 =?utf-8?B?MXNBT1ZheklFMGdKUDJWZ0VCbGMxTDlqKzhvQnloWHpyUXZQWVVWWnJKM3A4?=
 =?utf-8?B?ZEs2ODN0aVR1cm83Zm1zSms0M3dOeU0xYnFNT09RQUk0ZXV1aUhuQ3pESVBV?=
 =?utf-8?B?d1RjOUFYcTBWWDJSUzNVTEdmMmFlR29IbU14aXdDQ0N1OWxMdUw4TUNjZTJB?=
 =?utf-8?B?WnVubG1DMzAwdHljMTJHWEYxaWRMWVlUaEtiZjJMd2FWK284YzN2OXhhSGZH?=
 =?utf-8?B?WnhEME10K0pOQVQzK0FORlJmc1pqcWhiaU9EQTIvamtKN1NDTjRGM254SVB6?=
 =?utf-8?B?bHdSak1wVWMrQzRlQkw0OWlQMEtMbkJ0bTF4S0VuUkVxdUtLc2ZzS3lZcDRi?=
 =?utf-8?Q?KHOQsv+r5eLlabsEX3VB8zNWm/SmulZE2+3Mw8d?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ad9465-56d6-4f61-45f9-08d97690e32d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:31.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uev+2Gd0mbA+a+TSRO8eZUoYiTue1/hhlJYCcZCuUdUD77nK87TX87IrBLycfB3p7tF2lKen9ERC4Yt0v3k9oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRyaXZlciBzb21ldGltZSB1c2UgdGhlIHRlcm0gJ3JhdGVfaWQnIHRvIGlkZW50aWZ5IGEgcmV0
cnkgcG9saWN5Cih3aGljaCBpcyBpbiBmYWN0IGEgc2VyaWVzIG9mIHJhdGUgSURzKS4gVGhpcyBp
cyBtaXNsZWFkaW5nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwg
MTUgKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNzdmYjEwNGVmZGVjLi5jYWVhZjgz
NjE0N2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0yODUsMTUgKzI4NSwxNCBAQCBzdGF0aWMg
dm9pZCB3ZnhfdHhfZml4dXBfcmF0ZXMoc3RydWN0IGllZWU4MDIxMV90eF9yYXRlICpyYXRlcykK
IAkJcmF0ZXNbaV0uZmxhZ3MgJj0gfklFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSTsKIH0KIAotc3Rh
dGljIHU4IHdmeF90eF9nZXRfcmF0ZV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCSAgICAg
c3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQorc3RhdGljIHU4IHdmeF90eF9nZXRf
cmV0cnlfcG9saWN5X2lkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJCSAgICAgc3RydWN0IGll
ZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvKQogewogCWJvb2wgdHhfcG9saWN5X3JlbmV3ID0gZmFs
c2U7Ci0JdTggcmF0ZV9pZDsKKwl1OCByZXQ7CiAKLQlyYXRlX2lkID0gd2Z4X3R4X3BvbGljeV9n
ZXQod3ZpZiwKLQkJCQkgICAgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5X3JlbmV3
KTsKLQlpZiAocmF0ZV9pZCA9PSBISUZfVFhfUkVUUllfUE9MSUNZX0lOVkFMSUQpCisJcmV0ID0g
d2Z4X3R4X3BvbGljeV9nZXQod3ZpZiwgdHhfaW5mby0+ZHJpdmVyX3JhdGVzLCAmdHhfcG9saWN5
X3JlbmV3KTsKKwlpZiAocmV0ID09IEhJRl9UWF9SRVRSWV9QT0xJQ1lfSU5WQUxJRCkKIAkJZGV2
X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIp
OwogCiAJaWYgKHR4X3BvbGljeV9yZW5ldykgewpAQCAtMzAxLDcgKzMwMCw3IEBAIHN0YXRpYyB1
OCB3ZnhfdHhfZ2V0X3JhdGVfaWQoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCWlmICghc2NoZWR1
bGVfd29yaygmd3ZpZi0+dHhfcG9saWN5X3VwbG9hZF93b3JrKSkKIAkJCXdmeF90eF91bmxvY2so
d3ZpZi0+d2Rldik7CiAJfQotCXJldHVybiByYXRlX2lkOworCXJldHVybiByZXQ7CiB9CiAKIHN0
YXRpYyBpbnQgd2Z4X3R4X2dldF9mcmFtZV9mb3JtYXQoc3RydWN0IGllZWU4MDIxMV90eF9pbmZv
ICp0eF9pbmZvKQpAQCAtMzgyLDcgKzM4MSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lubmVyKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCXJlcS0+cGVl
cl9zdGFfaWQgPSB3ZnhfdHhfZ2V0X2xpbmtfaWQod3ZpZiwgc3RhLCBoZHIpOwogCS8vIFF1ZXVl
IGluZGV4IGFyZSBpbnZlcnRlZCBiZXR3ZWVuIGZpcm13YXJlIGFuZCBMaW51eAogCXJlcS0+cXVl
dWVfaWQgPSAzIC0gcXVldWVfaWQ7Ci0JcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3ZnhfdHhf
Z2V0X3JhdGVfaWQod3ZpZiwgdHhfaW5mbyk7CisJcmVxLT5yZXRyeV9wb2xpY3lfaW5kZXggPSB3
ZnhfdHhfZ2V0X3JldHJ5X3BvbGljeV9pZCh3dmlmLCB0eF9pbmZvKTsKIAlyZXEtPmZyYW1lX2Zv
cm1hdCA9IHdmeF90eF9nZXRfZnJhbWVfZm9ybWF0KHR4X2luZm8pOwogCWlmICh0eF9pbmZvLT5k
cml2ZXJfcmF0ZXNbMF0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNfU0hPUlRfR0kpCiAJCXJlcS0+
c2hvcnRfZ2kgPSAxOwotLSAKMi4zMy4wCgo=
