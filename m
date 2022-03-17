Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB854DCABF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiCQQIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiCQQHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:07:54 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B7214075
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:06:37 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22HA0Xb2020692;
        Thu, 17 Mar 2022 12:06:19 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3et64ktkt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 12:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOjXzy3o1YBqCYE3zupVDQR3OLUyufXt2tIC3vF92O85udZ1DSjRwH2zgBbOnmS1g2yoKjCz+LX1PS1rtfMzajg6IIOMyOuxRlQnqVJ96fQNZdK1E5JkMR7uyu1osJcEn8x5vqnpJ+uxoKE7Yi3zhoMN5wsJfhDhPZTjsZB1saj95oQ/KySRLj2pkX1jBjj6b7tsRwUSAUf3gxy1zd5p9HF5F82gaPQXpg2j063CHyxKq7jMA+tt07CUPwPKqc/oXUiZ0+8aNN6vHU3MWkq8QqYXGMPdPghF33q79IcnfSBB5q8fsOVLqRjTTnqqS4xvCYdsY1Rzuiq40dpEH6OoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qskhwHCNrhn30P4FIrDYw1+jAzPcEU06bdnxZ7MtZpo=;
 b=Rz6ecE8c1m7RQU5O/tRv3dl9vJWMTHoELuq5qjecv1g4X/zAZlf+8ZyXI0xjfyhV4+eBYvY0XtWSJws68PRcaZ8TTupJO2TahJDpeXB6lMYA6fi0UUm7PmuafWGn5+oS3S0WHsfQ6o4nlOob5oQzBQnJ8sRBhtBfpCokrbvUoeKGkhUMQH8fN/cksmWQCrudUOaeog7JXsPjsvrqCi3Vovbb1Rh+JTL2c9OuR/Y+62ofpP+SToaV5EAUEJ1OBUO9jkMzNbz1BoxBf+yPO6f7/knm5p3u/ZypoO6arYFz+kUAJztBiQkIVfRmf7FB5f9sN3zDtTYSJii191FQaMo56A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qskhwHCNrhn30P4FIrDYw1+jAzPcEU06bdnxZ7MtZpo=;
 b=mlPxmxqIkYu6+amsY43vmMyz50bGQE1ebjKjrUx26XR5nok7NFjgdaOiYhsv/QFmWJKv5NbUkKqdQusmG5KxzDe3r83lCNCVvkr6K4Y7oLDG1xE6Y8mIl3QGT6LJIBaPrXIvy8kDmncTbd10N7VXAAH1pL74VmQgM5jOCvUHvuA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB6090.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 17 Mar
 2022 16:06:17 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Thu, 17 Mar 2022
 16:06:17 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Topic: [PATCH v2 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Index: AQHYOeBenngk9+RYokmqKO+eu5OSmKzDWH+AgABlnAA=
Date:   Thu, 17 Mar 2022 16:06:17 +0000
Message-ID: <27534eccd05cd035773c1a4f1ea55fe6bd4a3f48.camel@calian.com>
References: <20220317091926.86765-1-andy.chiu@sifive.com>
         <CABgGipUd67TSoPz3eeKf2kXzzwy8NWJMkGYtkikdcBKiaJd8Bg@mail.gmail.com>
In-Reply-To: <CABgGipUd67TSoPz3eeKf2kXzzwy8NWJMkGYtkikdcBKiaJd8Bg@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 374f8dd0-54f5-4f37-8efb-08da08301192
x-ms-traffictypediagnostic: YQXPR01MB6090:EE_
x-microsoft-antispam-prvs: <YQXPR01MB60908311BD1D73E2A46C8EA0EC129@YQXPR01MB6090.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bF3F0BeP0VOH0F+fg9jiaUvJ6WqXe1Qg+Zc7hQao4QiwwVnJWTIPzSBYG+8rvntpX20JqyNsmkE3i6DK8ggX/EEeogd5+zW8xtenhKfZ2kRBJKhS0Jany7LsMMAcCq/PYRPtGSH8g8ftel/2i7K/rWMCdBbgreVf8cRmDyRUnxFxLqVDF6qS2XjKbsxZ+GXx5JWBmICIX2sDLx1h5mTnSXVcf4Pm7PXxODC1XC98Zm3WjJj7CsxCBZHvGJFMA547dClKixpMJaC9QVpzWDYvUBfGH/cYTThyMIHl0dtI7yAAhhKCwtGuX/qwy4aSHmzmZH/pJiIhNazWPBQEuvRsSOx/NFXADA5X0mZ9383IfICb6GSuzMYVMVs3y6H7h8Mou33K+KwzFXn/LoXG+bLd2aqQXb+SvEoe5zc3UvEsoL6cwZb7VBoJ8hcUX7skaoxEdRupTphcsEQ4oJ+1vPbbW3DA0b7t2cpTFcLUXMVrUYfw76y20C43MkSm+Nkjqp5rRV1BwVtBM97zsp21FAMotROMnByfplU7k8o+LPgDoDfoo05A+kgbkUyIwE/Hr/tlxyaRRwKEMZQvKeMPDxAoqaZO/OQVL5cRQz1M6/wAxNEEGjWokOT7dKi8RPbj6K7kd9VZ7sEpHvJExgRQcDbRvkF08jn8J+mUlI9L2KGJ1zcM2NDriqaVQLVme0wKuHx+Zpn1jsQsbk5KOGHkZT+jMiGnt2Gpd/a9vtHF3ydLkd/yqiOs8xVIk2bKlzk442xUXkAyw+DA60n9IiLDF2iM28MsipzGr9gmXsJIICvybbwArPcmMSm5bGo8xcEg5q17+VOzKVs2j6sg8SE6lv9RmtqKZSB+gK4X7HHGnAEBy7E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(2906002)(508600001)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(110136005)(71200400001)(6486002)(15974865002)(86362001)(36756003)(6506007)(53546011)(2616005)(6512007)(91956017)(316002)(83380400001)(4326008)(26005)(186003)(122000001)(38100700002)(38070700005)(8936002)(7416002)(5660300002)(44832011)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGR4SVJVUnJVQlJUWDBSNmRsbmtENzQvSTEvdmJqa2h0cVA5Z21lM3BVVEFF?=
 =?utf-8?B?bG5xZEdVc2NmbCt6OTFIRXNHOWRNRE12QS9reDhITFc3Skk4Y0dNODB6YTd6?=
 =?utf-8?B?M0hibnBqRm8vb2ZPdUQweVBDdWdlVjQ0azFUQ1dQc0pzY2J0MVUwRnBPbDdp?=
 =?utf-8?B?Nk1vM0w5MEI1cUhta0p0bGtrbngxOEc2bXVEd25VVVdsQmpPMTNsODVCbGZN?=
 =?utf-8?B?L2VzT2t6NTVGczVuaFRVUHZWenNGbWxPWll6djFmcG8yY3Q4Qkhja1QzQnpn?=
 =?utf-8?B?S0RtUk5MT20vYkdzVmU0bjI2QkYrK0JNSDYrYVlIRkpXQndtZGVwUGo0STIr?=
 =?utf-8?B?UUNtdVk2ZllCSXYwUm1LR0tHQUJ5MnM2SzcwQmttazdQZzRWZzJOS1RXcXRS?=
 =?utf-8?B?dE4zL2V1OXlLdnNzblp0R0wwTUNVUy9kN3RVbEg4YytqVFc2UlJIR2VHRmJW?=
 =?utf-8?B?NmpodzFVd295a2xaZXVyVDRrNDF1cEJiVXVKNXMrOUdaUG9oRTA0LzdFRjJ1?=
 =?utf-8?B?UHJRVWpGL2FCK3I0UWFKS21zR0FMdGJDNlZqSkFhbmJCK3RpTHBvcDUydEU4?=
 =?utf-8?B?S0Y3TEY3Q1M2WURKRnhDN3h6RzRmZWVpUkg5cERnbW9iT0Nwc3NrMEx0UTVD?=
 =?utf-8?B?U1VOZnZSSXRWbHdWTmxnenJTVDdxKzBGeGs0NWwwZlR5MVRMay9CQU04K3hQ?=
 =?utf-8?B?MGx0Kzl4c0dPNGl5bVhuZElpY0VwdVh3SVB3dlVGRzZIOEpUaGE4eVN6Q0ZK?=
 =?utf-8?B?cU43VnZudzI0T2g1RVgzeitmUlRaeHB5ZkE3N2N6cDlhYUNYZWdCZzhPU2p0?=
 =?utf-8?B?UDZmYWNrUUQ0TFRQSi9RMlNzUno1UnNobUpvZHFSMUJnUjNOMWRmZkZKa2NR?=
 =?utf-8?B?d2h3VGFHcWp2OE5icWk5b25xQUJ6OExPR09uMkdYR1hUcWxOZTNkSFRSMWwz?=
 =?utf-8?B?T0xpaFZXS3JsdnFLZEtDR1BnTm1nZm5LM2lqZGlJdFJqcUo5elF2QVlZUWN4?=
 =?utf-8?B?d2ZmTGdzTmxiRU5SUUhNai9LU3plT0xYdW9RVE82YWdhNEZYMGxaWHhYTjZq?=
 =?utf-8?B?L05wNzhFdEQvRlQ2eWhJTlU2Tkd1QzFDQXM4ZloydGo4TW9hZ1U4LzNhamda?=
 =?utf-8?B?U3Rld3RhMjhWK1BEd3VmNDhmUXBrWUZFR3J4cUlIUWpCeVhnVHY4T3VEZlJm?=
 =?utf-8?B?cUx3SkllVFEybzhseVpxK1VOTVZCWmNWRHhSNU4wM1NsUEx4VEVYMUJ2L1Qw?=
 =?utf-8?B?T1pmZzRIVzBPdU5zTld2QUF0L0ZRczZVSUF3d3BmL3prODBFVlE0MUlUdFVK?=
 =?utf-8?B?cTB3aTVZaHI5cGVmc0pIVmhxTmxXYWJHekxBT1VJNDluSGZ6UEZ4TkVCT0lG?=
 =?utf-8?B?OEJnSUlLQVI0bkVlZHV4ZzQ5ODA3ekVxeG10ZkVsb1RsMkloc0pJQkxQUlhH?=
 =?utf-8?B?b0JMTTg0WjV0alNaMjlZWGx4Q3ZybVNRTnZEREdMUUhFTXhFdDBzeHlhcThs?=
 =?utf-8?B?a0U4VlhuQUpiRXEvM1hlL2g3TGdJZDlsYSttaEVoR1FhSGYvOXRsaFF0alBU?=
 =?utf-8?B?RXcwRmRhaXFsTklxMzlOLzNVdTNnVlo1Q2pLaGEvTEVjTnRhbnBYZEo1ODRU?=
 =?utf-8?B?U0M5VDhwZE4wNGNITkg3SzBGYWZJY3c2MDJKbHZRSnVsUVpCSUtJMlJDZnhO?=
 =?utf-8?B?N2pxSnRYOTNBdk5KKzZBeTZYd2xXb3N4MGJ1U2V6eTA4eFM3YnU5K2RoeUtS?=
 =?utf-8?B?OHlVNzRBUE1qVFNjbXJGLzlQSTFaNy9EdUpjd0ptUDU2eEk3cFc1U1B5QWpt?=
 =?utf-8?B?OWN3em5TUU1WN0dJRUVTb20wSW44VkFDQUtsWVBqM1hpaG9hSXpuVzdqOCtE?=
 =?utf-8?B?bGdpMWtnNjQ4MDhYOUlpRjNWTWNZWmxmelprTm5MN0V3REg0cnBWOUc1N2xp?=
 =?utf-8?B?ME5yRW9nN2QzaGZjb3JMNkFJQXlQUHI2RXZ3NjlUd2wvS2phT1RMYzFDblR6?=
 =?utf-8?Q?M8Xd3rnxTX9uZhb/txhHYkqzPl0byc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C2D0CA15734534C929CDFE8B1BCD785@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 374f8dd0-54f5-4f37-8efb-08da08301192
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 16:06:17.1679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tgGsN+N4u0p24GcvaVlphVk1DQpFyjxK/H1QS2UaihMHT2lQ7y24hLWsNwrOrgLqaiIjD+lmkTc1//vSwIHKfy3GRFrzv8nS3ZOr2wn+NtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6090
X-Proofpoint-GUID: 7H46MEhM_I-oYzbEjbfn5iYGzMt3BcQB
X-Proofpoint-ORIG-GUID: 7H46MEhM_I-oYzbEjbfn5iYGzMt3BcQB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_06,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAzLTE3IGF0IDE4OjAyICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IGxv
b3AgaW46IHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbQ0KPiANCj4gDQo+IE9uIFRodSwg
TWFyIDE3LCAyMDIyIGF0IDU6MjEgUE0gQW5keSBDaGl1IDxhbmR5LmNoaXVAc2lmaXZlLmNvbT4g
d3JvdGU6DQo+ID4gRG9jdW1lbnQgdGhlIG5ldyBwY3MtaGFuZGxlIGF0dHJpYnV0ZSB0byBzdXBw
b3J0IGNvbm5lY3RpbmcgdG8gYW4NCj4gPiBleHRlcm5hbCBQSFkgaW4gU0dNSUkgb3IgMTAwMEJh
c2UtWCBtb2RlcyB0aHJvdWdoIHRoZSBpbnRlcm5hbCBQQ1MvUE1BDQo+ID4gUEhZLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEFuZHkgQ2hpdSA8YW5keS5jaGl1QHNpZml2ZS5jb20+DQo+ID4g
UmV2aWV3ZWQtYnk6IEdyZWVudGltZSBIdSA8Z3JlZW50aW1lLmh1QHNpZml2ZS5jb20+DQo+ID4g
LS0tDQo+ID4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGlsaW54X2F4
aWVuZXQudHh0IHwgNSArKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQveGlsaW54X2F4aWVuZXQudHh0DQo+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L3hpbGlueF9heGllbmV0LnR4dA0KPiA+IGluZGV4IGI4ZTQ4OTRiYzYzNC4u
MmE5YTNhOTBlYjYzIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQveGlsaW54X2F4aWVuZXQudHh0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQNCj4gPiBAQCAtNjgsNiAr
NjgsMTEgQEAgT3B0aW9uYWwgcHJvcGVydGllczoNCj4gPiAgICAgICAgICAgICAgICAgICByZXF1
aXJlZCB0aHJvdWdoIHRoZSBjb3JlJ3MgTURJTyBpbnRlcmZhY2UgKGkuZS4gYWx3YXlzLA0KPiA+
ICAgICAgICAgICAgICAgICAgIHVubGVzcyB0aGUgUEhZIGlzIGFjY2Vzc2VkIHRocm91Z2ggYSBk
aWZmZXJlbnQgYnVzKS4NCj4gPiANCj4gPiArIC0gcGNzLWhhbmRsZTogICAgICAgICAgIFBoYW5k
bGUgdG8gdGhlIGludGVybmFsIFBDUy9QTUEgUEhZLCBpZiBhIGZpeGVkDQo+ID4gZXh0ZXJuYWwg
UEhZDQo+ID4gKyAgICAgICAgICAgICAgICAgaXMgdGllZCB0byBpdCBpbiBTR01JSSBvciAxMDAw
QmFzZS1YIG1vZGVzLiBUaGlzIGlzIG5vdA0KPiA+ICsgICAgICAgICAgICAgICAgIHJlcXVpcmVk
IGZvciBTRlAgY29ubmVjdGlvbi4gVGhlIGRyaXZlciB3b3VsZCB1c2UgcGh5LQ0KPiA+IGhhbmRs
ZQ0KPiA+ICsgICAgICAgICAgICAgICAgIHRvIHJlZmVyZW5jZSB0aGUgUENTL1BNQSBQSFkgaW4g
c3VjaCBjYXNlLg0KPiA+ICsNCg0KSSB3b3VsZCBzYXkgcGNzLWhhbmRsZSBzaG91bGQgYmUgcHJl
ZmVyYWJseSB1c2VkIHRvIHBvaW50IHRvIHRoZSBQQ1MvUE1BIGluIGFsbA0KY2FzZXMuIHBoeS1o
YW5kbGUgc2hvdWxkIGJlIHVzZWQgZm9yIGEgZml4ZWQgUEhZIGRvd25zdHJlYW0gb2YgdGhlIFBD
Uy9QTUEgaWYNCm9uZSBleGlzdHMgLSB1c2luZyB0aGF0IGZvciB0aGUgUENTL1BNQSB3b3VsZCBi
ZSBqdXN0IGZvciBiYWNrd2FyZA0KY29tcGF0aWJpbGl0eSB3aXRoIG9sZCBkZXZpY2UgdHJlZXMu
DQoNCk1pZ2h0IHdhbnQgYSBjb21tZW50IGFzIHN1Y2ggaW4gdGhlIGNvZGUgYXMgd2VsbCwgd2hl
cmUgaXQgaXMgcmV0cmlldmluZyBwaHktDQpoYW5kbGUgZm9yIHRoZSBQQ1MgYW5kIHBjcy1oYW5k
bGUgaXMgbm90IHByZXNlbnQuDQoNCj4gPiAgRXhhbXBsZToNCj4gPiAgICAgICAgIGF4aV9ldGhl
cm5ldF9ldGg6IGV0aGVybmV0QDQwYzAwMDAwIHsNCj4gPiAgICAgICAgICAgICAgICAgY29tcGF0
aWJsZSA9ICJ4bG54LGF4aS1ldGhlcm5ldC0xLjAwLmEiOw0KPiA+IC0tDQo+ID4gMi4zNC4xDQo+
ID4gDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlh
biBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
