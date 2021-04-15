Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9939B360F4F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhDOPrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:47:47 -0400
Received: from mail-eopbgr760098.outbound.protection.outlook.com ([40.107.76.98]:14662
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233518AbhDOPrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 11:47:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRyHRzz9fa/phTdL5iKRs55Hzno9hs4BgFm0WVht+7OkKc7tyPZFLWG117mPvZjC3nJFGkRG8o7+gFRNSHEv+78KOPl1T1jNpnal6jwnqJs2bKD16c0Dpq78DBH4bCDNAjK/VPesSiOsRo6Bg4P+PbP11vgLUA73Zy3hDRK/U9N7CRHYNmPqwAtqowjka06NTh4+yHyWUjeaVF9UkaH/CmINvObLdh8gijzXcvB680mFVC5HHsU3RBZxFW9HlNsyBMUglI3ngVVu++pVEKGw6GI8MpjNINVRW4rYTIW13fThNjeBT4oqo7pQVGQjVcfU2rAJ/XDK74KqfLPZhd/VmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9wOH05nckNChEhVnt+i67BKp+Y/HSijFJgkdRsFaoQ=;
 b=J/gVI9VXlTdiQspO0D2pnckWEjeAEndUmRj8jqnJzTJgEvma47QrYB7zpmv5G+qWT7Pfe7yE+Gu1q7GM0QfoA2G+2BM0YfJrPNc3kXNAV4RONryBmGHhOS9dfneBWnTxKzmC3AXauDqcUP6rS52K1sFh/Ph7WaHENFt2s8X9Gc412PMEY1HP/nbGS1Z4fhPRsTzP0MPA5+16tzmjLMDia+ruKeqnCt+Fro+2oLtci6fsC5ICskj1tQgqg0nfWXgHL7DUxu+ULyJ2YYLy6AFeyijca85hf07pbahK7U+hf0DFdo9zy817D9URJFXK0mvWa22nj/owh5H8R8GJlNkZjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9wOH05nckNChEhVnt+i67BKp+Y/HSijFJgkdRsFaoQ=;
 b=p/lzVq4UXAJ3Tow7J6e0+2Uxkp3rzCRQeLt1BqA3/FK+//wCTltJHzoSqV7G46qwwS68sroHYU3GILzKtslV5m1YPqSKVy1WGC1uLkMHlC/GXboln18Qs596UVYD67/SwgUQ3SljLOpw6GKPYbIvJcQL4KE/U3NJDleGR/582wU=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1878.namprd22.prod.outlook.com (2603:10b6:610:8c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 15 Apr
 2021 15:47:21 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f%5]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 15:47:21 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PROBLEM] a data race between tcp_set_default_congestion_control()
 and tcp_set_congestion_control()
Thread-Topic: [PROBLEM] a data race between
 tcp_set_default_congestion_control() and tcp_set_congestion_control()
