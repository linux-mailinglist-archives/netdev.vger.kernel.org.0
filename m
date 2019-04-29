Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900A9E02A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfD2KEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:04:49 -0400
Received: from mail-eopbgr810059.outbound.protection.outlook.com ([40.107.81.59]:54112
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727661AbfD2KEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NjkoBYfhx3zcOTZanPpvloylKMgALcOF92U8yobG0w=;
 b=gwmkcBtDuGJXaU30REtwWDkD9Byiv7s41qdpQOow8uEPDEVj6AbievZAjT+zdX6PX5sSBHZ/8GvTANHws8EZXK8hzIVXC9PK+AaoCnPbR0qiLdsCnwJvGvC1yWksZCsYRcJNlZZs0FpYmiUqeo44z3uukE6RvjNdUhGe42eYk+k=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:36 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:36 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Yana Esina <yana.esina@aquantia.com>
Subject: [PATCH v4 net-next 01/15] net: aquantia: add infrastructure to
 readout chip temperature
Thread-Topic: [PATCH v4 net-next 01/15] net: aquantia: add infrastructure to
 readout chip temperature
Thread-Index: AQHU/nLznhWyS86pIEaWJe71KD0faw==
Date:   Mon, 29 Apr 2019 10:04:35 +0000
Message-ID: <0a378d58cf39e838372492dd6352ad082873d42d.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 851b1281-959f-4e00-d947-08d6cc8a1560
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB3644106AE97A5A58852DF64C98390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +7bvMf28ghl54DgUXpxGkpHCMMMJbdlyHlknw3hBVF6AtWC2dxDq+drf32fINpKNMGBYjzF9qwsasYMY0Oxk83y6jiEJ/8iCx6NeJ9FUMupBmxGvz2U8JwHZk8H3lNDnW+b4N6Az9yuRDjrz2aDoVmXcZwLRuJ7J8OEuRA6Gj6oC86JX7/hbF1EbaieO1I/ESX+3F7PaB/bUi0TEfjXa34zpYcPMGE97vdRLetwxOlTHCMVh74gPAFB1HnDqXd8BPam0mcGL80KmuMPKPVgaEjL0t9mKXbhW1N/lbEDkHOoVD6B8kdsm7dKSztnrp6sPxSWf72QNL+5kgNjmoWTUU55Hpe/Ppb6VzWYR1mWoAZy8HfVY3mUT/9MbR+QsxlYoZ4bd0+kKm9EpH5Yj6b0QsM5j0f8UATVDrV8Pbf62Lxs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851b1281-959f-4e00-d947-08d6cc8a1560
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:35.9778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWFuYSBFc2luYSA8eWFuYS5lc2luYUBhcXVhbnRpYS5jb20+DQoNCkFiaWxpdHkgdG8g
cmVhZCB0aGUgY2hpcCB0ZW1wZXJhdHVyZSBmcm9tIG1lbW9yeQ0KdmlhIGh3bW9uIGludGVyZmFj
ZQ0KDQpTaWduZWQtb2ZmLWJ5OiBZYW5hIEVzaW5hIDx5YW5hLmVzaW5hQGFxdWFudGlhLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IE5pa2l0YSBEYW5pbG92IDxuaWtpdGEuZGFuaWxvdkBhcXVhbnRpYS5j
b20+DQpTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlh
LmNvbT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfaHcuaCAg
ICB8ICAyICsrDQogLi4uL2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHMuYyAg
IHwgIDEgKw0KIC4uLi9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYyAgICAgICB8
IDM2ICsrKysrKysrKysrKysrKysrKysNCiAzIGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlvbnMo
KykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX2h3LmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9ody5o
DQppbmRleCA4MWFhYjczZGMyMmYuLmYxYmM5NmM2ZjNiOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2h3LmgNCisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2h3LmgNCkBAIC0yNTksNiArMjU5LDggQEAg
c3RydWN0IGFxX2Z3X29wcyB7DQogDQogCWludCAoKnVwZGF0ZV9zdGF0cykoc3RydWN0IGFxX2h3
X3MgKnNlbGYpOw0KIA0KKwlpbnQgKCpnZXRfcGh5X3RlbXApKHN0cnVjdCBhcV9od19zICpzZWxm
LCBpbnQgKnRlbXApOw0KKw0KIAl1MzIgKCpnZXRfZmxvd19jb250cm9sKShzdHJ1Y3QgYXFfaHdf
cyAqc2VsZiwgdTMyICpmY21vZGUpOw0KIA0KIAlpbnQgKCpzZXRfZmxvd19jb250cm9sKShzdHJ1
Y3QgYXFfaHdfcyAqc2VsZik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlscy5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlscy5jDQppbmRleCBlYjRiOTlk
NTYwODEuLmI1MjE0NTc0MzRmYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHMuYw0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlscy5jDQpAQCAtOTYw
LDYgKzk2MCw3IEBAIGNvbnN0IHN0cnVjdCBhcV9md19vcHMgYXFfZndfMXhfb3BzID0gew0KIAku
c2V0X3N0YXRlID0gaHdfYXRsX3V0aWxzX21waV9zZXRfc3RhdGUsDQogCS51cGRhdGVfbGlua19z
dGF0dXMgPSBod19hdGxfdXRpbHNfbXBpX2dldF9saW5rX3N0YXR1cywNCiAJLnVwZGF0ZV9zdGF0
cyA9IGh3X2F0bF91dGlsc191cGRhdGVfc3RhdHMsDQorCS5nZXRfcGh5X3RlbXAgPSBOVUxMLA0K
IAkuc2V0X3Bvd2VyID0gYXFfZncxeF9zZXRfcG93ZXIsDQogCS5zZXRfZWVlX3JhdGUgPSBOVUxM
LA0KIAkuZ2V0X2VlZV9yYXRlID0gTlVMTCwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzX2Z3MnguYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHNfZncy
eC5jDQppbmRleCBmZTZjNTY1OGUwMTYuLmZiYzlkNmFjODQxZiAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHNfZncy
eC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwv
aHdfYXRsX3V0aWxzX2Z3MnguYw0KQEAgLTM4LDYgKzM4LDcgQEANCiAjZGVmaW5lIEhXX0FUTF9G
VzJYX0NUUkxfV09MICAgICAgICAgICAgICBCSVQoQ1RSTF9XT0wpDQogI2RlZmluZSBIV19BVExf
RlcyWF9DVFJMX0xJTktfRFJPUCAgICAgICAgQklUKENUUkxfTElOS19EUk9QKQ0KICNkZWZpbmUg
SFdfQVRMX0ZXMlhfQ1RSTF9QQVVTRSAgICAgICAgICAgIEJJVChDVFJMX1BBVVNFKQ0KKyNkZWZp
bmUgSFdfQVRMX0ZXMlhfQ1RSTF9URU1QRVJBVFVSRSAgICAgIEJJVChDVFJMX1RFTVBFUkFUVVJF
KQ0KICNkZWZpbmUgSFdfQVRMX0ZXMlhfQ1RSTF9BU1lNTUVUUklDX1BBVVNFIEJJVChDVFJMX0FT
WU1NRVRSSUNfUEFVU0UpDQogI2RlZmluZSBIV19BVExfRlcyWF9DVFJMX0ZPUkNFX1JFQ09OTkVD
VCAgQklUKENUUkxfRk9SQ0VfUkVDT05ORUNUKQ0KIA0KQEAgLTMxMCw2ICszMTEsNDAgQEAgc3Rh
dGljIGludCBhcV9mdzJ4X3VwZGF0ZV9zdGF0cyhzdHJ1Y3QgYXFfaHdfcyAqc2VsZikNCiAJcmV0
dXJuIGh3X2F0bF91dGlsc191cGRhdGVfc3RhdHMoc2VsZik7DQogfQ0KIA0KK3N0YXRpYyBpbnQg
YXFfZncyeF9nZXRfcGh5X3RlbXAoc3RydWN0IGFxX2h3X3MgKnNlbGYsIGludCAqdGVtcCkNCit7
DQorCXUzMiBtcGlfb3B0cyA9IGFxX2h3X3JlYWRfcmVnKHNlbGYsIEhXX0FUTF9GVzJYX01QSV9D
T05UUk9MMl9BRERSKTsNCisJdTMyIHRlbXBfdmFsID0gbXBpX29wdHMgJiBIV19BVExfRlcyWF9D
VFJMX1RFTVBFUkFUVVJFOw0KKwl1MzIgcGh5X3RlbXBfb2Zmc2V0Ow0KKwl1MzIgdGVtcF9yZXM7
DQorCWludCBlcnIgPSAwOw0KKwl1MzIgdmFsOw0KKw0KKwlwaHlfdGVtcF9vZmZzZXQgPSBzZWxm
LT5tYm94X2FkZHIgKw0KKwkJCSAgb2Zmc2V0b2Yoc3RydWN0IGh3X2F0bF91dGlsc19tYm94LCBp
bmZvKSArDQorCQkJICBvZmZzZXRvZihzdHJ1Y3QgaHdfYXFfaW5mbywgcGh5X3RlbXBlcmF0dXJl
KTsNCisJLyogVG9nZ2xlIHN0YXRpc3RpY3MgYml0IGZvciBGVyB0byAweDM2Qy4xOCAoQ1RSTF9U
RU1QRVJBVFVSRSkgKi8NCisJbXBpX29wdHMgPSBtcGlfb3B0cyBeIEhXX0FUTF9GVzJYX0NUUkxf
VEVNUEVSQVRVUkU7DQorCWFxX2h3X3dyaXRlX3JlZyhzZWxmLCBIV19BVExfRlcyWF9NUElfQ09O
VFJPTDJfQUREUiwgbXBpX29wdHMpOw0KKwkvKiBXYWl0IEZXIHRvIHJlcG9ydCBiYWNrICovDQor
CWVyciA9IHJlYWR4X3BvbGxfdGltZW91dF9hdG9taWMoYXFfZncyeF9zdGF0ZTJfZ2V0LCBzZWxm
LCB2YWwsDQorCQkJCQl0ZW1wX3ZhbCAhPQ0KKwkJCQkJKHZhbCAmIEhXX0FUTF9GVzJYX0NUUkxf
VEVNUEVSQVRVUkUpLA0KKwkJCQkJMVUsIDEwMDAwVSk7DQorCWVyciA9IGh3X2F0bF91dGlsc19m
d19kb3dubGRfZHdvcmRzKHNlbGYsIHBoeV90ZW1wX29mZnNldCwNCisJCQkJCSAgICAmdGVtcF9y
ZXMsIDEpOw0KKw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJLyogQ29udmVydCBQ
SFkgdGVtcGVyYXR1cmUgZnJvbSAxLzI1NiBkZWdyZWUgQ2Vsc2l1cw0KKwkgKiB0byAxLzEwMDAg
ZGVncmVlIENlbHNpdXMuDQorCSAqLw0KKwkqdGVtcCA9IHRlbXBfcmVzICAqIDEwMDAgLyAyNTY7
DQorDQorCXJldHVybiAwOw0KK30NCisNCiBzdGF0aWMgaW50IGFxX2Z3Mnhfc2V0X3NsZWVwX3By
b3h5KHN0cnVjdCBhcV9od19zICpzZWxmLCB1OCAqbWFjKQ0KIHsNCiAJc3RydWN0IGh3X2F0bF91
dGlsc19md19ycGMgKnJwYyA9IE5VTEw7DQpAQCAtNTA5LDYgKzU0NCw3IEBAIGNvbnN0IHN0cnVj
dCBhcV9md19vcHMgYXFfZndfMnhfb3BzID0gew0KIAkuc2V0X3N0YXRlID0gYXFfZncyeF9zZXRf
c3RhdGUsDQogCS51cGRhdGVfbGlua19zdGF0dXMgPSBhcV9mdzJ4X3VwZGF0ZV9saW5rX3N0YXR1
cywNCiAJLnVwZGF0ZV9zdGF0cyA9IGFxX2Z3MnhfdXBkYXRlX3N0YXRzLA0KKwkuZ2V0X3BoeV90
ZW1wID0gYXFfZncyeF9nZXRfcGh5X3RlbXAsDQogCS5zZXRfcG93ZXIgPSBhcV9mdzJ4X3NldF9w
b3dlciwNCiAJLnNldF9lZWVfcmF0ZSA9IGFxX2Z3Mnhfc2V0X2VlZV9yYXRlLA0KIAkuZ2V0X2Vl
ZV9yYXRlID0gYXFfZncyeF9nZXRfZWVlX3JhdGUsDQotLSANCjIuMTcuMQ0KDQo=
