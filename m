Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7A406F01
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhIJQKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:10:00 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:8641
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229944AbhIJQIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw6rUajUkg/MTnwBBV6DhHax1zAkP0z0wmw64+maeIufo065MJuLgNNoBWF2uPVLnJtdsm8Qn4o8hdIlt3iK+dG2bSsItgfspfSL0O6HNZoY928UyhxMRnHx7o5X68UGKE3hoEiddNPBa/dJ3F29spYAjMRfIJIutRRYROezF/oTP+6LzEhvM/aHxF4RdXLtgFJaBEjqKqsBTQGxtv8nshNOMiT9GQ9EDaeTpxRAMcvyGm7n4gsPSBpBhPPuHr1eEnBt6g1r4+iTZiPpDs/UdPAi/Nm3DnZYI5AomqP4oWBzdUmMBQEZaxdFSuWm2x0eBXyy2vULVPq55iULKurICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FwmAPHbajhF2+WsJKbgL8BGX7TdC1AgdDDz7sKWPBfE=;
 b=B70rt1J9PbXaHWF7UvA7PhmoKRw9DGfrlxw8JCuyIe8ko49Ka4vf8dgBOQyNj9fs7D+oNjz5k/fmdP4pXjZ6+Ta8vAjTkvIC/2SP1TWo2auHuIqxIfd0pNtieIawXgK92U99bPyPSJmsbXoHQzsznodsQspOHO3bQoyN7xyihhAbeCB5HAhxdowTVrqpqeYd1Yig/29Qhu3ZnhWQ9BXXhmXsyGaZUHBLPv8Mt0OE5M6kX/n6Qj7EldZdQblVzqS9t9ton3N/Z/UQ91G1OKwTuHuepI+RuBcbxWDkCDhvayp77GNxKplsV1gkYh65l1zlpJiOSOgZp01LJ8FC8Ke8CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwmAPHbajhF2+WsJKbgL8BGX7TdC1AgdDDz7sKWPBfE=;
 b=h4l0YHp7IfGFnuxPsWTWta2NcmctmMOpleq1+2UGkWbKZFrt6aZNqbGBk9FbLj/CN4pFi6hqjU2puHkZEbNqg8hyP7v4NudGmlXSD9xr9yxaP9lFIaAYf0F7MBmC1IhPxPToovbpg/SKayQGCOXrUr9o1U3hM4Se0pboF8xH9Gs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:56 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:56 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/31] staging: wfx: simplify API coherency check
