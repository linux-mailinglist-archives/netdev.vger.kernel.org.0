Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1462F408BA5
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbhIMNEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:51 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240067AbhIMNEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7HISlX22YxMZU18Zp6QE3BWUptiWo8oCmicrXS8QGpA6EqW2WJG9J9+gY2EyQanuIZbC0QJxC8eCcn906+wRNb5vepLGMHTLeWISm5Ri7RNrBWjz1TX6yIFbyufGttSWCFdptivjObYR259zFmNU5zZQqQkBOh9jDsQClIQfZRhjNFD5QDztcf1TUOeVVg2bMv/x0rkL2sZaOA4PKYM+6+zB3FlimNxbOUHs3nxiO1otttjkozTcaieqcnM/4T+sIn985qASah1Z3+G9D0F+0U8ILnbEymgs8mWwXmFdRVn95fsFBoB2X4y0II/8BDdPfxwWQsACRYNU2unGec5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WhyYy1P7KsKUgLuM2glALRDRuLVP6X8mHvwirJcSluQ=;
 b=KVsCJek+lwXSQIunXEQdCqUF2OgmNQWqpyR/bdgCa/+JQRGdktHd4rrbZEnDD2O22zvsQ1jZ/NHTySYYdEP6G7NYSEiI6AdY24bC8utymQgJtrhK83Qu6dKL+bqRIIWTiAq754YvRM9H/cdd+Qs+7xVR3/Zws/IX6GAIK1THhrRl6kj1zaNR+i3qvuQ8XIAPOlY/DObi7U56SqI1F/yChGYqDrMO8jTo+GYmlD5icyPTX+B2cFhxLRVCJZFitStN/xiYtWrvPSGMlabpjaR0mxbHzrdAlaeCPnqo3/aKrqJgB22hXffafvcUKGzLnUX/mys7KLzjIN+lmbY1HgfUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhyYy1P7KsKUgLuM2glALRDRuLVP6X8mHvwirJcSluQ=;
 b=AN8KwaDDkgddg10s8IlarCJA0OJQo4+8Rpb4zqD8jQjgmluvIwUDnSQJaZ93CqeFp4v6YmDb02wkAvHjEu1S/e12oa+4Xro2ao688iI4MkN5fi62Of/nW1yZx6V81zdm0h6FJ1J4d45fEaJGA8+mYvHzXxFFYEGfVK2YiSeVO5s=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:39 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:39 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 12/32] staging: wfx: simplify API coherency check
