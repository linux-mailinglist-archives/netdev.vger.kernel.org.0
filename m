Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC256524DE
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 17:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLTQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 11:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiLTQrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 11:47:12 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2111.outbound.protection.outlook.com [40.107.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA3CB850
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 08:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzifW+/FmIijKuc1qw22ghwF/2hdh6EwU5ATeOy9p5w7YxReM591hCRY3VUQaSYDtX+neBn9ukMgZGrKxfG2Axp0Pr739rEdVEbQeDZCdboyX8E54oemoQu5isSk3tPPk9j35q3CLeirOTKMGju9Ym/iGPzSQOOsk2KNwlmyHsXLVYidrUZHDyYbLY9YMU15Iw6Oy5NDOtgvfGXigyiO915HcF0eMbY0aH5iK5IQMEiBUDe5Oely7boNYl6e9ooaqCgrautGW8TcfWSzxLldVyvMVbtkYkbLGrPOzIJvXvnYkFc6IaAAA6RpnAknCjm7+Ow8A7mpo8UjDnxdp+vsxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/M2saWdldyPbm3HIXsBVpyhig8r+SA2cbCt4rayQNMA=;
 b=A9IpBd+hJ/dbQUQMCaxT0kAjoBaUV39uLo8uq0YGpA1bzn0VPJgyEhIb3oyAI/5OknyTv1BsPzVBy6xF/z9xbXKVhN0UHC2u+nxa9FXbL/JXBAKk2ipRZrqnkgwr8Ma/d8OdwNggNndgicqrF+k0jcTYmNWm4lIXSz5KPZARfUHIzG52MiLAgn6baJYaGkVANChWvWPkVjtOv8O/P6F9Mk5JTzIcZjGIeuF1w95M9gtW4X22ss7k6I7qw/UYYd1jTbBUgS413jGsdzJKYGLMVxzkHD3SoVzxa3TRpyLs/17DzIB4uM5QeUOCcI55aBOhM7cQ/oCYFM6nOFnmH11Ejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/M2saWdldyPbm3HIXsBVpyhig8r+SA2cbCt4rayQNMA=;
 b=SfWUKnpjhdt96klaDxa3zA4u4qI5ykcSXLy8t0/JCltLYeBGlsyDcYMUN84kpCWHdwTb9UmzcvF2M5BcfbnkijBaXSrUMkNel+WGY1W+QOTAJ1K70qDlS2WHfQltjQ+ldfGP3W6vS70QTjEyCwA8gda6NCHaUnba7Ri+K4zAaFA=
Received: from GVXP190MB1917.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:6c::18)
 by PR3P190MB0892.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:8e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 16:47:07 +0000
