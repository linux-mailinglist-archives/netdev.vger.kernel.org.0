Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3A2C4775
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbgKYSRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:17:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17923 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733065AbgKYSRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:17:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe9fad0001>; Wed, 25 Nov 2020 10:17:17 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 18:17:17 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.54) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 18:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN6p3io3fA3q2M01hr/mD9HrxVKCLo7Fynx3h0eF6iCkHgPWJ76x/79E88MLj+NtFyrHdM7DyaZNRb5zvYahvb6n6PMmlcrAKRMjPrWVO7uBYWwcEbnel/0aiIFg1YLkhS8to59n0dKqZRbMEhV+0p8YVGTnTy8D5umGycUhjwd0wq0gAc4M6TrhTFBWMX7bi2G5wTGS6SrTzHxypXp2CrUoLqzBYIb/gcDeN444tiVZL5lmMkXDdD7OfZgVUA58loKiuA398QqBZjDKkBwntwnpx/Kw6V0w5zrgU1hqVApwK9NTA2MUW4VIzXlT3lvbSeILxdMYkhqSGF02E+ZDjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8/mBGUTLFXj8eDAgNquFzPfwzsAaOF9dNoIoYDCa7U=;
 b=I57lShBd/tZfmlJynTgvG/NXrR4A0gpUnTvxej+9B2XxxJhuvurpvIK1aRxTfgr+nfKvmyc0gpYVEYdJRU6/MdsEXjj97Z2/5z+tmZpyztUbJj9qCgVvddwxf31D4/CUHlLQ3gz1xgtAQ0hB35kvZljAx1vJJkNl1MNn1SBW6CDAS5QM+wH8XtiQkV2TyKh5bVn33+jQ9wUySRBGrOx/Z1X+C0kkQYDxbd3gIYe+sA9nAVsZz0L4HdzcCKrFrVvbZ/ULb7Lx112lBAiGfTLP2R2TMpPcRXkj2tuBTwXWgQgBnUVv0ZultcmQBSEUhVjD7JtQLS6Qc02nAfUuzUFh2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2775.namprd12.prod.outlook.com (2603:10b6:a03:6b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 25 Nov
 2020 18:17:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%5]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 18:17:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Topic: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev
 attributes
Thread-Index: AQHWwJaWgnmE6THF8EOAVnewN97U66nX4UcAgACKclCAAKOhAIAAC3xggAAIh4CAAAjUQA==
Date:   Wed, 25 Nov 2020 18:17:15 +0000
Message-ID: <BY5PR12MB43222543F49CA9DF7C25FADEDCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201122061257.60425-1-parav@nvidia.com>
        <20201122061257.60425-2-parav@nvidia.com>
        <20201124142910.14cadc35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224995BFBAE791FE75552ADCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201125083020.0a26ec0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43224D7843C4E83D1100AC53DCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201125094157.737d37aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125094157.737d37aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f405e9b0-7de3-46dd-676b-08d8916e5675