Date:   Mon, 13 Sep 2021 15:01:43 +0200
Message-Id: <20210913130203.1903622-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcb17302-af69-4ea4-8bbe-08d976b6c40a
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860489519B089BCEE8289DE93D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2rygBA5DJaX3wB+qdIjIOv24nuplhL6f0FDrXiVD5jnvYw9nC+G5XYe1ddVOqmnup+TXV9t+Fzaqi6FSxKn4+w416ku37qXrZke6jhwcBfys9zYYCjUQDDe+6R9PYCwxwsEsNjnepD8ccSRG8GAMbG2FIaBop9da8RphZyIvpBVkZLZ5caDNlv5IT900hmpCq6eO/uIdNud39bMEnrPKM09D0vweBfjDytIjVPxGNR/2nj9OC+/Gt433+RFdNquIUDlxdQjPhxnnVZ5xuaRFMT4hDIInQEtgMekk02ViX0Z2W5wH9R5MMg4pTx6kKFFXuMi8c//hfXHATandik781wltOLH3JI9SnvJXu8T3T0OS+YWYfeBAT56zbfhthbIL4aBCbUMkSlC0V4XiYi4h/n7N7vwLHoVMRCSy7fVu420UnPjcgVWiYAagL/H3eVTKMcjomMJMfuexijP9CestqJGZ2/0a5vxM0sbSU8lvWEIjSjUY/1Zwht7UwBahg/eKCdHVcH8XQeLHxDyjJBhsHVjh29TnPgtQvYV2K0g5pZtSPAObw8vRqvyHsPnSv/dyBjq1ndlb3M6rtoZHPtW8pplJfquLY8Ki4ik6P7Orly+SeQ6ZZ5GEzN/KTCWhV0v0Elcg+pDYP2LcwLA7TSY3ijFO8+82v0BweyqwuOTLFOJp0fGPSo99Kcv0j9Hru/lrRmvAlvPkEMat2JZ6xsyJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTF3bzVWREs1b3lpY3R5K2UxbkpHeVJoNjlaTWJ0TkxuUzVVYS9FREpQK1BU?=
 =?utf-8?B?bDN4bkNHRUtDNFdtUllGSkg1Y3ZCMCtoSndyeG0zWmZPQjJHWFdZNy82Vmlj?=
 =?utf-8?B?UXRBUzB2aHU3dWpXT3dydkl2UldzdG1wYWJEeW9xU3NQUldQeVI3TFNkRWlv?=
 =?utf-8?B?TGI4SXRYb3NYVUVvZVZtckJDOGtKeHNTWjExREhtQXdSRTJGOXlNME80NElS?=
 =?utf-8?B?QWt1QWhqR1QyU2swNXhGR25URzlWT0loQ2lObUc2cG5zZDZXRUtaU0d0anFR?=
 =?utf-8?B?OEpJdElsNnFhcWdxenRVSlZlWks0RTRCRkI3V2NnTXEzbHpLclhOOHdRYnpU?=
 =?utf-8?B?MEhtRVg5T2I3T2lSbEdCeU5QR2pqOWl6ZG9sb09IbEp5NGs0Q3QrbkEyelhT?=
 =?utf-8?B?SGpaUW1XQkk5S1pxS3Vield4MVV1Qkd4WDdTcStrT3RndjhTYVZxYnE2Vi9F?=
 =?utf-8?B?c1MwY3pibGF0NDNYUStTdTVXSTlsYnFNUlN1alh5VS8wWGpkcHk5bE1xcE9y?=
 =?utf-8?B?ZTNZdXdRNFU1VTJNQ1hFeE1ybUVHMGpvKzBjMWV4R3ByVTR4cFlIOW5pbEdm?=
 =?utf-8?B?OG5rb01UZ1J4elFNZVdJT0x2WWRLREltTktRa2JEWE9PS1VsRlpxbDlJR1pj?=
 =?utf-8?B?R1JEeDdHT2pEVnVaSWc4K1A3NnJVZlNGRUNLd0lqQWkwZlVoVXZFc0pIVnpC?=
 =?utf-8?B?czhWQ29SOGEzWlU1S1pSNXhkNjdOOGFLd2lzY1RtOEd6VDAvZ3VhNHF4RC82?=
 =?utf-8?B?anBYRWlQTGhYbDByeGtBRmFXQXlURjVwT2Fia1pKZDZhc1I0dHlra2J1dDhL?=
 =?utf-8?B?a1cveGw1QlAyQTZ6eDlzMXJFbXhaNTUxRUNGYy9EK3h3amptNWw4TGsvVEdF?=
 =?utf-8?B?dkVLZ1J5VXBPU0VMejBDdHg0WGdaZlhKbzI0bzNyOXkvc08zYXJWV0Rxdy9Q?=
 =?utf-8?B?K2hoTDVoWHNBYUtHcDJEZUF2UkRIU2MwZE1MS1BMVHVhL09TdkJPTVJvajBQ?=
 =?utf-8?B?VHNEMHFXRW0vUzJ6OGZoN0tiVVVDLzNOQ2hTanpBcHBIWk5XV1ZHNDYwSzJw?=
 =?utf-8?B?V29qMmlHaHdkdUZKanZualpIajkxQktmMW1SUnc0dUNyWEJ3N2wzVkswYXQ1?=
 =?utf-8?B?NVUzRlZLY09qc3hMSnRodUtEZ2VrbXZGSmhsVThmUm14bWF3QzNFdXpkM0I1?=
 =?utf-8?B?WU03dGhoUktzUGVUSHVkWkJLSndVNC9xNDc3VEhaS3E3NElGOXNMK0tqU3JZ?=
 =?utf-8?B?YU1hYW92TlIzMFd0VWRUbkdWd2Rsb3I2cExxcnNzc1JzSEtYQ3ZCblZJcElW?=
 =?utf-8?B?V2ErRzFWRWtoazVqSnMyUm56dXVQb1VCNUl2NWhublpnSEVTZmExZXNNQjA0?=
 =?utf-8?B?OEloUzd4NzFiWHBaRC83YUxsZEduZlJrL3AxamZPWXJReDNrNEhyMmZURk8x?=
 =?utf-8?B?ZHJtYUNwSnZxWW1ycnc1aUp5WXVZQWVjMGgwT0Fqb2FrVTlia216ZVNKOHR1?=
 =?utf-8?B?dkREdnFSbG9MTUNoWHFRK0VoVk12SXBRY2tvM1VCaEJOZ3MzdlZFeEVnQThn?=
 =?utf-8?B?RzIzOE5oTEoveW11cXdGMG8zS0gyRVpYL05kK29wK010ZzlYeURiRWVmcEZw?=
 =?utf-8?B?MEtjK0FNbUw1RU5TQW5sTjBneFNkL0taTlBRbitLZzJEVlFSMjNPa3E2NzFB?=
 =?utf-8?B?NkNxdEk3bllldzZBUUZKYmlrOUZZeGEwWmg5YU1rT2hpdWg3ZWFwZ2FWakw4?=
 =?utf-8?Q?Tl9Tw814u4JHpOAnHUNOmL0ObBPtdmoNZUC4IFY?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb17302-af69-4ea4-8bbe-08d976b6c40a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:39.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9K0bN7KGEDVdHc8QXvmyWYQZKwJYTRQ9TrsaBi6r262lABR2QEp/ta6afZ0jIX+ArUX/AVPnNbP5xd5qd8SWZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
