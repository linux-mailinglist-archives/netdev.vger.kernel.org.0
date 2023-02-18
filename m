Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC5569B9DE
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 12:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBRLwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 06:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRLwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 06:52:07 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6181517CC5
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 03:52:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT8dJI24g85E02VqprFkJrVeSHf0WmrZnWlkBwLoBGjgs1rJ9k66N91L5a2R7PRS/mb8rkJsctF9e+2jxzvKDeG4G8ySYFEU4+FuW7pbFeDWDO/AY6eoy1gSB40Qlvxvn2zvfsvyAk8gRGT1enOSc25DaUsKEbqgfcFhHplEQou64wwMP/sFytKk65Qsp+9RccnKCAibb+4ke/IoplFnFhb5Qz0v2dudbxRIBRWPrMGacPTwf2gicPSIL/bTLSt1NHPSizgRjMB3jKFn4lPwgwt5GX2ve3WNdnj6hUxFdzQFYXFqcTTy/h81T0wsJj2LFrEgWzKMJcdXyhrDZx8UUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9cl5ngZfVh3kTqiWUl9+jkhETJ8+NXAHHwQPdNmkzo=;
 b=n6heTtPsVeRvmE3d3fSHhCIobevT7OsHNfRIm8WDNbNxnxBW3KqPNM6m9tdlTdWWrxU7nHkiMOJlnPdLO3FmFzq/bE6+j8PoCPP7eXaRvbU10rZKmTFTTd3WRdpHkxoZGG9P8WxbHwvwmTi3ssJkNMNFGJY+k+WvcGtp1tsY+6C6+YFPMwAT499CoNGf0vbprNlDSjSy5tOe2jbPJqN/DNUUsQoi4NjOGtua5mIfWmhck4d2iYnmydMnJCu6PZlM73eJWQIS0eF355x6gCqtdfxCiT/OGPXoZSZLxPa4UQJLI4nuQxb7YAfaqeyQ0ZO5ALUsJR4yarDDVwMsSXrmCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9cl5ngZfVh3kTqiWUl9+jkhETJ8+NXAHHwQPdNmkzo=;
 b=AGmtMoAyfWoD9xakYH68RXUxDTdeeiz2T4bGnFa/LUSSu4W6kJjqSszs5XU+rSB85bcg+VT2beFy0sbkyGK8/V6NbZW9RtSFHXJtjSSo6U4x3iyp2eduysLK/1p5CPXYWittJRZpQ4jc2gm1ANWfY3kYV1+U8rXq7Go7VPE1b9U=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB7717.eurprd04.prod.outlook.com (2603:10a6:20b:292::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 11:52:03 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%7]) with mapi id 15.20.6111.018; Sat, 18 Feb 2023
 11:52:03 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Richard Weinberger <richard@nod.at>
CC:     Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: high latency with imx8mm compared to imx6q
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: KX6nItb3xzzXXgLsKrBE7F/dfPfNJbU33POAgABHTYCAAAZaMMtWSb1ctKpkzJA=
Date:   Sat, 18 Feb 2023 11:52:03 +0000
Message-ID: <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
 <Y/AkI7DUYKbToEpj@lunn.ch>
 <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <130183416.146934.1676713353800.JavaMail.zimbra@nod.at>
