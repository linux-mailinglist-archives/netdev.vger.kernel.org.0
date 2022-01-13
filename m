Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45D348D40E
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiAMI4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:21 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:35104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231980AbiAMI4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6JMUAgPLsKbJJi9xAOU8cAqaiKGU8lKj6J7EuLDGy/YNssHt/7OokC514ijhFSngatuaaxrmlzhwCqPBt65CcnnVPNKHLRMhCDZHA/THT7BgmVsrL1i5rGT73SCow+McuQPXzDQ1DQ69PoZXgi2E4602WH7Bqt1BAHswytQkcjR74qkQG+0e1Ji9gQFlyg/XcxgUok75CYpRkwfcyJc1LIkRWAKj6S6XCS4tQS1hGs/ABfLUIiLnhg4smkYRFoMx9PWT8T+XZGzzNVf7tuq5gG6SLIBnc9QXT2mmxqlrqdVtNlh0XlQ3fVVwQzzHP2PdyoVHEm5XloUH+IktbsVbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7Gah0YhgE6rIFrvRZ9DdGceIfhj0jtn1zWQUDomX7E=;
 b=fMLFSPHdASTS1x97BoIGjoZXbAolFLiGVK/BsqWSdtXqbXo6EwziZ1uO7cm0wHHSw0WGMwto8otMk+iaEhkfC2GmR7zkBDmFkRIN5YjDyP9Wv1qqbNheh2+l+kclhQl5IvVGsokzZmbVafYD4MCMm4hE4Rlmc79C0a8S2pcC2YUGnrOhZin4MLL56JpfzSGW9iu3jvOhZASqtsexpNGAUlXkVPaOJ6+SqRBMUJFZIXleSl1t44Q6Sm17GKXEskcOwP6XhEdYTTZl0layLjak7emF9JcspwmPGZdwoIff5t9GtKvzIRpLSqVSagk2gYcGodZLJMesMh8ZEGAtstPhDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7Gah0YhgE6rIFrvRZ9DdGceIfhj0jtn1zWQUDomX7E=;
 b=LF2BqjQRmbcj+1fNtaZbHUkJIqvHhhLnLPWzr6n140h2rOyV+XeOtETkf4S/A2n+S5KwHmv2ZhyxtzYpQtwmcoRfbG0lj24rMzkjsjjlkhJSIglg3ctVCkT1pTL5qDgqGxauFc/q/UhaLFTc1Ns6k2ARKbnOwgSvPOEtAv0jxw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:59 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/31] staging: wfx: preserve endianness of struct hif_ind_startup
