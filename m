Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99CB2535BD
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHZRJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 13:09:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9273 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgHZRJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 13:09:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4696bd0000>; Wed, 26 Aug 2020 10:07:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 10:09:10 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Aug 2020 10:09:10 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 17:09:10 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 26 Aug 2020 17:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHFh9vWhQQ7ZqP0lYFPR7nGLyaBOK0mMYbbqWkzwfK19D1yCwF0LBKbJ4tkqMYMpLQSE34eQDNvbmSccP860CNOUZFseUnlgERFM8qSdquumfOTtFweEh1Po8jFAC5cUQDInCr3yt+fe6UITe8NuM+aA8cMJXY7pLryl8tgV57yAqqmgfxEDmjgEcr5vSIqOUjere+9zJTv4HY12hsMonX5/oYm+wwcblytXwStVLx7zk4Btq05/Bk3AP76WRrOlJbLUqY3xliIu9Rkq2cBtuI6WtddDlxsUrCizRs8BHdKebN1mdTmmpAucZrcq1d95nz+VyJrjbWdkKW8BMWnirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o3CLU10hq9I9/xhizsOG6AktCBTSS4Ap/lxo5+Yq6A=;
 b=X0YrsV8rWg3nfJHRaLUKdBsltJmXUXCKgf6AVFJZtZpm4tGS5gbmnixgLJsikjjpnB7C8sjssOoGknc9j4XsHJJMYxayVSVYviJX4GGXPOMextP4ZODnPh/fellQR5jLDuFsyJR8VM4DYj1yRIFq4GucfEKtpiBZNyM5AoOKbuo5/EnNbWR6XAYZOlz41Z39g6mEeba2buq9plZOU7JTDjb//+KxFh6r3uTF0VFAiFe+NxFbxMa3BUBaAuNPLcQ8bWXLxkPY1nO+ki+EhsPAmTfJd8Rs5VHKSlQm8G9cRgh6YAuqrv9ZBS8k5DoZwGveMsaq+1wtBnlWz4kk/Cu/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3683.namprd12.prod.outlook.com (2603:10b6:a03:1a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 26 Aug
 2020 17:09:09 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9%5]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 17:09:09 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>
Subject: Re: [PATCH net-next 3/3] net/mlx4_en: RX, Add a prefetch command for
 small L1_CACHE_BYTES
Thread-Topic: [PATCH net-next 3/3] net/mlx4_en: RX, Add a prefetch command for
 small L1_CACHE_BYTES
Thread-Index: AQHWe6gd0Md2iOzeBUuB3M2EZKkp56lKeowAgAAlWwA=
Date:   Wed, 26 Aug 2020 17:09:09 +0000
Message-ID: <46820507065c60dc57840c6cf33f696980ed08a5.camel@nvidia.com>
References: <20200826125418.11379-1-tariqt@mellanox.com>
         <20200826125418.11379-4-tariqt@mellanox.com>
         <7a5e4514-5c5c-cd7d-6300-ff491f41aefa@gmail.com>
