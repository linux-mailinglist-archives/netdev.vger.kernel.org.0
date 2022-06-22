Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE965556E83
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359098AbiFVWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242135AbiFVWcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:32:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E243EBBC;
        Wed, 22 Jun 2022 15:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYrXGTbDAx12Cz6ItLjA4/5bLafwQo3Rmja2WVm3C45uRuqFsK6C49shAsnF94jYP8ZyqzRxU989e6vorGt66SbFHt0ek+iVhgT7s89CuU+VmbDTRUyPUeOdHzw0DAGrxsQTaBrtpxpGpWypKT/bHeThjzhNQplQB7pkzqEWrBayWsT4mtNPmNuprAAT9j0p3K9T7UofQFck6+VBvlhsfoT3VXkKlY7dChR4FhWXNliU37WEDS0LMpq4DAJWSlhkrW+8ffTA1fVMJ8feqOZgG5lFgMNf9SrOalwJ2JjY8eDt3b4QMy1plLZrsQv4Oo0WYifziHqrWNr/nuQVWSSB2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYNteLc0oXHmmhGb51wXEs5y3AJN6oRkC/UAfon/T0M=;
 b=HW/CZckAqpDuUwKPvix69JCCL6kgMIw/YchcDl8DCGOSRe79B+8eY1AzS8WvcxhyPpfPtG3NEu7dtPrH7XjD/Uqy3QIxUVhqqNVfbaT/n7fIrjbRkqSwZRJacLV1S8Is4UrgwpXA2MOPbivaLlZNcImRatvGqql/CZlGRt63+spAJq4vS/cm0lbl5E8dmcZsDKDMh4XRpv44kPqJiwYbDU0lhhgafEZZbUQpaEs3xHiaoTC1CU5icQUOpgEi8sagRP/mhLw99+HeXlkVPn7kq3hR5GuDuu0+UY/0UjOqid7OIp3IYuELDLvhfDkO0OZijLN7ToTQJFH7nE3EGwu/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYNteLc0oXHmmhGb51wXEs5y3AJN6oRkC/UAfon/T0M=;
 b=GhtKPm9aiQ7GlDSGs4wsxeRhWo6laiMywJ8QTnnH2leiIgKpr9qhUbhCefSyytqFiZwvshLSblxXpDh44w29MN5JpAbpYJzO5+OeJYKXhXtelcUp+pATrUbfGoZIq5btSxu8gmRSyT7cYHfqo/r6xzKAYlZlXBs9z2D4P903b74=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Wed, 22 Jun
 2022 22:32:06 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::71af:d414:52be:d531]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::71af:d414:52be:d531%6]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 22:32:06 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>
