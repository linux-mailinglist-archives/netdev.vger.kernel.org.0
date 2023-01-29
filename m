Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FC867FD94
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 09:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjA2IRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 03:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2IRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 03:17:02 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2101.outbound.protection.outlook.com [40.107.101.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F389513D4D
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 00:17:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETiCfamwZRp8u9BKpbLx2xmPi8hBGYu8AdxITeOWLsjG9T+WphfDGNSvxPQeUtulZb62wSW1VY+b8ESMbpjWEGfDeHlaMMpWIgIEfABHuoNjPynRjUk9MHdLLLUhiI7U2jV+jOiBYjW3GgZeCnznkfF+1zEfIFPTd801KcO//zJtBZWPzQFWkHlwMXwHOy8Pc5o/g4V4NYJ3A9Uw7dSDHEY3/CYM9ib2n9yqgU2E/hkEqttLAoxIFMpXL1fr+0DROYEFHBUOfpNccsjNwbJLlXDCC8Urgo84Krbs5bMVQZ2TifyrcV92XiROY8sc1eSkON0hpzypTCyrj2m8itDQmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGaQeiBBeUQdy6IBVx1jwrd8nTispkHakw7+PmyvczQ=;
 b=VX+Jd5JE04qQY4fZKtpjLGZDcnHWlK/hsuSCIQ3e9Yz+AB9K0FVGheFbttZzEQfKosuFVEyJo27yz1lmpTszcOI6gei8WizbwoVSL1sLwXdOCJ1Y3nxrlpA4V9SYnnns27p7dA7FHXbjXsnruzU458PBlubuTQNi77GgQ/ztqyX0GIxVtYyc61RRy8API3/2Ukwt8petT4utqUKkhWlzUiEOatYiIcIGFqQSrA+K4anzc7dTt6s4/aNLmCNRJamMYm0FIYC1BaNrrXmFJJgM3r4uX0npQuVsVbbfeqge8CL2dGXTNvhnrTiIPeHklxAuMR6toq4o1A3x6nWhvn198A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGaQeiBBeUQdy6IBVx1jwrd8nTispkHakw7+PmyvczQ=;
 b=lq4mLgLozfM5x3kcGf7wUDfGVBSg9U+fBvfTTiq2ncD30MgRzHz/HsIPzBEFhFB1yTeoJpIMrO4Q3X1qUvvePUS/xUdsHajhwz7TTrfVRB6Y4pZ/rTgGavthnXxxG9S2g31OBIXfUNkGVvnv4ZhJV7ZcdadFMonV64+O2x29x78=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by MW4PR13MB5506.namprd13.prod.outlook.com (2603:10b6:303:182::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Sun, 29 Jan
 2023 08:16:58 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::b703:fe66:3307:cc89]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::b703:fe66:3307:cc89%9]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 08:16:57 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>
CC:     Marcelo Leitner <mleitner@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: RE: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Topic: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Index: AQHY/mSdmThOr7A34UyDPeUsz+fSLa5OwOIAgAAoYjCAAMvsAIAENEkQgABvloCAAAG8AIAABGCAgAGCGgCAAPMOMIADvx+AgAACRRCAAAPdAIBa24jQ
Date:   Sun, 29 Jan 2023 08:16:56 +0000
Message-ID: <PH0PR13MB4793B28A3E695512BD469DCA94D29@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
 <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
 <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
 <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
 <A92B3AD9-296F-4B20-88AC-D9F4124C15A9@redhat.com>
 <PH0PR13MB4793ED98F9384F2CBBA0909094179@PH0PR13MB4793.namprd13.prod.outlook.com>
 <077229AF-F32B-4147-9F3C-FED786417E61@redhat.com>