Thread-Index: AQHXMg6fONH72Y/f+kCKC7WPm5facA==
Date:   Thu, 15 Apr 2021 15:47:21 +0000
Message-ID: <A63CB783-F5AF-419A-89B9-3755E6896D41@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e98dc2bc-a54d-4535-c355-08d90025c210
x-ms-traffictypediagnostic: CH2PR22MB1878:
x-microsoft-antispam-prvs: <CH2PR22MB187861401204F3B3279B5268DF4D9@CH2PR22MB1878.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HzAZht/XyticYswA3eBy0FtXYN0W41zKZjSTwK3Kdc3EC+PheeGP+aqw1keX6Qj0/Lp8Fy26OkQrrIYH+0uwOboMEWYuBsaF6Cp6ZrzToMUF2fbkLOu0oOMIWFopOsaZYSs8U+SGIXOZLZSthpw3BObJGFJus6zz91VqtgeIE302xDNLnkYC1SASpVFn3Z1W0vgkVjVcmrZ+eb1HZYZ8ysFpVDka1gn+myVSpkJ+Th6bVnTkms13cKMkhP5Mt6gRYEbvTS+J9mNpR8omElyAJBae+L1jFyVfU8W78wrzIjaR/oN6jtpx5lbz4RscS5tKJjURPcTGB9ApsjOpTXNnJ5c3y/yiUyYdRbXJqXcVzrY9HTUmvxDPDI1iu0RKfJLhdKeDw2beCRxjnfeorpi21AUCtAY5OOJYsYM2H3Nni/gOpa9oXaSb90qJeRPjggYSciSj0TSQkMJzzfqGDOfeOdV43cPYDEU5kTzAGk7vDaLDcwdC0y2ODqckQWJc53Ncp4YiL2GqTMdGYA0Dd4cI4DHwZczoJTvHnNJ8v0EfhMx8vuAiQHFyYH5C14JGzsyz5NqNbjcagt9PU1NfwVzguVGlL8BE6KJkwQl+6wA9+1QNjNZUFSB/a+8PayEKIcVvANgCCGWVK0pqYT/gHralhnn5wgCpgbprkNFxq8fPD7A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(376002)(39860400002)(2616005)(38100700002)(86362001)(4326008)(75432002)(83380400001)(5660300002)(66476007)(186003)(66446008)(66946007)(54906003)(6486002)(122000001)(8936002)(478600001)(8676002)(26005)(6506007)(66556008)(33656002)(786003)(316002)(76116006)(64756008)(36756003)(71200400001)(110136005)(2906002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RitmT0IybHBnVGRnNVN1Ly9YVnR0TFBudExTTVh0QzdzNkNFeFc1YlJWNHd6?=
 =?utf-8?B?UC9KOXBYS3VFZ3F5MWthd0E2ZGdzMm44RGZFdzBNRTVKS2l5VHJWSDY0S3B4?=
 =?utf-8?B?NGZkVjhnakdLa3d3dXhHclVxRXBseTFLK2czUGRhenhjTmpvV3ZNaEJWY1Vn?=
 =?utf-8?B?SG9kTHdwQWpFY0o4NFlTdkNqUU4yejBZbDY4L3ZHTnV5bHEvdzkrNnF5V24y?=
 =?utf-8?B?Y3hZYWVRK3JZdHF6MTF5WmR0S3Y3RmJLcXZWclIxWWhOaHVXR2VlM2MrMzBE?=
 =?utf-8?B?TThmWTRhYll1ZmdleUpWMjBVdjhGVnFOWHlYUUc1Kzk5ZmZ0V0xFbUNEbjZ4?=
 =?utf-8?B?VkZJQ2dTNG1IdHJSd0NZeXdUbTFaMytFT0w4UlRZdW5OVmtoRE1VVHFlOE02?=
 =?utf-8?B?S3JkUlNPSXRNZ1Rxa1IvbGdxZUwrbDQvZ3BwWmZ5S3pHS3ptdUYxbkdHRGs4?=
 =?utf-8?B?OXdiL3JaZ3hzaWxRTUF2Y011UVRiWVJhb2ZZcnAyRWtTK256UFduNVBObjQy?=
 =?utf-8?B?Z0FoRStRTFFsbDNJTE9TTkIvNmU3c0pPUnBZMXFVODJOZjRGWHNkeExQNFV6?=
 =?utf-8?B?aWhESHE4U0NjbTMzSWg3TlpCRmhSWUlZWVdJekwzbUR2d0VwSnlUaE5nTi9V?=
 =?utf-8?B?ckF2UU9xQ0RhWURVc01LWXJwTEJPaGJJV1pWNUZ0cHUyYnZtUjEyYXhvZDFl?=
 =?utf-8?B?Rk9pOTE1SlhMYk1HcUhSK0ZDdkdWcldwbHpCUjBvcHBlT2V2N2UzTjBTVTRy?=
 =?utf-8?B?YmFERml2cUJIR3NPRDlkUHNqdnpyME1wdHl6OTlSTTNVeEloMWNieldUYWJG?=
 =?utf-8?B?d1VjRHRzSEY2UUM4ODA3TjZZRTRDNmxUbCtsYlZEaGJQZitKcFNzUFNyZmVq?=
 =?utf-8?B?OWRXbGp1dk9lSWVER3EyK2JrejdrQ3d1WWNzeUpKMUwvWUZ2bHg4UDNOTGpz?=
 =?utf-8?B?dFNDWGtLaSs1MmV2ZGt5VXhCSWNqd1hsSzZWN05xMGgwdUMzaUs0OVMycnl0?=
 =?utf-8?B?VVd6YTJaY1AyUkVXc3FPTXJsZi9HRDlhYW1zVldrQ0Z1TTZ3QWtoVUxyMHpO?=
 =?utf-8?B?bGN2MGJBeHRCOXFqNzcvS3gyRlNGVUdkdlRXZndjeGw1L2g3bWgrR1FUYWxl?=
 =?utf-8?B?WGFaWmR2S3VWQlp2NDl5Vi9EY0FPSlF1TEM1ajJnQUFyRlN0eHRqL2hCK2Ev?=
 =?utf-8?B?WlBnK3N2RjZyeTFpM0xXRHoxa0g4YXkrYVdQR3ZMZjljODEvTzljUXVtamxO?=
 =?utf-8?B?U2QwZE9iQW04WXdob3ZoaTdWMFdsbERTRCtyN0JKYW8wUEdBbHl1czkvRzZq?=
 =?utf-8?B?VFRGSVNkcXE4NGVDMzVXRmFqMTB6TkxtakFMWWFYMXFvVFFCWkxhU2Z1Yk1S?=
 =?utf-8?B?QUk0YjI3UGgxNTluM0Q1L1Zjc1cwT24xQzlKQWNpUU1hbHNNOGQ3MzUzdDFp?=
 =?utf-8?B?NzNUT205SkpiUjlRU1pNWUR4QThlU2pOQk5xcGRFTmxtSE5xRm9TNGhmdm51?=
 =?utf-8?B?YVF5M2llaEVFSUFGckw1THFSV2lsYXVSYm1BLzVDa2xqY2dXTVhqV3llUW5i?=
 =?utf-8?B?L1JRbE1LS08vZHM4eGVldXBXQzQ5RmRSL3VBSlVUOFZuUWRLeURyQ1RLQ1Nv?=
 =?utf-8?B?b0lqcERFeXBDZkcyRFVMRW1VUmVBcE03bDVoaWZja242RFp2T05naWk0NTJn?=
 =?utf-8?B?bUFUajBxZ0RtOWNRdUowVFlpNkJ4WlFvcVNyOFBNVkJic2NwR3dyM1VVZG9I?=
 =?utf-8?Q?6HboNXtiRlyR1d9koimIV+FpM+7OKhYMo0bkFIk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9BBC204F4421444BEB98BC104BF7FC6@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98dc2bc-a54d-4535-c355-08d90025c210
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 15:47:21.7601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8rNHYl5kVPdANnpn/XAU2VwgaOdAeQ0Ikoy7ySpdC/cMQ867jM9mgQd0QgeSD6WCYy/AGI5Y7QCCZViPVPWaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1878
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldlIGZvdW5kIGEgZGF0YSByYWNlIGJldHdlZW4gdGNwX3NldF9kZWZhdWx0X2Nvbmdl
c3Rpb25fY29udHJvbCgpIGFuZCB0Y3Bfc2V0X2Nvbmdlc3Rpb25fY29udHJvbCgpIGluIGxpbnV4
LTUuMTItcmMzLiANCkluIGdlbmVyYWwsIHdoZW4gdGNwX3NldF9jb25nZXN0aW9uX2NvbnRyb2wo
KSBpcyByZWFkaW5nIGNhLT5mbGFncyB3aXRoIGEgbG9jayBncmFiYmVkLCB0Y3Bfc2V0X2RlZmF1
bHRfY29uZ2VzdGlvbl9jb250cm9sKCkgDQptYXkgYmUgdXBkYXRpbmcgY2EtPmZsYWdzIGF0IHRo
ZSBzYW1lIHRpbWUsIGFzIHNob3duIGJlbG93Lg0KDQpXaGVuIHRoZSB3cml0ZXIgYW5kIHJlYWRl
ciBhcmUgcnVubmluZyBwYXJhbGxlbCwgdGNwX3NldF9jb25nZXN0aW9uX2NvbnRyb2woKeKAmXMg
Y29udHJvbCBmbG93IA0KbWlnaHQgYmUgbm9uLWRldGVybWluaXN0aWMsIGVpdGhlciByZXR1cm5p
bmcgYSAtRVBFUk0gb3IgY2FsbGluZyB0Y3BfcmVpbml0X2Nvbmdlc3Rpb25fY29udHJvbCgpLg0K
DQpXZSBhbHNvIG5vdGljZSBpbiB0Y3Bfc2V0X2FsbG93ZWRfY29uZ2VzdGlvbl9jb250cm9sKCks
IHRoZSB3cml0ZSB0byBjYS0+ZmxhZ3MgaXMgcHJvdGVjdGVkIGJ5IHRjcF9jb25nX2xpc3RfbG9j
aywNCnNvIHdlIHdhbnQgdG8gcG9pbnQgaXQgb3V0IGluIGNhc2UgdGhlIGRhdGEgcmFjZSBpcyB1
bmV4cGVjdGVkLg0KDQpUaHJlYWQgMQkJCQkJCQlUaHJlYWQgMg0KLy90Y3Bfc2V0X2RlZmF1bHRf
Y29uZ2VzdGlvbl9jb250cm9sKCkJLy90Y3Bfc2V0X2Nvbmdlc3Rpb25fY29udHJvbCgpDQoJCQkJ
CQkJCS8vIGxvY2tfc29jaygpIGdyYWJiZWQNCgkJCQkJCQkJaWYgKCEoKGNhLT5mbGFncyAmIFRD
UF9DT05HX05PTl9SRVNUUklDVEVEKSB8fCBjYXBfbmV0X2FkbWluKSkNCgkJCQkJCQkJCWVyciA9
IC1FUEVSTTsNCgkJCQkJCQkJZWxzZSBpZiAoIWJwZl90cnlfbW9kdWxlX2dldChjYSwgY2EtPm93
bmVyKSkNCgkJCQkJCQkJCWVyciA9IC1FQlVTWTsNCgkJCQkJCQkJZWxzZQ0KCQkJCQkJCQkJdGNw
X3JlaW5pdF9jb25nZXN0aW9uX2NvbnRyb2woc2ssIGNhKTsNCmNhLT5mbGFncyB8PSBUQ1BfQ09O
R19OT05fUkVTVFJJQ1RFRDsNCgkNCg0KDQpUaGFua3MsDQpTaXNodWFpDQoNCg==