CC:     Sascha Hauer <sha@pengutronix.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v1 0/2] Fix console probe delay due to fw_devlink
Thread-Topic: [PATCH v1 0/2] Fix console probe delay due to fw_devlink
Thread-Index: AQHYhoNTqpdzQgAFwEqvJEpPmUMPoa1cAlLQ
Date:   Wed, 22 Jun 2022 22:32:05 +0000
Message-ID: <DU0PR04MB941733BFD323D3542B7F75A888B29@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220622215912.550419-1-saravanak@google.com>
In-Reply-To: <20220622215912.550419-1-saravanak@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f247e3f-a76d-4d2f-0d05-08da549f0959
x-ms-traffictypediagnostic: DB8PR04MB7114:EE_
x-microsoft-antispam-prvs: <DB8PR04MB711465B6A0588A7508E2A74788B29@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3bXUSghbJcAsnTF3KmCzAfEvamP2+yBqlkuLyN1hso3KPDfOC3bEKEJGiYZV6j2esPpYoEB8XLLRP9af42MdnL+awhpGILtC4138xmXkpwkFg9zSx8L376By125Fw2vOBfdxKFISObgL+0Z+8F87nQ7kgzAi8H+BCCLRgLcXVhvmS9gAwtCmM5n8ufv3GRxtvpLpXAsEIpp+JvIKWg00+l9kbZHXkOR8g+MN5pUQQjJLq/IHoTtvfQR9CmpwdA+2EuxqnuDKi8A7njaIjg9ANLF1v6+lZqoz8z464qZ1fgb41cpkE0Crcnapeo7P2lnzPk3Ux7OeV5Wy3WTGnfgUgLwH92VrctC53QovvNSYB8Dew3QYovhHTSRilsLXLTUiO44bjnANNxzc+Lz3GlJJw3bhLkcAJ+Shqvaw6ElkFr46cGKQHvNrfLqvr6Je4r8lyDji/TMxJZVn+1+olV6vsWFYnnsOu/FM76kzMipBRQp/lP+MmLDz0NornmTeZjS0B2LBNqcdED+zvvoPfuXvhXkVFsMv+Y49Av0gn1IX8REMwxuSexQ3HJ9AIB0/zhhIaMbU52sIqayXuohe0SW+Wkx/mWqwmTxUvODio2tPl7Iqi85XqHAaY9EVZp2AwSdYCxvI+pN4qdU5mw8gsX2lQuDJfEh8Kmr7hKKBGY5J7SP9OZ1Cs4yTeDNtjHq7uFCYqEYHsPntP1du+levYwOaiDvf+PpBc2MpZdTqEADaJiKU7LcqXSn5rkii0Nv7nA0BUHrFR7NA1mE1R62r3q7GhUIXZ6bXkNp1Yllv59n/Mo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(186003)(7406005)(6506007)(76116006)(7696005)(55016003)(5660300002)(7416002)(8936002)(83380400001)(71200400001)(38070700005)(44832011)(66556008)(122000001)(8676002)(110136005)(2906002)(4326008)(316002)(478600001)(921005)(54906003)(64756008)(66446008)(26005)(66946007)(38100700002)(41300700001)(9686003)(66476007)(86362001)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHowOWczUWcrUVRQTHhqdWxMbW9ZcVBHb1lsUEZENC81bGlnQmhram5Ya0du?=
 =?utf-8?B?YmhMdEM5bVZOSjQxZHhVbWtxT3plbC9VeGowblpVNVk0ellEcVExNDdaZDY1?=
 =?utf-8?B?Y1J4ZVhyY04wcktQNU5sWG1IeEd5QWFpY1lqV0wxWnpsRDJGRWJyZUZOR1d5?=
 =?utf-8?B?ZkZGb0xOTmVsMm8zaHArdTlnSHVLcGh0SWxHZG8vVVc3RzVuR2tVSnRIU2l5?=
 =?utf-8?B?K3hBRmZIclhNYldyT1kxeExzQWdOdXEza1ovb1Z4R05HWS94YjY1eXhDYTNz?=
 =?utf-8?B?Qnd1RG96dGxpdEFKdW5WK3JuWDFWSGRjTmFhdktpNWE4VXYwbDA4UHNCNWp3?=
 =?utf-8?B?RnZHa1RQZEQyMWJIT3hrQllMeC9GVHg1eFBuRFNydjlESmV3MEtwRXBOUnkz?=
 =?utf-8?B?L2d4bDBCRjc4cjNCVUZiUzJMT2dabU40c2NVM2VaNCt2OGdkWDZaYmtMY1Nx?=
 =?utf-8?B?SU9MMzZ5YzQ2NkthVVNQdEZ5TjRWMDF0WUVROVIvMS9kUDJHeFh2MkE3WG9t?=
 =?utf-8?B?MGFRN2tkR0pJL3ZVRkx4VmpDVUJUd09DcVg3TzlxTnBjV1F6UG8vVmp0dTFn?=
 =?utf-8?B?Q292Yks1SHdTOUpoQnlPWENoTFdVVEZwRXgwL1cvVk5QWittTE1XU1pveHJI?=
 =?utf-8?B?VStTbkp3WWZxVWJNNEE0UmxObkFieE9mdGsxbkNoTXVIYytpMWpCeU1RTGJW?=
 =?utf-8?B?Y01hUU56dEtZQ094RTZUWXlNdzhZcEduMGVhWmlDYjBJRTdBTXYrQnVNMjAw?=
 =?utf-8?B?MDJFcEJoZVB5YTB4Mk5aZEg4Uk1IaHlmTTQzRkovdFpXRzBObHUvL1k2VkZV?=
 =?utf-8?B?UVhjR1lHOGhlRGNuVlp1dXE5RHg0RTc0UXRNUGFPY3RyTis2bTFHOEU3bVFV?=
 =?utf-8?B?MGdrTVVnV0NwTW42SGIrZ2FnSnVFYWZjVmtuSU4xU29QNnlUbEp5cXdoWk5u?=
 =?utf-8?B?dThmSGtnblRVL1AxT3FVVW1PZCtqZlZoSlZDRGEyMnYxTFQ5ZkFyNThuRjRq?=
 =?utf-8?B?UUp5bGRMb0Vpb091V3FadGdFV1lFQk9XQnVFbTVQMG5Salc2cjNhRXNrajAr?=
 =?utf-8?B?Znh6bzQza3FJOC9UdnZQR01STzhmS3p4SVJOZ1oveXVhQ3NNK0w0d3AvUGtT?=
 =?utf-8?B?Wi9pOHZxcGZEYUFZcVpYcWkva3BybWNMSjJ0T25GWWpyeGxPdWZ5Zkh1WlBO?=
 =?utf-8?B?N3dFUENRMmRoYmo5SHJWODVaN09IS1Nib0IwUk5YY1Y4eEkvaytPQW9IUEZM?=
 =?utf-8?B?VXNmdGpLcGZKTFZnSlo5VmpIWmlPNXZONFlpSGplUlFhUlM5OHVjYzVneXU5?=
 =?utf-8?B?dEpvc0xvUS90VU9rWEZ5c3dzVExyTndNK1d2emFpZENHU08zTEZlei9sc1E4?=
 =?utf-8?B?dElUQ0hGcDdxbFhkaHovVEdiTUp3eDhQdmtRbXpDbFk5b2lZNnNnRDBCdWw0?=
 =?utf-8?B?T2htRWRib3A5WEZ3Z1VHZkVicnZCTkpmWTN4TUJxZWFYZjBObldRNjRIdlZK?=
 =?utf-8?B?UzhvNVhjcmtFVnJ2cEVHY0s1Z1NiQmhOZy9jZmlsT09rWVJDMUdkclZHSDlp?=
 =?utf-8?B?L2dWZDZTRGxONXlHZkYxVzRuTkFxbXowZ01GMUtUYVlVUXhRYnYvWU10T3Fs?=
 =?utf-8?B?cWFBWUhsd1JVdEl2cVFZQW1Pa0dkMmtRZmVuWS9QYkNUS0o1OVdyZFZVTWk5?=
 =?utf-8?B?ZEhkRkNiQnBDWCtOUUNMNzFaYjkvYSt4bG5jdUJwQWFzRVk5bXh4SkhOU0tZ?=
 =?utf-8?B?YmRWaVBUT2RaakNIWGJ5eUFMT3FQaXFZR01LZkJydmZXellOeGhvZ1BQUzlI?=
 =?utf-8?B?TnRWK0RIL2hhT2lBaE04bWx6SHJNRkdWN3o5aStHRVFJYndWdXFCK28wR0dp?=
 =?utf-8?B?RVc0cCtMSlhpYUtvNlVTRHlUcE5TUUVXTTNaRU5iSTAvSGhuUnorVlhRQkdi?=
 =?utf-8?B?NWdlU2pZWlpnUWplZEtpcHJieG0zbWk5VnY0KzBQa0pOaFZMaStHNHBWYXdO?=
 =?utf-8?B?SWllYjg3WTduaVNJSUhrZFlMRFhSTDhGQ2VJOFRJWW9valoxbWhPYTlqalRY?=
 =?utf-8?B?UldZS21hVEw1all2aFVxaWJwNTZ5V011aTNDZFZkd3hOVmVpT2pFbU1OSVpi?=
 =?utf-8?B?U1c4WitEMVNlY0M2NStkU2hSUEdlcko1djZKUjZkWjh6cFllOTc0ZlUya2hO?=
 =?utf-8?B?S1RyNy9rNXM3T2lRTGFIby9PNTRGbVl5dyt2MEpzcnJNSnArMTJnWDR1UWkv?=
 =?utf-8?B?dVdFWEJxSDFKYUMvUjRLNTJtYlNaY3hFWmZ3b3pFVFpnRXhVbzBJVjQ3YzBB?=
 =?utf-8?B?Nk9NdGhBY2xWNjA1ZE9lT1BBb1BNdVYrK1VkWDZSSGl6S1hldG1wQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f247e3f-a76d-4d2f-0d05-08da549f0959
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 22:32:05.9241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZM9n+CNU5DqHelOP1YQ9aPpCJ7ZrwMd8Znd1zPtiD7Hm47aP5kEL74+egByiHxa0O4/mxS0uTCOBKudXR/4m1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggdjEgMC8yXSBGaXggY29uc29sZSBwcm9iZSBkZWxheSBkdWUgdG8g
ZndfZGV2bGluaw0KPiANCj4gZndfZGV2bGluay5zdHJpY3Q9MSBoYXMgYmVlbiBlbmFibGVkIGJ5
IGRlZmF1bHQuIFRoaXMgd2FzIGRlbGF5aW5nIHRoZSBwcm9iZQ0KPiBvZiBjb25zb2xlIGRldmlj
ZXMuIFRoaXMgc2VyaWVzIGZpeGVzIHRoYXQuDQo+IA0KPiBTYXNoYS9QZW5nLA0KPiANCj4gQ2Fu
IHlvdSB0ZXN0IHRoaXMgcGxlYXNlPw0KDQpUaGFua3MsIGp1c3QgZ2l2ZSBhIHRlc3Qgb24gaS5N
WDhNUC1FVkssIHdvcmtzIHdlbGwgbm93Lg0KDQpUZXN0ZWQtYnk6IFBlbmcgRmFuIDxwZW5nLmZh
bkBueHAuY29tPiAjaS5NWDhNUC1FVksNCg0KVGhhbmtzLA0KUGVuZy4NCg0KPiANCj4gLVNhcmF2
YW5hDQo+IA0KPiBDYzogU2FzY2hhIEhhdWVyIDxzaGFAcGVuZ3V0cm9uaXguZGU+DQo+IENjOiBQ
ZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gQ2M6IEtldmluIEhpbG1hbiA8a2hpbG1hbkBr
ZXJuZWwub3JnPg0KPiBDYzogVWxmIEhhbnNzb24gPHVsZi5oYW5zc29uQGxpbmFyby5vcmc+DQo+
IENjOiBMZW4gQnJvd24gPGxlbi5icm93bkBpbnRlbC5jb20+DQo+IENjOiBQYXZlbCBNYWNoZWsg
PHBhdmVsQHVjdy5jej4NCj4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0KPiBD
YzogV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz4NCj4gQ2M6IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gQ2M6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+
DQo+IENjOiBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az4NCj4gQ2M6ICJEYXZp
ZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBDYzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCj4gQ2M6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gQ2M6IExpbnVzIFdh
bGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4gQ2M6IEhpZGVha2kgWU9TSElGVUpJ
IDx5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZz4NCj4gQ2M6IERhdmlkIEFoZXJuIDxkc2FoZXJuQGtl
cm5lbC5vcmc+DQo+IENjOiBrZXJuZWwtdGVhbUBhbmRyb2lkLmNvbQ0KPiBDYzogbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgtcG1Admdlci5rZXJuZWwub3JnDQo+IENj
OiBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZw0KPiBDYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogbGludXgtZ3Bpb0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbEBw
ZW5ndXRyb25peC5kZQ0KPiANCj4gU2FyYXZhbmEgS2FubmFuICgyKToNCj4gICBkcml2ZXIgY29y
ZTogZndfZGV2bGluazogQWxsb3cgZmlybXdhcmUgdG8gbWFyayBkZXZpY2VzIGFzIGJlc3QgZWZm
b3J0DQo+ICAgb2Y6IGJhc2U6IEF2b2lkIGNvbnNvbGUgcHJvYmUgZGVsYXkgd2hlbiBmd19kZXZs
aW5rLnN0cmljdD0xDQo+IA0KPiAgZHJpdmVycy9iYXNlL2NvcmUuYyAgICB8IDMgKystDQo+ICBk
cml2ZXJzL29mL2Jhc2UuYyAgICAgIHwgMiArKw0KPiAgaW5jbHVkZS9saW51eC9md25vZGUuaCB8
IDQgKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IC0tDQo+IDIuMzcuMC5yYzAuMTYxLmcxMGYzN2JlZDkwLWdvb2cNCg0K
