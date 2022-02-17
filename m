Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45BF4B9CDD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiBQKOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:14:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiBQKOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:14:09 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120048.outbound.protection.outlook.com [40.107.12.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5E8184639;
        Thu, 17 Feb 2022 02:13:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpYEMHF3QQFSdwuo+WX/Q8a1xFUO/O9eetvDk5xQDfE272plQCpQgUl0HSXMwca9tEM1Axay5tRkDQlb56UtqCNb4FEa8Qkt/obgkBfcsdvG09sktcQRQpoz7B9RbGfiGPO2FwHcYlPp436pCTcgG86fpk/RQDPfzpTaFtXt2gCbz/BsqV7EgkfV9bt+0Rytc6V8W8fPV4zGjzFQKm/Eho89dj6E/PDL9/TxiqtI+g+4qN6endEXoVDAvwkrmfEqVcu8w1HiCUtQEKfiREwFbjsOwx45j2ydSVO8EYMoIU8+E8pyopdtbNTevAxIxCTFUvJ9X/udhpBAT6DZu7OT0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGVLAUJWolAZZASfxuU0YoM+81Np9Ik47+QF7ySt44o=;
 b=n53fZvFPI1hGJkMUxXQABoqDhSliAOUG/X7hw8KZCIRiNWe+arJLBK+HAAmYfwUMh4C2iaX2DAyNnZ61vixDtSwNEoEGpfcDHMigc/G5Lb+kvWtk+J79FsmwDcJficJ/BNTLWU+GhlQ74Vv0aHukYIih6etz83xe81WIGTdGInMJkHkXZ9xPWBuqxautELV8JaKiKgAuT6aMAZLvWYZ/H3VIPWScislMPmoGbuAWkUaf6fU3rSw/z5v+ufnP6SxDP3RYlFFJrJX8S9WuO5zrlzICQV4vpYhIN7FpT5C3DyOOkShan+Wm5dzOqlOrX+vGSYzQ7xIXUIrKlVtgJK91Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3714.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:28::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:13:50 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 10:13:50 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     David Laight <David.Laight@ACULAB.COM>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] powerpc/32: Implement csum_sub
Thread-Topic: [PATCH 2/2] powerpc/32: Implement csum_sub
Thread-Index: AQHYHzGjv1qRDwuwQkORsm7TGArxrKyQzZQAgAbCJgA=
Date:   Thu, 17 Feb 2022 10:13:50 +0000
Message-ID: <7dcc4db6-d5c8-c521-1d74-46871a332b55@csgroup.eu>
References: <0c8eaab8f0685d2a70d125cf876238c70afd4fb6.1644574987.git.christophe.leroy@csgroup.eu>
 <c2a3f87d97f0903fdef3bbcb84661f75619301bf.1644574987.git.christophe.leroy@csgroup.eu>
 <a87eb9e5bb6d483f8352ccb4b7374286@AcuMS.aculab.com>
