Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262F84C4AA9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiBYQ0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiBYQ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:26:06 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2046.outbound.protection.outlook.com [40.107.20.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D673D1CDDEA
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:25:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JymIXAf7yW+I5AJiF1r5EJHcr+QTO5MrYzN7jYrNwP0azyIKLbh1ErigQAueJ1ECCOxRKzmPFxFTYhzY2Iat+yvJPEsahYFdfHggcxeQQldlDmL1wTCv66WHlo1TcHv4lFAsICEZWH17P0vRmQlw+2icmGIyz7mJgLU1OPZ9A9mTDv7aIMTwcaeJ/FNgcWQiLnUPlfdiYXK2kjTnsVeqZf+epCGogfQr/iWRNw1FQwv/K88p2ORhN9yR/C97lkXz2+uBqLhU/VNlpLjxzMJnNbl76G5zSEArq2ROA+SGDho3BD9vkpU/rFkZKb/ELRNKX/um5rjJA1C7AAa7Fjn66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9T7euxUkdHnBGzpdFdm8SXEtMiPP7r+4zqti9SMlbw=;
 b=KvICOQsxwBXOL5QnxsfDBtnv+DnfSY4hHqSZ7Oc8ZxuubMFTCVr3VgUBh7rPZJnjSh5Qr/0pqOguaA/WEHlSNCkLQRU0uu76/XG8v5rRVzm088KOLAo41rg6jt/tVqasHjQJs7665UqsH9UzaSFhc01BI1d3kTpBNY0NF4xfQLEHKmR18L4GBGYLjudbiJvxa/Ur1CpsQDQvf5k4gbt7SHaMBndizRTktRa0r5Fu8rE++xOOKLRIQTxJunw0wHAhra3TsCetVkHQ1QGjnZy+5f9UPSOfBoAO18JMC9CSiZR1kvYc6XyWJ8GjhV2GUvwc2n+wRgLVqNyRxUQXo50C0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9T7euxUkdHnBGzpdFdm8SXEtMiPP7r+4zqti9SMlbw=;
 b=Nj4DK+ZYAveE38NXcRxHM+YZZqDZEc6BaKNuO0M0O6y8/H4FnuCx3elPC+P3PtjqDEekpkzDrupiGAI5eGh8xAuwIQDtkywY128Sp5BcYv/WFIL8c27gRU5OIndp1ONCfPJYMhm5AuuQ3PVKU1uTG9EGB4GpurZcssryZJvqsOU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR04MB3159.eurprd04.prod.outlook.com (2603:10a6:6:11::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Fri, 25 Feb
 2022 16:25:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 16:25:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?TWFyZWsgQmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Thread-Topic: [PATCH net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Thread-Index: AQHYKmN6V9QT2X7RfUanwz/gTv10Z6ykc9QA
Date:   Fri, 25 Feb 2022 16:25:30 +0000
Message-ID: <20220225162530.cnt4da7zpo6gxl4z@skbuf>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
 <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ceed346f-57e5-4e6e-d4f7-08d9f87b710c
x-ms-traffictypediagnostic: DB6PR04MB3159:EE_
x-microsoft-antispam-prvs: <DB6PR04MB3159B55BE9949DD81AC96719E03E9@DB6PR04MB3159.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cG4PFkI6qS3loGQ6WHZXFY627n+1biPbYTqId0YYZrC6kgkTtpJSdw8nuw7XsSKdVhPj2HcU/mocRMlOQvHEPBHk2Y55epbdqFKdsylrh1j4OGNyUaWHrBwK2O9I2NBdbNVLGHhbLkbh7p9MKBndApmQ1evjrZ9FaCkzPTieE604I7mtTIFH+to6vQJWRMdGKVMrwj3A7G1/nFgv8TNmWUdPkbKwq+5Yuso470zEqltUxGl4APJx6ZwFVNHRjyct5F7/nGc6KD/zsTbPc+d04wTWHDFs9k2UTMPZKCBRzsAhd4Q1WXC6xrhVdSn4d5vTFmGBLCEvu9nbZqK0QqSn7jRD0bdlN0LybTvTQhLPIpJRvDN3nQgWYNp03v37isUvaltmSkSg3mtVN2mPAZTdGlY3sbryKtDNYspTP8VlnizzykeyDvL8f2r1z81LEF7Nb5eZFj6grYxlB1SfN+ygQlofCoLUsvtTbCS2y1hLLP81Ut+02fu1+Bhf4m1lDwqiEOVMJra4ymVOCDslFvWamm+vl8PeRPMPLu7KJO4v1LDqgNj385qoHovPdMFm1tFLyoygctLighp8vC2Qr71azDJQMs6Ddgxsl2hZ5ChzWVN23kYuVmlrZcTusH5XIKhoLAtQ3Khu/UvqiPBdlp/2qCOg6itpzV3wqZknZmSjQRetU1ipLIkQXVJZmK18WQyFs73s/rb3CxhicQyAcakbRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(64756008)(4326008)(38070700005)(316002)(66446008)(66556008)(1076003)(66476007)(6486002)(508600001)(8676002)(76116006)(86362001)(186003)(66946007)(26005)(91956017)(6512007)(71200400001)(33716001)(38100700002)(9686003)(7416002)(122000001)(4744005)(5660300002)(6506007)(8936002)(2906002)(44832011)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEsxY3R4MmZxaDJEY0RzM0c3TFlPVThRNWpjTTduaXFHZVYzRmZRQ2ExVi9K?=
 =?utf-8?B?ZVM2SVNwaVBHL2o2S3c4MEtMUlZWWUJSV1BXSjYyM2d2dnRiaXJteGhvcjdZ?=
 =?utf-8?B?M2thV2JJL1c4WlJPUUpyejdHL3ZrUVBJOHl3dW9SN0VMblNGdE5iNmtoUFpr?=
 =?utf-8?B?bDVNTUIzUjM5WGRXbUlRWmpjSmFpaFFrRFRLaEM4a09nVWNkUVJuRHByQU05?=
 =?utf-8?B?VkE5ZW1SMUMrV1V4L25Kdi9kMmdNZUlGdzYzdnRMaGtuSVpFM2dHZ0RRQmlJ?=
 =?utf-8?B?KzNmWEt0RnlJYU9lVDY5NVAyYW8xUmcvQ2NaMGFRclhPM0tKWGVQYUpBSXQ2?=
 =?utf-8?B?QnlIVUhKdUJnTDVXVXNJcDRsUEF0ZHMwQVBaUkFhdDhtOTZMT2hKVitPbmhw?=
 =?utf-8?B?bk9iQ2FTT0ZPandsOFVhZDdsZW40SW83RFE5OS83Um1veW5PKzgvYitSUjV2?=
 =?utf-8?B?NnZBdXRMckw5K3RQYitvc0xRMGQySTBjSDc3eGRucHduM0NldGozcVpwd2ls?=
 =?utf-8?B?U0ppM0FxcFlaZHZQZTExaWRVa0t4UXg2Vks0eFl3cGJyYzY4dTIvemFrd2Vt?=
 =?utf-8?B?MURqU2lUOW4zbElBK1pnWkVKcGJ1NEJudmc3RlJ3UEpEVFN6YVdRSHVZK1M4?=
 =?utf-8?B?T0thTldvR3ZGQ25PckRtNHlHTFZ0c2NSbGhqWHArN3VRZFVwTWsvNlh1QUNW?=
 =?utf-8?B?cVQ5aS9NZGFRWktzRXJ6QzIvRjdaMHJOU3JwRjlkMllLUWhYOUVDeG92Rm5x?=
 =?utf-8?B?aGxpSlR2QytEcUl1SzdlcEF5T1BnUW9uNkJjMlFDditRVDV4M2NXbG1NWFIx?=
 =?utf-8?B?L1ZWdGlIYlVpVHhjWGZNLzRWcDEzbUxOTE9QMER1VVMxVmdsWnI0cWZ4ZUdU?=
 =?utf-8?B?ZWVXbXFqb1RLMG1HaXkwSFZ3dGxIK3QrZmE5T0lGY1FzeWdvdzJWVjhqMnUr?=
 =?utf-8?B?a0JZdi91blBST3RQYVk3VnBkQ1RTK1hHdC9VWXJHWlgxZXJ1ZS9BUmw0S0RN?=
 =?utf-8?B?dUk0U1E2eDBma3phTGhvUXhYUnU3dHFwdURvMWE5TXhWM0l6d0Z0aFJwZ1Bv?=
 =?utf-8?B?d3ZFcnM5ek9PdWFFcENsSllIMFY1MS9Za09SOThDT2xWNFJTZTY4a0tZdGZ4?=
 =?utf-8?B?ekFaL0RWdUs4VExrOGhxdEpacDg4a3ZIMTdSNW5oeXBiZ0ZUM1NXak93OGkv?=
 =?utf-8?B?aVFIS0kwUDFsU2Nkd1UrV0taRkQ4dW9nZ1BlUHlFNTlpNlVnd2ZEbXJlNGdx?=
 =?utf-8?B?bG9xSDNMNDhQcXRKbnpoS215ZkhDTkRscU4xMGlMeWg4OGo5RndhZHBRZitQ?=
 =?utf-8?B?SnFWc0cycVVXTlhkOXVub2J0RFZWUG9kai9JNXFwWVdjYkNrYnk4S3JRMDFn?=
 =?utf-8?B?N2phMngxaFBsTC8rYnBNYkVCWWhsdnVVYlpLUUxlRkJjclhPUmZCRDVsdG9y?=
 =?utf-8?B?WGpQd1FKQXMwRWd6UEJwL0lSUmhjRjBFdXlzRHI2Q09uYjVKbG41SEJJek51?=
 =?utf-8?B?SUZweGZQYkZTd28rOURxTnFKbytrOGRtZ245ZUtHSFg5M2V0LzdMeFFUUFRi?=
 =?utf-8?B?endXbXhNTnRIZERtZ0h6T0JUeFdMS0FUdWVuMmgrblBmYkZRTTI2b1R5a0FE?=
 =?utf-8?B?aHczZGRpbFRuQ2pMR2VISUM0WjZFS2Z1R0cvbzFrazhTU0Q4SzJRY2JCWCto?=
 =?utf-8?B?RzYwQ3JYaEtXN2Q4Zldzc01ocysyaW1QNjFXN1NzN0g1MVZTQlo0S0hzZkxi?=
 =?utf-8?B?Z2ROQ2ltVlNXVmtuZUFYYlFRa3BaVGoxNzJMQjFkakpsQlROa05zZXFTWC9G?=
 =?utf-8?B?a3FMdTM3dFdhUnFKNVlaMG1OMFh5dTduN016eXMxWHNKQkk2ZlpJdzhFQ1Bh?=
 =?utf-8?B?Q24xZFRQUXJCTVpDcVZ5dFFORnBQV2hxVHNXN3R5NHpqTXRFUENpWTJ4NFM4?=
 =?utf-8?B?UlRyUGFpZDZ1a3BMK3g1VCtaSVFFYWtieHU2RzBGemw2VDVEMjVNQzEwSTEx?=
 =?utf-8?B?YU9Xc0lsT0MySmZrMGVqWitWT3R0RmFZMFJ4aStHZm8rc254WjROeTRBRVBS?=
 =?utf-8?B?ZDdCazQ1RTJaRnIwQ3l0RExPZktjd3Z4aXZ4MzNlL3M0SmZ0bE5vMVhybWt6?=
 =?utf-8?B?eldPdjVacVBldDlaMDB2UWtmUUYraWpIV0VuQllDdFVOMXo3YUFldFRXODlh?=
 =?utf-8?Q?H2pKzkYvDLbN2yEVUWSGnYtcPUCfOoqVnTkqD8o4RDRT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <844AF777EF46D34488740D4B724E6970@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceed346f-57e5-4e6e-d4f7-08d9f87b710c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 16:25:30.9874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMEcZwu30GVYznkVKq9zXmYu1krjHY9MbsyZFE17rh6EnHArRXc7nzQxUXbGACr7rYAokEYEcU293rToJEHRyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDQ6MTk6MjVQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBQb3B1bGF0ZSB0aGUgc3VwcG9ydGVkIGludGVyZmFjZXMgYml0bWFw
IGZvciB0aGUgT2NlbG90IERTQSBzd2l0Y2hlcy4NCj4gDQo+IFNpbmNlIGFsbCBzdWItZHJpdmVy
cyBvbmx5IHN1cHBvcnQgYSBzaW5nbGUgaW50ZXJmYWNlIG1vZGUsIGRlZmluZWQgYnkNCj4gb2Nl
bG90X3BvcnQtPnBoeV9tb2RlLCB3ZSBjYW4gaGFuZGxlIHRoaXMgaW4gdGhlIG1haW4gZHJpdmVy
IGNvZGUNCj4gd2l0aG91dCByZWZlcmVuY2UgdG8gdGhlIHN1Yi1kcml2ZXIuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3Jn
LnVrPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0
ZWFuQG54cC5jb20+DQpUZXN0ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFu
QG54cC5jb20+
