Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3893601A0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhDOFeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:34:00 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:56997
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhDOFeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 01:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d50VKEqj50UGsKR+PylvgGlocsbeQHBnjldapHY1ku0vEEVi2GJ7nNwsOGSsUgsxGUboshOCGdekcgCjlToEplIENZc3bUWE+XIxT8eGP7r799EvHtpAJhvWnIZmBrGD2FsqnqZFR12GtlzR87Q+xc5UmUEhMe4TlpXkIp1GeESAAl+uuFTqnkd9xVG8LgJmyBfDUVkkyIvRPOP51eR7WcYrLQ9K8Y6aDE6ObQ/FzZQB4xZcBA0K8Qip5i8CuNisG23elerw50IVCTW5KY2HDcxS+c47U5WEziN9LYRrj9yg8RnqUsDZs9unzEBndwk7rfcur0plvblG5QM6dJLZXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb/NedUt87lOzOkSJzzmIRUYA8Cx7HF2SLIWfHBMVic=;
 b=mzaGFPp8iMeGpeJBw8U2EG7aqDpk90dwUMi0FAjSJi7XwJNhaFelZoOSKfJWQz5Qq3DPKB6OTvhbi02+T8WbpHU3s8HA7FOuh2BiP0PzuWK0K7QDsVgCkdXbnigrJZoyPmDRcm2hrr1aiDdGH0J1OUV1Cp5iKdbbDQ4QCdDxST8C9n9Ge1EPM9Z+WH26LTIRZv98A9ZltdX4sB0tvaaKoFjoPqy8UfHO2M+WFfGmgSr0IMinKIyQiC8NtZxZZX4eXFXdzLcSm68N66bpqMkRt/LBS0Dw797cLXJwFvXw2fvB5/b5/wOGfsWaYv818oUuoiO6lReB17IHsi3VXBhL7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb/NedUt87lOzOkSJzzmIRUYA8Cx7HF2SLIWfHBMVic=;
 b=s1u7Dpinh/HuLa8shauz0zbI+OcQhUggvo5+n1fEq2vr4B0s4Pxr9GGyOA5ivXoo6i6d82Xds6ASPE7EbLlZDU0xQu495mlQToTdKmttMrv8dcgDvNq+HWKRo0csVGzuDBheGAx7e6Rjcu2x/u915ikXWZonpNmrl/MW3JqY5Jc=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM5PR04MB3074.eurprd04.prod.outlook.com (2603:10a6:206:4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Thu, 15 Apr
 2021 05:33:35 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 05:33:35 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Topic: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Index: AQHXMBbxUAh74ZmQ7kaFEfOTMU7Q+qqyr7+AgADYi+CAAK/ygIAA2Szw
Date:   Thu, 15 Apr 2021 05:33:34 +0000
Message-ID: <AM7PR04MB68858CD679FCD7F0BBE41E20F84D9@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
        <20210413101055.647cc156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM7PR04MB6885805B7D5D11DD8DC1CA28F84E9@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20210414093541.39706863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414093541.39706863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e9929e7-e135-4cd2-3fc1-08d8ffd00390
x-ms-traffictypediagnostic: AM5PR04MB3074:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR04MB3074F77CFA3D3F8876B121CCF84D9@AM5PR04MB3074.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TULTtu+BWLV/iXWDl2SoIAj3lEz+uU+NHLCOD+H91fbJrHknjmwqTGitJRJ4C66NCM+rpxIjg/3aO8B2SH2UIEg9wtnpqxttWjuwbOTh4JNwv8yNdnP9u7vGZ3SJ1hGvEnQ/bn5WR4pJSipd44l2iV+8/dDkg1Ll5PpWg1jxvLWhETbDHkm2LvvLj4T+xxJ0nNfO5bTQhpWt7q6Fqw6YmZSMsr4goX8sia9T2P/58urD3XTV+5rnsir9tBZQeQafKLv7iRCHv1wafMlH+aACK+JG3NU+D7FzMPqkAof/d/BJ8qOiBGyv2XxDWLIJ8qDMIHS5hhUIcU1rC8BhmDdv048kIJ5V79p5mRbIgcBnKST85g6H3pXjfI6xMswgPEgAsN+dPP8XUQB20kSIfg+UpXhhS94VGdzPd4Bjh0/U1aJZ2ty5jRMex1XSnMu6pRcjSNXO7096TXbe9yYJPIKGQsJBi2XupCesaJMNscLO0mVBAp50BxBWw+KMZFz52LkQ5lw+2ZSE1ijQSVZz2LLuCm1abea92Gj1GjJIU29X/15Bvdx1Xk/zH8zTCQ3ppScVQDoeDZ7V2EZXe5uYprA5ZzYZuvRYwFHMSqtDttioQY3ZEZZK6FhKf3AbyQnIeN3H2KGxUWhDMCYsxoor5VnAre5f+Xf3/q0mVWEs7tBCoSg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(966005)(86362001)(122000001)(4326008)(478600001)(9686003)(38100700002)(26005)(316002)(55016002)(66476007)(66446008)(54906003)(33656002)(53546011)(6506007)(7696005)(76116006)(64756008)(66946007)(8936002)(2906002)(66556008)(83380400001)(5660300002)(6916009)(52536014)(71200400001)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?TnZ5OUsrUC9YVGFqSUxTc0orTHhsS2pHUHFHVUh4cFlFZ08vUlZIeUtjM1hy?=
 =?gb2312?B?ZzlSUEx4U29ZcGoxRWwyQUlvTUU5NUc1ZSswZTFOM2l0dWNYUjBsUU1Cdmtj?=
 =?gb2312?B?U3hDb3RWTlkwUUlhMHBmY3NtV0FhT2xmYnV2V0dlNEdINWlhOFhEaXlvVnA5?=
 =?gb2312?B?emdaZEpSSkJGVjM5OHhvSzZTYVN1WEVIc2JBb3d3YnA1dDNycnF4ZmZ3Nzhz?=
 =?gb2312?B?anlCZW80UFBFUUcwdkNFemJxY0VPVjdCY3dUWFBkM0p2T01JYVo2K0VtTVBS?=
 =?gb2312?B?ZjhJRUhIZHhOd2lBbU03eG5BRDBzZkdpZTUrd0VtUDBDQkVzcjg0eWJvQVAx?=
 =?gb2312?B?VTEwNlVZaW5iMVZsb3IxRGZmSEJQMVM3cTY1U3N3eU1UWmNjVGhOVkJPQjgv?=
 =?gb2312?B?U2NzamlOZ2EwK3hETnIxcHEzcG1YeEphUEhlcnVqdEVjNk5DZWtYa0ZzQ25X?=
 =?gb2312?B?RFZqYTdvNUxKbWJkK3RqUFlmQlFhR2duOFlNdm5zdVUzeFRpWkdBYVpLUXpZ?=
 =?gb2312?B?UTB6SHBFRTVoTTJENmVmMStBdC9KanVPaW1tdW9IUEVHYmpIb3h1OFU5a3JG?=
 =?gb2312?B?TFlQMzF1NnJ5L1NGUTNxZHVQRlRWZFFHa1lRY1d4NkdSQ1REeWlTVUlOOE44?=
 =?gb2312?B?YmxJVUdvSXI5MElLNERsNXkvaG5DYlZ5T0FHQXFYdlRNeW1aTUhzZ3VZQXRi?=
 =?gb2312?B?cFRMRFdMWCt0Q016TkszYTluNzlhdGZ4Zi9GUlJlUTJ5WngwVjI3T3VuSFpx?=
 =?gb2312?B?TXpORUFCOGE0cERMNXBjSUtmSFNVRm1JRXNRL1JmNVVZeU5kSGdYRTdIalZk?=
 =?gb2312?B?Y1V5SjRQdVBKbmUreUFNTHl1NFZzMUhSMnZDYXkvVzRTUTB6U1ltUUZRUFJ3?=
 =?gb2312?B?S0djSGpmRjhOZXVQRjdJUllGUmNJMWp1ZTM4L000eFUySGFMTUdSTW9HUlZL?=
 =?gb2312?B?bDVIanEvdkh4V2V6Ykc1ZnZMUHZSWDl4S3JrT1VlVW9hQXdXWUJZUkVkTHVH?=
 =?gb2312?B?T3I0aVVydGs2SnNSYldnL2IrVy8yYnFRSFE3SUp4M2dZR1lWaW9qUDUyb0sr?=
 =?gb2312?B?azlZSnZocURpOXM3aGlYdm9VT1dScys5T3hab2xkMVNkc2hoajZaY0FkRVhB?=
 =?gb2312?B?cFg1S0grcmtINk51Y3dxYnd3Qm5tSzlEdGtrMFBTejJKRFhOU3NsQkxydCt3?=
 =?gb2312?B?a2NrNUpEVXlRN2p2ZlVWd0hnTnFxaENMQ2xEUmNNV2tBNjI5ZWkweGFEUXhz?=
 =?gb2312?B?cjdiMU83UDVOLzZhU25ZeDNEbXZ4ZnNVY1B3eUl6U1dLZWcyVjBhbW0vVWlX?=
 =?gb2312?B?cE5PQ0FLNDE1bGJsMWdYeldaSFY4TnpYQkZ5ZnhBdTRjSnEvK2Jmb3dIMW54?=
 =?gb2312?B?NzdIQUNzaTM4a1M1bk96NmN5Q1dYS1E3bWlxVEN0Zmt4ckRpTXI5MlhJTXFy?=
 =?gb2312?B?QUxpNzJYUDJWUVc2ME5BQ2pWWVFwZThLcGtoYk1qaHVKWlhPRHhUU2E0VGJG?=
 =?gb2312?B?aWZuUGtKQURKb29sTGhmUEpUQXhHaktJY1pOZ1RPUWhRR2RHd2tTWTNhZ2tk?=
 =?gb2312?B?UmppcDY2a2hIcWozc0Z5MHYvRmhqT3JwRlMxNzFZZWZBc3FaZDZvc2dMai9S?=
 =?gb2312?B?c1Zva1RqRjcyREJzK3QyTTk1SmNFY2pGNjZUOW1TMjMxTnNhenRhWnJ4Snkz?=
 =?gb2312?B?M3BNdTdmOVVhY0Z6U2pkdFpCLzRkSUljdzhtckU0Z1kwS3ZJVnBialR4dS9T?=
 =?gb2312?Q?NOEhEVxbq9vlrhTPR3PCEOENEKCyQ80PGlQioDZ?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9929e7-e135-4cd2-3fc1-08d8ffd00390
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 05:33:35.0492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ba4Oqrwj7TSqQWpafHFOK4kNtt4SDMBq8bcjay4yywF7eiL9b/81w1hl8PGSfdEfK/aGJkDgBimMuHC8vJbhJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3074
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMcTqNNTCMTXI1SAwOjM2DQo+IFRvOiBZLmIu
IEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERh
dmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBSaWNoYXJkDQo+IENvY2hyYW4g
PHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT47IENsYXVkaXUgTWFub2lsDQo+IDxjbGF1ZGl1Lm1h
bm9pbEBueHAuY29tPjsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47
DQo+IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTdWJqZWN0OiBSZTog
W25ldC1uZXh0XSBlbmV0YzogZml4IGxvY2tpbmcgZm9yIG9uZS1zdGVwIHRpbWVzdGFtcGluZyBw
YWNrZXQNCj4gdHJhbnNmZXINCj4gDQo+IE9uIFdlZCwgMTQgQXByIDIwMjEgMDY6MTg6NTcgKzAw
MDAgWS5iLiBMdSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgMTMgQXByIDIwMjEgMTE6NDg6MTcgKzA4
MDAgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+ID4gPiArCS8qIFF1ZXVlIG9uZS1zdGVwIFN5bmMgcGFj
a2V0IGlmIGFscmVhZHkgbG9ja2VkICovDQo+ID4gPiA+ICsJaWYgKHNrYi0+Y2JbMF0gJiBFTkVU
Q19GX1RYX09ORVNURVBfU1lOQ19UU1RBTVApIHsNCj4gPiA+ID4gKwkJaWYNCj4gPiA+ICh0ZXN0
X2FuZF9zZXRfYml0X2xvY2soRU5FVENfVFhfT05FU1RFUF9UU1RBTVBfSU5fUFJPR1JFU1MsDQo+
ID4gPiA+ICsJCQkJCSAgJnByaXYtPmZsYWdzKSkgew0KPiA+ID4gPiArCQkJc2tiX3F1ZXVlX3Rh
aWwoJnByaXYtPnR4X3NrYnMsIHNrYik7DQo+ID4gPiA+ICsJCQlyZXR1cm4gTkVUREVWX1RYX09L
Ow0KPiA+ID4gPiArCQl9DQo+ID4gPiA+ICsJfQ0KPiA+ID4NCj4gPiA+IElzbid0IHRoaXMgbWlz
c2luZyBxdWV1ZV93b3JrKCkgYXMgd2VsbD8NCj4gPiA+DQo+ID4gPiBBbHNvIGFzIEkgbWVudGlv
bmVkIEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgeW91IGNyZWF0ZWQgYSBzZXBhcmF0ZQ0KPiA+ID4g
d29ya3F1ZXVlIGluc3RlYWQgb2YgdXNpbmcgdGhlIHN5c3RlbSB3b3JrcXVldWUgdmlhIHNjaGVk
dWxlX3dvcmsoKS4NCj4gPg0KPiA+IHF1ZXVlX3dvcmsoc3lzdGVtX3dxLCApIHdhcyBwdXQgaW4g
Y2xlYW5fdHguIEkgZmluYWxseSBmb2xsb3dlZCB0aGUNCj4gPiBsb2dpYyB5b3Ugc3VnZ2VzdGVk
IDopDQo+IA0KPiBBaCwgSSBkaWRuJ3QgbG9vayBjbG9zZSBlbm91Z2guIEkgd2FzIGV4cGVjdGlu
ZyB0byBzZWUgc2NoZWR1bGVfd29yaygpLCBwbGVhc2UNCj4gY29uc2lkZXIgc2VuZGluZyBhIGZv
bGxvdyB1cCwgcXVldWVfd29yayhzeXN0ZW1fd3EsICR3b3JrKSBpcyBhIHJhcmUNCj4gY29uc3Ry
dWN0Lg0KDQpUaGFuayB5b3UgSmFrdWIuIEkgc2VudCBhbm90aGVyIHBhdGNoIGZvciB0aGlzLg0K
aHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIx
MDQxNTA1MzQ1NS4xMDAyOS0xLXlhbmdiby5sdUBueHAuY29tLw0K