Received: from GVXP190MB1917.EURP190.PROD.OUTLOOK.COM
 ([fe80::459:4a7c:1d69:3644]) by GVXP190MB1917.EURP190.PROD.OUTLOOK.COM
 ([fe80::459:4a7c:1d69:3644%7]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 16:47:07 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: AW: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Topic: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Index: AQHZFHXG5ZybZSxm1UCmHmccrEFA+6522QaAgAAGVgCAABO5gIAAAmCAgAABgmA=
Date:   Tue, 20 Dec 2022 16:47:07 +0000
Message-ID: <GVXP190MB1917FAE75EC2A440A59922BCD9EA9@GVXP190MB1917.EURP190.PROD.OUTLOOK.COM>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
 <Y6HfK7bnkL2uyp3m@shell.armlinux.org.uk>
 <1201721565.475609.1671553321565.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <1201721565.475609.1671553321565.JavaMail.zimbra@savoirfairelinux.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=schleissheimer.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXP190MB1917:EE_|PR3P190MB0892:EE_
x-ms-office365-filtering-correlation-id: a83bde47-14b2-40eb-9f8a-08dae2a9d4f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IzoYKyM31+VbvnV1jWVGOWj+YMYBcC1VfrA4xG0KYnBy8qstDy51Z9pgQo9FsigXvOEILpPSE2W4pGtT4KhF/3MHitR5vEI4tAE0zrO4RqG4XEE2nqZc2kacODj/lK2sZnJhNJDVZHhtmXAp1R+D6+hSS/uxFerXkkTEO/6ktVYSVyWXxNxvo8hdeVvUR+EwbqmK2I1qfbFG68RGasIKkkspn/jIQUhq7YPb5V64cCi0Mw48n3LPe2jQ5mzJDPKfYziFp88hOsm5ti/Qhx8nJU6GrwLXyHdPfYYdzsC1nletNtmfYF9SpFDQbvyID8G7fbzlJeWLg1C3D4wGj0QX2V6yXpYL5fPKgX0focAmr3NQ5egI802rydFC7O+hVG5td+CDJMA+5fvskzzyNeVjrlLeq0CCKCZsys8fRUxw8qhi+sxugv+gylu6USbAvPLVrdenMi1R5jqDhgb+rc3nwTTsAfzYA4qPuhtfhWgLQNcIOA2VCIOiKq+ltJ3msA86dzeyvnVb+iFpUw5Xehi6CNFn7Q9MuVPtTJzcJ49mTeEBkxFen8u0o4yTeVc6VXHYU0TnPkXmRGCtBsC3SU74vfVdsYoY1NVGC/w08OMxmFtL4kSTSbD8LpJyPRcF5G9arWngY1O5iFnBTDOgd/FwHAP5h6qS2NJr4rOJIP6xPDjqoZizURe/ZKD6zzHsrYTMhZhaIkkazgIFdVP/pHbdN0YXBjwTo85Jf4eXgzPpwlg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXP190MB1917.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(396003)(366004)(346002)(376002)(451199015)(52536014)(8936002)(41300700001)(5660300002)(2906002)(86362001)(55016003)(33656002)(122000001)(38100700002)(38070700005)(71200400001)(186003)(316002)(54906003)(110136005)(26005)(9686003)(7696005)(478600001)(6506007)(66556008)(966005)(64756008)(66446008)(66946007)(8676002)(4326008)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWZFMXQwUm5Mb3NlUFRwckZtRUtQZjhhNXYvY29OVHFtbEpJTHhVZUZPdktY?=
 =?utf-8?B?VUNJYm5qZEdCdzBFVG9TbXNWSzdTR0MzWFUzNVB4bHlybm9zT1RiaXc2c1lW?=
 =?utf-8?B?eDB3RE5QSm81Uk9iWTk3ZG1iTmJOQjdYa21CRnFiZWcrV3JKVllsV3B3Rnhs?=
 =?utf-8?B?WFg3SmlnZmhZUTBiSVlRZEVKYXI3Y1VvNElTRXpSK1hOaHlJamRsMnE1ck4x?=
 =?utf-8?B?MlR4RWw4SlhZTXlnMmlhV1pWTXVzMkhueWlxSGZDNjF4QjNwVnROUjdVaHNN?=
 =?utf-8?B?ZG5nSmY0dGJRYllaSENaMXBCcmhQTVBOZVpGcWFhcUVJR2cyV1ZxTG9FQUp3?=
 =?utf-8?B?NGhKalZ2dXlqZUMxTTRWSnVoa2FTU051dDlCU1NDYVQ4S1hwMjJUcU82dGVB?=
 =?utf-8?B?UWM5aDh5RGpaYnI2NTFhT0dheWxXckVYSnp1N1F4QWZsb0lYd0o3dEpaYkM1?=
 =?utf-8?B?NUNpR3dOa1dDb3haK2dWVHR4Rk5nQlUxWklVbzl5bHhkNmUzWWVxcXcwaW1X?=
 =?utf-8?B?V3hHOU1MUXBFaUQwdXlOcjhoclpvN0dudS9WL05xSGJDU2dBbVZrSVlWRjU4?=
 =?utf-8?B?OU5WcGU4NlFhbElTb2daWFNTcnpRTHNtU251SHRQZHV0VnBsbnJGMGZ4QlRx?=
 =?utf-8?B?WmtmdStoa1hzdEcyN05qKzkrSitocVlCZ1NBcXBaUnJnVmUvc3Z6MTA0UGJE?=
 =?utf-8?B?YTMwSktBM0t0M21wdTNTYnJBbmhnc3FFY0Z1ZUtmUUZqRVlFbm1yNUdnNmxR?=
 =?utf-8?B?SGpWUjB5Y25yZllzbWtSU3pETmFYRjdxdWNnZWRJS0tSdk5McmpmMEhzdG5q?=
 =?utf-8?B?NE5nWHJDa1k2ZmZNRjUvVUd3S0gzcThXYkduZmFWMHlPQzZ1NkhsUGJWWURl?=
 =?utf-8?B?ZTZ5OGw4RlFZYnhwZk8yTnJUWUxpUll3dFBYaHNJOUlhUitLaVc1bzB1MjZY?=
 =?utf-8?B?ZHdOT1FuTldESW4wZEZOU3dtUXYvNklHdXl2SENJZ3ZYN21OUzJUS2h0R2hv?=
 =?utf-8?B?MWR3SE96WWVFU1B0UzlEbncwUy9DVzVtOFpzeENwNXFQZDRnenBVZmJWVVhq?=
 =?utf-8?B?M2liOWhDN1NDWUxGbHdNcWZXV1pGV1hTbDFUc0xxUGhLZEpQYVFzVUt2eks3?=
 =?utf-8?B?ZGtlcG1STDVHaWhaQk42MUM0TFBrUmNzNHBuNjI0bUlrczNPTkNTTUN3cGY2?=
 =?utf-8?B?ZS9QTkpNTnFueGN2bThHMFlvemdETmZaUW0zNnBiOGRzTG5ScEpqUXR2OWNK?=
 =?utf-8?B?WHIxZWpNRTI4d0MwOEJOdm1rQVdxT3gvMGtyOFVhL3BLWGdnbGx2bkVnTU1u?=
 =?utf-8?B?T3JBNS9Wa3M3NDVJKzJtWW11Y0hhOER1UlJ3RlhxTnE2aEJLSSsvajh6NWsv?=
 =?utf-8?B?c1RCaGw1T3ZidFBBcHNSaUgyWFVONkUxM1k0aG1NMk1yUzkyM1NqVkg2Z2tu?=
 =?utf-8?B?R2VZaG1GVThpTHZJeG1ld0ExQ2tJUFhsMTF1LzZ5aXI2WVBCOU44OEpXdTVM?=
 =?utf-8?B?bTREMUp4T0g0NDV3aUdGVC8zSENCV2tpcWNuOC9TVExhRDJMMVJzejJ1OVhT?=
 =?utf-8?B?TnhPT01JVG1TVUNFeE9XM1ZwTXNBRkR2bVN0M1NDMEFZWTBtRWt2M20vT29U?=
 =?utf-8?B?YjAvQlJhSU9ldVFPRDkvOHVzZ1RGOWF1OUx3ZWhBZFhWMTdUZTFzYk9wZFRG?=
 =?utf-8?B?cmt6ZVVUZlRSRkxRSVZHT3NPM3A4ZDZRSEM3clY2SWNzWjdQZ1BZVlJWckhi?=
 =?utf-8?B?Zk9TNmQxSXVDRXluU1o2Nmhycy9ONFZHc3RqRTdLYktrQUpNa1ZrYkZBZEtR?=
 =?utf-8?B?ZFhYVGFVMzE5VWt1bTlmbkx5US9GbU5jTW85NDZFemZ2SkhYeEpjODVYeU9Y?=
 =?utf-8?B?RHRLSndwQmhMUmFmZmJpalkvbVR0VmVaaGlEaXAzYWdBRWdPUEJWaEFkcFlD?=
 =?utf-8?B?TXVlL1FtQzNKbXBPMTZBL255QnNxQWtqZ0w4TzZua0o3REVQb05HNjdxcmhJ?=
 =?utf-8?B?S2VVNEcrcXVlVWc4UEFRcjZOK0VnRDVaN2llZjhPdjMvRjBwemF5M2ZqZTV6?=
 =?utf-8?B?bWxKZ2I4T2xtYTJOT0srWldsZHFNU1RtZ3ZqOEdpaGQyclhvMFRxRE1ZY1B1?=
 =?utf-8?B?ZVZnYmE1ZEVGdXVVSkQ4eDdQaG44Q3hrOVcxNmlEOG5URFpXQmY0ZVl5VkJs?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXP190MB1917.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a83bde47-14b2-40eb-9f8a-08dae2a9d4f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 16:47:07.6316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cYpf0JyAFFMxJRp5pt7VE3S6deIoJ1j54h++LFGcqdqcFO4sBU7p8XRrjnU715zZ2SR5s6NjuOnOidMiWxTT8o1V87Fk0YLmFffpYLABq4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P190MB0892
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLVVyc3Byw7xuZ2xpY2hlIE5hY2hyaWNodC0tLS0tDQo+IFZvbjogRW5ndWVycmFuZCBk
ZSBSaWJhdWNvdXJ0IDxlbmd1ZXJyYW5kLmRlLXJpYmF1Y291cnRAc2F2b2lyZmFpcmVsaW51eC5j
b20+DQo+IEdlc2VuZGV0OiBEaWVuc3RhZywgMjAuIERlemVtYmVyIDIwMjIgMTc6MjINCj4gQW46
IFJ1c3NlbGwgS2luZyAoT3JhY2xlKSA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBDYzogSGVp
bmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT47IG5ldGRldiA8bmV0ZGV2QHZnZXIu
a2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IHdvb2p1bmcg
aHVoIDx3b29qdW5nLmh1aEBtaWNyb2NoaXAuY29tPjsgZGF2ZW0gPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+Ow0KPiBVTkdMaW51eERyaXZlciA8VU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbT47IEFu
ZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gQmV0cmVmZjogUmU6IFtQQVRDSCB2MyAxLzNd
IG5ldDogcGh5OiBhZGQgRVhQT1JUX1NZTUJPTCB0byBwaHlfZGlzYWJsZV9pbnRlcnJ1cHRzKCkN
Cj4gDQo+IEluIHRoZSBtZWFudGltZSwgSSBzdWdnZXN0IHJlbW92aW5nIHRoZSB3b3JrYXJvdW5k
IGZyb20gbGFuNzh4eC5jIHNpbmNlDQo+IGl0IGlzIG5vdCBjb21wYXRpYmxlIHdpdGggbW9zdCBv
ZiB0aGUgUEhZcyB1c2VycyBvZiBsYW43OHh4LmMgY291bGQgdXNlLg0KDQpTYW1lIG92ZXIgaGVy
ZSwgd2UgYXJlIHVzaW5nIHRoZSBsYW43ODAxIHRvZ2V0aGVyIHdpdGggYSBkcDgzdGM4MTEgZnJv
bSBUSQ0KYW5kIGFsc28gaGFkIHRvIHJlbW92ZSB0aGlzIGNvZGUuIE9uIHRoZSByYXNwYmVycnlw
aSBrZXJuZWwgdGhlcmUgaXMgYWxzbw0KdGhpcyBwYXRjaCBodHRwczovL2dpdGh1Yi5jb20vcmFz
cGJlcnJ5cGkvbGludXgvY29tbWl0LzJjYzQxY2ZjNzkzMjNkOTBiN2ZkOGYyOGIyMmU3N2RiMmEw
YzMzNjANCndoaWNoIGlzIGFsc28gbW9kaWZ5aW5nIExBTjg4WFggcmVnaXN0ZXJzIGZyb20gdGhl
IGxhbjc4eHggZHJpdmVyLg0KQnV0IEkgYWxzbyBoYXZlIG5vIGlkZWEgaG93IHRoaXMgY291bGQg
YmUgZml4ZWQuIA0KDQpPdmVyYWxsIEkgd291bGQgc2F5IHRvIHJlbW92ZSBhbnkgUEhZIHNwZWNp
ZmljIGNvZGUgZnJvbSB0aGUgTEFOIGRyaXZlcnMNCm1heWJlIGJ5ICJmaXh1cCIgZnVuY3Rpb24g
b3Igc29tZXRoaW5nIGVsc2UuIEJ1dCBhdCB0aGlzIHRpbWUgZXZlcnlvbmUNCmhhcyB0byBtb2Rp
ZnkgdGhlIGxhbjc4eHggY29kZSwgYXMgdGhlIGFib3ZlIHBhdGNoIGluZGljYXRlcyBldmVuIA0K
eW91ICphcmUqIHVzaW5nIGEgTEFOODhYWCBQaHkuDQoNCk1heWJlIHNvbWVvbmUgZWxzZSBhcyBz
b21lIGlkZWFzPw0KDQpTdmVuDQo=