Date:   Fri, 10 Sep 2021 18:04:45 +0200
Message-Id: <20210910160504.1794332-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf480852-6f7e-47d7-48d0-08d97474deed
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB31184769CFD449DCDED7C58F93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIa0RLTpIDLQpUg4NzrHTkfR+o2S7r8Av3obw0DvXZaR6iK3Ix5KVL4q6RQDth5tBzo73Gy3U1wzoBs2LqvsVXiZIAiXxBfQrhRV7oInKF2d6htv7wCHvLShhcST12OSnN9VRquiE/BKyCOnsbeydtXDmnoyDp6bl9qSTBezpddgdLoSr/eqOLDj11op1+Nodltk0nEWtZusiX4dr/yoLZxYWuSVDKxNRaZ2tJ13UYAeqAM/GU3GfNdj8UN3r5n+ihGEpZrTRCwA3gp//MkIVqxRFEbov9tnQBhSqsNaKG+cwkYsSeNZGyiaRS4ZvKWHy57tZ/caCOhKHUMng/5/GN0iROKT5S0I9800H1fCmz2NKjWQ4lqZICLx8mwRnzzwiKWyLTJ9t9KnT92B1YICt3o4XL6B08R1wweK5xaZO4Fw7oSP4atLObwmwTEx+rSXcWWaxP7A3BCPdSwyDUeLdF/xlyYxkOAXCXTV4ik5DI/TaFoMVKt4cAx4v6OjtsgEQokBOMLGxBnhGO5r+mZpfE5lq5EzxDNlOziHc7i7ncP4Ih5lZJmHRL5lZtUAWO/XiyHQCKUmmfbsWb8DzItTEMJGRG8BJozuNd0l79EGxRL9r7NzznApYjafuQ8ULMueiPRrF/Rt/Io1nitS3n0u/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTlYTlRPL0p5RHlVUG52bnFoSnZ5NkdHNERlNzg0aVFWY0h5YXdOcmI4VUc3?=
 =?utf-8?B?S05lWUp2UWY2UEpZKys4dnNtVUFJUHdndTBuS1Y2SWNLQ2VTc08ybVVvS1B5?=
 =?utf-8?B?d2pDREhKWUVCUXJzakpCSXg5NVE5Z2d5N2I5L1h2a0RGYmJ1N2RROVJsbFhQ?=
 =?utf-8?B?RWFUdlhDWGwrOTdqV04vVnhwSHgxRUFZMmFKb1BiWU5KQWN4aEh3d2dxeGZ1?=
 =?utf-8?B?L09rdFU4eGZFTGtNL0xNc0JmbmlzbXBOQTc5MVA4ZGZRUkg1dlMvcDBiS3pr?=
 =?utf-8?B?THFDN1hOakVBd0tiaUJLTWVhUGxQR0cxbnpBb0tjYVRNMGhrZ0s5S25VeS82?=
 =?utf-8?B?bEhoS1g3L0VFbFM2cm1xc3ozT2wwUXA0eGtXT0VFeGI3UWhHNzkyWWVsT3kr?=
 =?utf-8?B?bnJndERISlUyQXdGdURGdlNNZU9TU1ppMHpWemRucVVQaWo5VWpYY2ZvazNU?=
 =?utf-8?B?RFJTSllWdzR2VDZZcWY5R3Rva0FvUVJpOUF0VmFKTHFEd2ErT20vb3VGMWlT?=
 =?utf-8?B?K0dIdndkdCs0NVUxSHVzekRCdXUyaUtKd2NBUDdxSkZPU09mWm0xUERXVW1a?=
 =?utf-8?B?UDlOM2d6ZVlVMnpSZUdMb3B5WHNtb1JWb2pxaW1PUldQSEZYZDdLMnpmakRU?=
 =?utf-8?B?aWhVRmtnMHU5Yy8yOU1SM0tRLzNiLzhXRkFqT3UvTEdBMllHYlp3bEdBamVT?=
 =?utf-8?B?VXN1SzZpQWhGMTllWlNySXNTZTdaZjhRb2hwVkY2TTRpNTNVLzU0eDY5Rmxs?=
 =?utf-8?B?NmNEVHhzT0lTOWl6RDN0V20xY3ZLd2RIaDVOeUVzVmpIQ1crMWI1Z2puMmRi?=
 =?utf-8?B?ckg3SlVsaml0eDhuWHlUM3lJb3haRFV6blFjUGZBclNTOW1tdFZndmVZS2Mw?=
 =?utf-8?B?Z1YzMXp4Z2NmOHhMVFR6TmxucUJ6bEVMSE12c1M1cVU5bnpvcGxPM0NZQXcy?=
 =?utf-8?B?dWV2T1JzUmw5VnhXNGpobHcwdFZJcVdJeThBYnVKa3V6aTFaMnVrUjFqc2F6?=
 =?utf-8?B?NE82K3NJdDRQWEh1RkUwckdxUzZYM2F5dzA2bFNOR2FCaEVFWHUvS2lhSGRh?=
 =?utf-8?B?alg2cjZFdjZNaEROakY1WHg4dk5ubERESlpmalZ4WTY4ajB6VkE4NjdDK2lx?=
 =?utf-8?B?WTJoMWJUa29TWTlISTkxcm1iTTlvZmZDTTJIYXRJZi82bkJabFRuY0pDYits?=
 =?utf-8?B?b1FiK29EWmNQVk9VRGZNTThQTUV4ZVF4ZnIzV1ROSm00SGZ4SFprRlJ4TEFV?=
 =?utf-8?B?V0tsSVZyZm9ZWVFVMXVWTStHQXN2blNlVjlkbDlJZmtXRUlCVm15cHhsdVhi?=
 =?utf-8?B?MElCWUlzSTVDK0t3NDJ3RlFZalZva1U2dHgrbTBQWUl2ZnJPbVFuQ0FsZzBu?=
 =?utf-8?B?THdyWjVwMHVNdTF3Y3RMei83N2R5RGx4a0p3QURWSkVTaXVVMWJ5MlQrTmVT?=
 =?utf-8?B?Rjdsd0hyaHNZZUdFa2xlWCtXenRubGw5L3QyT3pYSlRteG44R0pCYXVQZytL?=
 =?utf-8?B?VjBpL1ViSmRoM3RMYnNuNkEybkJPdm5tMWsxSEFHRVBvWkJqN3RGM29LSnpv?=
 =?utf-8?B?VVEzQ1NIVXFXTUYwSnpDbUpLLzREVDdKMCtUeGtyQ0NNd2k2RkNDZit3OHo3?=
 =?utf-8?B?ZE5kOG9PNVBxMlBNdGZnUHgxRm9KWEtNMVZGTUdSQzE5UVBROEZyMytOK2dy?=
 =?utf-8?B?NG00RFJFZXhQdlVKNEhXQWJrdjNhTEVwUVJlWXdWaTlMVFZ0SHhweVMxcXMv?=
 =?utf-8?B?Rzk0RFRUamgxV09EcnpjZzRWOVNFeDhEaVhINnBYdUdyL1FialNuREZQTXRj?=
 =?utf-8?B?WEhmQUlvd3hQUFNsRVhIT1NTWmhMSStHUmR0T0dGck9FNGkvd1FkcW4rb0dp?=
 =?utf-8?Q?gzF5teVR1/NNV?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf480852-6f7e-47d7-48d0-08d97474deed
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:56.2502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qb7512ayZSS4YqzFq3IZyMd9umjbVYV4U4sVMDSoYxojIW7pivoAPq6ZCSxKMEUJxwByXp0AI9dIh2DxezOpwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
ICdjaGFubmVsJyBhcmd1bWVudCBvZiBoaWZfam9pbigpIHNob3VsZCBuZXZlciBiZSBOVUxMLiBo
aWZfam9pbigpCmRvZXMgbm90IGhhdmUgdGhlIHJlc3BvbnNpYmlsaXR5IHRvIHJlY292ZXIgYnVn
IG9mIGNhbGxlci4gQSBjYWxsIHRvCldBUk4oKSBhdCB0aGUgYmVnaW5uaW5nIG9mIHRoZSBmdW5j
dGlvbiByZW1pbmRzIHRoaXMgY29uc3RyYWludCB0byB0aGUKZGV2ZWxvcGVyLgoKSW4gY3VycmVu
dCBjb2RlLCBpZiB0aGUgYXJndW1lbnQgY2hhbm5lbCBpcyBOVUxMLCBtZW1vcnkgbGVha3MuIFRo
ZSBuZXcKY29kZSBqdXN0IGVtaXQgYSB3YXJuaW5nIGFuZCBkb2VzIG5vdCBnaXZlIHRoZSBpbGx1
c2lvbiB0aGF0IGl0IGlzCnN1cHBvcnRlZCAoYW5kIGluZGVlZCBhIE9vcHMgd2lsbCBwcm9iYWJs
eSByYWlzZSBhIGZldyBsaW5lcyBiZWxvdykuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguYyB8IDMgKy0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXggMTRiN2UwNDc5MTZlLi42ZmZiYWUzMjAy
OGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYwpAQCAtMjk5LDEwICsyOTksOSBAQCBpbnQgaGlmX2pvaW4o
c3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNv
bmYsCiAKIAlXQVJOX09OKCFjb25mLT5iZWFjb25faW50KTsKIAlXQVJOX09OKCFjb25mLT5iYXNp
Y19yYXRlcyk7CisJV0FSTl9PTighY2hhbm5lbCk7CiAJV0FSTl9PTihzaXplb2YoYm9keS0+c3Np
ZCkgPCBzc2lkbGVuKTsKIAlXQVJOKCFjb25mLT5pYnNzX2pvaW5lZCAmJiAhc3NpZGxlbiwgImpv
aW5pbmcgYW4gdW5rbm93biBCU1MiKTsKLQlpZiAoV0FSTl9PTighY2hhbm5lbCkpCi0JCXJldHVy
biAtRUlOVkFMOwogCWlmICghaGlmKQogCQlyZXR1cm4gLUVOT01FTTsKIAlib2R5LT5pbmZyYXN0
cnVjdHVyZV9ic3NfbW9kZSA9ICFjb25mLT5pYnNzX2pvaW5lZDsKLS0gCjIuMzMuMAoK