x-ms-traffictypediagnostic: BYAPR12MB2775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2775F1FC3CD7EB74D46F428DDCFA0@BYAPR12MB2775.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pa3c/XECrRel71eSFqvMcI/nweshhhBiz6UAMIz8ZJ2sAUFXh3YIBhZp+YTlBI7Q5+xlLvS6OMliEXrakH+/HNKpehywMy3XXZXMm7ASpI6yUKoWnZ/6MU5Z/xTvn1DslFSzOP7lcNIbh2Wc1TlwS98CopJ/awb/2hbEaXtM8movJyxzJqlErMOSI6Ms25bOC0VypSiEnvEfkGO6km3Gon4Lo1nqecTbyJcYlFKhgKj/fHCUsoYtW+gLjaz8dwB+HJMIUF+3p8Iursr1r0kRZimgZcXA4qiJl22CWJnIsHb7K34fL6LE8j8wezbrqVtl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(7696005)(8676002)(5660300002)(6916009)(71200400001)(8936002)(83380400001)(54906003)(2906002)(76116006)(33656002)(26005)(52536014)(66446008)(64756008)(66476007)(66946007)(66556008)(4326008)(86362001)(9686003)(55016002)(6506007)(107886003)(186003)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VmZXNWEvdVZFZlB5MHl4ZEhnZ0VXcENCeVRlWjV1L1ZCczNGRHMvam1IeTls?=
 =?utf-8?B?dDNGcllzeSs1SHIzcHpteE9OTCtGbTNSZG9hUjRZd2hkYjVaOW9lOFNrNGpU?=
 =?utf-8?B?RE5GUHkvUHExaWF3bXFxUi96WkYyTE9CTkF1dzUyd09iUjhGS1hsVU0yS0x1?=
 =?utf-8?B?TWxMSkRRRGYzSVE5NjRPQVcxb2VXb05ORXVzNktxTWRnVGd2eC81LzQydnYy?=
 =?utf-8?B?bW4yU3FGZmRLenl3V0hXTzlROTl2Yk5BNS9kVCtFd1A4a1oyTUtBb01MWDVM?=
 =?utf-8?B?OTNaWTRLOGgya2xUU1FKdHgvQlJ3VGZNZ1NZdzB5ZWZhWXJOK2RwWktjS0J5?=
 =?utf-8?B?My83bTdoYUdvRUxpVDZYNDdiZUpMMU5HMUJILy9IbUVVZUxQUGIrL0wvWnJj?=
 =?utf-8?B?OElWdDlhdHNiZmNCcEwwcGljaHhIeE1XYlZvaWNEb3FjQXN6RFdzZG0xMHZV?=
 =?utf-8?B?dEVackd3Y0plMG1xQ3dHN1hKbHU0bUZoRzVXbElMVzBpTkpWNWZrK2FvaUs5?=
 =?utf-8?B?cnBRTUYvNzZLOTMvZjV3M3ErYWFZSlFQck8ycll2SmJ1OUxybnZOZzZ5VXEw?=
 =?utf-8?B?WmlBQXFoT2pYenc5RnBxZ05CTmpCdUVDY3N3YWpIVG1BMXpZSGVUYVIxMjhn?=
 =?utf-8?B?dUhwcDErQ1ZsN1dxZGhvYUtKaGphZDNObDRVUk5GUHRKVllOWHRLUlpxVjNo?=
 =?utf-8?B?QUJ5emtZM3VacVhkcXpPYUliUkVnakpuV3ZUUzFZeUJnOEgwNFAxRmlWa0Ez?=
 =?utf-8?B?SE44QjlBeUVLaUEwNjhtMktZenlIV2JuRm4zQjVPSnVQdmxnR2l3REE4U29F?=
 =?utf-8?B?ZitPREYzTnRvbm5Oa3VuVHlGZkk2c1VpaVNlOTMxQTUzUm5XTTlPWE51d2x5?=
 =?utf-8?B?NnRUaWUrcUpveFErTEVPajEyVmpDOC9XL2JFMkJZcDZBTHhLQ1p3WGdCWGtS?=
 =?utf-8?B?N0RCVGQ1L3ZQdTJUb0QrQS8xdEpTQmYxYmJ2bG0zb3JjajN5K3pIL2pQMVdO?=
 =?utf-8?B?L0x1ZHBaRDF1R3dvL3ZlMUptK2J1YUVrTnh4S0p4elhlSVkxOXBDaXBQK3RK?=
 =?utf-8?B?djNrUStrSWJMamdGUVcxblpnNjR6czdoOG1hTWo5TkpaekxIWnVvNlBQa0RY?=
 =?utf-8?B?a3Q5Z2NoM0g0V0xiL1FBU3Irc0g0MnRTY1p4V0JpenFEVXlLYzc3NFRMUjdu?=
 =?utf-8?B?ZXppYUswa3gvbHNpc04wMFRjZ2NYL2h0UmZVTDhTZWN5UmdPSG4vaGtITWFz?=
 =?utf-8?B?QnV2TFN3V2U5UVdWUTVQVUd5dUVLZnNleEtlVlBkYjRWSTNYZVRUUmNDYWhh?=
 =?utf-8?Q?ykhU67FN0E5AY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f405e9b0-7de3-46dd-676b-08d8916e5675
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 18:17:15.2694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nD7wuUzb4oo0CbD8iIsqB7/8AOLSPGq9orIJZHuAvCuyQz1dLfcpH8IyITzyEOVBAM6Ss0y24IyQkPQb+ZjmKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2775
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606328237; bh=E8/mBGUTLFXj8eDAgNquFzPfwzsAaOF9dNoIoYDCa7U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=eqXQMTIyXwbPQpMHN3oDk8gc1Q6OyrXfDTiZ8hg5aX37mUc1u1FR7sumARF1GCYgy
         5VkaV25P98qMvwrT3+eRnG0sKtwh0TSZDCtXchwGaNfDoJMn4nkuxZkenIRk2Y2GLs
         CqYgJalCzPBFhlvDWL+UzXwngA8dnn1fwQyvcyEq5O7W2aXo1FcPZCLT8cboYB89gp
         tmq9F8CilfU7RkunC7AtcsQLOp4DQZDlmffd/jS/WB54Ey8/XOFbYcPZqQhiHN+RsK
         Pj05g92eJ1NNNMjwn6i9HlQ5AUXglcN5NGZK8jGvD4FcjhYCx6wf7skoSrCVIH9q6D
         eMPMHZPFf7i2w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogV2Vk
