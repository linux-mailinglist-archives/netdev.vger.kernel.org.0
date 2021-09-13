Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C598C408B9C
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhIMNE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:29 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:54369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239080AbhIMND4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bculkg5t6NFBZBPr0crWO+b7k3QcmlAYaL7rwF3s4GXfI0d668FrHh4uv431BY/h63wTMTaOg3CpRgycGmYQlRhjLkO1RYuikMNK5SkKWocluZtfC79Cub9W2fDe7GKmL7AvawF/4UQ3qqPrdcMtlG4xaWjZMHER8KqS17zz00Dwk9WiLMJgGgkkty7Bnew/bjMMvB2IlZ4a2lde82lpYzkgooMLsSFmeVW/vfN6jYsFZ1JCa9Cmr1x9IXk1f16ba9kcbXF8mCa1jVWt8qSWlpRhoibWoOdnIhsEASANnDosh8CKMQkMn+D+Dqi72bjfamY5j3vFmFQFa8L+kt53bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=Z2W/yW0AH/KjUdQ9Xb9pAZLsisTrJjtT6MePQppSAbtHn3c0t71OXhLF4PlXluwmHbnqpXzYTm2m62BKLjgSEwavRll91zLa9GoUoLEVsKT3XceUTqpusyF2shDoZq2ZxfPmeLhVY1XTRLwKfT+kCrDx3886kvY70ol/FWvLXYGY0E+gZKuCmAZdnBAd3Nu/reRk4P1tCfJzt+LwMVF9r0w02AXllmtupQRUJBaVFI0arLGK1bDZQDTiepE32R5Gw9MxvvU01N7PizFYkABvOdDjhQk6i1/iSThdXCX6aaZm8L6zH6Fqy9gTVPCNZ4GdKdJtcXZ7UQ6aGeU6suuGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukiiaXuHB68lNESJa7s+KPhr2UdHv8KEhL2rJ3/GeVg=;
 b=N2xbeV9/KkFElEa9SKsVHLCWJV96+oYAViGrCZTEdVJkzEUdOLE/QrSnQcTogibX1DI92fIiXKFdYcGKN0zTGQHSdI18LtV7voKusJCZGxp51qadRWl/1uQl6vYcXIzJeL3McqDyi6RsI4vH7cr74Wic9UR2DUz8wC1RiVo38yQ=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:31 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:31 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 08/32] staging: wfx: take advantage of wfx_tx_queue_empty()
