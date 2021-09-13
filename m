Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD11408BD0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhIMNGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:14 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:10209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239037AbhIMND4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW/ndlIjtDKpEoNUEvvqcsVO5u17vRH7uft8BcLXz175YY9ZV3M05CCnGsxhAh+Ln/ml94quFCQWZefnH+H353crUNWHdOPaJ0T8ZeT2k5/sVyQW8m9wKb0Tv4dbzQYftE6NzatdOdCZ6EWestvu7wsYLk20MLFHOZm2k9tSe5HfmpuCVCs432vmxJgPQt7K7JSFLdygh4nRh1TyN65m939Gr1H8KIumM5Rmv2HXEzlo7iSUCULrsxXf8WnqCPzwWBr82O0Wh2TIWiecRy1YZLbRzWY8n1eKH5zyMs9xHJB/TpJtkV9n+WZk/CJ9vG3XDh7mrkaiwaNsDB9t9ae/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6X5C8iiyie5c+H0xNzgV2k5OxRmd70FdYQimieF/nBc=;
 b=VOCYnJe8/MO2WGmVSqGLE0Y4+W48wJTciVpbYRO9riPsELg9eYOzhZOEyk7vCt4wL3efBDpT4Ka8IbneKKAaRgLJQMryPLHaneoDCt/ciOpwUkH6uKeyi8DrUfrTV5U/qObftU+96mKZle3HiYS/IZ6oND05tV3MWdcSWk0K9l+zcrbaxaDYgQiD3N6BgGXY1b6YwusUkvs6qpb9ng4c9WkRVNyHcafs+/D0eqQYv0m7gqBhr7d6ZUPIBhtUkkLj5Dg5JMTSBs9dVgk0K8xvG/1xuqZKLVwYXkR2GgeGFGMnoPXMgVKh2zrZFToR+GGVvIe3M+0I2pdAUa8B71ckqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X5C8iiyie5c+H0xNzgV2k5OxRmd70FdYQimieF/nBc=;
 b=LA3tzN7pjwSCxr1orVpxyRo1bKx1c2zoEytGrcYbY5qmjJG29XPc0XnXPZILV2PaBuQRl5g8cRJ+WGApMvz6z/WwGBoZo4AsYZdc3W2VdW9J+zqesz4l6CqdH9nqkiPCEj6u2//DGxSz6hShZt068o6H1Kw0wgLt1EK7CD5Kvd4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:30 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 07/32] staging: wfx: fix atomic accesses in wfx_tx_queue_empty()