bmVzZGF5LCBOb3ZlbWJlciAyNSwgMjAyMCAxMToxMiBQTQ0KPiANCj4gT24gV2VkLCAyNSBOb3Yg
MjAyMCAxNzoyMTo0MSArMDAwMCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gPiBGcm9tOiBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBOb3Zl
bWJlciAyNSwgMjAyMCAxMDowMCBQTQ0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgMjUgTm92IDIwMjAg
MDc6MTM6NDAgKzAwMDAgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+ID4gPiA+IE1heWJlIGV2ZW4g
YWRkIGEgY2hlY2sgdGhhdCBkcml2ZXJzIHdoaWNoIHN1cHBvcnQgcmVsb2FkIHNldA0KPiA+ID4g
PiA+IG5hbWVzcGFjZSBsb2NhbCBvbiB0aGVpciBuZXRkZXZzLg0KPiA+ID4gPiBUaGlzIHdpbGwg
YnJlYWsgdGhlIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgYXMgb3JjaGVzdHJhdGlvbiBmb3INCj4g
PiA+ID4gVkZzIGFyZSBub3QgdXNpbmcgZGV2bGluayByZWxvYWQsIHdoaWNoIGlzIHN1cHBvcnRl
ZCB2ZXJ5DQo+ID4gPiA+IHJlY2VudGx5LiBCdXQgeWVzLCBmb3IgU0Ygd2hvIGRvZXNuJ3QgaGF2
ZSBiYWNrd2FyZCBjb21wYXRpYmlsaXR5DQo+ID4gPiA+IGlzc3VlLCBhcyBzb29uIGFzIGluaXRp
YWwgc2VyaWVzIGlzIG1lcmdlZCwgSSB3aWxsIG1hcmsgaXQgYXMNCj4gPiA+ID4gbG9jYWwsIHNv
IHRoYXQgb3JjaGVzdHJhdGlvbiBkb2Vzbid0IHN0YXJ0IG9uIHdyb25nIGZvb3QuDQo+ID4gPg0K
PiA+ID4gQWgsIHJpZ2h0LCB0aGF0IHdpbGwgbm90IHdvcmsgYmVjYXVzZSBvZiB0aGUgc2hlbmFu
aWdhbnMgeW91IGd1eXMNCj4gPiA+IHBsYXkgd2l0aCB0aGUgdXBsaW5rIHBvcnQuIElmIGFsbCBy
ZXBycyBhcmUgTkVUTlNfTE9DQUwgaXQnZCBub3QgYmUgYW4NCj4gaXNzdWUuDQo+ID4gSSBhbSBu
b3Qgc3VyZSB3aGF0IHNlY3JldCBhcmUgeW91IHRhbGtpbmcgYWJvdXQgd2l0aCB1cGxpbmsuDQo+
IA0KPiBJJ20gcmVmZXJyaW5nIHRvIE1lbGxhbm94IGNvbmZsYXRpbmcgUEYgd2l0aCB1cGxpbmsu
IEl0J3Mgbm90IGEgc2VjcmV0LA0KT2suDQo+IHdlIGFyZ3VlZCBhYm91dCBpdCBpbiB0aGUgcGFz
dC4NCj4gDQo+ID4gSSBhbSB0YWtpbmcgYWJvdXQgdGhlIFNGIG5ldGRldmljZSB0byBoYXZlIHRo
ZSBORVROU19MT0NBTCBub3QgdGhlIFNGDQo+IHJlcC4NCj4gPiBTRiByZXAgYW55d2F5IGhhcyBO
RVROU19MT0NBTCBzZXQuDQo+IA0KPiBBbGwgcmVwcyBidWlsZCBieSBtbHg1ZV9idWlsZF9yZXBf
bmV0ZGV2KCkgaGF2ZSBORVROU19MT0NBTC4NCj4gDQpZZXMuIHRoaXMgaXMgY2xlYXIgdG8gbWUg
YW5kIHdlIGFyZSBnb29kIGhlcmUuIPCfmIoNCg0KPiA+IEkgZG8gbm90IGZvbGxvdyB5b3VyIGNv
bW1lbnQgLSAndGhhdCB3aWxsIG5vdCB3b3JrJy4gQ2FuIHlvdSBwbGVhc2UgZXhwbGFpbj8NCj4g
DQo+IE15IGhhbGYtYmFrZWQgc3VnZ2VzdGlvbiB3YXMgdG8gYmFzaWNhbGx5IGFkZCBhOg0KPiAN
Cj4gCVdBUk5fT04ob3BzLT5yZWxvYWRfZG93biAmJiBvcHMtPnJlbG9hZF91cCAmJg0KPiAJCSEo
bmV0ZGV2LT5wcml2ICYgTkVUSUZfRl9ORVROU19MT0NBTCkpOw0KPiANCj4gdG8gZGV2bGlua19w
b3J0X3R5cGVfbmV0ZGV2X2NoZWNrcygpLiBHaXZlbiBpZiBkZXZpY2UgaGFzIGEgcmVsb2FkDQo+
IGNhbGxiYWNrIGRldmxpbmsgaXMgdGhlIHdheSB0byBjaGFuZ2UgbmV0bnMuIEJ1dCB5ZWFoLCB3
ZSBjYW4ndCBicmVhaw0KPiBleGlzdGluZyBiZWhhdmlvciBzbyB5b3VyIHVwbGluayBoYXMgdG8g
YmUgbW92YWJsZSBhbmQgY2FuJ3QgaGF2ZQ0KPiBORVROU19MT0NBTC4gSU9XIGFkZGluZyB0aGUg
V0FSTl9PTigpIHdvbid0IHdvcmsuDQo+IA0KUmlnaHQuDQoNCj4gSG9wZSB0aGlzIGlzIGNyeXN0
YWwgY2xlYXIgbm93Lg0KWWVzLCBpdHMgY2xlYXIuIFRoYW5rcy4NCg0KSSBhZGRyZXNzZWQgeW91
ciBjb21tZW50cyBhbmQgY3V0IGRvd24gYm90aCB0aGUgZml4ZXMgdG8gbWVyZWx5IDcgbGluZXMg
Y2hhbmdlLiBTZW50IHYyLg0K