In-Reply-To: <a87eb9e5bb6d483f8352ccb4b7374286@AcuMS.aculab.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6d9668a-69e9-4dac-7754-08d9f1fe3180
x-ms-traffictypediagnostic: MR1P264MB3714:EE_
x-microsoft-antispam-prvs: <MR1P264MB3714B9F55ABEF2903F8B3407ED369@MR1P264MB3714.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tzvzxY8VwERFlRCfGM7p2yakgYwZLB5sAp3s9PiLVxnhxIaZs0y5j6igFOjyc/lPN6yfHeSa1wH7Ii9Kt/3MWtBT6IvzhF22ofYNO63TauCbcoJVbuMJaEUGWdrFQi5h0NiWDjIzrmF1PQ31+yS4xggvriCyQrvTHzssa5RR2u44jwsrsmCw7PNATVrz4d9O9FTpIB7EUsgtpiPDzcjtfNdgsErk2ah4CpvyXXuVse+BdeA6/zXLqKJjpyW9sTYLGaj3Psn4xw6Yp7mpSmh7b7bT7IWHYrnDPcKK7HjYDt7TiP7fggOd3GTFHRIRNUepPyFRnpV9y1khz7a3bV0FXXK130pySimZuUxPIE2IzQ+RBpPTjbbP+DvFoZaLkXpv3NNDnbTCzFnC3+D6kl5RdhKQYw/8mhLgBziDNdUIomQcHZZlZSUymakF4L7M4xmo3J/XttGi5H1u1w7nFw6Crn7zYl0VSkHkQ7tWI3b6+ZC9G4ILhBmrR/SIkrnXLz6lMnSShq6eF0dfTzkGQYTzNO4PnVIbhJTB0wIU6Mkeilqkg2sc9ACdUKgGpxPQha0iQOgi7lbuYzFzsGKc7T+kI06G7jv2CSnkEWn/NF5lvYX8flMGgKsQmSgtl7cn2/njsjn8YOrI0FU3TGOOl0pscOesZVOXbup7xtSX7tFO7KOP5jdtOqq4Uj7BMTmEi1Tb0qv7sS0ohNoPyRJVQr/Rqdd40YLhpJZwjgZE0rQcHKsUxT/z/oXRZvAJD+BWxJG5CJOBbGuQ/Lvl374oC1fOAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(31696002)(86362001)(8936002)(66574015)(316002)(508600001)(54906003)(31686004)(6486002)(36756003)(110136005)(2906002)(8676002)(4326008)(91956017)(122000001)(6512007)(44832011)(5660300002)(38100700002)(2616005)(38070700005)(76116006)(6506007)(66946007)(66446008)(66476007)(66556008)(64756008)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3k2bXQ4YVNhUWZLbExjYTI1RjZmTTh5TWNYcmNISmZpbldOVlZPd1hoc3Rl?=
 =?utf-8?B?bTFjTFNDdDloZmVIUzZKSzlCMHV5enNCUmFpQ1l4R3RsUFd6RVpmNmowUFVj?=
 =?utf-8?B?ekJGVVRvUExibFl1NUI4SDlKZTkxc21xUHltVURuNXBkblBNeE9mejUzbHVk?=
 =?utf-8?B?ODdCYjVDcklnZXRwWjBMM0ZOaFB3d0tjdk9PVVRjMjdlYThDWmQ3V00yNU0z?=
 =?utf-8?B?NlNuZUhBUWlIUEN4cWw3NVplMkZUcnhxQlNYSG1PRmxvTFdycHBRb3VMa2cz?=
 =?utf-8?B?cW9IRmdjdzY3bi81N1p0VFpqWXZFQkdEektoallOU1E3S0Z1RzFLUTE2cmVy?=
 =?utf-8?B?aEc4YzV4Z0QvUnV2VEQ0RGN5ZlQycWk0dVY2ZTdscHlKcDVQOENNZ2pjN2xD?=
 =?utf-8?B?OCtpNXAvZDV2SXlyNVhnOVR5UXhhWmdJMUx2eXZTQm9LQm1jc2hnRStvQm1S?=
 =?utf-8?B?ODY2b29zRkFBdnhDRUFWMEZCMDluWXBBeWhWMTJjNjVaSldQNlE0ZlJRc0xI?=
 =?utf-8?B?bU1ybmxYSU5RVXFPcTN5SWhINWRoT0w1OE5uYnFabkUvdUZBajZsYmpVT3RO?=
 =?utf-8?B?VmFudjZNcjB1b0hGYUFvbjFNN3hDbC83K1NDOStuVy9LT2Z6d1pMV2pKUGpQ?=
 =?utf-8?B?aFBYQm9OYlgxdm5hYk9NT2FwbHJ2V1V6U3pFMFhmdG9oM01USGhyeUZvcWhh?=
 =?utf-8?B?WVdJSWx3S3ltVUZLNUMrUzVmcTlwcUxEdW8zaURWMStKd1NsekF0VDZEZ3JV?=
 =?utf-8?B?UDJYVFJTL00xUXRQNGZET3lVVDU0RnE4VHg1Uk16amZJbnJQNFZEc0twRVVV?=
 =?utf-8?B?dTFUMnZSaGpTSW9PZllFS0N5VVdXZWVMU2RzWkVEdGVCcUdCWkR0KzRsSjQ5?=
 =?utf-8?B?NEZMLzBqR0pjOTNwdU9QYjJxakhVblFhdGpVeEVadkkvalJhZG5Jelg5elF0?=
 =?utf-8?B?d0dtWnJwMDg3U0luNWZ4TzN5cEh6RXdKZzd1ejQ5Nkp0Qnp0M2p0SXFBZjQx?=
 =?utf-8?B?TGUwR0FBRGtjZHZSTXhDTUR4V2ZETW9WTDYvdzB0UUFOZ1BVYW8rVVZRcWh5?=
 =?utf-8?B?bTF3R29TWUtGRFJFK0gwUTV6TTl1cjdNVURKOWVwU1RYWXV5MFFNV0xqSGg0?=
 =?utf-8?B?T3pyZDM0RHZwKzhIMTJmaFdYVllSTEVvTnduWkdtOUw5d3ZWa0xwVTBzekQ0?=
 =?utf-8?B?YVRYbFBJNFZQK1ZCT3hBdCtHaG5GR1B6dlR3Y1FvNm1iUXJTWUFzempBc1g2?=
 =?utf-8?B?S1VoMVBMMkZZWXY4S1VKb1oxaC9LdEhzSHBSVXNGWFFXZk8vZUJSZ0lHUlhO?=
 =?utf-8?B?K1FNck1PL0MxS0FBQndleCtrRlBJeGpiT1JxRENHbzNvTFM0ZlRXK3pMaE02?=
 =?utf-8?B?azhLZmdvMjFDSCtvM0Q3a0FuMTVjQWJ0RjNrd0k0RlBZanFHRG5YOEQwbGFo?=
 =?utf-8?B?TDNnTjltQ1QrejhHTndINDQxSGxXL3N5Tkh1YnVlS3lrUG9qeTZIMldTRDlT?=
 =?utf-8?B?K0ViYTZ1Slc5UDRNeFg0eTFySjNoVm5MMnEzZDk2dEQwQ1M2ZXZEMU43eUFI?=
 =?utf-8?B?SitkQXh4bGVOTU1CeS9DeGg1cUQrNUlMdVkxMG1kTE8yWUQ1UFB3NGQ1eVl6?=
 =?utf-8?B?c09ZK1dOdk9LMjRuR0dNN3FtUkJqUDRZZGlNOW9wUG1IU3p0SWdWeVlDazVS?=
 =?utf-8?B?MGtjbTgyRmhxSXJlTEV1cnFnUlA2bWdEVFNRWitaRkNmbnpYRVVvdVRVYjFN?=
 =?utf-8?B?eTZvR0t0UGpYT3ZYcDl2SElJNG0zdzJvcDZrQXVYNXBlTVJTalVnZDhsai8z?=
 =?utf-8?B?WTVxR1dGNjR5QTZlQU5CbURTazZXTHN3WjFGR28zUHo5RGdYN1IvUGNXL0tM?=
 =?utf-8?B?Zk9VWkxSL09yM1FwMjdXK05jOUcvVFNjWkxMVlYrUkJodyt4TVN1KzV6emYw?=
 =?utf-8?B?U0tmb1ptd2VjWTUvaG9aZEd6Yk1zcWplS1ZXOXk0U2kxLzAxNm1rWkJPNnRs?=
 =?utf-8?B?QnlYZXhYUzJkSmQ2dkt2WkxNaVF6bDBxaXNyTG01SG5kaDJMVWx4VmxYN2lS?=
 =?utf-8?B?aXliRFV2dFg4eCtaditOM2QyblhKdGl0a3RROHhVK0FNSzRNQTNta09VTHcy?=
 =?utf-8?B?QVYyMDJyVHB3WFpGV0NpWDJFMVZRMW5idDNiNEdpMjBFWndFdU9XSnowbUg5?=
 =?utf-8?B?WTFQRktSOEN3L0lNUm1RRVpWakhoZWZqdlNuN2cwMXhIU1MrM1Zha1BXVUQz?=
 =?utf-8?Q?6ZBUPmMuo9r89+Sy4+MtLPXDRtDL5ppbkjc2decA6g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E789F3F9AF5CE44197DF8A0DA5720632@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d9668a-69e9-4dac-7754-08d9f1fe3180
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 10:13:50.3500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fPE/TxwbSWykCH4dUIub+/omYdpk8xu5j5fECe3oc4BDZFvUPsX5X+z+yIHfvQuxqIYUUMwkFL3i+3zuxKarBnidTG1DPIc8n9CU0krJ1Zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3714
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEzLzAyLzIwMjIgw6AgMDQ6MDEsIERhdmlkIExhaWdodCBhIMOpY3JpdMKgOg0KPiBG
cm9tOiBDaHJpc3RvcGhlIExlcm95DQo+PiBTZW50OiAxMSBGZWJydWFyeSAyMDIyIDEwOjI1DQo+
Pg0KPj4gV2hlbiBidWlsZGluZyBrZXJuZWwgd2l0aCBDT05GSUdfQ0NfT1BUSU1JU0VfRk9SX1NJ
WkUsIHNldmVyYWwNCj4+IGNvcGllcyBvZiBjc3VtX3N1YigpIGFyZSBnZW5lcmF0ZWQsIHdpdGgg
dGhlIGZvbGxvd2luZyBjb2RlOg0KPj4NCj4+IAkwMDAwMDE3MCA8Y3N1bV9zdWI+Og0KPj4gCSAg
ICAgMTcwOgk3YyA4NCAyMCBmOCAJbm90ICAgICByNCxyNA0KPj4gCSAgICAgMTc0Ogk3YyA2MyAy
MCAxNCAJYWRkYyAgICByMyxyMyxyNA0KPj4gCSAgICAgMTc4Ogk3YyA2MyAwMSA5NCAJYWRkemUg
ICByMyxyMw0KPj4gCSAgICAgMTdjOgk0ZSA4MCAwMCAyMCAJYmxyDQo+Pg0KPj4gTGV0J3MgZGVm
aW5lIGEgUFBDMzIgdmVyc2lvbiB3aXRoIHN1YmMvYWRkbWUsIGFuZCBmb3IgaXQncyBpbmxpbmlu
Zy4NCj4+DQo+PiBJdCB3aWxsIHJldHVybiAwIGluc3RlYWQgb2YgMHhmZmZmZmZmZiB3aGVuIHN1
YnRyYWN0aW5nIDB4ODAwMDAwMDAgdG8gaXRzZWxmLA0KPj4gdGhpcyBpcyBub3QgYW4gaXNzdWUg
YXMgMCBhbmQgfjAgYXJlIGVxdWl2YWxlbnQsIHJlZmVyIHRvIFJGQyAxNjI0Lg0KPiANCj4gVGhl
eSBhcmUgbm90IGFsd2F5cyBlcXVpdmFsZW50Lg0KPiBJbiBwYXJ0aWN1bGFyIGluIHRoZSBVRFAg
Y2hlY2tzdW0gZmllbGQgb25lIG9mIHRoZW0gaXMgKDA/KSAnY2hlY2tzdW0gbm90IGNhbGN1bGF0
ZWQnLg0KPiANCj4gSSB0aGluayBhbGwgdGhlIExpbnV4IGZ1bmN0aW9ucyBoYXZlIHRvIHJldHVy
biBhIG5vbi16ZXJvIHZhbHVlIChmb3Igbm9uLXplcm8gaW5wdXQpLg0KPiANCj4gSWYgdGhlIGNz
dW0gaXMgZ29pbmcgdG8gYmUgY29udmVydGVkIHRvIDE2IGJpdCwgaW52ZXJ0ZWQsIGFuZCBwdXQg
aW50byBhIHBhY2tldA0KPiB0aGUgY29kZSB1c3VhbGx5IGhhcyB0byBoYXZlIGEgY2hlY2sgdGhh
dCBjaGFuZ2VzIDAgdG8gMHhmZmZmLg0KPiBIb3dldmVyIGlmIHRoZSBjc3VtIGZ1bmN0aW9ucyBn
dWFyYW50ZWUgbmV2ZXIgdG8gcmV0dXJuIHplcm8gdGhleSBjYW4gZmVlZA0KPiBhbiBleHRyYSAx
IGludG8gdGhlIGZpcnN0IGNzdW1fcGFydGlhbCgpIHRoZW4ganVzdCBpbnZlcnQgYW5kIGFkZCAx
IGF0IHRoZSBlbmQuDQo+IEJlY2F1c2UgKH5jc3VtX3BhcnRpb24oYnVmZmVyLCAxKSArIDEpIGlz
IHRoZSBzYW1lIGFzIH5jc3VtX3BhcnRpYWwoYnVmZmVyLCAwKQ0KPiBleGNlcHQgd2hlbiB0aGUg
YnVmZmVyJ3MgY3N1bSBpcyAweGZmZmZmZmZmLg0KPiANCj4gSSBkaWQgZG8gc29tZSBleHBlcmlt
ZW50cyBhbmQgdGhlIDY0Yml0IHZhbHVlIGNhbiBiZSByZWR1Y2VkIGRpcmVjdGx5IHRvDQo+IDE2
Yml0cyB1c2luZyAnJSAweGZmZmYnLg0KPiBUaGlzIGlzIGRpZmZlcmVudCBiZWNhdXNlIGl0IHJl
dHVybnMgMCBub3QgMHhmZmZmLg0KPiBIb3dldmVyIGdjYyAncmFuZG9tbHknIHBpY2tzIGJldHdl
ZW4gdGhlIGZhc3QgJ211bHRpcGx5IGJ5IHJlY2lwcm9jYWwnDQo+IGFuZCBzbG93IGRpdmlkZSBp
bnN0cnVjdGlvbiBwYXRocy4NCj4gVGhlIGZvcm1lciBpcyAocHJvYmFibHkpIGZhc3RlciB0aGFu
IHJlZHVjaW5nIHVzaW5nIHNoaWZ0cyBhbmQgYWRjLg0KPiBUaGUgbGF0dGVyIGRlZmluaXRlbHkg
c2xvd2VyLg0KPiANCg0KT2ssIEkgc3VibWl0dGVkIGEgcGF0Y2ggdG8gZm9yY2UgaW5saW5pbmcg
b2YgYWxsIGNoZWNrc3VtIGhlbHBlcnMgaW4gDQpuZXQvY2hlY2tzdW0uaCBpbnN0ZWFkLg0KDQpD
aHJpc3RvcGhl
