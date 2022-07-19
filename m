Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A48757A744
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiGSTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGSTen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:34:43 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2108.outbound.protection.outlook.com [40.107.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2111558FE;
        Tue, 19 Jul 2022 12:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbgC/Oya1GIH91uTFZMAJ0bwSIQqhgq3wLQYIl28pmwz1CGPRfnvGiKXGmndVEERY3Ei8oKQBrm8gb4tQMdkR44ruCHccHPrEbpL11jSAf8OdQ5CFiHP72KhgZ6naJWaDVhSJePRaleeEr2FgisBEvOlFuCEzhvG8mBJFPSHH1Rmot2QBuC3eTaE+2FaGAdz296rPs3BC/xy6I6wpobJEwpFUYCZgs03jJSbb6XV6rMSxy1ldUJcI+cne2vK6MSSS7tEb63rO5LFVXToCkfH+nhHWuaSGOXFxY9iF4vreVrPgM+TzEa2tEFB/x+vSq1DkIy3099HJQ4jATeqe/aVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vc5XpFfy24Sa6DjDPHwdepGhxS87yJcCNFZLrYo+Li4=;
 b=M6pyOp54+4jJsHFS7C+lGBGIrIImmubPI8yh4ab4P7o+JVPR96hoOf6bX517S3o2tp8sYHNGaeYQ4MiH8kZfEY+sVeuYxHhrL4u6n/gsEgT/lIhTtQMmq+QU7x5hHUbkgr+TK9aTSnvbVABbGDYGfzx6oOtnD803ou4jd8XBUP0hZvj1Ue9KtPNwej+lnaVdAEIdRwafRD313YXBFxk1VFqCQoN2fUeyEwTnAh6P99ECC1bISKcqUuow+fzqnoGx7YUsYfjEMLnX96u4DeZIroh0okjuA/wo/1aV5L0dDT4Y/vZjEr2YpT+yJ8/zSQi4DUK68g5qFYrWOBM06XM3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vc5XpFfy24Sa6DjDPHwdepGhxS87yJcCNFZLrYo+Li4=;
 b=Gh3OCt5KITfG2a5y51YqjwWuNlvly7xSzMD1mRkaG4NuoDz1Eow8SZZYoN0Jk3YilYVB9XD+L0vJqJ5fwF5kE8zwcPD/NH7ZpwNYL82Fn/XoFILJtZC9YuQWYxFl8Vud9izbtDkIn0hVWiVT3SMij9OGF0WoBY0odorwdU0Krlo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB2893.jpnprd01.prod.outlook.com (2603:1096:404:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 19:34:37 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::b046:d8a3:ac9c:75b5]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::b046:d8a3:ac9c:75b5%4]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 19:34:37 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Topic: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Thread-Index: AQHYlFOvG7fj/afWrUacI2C3d23LRK16tOyAgAABMVCAC2LXAIAAC08Q
Date:   Tue, 19 Jul 2022 19:34:37 +0000
Message-ID: <OS0PR01MB5922D979899803FF8B45D904868F9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
 <20220712125623.cjjqvyqdv3jyzinh@pengutronix.de>
 <OS0PR01MB5922495C78A7B77874940D2386869@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20220719185316.eohz3o7d7fmhk2cb@pengutronix.de>
