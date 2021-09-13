Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFD408B85
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhIMNDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:03:43 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:19681
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237853AbhIMNDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:03:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIJ8/r6Dfopq1NexW056kxnr+fquFXRQzEoBg+286Ym4DyXPM2t2KDAUL+2HK1ZzSBvVTVV00vROXQACwWd7DMD6q5vPRcl2hCVAVbhqKuHJba/kOsQs7lFDNyLovVLf/++UhdX7TOSoXurbQaGt4YwczT5JwUjyQFPOkxbf10zvL/oazwpQfWVmwPQOnqElUUvDmKIXAAeGEI+hEWin6FQFLCqJ6ro/joBwlFa8M7PfGaIGAmjZgrG0RXfTzuMEzbNY69LXotOagHsJgrS4rcZS48c36WiNhrjTwwvCdB1n8vSGyuBbw6rymY0kcPgnJm4rTetBK1Rg0sDgTUVtUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3TsJ441Hxc5w6kwdECytocZuGWRAv1M22Qp1aIMK6mk=;
 b=bqA54d6IiNnnKkbFlMsuczZgBXGyy6vO4f3aK92asQ1zmzzSLJRXHg2zK3fnSqoDmlbEGqS7Zg10lGT2AYFJjdeE+Mh5sn6/yaBeq7cI0ZtKUnc3/m/LMpka9eE6nloqIlxDjtSeROZfY0ARmHPwuLespJTug+fON7rf2sZls4ftB1Ff1dTStU60J8X7/cZB8n1rT3IIwmcaZqUAfC8YCIOkpgpL1qosjnx7x0ykD6m5qe0BYYV9OEXh1WuiKlnpjDAWtyK/jNBsFH7mFWHinm8Qd8kEDHiHU+ysA2qeIgBW/MyjksEC+SSGwqNtUKwblb3MrfR/9OOkS5/RVeVLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TsJ441Hxc5w6kwdECytocZuGWRAv1M22Qp1aIMK6mk=;
 b=BJQNdJOG1204LmyCD9MdvTkImXfFb5hE8gGKIht1CDf/DgywQuDxlykrLe67KjjWoHgy6kNHzekofmdITSlAaYlMN4Pj+B0ToECYOVwHVDq/DWnMDCk0I7p7CJJqdqpUHDkrq40RFe1NdLYjNFuuMjU2PHjftUsEd2j90EEC0Fs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2894.namprd11.prod.outlook.com (2603:10b6:805:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 13:02:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 02/32] staging: wfx: do not send CAB while scanning
