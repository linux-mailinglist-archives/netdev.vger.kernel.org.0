Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A145832D
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 12:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbhKULr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 06:47:58 -0500
Received: from mail-bn1nam07on2071.outbound.protection.outlook.com ([40.107.212.71]:62944
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238162AbhKULr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 06:47:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4VWMln2aAN/k7Qt4yjeF+8QRSCbKP67Dv4GLBwxA9zPw9R6jObP6bu1BcaLy7rc/UUoJERk+BIUyNM5Ezo6RMakPyaKlrcd7n6U2sywOm5+ThUlWPm6TEjzRrPDBMWRKmyD0xN+UGQBhhXl26bwgyv0NEQNhBJsWwOiR3hxdye1R/gEl7TcaMddFuCvtn6kUNBSEy6Li42q//FQ98nULoN0prhKJmFLuUgpxqm9WPun9atSe42xwddBCrAsLIRyq+6sDks4Gf2EDueVAuZ2OdNR0sl5aKmv3TvGrxcYPsv1+lghCttaVgTJHf6TSceMJM7m6DVHbfVFvMysCv15EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l98vVg1pm3sCCi4JzzQp7gN6ZqKHSQxvkTg3nPjSTSQ=;
 b=K/NUbBeC3Ba0DaRhxTPqlHNHJL1Q1SA7Kbdqxcoidg9OStXemfDQ01KPfuFdtLzzCZcux2R+rzTb210sEE3kFDHbQzAr1SEqf8hDk0ow9fND2rU4VMNyDVspi3ahl2D31T3Y1TaJR50mFsJWGBzOvJ9UpijOIlJBfK1qGXc7YoPBLww7ZqbA/5O8MDPEwlh1s5HvGsemYK2FPNseWTowrOF7FgsqNTc1WmSuUNXyuleyXc3L7ojfEamfM/0ysY2O5TrHNT8eEeMao2VxfXZGERmkh0QEd5xUMj0FhXnbtFqSMFEhqyHhhvQ40W7sHbdahBEyeGM1C3XZ5Qgcr3cDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l98vVg1pm3sCCi4JzzQp7gN6ZqKHSQxvkTg3nPjSTSQ=;
 b=Oq506hn+6i3Lebcy2jP9XICcQ0TKdXcAs5pxyzvdCBcNlNBnrGJQV1LvXg+uU/BFTMJd5wM6g+pWsOgMJeznZOvnQ0hY2q0+VJ7tND3rB6Y5+GLQg0LiIm2klmg3QOqLQY01W2clAdISyQ8jRNyiY+vHGEyxn53nUv4biwr3TKjqIfozTVCcxMGBA/lqm08JFKXOiX44dwAMyjoH2v/Glut4lfTko9ncSxIiCzMIiFxjdTD6qSNDLk1Hqb310mqKfcmDjhCPRQMWZlnHWgk4uDcAqzUDpOwyslBKTKvExdXpomBHVaJrOcfpoqiUKtyORtxQwbvSvH+nyzAF3MB93w==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 11:44:51 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0%9]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 11:44:51 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Subject: RE: [igb] netconsole triggers warning in netpoll_poll_dev
