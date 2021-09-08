Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2341E403307
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 05:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347426AbhIHDmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 23:42:10 -0400
Received: from mail-dm6nam11on2101.outbound.protection.outlook.com ([40.107.223.101]:35712
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347576AbhIHDmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 23:42:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBKmH2fewsvuCiUkPX59YRUi8Rm6VP6ioUBaYS3ErwaVIOdyhlvddjFaro0W/FUxwlS6MPnCGG7yMb3fXcnlcGdMjnRENUPViLIN/6WMarAolOvEFd5pt0Uo5NycAVOwshX/GOP/heFXtUX/F0du/f1Lboltag3VyEXR6rHF4jGSVfMnEAu6cuHcGx2+KGNPGn91qIfAuxphhh1Ime2iHXR4ot3T08mF/6RMoLEUD7OIpLkKgGfCOtOuvpwD1UObEWby28EsDkX4iFuxLzNWfg6KN2TfYPUN56Wf5xKZyzcTmTFdnZ+CXWfvZoapIhsk97OjeRSsO1EBX/JDvzKA/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Z2mvPl1AmJ+4j6VqKfNdoxTkWO5yJ/4YrPXN+oGfLzI=;
 b=X+gTHhd/znnqxj2ZnNMq7WTVHIHYhAWWYoAgRK+Pl2tEHsIGyDZ+u+msajTjECXQAZXlWSjhBzhiIP7igg/1WpthIvRuG9NtYt0bJp7djFEMPdn1ITBIMA3q6eyIWHfwLZA2yN2EObkgNgOG5J4e4XtHOdf2Bi0EiD/Ltded+xADkuOoUK/bFB9pODshhybM3jU7sDmDbHG+8Kx5EjSK1LpwBTx0QRFK7kug/kaJP2LfQub6B7cUVbHEbLr0QVJuhoUuPA7R/fA8WHfXu2lVQ58MM9iaEDcVxpUJgJmXMrJFzSvc/luXaUiCg7HLFCl0syeEH9A+ijqRCcxFzwgZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=psu.edu; dmarc=pass action=none header.from=psu.edu; dkim=pass
 header.d=psu.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=psu.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2mvPl1AmJ+4j6VqKfNdoxTkWO5yJ/4YrPXN+oGfLzI=;
 b=AO5EBgdz8+nAL5Cn4JmLQM/uaRrrgtu1PZGkFVJR3ScynCHHUqXDfEAxUhH6wZ1gqDxhpHDr/YGiU+Rh4HaoLiNLVWPZGvwbo1Dvr8zI2NXYiTTaxzWWfc3CJFgSN4meQttt4ngtck30myWoyuVMdTa2jCR3e+zNOgYKZYLgEI0=
Received: from BL0PR02MB4370.namprd02.prod.outlook.com (2603:10b6:208:42::31)
 by BL0PR02MB4772.namprd02.prod.outlook.com (2603:10b6:208:52::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 03:40:59 +0000
Received: from BL0PR02MB4370.namprd02.prod.outlook.com
 ([fe80::40fc:3ab5:8af7:7673]) by BL0PR02MB4370.namprd02.prod.outlook.com
 ([fe80::40fc:3ab5:8af7:7673%7]) with mapi id 15.20.4478.025; Wed, 8 Sep 2021
 03:40:59 +0000
From:   "Lin, Zhenpeng" <zplin@psu.edu>
To:     "Lin, Zhenpeng" <zplin@psu.edu>
CC:     "<dccp@vger.kernel.org>," <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org ," <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org ," <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net ," <davem@davemloft.net>,
        "kuba@kernel.org ," <kuba@kernel.org>,
        "alexey.kodanev@oracle.com" <alexey.kodanev@oracle.com>
Subject: [PATCH] dccp: don't duplicate ccid when cloning dccp sock
Thread-Topic: [PATCH] dccp: don't duplicate ccid when cloning dccp sock
Thread-Index: AQHXpGNWiO2TW5YFkEOix90IJpmn9Q==
Date:   Wed, 8 Sep 2021 03:40:59 +0000
Message-ID: <F3E0B9C9-14F1-43F5-AC6C-E5DB346A8090@psu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: psu.edu; dkim=none (message not signed)
 header.d=none;psu.edu; dmarc=none action=none header.from=psu.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 411402a6-1ce5-419b-3196-08d9727a7944
x-ms-traffictypediagnostic: BL0PR02MB4772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB4772A77B7236A40DF2E085C0B7D49@BL0PR02MB4772.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lELqEBOpaGohbgIZ1PyNIgwxV7F0sMDx/PsXNRKq3AxjiVzrmjbA0H6r5UraZeh+KhN413O2fdXiWlxLpdSvzmBLXy65G3p8r4g4/NpMCIMUy6q0ApHyemlC+ntEFbe8aqwZOb6Em3MK+LEB2GKcQP5lDO+XmdbIxpvjbS8bcsMmMtsisRNJOV4qaRKmTpc9VCHFdcOb0HjAc5lx9+v+1k9hLRWq0jwOzA3PvmLp0uAfDkfWLbeZ9xGlCwN2UbZlbKqIEHJ9qV+Hpfqnm/9Drw/bUZLUz7jAXseQCCKSGrSvKPavTBOtPfthNRuGTdHmjw0EggJm/8sDSelBDl2pY6HyRnXVRDNq6CSuYKuaV1hWqRlXN/wwhodVEXu20gQswxiWQR3dojE4TV1JVZx9wgiXTwHIU+lM06TCkKbMASqcwanLnAkDOXINCAP6pHHzLIA59OhXVjQxUuhmXtP5ClIm+dmuQdgwDwZM6lLkS1wi5Hb2PpWgDV70UccZEafm1yG9FMmU10AtAuE6o/6NtSsEcy6o7Z3lq2sQk9FpUZO0DIfNZhW1G/M7WVc044fsRSr0Dm1Z2CvJSf84V2XfDyrrO2kTdj82wQs25ecAZmvwrYjUFVHA6xp8IF74Do3ElcTK6QPgIov5qZm9w3uQu5nBgfnpVG9urvVlsVhhC4XhpFqAf8d3D+mmrvdJoG6QP64b/MxmwFIT6RQOW7/foLMR6iC6cjGHYOQecFOcqDAFb3KGj7LVbi4vwEeSKuTr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4370.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(136003)(346002)(366004)(396003)(2906002)(75432002)(6200100001)(33656002)(66476007)(66446008)(4326008)(64756008)(8676002)(2616005)(66556008)(66946007)(38070700005)(26005)(54906003)(71200400001)(37006003)(316002)(8936002)(5660300002)(6862004)(76116006)(186003)(478600001)(36756003)(86362001)(6506007)(38100700002)(122000001)(6486002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VURCR1RiVjA1cm1UMXNVaWQ3cGR6RmhoY3BtMnhXbE5UTW4vODhHS1ZTbjJB?=
 =?utf-8?B?cUFYbTdmcGZmWUp3TDluU2k1ZzBDQVZ1R1Bpb3NVc29qSnF0Yk9JbmVYZXVz?=
 =?utf-8?B?VVczTXlkelEvQ3RWNmQ0NEl4dVdJSUZGeWJUV0M4RVNPcnJaNG1JRTBBVmNQ?=
 =?utf-8?B?TkpYVEZsaFNONUZrUlR3NVpKdzNVNEdOa1VwUWROMk41Q0x5bHRybGhkN1JG?=
 =?utf-8?B?bnNoNGtZdVY5Qy8zVVcvWWIvUnlpV1JlUEI4VVg4VldReGY1VjBtbDRJQXl2?=
 =?utf-8?B?MXNRekFtWHFNZFI2OEwrd292T0hLekt2bjZNN0dlTEw5K3VSb0lGN2w1YW5R?=
 =?utf-8?B?bTd2OG84UnpXKzJLYzRUS0VWS1hndDVsNGtYeTFuaFp6UDNTK0lwVkU0UVZw?=
 =?utf-8?B?VVlOZEFjOWRYODZJSTBjZzU0ak8zUXFRcVg0ZFRGREJUU1JQbUQ2RGo5MlFR?=
 =?utf-8?B?Qmt1ZnpTS3lLbFdxb0FjZTZPYTBoamxYa0N1VjZxcC9aYWNBNE4xRlN4bWRu?=
 =?utf-8?B?R2FsbE1sbkFMWXZCRHlpR1pHVjlnbnI3c3lzVVNucGNCcmsrd0trWFJtNDJN?=
 =?utf-8?B?K2xXTGNZM1UyVjNlYzZMTmNtVGRiZGx0ZUx3ZkNGMWtob3pTbCtWUnErYXc4?=
 =?utf-8?B?OTNlZ1g2YWZzSHVFaG8yd3EzbGJVMStuY3dZSkZKTUJrWDlPVjB4bXZtVGZv?=
 =?utf-8?B?aC9GOTFWeTdyS1pTWTBoMys3Z1hSVlRveUdCOXpkbUFYVXFrTUF5WExtQXZI?=
 =?utf-8?B?UTVCanlVd2lBZU4yOGJUbzRjbTZiajZob1ZxdmQ2MCs2NUtDY2xZSDNIeHp2?=
 =?utf-8?B?ak1GM0hGSVhmSUFjL3NvMEllMHdRM2ZudTQvRDVqSXMwTXFFTkhRQnYzSUdY?=
 =?utf-8?B?VTYxelFaeGVIQVJYRmFJQk5lNENQRWtMVlVkSnNTZjRqYkphM1lmS0RjWTBB?=
 =?utf-8?B?OXZqVTJlMVcvcm5kMTAwSVlLSEdLRFQ1cGprYjFKdi9xSDNhLzFzTFN0bloz?=
 =?utf-8?B?Y2pXS3RtNEJodnc2cDZvK1ZSYVR4MUUveHZNWDNpTENwZkhQY01kTHY0Qk5I?=
 =?utf-8?B?N3lxbWlzNXdmTFVqVWxPdTdkVXk0MEdLOWdoM0YvSExRa0pDaEREa3E1bzhH?=
 =?utf-8?B?N1lOSVVzTXp6OVpvZVN3em1VZGtwUGNML1U1UnJTck1oTzczUFl2ckhTME9K?=
 =?utf-8?B?eFZTajhrZEFkOGE3czAyZ3VrK2RiRXdGN3J2Y1p0aUg1ODRSZFNjQmhRMjdF?=
 =?utf-8?B?Zjg0NW9CRmJHd1NNbWhacGt6ZExYRkdXcmdPaFFYSkNhV29OMVpYamhqSzNn?=
 =?utf-8?B?b2RuYUJOclE2a3hXbnphNmEyR09nNFFXKy9IQkFicks5V1BXN3puSjJvU1Zp?=
 =?utf-8?B?cW5zU3lvbEQ3bjJxaUFmOHB1TGx5aFkvVVZSb2daNE92YWlQVXhjNDBKT2dO?=
 =?utf-8?B?UVE5WlFZVU5DOUdQVEMvYXAreWN5dUErQUhSSDNuMGppSWFqbDR2MWVXSGJO?=
 =?utf-8?B?VGFCZEJwNTN2cit1RDFZb0YvcEF3elBmR0NNVXdHWUg2T0o1S3duOUtoTU81?=
 =?utf-8?B?T2M0RnkzYnNtWXRsUDFJaG4yaG5PZ1dnQ3ZMYjBSMnJMQm1yZlh4Q0lqNmJn?=
 =?utf-8?B?eXNwdWxxUlFLaS94NE42R0ttL3BrNVA2V2FsR05NVDBsb3NXZFoyS2VpMmNh?=
 =?utf-8?B?THBrYzhoK0I5ek5haDJxRS9aTTBFTXBqdHp4U0ZYTS9HQ0R6SnBzSGJqYTdZ?=
 =?utf-8?Q?5Z/USQjUBP+AafmY9X3pTaMeyDeqkIuR38NmP1W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <063669E3AC7DF54290AC26E4EC515950@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: psu.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4370.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411402a6-1ce5-419b-3196-08d9727a7944
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 03:40:59.5214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7cf48d45-3ddb-4389-a9c1-c115526eb52e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4khiM545+9SXdCil5Ux/71pHfngiyWa38jh7JZsaU1zKwnxg5aHFIPaJapzlyIf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tbWl0IDI2NzdkMjA2NzczMSAoImRjY3A6IGRvbid0IGZyZWUgY2NpZDJfaGNfdHhfc29jayAu
Li4iKSBmaXhlZA0KYSBVQUYgYnV0IHJlaW50cm9kdWNlZCBDVkUtMjAxNy02MDc0Lg0KDQpXaGVu
IHRoZSBzb2NrIGlzIGNsb25lZCwgdHdvIGRjY3BzX2hjX3R4X2NjaWQgd2lsbCByZWZlcmVuY2Ug
dG8gdGhlDQpzYW1lIGNjaWQuIFNvIG9uZSBjYW4gZnJlZSB0aGUgY2NpZCBvYmplY3QgdHdpY2Ug
ZnJvbSB0d28gc29ja3MgYWZ0ZXINCmNsb25pbmcuDQoNClRoaXMgaXNzdWUgd2FzIGZvdW5kIGJ5
ICJIYWRhciBNYW5vciIgYXMgd2VsbCBhbmQgYXNzaWduZWQgd2l0aA0KQ1ZFLTIwMjAtMTYxMTks
IHdoaWNoIHdhcyBmaXhlZCBpbiBVYnVudHUncyBrZXJuZWwuIFNvIGhlcmUgSSBwb3J0DQp0aGUg
cGF0Y2ggZnJvbSBVYnVudHUgdG8gZml4IGl0Lg0KDQpUaGUgcGF0Y2ggcHJldmVudHMgY2xvbmVk
IHNvY2tzIGZyb20gcmVmZXJlbmNpbmcgdGhlIHNhbWUgY2NpZC4NCg0KRml4ZXM6IDI2NzdkMjA2
NzczMTQxMCAoImRjY3A6IGRvbid0IGZyZWUgY2NpZDJfaGNfdHhfc29jayAuLi4iKQ0KU2lnbmVk
LW9mZi1ieTogWmhlbnBlbmcgTGluIDx6cGxpbkBwc3UuZWR1Pg0KLS0tDQogbmV0L2RjY3AvbWlu
aXNvY2tzLmMgfCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZm
IC0tZ2l0IGEvbmV0L2RjY3AvbWluaXNvY2tzLmMgYi9uZXQvZGNjcC9taW5pc29ja3MuYw0KaW5k
ZXggYzVjNzRhMzRkMTM5Li45MWU3YTIyMDI2OTcgMTAwNjQ0DQotLS0gYS9uZXQvZGNjcC9taW5p
c29ja3MuYw0KKysrIGIvbmV0L2RjY3AvbWluaXNvY2tzLmMNCkBAIC05NCw2ICs5NCw4IEBAIHN0
cnVjdCBzb2NrICpkY2NwX2NyZWF0ZV9vcGVucmVxX2NoaWxkKGNvbnN0IHN0cnVjdCBzb2NrICpz
aywNCiAJCW5ld2RwLT5kY2Nwc19yb2xlCSAgICA9IERDQ1BfUk9MRV9TRVJWRVI7DQogCQluZXdk
cC0+ZGNjcHNfaGNfcnhfYWNrdmVjICAgPSBOVUxMOw0KIAkJbmV3ZHAtPmRjY3BzX3NlcnZpY2Vf
bGlzdCAgID0gTlVMTDsNCisJCW5ld2RwLT5kY2Nwc19oY19yeF9jY2lkICAgICA9IE5VTEw7DQor
CQluZXdkcC0+ZGNjcHNfaGNfdHhfY2NpZCAgICAgPSBOVUxMOw0KIAkJbmV3ZHAtPmRjY3BzX3Nl
cnZpY2UJICAgID0gZHJlcS0+ZHJlcV9zZXJ2aWNlOw0KIAkJbmV3ZHAtPmRjY3BzX3RpbWVzdGFt
cF9lY2hvID0gZHJlcS0+ZHJlcV90aW1lc3RhbXBfZWNobzsNCiAJCW5ld2RwLT5kY2Nwc190aW1l
c3RhbXBfdGltZSA9IGRyZXEtPmRyZXFfdGltZXN0YW1wX3RpbWU7DQotLQ0KMi4yNS4xDQoNCg==
