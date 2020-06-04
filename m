Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE81EDC8A
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFDErR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:47:17 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:8928
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgFDErQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 00:47:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4mzbMxzLVvDxEWq0AEBTMayIsaMSNNRK+mZbyv4xG5oEpOSl/iULstFQto7JJu12EKh7AIQDXXKCsBeUO94BtyLz/YFM5BYMU3DO2Zm3U5XU7dPctKFtAX4KHP/Z2yfFsiox5XajM8TNvFRwIN0vlCU2V4SOR5x4VcHcFlu7Axbyutwwukd01vsewninpVx7/vYaRXThp/1pqc9h+9PAlPFfZKqRE6Zkqd3Lssz+vp+8pO69fX72Sbs4xQJH4VMR7uWDjanPh3zlTnuqOHg6emUaap9O2KEJBfO/waO5DSTodTq1t46DKU2kRn1zZxTjc6WTu5Orgep98Tw83bjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noaHx6GA4sE4qeUfjrXWLwrGBpPZ5dHA5aXa4jYsxnM=;
 b=IiqIZE0lg8re64RbTul7O4zn1gZuM/bq/XP05HtDkjRj/sdVMuoOIMPonGQYLVQ4A9VrT4fILzqJ2GXhDxMfZAOoAkYu7HFAmThIs3nmdNCL1Zv+z+G0gTRIFgfpSDWybPYPp7yK2+2vvPG5NVwmJMpBkW4SFQ+vwYX8twkvBiYqdxM4agqUxuv+QP30VRwQFS+IgKj4MZt/B+3tUDV/2Pm8mq/y/sxDblNL3WY94ltUZ0yxBr/M0xBrbIRLVuzTJmNp0PedrYdb+EI+tFPvTr2Ey6rtKRS24J7BYKR57134HT0cFVtjIbHvdsC4qDMs3nFJ79OHurwJuuOu0xjFBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noaHx6GA4sE4qeUfjrXWLwrGBpPZ5dHA5aXa4jYsxnM=;
 b=XpSqX/okyK1pY4VS1QASa0xHk6vWzMX3c5zCvEseeDR+pEWG8/jakF08VLO3Vesd0OkoSAjQL0GZd1vSghw9WlvD4tODUT4wG/9jMNoYGKU0nidltR91yPYuDC6Gd2qVC8y0DwN2s2K74AJ8ksMptz6Nbw4N8mpaWyJFbCgBcUs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6688.eurprd05.prod.outlook.com (2603:10a6:800:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 04:47:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 04:47:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "efremov@linux.com" <efremov@linux.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        Alex Vesker <valex@mellanox.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()
Thread-Topic: [PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()
Thread-Index: AQHWODQW08Et5AyQukqYq107OQeR4qjH5gKA
Date:   Thu, 4 Jun 2020 04:47:13 +0000
Message-ID: <71eddd29fce960fed5556083548d68368315f6c3.camel@mellanox.com>
References: <20200601164526.19430-1-efremov@linux.com>
In-Reply-To: <20200601164526.19430-1-efremov@linux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: linux.com; dkim=none (message not signed)
 header.d=none;linux.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f599eb7f-4e5b-4dd7-18ed-08d8084259ba
x-ms-traffictypediagnostic: VI1PR05MB6688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6688861F81343A19710EA2ADBE890@VI1PR05MB6688.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a4prBYqFb+5pssA7glNlr8ux+Ayz6VsdKYGua+ZBmdtETiR5TRzvwZOJOxsZG3CBQXGzRH7OW3NptBiCxLrXauKLUkQ4Ioryd066mAeqojrwTTTPrBgEh32HHkcx5Zz7o0D0Z/krN8wD8dd603zC9W6EmoyjNp5Nf70hJP+xDRdsAroKKIyeDF0RXJxw4sEcpvBDVeWWyBf1QoG57g2rUfFsGV2a0BqL1djaeiT+sT7OZb/2Vzq+EmRvs0uid3rbeMZNrJSYzFLXgBI/L2sAp8JJKkc61VDMFvrqITCAoMQWAGyWMicFKkd2/yHXWHyAfB2pSvsIFoYk8t6r0kgXSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(76116006)(6486002)(5660300002)(478600001)(71200400001)(4744005)(2906002)(8676002)(8936002)(36756003)(6636002)(26005)(110136005)(4326008)(6506007)(91956017)(6512007)(186003)(66476007)(64756008)(66946007)(54906003)(86362001)(2616005)(66446008)(66556008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: q727Na69tJDNxZUCAthSHI77Qw21KIViDB+TuTaYP04Qi2LxiucFelHkkGxdrdWrq+UpCGJMeZC8hoAcELbSj0loxlDlIXzlQ5sEvVZ/xxKpYQR1QHW0Aumb+8Q6OYrL2gGrJ48tsujSwL36HXq29p0lCOG6VMUwNRKHjU6dGD0idLQqFQpA3FHTqj5OO8hB+O/FBbJahy2sWLYDhYg5bGP4Y8nOUCfS4NMXX/rrJdOmqaqlcgj04+EAKRob5ZXaGDFWjHFw6UYKdxfo9cUqApgMHTIESB4Ys7TMubKxxe4VJR0lficdEO/bES8PJRODaNy9LdyDvUZaKVCmMrU+wxp3ENLmwQEnyhSLc/3VYQ3LqSwzwbXoboLuuz3nqzFOnCur8+zlmQobAHSCOWhRj4OtPSNXIwjVAb8haq3SSvfrmOSIJkikk3gOew4LR8UatdJ3SuQ++hMvu2wtBhmGjL4r5d3WMjol7WuAcz90XVM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D670B1CD12B599478A49F8D3DCB91643@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f599eb7f-4e5b-4dd7-18ed-08d8084259ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 04:47:13.6598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nrYTWcJ9EiYoHogJnnjB04U63p5XRd9CfiGFXTYH0dPriHW3jdflOLZHoHqBJL7a6CD1QZlKHbeenMUmrmd/Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA2LTAxIGF0IDE5OjQ1ICswMzAwLCBEZW5pcyBFZnJlbW92IHdyb3RlOg0K
PiBWYXJpYWJsZSAiaW4iIGluIGRyX2NyZWF0ZV9yY19xcCgpIGlzIGFsbG9jYXRlZCB3aXRoIGt2
emFsbG9jKCkgYW5kDQo+IHNob3VsZCBiZSBmcmVlZCB3aXRoIGt2ZnJlZSgpLg0KPiANCj4gRml4
ZXM6IDI5N2NjY2ViZGM1YSAoIm5ldC9tbHg1OiBEUiwgRXhwb3NlIGFuIGludGVybmFsIEFQSSB0
byBpc3N1ZQ0KPiBSRE1BIG9wZXJhdGlvbnMiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBTaWduZWQtb2ZmLWJ5OiBEZW5pcyBFZnJlbW92IDxlZnJlbW92QGxpbnV4LmNvbT4NCj4g
DQoNCkFwcGxpZWQgdG8gbmV0LW1seDUsDQpUaGFua3MsDQpTYWVlZC4NCg==
