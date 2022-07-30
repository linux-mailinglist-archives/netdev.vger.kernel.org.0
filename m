Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354EE585B44
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiG3QX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiG3QX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:23:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80041.outbound.protection.outlook.com [40.107.8.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A113D36
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 09:23:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjFRwn9Vp9QzvXq1VnkX+dHS/2ULF/bfomuDMcKoMAq/6aEItZEW8gr+K7V0fe03Ba21QWJG+GCEQQiOOT0NfLemFmFhrYERJSpOHHLHdvpycR6DHEPdqHBj4Ge/KYV1PRuoLYd+N3L3w9JlEZAt91A6C229jfJb2q2YJLCHoD0ZYH9ovwj8lVvcHJy3ZkmTDpgdi/tq2AxO9xo06JEJjp3MqvTD7Rm9s8vcyko0rg2uU/dIgRtHGWf+DWNtyh1sWxA2Ghk8qCwD7oCc65DO6frsC8cDEOf0sRVCDGdAON2FKcysmoyru7hWQfso42KhSCvsLsFeCgu5X1VxgB7xmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIyMzcl7PH8Q0gEzwghvpQJWOXbU7JIbpHpHxIWDZ0w=;
 b=WK8eOZ+gtYPKGsKBAfZ3bc0JUfS9nIzIQrhYK2mPqr3rTF/C69MK5wMOfZWOk5OydpvMeZdg9VHCZ9IT5ZjpNATUc2aOvKtsUHmtOB9d5xz7ZKXcm7zz15GbDBwYwd/6NJGqn3/iSI30tJwAWX/3qIG+JXfOvslYRmFZUYcqrFgqA07gDMlH7L4fnoHChJOj8nKEtGP1VwLNwCqKzamaGhtBXNs05qQdtKDZ6dh7SRGLsc51ndpdYPIcVH3k+ZlDMTyf7MRs67dXQL/hQWcxtkUx3dIEXcnO2FtaIKvru/Ft1ABLeZE6Bw/MM+AgMfy+9ORGaWcZkqO+v2yqQ6+K4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIyMzcl7PH8Q0gEzwghvpQJWOXbU7JIbpHpHxIWDZ0w=;
 b=FBuyC5PSOnx3xDOgWTWfynw39W3jm5WD1yKUgzYwxqhbe/jFJsLY1zRSwuqW2T9H8cu1qgXpY4bPp0IbYTiPYEbwihoEOZGWBnmNPB2jgCHqGRiM1idjr00DqzHXD4MXLrd6cXd9F3w+B4Y83+JO9bgyGqkLpIizjPU+t2Jq2z4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4420.eurprd04.prod.outlook.com (2603:10a6:208:72::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Sat, 30 Jul
 2022 16:23:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 16:23:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Topic: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Index: AQHYo04nl4JHZbxuek2HktTJEcy9Ma2ViEaAgAAKtICAABtgAIABbIuA
Date:   Sat, 30 Jul 2022 16:23:52 +0000
Message-ID: <20220730162351.rwfzpma5uvsg3kax@skbuf>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
 <20220729170107.h4ariyl5rvhcrhq3@skbuf>
 <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
In-Reply-To: <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5abe8ad3-0f32-4513-ba6a-08da7247e47f
x-ms-traffictypediagnostic: AM0PR04MB4420:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XK6DRGHOjHL556/R2QHBFDbSUBbNfI7k7BWYBCIDshIKBEwG68b/2gG9n0riAYRY4WFqeug4GKbgsZbY70CE1FING9i/tpWAIP2EYSr6Y3OlvObxsnm2ixWL+TTTqrGl1jnJYE5vNQsNEe7jVMRCNgFfNhaXIQu4C8XWLj5JiPoFOLCFC2Ag+UzTCzsv8urtkxmujRPOo4zdnmxghENmrMrRbkiMN49PA0ZiloPbhayVXfAiav/10n9fOwmueV9qjUsggy+f9yOs2GUtCFKFpcHSIbaBocDWXXYVKQphouyAHGsVqk5gLo+TRkPfCIr1NHYM7ILnUc8DBKbl+yw3VlhGR28DOCY2QApcj1G3FmYcXzmJvY1ThrFh7cUemkN4Y1r/Jmd51zrxT+LY8SliefBraXHYteIrpDt65D1wfECPKsQmdPO49+5d/xf570BUtk86Cb/l4F6AwDSlnyzEUnS8gWFfA4PqW2sbCsw2v8APdD24uhbVId33wlZ6ARlpDSfvODFruEihRWQrTVEHG4KKSbjvUVQr4tTFx4vUIFDR+wmhdUuCJrKWWhXb8duIZ5mvTQ5Uqlwi5lded6LCU9yo+QorCtU6uCyPlv8E8DhgX5ix6rAekBWEzI+wzeqFLBtvn/SAgAtWSZ3DAFsn+kBWE/K6gR7LxoJxZpl85K4CrIuha74IvrTNv8yE7bsgq1fNWztAyOuKltXEySScz9EEWPijTZZX+F7PVlBg1ut4EU4dA23Z6wbfg/3OAMZYdjm5CKOazWUv6HBVI5HaHT2hXZeCTaq+4hu5MvtJKzE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(66476007)(186003)(6506007)(66446008)(38100700002)(33716001)(66946007)(1076003)(66556008)(76116006)(9686003)(8676002)(41300700001)(64756008)(4326008)(83380400001)(26005)(6512007)(316002)(8936002)(6486002)(122000001)(2906002)(478600001)(86362001)(44832011)(71200400001)(5660300002)(7406005)(7416002)(38070700005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?1JynL9F9svonuZ/2jH5XC72R6O7QNYrRxMryOoZKH1j885eo6lYGD4JP?=
 =?Windows-1252?Q?3LvqDNgfzUcLcbEAGPXvHlfHd1LkDbArs90/pJ5fGfnZnrnG0bu1ou33?=
 =?Windows-1252?Q?k4xtND8/Amjfk3oVZCWw7dGG/oHDF0l7vbl3cjgqPLFbTSCFjFjTuKPR?=
 =?Windows-1252?Q?QbxtzmKVZb5E/NwiVm/NV6a3V4Z2WivyIbMjqjhEOsdKRKmHhc7xeWiY?=
 =?Windows-1252?Q?6wBxhUAx0Tpw41k6i4qdu8DHR7oTz2AfMJyTpBHIdAhAVZBUS9oEwEQs?=
 =?Windows-1252?Q?fDVY++kzO8h6O9I3snBvqyrljyo7PvnO0/1zoCngNOxAbdKbHVXr9TLl?=
 =?Windows-1252?Q?VVKlCAxjgpCCn+PvqKl1KIBmwrM8sOF9kQtPvU3XeI0UnP0Tql5jrl9Z?=
 =?Windows-1252?Q?qLFBdteG3JMMaHgSSSL9tphrIOFg3+3ldgpVlhQCIrPfLwMkdNVTcwcB?=
 =?Windows-1252?Q?CvvYUurQpIFsGeNf6+mHmuMYeAvV76enDQf+/aw4i1HHoATyG5pjpJFZ?=
 =?Windows-1252?Q?WgD3+hRMEFije9JQhn/XYnzn8rXnz0cA5y6Kkqo8tIWlvlT9/2Y88fld?=
 =?Windows-1252?Q?kRyiUpORQpA5Be7v4DbOLsnyqQpLh9z9ST3QWFI/faQ8GWRzsfF08RVA?=
 =?Windows-1252?Q?/Wr6HtTkbamTiKRbjpyOWkO9TNh/WkR6Le43nQTCXAJjCMu0iUEcIGlM?=
 =?Windows-1252?Q?+fCPRSgHmyZkrEP9GR7kD3xeS8QOkD/nXOuzIVNvV82THQeyFg4EihAY?=
 =?Windows-1252?Q?lXlMGykimiaMaL/mLScCa9+j9zi78SSZhlogTa/ioqcyHcnkNmO4Aj+s?=
 =?Windows-1252?Q?Q7xfsMsx8hIfT+luSNxZ76FI+yViZqZPZL4rZRtQtoR42wjEKgN29/1D?=
 =?Windows-1252?Q?e2wWWDOYvm8qvR52hGD83tgsSkhYx5SNs+zEnT1G0xs501IRY5UXLEqI?=
 =?Windows-1252?Q?UaPg+NCVTecVQDdSRZ2Vgg7+AjHxh9IXWiVya8OOS49MPsZtdEt9Z843?=
 =?Windows-1252?Q?v9TSqCbi44Qav6+UkjmKHIcjHNis6gv0A1EGUpF9dfo5/mwnEfDNWACY?=
 =?Windows-1252?Q?pcwg2dXD1vdHV+tbGmsYle3TmZl+jwzSrwHjHBxe4rr+44by+vGQIxtr?=
 =?Windows-1252?Q?Hi1FUXfZCa8JwfaU9h3Hts4zWJfhMh6CyjEMoJZYZ4CJNWEOzkenhV3s?=
 =?Windows-1252?Q?Lm4Mj9hJyX2ZqH0A21SWa9fwM+ACt8To/I6FKdCmTPg4+bXHH74GWSWO?=
 =?Windows-1252?Q?f3Yu2UgcaOYXZcwmYyi7LgV2NdTO/QRJHc/FCTcMlXaX2DNqrNayn0WI?=
 =?Windows-1252?Q?ISwEo3jQqLEyZqTOEYrsTLq0exEwgkOkXDfnhBQM9wgrk42nVcn8w+7h?=
 =?Windows-1252?Q?bJK9tPE7PSsKE0zvqpoed6R5X0hDk3kpKGSAG9UOFiz99g9klMPSmlpS?=
 =?Windows-1252?Q?doC2vRqPSzy0M7eoqX02Zq31I4Grud+FqDUkIuLV/qk5DbUUSXWenxvW?=
 =?Windows-1252?Q?x/cpTMR2xOjEgZfKSKY7SbsFtfbYeErKIZLWUV0v1qrLT9SYIbWc9FXU?=
 =?Windows-1252?Q?7ZSkn22vJGw749gigXjfOBzZF8Ac0F0RYd2BZQpnfVWZEyh4wAPSqNct?=
 =?Windows-1252?Q?uuo0T5ZQ3ySvWK0P/Tnu8e27cX69tBgYnDFECbt3R+Ixg4LSuQSzzYm+?=
 =?Windows-1252?Q?Hv/trhA79D8l9xk3gNmcuOCmz5dj+DaIe5en6jZFVXeG9YdNAdk3rg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3BA234C2D0F86A448982E7643DDAB3BF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abe8ad3-0f32-4513-ba6a-08da7247e47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2022 16:23:52.8010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: COSFmdv4d/ZHo/CQ0Ix3RgnLX1a6qXql4xxAEyos9/f/RVfyxAU6+EQmOW0pKSqydR6Zrm23SHjEqRYtTEVtHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4420
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Fri, Jul 29, 2022 at 12:39:06PM -0600, Rob Herring wrote:
> All valid points. At least for the sea of warnings, you can limit
> checking to only a subset of schemas you care about. Setting
> 'DT_SCHEMA_FILES=3Dnet/' will only check networking schemas for example.
> Just need folks to care about those subsets.
>=20
> I'm not saying don't put warnings in the kernel for this. Just don't
> make it the only source of warnings. Given you are tightening the
> requirements, it makes sense to have a warning. If it was something
> entirely new, then I'd be more inclined to say only the schema should
> check.

How does this look like? It says that if the 'ethernet' property exists
and is a phandle (i.e. this is a CPU port), or if the 'link' property
exists and is a phandle-array (i.e. this is a DSA port), then the
phylink-related properties are mandatory, in the combinations that they
may appear in.

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Docu=
mentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 09317e16cb5d..ed828cec90fd 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -76,6 +76,31 @@ properties:
 required:
   - reg
=20
+if:
+  oneOf:
+    - properties:
+        ethernet:
+          items:
+            $ref: /schemas/types.yaml#/definitions/phandle
+    - properties:
+        link:
+          items:
+            $ref: /schemas/types.yaml#/definitions/phandle-array
+then:
+  allOf:
+  - required:
+    - phy-mode
+  - oneOf:
+    - required:
+      - fixed-link
+    - required:
+      - phy-handle
+    - required:
+      - managed
+    - required:
+      - phy-handle
+      - managed
+
 additionalProperties: true
=20

I have deliberately made this part of dsa-port.yaml and not depend on
any compatible string. The reason is the code - we'll warn about missing
properties regardless of whether we have fallback logic for some older
switches. Essentially the fact that some switches have the fallback to
not use phylink will remain an undocumented easter egg as far as the
dt-schema is concerned.

What do you think?

Can I also get an ACK for this patch and patch 1 please?=