In-Reply-To: <077229AF-F32B-4147-9F3C-FED786417E61@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|MW4PR13MB5506:EE_
x-ms-office365-filtering-correlation-id: abfba94b-c922-450d-d9f0-08db01d1302a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZUtplUv/7F/FYYKVutheGSvSELbVfMg8qwu/sJ8kEuxht6uP874FvWVN1tWWkn2jA70lpcINK0jKqbJFNNhYB+26it9B/xp+kV8qofte319cd/kVxvsXsEOpx9G3LQX3RRC/o9PXubsatw+h5Ie2AsF4OgfnmCcEZmcYlduKOzB8JbMGfEV9CIwCdfWxnQ0Wh/qauZ6HQ+PYCiSjPd9Q0N0/mEkL+04V1y440w8shVnnEwO3D0iv5J/yBRmgSs4eSx45SJhwF84WDNtZqVwPltMgEFlQFI813+Rqf5bHi+5bz/uaqgI0Rzmn6paMb+N0njVGvvZDKEknIZmqR9Hbqwq+4xP5RCdWJPcgyAzlwAZFuHRpocIYQP+4tntBplwtDrNmPVGpdNX1DtmO46sacu3s74+xZoEMFPWC22yPpuJtlHUKLz1/kAD88XY4lxyv3KlBGZ1eYujmyaDtWaOhXKP1fl0RwJ9UGsn+7WRmehBTBkMPcspr1/KgQ70CWHjbtV1cXFmhF8IfXJnfM//HO/EoZJWasAK428zsQePzQ6jJ4PoKjbRB6/RA4gnJIHbudqAsqVqR+fxtFi998Yn0m9VeU6+t7rHZsG6gooKUIHVExWuH4XnWb4kMG3JWaRWEyD6wF2mbOOuYEIHlCzfYVvctlcP3izpTjOnszIPK+r+hwCS2w1lyZHjE1jSncUeMfEpWmlkqJSMF+dMqsGUKlUuVLXABCK8BXYEESG6TlR6yOQRwvoGBtnMK1ApVgTZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(346002)(39830400003)(451199018)(33656002)(52536014)(5660300002)(7416002)(64756008)(4326008)(76116006)(66476007)(6916009)(66556008)(66446008)(66946007)(55016003)(8676002)(44832011)(83380400001)(41300700001)(8936002)(6506007)(53546011)(9686003)(478600001)(26005)(7696005)(2906002)(38070700005)(107886003)(122000001)(38100700002)(71200400001)(316002)(54906003)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWJHU3FDanQwRCtBeHJZaDkwNjFPODlKaVZMNjdFeWowcUxoK25uSHloMExV?=
 =?utf-8?B?Uzd1Q255RFpabVVSODAyZ1dsVXo5aG5VMVgxcXV5VVlCU3FlSVNsUWZLVWJK?=
 =?utf-8?B?dUVqejFUSWFPbHlFdGpBZW5jMEVncDkwTlU4ckZuYjNQaDgwYVcwa01sODd2?=
 =?utf-8?B?bXFodFNkcFR1OVZCUkZBdDdaRFZ5TzBHek5kWDh6OW5OTlVkZWhERjZDWFg4?=
 =?utf-8?B?bU11THBKRE4vL20xeU01NUFDMHplc2w2TnVETlB2NkhNWlY5RzZQV1RXMTlS?=
 =?utf-8?B?TjFYZ21ieUpvZlVyQWdWc1VpYVdXMWI0QWJLRkloQXRVdDVJK09Yb1JPc2xE?=
 =?utf-8?B?a2d3ZFl1bjNUWUR3R210ZzFCQjlFVUhnb2ovdzBXRDdnK0d6ek9UYnpBNjZu?=
 =?utf-8?B?V0hmTHRTdVBjWVhyN1pOdmh4VjVVQ0dVMTl4R1JDQmsxQXIrLzU5M1EzVkli?=
 =?utf-8?B?K0VxN0wzZ20zcDBmSTVLbmM2dVVmT2c4V1BtbDZhZGEzaXpmL0VoQmt2ZEhM?=
 =?utf-8?B?Umd0T3FOK2Jhb3U1d0dIWWlQQUdVWUlob1dkakhLQ1JVL3k4dlZFeFZkY3hC?=
 =?utf-8?B?YTFwTWpVMlBhYm5RelNXMnhjYVJXckU2dFRram9kQmk2enVWVGVWdncwcnFt?=
 =?utf-8?B?UHNYdW5tbE1rT3hsTXBGZFAza085Um9rcWhoSUc4MG9KbTBVdHY1Rlh0N29T?=
 =?utf-8?B?aEdrYkNIcU9NRTZrREgyZllZRTZpWkJub2FaQXJad0M5RU8yeTRnVzVXalFm?=
 =?utf-8?B?NFZJa2dsU044Q2RPTkJvVzNQcytLVXNWMDd5NDc3aFdwd203OXIzT011bWRF?=
 =?utf-8?B?d1kvWTdmTjlOTEpDSE9tSkVaVGlJcWhRdjFuVWR2WnFUZ2pVWk1jMkdqVGNB?=
 =?utf-8?B?Q09Ya0hyZTBscXhwdnFWZThvVmFFa2VGUGgyeFRlM2JYdXUrV0xzVTB1WDZ4?=
 =?utf-8?B?VXBod3R4QTR0SjVucFZyT1VoaXJXNWc4U00yNjV0WmFKaHZnemFLVTczUDRk?=
 =?utf-8?B?bGN5K0tHNDVkUk4zd3ZYODVQZ3ZWZHFwZzFlRnE4VkhPVHJ4NVExTWVlZ1Nm?=
 =?utf-8?B?bFpXN0RORUVNOVljdzJPaFpQV2FRazhOWEsrc3pQeUo4OWNpUFZkSndSTTlj?=
 =?utf-8?B?V3IvWGdUelRiN3hKMmFBaW9EQU9vbDkyMHIyWUFrTXkrZUdQSTRVWGRCRXhk?=
 =?utf-8?B?ZjhqY0tTQ1dES2FveXpWM2lqVWVBeGpTblJYeXJ4MGdvNTRFYjIyTC82VTVB?=
 =?utf-8?B?anlSUlhzbno2MlhKUFFlSG8zUmxYTjM0aGwrd2hwSnJHay93RUJTZVlYaW40?=
 =?utf-8?B?dDFNbHYrbXZuRHljWkx5R0dWTmxrYU1TRjRaMXA0TkFPOEkzd0l5dm9HeWRo?=
 =?utf-8?B?OExnZnVaUHRSUHFYUzlnekhVM3VWNzhUeVVUc2xIeGVMd0Mzc0NrSmdIQ3NM?=
 =?utf-8?B?Vm9XUWNYZ0hFSlRGTG5MOHBiOW1QNFlyMXZ3RG1tRkFLYlllZG5nZEJkc1dV?=
 =?utf-8?B?S2ZUZUVpcmh2RU82UUFsTGdVYlIzbEpKRTRvRXJuT1cyNnQ2bkdnSFZjUzF0?=
 =?utf-8?B?clZUdzM5TmFIYlJ3Q2E3bU1ENE1Za3dad2FuZ1VUVUpYSWlpL0VCOHN0bFg1?=
 =?utf-8?B?R1VPU00rRGhlNkVKKytjT2gyenFGMHkweTdSQmJtYkZmNUFyRkZGWHRIQ244?=
 =?utf-8?B?aFBvMkkrOU5SaGlRTm91Z3AxT3lpQmhmMXhPSmlibUNBTkZDNWpvY3JkSXBI?=
 =?utf-8?B?WGdHanpucWI2dEY2cW5LSTh0ZDZRSzJrZmJ3U2hpSEpGU1VPc0crQk5Kd0RW?=
 =?utf-8?B?SDh1RHVTS2ZNampsNm5nU25GVFdmMkZuSHgvSlAxSUQvRnNqSEV2VWMrL3pW?=
 =?utf-8?B?NDJCcDVHSVYxc2JIWE1QKzB4SkN4dXk0cGpvYjdjOEd0R0RXWEN5QUJPY1Ez?=
 =?utf-8?B?Tk9NUkd0dXIxUzlOZG1UMHQwY0lHZ0ZCQU1jVVlKeUxlUEVmNGNIQ2p1NnV1?=
 =?utf-8?B?UGpGdUhYTk5IOHdCa3JiNTBSUGdkUEJlNkJKcGFDUHFmMWJZVU5PNWwxVFZy?=
 =?utf-8?B?RFBaVWkrc1pmSGlnU3VUaWkxUW1EdjlDTFoveGJ4TElNSFlSUk11WUtLSndI?=
 =?utf-8?Q?3bxzJpt7hFo6c6ARP4zVUNrZH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfba94b-c922-450d-d9f0-08db01d1302a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 08:16:57.0495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0bx0vK1c+WN8Of+CrCdXl69ipdv1X2yUo4L7I4ntgs2ikcCte544byvC4kFv7bCnijZR0oXzArhfWrmytOyJbNMOMnKNDk5wDO9vt+jG+QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5506
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMiBEZWMgMjAyMiwgYXQgODo0MCBQTSwgRWVsY28gQ2hhdWRyb24gd3JvdGU6DQo+IA0KPiBP
biAyIERlYyAyMDIyLCBhdCAxMzozMywgVGlhbnl1IFl1YW4gd3JvdGU6DQo+IA0KPiA+IE9uIEZy
aSwgRGVjIDIsIDIwMjIgYXQgODoxOCBQTSAsIEVlbGNvIENoYXVkcm9uIHdyb3RlOg0KPiA+Pg0K
PiA+PiBPbiAzMCBOb3YgMjAyMiwgYXQgNDozNiwgVGlhbnl1IFl1YW4gd3JvdGU6DQo+ID4+DQo+
ID4+PiBPbiBNb24sIE5vdiAyOSwgMjAyMiBhdCA4OjM1IFBNICwgRWVsY28gQ2hhdWRyb24gd3Jv
dGU6DQo+ID4+Pj4NCj4gPj4+PiBPbiAyOCBOb3YgMjAyMiwgYXQgMTQ6MzMsIE1hcmNlbG8gTGVp
dG5lciB3cm90ZToNCj4gPj4+Pg0KPiA+Pj4+PiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCAwMjox
Nzo0MFBNICswMTAwLCBFZWxjbyBDaGF1ZHJvbiB3cm90ZToNCj4gPj4+Pj4+DQo+ID4+Pj4+Pg0K
PiA+Pj4+Pj4gT24gMjggTm92IDIwMjIsIGF0IDE0OjExLCBNYXJjZWxvIExlaXRuZXIgd3JvdGU6
DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4+IE9uIE1vbiwgTm92IDI4LCAyMDIyIGF0IDA3OjExOjA1QU0g
KzAwMDAsIFRpYW55dSBZdWFuIHdyb3RlOg0KPiA+Pj4+PiAuLi4NCj4gPj4+Pj4+Pj4NCj4gPj4+
Pj4+Pj4gRnVydGhlcm1vcmUsIEkgdGhpbmsgdGhlIGN1cnJlbnQgc3RhdHMgZm9yIGVhY2ggYWN0
aW9uDQo+ID4+Pj4+Pj4+IG1lbnRpb25lZCBpbg0KPiA+Pj4+Pj4+PiAyKSBjYW5ub3QgcmVwcmVz
ZW50IHRoZSByZWFsIGh3IHN0YXRzIGFuZCB0aGlzIGlzIHdoeSBbIFJGQw0KPiA+Pj4+Pj4+PiBu
ZXQtbmV4dCB2MiAwLzJdIChuZXQ6IGZsb3dfb2ZmbG9hZDogYWRkIHN1cHBvcnQgZm9yIHBlciBh
Y3Rpb24NCj4gPj4+Pj4+Pj4gaHcgc3RhdHMpDQo+ID4+Pj4gd2lsbCBjb21lIHVwLg0KPiA+Pj4+
Pj4+DQo+ID4+Pj4+Pj4gRXhhY3RseS4gVGhlbiwgd2hlbiB0aGlzIHBhdGNoc2V0IChvciBzaW1p
bGFyKSBjb21lIHVwLCBpdCB3b24ndA0KPiA+Pj4+Pj4+IHVwZGF0ZSBhbGwgYWN0aW9ucyB3aXRo
IHRoZSBzYW1lIHN0YXRzIGFueW1vcmUuIEl0IHdpbGwgcmVxdWlyZQ0KPiA+Pj4+Pj4+IGEgc2V0
IG9mIHN0YXRzIGZyb20gaHcgZm9yIHRoZSBnYWN0IHdpdGggUElQRSBhY3Rpb24gaGVyZS4gQnV0
DQo+ID4+Pj4+Pj4gaWYgZHJpdmVycyBhcmUgaWdub3JpbmcgdGhpcyBhY3Rpb24sIHRoZXkgY2Fu
J3QgaGF2ZSBzcGVjaWZpYw0KPiA+Pj4+Pj4+IHN0YXRzIGZvciBpdC4gT3IgYW0gSSBtaXNzaW5n
IHNvbWV0aGluZz8NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IFNvIGl0IGlzIGJldHRlciBmb3IgdGhl
IGRyaXZlcnMgdG8gcmVqZWN0IHRoZSB3aG9sZSBmbG93IGluc3RlYWQNCj4gPj4+Pj4+PiBvZiBz
aW1wbHkgaWdub3JpbmcgaXQsIGFuZCBsZXQgdnN3aXRjaGQgcHJvYmUgaWYgaXQgc2hvdWxkIG9y
DQo+ID4+Pj4+Pj4gc2hvdWxkIG5vdCB1c2UgdGhpcyBhY3Rpb24uDQo+ID4+Pj4+Pg0KPiA+Pj4+
Pj4gUGxlYXNlIG5vdGUgdGhhdCBPVlMgZG9lcyBub3QgcHJvYmUgZmVhdHVyZXMgcGVyIGludGVy
ZmFjZSwgYnV0DQo+ID4+Pj4+PiBkb2VzIGl0DQo+ID4+Pj4gcGVyIGRhdGFwYXRoLiBTbyBpZiBp
dOKAmXMgc3VwcG9ydGVkIGluIHBpcGUgaW4gdGMgc29mdHdhcmUsIHdlIHdpbGwNCj4gPj4+PiB1
c2UgaXQuIElmIHRoZSBkcml2ZXIgcmVqZWN0cyBpdCwgd2Ugd2lsbCBwcm9iYWJseSBlbmQgdXAg
d2l0aCB0aGUNCj4gPj4+PiB0YyBzb2Z0d2FyZQ0KPiA+PiBydWxlIG9ubHkuDQo+ID4+Pj4+DQo+
ID4+Pj4+IEFoIHJpZ2h0LiBJIHJlbWVtYmVyIGl0IHdpbGwgcGljayAxIGludGVyZmFjZSBmb3Ig
dGVzdGluZyBhbmQgdXNlDQo+ID4+Pj4+IHRob3NlIHJlc3VsdHMgZXZlcnl3aGVyZSwgd2hpY2gg
dGhlbiBJIGRvbid0IGtub3cgaWYgaXQgbWF5IG9yIG1heQ0KPiA+Pj4+PiBub3QgYmUgYSByZXBy
ZXNlbnRvciBwb3J0IG9yIG5vdC4gQW55aG93LCB0aGVuIGl0IHNob3VsZCB1c2UNCj4gPj4+Pj4g
c2tpcF9zdywgdG8gdHJ5IHRvIHByb2JlIGZvciB0aGUgb2ZmbG9hZGluZyBwYXJ0LiBPdGhlcndp
c2UgSSdtDQo+ID4+Pj4+IGFmcmFpZCB0YyBzdyB3aWxsIGFsd2F5cyBhY2NlcHQgdGhpcyBmbG93
IGFuZCB0cmljayB0aGUgcHJvYmluZywgeWVzLg0KPiA+Pj4+DQo+ID4+Pj4gV2VsbCwgaXQgZGVw
ZW5kcyBvbiBob3cgeW91IGxvb2sgYXQgaXQuIEluIHRoZW9yeSwgd2Ugc2hvdWxkIGJlDQo+ID4+
Pj4gaGFyZHdhcmUgYWdub3N0aWMsIG1lYW5pbmcgd2hhdCBpZiB5b3UgaGF2ZSBkaWZmZXJlbnQg
aGFyZHdhcmUgaW4NCj4gPj4+PiB5b3VyIHN5c3RlbT8gT1ZTIG9ubHkgc3VwcG9ydHMgZ2xvYmFs
IG9mZmxvYWQgZW5hYmxlbWVudC4NCj4gPj4+Pg0KPiA+Pj4+IFRpYW55dSBob3cgYXJlIHlvdSBw
bGFubmluZyB0byBzdXBwb3J0IHRoaXMgZnJvbSB0aGUgT1ZTIHNpZGU/IEhvdw0KPiA+Pj4+IHdv
dWxkIHlvdSBwcm9iZSBrZXJuZWwgYW5kL29yIGhhcmR3YXJlIHN1cHBvcnQgZm9yIHRoaXMgY2hh
bmdlPw0KPiA+Pj4NCj4gPj4+IEN1cnJlbnRseSBpbiB0aGUgdGVzdCBkZW1vLCBJIGp1c3QgZXh0
ZW5kIGdhY3Qgd2l0aCBQSVBFIChwcmV2aW91c2x5DQo+ID4+PiBvbmx5IFNIT1QgYXMgZGVmYXVs
dCBhbmQgR09UT19DSEFJTiB3aGVuIGNoYWluIGV4aXN0cyksIGFuZCB0aGVuIHB1dA0KPiA+Pj4g
c3VjaCBhIGdhY3Qgd2l0aCBQSVBFIGF0IHRoZSBmaXJzdCBwbGFjZSBvZiBlYWNoIGZpbHRlciB3
aGljaCB3aWxsDQo+ID4+PiBiZSB0cmFuc2FjdGVkDQo+ID4+IHdpdGgga2VybmVsIHRjLg0KPiA+
Pj4NCj4gPj4+IEFib3V0IHRoZSB0YyBzdyBkYXRhcGF0aCBtZW50aW9uZWQsIHdlIGRvbid0IGhh
dmUgdG8gbWFrZSBjaGFuZ2VzDQo+ID4+PiBiZWNhdXNlIGdhY3Qgd2l0aCBQSVBFIGhhcyBhbHJl
YWR5IGJlZW4gc3VwcG9ydGVkIGluIGN1cnJlbnQgdGMNCj4gPj4+IGltcGxlbWVudGF0aW9uIGFu
ZCBpdCBjb3VsZCBhY3QgbGlrZSBhICdjb3VudGVyJyBBbmQgZm9yIHRoZQ0KPiA+Pj4gaGFyZHdh
cmUgd2UganVzdCBuZWVkIHRvIGlnbm9yZSB0aGlzIFBJUEUgYW5kIHRoZSBzdGF0cyBvZiB0aGlz
DQo+ID4+PiBhY3Rpb24gd2lsbCBzdGlsbCBiZQ0KPiA+PiB1cGRhdGVkIGluIGtlcm5lbCBzaWRl
IGFuZCBzZW50IHRvIHVzZXJzcGFjZS4NCj4gPj4NCj4gPj4gSSBrbm93IGl04oCZcyBzdXBwb3J0
ZWQgbm93LCBidXQgaWYgd2UgaW1wbGVtZW50IGl0LCBpdCBtaWdodCBmYWlsIGluDQo+ID4+IGV4
aXN0aW5nIGVudmlyb25tZW50cy4gU28gZnJvbSBhbiBPVlMgdXNlcnNwYWNlIHBlcnNwZWN0aXZl
LCB5b3UgbmVlZA0KPiA+PiB0byBpbXBsZW1lbnQgc29tZXRoaW5nIGxpa2U6DQo+ID4NCj4gPiBJ
J3ZlIGdvdCB5b3VyIHBvaW50IG5vdywgc29ycnkgZm9yIG15IG1pc3VuZGVyc3RhbmRpbmcgcHJl
dmlvdXNseS4NCj4gDQo+IE5vIHByb2JsZW0sIHRoZXJlIGFyZSBxdWl0ZSBzb21lIGVtYWlscyBh
cm91bmQgdGhpcyBwYXRjaC4NCj4gDQo+ID4+IC0gUHJvYmUgdGhlIGtlcm5lbCB0byBzZWUgaWYg
dGhpcyBwYXRjaCBpcyBhcHBsaWVkLCBpZiBub3QgdXNlIHRoZQ0KPiA+PiBvbGQgbWV0aG9kIHNv
IHdlIGRvIG5vdCBicmVhayBleGlzdGluZyBkZXBsb3ltZW50cyB3aGVuIHVwZ3JhZGluZw0KPiBP
VlMNCj4gPj4gYnV0IG5vdCB0aGUga2VybmVsLg0KPiA+PiAtIElmIHdlIGRvIGhhdmUgdGhpcyBu
ZXdlciBrZXJuZWwsIGRvIHdlIGFzc3VtZSBhbGwgZHJpdmVycyB0aGF0DQo+ID4+IHdvcmtlZCBi
ZWZvcmUsIG5vdyBhbHNvIHdvcms/DQo+ID4+ICAgLSBJZiB0aGlzIGlzIG5vdCB0aGUgY2FzZSwg
aG93IHdpbGwgeW91IGRldGVybWluZSB3aGF0IGFwcHJvYWNoIHRvDQo+ID4+IHVzZT8gV2UgZG8g
bm90IGhhdmUgYSBwZXItaW50ZXJmYWNlIGxheWVyLCBidXQgYSBwZXItZGF0YXBhdGggb25lLA0K
PiA+PiBpLmUuIHRoZSBrZXJuZWwuIFdlIGRvIG5vdCBrbm93IGF0IGluaXRpYWxpemF0aW9uIHRp
bWUgd2hhdCBOSUNzIHdpbGwNCj4gPj4gYmUgYWRkZWQgbGF0ZXIgYW5kIHdlIGNhbiBub3QgZGVj
aWRlIG9uIHRoZSBzdHJhdGVneSB0byB1c2UuDQo+ID4+DQo+ID4+IFRob3VnaHQ/IE1heWJlIHRo
aXMgc2hvdWxkIGJlIGRpc2N1c3NlZCBvdXRzaWRlIG9mIHRoZSBuZXRkZXYgbWFpbGluZw0KPiA+
PiBsaXN0LCBidXQgd2hhdCBJIHdhbnQgdG8gaGlnaGxpZ2h0IGlzIHRoYXQgdGhlcmUgc2hvdWxk
IGJlIGEgcnVudGltZQ0KPiA+PiB3YXkgdG8gZGV0ZXJtaW5lIGlmIHRoaXMgcGF0Y2ggaXMgYXBw
bGllZCB0byB0aGUga2VybmVsICh3aXRob3V0DQo+ID4+IHVzaW5nIGFueSBhY3R1YWwgaHcgZHJp
dmVyKS4NCj4gPg0KPiA+IEkgYWdyZWUgdGhhdCB3aGV0aGVyIHRoZSBwYXRjaCBpcyBhcHBsaWVk
IGluIGtlcm5lbCBzaG91bGQgYmUgY2hlY2tlZA0KPiA+IGF0IHJ1bnRpbWUgcmF0aGVyIHRoYW4g
Y29tcGlsaW5nIChmb3IgdGhlIGRlbW8gSSBtYWRlIHRoaXMgY2hlY2sNCj4gPiBpbmFjaW5sdWRl
Lm00KS4gSSB0aGluayBJIG5lZWQgc29tZSB0aW1lIHRvIGludmVzdGlnYXRlIGhvdyB0byBpbXBs
ZW1lbnQgaXQuDQo+IFdlIG1heSBkaXNjdXNzIGl0IGxhdGVyIGluIGFuIE9WUyBtYWlsaW5nIGxp
c3QuDQo+IA0KPiBObyBwcm9ibGVtLCBidXQganVzdCB3YW50IHRvIG1ha2Ugc3VyZSB0aGF0IGlm
IGl0IG5lZWRzIGNoYW5nZXMgdG8gdGhpcyBwYXRjaA0KPiB0byBiZSBhYmxlIHRvIGRvIGl0LCBu
b3cgaXMgdGhlIHRpbWUgOykNCg0KU29ycnkgdG8gbm90IHJlcGx5IGZvciBzdWNoIGEgbG9uZyB0
aW1lLg0KDQpJIG1hZGUgc29tZSBpbnZlc3RpZ2F0aW9uIG9uIGhvdyB0byBwcm9iZSBzaW5nbGUg
cGlwZSBhY3Rpb24gb2ZmbG9hZCBzdXBwb3J0IGluDQpPVlMgc2lkZSBhbmQgZm91bmQgdGhhdCB3
ZSBkb24ndCBoYXZlIHRvIG1ha2UgY2hhbmdlIGluIGtlcm5lbCBmb3IgdGhpcyBwcm9iZQ0KcHVy
cG9zZS4NCg0KTWF5YmUgd2UgY291bGQgcHJvY2VzcyB0aGlzIGtlcm5lbCB0YyBhbmQgZHJpdmVy
IGNoYW5nZXMgYWZ0ZXIgT1ZTIG9uZS4NCkxvb2sgZm9yd2FyZCB0byBkaXNjdXNzaW5nIHdpdGgg
eW91IGluIE9WUyBzaWRlIPCfmIoNCg0KQ2hlZXJzLA0KVGlhbnl1DQoNCj4gDQo+IA0KPiA+Pj4g
SSBhZ3JlZSB3aXRoIHRoYXQgdGhlIHVuc3VwcG9ydGVkIGFjdGlvbnMgc2hvdWxkIGJlIHJlamVj
dGVkIGJ5DQo+ID4+PiBkcml2ZXJzLCBzbyBtYXkgYW5vdGhlciBhcHByb2FjaCBjb3VsZCB3b3Jr
IHdpdGhvdXQgaWdub3JpbmcgUElQRSBpbg0KPiA+Pj4gYWxsIHRoZSByZWxhdGVkIGRyaXZlcnMs
IHRoYXQgd2UgZGlyZWN0bHkgbWFrZSBwdXQgdGhlIGZsb3dlciBzdGF0cw0KPiA+Pj4gZnJvbSBk
cml2ZXIgaW50byB0aGUgc29ja2V0IHdoaWNoIGlzIHVzZWQgdG8gdHJhbnNhY3Qgd2l0aCB1c2Vy
c3BhY2UNCj4gPj4+IGFuZA0KPiA+PiB1c2Vyc3BhY2UoZS5nLiBPVlMpIHVwZGF0ZSB0aGUgZmxv
dyBzdGF0cyB1c2luZyB0aGlzIHN0YXRzIGluc3RlYWQgb2YNCj4gPj4gdGhlIHBhcnNpbmcgdGhl
IGFjdGlvbiBzdGF0cy4gSG93IGRvIHlvdSB0aGluayBvZiB0aGlzPw0KDQo=