In-Reply-To: <20220719185316.eohz3o7d7fmhk2cb@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3360196c-573f-4cd0-87d0-08da69bdb7a0
x-ms-traffictypediagnostic: TYAPR01MB2893:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pj7jplcRnWxQPBvd3NoEZl2i/KF/osmQpaWB+SyIi2GwyYKeSPedTC0iplYA8cvIl+SEP0Rl0a9iJfNO1Uj9D6cN0EFjL7W+Fi08uH0oD1As1CtWEPKqvcvxigrKhxyJxNBqaJx3uDCyoem7A/O2V1WAvYKGb+0T6IObTg1Ecp9R228LpOrAP7kk8hqeq/Ry61uJNj8yUg8ZEFQmYqvgEuzo5IeCJFpiriZs9CzPfi/+UKHfOL8ez6VXwtqWkD1fogUh8KT/6L7We97J03cUAXPahtk2eIvLDEzwdrYPO2bwjKuk0BWELKLezgrIL/6IWiq//g6unS/bMNhFqzFvxrPRA6Vu5LZB/uZKrH2Z93UCn6TgX8zZlAbAUSYwc9sY8FlzjbH1lU9PkUb9ZurvFLCKiTpsA0Il8NpkEqBYmTjyWPX7j1Ay4pqiHrgDlwEKxk046gG7u7TIySmXQAUK8EBqGDYDCfdapf8RH+IM5dC6MY/djL4cNefB5eaPCnSLqQrlgJJ3Z3qk2tKQUSxlJNSxyCDOUC667lyFNk9sxeD6fEAdpQY8XWLujuUGcHw8oHvvrinSAB9T+029MXxIqWWNo7rgeii+kSEVcDg8w1wIXCbnyyG8Y9VPfG0Ye+mYM40hcbtKFLU6MmqgXe0ID9gQ3manQupeyrzLlt8zrHFLP/BMFnlNyBBLhDNuJxTue7QfJqQn6JFyy1LRFr1cjDlIS2RO1IKo9Kz7VmBuDRB5njt0EDGnehLfQvXJ8kqycF/WfD17fNkwnP6hL0iozgxbOgMVlL8d4BJn+tC4H45jU3WJTRhJdhzfokHkjxN8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(5660300002)(8936002)(7416002)(76116006)(38100700002)(66446008)(66476007)(66556008)(64756008)(4326008)(4744005)(52536014)(66946007)(8676002)(55016003)(2906002)(122000001)(33656002)(86362001)(38070700005)(71200400001)(478600001)(6916009)(316002)(54906003)(186003)(7696005)(53546011)(41300700001)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZktINEtlKzFNMEZIajZsbmJPYUZDUFF3QnVzQ0dRNjRwUjlLYkdRcElhZXc2?=
 =?utf-8?B?ZmV4dnFJNDE4QmpkSENMN1hJR0lwOWFhYVQrKzNKQVVGOGpVVUM4TGdud1Ft?=
 =?utf-8?B?NXpoSEJCeTFERFlDM0E4M0VlY2pFbXYvTVFIRng1MXFURngzZy9ZUUJXckRh?=
 =?utf-8?B?RFpZSytFUkZWTHFQeE9aQmswN2V5S0xESUxnd09KdU90elZXcC94d0E0K0lk?=
 =?utf-8?B?ZTc0bng4ZFV2b3JRTUN3OWJlWXNhSEtpQm1vSzJlek9QNkVOOGNlZHNTZjF0?=
 =?utf-8?B?TCtYSlIwcUNXZnNmaHUrb3lWMGZUeGtlSXpCVU9USXMydFdNMkNQUjhxNjNT?=
 =?utf-8?B?czNwTjd2VUczcldFVHN4TzNveitoeHcrdVZjTGNpdlZvYStjSFNIT1BsTjlT?=
 =?utf-8?B?aDZCK0dONk1sWGJGRHRvbWFyWm5YS2x6Y1p6cGxYS2lhNTRDL1FKbFhPVC9R?=
 =?utf-8?B?YTJNRWt2Z2dmaUtHQWI1WGRtRm92djFGRjA4UGpDTWJWL0szWkx4UEZJRkND?=
 =?utf-8?B?MUdLQW1VSXNVVzdlOUlEd3hWRnA3SFF5YnN2QXVNZFEwQk56MlVzUy9YZWRl?=
 =?utf-8?B?cXcrUUk2TlBsZmdEdE5BWnAxTzlXNlBGcFFYZ2x3eHVLVVl0L1liWnNTaDVj?=
 =?utf-8?B?cUV4RjJ6STAyRG9saEVMd1Bvd1gycndqWmcrd1JacjEvZ3JuZk45MHJUNGRQ?=
 =?utf-8?B?U3Y5UnZpUXdYcXZoQWlscmJKSk1YRXhabnZOejNzeGtRbnl4b0V3cWZmM2lq?=
 =?utf-8?B?dVI3ZFhPdTBia1Z2eU1ZMFh6MC9Zb3NJem9qZXA1MTUxbmRKMEZQallTNjdC?=
 =?utf-8?B?OEZDeXZpRG1HUkJsMXNUekNUdXdWeDJMWDA0aXBXL1IvbmRRL2Fkd0FZZnNP?=
 =?utf-8?B?UFdhUnlWVU43UkJpK29UZStvdWo3dVlmUU50aVEyNDByM0pNQ0hJZi9NUVVP?=
 =?utf-8?B?ZmxIT0I4aWc3ZmcxdDFPRHBlYTVwR3ovRldHN1pFeDhPWGhFQUFtckFQOU5n?=
 =?utf-8?B?WndaMkdMdEN3K3pGS1BPTXhaS0NTT2hWcDR5cU82MFdxcjVUTXp5emVjVmlt?=
 =?utf-8?B?Z0tDT1BMMW05S1IxdXJwMWlhTmpUL1o2aEtmcGJCMkk1ZXBtcjk2MUtUSUgr?=
 =?utf-8?B?T0pzcU5BWEVaeWMyY2EwVmVmRDJnZGRSeFdjQk5raGhWWjluRFkrQWRUNTdo?=
 =?utf-8?B?K0F3dkFZOHJmM3YvUEMyc0gxRHAvby9kVDZCR1ZlYm9IQm4xdlFMVkdCWHRG?=
 =?utf-8?B?R2R4c3dSTGdteGNESEd3djJDRVo3YWVic21tTGc2TTRtdERubjVxVU5UZFRj?=
 =?utf-8?B?bkUwUFRDQ3gxamdxSnVSdFc3cFVVYU44QWdGV2ZQeCtTUXcxdTFwOUp4MkZC?=
 =?utf-8?B?SzFOcnlIZ1ZiV1B5ZGVYYXBwRGNFSThqYWZOTk5jbnNtODhOWTFNNHE1TmM2?=
 =?utf-8?B?M1ZncmtRQXJoMElZRG00WFJGRm91L051T1N1NVdlTUE0azJEcWE2ZUMwczlY?=
 =?utf-8?B?UzVIOHJHMjN5ZzlNK1U4Z2tmZU9jZWZiNWY5R212cmVjRWVwdng0QVUzSUYx?=
 =?utf-8?B?V3lEV2tDVVlkWkp0WXpic2VGdHMxSU42RGM2VFV1ZnZ6alZtdzZkaTJkRFJI?=
 =?utf-8?B?SHozYUNNd1JvUVhyWGpyT1ZUd3RnaFFBcWx3M016WlMwMWwrS0VlVUZCRFBC?=
 =?utf-8?B?TVppbkd6UW9EZ1dOOVdMS1h6a1VsbG5BYVhIQlZ5N1JxWHVNOXlDN0hjWmNj?=
 =?utf-8?B?YUlVWGJFMXZ1QUhhdXl0amRMZjhPZDFxdmluMTVqaUs2M2xWdnpjQ1lDN3k2?=
 =?utf-8?B?VVhPM2hTUkVTQlBoS1I5UzZLRkNUMWN1Q3EvSkN2RGdDRDhpTWo5ZFlscnhM?=
 =?utf-8?B?eFN2Qklmbkp3YU1LZ09YWXVTZThUb2F1YWtUWjZ2cmsrV2xrSUJMV214TWw3?=
 =?utf-8?B?M0IyUkZia2NTVUs1eDR1NHZWTFY3eEJxdkc0R3ZWbzdMcDBUNzJFbVZzZFFs?=
 =?utf-8?B?bW00aEdyaXFCNHZQZ2dlZnQ4blFnaTdKbDJDRlphaWZWQy9QL3BPVjlaSi9k?=
 =?utf-8?B?NTRoR2ZSelFsd3FXTUhsdWdKaXJNY3dOb1ovOXcveEZ2bHlYVU03d3lKUzFS?=
 =?utf-8?B?UmZFZUFrdXo3dW1nNVNHV0hlb2svd053ZnhQRGMyWVJFNjVXQjdoWmJxTHI2?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3360196c-573f-4cd0-87d0-08da69bdb7a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 19:34:37.6676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mC94uFECgYMMgkcbgI8uzGPGTbOq/aj73dIOfpH0xHwv01Ozw0TT8DQ7Qu8NzjM9wiZ6wXXdDMpn6SC5TSM4pBjyeprTVVRrv5I5LBw2IKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2893
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDYvNl0gY2FuOiBzamExMDAwOiBB
ZGQgc3VwcG9ydCBmb3IgUlovTjEgU0pBMTAwMCBDQU4NCj4gQ29udHJvbGxlcg0KPiANCj4gT24g
MTIuMDcuMjAyMiAxMzowMzo0OSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4gPiBEdWUgdG8gdGhlIHVz
ZSBvZiB0aGUgZGV2bV9jbGtfZ2V0X29wdGlvbmFsX2VuYWJsZWQoKSwgdGhpcyBwYXRjaA0KPiA+
ID4gaGFzIHRvIHdhaXQgdW50aWwgZGV2bV9jbGtfZ2V0X29wdGlvbmFsX2VuYWJsZWQoKSBoaXRz
DQo+ID4gPiBuZXQtbmV4dC9tYXN0ZXIsIHdoaWNoIHdpbGwgYmUgcHJvYmFibHkgZm9yIHRoZSB2
NS4yMSBtZXJnZSB3aW5kb3cuDQo+ID4NCj4gPiBPSywgd2lsbCB3YWl0IGZvciA1LjIxIG1lcmdl
IHdpbmRvdywgYXMgdGhpcyBkcml2ZXIgaXMgdGhlIGZpcnN0IHVzZXINCj4gPiBmb3IgdGhpcyBB
UEkuDQo+IA0KPiBJJ3ZlIGFwcGxpZWQgcGF0Y2hlcyAxLi4uNSwgcGxlYXNlIHJlcG9zdCBwYXRj
aCA2IGFmdGVyDQo+IGRldm1fY2xrX2dldF9vcHRpb25hbF9lbmFibGVkKCkgaGFzIGJlZW4gbWVy
Z2VkIHRvIGxpbnVzL21hc3Rlci4NCg0KVGhhbmtzLiBXaWxsIHJlcG9zdCBwYXRjaCM2Lg0KDQpD
aGVlcnMsDQpCaWp1DQo=