In-Reply-To: <130183416.146934.1676713353800.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|AS8PR04MB7717:EE_
x-ms-office365-filtering-correlation-id: 189e9c5d-7495-4873-f41e-08db11a68d3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wjjhxbhdYm2c0E+IWlALnvRfc/1z3VjdTBQRBT/UGOBOGv3E9LO+C/Soyg18MWbvb1UqyfKerEmGYvs1+puhNAL39Uh3Ze3H5vrCa00/O3RpfENoZbS++GERzpZ8G/vjFmhxxNauZr6pJLkQDUZFN2/asbusgLSCCb7lU5DTLTdg6L7CsWYXpOOlfRTsiYZ9jGJpNFPnZsb7sj6xNVVP2buFfQHquqo0T0AVvDJkH6nuIWhUynUOeEUauWm3tHcWJhxcQb4gSrxTGA1Nb5SWOKxT2DtzGV0G2hi+VJrCP/K7H/xyIfGw6C6YCVNwey/pahhzb3eveqPoOyeM2cT1WBS3q+hzbU7MY7E3W3uuv18qZP0jRB+fTBe1oYV2Q2+AVMoFoZ4a+kg+Y/vIeBjkWAC4ue+jigoO00KZWwM3lCJRbe6ozjyt6Az+9VW/+C2zwexpnUwhe0oK5h8Nw0wCbAm5SqAGHdwCUKuhKCsibFcV8isxQ6l/IWTnil7kGL3aSy85hq954hIkTO11Nv5nzgLCidRXhUpiIwEN2s/4ySreR6SE+wySusp82+7xo8uK6TrstdvnWZhnELptdiobwA6kA/rG02cn/HilNjsmEngoMmXS2qA5MUnGfZdGaaHdd6otRZRT8jFkH9kMilt7YslngtKHn+l4Ij4xfzs/nE8Bx2S22qmpSswJpVwide4+PT4CORA3McRnDNZI7A7Vs6uP4EgYk6oWGlHm2B952f0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199018)(83380400001)(55016003)(33656002)(122000001)(38070700005)(38100700002)(52536014)(8936002)(44832011)(41300700001)(71200400001)(64756008)(53546011)(2906002)(6506007)(186003)(9686003)(26005)(5660300002)(7696005)(316002)(54906003)(86362001)(76116006)(4326008)(6916009)(66556008)(66476007)(66446008)(66946007)(8676002)(478600001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkZzR0VEL3FGR3NDNG4xelQ2eU40aTRUaVFyeDNCQ0pZb1JQT1VsaFdMbjBs?=
 =?utf-8?B?WWxjQ1gwS29kRk1NeGFqcTQyREl4aUlQc0F1V3ZlK2ZWenk5aS9ZUDBKWUp6?=
 =?utf-8?B?ZWFpeFhpNzV1ZlppM0JzVmFnR1JpKzlrTXpwUjNuUnE0ampKaFpyTDlFSVMr?=
 =?utf-8?B?eDRMYm5vK0RtWmVJOWtjdkZJQkJTMUJNRU9zaFdlZWN0MUcvTVVDOVo1dEZD?=
 =?utf-8?B?U1BwUmFzdGRRWDFaa3NSb0VEQmI0dm1IQXd3ZjdodkxGaysvR2dielBMeWVY?=
 =?utf-8?B?NTdnYXc0bmJUNk1WS1B5dW1wRUZBd245OEJyWlZPUVhUZlJsdTFJNWRoMEhp?=
 =?utf-8?B?T3VEcVNhbXAwZnAvVkpMN0Zvd0xZN1NpMFRRL0MrUVBYb0JGa1JBSkhHZ1Zm?=
 =?utf-8?B?K0E0V1JQQnlYSUNSNTJMUVFDR2lPY1ZkM0lJYTFIWlVMcDFBNFF4UXZUcFVM?=
 =?utf-8?B?cVU0b1JaUTM3OTIxVGhzZ1pKcE1aSUp5ckZwVFZFVkQ0N3d4OVFmR1pMaHJF?=
 =?utf-8?B?STM4a1R5WlZGbi9GMm9rWDlJeFRZU2xkSjBmN3Q3VGFneElNTFYxQXVWOVNX?=
 =?utf-8?B?TVkzMHFIbkdad1dWbjBwMlVVN0xVeEUzTVk2bjhoYnNueHF0KzZtY21JMkJM?=
 =?utf-8?B?VHpzczNyV1plN0ZweEdlMG1vN0kza0pQN1I1K0ltaS93Z0Fvdmt0VU5WWDlt?=
 =?utf-8?B?UEYwTHlXQ3RPemk3aGY0aEZ0ZWR5YnpoYWplSjV2ckU3aDVqRVRZNnlpTENL?=
 =?utf-8?B?eUJoOGtmUmdkZEtpQ2lNMGk1Tmc4MmE3aG8wZ0lJbXVOVjJYZFd2VXIreURi?=
 =?utf-8?B?bzZwd2tCSkhzSXErZ1JMRG1lTmVHU01IakNaUnI4UDBJNHlqVTAxWWwzbklZ?=
 =?utf-8?B?clRDODN0WkxFbkV2WWFUUnU2YkNXZEg5SGo2VnhubExEa29TRTVKR0p3bDJK?=
 =?utf-8?B?SFI2c3dUbnk5bE1wOUVFRGM2Ujh0NlFUdENuQ1grNVArbDJzS1ZNOWl1QllV?=
 =?utf-8?B?bS9iY0hTQmlQb1V0ejJyZTdjYWdhRzdMUFpmTURYTGRGbWlPcTVOVW90UDVz?=
 =?utf-8?B?Vmk3Zms5RC9McWpNQnM5d2tLUktJbkxRR0F6dUdpcmNWazFPUlZvMVhOYllC?=
 =?utf-8?B?eFZQaUYwbkRYK1FQRENyYjZEeEkyUW1rMDN2V3ZKdU0xUlhCSVk2czBPOXlL?=
 =?utf-8?B?YTRXZGlGbXl5Q0dqa2tpdEpvMFhjeE9teUZkU2RjSUpKWDlCODBSalppazcz?=
 =?utf-8?B?K3NpRUJlMll6RkJBaFpneW41WFo2aDR0TXpqd0J1V0ZyWHU0YXhGcDBqOXda?=
 =?utf-8?B?UlpPYlVwRFZleVZvUTh4TVY0Y3F5aVQzWmJCa21TZXZlQ1EvUVhTblhuL3Yz?=
 =?utf-8?B?QUJBU3djd1pacFg2NmpPUnR6dUJJT3JwWUtBbloxOFZ6aVFxc3YvVkdtdXVV?=
 =?utf-8?B?akxaT2t1TDVXb3A2ZXpqK29vM1Z2WnYydGhVaUpob2I5YVkzU3VudGo5Z3VG?=
 =?utf-8?B?RnZ0TnU2dDZ1NkY5WlFrOUIvNllmUHk3SlFpUEx2b2g4UkFTMEhsQXI4VGhm?=
 =?utf-8?B?ejVmTXNwWlcxQWRaZ2tpd3ZZVjdnaUdYMDRnUmdqVHdQNWMvZWZsSU5wd3N5?=
 =?utf-8?B?blF5bmhJNUdlVVZGOUFkejRZcVB1OWNLSDJWWlI4R1oyeGR5aURVVGFXdDYx?=
 =?utf-8?B?eEpGNFVrejdQNU02SHNCMzg3eHNJaDgxWU1OaUZiU3AyejJQaWg0cTBaN1hL?=
 =?utf-8?B?UGRnYzFGemNBVVdTWE53czNzSWx5S0d2VUxNK2ZMaXBQTGVPTmQ3b0Nod3Zs?=
 =?utf-8?B?SVVKck1vblBkNU5QUGYwb0tRdERZOU00d3c0L0phK2RYcnNCWmgyS093ajBp?=
 =?utf-8?B?WjJnOXFkdzFFMEhkV3hNakVpVnhRd0FicFlxbEhuZ29CcllIZXFmZFBrQVc1?=
 =?utf-8?B?aHRiMDlXa3pZMHJBbWRHMEZaV2NwY1gzbkM2ZllTSUFIMFYvWk5uL3JxUUxu?=
 =?utf-8?B?bjVEUk5sUXpNQTlsVXhWZnViMHp3NXUxQm9ZK0VLUzR1SzlEYzZvejFITlg3?=
 =?utf-8?B?MHN0TzN2Qk9CbVJxdTNIalNJclNmMVpESEJ4dHZUR2htaHA3Y043TnFjbW13?=
 =?utf-8?Q?hSzk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189e9c5d-7495-4873-f41e-08db11a68d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 11:52:03.4791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Tr/aQS8nG+gAxrawo+7e2v5V+qV/XFy9bS1TVGlOdHE/FLWuz9IOLzWEQ4sAYujHVnifo6sS8EX4nF1Xy5BRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7717
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJpY2hhcmQgV2VpbmJlcmdl
ciA8cmljaGFyZEBub2QuYXQ+DQo+IFNlbnQ6IDIwMjPlubQy5pyIMTjml6UgMTc6NDMNCj4gVG86
IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPjsgRGF2aWQgTGFpZ2h0DQo+IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT47IG5ldGRl
diA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFNoZW53ZWkNCj4gV2FuZyA8c2hlbndlaS53YW5n
QG54cC5jb20+OyBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+Ow0KPiBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogaGlnaCBsYXRlbmN5IHdp
dGggaW14OG1tIGNvbXBhcmVkIHRvIGlteDZxDQo+IA0KPiAtLS0tLSBVcnNwcsO8bmdsaWNoZSBN
YWlsIC0tLS0tDQo+ID4gVm9uOiAid2VpIGZhbmciIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+PiA+
IElzIGl0IGp1c3QgaW50ZXJydXB0IGxhdGVuY3kgY2F1c2VkIGJ5IGludGVycnVwdCBjb2FsZXNj
aW5nIHRvDQo+ID4+ID4gYXZvaWQgZXhjZXNzaXZlIGludGVycnVwdHM/DQo+ID4+DQo+ID4+IEp1
c3QgYWRkaW5nIHRvIHRoaXMsIGl0IGFwcGVhcnMgaW14NnEgZG9lcyBub3QgaGF2ZSBzdXBwb3J0
IGZvcg0KPiA+PiBjaGFuZ2luZyB0aGUgaW50ZXJydXB0IGNvYWxlc2NpbmcuIGlteDhtIGRvZXMg
YXBwZWFyIHRvIHN1cHBvcnQgaXQuDQo+ID4+IFNvIHRyeSBwbGF5aW5nIHdpdGggZXRodG9vbCAt
Yy8tQy4NCj4gPj4NCj4gPiBZZXMsIEkgYWdyZWUgd2l0aCBBbmRyZXcsIHRoZSBpbnRlcnJ1cHQg
Y29hbGVzY2VuY2UgZmVhdHVyZSBkZWZhdWx0IHRvDQo+ID4gYmUgZW5hYmxlZCBvbiBpLk1YOE1N
IHBsYXRmb3Jtcy4gVGhlIHB1cnBvc2Ugb2YgdGhlIGludGVycnVwdA0KPiA+IGNvYWxlc2Npbmcg
aXMgdG8gcmVkdWNlIHRoZSBudW1iZXIgb2YgaW50ZXJydXB0cyBnZW5lcmF0ZWQgYnkgdGhlIE1B
Qw0KPiA+IHNvIGFzIHRvIHJlZHVjZSB0aGUgQ1BVIGxvYWRpbmcuDQo+ID4gQXMgQW5kcmV3IHNh
aWQsIHlvdSBjYW4gdHVybiBkb3duIHJ4LXVzZWNzIGFuZCB0eC11c2VjcywgYW5kIHRoZW4gdHJ5
IGFnYWluLg0KPiANCj4gSG0sIEkgdGhvdWdodCBteSBzZXR0aW5ncyBhcmUgZmluZSAoSU9XIG5v
IGNvYWxlc2NpbmcgYXQgYWxsKS4NCj4gQ29hbGVzY2UgcGFyYW1ldGVycyBmb3IgZXRoMDoNCj4g
QWRhcHRpdmUgUlg6IG4vYSAgVFg6IG4vYQ0KPiByeC11c2VjczogMA0KPiByeC1mcmFtZXM6IDAN
Cj4gdHgtdXNlY3M6IDANCj4gdHgtZnJhbWVzOiAwDQo+IA0KVW5mb3J0dW5hdGVseSwgdGhlIGZl
YyBkcml2ZXIgZG9lcyBub3Qgc3VwcG9ydCB0byBzZXQgcngtdXNlY3MvcngtZnJhbWVzL3R4LXVz
ZWNzL3R4LWZyYW1lcw0KdG8gMCB0byBkaXNhYmxlIGludGVycnVwdCBjb2FsZXNjaW5nLiAwIGlz
IGFuIGludmFsaWQgcGFyYW1ldGVycy4gOigNCg0KPiANCj4gQnV0IEkgbm90aWNlZCBzb21ldGhp
bmcgaW50ZXJlc3RpbmcgdGhpcyBtb3JuaW5nLiBXaGVuIEkgc2V0IHJ4LXVzZWNzLCB0eC11c2Vj
cywNCj4gcngtZnJhbWVzIGFuZCB0eC1mcmFtZXMgdG8gMSwgKnNvbWV0aW1lcyogdGhlIFJUVCBp
cyBnb29kLg0KPiANCj4gUElORyAxOTIuMTY4LjAuNTIgKDE5Mi4xNjguMC41MikgNTYoODQpIGJ5
dGVzIG9mIGRhdGEuDQo+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT0xIHR0
bD02NCB0aW1lPTAuNzMwIG1zDQo+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3Nl
cT0yIHR0bD02NCB0aW1lPTAuMzU2IG1zDQo+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBp
Y21wX3NlcT0zIHR0bD02NCB0aW1lPTAuMzAzIG1zDQo+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4w
LjUyOiBpY21wX3NlcT00IHR0bD02NCB0aW1lPTIuMjIgbXMNCj4gNjQgYnl0ZXMgZnJvbSAxOTIu
MTY4LjAuNTI6IGljbXBfc2VxPTUgdHRsPTY0IHRpbWU9Mi41NCBtcw0KPiA2NCBieXRlcyBmcm9t
IDE5Mi4xNjguMC41MjogaWNtcF9zZXE9NiB0dGw9NjQgdGltZT0wLjM1NCBtcw0KPiA2NCBieXRl
cyBmcm9tIDE5Mi4xNjguMC41MjogaWNtcF9zZXE9NyB0dGw9NjQgdGltZT0yLjIyIG1zDQo+IDY0
IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT04IHR0bD02NCB0aW1lPTIuNTQgbXMN
Cj4gNjQgYnl0ZXMgZnJvbSAxOTIuMTY4LjAuNTI6IGljbXBfc2VxPTkgdHRsPTY0IHRpbWU9Mi41
MyBtcw0KPiANCj4gU28gY29hbGVzY2luZyBwbGF5cyBhIHJvbGUgYnV0IGl0IGxvb2tzIGxpa2Ug
dGhlIGV0aGVybmV0IGNvbnRyb2xsZXIgZG9lcyBub3QNCj4gYWx3YXlzIG9iZXkgbXkgc2V0dGlu
Z3MuDQo+IEkgZGlkbid0IGxvb2sgaW50byB0aGUgY29uZmlndXJlZCByZWdpc3RlcnMgc28gZmFy
LCBtYXliZSBldGh0b29sIGRvZXMgbm90IHNldA0KPiB0aGVtIGNvcnJlY3RseS4NCj4gDQpJdCBs
b29rIGEgYml0IHdlaXJkLiBJIGRpZCB0aGUgc2FtZSBzZXR0aW5nIHdpdGggbXkgaS5NWDhVTFAg
YW5kIGRpZG4ndCBoYXZlIHRoaXMNCmlzc3VlLiBJJ20gbm90IHN1cmUgd2hldGhlciB5b3UgbmV0
d29yayBpcyBzdGFibGUgb3IgbmV0d29yayBub2RlIGRldmljZXMgYWxzbw0KZW5hYmxlIGludGVy
cnVwdCBjb2FsZXNjaW5nIGFuZCB0aGUgcmVsZXZhbnQgcGFyYW1ldGVycyBhcmUgc2V0IHRvIGEg
Yml0IGhpZ2guDQo=