Date:   Mon, 13 Sep 2021 15:01:39 +0200
Message-Id: <20210913130203.1903622-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0e36de-de8e-401f-c24a-08d976b6bf62
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB486013E017063506C7C9786693D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUUGvWV1wbqaPvlu90FThUmw6/xngzHxEk1HRjzL492rhgnbejNDC8sejynd9B5TuIBFfjslvjX8FVZMG5sZNPw/sGt7mycn48Df8/BcWpQ3qVZFn7Ogi/XdfZQAVD/sqBUubMO2R18EofjGubBfFnaNFoU7Lri5YPPRLiyjwdqnUfqevCrqSVexezd2Uzlbiw+Crzbbam6cdfnkVvjjD6S0wJ5tVvXcN2SBynzSAczYiYdp9ur4GOGjITqPqxLWrzuU5yrXZZQ9uZR5B5AzwaNCGNXj+sVhTBccUdkVn7jrw39WOQuykJu123JtuRDtorVPtynnHwYH/WRbMH1G7g8woFCL8PTHT1jZTOK8GXi3z1V0XCgqsSXOIhTjltxI+M3j1hXZc/O7AXH5Iac09WoyKAp4vxXirq8uxjvbb7rPckRTZHj0I+A1FWFJ1W+qeaor3cOCZ6/s6Njxd3xbtjoA6jzhSRDlsqPgC4VhvH9QkzQdSzV8udk5ZuPYFpNO0iC06g+Gdhg46wCR/WzZDwDclksFuOJn7WWjms1zlJAuC/6LEJ7w49zIDLOv+rnL167NZEYdDUDu7n4WrSXRy5sePvtW9vmejacQ1xcHK4TRSugs1ImA49Wj2mIFOmVkwJ5XF3UBjDwiaFhPb9s2FNAOsdimyOV4j4HwKndVVvpf+dzcX592DwOAiMt/Vf/IMGxroonZ2AnXa1WF1cer3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjJGb2VlNnk5bmx1YUlVd2cvMVNGVmZnVFJZNHRaN0RvWGM2L2FPSWVvbkl5?=
 =?utf-8?B?eENnendPRW1IUGp1bm0ybVZmVkZCek43QXZnbHhyelQzMGNQMlNMak4wR2Ew?=
 =?utf-8?B?RSs2eUFSUk10ODZORUZXbm5QNGo4VTJpNGI4RXJTRW44WkhPU2VIWExnL25U?=
 =?utf-8?B?ZGFIeW5ZbFdvcVRxVHVqbGJkSVNQZmdOVGxWSnQ2Nm9pOWc5NythNVZvMzVx?=
 =?utf-8?B?ek9sNGl1cVFHbmZNY3pQaTdUeTRmVHlnMWZ4Sk9WUEdpcVB0TFVabTRaeDZX?=
 =?utf-8?B?bHJpOUt1K1RFekRwa3hCVThOMU9jcXFUSFZic3BoY0U5QTJmRkRMRlNHZlhn?=
 =?utf-8?B?ZjZ6SGtDajBhL2g3ODNQenMyemZSczJtNHdGK0psQ2ZCRzZ1YTZyT0NSNnBv?=
 =?utf-8?B?aFBwbXFQOWpZSE9TUTRJSitmTnErRUFYMTAvZm5PTzIzVkhJV1dRSUE3YUJz?=
 =?utf-8?B?aHVkWk94NXhqSU9wU2pTV0o5WHZzckd6SEZ6WEE1ditLekJEcHN5UFVKTlc3?=
 =?utf-8?B?WlNML1JtUmt2N0d2SHJ5VDRTcEdxem9tQUF6Y3A4bFA2TGJkL2RaYVppMTNT?=
 =?utf-8?B?dTk5emZRdGUvVWdjeFAyYjdMS2lrYXRhRGo0dW02MStOek9UbVFmWWhsQVVs?=
 =?utf-8?B?UHA1bDhkVWVGeDMzM01qTzAybWlORllmMEkxcUp0T0pocitWYzhWRnJDVFdS?=
 =?utf-8?B?Rzd6MHYzUnAyK25IVGFRb3RNSDRkM2h3VmhDTG8wQjg4WXNNZzNHSDJNV2Fs?=
 =?utf-8?B?Q3hPYnpzcWUvdkkyWDJGaEZKVzhEY2kwbkJuUVJMNUIyenExYVhpTmdDUnVO?=
 =?utf-8?B?d0crL2VlNEZIUUNLU0MwUFQ2YkJxSlhMdDJqN3hBR0FsV01Vd3dlR1ozVkh0?=
 =?utf-8?B?Rk9OdGlsd2dMODJITGxrbjhxbEdQcWE5WnU1RFd3MW9FN0hWZ2ZhaEg3Tmxi?=
 =?utf-8?B?NWwwNGV1NThBMVlsd09NaVRFZnVtVWFEaFh6Q2kvRnlsV1hjU3k3cktwSVQv?=
 =?utf-8?B?K29ZWDAwNE1TVno0Zmh2UmJHUk5pTHlJdHowTzFCRys3T1c3MzN3ME16WVJM?=
 =?utf-8?B?V29tc0JaOVo1cWZkS3RTSXo0UDF5OENWQ1RZSWtFYTJtblpza1lPZ0F5UDFt?=
 =?utf-8?B?N21aUUpwSDBaTHVJN3c4Qjc0R0JHbTREMUR0QnF1ZWR2YnN3dWlzb3BQMlRQ?=
 =?utf-8?B?a2VzN2xSNlhYSmJnWnoyZzRjc0tIWVdTWkZVSVBncFJLTUllSktUNkNMYzdR?=
 =?utf-8?B?cExNUDJTdXp0d3RuemxTQjNlWktKbDBnZVQ3ampTY3psRUNNTVloREVPcXc1?=
 =?utf-8?B?ZUxHc2ZMMUx6Qlg1TlNWOURGMk1pN3Ayb1RoY0NIRFpkbDNpZFFBSzhGaEo1?=
 =?utf-8?B?VUNqOSt3cE5jZlRUY0hzVTNEOHFWL1VyMTdIeG9iSnd6aW5OWnc1YlJlOHVP?=
 =?utf-8?B?cnVpWFhMT2Vwb2kyVjJnYjhtZkNScElBdzBva0FpUGxnM09EU0ZUYllkOXlo?=
 =?utf-8?B?ei9YSVZaZnIxdzBZMnErNXM3aWUwdklLY1k2QnFuZnR6b1Z0cEpuMG5TYlpR?=
 =?utf-8?B?RzFRVHJVckhrVGhmdXhPREJMczdlcGs2VkdDbVdRVTUxbEJXWmFodm9ZMlY4?=
 =?utf-8?B?UC9pTWdINTBZdmx5YWx2bTNYbFJFNHZwY09zOXVXelNZUnpGS0wwZGFZZkMx?=
 =?utf-8?B?ZERCL2hWRFQ3UXI4Z3JSdTRvRWZBZ0Vodll5SlB2VFhlcU5YaHcwc0ltR2Jo?=
 =?utf-8?Q?4R1NpOkEgrjXnb5uZI6yXCuz9SdDsFSWO6MkZHu?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0e36de-de8e-401f-c24a-08d976b6bf62
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:31.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tGysRla1abGaPdGJM17r/1Y3pzxrLcLhN/WEGfMKmQm1WOfuiy5b120MPyPsq8/wyrxz7MXmHgXeSfMaQG8TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlc19jaGVja19lbXB0eSgpIGNhbiBiZSBzbGlnaHRseSBzaW1wbGlmaWVkIGJ5IGNh
bGxpbmcKd2Z4X3R4X3F1ZXVlX2VtcHR5KCkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jIHwgMjEgKysrKysrKysrKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTAg
aW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGZhMjcy
YzEyMGYxYy4uMGFiMjA3MjM3ZDlmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC03MywyMyArNzMsMjIg
QEAgdm9pZCB3ZnhfdHhfcXVldWVzX2luaXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJfQogfQog
Ci12b2lkIHdmeF90eF9xdWV1ZXNfY2hlY2tfZW1wdHkoc3RydWN0IHdmeF92aWYgKnd2aWYpCi17
Ci0JaW50IGk7Ci0KLQlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7ICsraSkgewot
CQlXQVJOX09OKGF0b21pY19yZWFkKCZ3dmlmLT50eF9xdWV1ZVtpXS5wZW5kaW5nX2ZyYW1lcykp
OwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4X3F1ZXVlW2ld
Lm5vcm1hbCkpOwotCQlXQVJOX09OKCFza2JfcXVldWVfZW1wdHlfbG9ja2xlc3MoJnd2aWYtPnR4
X3F1ZXVlW2ldLmNhYikpOwotCX0KLX0KLQogYm9vbCB3ZnhfdHhfcXVldWVfZW1wdHkoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlKQogewogCXJldHVybiBza2Jf
cXVldWVfZW1wdHlfbG9ja2xlc3MoJnF1ZXVlLT5ub3JtYWwpICYmCiAJICAgICAgIHNrYl9xdWV1
ZV9lbXB0eV9sb2NrbGVzcygmcXVldWUtPmNhYik7CiB9CiAKK3ZvaWQgd2Z4X3R4X3F1ZXVlc19j
aGVja19lbXB0eShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlpbnQgaTsKKworCWZvciAoaSA9
IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgKytpKSB7CisJCVdBUk5fT04oYXRvbWljX3JlYWQo
Jnd2aWYtPnR4X3F1ZXVlW2ldLnBlbmRpbmdfZnJhbWVzKSk7CisJCVdBUk5fT04oIXdmeF90eF9x
dWV1ZV9lbXB0eSh3dmlmLCAmd3ZpZi0+dHhfcXVldWVbaV0pKTsKKwl9Cit9CisKIHN0YXRpYyB2
b2lkIF9fd2Z4X3R4X3F1ZXVlX2Ryb3Aoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJc3RydWN0
IHNrX2J1ZmZfaGVhZCAqc2tiX3F1ZXVlLAogCQkJCXN0cnVjdCBza19idWZmX2hlYWQgKmRyb3Bw
ZWQpCi0tIAoyLjMzLjAKCg==