Date:   Mon, 13 Sep 2021 15:01:33 +0200
Message-Id: <20210913130203.1903622-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07448c20-2f45-463d-f1d2-08d976b6b8bb
X-MS-TrafficTypeDiagnostic: SN6PR11MB2894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB28942CE8AA2584DB310F659593D99@SN6PR11MB2894.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 959H5TAnBCnDSq+dN6pEyuJRb5rdeaswWZGgaJIthrg6SK30PVF51TZvB2EphAoHOC1aJdZoIyPvSYfXXAllBV2USdAvugIfmdhALk6ONxNPnH0pWFZqx26DqLn0F8tRBg3c2idq70bh0k+8/0pslm/F+MjatuLhQPPt1U+nzMwxevpKUOUpDtnQwnjq3EECxmDTgsLexYKHNWUIKe1uSRF+Nm85XMFRSstao+PwQDEUwT6vcd7Wm2e8+LKu68uJxJQreZapqUbvdTSaVPF2ycWoPPWY7Jwv9nk5X6vStkmDWGPN8P1YfU0EOgArhSzhV+618aq6eyPZWZJWhkLNomIVaVTqe1O/pxM8bv5d6S5dl05nci6/0pSnUwCwv/Etz5OcJXXZNEyPZQrviaO/577NJXOQQxwriHCXtH5RGsPcpBfMe5as1mac7Ufx93zQicHosWCG4gQQez5b/eENV1UcVHCIOdvFyGXz9eRu0JYH+r8/Z3ZR7ytQURHZrJs29IkBHG31+IgnXITUrFXFinaTvimuFJ2QhB6DYuxenUJCk2ye9Mzi2tToqm8hS0EkUl6kYvF00HZilRuuhfKU5tSDfSKS2qaKABZnkDfOpPtlQw06EhrioBkn0ZDTEyc45JidoXkmgVC0MPZDFYNiSj9GZnqQk5nYl3GZE88zKxIA+GvgAZ5yqYMDtw1wG5p+KOvFgKGFLj3DpfdNVk3ryQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39850400004)(346002)(376002)(5660300002)(26005)(8936002)(6486002)(38350700002)(38100700002)(66946007)(7696005)(186003)(316002)(1076003)(8676002)(956004)(478600001)(2616005)(2906002)(52116002)(4326008)(36756003)(6666004)(54906003)(83380400001)(107886003)(66476007)(66556008)(86362001)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEZQUVJrUnFvQXNNdFBONGpGNG1hNUhlMWJmSWpJd25uVml3OFByODNrUENh?=
 =?utf-8?B?Y0p4aGpaYU1IRHpXcyt0WVI2MGJpZ05IejVSL29ZdG5saDBERmMzQ2VaVEt2?=
 =?utf-8?B?UUhUc2grci9UaFM0R1RzMG41QVJ6Z25Ea3E3Q1l2NER2QlRVbzIrUHZxakJJ?=
 =?utf-8?B?TGlmbmpmMGVJblBoOUwweGpMYXRIZExaK2lZU3ZScVZuejlpczVGbTczbUdy?=
 =?utf-8?B?aVhXN1VtMkJxWjU0UjYwMnJKdmozbFNnZXVXbFN4WjBqQi9rRENrNDVVWFpW?=
 =?utf-8?B?MFA3L3RTZ0hJVVUxZUtpcWN6VE1zNmFTY1Y2YVV4ZUtqaHFCNEJ3bzQrSW9y?=
 =?utf-8?B?M1RyV1g5Y1NXYVN2N2NwcS9xWFpJQ0VOS3I1SVBhN0FsRXlsbGY2bituYUgz?=
 =?utf-8?B?QzM3QlBWZ3RWS3VLZGpDb2hWRG9iMWtOWmdpQjJNYyszUVdvSm56OTQwendz?=
 =?utf-8?B?WHhuajZwdHpvUUM3SUl1OTIzMDE2ZVRDTWpid1U0eGhSN1NiQk02VXExS3lr?=
 =?utf-8?B?cUcvZDZpaXhxVEpUVHplRDhxUUVUOC9jS2pEUHAvNXdKNm5ESWkvZmVCaE9K?=
 =?utf-8?B?cEI4VVJNMGh5M1oyM2NONDBaYzJqbytQdmliUHdBQnRnSWhHRThzaTh2ZlYv?=
 =?utf-8?B?R211QWFYd1o0ZkF4Z095MzR0NW9UOWRxNWppWm9oT2RkU1lwT1BBMXVtRlZ3?=
 =?utf-8?B?amtUYm5panNuODZndTVJR1RuTi9BcUVMb2ZIVis3WGpwb0daRk9sWlgxcVNq?=
 =?utf-8?B?Z0xLNE5JMWl6ejdYVlR1U1ZoNnl0MzV0eGhoZVNJTk9ycEdEWlQwNkxWVEZV?=
 =?utf-8?B?YnMvY1Zhd2dHZUk4eCtHc1FkL1dYWHFOMmVuVTRRQXJObFRSUmxWWWk3VGFI?=
 =?utf-8?B?TkxvSU02YUIvN0g0ZnZMbGRVUEYxdHQreUVqZlhPKy8rM1RCODVtWmliV2F1?=
 =?utf-8?B?ZEZ5ZVVaTmI0OXB6blNlcUJxQzdIazZJRFBVazFLUXAxOXNBWmhUVVhkRDA3?=
 =?utf-8?B?dk1qT2V2dG83KzREVitxeW4xTENBKzVEeVg4MFU4Q2ZsNG1TdEdUZnZOREty?=
 =?utf-8?B?L28vOVMzODJEZCtjV1B6ZjJqSHEzRUFoUEFDczBWbTdLdC93K2JPMlU0M0xy?=
 =?utf-8?B?M1dudzNsZHdQRko3ZmplWDhzUnpJaXo4VEE0cjZiV1RCTThzeStCWi9USEdh?=
 =?utf-8?B?WUVORk81c3QvL3RxNXJ2QXdQaXFJZmhVUUF6aHVIVjJWdXpmMjB5WjdaYVgr?=
 =?utf-8?B?OGJEdXYweFhnWStWdGk5cmpDcnBOb2xVaGxhQjZLd1FBMkJsaUxKM2ZEd0lr?=
 =?utf-8?B?R2FEYmVPb3hTZGp6UVhYd09wbStPN2FjOGF0NDRnVmFkVk1FeXdqNk05OTVD?=
 =?utf-8?B?SllQdUt3QmlxS0hFcnNMR1RZZDJoSlBrQkhSY3VxUHhFYzdldnFYWGh4Z0gx?=
 =?utf-8?B?ejZCRnFJNS83KzhCRldzeUNBQ0ZXTVkvejJ5ak4rekVWZWc5S0FISlI4bWhl?=
 =?utf-8?B?eDIrd3FtME5NTlpoRGVBZXZsdFRWc2dlek5BUUl1RGtIRHJSVHBrQXN0SlRy?=
 =?utf-8?B?YlJnQXQyQ01uTElZZzN0Y3htV3czNEp2SWFvZ1lubHJ6TUtqZ3ZOYlptWlhG?=
 =?utf-8?B?L3dUZE1sS2N6LzhmV2JBWENURHkyVUpoS2l6d09DV0g5aWVScTEzSzFzemJM?=
 =?utf-8?B?OWJJRm9YanQ4eWFPUXh1ampNOThTWFA0bWFvUi9HZEVMb3BnTE9uRzNoTXor?=
 =?utf-8?Q?HAxzxeNNZUEAwnAeN1HuJrWlJeoJy0FQKko8fAp?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07448c20-2f45-463d-f1d2-08d976b6b8bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:20.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAOhaiKqQ7P9Ua9JjOSsaBH5SmxCGBuQfqfVoiJhTIoyK82JvorGExxllEyRdU7pudQQrNlYHGQHdLYxRxQ8vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2894
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRHVy
aW5nIHRoZSBzY2FuIHJlcXVlc3RzLCB0aGUgVHggdHJhZmZpYyBpcyBzdXNwZW5kZWQuIFRoaXMg
bG9jayBpcwpzaGFyZWQgYnkgYWxsIHRoZSBuZXR3b3JrIGludGVyZmFjZXMuIFNvLCBhIHNjYW4g
cmVxdWVzdCBvbiBvbmUKaW50ZXJmYWNlIHdpbGwgYmxvY2sgdGhlIHRyYWZmaWMgb24gYSBzZWNv
bmQgaW50ZXJmYWNlLiBUaGlzIGNhdXNlcwp0cm91YmxlIHdoZW4gdGhlIHF1ZXVlZCB0cmFmZmlj
IGNvbnRhaW5zIENBQiAoQ29udGVudCBBZnRlciBEVElNIEJlYWNvbikKc2luY2UgdGhpcyB0cmFm
ZmljIGNhbm5vdCBiZSBkZWxheWVkLgoKSXQgY291bGQgYmUgcG9zc2libGUgdG8gbWFrZSB0aGUg
bG9jayBsb2NhbCB0byBlYWNoIGludGVyZmFjZS4gQnV0IEl0CndvdWxkIG9ubHkgcHVzaCB0aGUg
cHJvYmxlbSBmdXJ0aGVyLiBUaGUgZGV2aWNlIHdvbid0IGJlIGFibGUgdG8gc2VuZAp0aGUgQ0FC
IGJlZm9yZSB0aGUgZW5kIG9mIHRoZSBzY2FuLgoKU28sIHRoaXMgcGF0Y2gganVzdCBpZ25vcmUg
dGhlIERUSU0gaW5kaWNhdGlvbiB3aGVuIGEgc2NhbiBpcyBpbgpwcm9ncmVzcy4gVGhlIGZpcm13
YXJlIHdpbGwgc2VuZCBhbm90aGVyIGluZGljYXRpb24gb24gdGhlIG5leHQgRFRJTSBhbmQKdGhp
cyB0aW1lIHRoZSBzeXN0ZW0gd2lsbCBiZSBhYmxlIHRvIHNlbmQgdGhlIHRyYWZmaWMganVzdCBi
ZWhpbmQgdGhlCmJlYWNvbi4KClRoZSBvbmx5IGRyYXdiYWNrIG9mIHRoaXMgc29sdXRpb24gaXMg
dGhhdCB0aGUgc3RhdGlvbnMgY29ubmVjdGVkIHRvCnRoZSBBUCB3aWxsIHdhaXQgZm9yIHRyYWZm
aWMgYWZ0ZXIgdGhlIERUSU0gZm9yIG5vdGhpbmcuIEJ1dCBzaW5jZSB0aGUKY2FzZSBpcyByZWFs
bHkgcmFyZSBpdCBpcyBub3QgYSBiaWcgZGVhbC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMTEgKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKaW5kZXggYTIzNmU1YmI2OTE0Li41ZGU5Y2NmMDIyODUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYwpAQCAtNjI5LDggKzYyOSwxOSBAQCBpbnQgd2Z4X3NldF90aW0oc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsIGJvb2wgc2V0KQogCiB2b2lkIHdm
eF9zdXNwZW5kX3Jlc3VtZV9tYyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgZW51bSBzdGFfbm90aWZ5
X2NtZCBub3RpZnlfY21kKQogeworCXN0cnVjdCB3ZnhfdmlmICp3dmlmX2l0OworCiAJaWYgKG5v
dGlmeV9jbWQgIT0gU1RBX05PVElGWV9BV0FLRSkKIAkJcmV0dXJuOworCisJLyogRGV2aWNlIHdv
bid0IGJlIGFibGUgdG8gaG9ub3IgQ0FCIGlmIGEgc2NhbiBpcyBpbiBwcm9ncmVzcyBvbiBhbnkK
KwkgKiBpbnRlcmZhY2UuIFByZWZlciB0byBza2lwIHRoaXMgRFRJTSBhbmQgd2FpdCBmb3IgdGhl
IG5leHQgb25lLgorCSAqLworCXd2aWZfaXQgPSBOVUxMOworCXdoaWxlICgod3ZpZl9pdCA9IHd2
aWZfaXRlcmF0ZSh3dmlmLT53ZGV2LCB3dmlmX2l0KSkgIT0gTlVMTCkKKwkJaWYgKG11dGV4X2lz
X2xvY2tlZCgmd3ZpZl9pdC0+c2Nhbl9sb2NrKSkKKwkJCXJldHVybjsKKwogCWlmICghd2Z4X3R4
X3F1ZXVlc19oYXNfY2FiKHd2aWYpIHx8IHd2aWYtPmFmdGVyX2R0aW1fdHhfYWxsb3dlZCkKIAkJ
ZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LCAiaW5jb3JyZWN0IHNlcXVlbmNlICglZCBDQUIgaW4g
cXVldWUpIiwKIAkJCSB3ZnhfdHhfcXVldWVzX2hhc19jYWIod3ZpZikpOwotLSAKMi4zMy4wCgo=
