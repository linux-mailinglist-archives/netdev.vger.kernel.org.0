Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E6235DC1B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbhDMKEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:04:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31116 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240518AbhDMKEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:04:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DA1CF6003652;
        Tue, 13 Apr 2021 03:03:53 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0016f401.pphosted.com with ESMTP id 37w6vugfpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:03:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZpDytK6qy4PuxBFYnB2dFxPKwVhirc64HxvauFvSXS//JnxTO6EAWqdySoslszpLmgvsvA7jZBrIDZIx0I3uCS+Z/frDxozuj+uw8QSQ1jmuheegilPSMmbrnKUYnEH3QS3ncqQ1AEU31aD4v1qtBSrOj0vRlZoGj/tSis+lnVBge1E1greaVbvJKR4t4ertLxa6F52vFpc5LS4pWB96MYOd1KXOUlZMgy2HVA7X4p1pD3oNnpv2r/eTo0LnJY9ilb/z2wFSq0R8gD/3ELtWMFYcmd3OAfqhmCXENF32/7QSq8w3GMBPjVwn5bqGphecoPMSy56Gzu+jeQTi2xytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRXJnyhg8rryCyrAXJhYc9goDvRVNpIN6EdjvutnLAw=;
 b=ZEYSXYfv4rW+8Awv8FACPpBbC6J+0r+NyNaUco3cslxusoCICrb5/Kn/Jn87BoZt2jCn9DivLc/IaC/ADJ9oMczVkWBOY31SQ5l57dXrmempA+T+QkKXXapy+XWWBJ5R4v67nhUrzdXDCPUcEtM3yMtE1bOCGDmc8j0UgOdlU2Z92eD15Ae3Qr1WlubkNmSblytl7Ie1nSbZ5j1Z6mjuMTYIwO+j9RHII81DOG/qfg1w2qay03BKZ5AAnXzDuiJ3NHvYk/1zY78go4VI4PyagFJTpuC5EsTAL3E3VogKzhCDKvRR/2oBen8YLFV/sSWQ4pU7Rn0AV06nrHm+31B+hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRXJnyhg8rryCyrAXJhYc9goDvRVNpIN6EdjvutnLAw=;
 b=aCn1B9VO2NBFq2PXXjLzWR1LT0KolSXwRQcdEwVNKs5txpf2FSFolN0OrkCDCWxDEwdHEgKz1tQqpt2mR7k4GLEvSZIJti7to312/1USpIt2IRUxAd7hj+JiEjd4duOhN74Ou2Xdg0TdE2P4xo+yiaAaEq44Jv/JZnlfgGvAS4w=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3924.namprd18.prod.outlook.com (2603:10b6:5:340::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 10:03:51 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 10:03:51 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Marcin Wojtas <mw@semihalf.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        Liron Himi <lironh@marvell.com>, Dana Vardi <danat@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Topic: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Index: AQHXMEFo10wdEFvjykKGBHXbluX/IaqyKzMAgAADlZCAAAZBcIAAAcGAgAAAUMA=
Date:   Tue, 13 Apr 2021 10:03:51 +0000
Message-ID: <CO6PR18MB3873F606BAA003DF8F0DA5D7B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
 <20210413091741.GL1463@shell.armlinux.org.uk>
 <CO6PR18MB38732288887550115ACCCF75B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <CO6PR18MB3873B0B27E086CA02E09B08DB04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <CAPv3WKfCLfMTDrmkf-1=tdQ6zJaBaDCV64T+vv2cLKUSqAAYGw@mail.gmail.com>
In-Reply-To: <CAPv3WKfCLfMTDrmkf-1=tdQ6zJaBaDCV64T+vv2cLKUSqAAYGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: semihalf.com; dkim=none (message not signed)
 header.d=none;semihalf.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59f6b72e-67a9-4e49-2f72-08d8fe637091
x-ms-traffictypediagnostic: CO6PR18MB3924:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB392492B082DDCF102626593BB04F9@CO6PR18MB3924.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L8Ffrz50DrQKbpLPeeTe41H06jcV+r2Q8SM9hn4rHkYScEx6YDioMO1vGqil4QkJItBWtGt3IBATBZw2vJGOi3hovJPEIkMgTvmqKJgLWUEKkO5V1y10iCrEdfUSSA7/chKe+TxmNgc612M5MwEJV1VfVw6DrlqsBqf8gbVsbDKKI+Ld1oLfFgVbjxp9PaB3WwPuJHMsIlpO6x4pBi7TvW7+0nVYWmUV4vpvAILXZUFO+65JJmL8cnkpvdUyldgHhggvLE7qbueRnvLtiqH/gGYiLnGNgqTsdjCT2PrxerCELHk8w1xdAWhDGAHdLWWi9YXPKAhauy1rDZdHd3j/9FKD3bjY/kk48kHArt0ESNVNA+CQjquha1DwYhRu449hCugWvWgOOSAZEM4GM589vSLo3LLUM/qh23MOEj8hQ23Ya5C5l5Slzkp5uincaGzICPluxvLVk4Ppd6jV7ckF1Ca1gUKO0poJTp86da7W9yV+Zrqphjz5QUlRc7X3pCpGg3kcDv/gDwMs4v+kNv4s6kSh4qbb2doM8N+DS6a/f2447+KZDXL362W2hACwQf4TrWTguyP5RNu6Hj/NKw3qQrBxjLhRPdVzsuE1Ad85ixg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(54906003)(52536014)(26005)(66446008)(316002)(83380400001)(5660300002)(66946007)(66476007)(6506007)(66556008)(76116006)(8676002)(122000001)(186003)(64756008)(53546011)(6916009)(86362001)(478600001)(33656002)(107886003)(4326008)(55016002)(9686003)(71200400001)(7696005)(8936002)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bzBRajZuZWUvdjdUTXRvRkt1MnkraDg3L0NqL3BYWVExUUJ4bkJVT3JoR21l?=
 =?utf-8?B?TWd2Qlk4Z3VhblBBSmZrelUwcnJKOWk3UnpiLzh0NlZBQ1hxRzFoNDlqeFFX?=
 =?utf-8?B?RWc4VmVxenFZcmhTM0tZUW5pNittMWFQaUxBR0pkMFZzclBHQ2o5aEVaeUk4?=
 =?utf-8?B?RFJueHY1MGY0SitPc2JPU2tqT3FXc0hmSFlUdkVnU2krT1VocGxjdnduZDJy?=
 =?utf-8?B?UzZsQzhNKzBsSk5PVS9SNTNxVlVBUWF4NDBxbzljbnZYODZoVlZ0VCt0NzJu?=
 =?utf-8?B?dDhNTFJrWHllMFE5Q0NXZTEwL3drdjdFSldVUGN0VWQxTUFGN29ETUc3OXFT?=
 =?utf-8?B?RFE5ZnhUKzkxdStnVzljMkFDdldqZmlhd01SUUJ0ZUFXeDUweDZ6akxWOG5U?=
 =?utf-8?B?RGtZZE5BMCs2YVZyRlczcWpqZFdnMzRpczRDQmNKVWZaWHFRc0NYTEZiOFda?=
 =?utf-8?B?UEhWcExUSWd3S3NrdFYycWxHZFFzZWl1UVZEUU1tWWhBR1VrS3VFWVJjYTht?=
 =?utf-8?B?OUNGWmhiZXEwQTU4NnJIaU1ZazMrdCtLazZXV1FpVlpSSjFkVGxTWERsUk01?=
 =?utf-8?B?WWJCSkJheGtWRmlQSCsyZ0tJeDRvQkwxc29LK2dxa2JZclloSmdHTFA1dnE3?=
 =?utf-8?B?WkluYzJqQXd5N0ZLV2Y1aFZvdlYzeGNnK1FhY2V0c3YrS1N0NWVPZ2RtZ2lJ?=
 =?utf-8?B?K1AzZVpROUVmZ0ZoSTlyL1VhRVBFY01yY0dCOHRpQkpuTG9RUWFqMnF2em1p?=
 =?utf-8?B?Z21HNzFhZlJTVzFveDVja3JnUUYvekJQNDBMR0Y1TCsrN0Y2THcrRzNIeVpk?=
 =?utf-8?B?ekVZdFZZNVd6aEVyek14Qk5XU0JjeFhmSXhlQnhtVzdiR0VwYTd6MU90OXFk?=
 =?utf-8?B?Y1E0TW9Qamh4T3NPMW1SQUtvSEYvQVUwcm1iRVdRenVpeWRNVk4rSmNpblM1?=
 =?utf-8?B?S1c2b1ZRQTVWeXplN2hKdGNrUWFON1o4UmFXdWw1ZEdiRkVZWm85SEdaeDlH?=
 =?utf-8?B?S2c1akZSL1IxMzE0aDZpVDVJODErYWh0VWhXS1ExS1E4dURrRjFuVXk4enE1?=
 =?utf-8?B?ZGhaQnJWU0FwS2h3Vk15YWZKK290Zm1ocGV2VlBaNDJvR1Bwalc5VVhlejY4?=
 =?utf-8?B?REVUYStiaGpKSE92c203WDVRVFNvSHJvNWpaSVNUSjBaeUw3TEZPK0wxeGZr?=
 =?utf-8?B?aGIzN1Bza0tsNXdRcnEzOVN3TXJTL3JaclB4ZVFpNi9FWXVEZzR4bVNFWUpB?=
 =?utf-8?B?dFFxU2lzalZyQkN3ZFdTYmJFaWdIMk9vUDhQbXZ6aUV3SlBlWFBCOXQ2aklD?=
 =?utf-8?B?TjJJQ1NKTTFYN0dDajhWczQvU3FZNnVFSHJkOUxiNUQ2Y3RTVFZPMXp2QzV3?=
 =?utf-8?B?VTV4bGlETWlzQXBtSFIxcW80LzU3MHphZWdUUllvSmhlQ0U1V0lmTUJGK0ZH?=
 =?utf-8?B?VHdoTmlxVHFLTSt1TUpwTXo1TEsya0lnbEpPT0wrSnZUYkJYdytTQVF4V3RM?=
 =?utf-8?B?MXdNSzZTOXEyeVN4S29ha0RWN05RQzc0TlVJZlBYRFlrT3M4cGI5TWdWRXJO?=
 =?utf-8?B?c1E1UjhycDhaSzFVbk96VE9CYWV6S1cxRnROeVRSRTJFdUZQeE9uM1gyNDBJ?=
 =?utf-8?B?VDNjV29zU2JVTm9mOEQydkg1U2JxYStoKzU4dlVxaGVIU1JQVGp3MitwU2cr?=
 =?utf-8?B?R1hsWmpSRG1lWmtkblBpbUl2NXBxNmNVQmFtSFZDZTZEOW5Cdk9xSWZLeUJs?=
 =?utf-8?Q?MEE5sj5+uz5W9CL6IPi5vT77S3YW+ROj7EAVi/R?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f6b72e-67a9-4e49-2f72-08d8fe637091
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 10:03:51.5331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVXiq18sQ5JEWx/OkD+M2ORsSQ1K/YCQnil7b1bc7apzH1wJmDHrJjj5dxsjmWg9DfcOllTqSAvKw4qYWUOEmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3924
X-Proofpoint-GUID: -CMTd263ruVC9uzn9ApDRl7mFEOIot8N
X-Proofpoint-ORIG-GUID: -CMTd263ruVC9uzn9ApDRl7mFEOIot8N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_04:2021-04-13,2021-04-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFyY2luIFdvanRhcyA8
bXdAc2VtaWhhbGYuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBBcHJpbCAxMywgMjAyMSAxMjo1OSBQ
TQ0KPiBUbzogU3RlZmFuIENodWxza2kgPHN0ZWZhbmNAbWFydmVsbC5jb20+DQo+IENjOiBSdXNz
ZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4gPGxpbnV4QGFybWxpbnV4Lm9yZy51az47DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRob21hcy5wZXRhenpvbmlAYm9vdGxpbi5jb207DQo+IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IE5hZGF2IEhha2xhaSA8bmFkYXZoQG1hcnZlbGwuY29tPjsgWWFu
DQo+IE1hcmttYW4gPHltYXJrbWFuQG1hcnZlbGwuY29tPjsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsNCj4ga3ViYUBrZXJuZWwub3JnOyBhbmRyZXdAbHVubi5jaDsgYXRlbmFydEBrZXJu
ZWwub3JnOyBMaXJvbiBIaW1pDQo+IDxsaXJvbmhAbWFydmVsbC5jb20+OyBEYW5hIFZhcmRpIDxk
YW5hdEBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtFWFRdIFJlOiBbUEFUQ0ggbmV0LW5l
eHRdIG5ldDogbXZwcDI6IEFkZCBwYXJzaW5nIHN1cHBvcnQgZm9yDQo+IGRpZmZlcmVudCBJUHY0
IElITCB2YWx1ZXMNCj4gDQo+IEhpIFN0ZWZhbiwNCj4gDQo+IHd0LiwgMTMga3dpIDIwMjEgbyAx
MTo1NiBTdGVmYW4gQ2h1bHNraSA8c3RlZmFuY0BtYXJ2ZWxsLmNvbT4gbmFwaXNhxYIoYSk6DQo+
ID4NCj4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gRnJvbTogUnVz
c2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+ID4g
PiA+IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDEzLCAyMDIxIDEyOjE4IFBNDQo+ID4gPiA+IFRvOiBT
dGVmYW4gQ2h1bHNraSA8c3RlZmFuY0BtYXJ2ZWxsLmNvbT4NCj4gPiA+ID4gQ2M6IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IHRob21hcy5wZXRhenpvbmlAYm9vdGxpbi5jb207DQo+ID4gPiA+IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IE5hZGF2IEhha2xhaSA8bmFkYXZoQG1hcnZlbGwuY29tPjsgWWFu
DQo+ID4gPiBNYXJrbWFuDQo+ID4gPiA+IDx5bWFya21hbkBtYXJ2ZWxsLmNvbT47IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBrdWJhQGtlcm5lbC5vcmc7DQo+ID4gPiA+IG13
QHNlbWloYWxmLmNvbTsgYW5kcmV3QGx1bm4uY2g7IGF0ZW5hcnRAa2VybmVsLm9yZzsgTGlyb24g
SGltaQ0KPiA+ID4gPiA8bGlyb25oQG1hcnZlbGwuY29tPjsgRGFuYSBWYXJkaSA8ZGFuYXRAbWFy
dmVsbC5jb20+DQo+ID4gPiA+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggbmV0LW5leHRdIG5l
dDogbXZwcDI6IEFkZCBwYXJzaW5nDQo+ID4gPiA+IHN1cHBvcnQgZm9yIGRpZmZlcmVudCBJUHY0
IElITCB2YWx1ZXMNCj4gPiA+ID4NCj4gPiA+ID4gRXh0ZXJuYWwgRW1haWwNCj4gPiA+ID4NCj4g
PiA+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+ID4gPiA+IC0tLS0gT24gVHVlLCBBcHIgMTMsIDIwMjEgYXQgMTE6
NDU6MzFBTSArMDMwMCwgc3RlZmFuY0BtYXJ2ZWxsLmNvbQ0KPiA+ID4gPiB3cm90ZToNCj4gPiA+
ID4gPiBGcm9tOiBTdGVmYW4gQ2h1bHNraSA8c3RlZmFuY0BtYXJ2ZWxsLmNvbT4NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+IEFkZCBwYXJzZXIgZW50cmllcyBmb3IgZGlmZmVyZW50IElQdjQgSUhMIHZh
bHVlcy4NCj4gPiA+ID4gPiBFYWNoIGVudHJ5IHdpbGwgc2V0IHRoZSBMNCBoZWFkZXIgb2Zmc2V0
IGFjY29yZGluZyB0byB0aGUgSVB2NCBJSEwgZmllbGQuDQo+ID4gPiA+ID4gTDMgaGVhZGVyIG9m
ZnNldCB3aWxsIHNldCBkdXJpbmcgdGhlIHBhcnNpbmcgb2YgdGhlIElQdjQgcHJvdG9jb2wuDQo+
ID4gPiA+DQo+ID4gPiA+IFdoYXQgaXMgdGhlIGltcGFjdCBvZiB0aGlzIGNvbW1pdD8gSXMgc29t
ZXRoaW5nIGJyb2tlbiBhdCB0aGUNCj4gPiA+ID4gbW9tZW50LCBpZiBzbyB3aGF0PyBEb2VzIHRo
aXMgbmVlZCB0byBiZSBiYWNrcG9ydGVkIHRvIHN0YWJsZQ0KPiBrZXJuZWxzPw0KPiA+ID4gPg0K
PiA+ID4gPiBUaGVzZSBhcmUga2V5IHF1ZXN0aW9ucywgb2Ygd2hpY2ggdGhlIGZvcm1lciB0d28g
c2hvdWxkIGJlIGNvdmVyZWQNCj4gPiA+ID4gaW4gZXZlcnkgY29tbWl0IG1lc3NhZ2Ugc28gdGhh
dCB0aGUgcmVhc29uIGZvciB0aGUgY2hhbmdlIGNhbiBiZQ0KPiBrbm93bi4NCj4gPiA+ID4gSXQn
cyBubyBnb29kIGp1c3QgZGVzY3JpYmluZyB3aGF0IGlzIGJlaW5nIGNoYW5nZWQgaW4gdGhlIGNv
bW1pdA0KPiA+ID4gPiB3aXRob3V0IGFsc28gZGVzY3JpYmluZyB3aHkgdGhlIGNoYW5nZSBpcyBi
ZWluZyBtYWRlLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGFua3MuDQo+ID4gPg0KPiA+ID4gRHVlIHRv
IG1pc3NlZCBwYXJzZXIgc3VwcG9ydCBmb3IgSVAgaGVhZGVyIGxlbmd0aCA+IDIwLCBSWCBJUHY0
DQo+ID4gPiBjaGVja3N1bSBvZmZsb2FkIGZhaWwuDQo+ID4gPg0KPiA+ID4gUmVnYXJkcy4NCj4g
Pg0KPiA+IEN1cnJlbnRseSBkcml2ZXIgc2V0IHNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9O
RSBhbmQgY2hlY2tzdW0NCj4gZG9uZSBieSBzb2Z0d2FyZS4NCj4gPiBTbyB0aGlzIGp1c3QgaW1w
cm92ZSBwZXJmb3JtYW5jZSBmb3IgcGFja2V0cyB3aXRoIElQIGhlYWRlciBsZW5ndGggPiAyMC4N
Cj4gPiBJTU8gd2UgY2FuIGtlZXAgaXQgaW4gbmV0LW5leHQuDQo+ID4NCj4gPiBTdGVmYW4uDQo+
IA0KPiBQbGVhc2UgdXBkYXRlIHRoZSBjb21taXQgbWVzc2FnZSBpbiB2MiB3aXRoIHRoZSBleHBs
YW5hdGlvbi4NCj4gDQo+IEFsc28gLSBpcyB0aGVyZSBhbiBlYXN5IHdheSB0byB0ZXN0IGl0PyBM
MyBmb3J3YXJkaW5nIHdpdGggZm9yY2VkIGhlYWRlcg0KPiBsZW5ndGg/DQo+IA0KPiBUaGFua3Ms
DQo+IE1hcmNpbg0KDQpJIHdpbGwgd2FpdCBmb3IgYWRkaXRpb25hbCBjb21tZW50cyBhbmQgcmVz
ZW5kIGl0IHRvbW9ycm93Lg0KV2UgcHJvYmFibHkgc2hvdWxkIHNlZSB0aGlzIGluICJwZXJmIHRv
cCIgaW4gTDMgZm9yd2FyZGluZy4gTGVzcyBjeWNsZXMgY29uc3VtZWQgYnkgTmV0d29yayBzdGFj
ayBjaGVja3N1bSBjYWxsYmFjay4NCg0KUmVnYXJkcy4gDQoNCg0K