In-Reply-To: <7a5e4514-5c5c-cd7d-6300-ff491f41aefa@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6930b639-847a-4caf-7fae-08d849e2bf39
x-ms-traffictypediagnostic: BY5PR12MB3683:
x-microsoft-antispam-prvs: <BY5PR12MB3683E9E9DDBA04F3025366C6B3540@BY5PR12MB3683.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3v5NOf63ViDHx4CHqjIZMZ74CRztljbOfiMcTdWsVfIvRIia9x2ksxFQEpm9gybRl9K+dihidnLiP6E++AsoAZr6SJJeLvVjRkTV8XiTCZvUPF3OFM5Lkysc5S3U0azMU2CLgbHe0EfrW0fUZgqzblZtYvgfI9okg5mtJl9ReQy0fZXcXqJXOPMCUOUVAEBJpxW/ZDpLrXYFCXo8VcbhDb3A80EEGVK1h85TqXYbOSUZwnI93GMtAonGyVgdRQa01oN/Z2J6Xy7NIV009B/zQFnVKFwaCsHVZQOdggL4b8TXzY+Z2qa9ASJz3j0Hl4lARI/zlNpvjD7K2l64NMO6uQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(6486002)(4326008)(478600001)(86362001)(2616005)(26005)(36756003)(186003)(5660300002)(6506007)(8936002)(6512007)(53546011)(107886003)(316002)(66556008)(83380400001)(54906003)(71200400001)(76116006)(66446008)(64756008)(66946007)(66476007)(8676002)(2906002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iXnfqDVanAY+vvf1WAKs0kMFipaNOuSB6qLVMKSZQUG/bZXCOhDYMh3ItvIwY8hrREsHjIb0sBMSyQvBdzofqrhTUVcqOLvfGbDaK+aMKJ6+x2wbpzuDB9QAg5ANwF2qcOdt6zzl0oSixyno7dzMtBHcWHsTwOkb2arN5V0iedb+5JydEn6nREjdpujxqyy3JrTCBws4gm/0M3tyfd35+Z7xD89kWv3G8Z3Fb7bW1vPM6ZQT971QcWs3sI5xcg7kdthXfLlQa/n19I+WuFEN4iXjwZZpY501Ru7btcqwIcO4p3MotfMK2Aqtco3jzVAofPBQG4MANRpDECGYvUkAdy3kHyeh0ENpOAxGK29rtV2t26lYIjrqg4oJ0Y2FkkRHUxrpbpGwelF7j/e1G8hvasvJaWMgNqwy9ZJKGBUqyHEwrOJ3zlq9yrCGSgGL9gsverlfxeK0plDR+9qKQmSSRrphmKd8T/0fBTkSxV/1LRUsxfNe2SHLnRLwlu2Zlz56xSpSc98/1LowJg/2QxQfkGw7QeDNpIHr/Xgim1B54mpykR8U5QhkMg2QU8ke5iv6X5Pe+K0BzYiTasLunq04nTBqotm28y1ryCOnksoysX3+/RlYsE3mwvdAr5BYfBDFw34Hnpb7UZSK6X9Flb/cBQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <63530604AE8E3246AF09A5910BCBBD1D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6930b639-847a-4caf-7fae-08d849e2bf39
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 17:09:09.1492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dIqBZleJsm/MQCK2rRTdHCrI154dMmvI53ngUtH7wOWun/km9VTCrUO26OgGaFZp9vsWMzj4nBwComyIILbyDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3683
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598461629; bh=+o3CLU10hq9I9/xhizsOG6AktCBTSS4Ap/lxo5+Yq6A=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=U5tzNK+MWciS+B27WnYf5XnjQqByj1NQiXGM52t+7EmJXFsCrekElRg85H1Xw/XxH
         uMDQcYuq7uXPfBmmffYsUpa3TZM0bIHMrJ/O5HyJfTCh3tz49qamHsKUc0KlsND4OQ
         30nOuuqzaRYtlrld6qcy3ZQbv37qGjtWtgY3oihnMLy6hJX/l170rOgYvs0u/BLWLK
         mdB2R+Enu20XKxWDNxr3+hzhTiTq82wapmjVPYRZUbHa13Eb04SRf/hDICgkkU/9zD
         tuhBzw16ikLPaVDlWNIjUbeeDYVjPNz3B1pFCzgrkoQQdIgxzJR7UfGP1YZlUsCOKH
         vB5Uqvo6qpH8Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA4LTI2IGF0IDA3OjU1IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IA0KPiBPbiA4LzI2LzIwIDU6NTQgQU0sIFRhcmlxIFRvdWthbiB3cm90ZToNCj4gPiBBIHNpbmds
ZSBjYWNoZWxpbmUgbWlnaHQgbm90IGNvbnRhaW4gdGhlIHBhY2tldCBoZWFkZXIgZm9yDQo+ID4g
c21hbGwgTDFfQ0FDSEVfQllURVMgdmFsdWVzLg0KPiA+IFVzZSBuZXRfcHJlZmV0Y2goKSBhcyBp
dCBpc3N1ZXMgYW4gYWRkaXRpb25hbCBwcmVmZXRjaA0KPiA+IGluIHRoaXMgY2FzZS4NCj4gPiAN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+
ID4gUmV2aWV3ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3J4LmMgfCAy
ICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0
L2VuX3J4LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcngu
Yw0KPiA+IGluZGV4IGI1MGM1NjdlZjUwOC4uOTlkNzczN2U4YWQ2IDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fcnguYw0KPiA+IEBAIC03MDUsNyAr
NzA1LDcgQEAgaW50IG1seDRfZW5fcHJvY2Vzc19yeF9jcShzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+
ICpkZXYsIHN0cnVjdCBtbHg0X2VuX2NxICpjcSwgaW50IGJ1ZA0KPiA+ICANCj4gPiAgCQlmcmFn
cyA9IHJpbmctPnJ4X2luZm8gKyAoaW5kZXggPDwgcHJpdi0+bG9nX3J4X2luZm8pOw0KPiA+ICAJ
CXZhID0gcGFnZV9hZGRyZXNzKGZyYWdzWzBdLnBhZ2UpICsNCj4gPiBmcmFnc1swXS5wYWdlX29m
ZnNldDsNCj4gPiAtCQlwcmVmZXRjaHcodmEpOw0KPiA+ICsJCW5ldF9wcmVmZXRjaHcodmEpOw0K
PiA+ICAJCS8qDQo+ID4gIAkJICogbWFrZSBzdXJlIHdlIHJlYWQgdGhlIENRRSBhZnRlciB3ZSBy
ZWFkIHRoZQ0KPiA+IG93bmVyc2hpcCBiaXQNCj4gPiAgCQkgKi8NCj4gPiANCj4gDQo+IFdoeSB0
aGVzZSBjYWNoZSBsaW5lcyB3b3VsZCBiZSB3cml0dGVuIG5leHQgPyBQcmVzdW1hYmx5IHdlIHJl
YWQgdGhlDQo+IGhlYWRlcnMgKHB1bGxlZCBpbnRvIHNrYi0+aGVhZCkNCj4gDQoNClhEUA0KDQo+
IFJlYWxseSB1c2luZyBwcmVmZXRjaCgpIGZvciB0aGUgYWJvdXQgdG8gYmUgcmVhZCBwYWNrZXQg
aXMgdG9vIGxhdGUNCj4gYW55d2F5IGZvciBjdXJyZW50IGNwdXMuDQo+IA0K