Date:   Thu, 13 Jan 2022 09:55:04 +0100
Message-Id: <20220113085524.1110708-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 634502e5-44eb-47b1-81e4-08d9d67284e9
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040F6C8B9D12279C876AC0793539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsfvUEh6dNufLDLCpsE4NKOBiVft98Lz93RsFULn2GDrdSJjzVeyT0Pm1YgJ6w82IvFDseW7D8ZB+bO4+p4XHP1j72YEi8NToJXxtjYXfa6OzlF08IND2Hk4dQHBxOCteLYtANfMr/8+FP4pi/3qwQsdsjP/e6MSATHqYFuD3CfgPkQHMXVZ2Y4xgM1ArMeB2nXdrTy2AlZvy2sIXIJNwlja+XQT7DYIzz9qAcWUkRCeu4+57OqSOHFKZD4kRbNKMeI+jj792XwN/eqIPiNXqm0aP/Za/iW56bVOaNJcov2bU6gt+89xgXj45m3cjNs6q/XA5E3fBvxPZzy0SX4nYhgV3PpLHv7JZJu+YpnwOpXZQ/kMTZN3Wvery83so7axrUsjn5RknJW0NrFsgjBwouEbGrPKCv188f3TYPG7OOzPr3IShrOtrOLTie2+HF+XrzeNwjZ3UZfg8/DfshafQUl4aG2/sUP3Z+jEwaQIZ7uioyZNNY54bk8b7dqdDkh4IOV9ZM+qfJnbuUMFJY55tXLnGJknnsXsc/6ajShMxAR0zqdG5cwcSgkNFumabk4spkp07ShgWy9sDb7YyN+GevHz9Sw9S0QBVH2tJE/t8tV+FJ/T/GwdlkTl2xjfDZXQcTqfT0N0xLeB7mzRYsJ1bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3VsMEZKMjNXbmdMN1R3R1pueDJodXFsU1JNZVIvd01GVVZwajJ4VjZCTFk1?=
 =?utf-8?B?QzRMSE5Da2pzNGVyTlpOb09RV0lMK01RaGQvV0MwQlFOQTZHWmdEZUhUUVBx?=
 =?utf-8?B?VzM0bGFleTdVVG5yWXZlSDVqNi9sSFpvalVxRGx4N05UU283cDVxL3F5di9l?=
 =?utf-8?B?RitmSUNGVlIwOVlaQUtzUG1pRks2aEkrZSs5WjhiakFOL2NPREF0RXhDK0Rs?=
 =?utf-8?B?R0NTNkFlMlJBR1lQOUpJMkhIeHBGMytlVm1wK0pyUDdhaHZzamdUY3Q2bWtY?=
 =?utf-8?B?K1MzUWVSRkVnYUQvVG1JQ3pMZWprbzlOQWlaWGhGRXNqbndoV3ZlWThQVWhV?=
 =?utf-8?B?Q3hVTHdvUU85WGRqMU9FMEJScGlJQWZBYnR6SkZINHgrRXBTSmovSm9DbkN3?=
 =?utf-8?B?ZmpRWDJKQVIyRjVCdlRSdEsya2tmRWN0WHpRaWlXUkViQVhQZGtXYzZMZUVY?=
 =?utf-8?B?a1BkcGpVQkg0WWtmS2pGcWorMCs1MWFtaW0rZ05paFFYTXN1RDJ6b1owMkRk?=
 =?utf-8?B?TUJNdE9LMVBtMEt5UFp5eXVPdUNpM2ozZy9VTDVaOVVidmQyNGdpOFNBYXR2?=
 =?utf-8?B?Q28vekRQU0grVnF6a2ZrUkVNaXlZblJPL0xOaHBBTWdIK1ZvTTlPeHZDZldR?=
 =?utf-8?B?eEZzeFFHSXk0UHg3SEJCZ3FFVGkweE5hM1NjbDVxQ0tSRUZETjNVblVlblhZ?=
 =?utf-8?B?ZE5JU2NoazF5V3ZkbE1rb1EyYS81d2lQMGo4Y2d1Yk9Jb3lSd25CYkZNT3k0?=
 =?utf-8?B?NUt4Yi9PYzI4emxFVDNIZ0N5WXNTT3JQQlVSY2tLVEJiU0NCcTJvOXpLOGJK?=
 =?utf-8?B?NWU3WWFmNnA2WHJ3YXBvYzJhTDZVcHBCWDNReTF0Y3o1bmthUXdZSjhtUWJ6?=
 =?utf-8?B?WlpzRTF2ODVjVW85SjNnck9qMTBrYTRNdEFoV1Y0VHNmQ3ppbHRzWmJYY3Ft?=
 =?utf-8?B?OEVQVGl2UU9pRTA5dzJQYWZmV0huSDluR3RURU9BV21VL2U0a2NXS01xM0RK?=
 =?utf-8?B?a0JYazdiYlhsa2FWUU9McngzcWl3a1FUZ2xuODd2Q0wyQkpacE1CdGtBTUZC?=
 =?utf-8?B?bjY1NDFjencya3Z0T096NWprMCtGVFdDdXlBUExra2c3emRnS3JJVEJxSWYw?=
 =?utf-8?B?U1U0elg4VmlUc0piOTVmMEl5dHQzVmJlSlhBelZaczh6cjBwRUsrNy9QVmFR?=
 =?utf-8?B?UGxLSDZVZWh4UVpCdFJuWHpiSHB4QTF5ZVdCZmxiZzVBVjZHakN5c2x1QmZT?=
 =?utf-8?B?c2h0aWNKNnZNQTNoMy9VZ0ZZelFFMWN2YnIvdTdsckdDTU9YaHZGSGNjNzdJ?=
 =?utf-8?B?L0RlOFQzZS93UThrcDB0Z2ZxSFhFcW9mMFJuSGpBOGlXNnlTZEtSTWZjR3F5?=
 =?utf-8?B?LzVWUm52S3Fzcm9YV3pOOWsyRkxzTFNhZHZRRHA4cC96K2p1ejlBS2gzbjVK?=
 =?utf-8?B?akd2SHVJY1JRVUl2dHRFb0h3elErQ2FBSHNHbFBBNXV0RlhtemQ3WUQvcyty?=
 =?utf-8?B?YlJKU2RkdEh3ZWZ5R0lxKzRoSXpCZnZOWVllVVV1QkNKWmw4dm0xNStvSVlQ?=
 =?utf-8?B?NnE0WTZXUHk0U1ducWNQMGNhbzQ3d1ZDSUpnQUtFeEQ0cS85SmIwdDlyVTNo?=
 =?utf-8?B?WXVpY3pTdGRtR2p4NHlrdGFsQnhJRmZXYUlsVmJRdm9zY2RhVmIyclR2YUFz?=
 =?utf-8?B?Z0RKL2Y2eU5ab3pNbTdZWm5FTEpPanNadmJuYVBpU0thcVF2dzI2Z1FYU0Yv?=
 =?utf-8?B?V1RWK0ZYWDZtbnlVaFdwMVdVdVl5V25zZXpoczZBL0ppQ3crQS9aajJLTksw?=
 =?utf-8?B?alB0dGpPY2NiQ2pWTXVVa29HeWZxVTQwWFJNeE1udi93anBuYS9Lanl4K2lL?=
 =?utf-8?B?cE83ZlhMSldXalZoRDQ5WnBRRHVScS84U2IyaldoR2dISGpCK0Z0MWRwUXhT?=
 =?utf-8?B?cXZDZDFibVB0R0tOYk43WERGZW9Vc2RsOWo4RUZ5WEV0Mm1wMUtBYlhtRVNL?=
 =?utf-8?B?aUdid3g5cEh3L2dKWC9Oc3ZERU1pQXpCODc5Ui9ZdjYzRXVuK1ZlT1FRbHZo?=
 =?utf-8?B?U0ZzODdmQzQ3b09yMkIzVzVaRUs1bkk4MjJWZUxnYzFBaThxVWVidTd3bmVq?=
 =?utf-8?B?a2hCNXVWTE80QnRSQkdrcFFYNzU2MFQ3ZmxoUFUybXRITUdJK2M5VU5mVHMw?=
 =?utf-8?B?cWN4ZGZWeUNyWXAvTHRQZno5TXJ4WTdEQ0JnVG1UMmtUMDBsMU5RY3k3dkpF?=
 =?utf-8?Q?/5OrRe0JqRmglk82hA2jrl5YZLNtPHliqHNCoTSC+k=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634502e5-44eb-47b1-81e4-08d9d67284e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:59.6803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jfV/fb2vfJJWWbFHzXWkaqdqV/whI/BjchKsZNysxEj3IzVN8UUSB2052yYC8VZb2gfM9iVs7xXDgdIz0/AMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGhhcmR3YXJlIGZpbGxzIHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgd2l0aCBsaXR0bGUgZW5kaWFu