Date:   Mon, 13 Sep 2021 15:01:38 +0200
Message-Id: <20210913130203.1903622-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 276b04a5-0473-4858-14e3-08d976b6be30
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860D3371D33A45DEF8F03C193D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5lKbEAKEdrwmpOd5gsk3k2cvcqQwwoIVtAp4fto4PaDlEieG9su9q0lhfgR9gQDA10RseSL8+O4yT/wT2tNDw2h6S72ypJtT3jUQ2YmPVHPDL/6MLNrgGzO6WUlAXMU383vGLrEOWz6Nt3ybJespeRiSzi+z+V0OUlM36DrYcTst/3FvscWFoC2Bwwbp/ejgts5zoYkua1hf+ICZ/D2UVaSaTPBEEZSBwtscr+yN0KHokypmR9DQkpCPzYoFfKwnLZz1Wgc8Agw0/dfG3xa00wHfaZ70RDDBYqbiLbGswv4YYyHhvaqytCt76gxO2mne4bkGIfPBbPHkzMY6FINfDia346zGnQB5I1N9geNLv/E4dKwvBi8PXr6JbBEWPukQxDuJ9NOaJxzgDzgl8HIg5tZvdXCwcDsMaG4MlNBb/jmN++GkMPe2CzciHcFPfdiPngb6BBI+K9vhXjRfOT132b0Ji1tGIeAYk5o1vf0YuNzqcQ0KjMj+lzyfCD0a0lMWvjx8iwl/Gseb0uQKX+HYIAtewxZhvNv27YqT8Wrc7URXhD8Ps0AdN8PtsSBawcG7KCzOxxWf4EGBVUX90IvsnGH6724KXQV2Ev9gJMZUZm6Q8IVazo1tlAnarFwiamxoD/A/8rNZhOEqXQebfn/n3AkkWTFbNALUpr2/dxeLlxDDl0mWNwOUM9uK4cxHr7MIdSPSgQjOrD4oet5HW8/xLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66574015)(6666004)(4744005)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTFjRHJIc0NxWk1Qb0plNjlNWisxZTBxODBZYWNFcFVzUkVGeUwycko3dnFT?=
 =?utf-8?B?aFhQcmFxVnZnaXllUjJNZW5IQXRRdmpkYmwzM2N5Z2ZOeWFUT1ROZU1IRnEr?=
 =?utf-8?B?dDdlMHNuUTlwWmY1M3RCeFpxZXZZYkNhMGtaR29VeUFQZGhVcGZIQmpnbEpl?=
 =?utf-8?B?VmVKQW56ajhET1h2OVJjcUxvTitlUW1sNEs1RTZwd0xUZk5JR1lEU3Rta3My?=
 =?utf-8?B?Q2xNL1U0bWxESWxtYjBkU0U5U0xzMTVpNVdnd0JtZzBESy9QV1JWMUZNR084?=
 =?utf-8?B?cUZlWWszSXJJN0Y3Tmx5K2ZEa3ZFWGlDVmZST3dXLzVKMGFCUmlYd2E5bmkv?=
 =?utf-8?B?dHBLcGovMXEwaEZaNkxHdUQ2RENsejI2Zkd5cmo1a1ZmbWdyNmFMbnlyMDZ0?=
 =?utf-8?B?SEcrRzQ2SnQvYmJKK0ZJdjRiT3puWmRuQXJOYlpicTdZQ0E0akxqTnhPc2Z0?=
 =?utf-8?B?Yk5TY0t2VHR6ek9qU2xJdkk4Z0VuekEwbkhacEdYQWl5UllLRU1oVFRXRjBT?=
 =?utf-8?B?RUZxckZpRDEyQ3JVVFU3M2E0MmgyZXh1eUxHRURXUWIyczRjMjJVRUp0bVBa?=
 =?utf-8?B?aGRyczFSWjJTNWU5THhUc3h2OHlUdi83MFlpSE43djdTd1BGK2RaRzc2Q1dj?=
 =?utf-8?B?d2ltMVJ2VDNTbTA2NDhsekJWLzU1bXZydTFPUllpNVRhb2p2UDI0TDZ4Z1lz?=
 =?utf-8?B?MTBSUDBWblVUTEN0VkZvejhIZmFFaE1tS1VXVHlBc0NBbnM2Z2VSV1IzQVpO?=
 =?utf-8?B?MXJKTlUvTGlhQ3NYS205ZWdzNVdyOTJSRVg1em5sdkQvRE0zKzVkdHhqRlhS?=
 =?utf-8?B?ZHZZRm83UEFXL3F3ajBzcTFjNEVTSkJrNXFFK3dwY3hrZ25oWG9qeVZOeXkx?=
 =?utf-8?B?U0UxVjUrZ0YzZGlvOWYybzczVEFuOG5lZ3dESXppMHJMQzMrKzE1cmV6Kzc4?=
 =?utf-8?B?dW9DN3BjMWFpOUdONHdaam4wVUc5d3dHSVErMC9BUEcva2lBbnFvUkVYVXJD?=
 =?utf-8?B?M1RKM2xlVEVsNW9pQlVuSXVQclFJeUF6ck5zQzJWSGhUenNaUGFCMEtIQ2hx?=
 =?utf-8?B?Ykx0RGFTTlMwaVpVVG1QVHRUUU9JdDk3MklaMFNFRHFzSlNCcm9DMWV2SjZp?=
 =?utf-8?B?ZCtCMWt6VEdrZ3doVUhqSklDTU13YUs0YVQvcVRWZ2NPelh0QU16cUhsR0hL?=
 =?utf-8?B?b09uTXpTa0tZaTIrcXRZbnFCcHZhUkZPRTE4TU1lMEFIVTBJUHJXbHo4Zk1L?=
 =?utf-8?B?aXdIZUZTZ0p4eTVBdExoZkY1Ync1d0phVTFXNGNnaUFTeW9CdXdGK2xmQThu?=
 =?utf-8?B?NFBOQjcwUzlvZ1FyVitwRzdvS3lZcUJqZjAraEFhaVgwbGdWWmErYStMekZm?=
 =?utf-8?B?UUFwWmZwakk5L2wzZmd3Tmc3cGJUTGtXWmJvMEVIU3VyNThFNlVEdDlKTVlE?=
 =?utf-8?B?SnBxL00xMGdwd0hvejEzdElQeEN4cDlvdVhsdzVxT0RiZ0dsZm92R0hGRFdL?=
 =?utf-8?B?bGR2Sm80VVVKWW9MY0VVdGdLOVpQdmxka3BhSVFkaG5YMy9NWTF3UlpDVkJy?=
 =?utf-8?B?ckNGMmlqbENMTmZZSDczUndvR1cvVUw4bW9aYlZrRzZmYXB0b2dDQVd5QWlN?=
 =?utf-8?B?WG9ETVFiVlkzZnRvNWhEOFVIZlFKQ0lIeVpzbkxKZDBEYVZMRGR6NGM4ZkdU?=
 =?utf-8?B?OEpIaFRJS1hMTkkyR1ovZGZsMzl1MHRYb2N0aTJlOGVrZk15Q3R3ZHRGdmRG?=
 =?utf-8?Q?IqJSes2h7s4yXLCcWhi3mancQakYUvHrA57t3fn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 276b04a5-0473-4858-14e3-08d976b6be30
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:29.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+zh0bJpb62siKqT2swhbwlnNhtDFz5n9p6bSMuQOsqCnvfNrdvr9uJGYpaFxpWHSf7GtA7Pd7YO0R8uAQg5cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ2hl
Y2tpbmcgaWYgYSBza2JfcXVldWUgaXMgZW1wdHkgaXMgbm90IGFuIGF0b21pYyBvcGVyYXRpb24u
IFdlIHNob3VsZAp0YWtlIHNvbWUgcHJlY2F1dGlvbnMgdG8gZG8gaXQuCgpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMzFjMzdmNjljMjk1
Li5mYTI3MmMxMjBmMWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTg2LDcgKzg2LDggQEAgdm9pZCB3
ZnhfdHhfcXVldWVzX2NoZWNrX2VtcHR5KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCiBib29sIHdm
eF90eF9xdWV1ZV9lbXB0eShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHdmeF9xdWV1ZSAq
cXVldWUpCiB7Ci0JcmV0dXJuIHNrYl9xdWV1ZV9lbXB0eSgmcXVldWUtPm5vcm1hbCkgJiYgc2ti
X3F1ZXVlX2VtcHR5KCZxdWV1ZS0+Y2FiKTsKKwlyZXR1cm4gc2tiX3F1ZXVlX2VtcHR5X2xvY2ts
ZXNzKCZxdWV1ZS0+bm9ybWFsKSAmJgorCSAgICAgICBza2JfcXVldWVfZW1wdHlfbG9ja2xlc3Mo
JnF1ZXVlLT5jYWIpOwogfQogCiBzdGF0aWMgdm9pZCBfX3dmeF90eF9xdWV1ZV9kcm9wKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAotLSAKMi4zMy4wCgo=