Thread-Topic: [igb] netconsole triggers warning in netpoll_poll_dev
Thread-Index: Adfchsjmgwle+3nASZanfB6Ju1VdOQAEI/4AAIfaIfA=
Date:   Sun, 21 Nov 2021 11:44:51 +0000
Message-ID: <DM6PR12MB45162662DF7FAF82E7BD2207D89E9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <DM6PR12MB45165BFF3AB84602238FA595D89B9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKgT0UfGvcGXAC5VBjXRpR5Y5uAPEPPCsYWjQR8RmW_1kw8TMQ@mail.gmail.com>
In-Reply-To: <CAKgT0UfGvcGXAC5VBjXRpR5Y5uAPEPPCsYWjQR8RmW_1kw8TMQ@mail.gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 291fae0d-ddb9-4b89-8579-08d9ace45440
x-ms-traffictypediagnostic: DM6PR12MB4862:
x-microsoft-antispam-prvs: <DM6PR12MB48620C346E8064F3F1789651D89E9@DM6PR12MB4862.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2+6ujWXLB+F2iZihpuP2WDSuIMxHfiDH+xjVFZ5HceFBB18lBEvK7SkKNdUPsJrwulLuwjOnBVTdkvu5/n0VQlYDBndOkH8K+zRZ45p8/Lp6+sRTDKdN20zPAT1GIJoQKuTJmOxlDfdTMtkqTPCF3Qo2UrNaeBN2ukF18rw+LZA3tYwHrHw4U7yDWd6ZXvAb2iDz0PY3hK2zHeR2C4hr6PhvuuO3CZsIytbFHskjVbtCgDTrqU9+W+e2jT8hAp0CJQZ9Zfl3FzUP7jNxU7BGNTZszXLcRC0/3DcSwJa8ik+xoSmYAYhrehpK3D6tZyESW633JeGGdvJqQxvmk7X/GxHrzNU5pg9u0PVYKspFUTcMgQphDpUT7G7iHz0/62/YddeogO7FvsVvYdd7Fbbn+Mk461/djBZL4q2KEqHdUkNCeYFRgZt/Mo/dK0d4tjaqaa4dOjp8CgeUIy54rB1x901z3HLo3G6iZHc7q7/KdcsQHGHxxgp9iktn4+M8EkQ3WHTdnlmBRK6Ve/4tBdVqIP+upcFKiauFGzPecMqQduvguNq9dZu9ockjWSGdSngOijvEl00Wn32XJ9bMWosWmTHWXu3nT9Jg2hSiu0bc9AvFcc13CXkMiXf/P4pY/yzI5XkWa17DFVmy1f0LETKW5Yg04vcG6wqVgdYy/iihX/Wv2e9wsH9Fl0DwBpSwzZOv1UIn5nH5nZN/frIli9eaVE9TNapz+d1d09v305US+8o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(86362001)(508600001)(8676002)(33656002)(66446008)(64756008)(66476007)(66556008)(9686003)(52536014)(38070700005)(122000001)(54906003)(6506007)(4326008)(6916009)(38100700002)(8936002)(5660300002)(186003)(71200400001)(76116006)(2906002)(66946007)(26005)(83380400001)(7696005)(316002)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?di9nMmdUNStWUXlCTm5wTVRoQkszbjM3MlN4NUM3TzlDeGdtWW5JZ3dOMDZ6?=
 =?utf-8?B?YVA4bzlLZGVVY0hRbjhrcWRBbVc2VjFVbjJsVDdxYyt4blZvM05TbWY1amVl?=
 =?utf-8?B?UlUwUTUyM0RySjhKbzRLT0VaeitOVU9TRTN3anB1M3Y2UWFxMU8vdXJqVDRN?=
 =?utf-8?B?eTdGc29ERERhY3p6UktWbmwxaXdSZXdDS3ZoUWVUaWZoNkxnQTI1M3QyWDVw?=
 =?utf-8?B?N2R2YWxwZzYybEIwNXprTytTOEdCVlJDMWhFaTdSQ1NickQyc1NMZU1QbkRp?=
 =?utf-8?B?TFRWRFdBZW1vZitWc0pUeHd5UGRJR2FUUU9tQUJaQkJxT3hqanZhZWZQTGRl?=
 =?utf-8?B?Yk5ReUkwVUZmOHNlYWRnUXR6YmhvUGgzeUNZRTExTFlaYUVCQ0gyWW00SE85?=
 =?utf-8?B?SkhDM3NrSUlTcXE5Zy84dVpyemhkc2ZmTVNmZ0M4cHFseDNCMzQvcTNoU3A0?=
 =?utf-8?B?bUphQ3dkUi9qQnFrQUlreGFmTGRBa0haN0w2aTZOQXpSMnFmS3RVcTZkckhP?=
 =?utf-8?B?NnV2cTdqMHA0M3V3Y0FYT1p0Q1lVT0FkZnFuTTkzcnRGY3pzUkRCSS8zS1RI?=
 =?utf-8?B?cDdUWjFXV0VIOXZFRGRhNUd0Ti9rNEE2UVhHZ0s2ZzJUVzg0NFFkSVVSbFVq?=
 =?utf-8?B?RWJtNlRyaStKNXE0dDcwRzE2VXNkcEp0ZklMTk9sYXh5eGgxc0RBRnY2c2lw?=
 =?utf-8?B?ekdCeUZncDFCTGQvTGZYRTlxTFNGSGJSRFRTdnRleUJTaVdvT1UvNlJCTFN3?=
 =?utf-8?B?dEdBTmxtMjdqRitqMWcrSmtMTE9hOExxMzBpRjlwV0ViQnVtZ3BBNDI0RFdU?=
 =?utf-8?B?Y1hTa3pOWkt2OTRKTzF6VHcwVzMxQ1NDN2RraWpNMjJCMjJ1c2dKM2czT3dE?=
 =?utf-8?B?L01sZ1RGcWlvZmlOMFBzVERJMHNvS09VaFgyQmhvbEgzNUhoS0JyN3lMcStl?=
 =?utf-8?B?TndHU3Z0VjBlUFlZZWFOQXVNbWg1NmJkK1pQRGwzZC9oRkpvaXNVVlAxcTlp?=
 =?utf-8?B?czBZMHEvbjhYcXBkK1l1ZEo0czNBMXFVc2J5aHpUYTZGTjZjcEtvTllRTS9k?=
 =?utf-8?B?MkRsUnE3WmJqMmZna3R1NGJmS29Kd3QzZGFERGRubU4vUTJPamJpUkI2RHdI?=
 =?utf-8?B?ZnhCZk4yN3lSNGxZdnhGQWlHZXVITXl5QTNWbGpibStNR1JKeGVzc0VHbWpJ?=
 =?utf-8?B?TTdTQWZKWWpnWks5Y0NKSmNQTktWMUs2aXdJamNtNnM5OXpYMEt3bVd4L2dN?=
 =?utf-8?B?TGRPVjlJa0pQQXFrL21xVjFUOVV6amE4OW9Pb2pldzlyczN4WW5WKytyYmZL?=
 =?utf-8?B?MncvM2U1Q3dub0VvRk5meUZzVjg2ejM2ekF1NkxKNnJpcXRwWEFkYkZFMWNo?=
 =?utf-8?B?aG1MZHZMQ1hCdmhWY09wcHZyQ0FUMEtOOXFTOXZPWTRWd3kxVFBTZWEvVEN6?=
 =?utf-8?B?ZW5HdWI3bUl0TmF6dEROSUFxYmlhT21EK1dKMDdyT0NWa3pycXUrMU5CTnhY?=
 =?utf-8?B?czEyNHh2SEdXVzNqclFMS3JSMjI3ZW4vU0RZQXQzQXlEd0xiU3ZKakI1ajhC?=
 =?utf-8?B?V0sybEhVY3NITFFJc05EK3psYitGaFBwdDVlam1HNGlmQS9SQ2l5OG5nOVdy?=
 =?utf-8?B?YjFvZkpuMXVtczJ0VWQ2d0x4cExaQk90RHRkWnRSb05tODBZRlNWMTJOUE92?=
 =?utf-8?B?VFZpMDFUeWdlZ2JBYitYSExtRlF4a1Q4K2t5b1NqN0VSZGo4ZXp6WHc0MzJs?=
 =?utf-8?B?VmgxTnQxbFl6Um9sRXUyN2I4ZHZLUFFKZ0ZCZGR1SlRoMmFwRjFKOEJTZitY?=
 =?utf-8?B?VFBRUWUzMXByTWh5Z3RvbGxhTU0rNzMyb1pwazNWTGFmTkhpR2wwVGtUNDNt?=
 =?utf-8?B?N3dtSFZhZG5xM2tCdG9WRTlETFAvLzFPalhNTVV1MEg5VmtsWWlVUEFGZkxx?=
 =?utf-8?B?K3FkM3h3Tkl2MlVleVBFZlIrblB4M3NtTVg5M3RGd0h5WWh2UU1CSzNub3RV?=
 =?utf-8?B?NHNWaWoycE9SR3pjY2phaWJNczJLUEV0dW4xbkR1dENTY3o4SFNJMzlXUDh6?=
 =?utf-8?B?QjRKeEVIN0hpQVh5V3p6aENINTNNMjQ3TDMwTXRZcjhBOThsRTdUR25HdnpB?=
 =?utf-8?B?SS8zUXlKRyt4QmJLNk9uaVp2Q3o2RitFU3pSMkRzTVBPUmVrcTd2aFRmelRq?=
 =?utf-8?Q?JtmGKfgPcVK6aNiwsQ5vLsw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291fae0d-ddb9-4b89-8579-08d9ace45440
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 11:44:51.4795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WAy0Q61i6FRtZ+0heXjt4rVtgk9z4hPpaDo51HzKeTVxIxIAD0o/AxWKUw2N0QrxsrAuXxq0biVLN11sHN2cUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMgfCAxMiAr
KysrKysrKy0tLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pZ2IvaWdiX21haW4uYw0KPiA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2lnYi9pZ2JfbWFpbi5jDQo+ID4gPiA+IGluZGV4IDBjZDM3YWQ4MWI0ZS4uYjBh
OWJlZDE0MDcxIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pZ2IvaWdiX21haW4uYw0KPiA+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pZ2IvaWdiX21haW4uYw0KPiA+ID4gPiBAQCAtNzk5MSwxMiArNzk5MSwxNiBAQCBzdGF0aWMg
dm9pZCBpZ2JfcmluZ19pcnFfZW5hYmxlKHN0cnVjdA0KPiA+ID4gaWdiX3FfdmVjdG9yICpxX3Zl
Y3RvcikNCj4gPiA+ID4gICAqKi8NCj4gPiA+ID4gIHN0YXRpYyBpbnQgaWdiX3BvbGwoc3RydWN0
IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KSAgew0KPiA+ID4gPiAtICAgICAgIHN0cnVj
dCBpZ2JfcV92ZWN0b3IgKnFfdmVjdG9yID0gY29udGFpbmVyX29mKG5hcGksDQo+ID4gPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0
IGlnYl9xX3ZlY3RvciwNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBuYXBpKTsNCj4gPiA+ID4gLSAgICAgICBib29sIGNsZWFuX2Nv
bXBsZXRlID0gdHJ1ZTsNCj4gPiA+ID4gKyAgICAgICBzdHJ1Y3QgaWdiX3FfdmVjdG9yICpxX3Zl
Y3RvcjsNCj4gPiA+ID4gKyAgICAgICBib29sIGNsZWFuX2NvbXBsZXRlOw0KPiA+ID4gPiAgICAg
ICAgIGludCB3b3JrX2RvbmUgPSAwOw0KPiA+ID4gPg0KPiA+ID4gPiArICAgICAgIC8qIGlmIGJ1
ZGdldCBpcyB6ZXJvLCB3ZSBoYXZlIGEgc3BlY2lhbCBjYXNlIGZvciBuZXRjb25zb2xlLCBzbw0K
PiA+ID4gPiArICAgICAgICAqIG1ha2Ugc3VyZSB0byBzZXQgY2xlYW5fY29tcGxldGUgdG8gZmFs
c2UgaW4gdGhhdCBjYXNlLg0KPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiArICAgICAgIGNs
ZWFuX2NvbXBsZXRlID0gISFidWRnZXQ7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICBxX3Zl
Y3RvciA9IGNvbnRhaW5lcl9vZihuYXBpLCBzdHJ1Y3QgaWdiX3FfdmVjdG9yLCBuYXBpKTsNCj4g
PiA+ID4gICNpZmRlZiBDT05GSUdfSUdCX0RDQQ0KPiA+ID4gPiAgICAgICAgIGlmIChxX3ZlY3Rv
ci0+YWRhcHRlci0+ZmxhZ3MgJiBJR0JfRkxBR19EQ0FfRU5BQkxFRCkNCj4gPiA+ID4gICAgICAg
ICAgICAgICAgIGlnYl91cGRhdGVfZGNhKHFfdmVjdG9yKTsNCj4gPiA+DQo+ID4gPiBJJ20gbm90
IGEgYmlnIGZhbiBvZiBtb3ZpbmcgdGhlIHFfdmVjdG9yIGluaXQgYXMgYSBwYXJ0IG9mIHRoaXMN
Cj4gPiA+IHBhdGNoIHNpbmNlIGl0IGp1c3QgbWVhbnMgbW9yZSBiYWNrcG9ydCB3b3JrLg0KPiA+
ID4NCj4gPiA+IFRoYXQgc2FpZCB0aGUgY2hhbmdlIGl0c2VsZiBzaG91bGQgYmUgaGFybWxlc3Mg
c28gSSBhbSBnb29kIHdpdGggaXQNCj4gPiA+IGVpdGhlciB3YXkuDQo+ID4gPg0KPiA+ID4gUmV2
aWV3ZWQtYnk6IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyZHV5Y2tAZmIuY29tPg0KPiA+DQo+
ID4gSGksDQo+ID4NCj4gPiBJIGhhdmUgbGF0ZWx5IGFkZGVkIHRoZSBuZXRjb25zb2xlIG1vZHVs
ZSwgYW5kIHNpbmNlIHRoZW4gd2Ugc2VlIHRoZQ0KPiBzYW1lIHdhcm5pbmcgY29uc3RhbnRseSBp
biB0aGUgbG9ncy4NCj4gPiBJIGhhdmUgdHJpZWQgdG8gYXBwbHkgSmVzc2UncyBwYXRjaCBidXQg
aXQgZGlkbid0IHNlZW0gdG8gc29sdmUgdGhlIGlzc3VlLg0KPiA+DQo+ID4gRGlkIGFueW9uZSBt
YW5hZ2VkIHRvIHNvbHZlIHRoZSBpc3N1ZSBhbmQgY2FuIHNoYXJlIHdpdGggdXM/DQo+ID4NCj4g
PiBUaGFua3MsDQo+ID4gRGFuaWVsbGUNCj4gDQo+IFRoZSBvbmUgaXNzdWUgSSBjYW4gc2VlIGlz
IHRoYXQgaXQgYmFzaWNhbGx5IGxlYXZlcyB0aGUgaWdiX3BvbGwgY2FsbCBzdHVjayBpbg0KPiBw
b2xsaW5nIG1vZGUuDQo+IA0KPiBUaGUgZWFzaWVzdCBmaXggZm9yIGFsbCBvZiB0aGlzIGluIHRo
ZSBpbi1rZXJuZWwgZHJpdmVyIGlzIHRvIGp1c3QgZ2V0IHJpZCBvZiB0aGUNCj4gIm1pbiIgYXQg
dGhlIGVuZCBhbmQgaW5zdGVhZCBqdXN0ICJyZXR1cm4gd29ya19kb25lOyIuIFRoZSBleHRyYQ0K
PiBjb21wbGljYXRpb24gaXMgb25seSBuZWVkZWQgaWYgeW91IHdlcmUgdG8gYmUgcG9sbGluZyBt
dWx0aXBsZSBxdWV1ZXMgYW5kDQo+IHRoYXQgaXNuJ3QgdGhlIGNhc2UgaGVyZSBzbyB3ZSBzaG91
bGQgc2ltcGxpZnkgaXQgYW5kIGdldCByaWQgb2YgdGhlIGJ1Z2d5DQo+ICJidWRnZXQgLSAxIiBy
ZXR1cm4gdmFsdWUuDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmVwbHkgQWxleGFu
ZGVyIQ0KSXQgc2VlbXMgdG8gd29yayB3ZWxsIQ0KDQpBcmUgeW91IHBsYW5uaW5nIHRvIHNlbmQg
aXQgdXBzdHJlYW0/DQoNClRoYW5rcywNCkRhbmllbGxlDQoNCg==