IHZhbHVlcy4gU28sCmRlY2xhcmUgaXQgd2l0aCBsaXR0bGUgZW5kaWFuIGZpZWxkcy4KCkl0IGlz
IG5vdyBhIGJpdCBtb3JlIHZlcmJvc2UgdG8gYWNjZXNzIHRvIGZpZWxkcyBvZiBzdHJ1Y3QKaGlm
X2luZF9zdGFydHVwLCBidXQgaXQgaXMgbGVzcyBjb25mdXNpbmcuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9iaC5jICAgICAgICAgICAgICB8ICA4ICsrKystLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYyAgICAgICAgIHwgIDQgKystLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfYXBpX2dlbmVyYWwuaCB8IDEyICsrKystLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfcnguYyAgICAgICAgICB8ICA1IC0tLS0tCiA0IGZpbGVzIGNoYW5nZWQsIDEwIGluc2Vy
dGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvYmguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwppbmRleCBhMGY5ZDFiNTMwMTkuLmJi
Y2Y4ZDZhMzljNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvYmguYwpAQCAtMTgyLDkgKzE4Miw5IEBAIHN0YXRpYyB2b2lkIHR4
X2hlbHBlcihzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IGhpZl9tc2cgKmhpZikKIAl3ZGV2
LT5oaWYudHhfc2VxbnVtID0gKHdkZXYtPmhpZi50eF9zZXFudW0gKyAxKSAlIChISUZfQ09VTlRF
Ul9NQVggKyAxKTsKIAogCWRhdGEgPSBoaWY7Ci0JV0FSTihsZW4gPiB3ZGV2LT5od19jYXBzLnNp
emVfaW5wX2NoX2J1ZiwKLQkgICAgICIlczogcmVxdWVzdCBleGNlZWQgdGhlIGNoaXAgY2FwYWJp
bGl0eTogJXp1ID4gJWRcbiIsIF9fZnVuY19fLAotCSAgICAgbGVuLCB3ZGV2LT5od19jYXBzLnNp
emVfaW5wX2NoX2J1Zik7CisJV0FSTihsZW4gPiBsZTE2X3RvX2NwdSh3ZGV2LT5od19jYXBzLnNp
emVfaW5wX2NoX2J1ZiksCisJICAgICAicmVxdWVzdCBleGNlZWQgdGhlIGNoaXAgY2FwYWJpbGl0
eTogJXp1ID4gJWRcbiIsCisJICAgICBsZW4sIGxlMTZfdG9fY3B1KHdkZXYtPmh3X2NhcHMuc2l6
ZV9pbnBfY2hfYnVmKSk7CiAJbGVuID0gd2Rldi0+aHdidXNfb3BzLT5hbGlnbl9zaXplKHdkZXYt
Pmh3YnVzX3ByaXYsIGxlbik7CiAJcmV0ID0gd2Z4X2RhdGFfd3JpdGUod2RldiwgZGF0YSwgbGVu
KTsKIAlpZiAocmV0KQpAQCAtMjA0LDcgKzIwNCw3IEBAIHN0YXRpYyBpbnQgYmhfd29ya190eChz
dHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IG1heF9tc2cpCiAKIAlmb3IgKGkgPSAwOyBpIDwgbWF4
X21zZzsgaSsrKSB7CiAJCWhpZiA9IE5VTEw7Ci0JCWlmICh3ZGV2LT5oaWYudHhfYnVmZmVyc191
c2VkIDwgd2Rldi0+aHdfY2Fwcy5udW1faW5wX2NoX2J1ZnMpIHsKKwkJaWYgKHdkZXYtPmhpZi50
eF9idWZmZXJzX3VzZWQgPCBsZTE2X3RvX2NwdSh3ZGV2LT5od19jYXBzLm51bV9pbnBfY2hfYnVm
cykpIHsKIAkJCWlmICh0cnlfd2FpdF9mb3JfY29tcGxldGlvbigmd2Rldi0+aGlmX2NtZC5yZWFk
eSkpIHsKIAkJCQlXQVJOKCFtdXRleF9pc19sb2NrZWQoJndkZXYtPmhpZl9jbWQubG9jayksICJk
YXRhIGxvY2tpbmcgZXJyb3IiKTsKIAkJCQloaWYgPSB3ZGV2LT5oaWZfY21kLmJ1Zl9zZW5kOwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYwppbmRleCAwNTJhMTkxNjFkYzUuLjU0OTIzNzVmZTgwYSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmMKQEAgLTM1OSwxMCArMzU5LDEwIEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lu
bmVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCWhp
Zl9tc2ctPmxlbiA9IGNwdV90b19sZTE2KHNrYi0+bGVuKTsKIAloaWZfbXNnLT5pZCA9IEhJRl9S
RVFfSURfVFg7CiAJaGlmX21zZy0+aW50ZXJmYWNlID0gd3ZpZi0+aWQ7Ci0JaWYgKHNrYi0+bGVu
ID4gd3ZpZi0+d2Rldi0+aHdfY2Fwcy5zaXplX2lucF9jaF9idWYpIHsKKwlpZiAoc2tiLT5sZW4g
PiBsZTE2X3RvX2NwdSh3dmlmLT53ZGV2LT5od19jYXBzLnNpemVfaW5wX2NoX2J1ZikpIHsKIAkJ
ZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LAogCQkJICJyZXF1ZXN0ZWQgZnJhbWUgc2l6ZSAoJWQp
IGlzIGxhcmdlciB0aGFuIG1heGltdW0gc3VwcG9ydGVkICglZClcbiIsCi0JCQkgc2tiLT5sZW4s
IHd2aWYtPndkZXYtPmh3X2NhcHMuc2l6ZV9pbnBfY2hfYnVmKTsKKwkJCSBza2ItPmxlbiwgbGUx
Nl90b19jcHUod3ZpZi0+d2Rldi0+aHdfY2Fwcy5zaXplX2lucF9jaF9idWYpKTsKIAkJc2tiX3B1
bGwoc2tiLCB3bXNnX2xlbik7CiAJCXJldHVybiAtRUlPOwogCX0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfZ2VuZXJhbC5oCmluZGV4IDgyNDQ2NzYxMTJhNS4uYTU3Nzg5Y2ViMjA5IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKQEAgLTEwOCwxNiArMTA4LDEyIEBAIGVudW0g
aGlmX2FwaV9yYXRlX2luZGV4IHsKIH07CiAKIHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgewotCS8q
IEFzIHRoZSBvdGhlcnMsIHRoaXMgc3RydWN0IGlzIGludGVycHJldGVkIGFzIGxpdHRsZSBlbmRp
YW4gYnkgdGhlCi0JICogZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0cnVjdCBpcyBhbHNvIHVzZWQg
YnkgdGhlIGRyaXZlci4gV2UgcHJlZmVyIHRvCi0JICogZGVjbGFyZSBpdCBpbiBuYXRpdmUgb3Jk
ZXIgYW5kIGRvaW5nIGJ5dGUgc3dhcCBvbiByZWNlcHRpb24uCi0JICovCiAJX19sZTMyIHN0YXR1
czsKLQl1MTYgICAgaGFyZHdhcmVfaWQ7CisJX19sZTE2IGhhcmR3YXJlX2lkOwogCXU4ICAgICBv
cG5bMTRdOwogCXU4ICAgICB1aWRbOF07Ci0JdTE2ICAgIG51bV9pbnBfY2hfYnVmczsKLQl1MTYg
ICAgc2l6ZV9pbnBfY2hfYnVmOworCV9fbGUxNiBudW1faW5wX2NoX2J1ZnM7CisJX19sZTE2IHNp
emVfaW5wX2NoX2J1ZjsKIAl1OCAgICAgbnVtX2xpbmtzX2FwOwogCXU4ICAgICBudW1faW50ZXJm
YWNlczsKIAl1OCAgICAgbWFjX2FkZHJbMl1bRVRIX0FMRU5dOwpAQCAtMTM4LDcgKzEzNCw3IEBA
IHN0cnVjdCBoaWZfaW5kX3N0YXJ0dXAgewogCXU4ICAgICBwaHkxX3JlZ2lvbjozOwogCXU4ICAg
ICBwaHkwX3JlZ2lvbjozOwogCXU4ICAgICBvdHBfcGh5X3ZlcjoyOwotCXUzMiAgICBzdXBwb3J0
ZWRfcmF0ZV9tYXNrOworCV9fbGUzMiBzdXBwb3J0ZWRfcmF0ZV9tYXNrOwogCXU4ICAgICBmaXJt
d2FyZV9sYWJlbFsxMjhdOwogfSBfX3BhY2tlZDsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXggNWU2
NzVkMmMzZTgyLi5lYTZkMTkyY2UyOGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtODEsMTEgKzgx
LDYgQEAgc3RhdGljIGludCBoaWZfc3RhcnR1cF9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAogCQlyZXR1cm4gLUVJTlZBTDsKIAl9CiAJbWVtY3B5KCZ3ZGV2LT5od19jYXBzLCBib2R5
LCBzaXplb2Yoc3RydWN0IGhpZl9pbmRfc3RhcnR1cCkpOwotCWxlMTZfdG9fY3B1cygoX19sZTE2
ICopJndkZXYtPmh3X2NhcHMuaGFyZHdhcmVfaWQpOwotCWxlMTZfdG9fY3B1cygoX19sZTE2ICop
JndkZXYtPmh3X2NhcHMubnVtX2lucF9jaF9idWZzKTsKLQlsZTE2X3RvX2NwdXMoKF9fbGUxNiAq
KSZ3ZGV2LT5od19jYXBzLnNpemVfaW5wX2NoX2J1Zik7Ci0JbGUzMl90b19jcHVzKChfX2xlMzIg
Kikmd2Rldi0+aHdfY2Fwcy5zdXBwb3J0ZWRfcmF0ZV9tYXNrKTsKLQogCWNvbXBsZXRlKCZ3ZGV2
LT5maXJtd2FyZV9yZWFkeSk7CiAJcmV0dXJuIDA7CiB9Ci0tIAoyLjM0LjEKCg==
