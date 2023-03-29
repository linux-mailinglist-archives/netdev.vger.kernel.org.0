Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62586CD375
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjC2Hkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjC2Hkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:40:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75472B1;
        Wed, 29 Mar 2023 00:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680075630; x=1711611630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e8Cwob/Df9R6H5BqipEShZpQCQK5BU6sU66lPM/fy+o=;
  b=XYjbWD0/0IUq5txrGeRtd0aSqEfHZf3oKuOY+eajbXkXnnPgv0YkbmjU
   yDiKfcCyjWx7kK9rzCdQiAwrW1LW7pOQrYreH1kYU9fliXKpoGG01FZLB
   68dzZ+vhs9vjakXqIAcTvCR89snaiOpzcTe07CdnvbMDs2OER7qk9R4RW
   9e84OuUOLoWAqpmwy+kB+ixzB9UhLGE1e+62FMYEigp+I4RFZKolCd7Zb
   nFe6i7+73EFd+pWj6QuPkI70Arl9+nWxuOfXkU2im2q/KBWvlxvikSFml
   MEX+E+haGCTUSGwXq9+Vsk+E3fgjpfXY/oYG11o12wEG1RF53Cr9RqL4Z
   g==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="scan'208";a="203957254"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 00:40:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 00:40:18 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 29 Mar 2023 00:40:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvKQcwNACzyE7hP1zWp0HYsxHYUV9gOjoWHEEm3ehE6CZzGO5EeQo0wuHoqpfhAPXaTN3nquutFWSQhoriv3gw7WxcN08D4WQF/dQrLX9AfFAvwn2A1ULF+iY70QikQvT6aQtAdymYENQfqo9mV35+00yBPZnuMt/xQTDEhJg/MWnUzCzYBvPCq2phK64VCN2uE3qfoJ0t8hFQu6zMQz1FOMOd60Ipe6BOS1b+MDhuY0Vrt5sgLBA5NznsSW3L9a8Gm9kl3hJukFFQQVR7cyNJz2p1R2m0KueU6GYY5irUQmWmyjeYHUBZyYK9ojwC3uAti8Qq984NjPlnOJ35WBrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8Cwob/Df9R6H5BqipEShZpQCQK5BU6sU66lPM/fy+o=;
 b=EwAdDMzVM4SxoPVBgFEJTJFFIw1Neuis0nRjfIV3GPeEBlXknHYFfK2pr5LOv6VLy9VXvWQFEs6uiJ+W4JTIjc6zeTjSBW2KuO9CI4fwyXKi238Afzb5I7UQptuvophPr24jzPJ2z1a17JmCTQD0qUL+NnQxYxfPeYmS3xYW22452kgZk8l2J4UGsLmJ/zD+Dhzs9CqxsXyjBOk0HOyaJ5sn2LDOUmXwVR5yosnByQPPc5QdjMJdidSkxsIvD4+/YoE0AmEWYR1gZCU0zIABrnhQYC4vJSMuPT8nz0P6F55NQwogQOoB4gzNmBRToL0T6iFSwvNi8FkXMHnArFDn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8Cwob/Df9R6H5BqipEShZpQCQK5BU6sU66lPM/fy+o=;
 b=h/dKndEQLx3BjQkq/LrlNSoGRwTpNky6CJ1WBVtyCOjDdryyWcPRh9C9JdevEHVBSrAmBCkzhVah8U07nacc2F4rF6Ns9nqyeVX/SASvdfSARBuZCJ0gXioDxqvpHIcojjtKR7Mis+mNqlgnVVkLUKvhEWw+qpSb3rY4N/1IPVI=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 MN6PR11MB8220.namprd11.prod.outlook.com (2603:10b6:208:478::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Wed, 29 Mar 2023 07:40:16 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::60cd:a09b:d7fe:5b72]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::60cd:a09b:d7fe:5b72%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 07:40:16 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <geert+renesas@glider.be>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] can: rcar_canfd: Fix plain integer in transceivers[] init
Thread-Topic: [PATCH] can: rcar_canfd: Fix plain integer in transceivers[]
 init
