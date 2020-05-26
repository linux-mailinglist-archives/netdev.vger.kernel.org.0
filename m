Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814151E2858
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbgEZRTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:19:00 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388736AbgEZRS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2pFCKy5LaCnnAVhLrXhyVRMPAKLwVrSOpp3XomqPXf140JmwyEsBOM+mYV4AUJj4jCfGn6MGUI4418uj6UZphx/4UhsmLMGbddWYYT5YcgUZdvmM9Cu3qzknccRUyrxH+rpPjf8k/6eD35piZpbqdoqd4ejjzYlItnDKNOVShxaIc5oqVwuGwKcc3B+poV8TTravInVG44httoFfUm56sKm//NvOVJ/i6QN0cVKLgUMGF7wpLYUH+vkH7xZfv9gd9j32hgOqCKP/XPGHnZUtRtizPfrYWuUOxgEP7K27nQ0lPmvXHJY3XF0YxFSQ2S6FyrgyjXZyS5ZGlcPJimDDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oshIULAZ0qp5hLmt2U37gnOrA+tYUU0n5uGYxxUja8=;
 b=ccOj4VhI/lplBqb2q/bMc9+vG5UTPYeCiZsaQAbV4d8188FsIH80fBRLrAL4ISR6rGrjl1qSGcxt4H0tcY9hgP5Txaclx10SEeHKAW+E8EFDYf7CgDLx9yrRr1SiiFSqk5FDLnP0gJBt0O7USRDzvl4dndBaM8aL0BNeU05VhJsLn8OvalpgJ8PgBqiCwXYp6Vxx3Kr3CtVcraIRQvjGFQXjCDrOd73RuZ/ajksQGap+0nZz2nCbYFGIVAG8105yvGSvndz/hAvFkOQrBJVZz9enk4LFwQ+WMZcRRVEyjRP2sNkpeGb9ojLP3l8THCAsBXxZTyFvzyMkwAclKQ3X2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oshIULAZ0qp5hLmt2U37gnOrA+tYUU0n5uGYxxUja8=;
 b=pc4h3Xn4v9e9ftcoJ0cbH46YOw9S/5DjF5GcMbaB/hlG7sc/Cfxoa7AKetPC6WC3AvCmgf9BTsYYorE9fqakF0WxVW0AQ/+BixsCvTvUURcgmXAW8gO7QzQPexfxMKes6BF8zrr/dWDKbvvEzn2ZpzbxuER50ZdO2A+8hKgE9pc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:49 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:49 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/10] staging: wfx: retrieve the PS status from the vif
Date:   Tue, 26 May 2020 19:18:16 +0200
Message-Id: <20200526171821.934581-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:47 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d47e3e01-1945-48c1-034d-08d80198da96
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2750BF88A6F5B79CA9B20F0893B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SU933gwRq02PP6xL/XZTvXigzI1wQVDh+UySli18TO93qE2WShEMr4AnYDYpPEb+vQ5iwJ2/sERhLBEKeclAS/Nf9SQQKfkyvrLcp9UKlZ7MCucIXGuH2/eVBbJmpjIaLO+tS4/0FeNdp3UATtIJcrCeDWINL/lCbgBczGoGs3sQFAtL74BEflVQy6DtzrhmcaKsUtrlRXn/2SaeCMN87TTFkzFb5ta3N4444SUUJUpseJy6FR3QFyTdhMVbqMBS9mXPGjicLtYbENyrnEiChkiZOD5bySg6uOpo54vTqg3B6Pd9p1zrD4Ct11Ji3M2W5/Bs36g5IRy2dQXZv2sYeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(4744005)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N1ja9PKm3ROBkDUl7fqOoh/ZMLAvgAjYbD2lQmu/W+i7Q30zWYfuOXefUHmxeII2oQRFL3KRmix8eaHRtEudiIUs5Tsb9puLq7zG+muGKt5X9CuSLZ9GI3wZ01HJ+ZyUZ1le/cDaQDVDsWTN/YiJkPQ/DJGTnS9A3mvIHdrJZ8WL1S4X/zOAIMb5wCkAyX7fAsl8DzeDIBthGse/656Qw6ua3dcrm7CLIIjCXBLXT8LaOTupM86/vV27s7vmhWtehKt1wfA1b7ZR478ZyhBBvhOGB410L1QPY+huTV6p6Z+TTsI7/KioGWENx5jBltItsKO45G1dSKFhV+reaPTiuc65n+oqS+hGOFMAHxU57px9vUPtCKlZf6SwL8zHlEdRP05KBn3VC7Xs59EKkGMYN/IzVN6SrVli1CTjzI0SQ37hRMiit+0lR127nCj/KloyrwLuPrp0u6rK7nPFGu/ydoS0QxLaxkK8opEIdk1MyYeENfsW4kukvAj8Pn+Fn8Fs+1EB7tYz4ojgjLHvh+3jbGlL5sYAGxjrjB3DjS7BPrM=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47e3e01-1945-48c1-034d-08d80198da96
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:49.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bsm6TRAa4BAtQFk2XMuxpEHn8VwTCQkBqJtMTZ2LU/NrFWK+VpfM0fitb8O1iDMfaRPCooYHoxK+AT80Gb28w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IFBvd2VyIFNhdmUgc3RhdHVzIGlzIHN0b3JlZCBmb3IgZWFjaCB2aXJ0dWFsIGludGVyZmFjZSBh
bmQgZm9yIHRoZQp3aG9sZSBkZXZpY2UuIFRoZSBXRjIwMCBpcyBhYmxlIHRvIGhhbmRsZSBwb3dl
ciBzYXZpbmcgcGVyIGludGVyZmFjZSwgc28KdXNlIHRoZSB2YWx1ZSBzdG9yZWQgaW4gdmlmLgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAyICstCiAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA2MDE1Y2Qy
YzRkOGFlLi5kMGFiMGI4ZGM0MDRlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTIwMyw3ICsyMDMsNyBAQCB2
b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1bnNpZ25l
ZCBpbnQgY2hhbmdlZF9mbGFncywKIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZikKIHsKIAlzdHJ1Y3QgaWVlZTgwMjExX2NvbmYgKmNvbmYgPSAmd3ZpZi0+d2Rl
di0+aHctPmNvbmY7Ci0JYm9vbCBwcyA9IGNvbmYtPmZsYWdzICYgSUVFRTgwMjExX0NPTkZfUFM7
CisJYm9vbCBwcyA9IHd2aWYtPnZpZi0+YnNzX2NvbmYucHM7CiAJaW50IHBzX3RpbWVvdXQgPSBj
b25mLT5keW5hbWljX3BzX3RpbWVvdXQ7CiAJc3RydWN0IGllZWU4MDIxMV9jaGFubmVsICpjaGFu
MCA9IE5VTEwsICpjaGFuMSA9IE5VTEw7CiAKLS0gCjIuMjYuMgoK