ICdjaGFubmVsJyBhcmd1bWVudCBvZiBoaWZfam9pbigpIHNob3VsZCBuZXZlciBiZSBOVUxMLiBo
aWZfam9pbigpCmRvZXMgbm90IGhhdmUgdGhlIHJlc3BvbnNpYmlsaXR5IHRvIHJlY292ZXIgYnVn
IG9mIGNhbGxlci4KCkluIGN1cnJlbnQgY29kZSwgaWYgdGhlIGFyZ3VtZW50IGNoYW5uZWwgaXMg
TlVMTCwgbWVtb3J5IGxlYWtzLiBUaGUgbmV3CmNvZGUganVzdCBlbWl0IGEgd2FybmluZyBhbmQg
ZG9lcyBub3QgZ2l2ZSB0aGUgaWxsdXNpb24gdGhhdCBpdCBpcwpzdXBwb3J0ZWQgKGFuZCBpbmRl
ZWQgYSBPb3BzIHdpbGwgcHJvYmFibHkgcmFpc2UgYSBmZXcgbGluZXMgYmVsb3cpLgoKU2lnbmVk
LW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgfCAyIC0tCiAxIGZpbGUgY2hhbmdlZCwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAxNGI3ZTA0NzkxNmUuLmZjY2U3
OGJiMzAwNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC0zMDEsOCArMzAxLDYgQEAgaW50IGhpZl9q
b2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25m
ICpjb25mLAogCVdBUk5fT04oIWNvbmYtPmJhc2ljX3JhdGVzKTsKIAlXQVJOX09OKHNpemVvZihi
b2R5LT5zc2lkKSA8IHNzaWRsZW4pOwogCVdBUk4oIWNvbmYtPmlic3Nfam9pbmVkICYmICFzc2lk
bGVuLCAiam9pbmluZyBhbiB1bmtub3duIEJTUyIpOwotCWlmIChXQVJOX09OKCFjaGFubmVsKSkK
LQkJcmV0dXJuIC1FSU5WQUw7CiAJaWYgKCFoaWYpCiAJCXJldHVybiAtRU5PTUVNOwogCWJvZHkt
PmluZnJhc3RydWN0dXJlX2Jzc19tb2RlID0gIWNvbmYtPmlic3Nfam9pbmVkOwotLSAKMi4zMy4w
Cgo=