Thread-Index: AQHZYgl/0DfUjjqwsUudw/x5dInuSa8RX1SA
Date:   Wed, 29 Mar 2023 07:40:16 +0000
Message-ID: <CRIP3MJO75K3.5ZIJWJZFYIU1@den-dk-m31857>
References: <7f7b0dde0caa2d2977b4fb5b65b63036e75f5022.1680071972.git.geert+renesas@glider.be>
In-Reply-To: <7f7b0dde0caa2d2977b4fb5b65b63036e75f5022.1680071972.git.geert+renesas@glider.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|MN6PR11MB8220:EE_
x-ms-office365-filtering-correlation-id: 868b3a1d-17ab-4d11-1e38-08db3028d6d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWNNY1BToTTE46MjahQz4xMmX8Nifqjr/wvaw4LVbgkdr/vkCRH2fmrPyPQWUU5EuHqC5KWxJizo6OjT7Dhv7xOeUswLP4Pvfo9fFSawkHYMgqglON/Bt+J/wWyOk8erwU512hmIrXPagRswxa1tdM4oZMlOYqQGwXIylNAi+NRomCPHtPcfCZw/DKn6F3No0x5GTNzfbvoEd2FaYErYqfMtLiyrpQTSP4CDXvAaMt/vFklNZJjM5eCxJvFVghage92Uu7UihWijWDt+Dy60F7v5lx0zXv2rsyAwSUkRVQ10FmQ6H4d19KfkKQWPKJbiAyZZQHCVyFr6+nlewjuuZ7z3qKvGvr8Tomo17nrEeAAbpi9NJH7kW5ocrZRBzSpFv8nGa7Xs+M+uZRUZldHcloiXG9ah5rcX5+JJjj376TnPIfLEglBmCBMyelW/qaOG2VCBu1Xa9f4jpq1S4YYJp8+Af69F59XBLEupVZKZjUlBmQw/exH1b9uf/Pldnj1zLrg0/3Gno/GqR7wzpZ76LwtcbBdJyg5L0iVtG2s8Xnxf/bZ9Rj0Cq0bPojhnRBdW/Uq1hx8NrDhxLBA/uORhlLQ8CL8MI90VUNP2N8AAgEA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(71200400001)(41300700001)(6486002)(966005)(6506007)(478600001)(4326008)(186003)(8936002)(26005)(6512007)(5660300002)(9686003)(66556008)(66476007)(66446008)(66946007)(8676002)(54906003)(76116006)(83380400001)(91956017)(316002)(110136005)(64756008)(2906002)(122000001)(38100700002)(38070700005)(33716001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjUrWFptRWZYOUc2VzZEemQyMmtoTXcwNXRwZnhLM2NzNWNaMjRpU3JnWWI2?=
 =?utf-8?B?RG9sOUJoRjkwUllyZUpDODZpMmxaakd0UFI1eVZNQVMyemRVL1VqeGIveTUr?=
 =?utf-8?B?ZVlaSmgwdTN2SVdZYXNyZDMyWi85YnpKeThRa2tHOGxZbWNFUGp5akVzNWlT?=
 =?utf-8?B?ampLek5UMHRDb3dIVStkZHEwelFDYlowOTNMNGlRWTVocUUwL1VXay9VUEJS?=
 =?utf-8?B?UGVienZoUllHRFFoOThkNHg3VHo5WTJjMU1QWjhFY0RvMFV6RUI1KzFDL1lC?=
 =?utf-8?B?ZEpGVURSZlQrNXhxODQweGFnRG1VOE5vWTZDWG5ZVFRlSElNSmRQVndxVmho?=
 =?utf-8?B?UWRGeHlrck5uZUFlTnZhaHJoWExPcVZ6ZnRkbWo2RFVmUWsyakdYWWp5RTdK?=
 =?utf-8?B?dUN2SXdEcFZYRjIzeDcvOGV5VFFtR1p1S1FnazNTQUV5TFhPUkEvSHhTNHZq?=
 =?utf-8?B?Q0VpN1l2aHdORFNXQlFpa2I2RVFzRVp3ZThheitKQUZabzZ6eGk2Sm5JZy9G?=
 =?utf-8?B?OGJaZUhMZW1wS0FCQWZhZmk5cG1ncDJjNk9kYUZtTXhSemxtVmg4bTBEaGhG?=
 =?utf-8?B?eURiZlE1VDdmeUxYN3E4QWxwRGlwVys2WXdGS1dvYmljQzJYLzc3dWVEWFEy?=
 =?utf-8?B?c2pUSVpyREJPbzN3Uk12dUVScUc4bTJaT0h2MC9kOC85d0dBRnBLenpGeTdN?=
 =?utf-8?B?VFNJcklUc0RldU5XR0ZBeG1PU051aCtSM3VLMXVFc2hkaklOQStSUU9CeGRy?=
 =?utf-8?B?aThvK1dBNGRHQVpQazFzODh1Y2gzQnovZEs5NVJyVzBHQXljT3ZQcTk4UDU4?=
 =?utf-8?B?QTVYWEYxc3FjVW9DR0RpTHpmSTVKM21nUDNreEZDbUdGZ1ZWK1ZoUFdZQ0Nz?=
 =?utf-8?B?anFubHhqKzZsamVXeURKYnFuN1RwV1FWaEhlQU5GTFB6MVQ2SVA4OWxoOWVO?=
 =?utf-8?B?bDRoT01aUXo5RlhqcnBBdUNRY2pYNlNpb3R3QmY2a3grcms4RW1uM09GMEFX?=
 =?utf-8?B?ZEt0N0J6ajFuVW5DTUhYbmg1SnJ0SkpxaFpSelVkK1IrTU94MU9YNVREczlC?=
 =?utf-8?B?Z3lQM213aERMVGVjdlRZZXdrdDZoZGUwWkpaVGtMb1hIbmpBeFBRR0tjRWp2?=
 =?utf-8?B?U1lReTdVSUV5dW9QYnBvU2hVNjZJWnpjaUJkeG1SbVRDSFVvYTZweGhMV3hY?=
 =?utf-8?B?UHNFbXI5dlVFMzdhUG5xWGJHVjMrdm94OWxkSTh3SFFaR0U0SFFlbEN3eTJN?=
 =?utf-8?B?SjhEZEZyaW1sUFRzc2FleHdRcWg0c1JZUDJORVhwcWl6UGRGTEFxaWFJQ09X?=
 =?utf-8?B?aUM3Yk1yN2pwTDJDVGdpNDRaOWVsNnE5enlhY1VNUlZ3Y2VBc3hyR0IxUXF3?=
 =?utf-8?B?UEJHZml1MDJOc24rOFExRjgzYnlJczBNSGh0Y005d3ZLU3l0bkFFOW9ZeE8z?=
 =?utf-8?B?Z3pXNWVaSi9Lc2VOY04zSFlyMnorcUszeElIZWU5clV4MXNXL1NrWlhuVDhl?=
 =?utf-8?B?bWc4RjdRcm5mN1VMZGw3alJNUUFSTmhkQWxqTWZmRklEWmwyN0YyUHlYRDBh?=
 =?utf-8?B?RlN0YU4yNG9TTkNDUlN1WDB1dTZrTFk2by9pNCsrQWpZd0NJTHIzaHJSa2Zi?=
 =?utf-8?B?K21BMDd4ZFVNclhwNG5DUWtrZEY3RTkrNCtzUndxbTV1T1ZkaDlKQnlBNkE1?=
 =?utf-8?B?Zkc5dlhrOXBWUkRoY3lkcFRaRjJiRTRJWDBOWEFiNno0aUdjMDMzTmduTWhD?=
 =?utf-8?B?eit6THJ3SWN3anBnMkExMFF5ckpQUDk3R0VTam1mM2lWL0tlRXJ0MGNFVE5P?=
 =?utf-8?B?eHkrRlZyZ21oRUZpTVR1UC9aS3NGTmkyZWpNeGtYTm1LVlBhMDRrbW9qQ1lT?=
 =?utf-8?B?R1J2TElESVNMNjlNdTJzRVNBY09OTzRkbGlvQkJqZTJlQUk3WFE1ZHhvWUlL?=
 =?utf-8?B?TXZoK0tCSnNWSzdwK2ZPWGRmazhjVEEvdDkyWmw4cm9wL1lOb0ppSXR1UTM4?=
 =?utf-8?B?NG4rSGw2anpLdmRCSGhURUVidHBhekdnQzhnZjZIMmwwdnRmYzRjQkVRdnJP?=
 =?utf-8?B?SFlqSC8zSHFycFA2N0RzOU9ML0xwWjdhSE4ySldURXRkWGpPMlNhNTFRNEw2?=
 =?utf-8?B?LzYzSGZTdGVNRGJzWmRGcHpBdTFkSkV0NEdySWRIR2xST0JDa1FJN25keE9C?=
 =?utf-8?Q?uj4Ek+Hzo4gFt7NTiM1zd7g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B1D671CEE681A4AB9C35B5BCC48EA79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 868b3a1d-17ab-4d11-1e38-08db3028d6d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 07:40:16.3919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fb0O10G3FqgjRSEXiA2W8a2J5XpZjueZNQC5wSIwbTOFmERypcT+cWBqpTXzQacNbcipBW4NyST7F9m9UrSYmV3CKZRoUN8vqLZQd4NFhEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8220
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNCkxvb2tzIGZpbmUgdG8gbWUuDQoNCk9uIFdlZCBNYXIgMjksIDIwMjMgYXQg
ODo0MCBBTSBDRVNULCBHZWVydCBVeXR0ZXJob2V2ZW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPg0KPiBXaXRoIEM9MToNCj4NCj4gICAgIGRyaXZlcnMvbmV0
L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYzoxODUyOjU5OiB3YXJuaW5nOiBVc2luZyBwbGFpbiBpbnRl
Z2VyIGFzIE5VTEwgcG9pbnRlcg0KPg0KPiBGaXhlczogYTAzNDBkZjdlY2E0ZjI4ZSAoImNhbjog
cmNhcl9jYW5mZDogQWRkIHRyYW5zY2VpdmVyIHN1cHBvcnQiKQ0KPiBSZXBvcnRlZC1ieTogSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvci8yMDIzMDMyODE0NTY1OC43ZmRiYzM5NEBrZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYt
Ynk6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMgYi9kcml2ZXJzL25ldC9jYW4vcmNhci9y
Y2FyX2NhbmZkLmMNCj4gaW5kZXggZWNkYjhmZmUyZjY3MGM5Yi4uMTE2MjZkMmEwYWZiMWE5MCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiBAQCAtMTg0OCw3ICsxODQ4LDcg
QEAgc3RhdGljIHZvaWQgcmNhcl9jYW5mZF9jaGFubmVsX3JlbW92ZShzdHJ1Y3QgcmNhcl9jYW5m
ZF9nbG9iYWwgKmdwcml2LCB1MzIgY2gpDQo+DQo+ICBzdGF0aWMgaW50IHJjYXJfY2FuZmRfcHJv
YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gLSAgICAgICBzdHJ1Y3Qg
cGh5ICp0cmFuc2NlaXZlcnNbUkNBTkZEX05VTV9DSEFOTkVMU10gPSB7IDAsIH07DQo+ICsgICAg
ICAgc3RydWN0IHBoeSAqdHJhbnNjZWl2ZXJzW1JDQU5GRF9OVU1fQ0hBTk5FTFNdID0geyBOVUxM
LCB9Ow0KPiAgICAgICAgIGNvbnN0IHN0cnVjdCByY2FyX2NhbmZkX2h3X2luZm8gKmluZm87DQo+
ICAgICAgICAgc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsNCj4gICAgICAgICB2b2lk
IF9faW9tZW0gKmFkZHI7DQo+IC0tDQo+IDIuMzQuMQ0KDQoNClJldmlld2VkLWJ5OiBTdGVlbiBI
ZWdlbHVuZCA8U3RlZW4uSGVnZWx1bmRAbWljcm9jaGlwLmNvbT4NCg0KQlINClN0ZWVu
