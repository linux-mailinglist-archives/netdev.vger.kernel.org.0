Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEDB68FB39
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBHXdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjBHXdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:33:12 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2109.outbound.protection.outlook.com [40.107.215.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1311717E;
        Wed,  8 Feb 2023 15:33:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4/8/NFlyoW1PpYQhWw3t0RqqcdTITtiCMj3Wze4nq2+2R+KpaW2fPuiKxMBDrB+1NF/B0MuJEe0RkH07uEH72zjyzXQ4mFHwWJDzVIpiivVySVLhPpong0ipJDIOsOsg7t3z/NjtsHpJfIF8jEAVusEZPCpmZAk6pKIwaR0r4hhfPxMQR8qpWdQRSBvejO2R4VgW5p9OaTQurcCqM51SPn8uKkH2449gGegyW0frTiVR4p/72LF1hxn8Yw4lixTnxjpGVfnUK85Zm59hFEVCkaI7BJ3Ob7H4SQ50S29JqDwfbz6IlsHH2qSN3mVFl+aWAqvVBGGqSVNSmDAp09vtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrtF2vbAndq/R5/04PAd2Uct1eHejkCkXJr9fPfc7ck=;
 b=hYra2fPTOnNh3f9tuZiEFPHMIo3xM3IPJNZSO434sW5E6C6Hsuv9HINRGu3uCmKZP81JQtzMkkJJHbwCyvFjRmexxUFLYWId0aYN4n5YFYgXLjDUdf8h9yhlJUrYIQwKGVMcNLZ1Hxor3y2OOds/hDUcxHvgAJ3Psp5p7NjuiUO3qFOrzQXOrvldo4va07AyYL8E9C//U8GpUBbiJmEbuDLufjvc8N/IONKhjGe+87XVYhic9fFem0S0elAOeQw8eYqqvM74ebGLQ6RCtxP6l2jf01un2epnHHw39u5EWDRHkhIhuRFUJ7jJImgC4a46YqpmQc4vC0AvQk+bxgVwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrtF2vbAndq/R5/04PAd2Uct1eHejkCkXJr9fPfc7ck=;
 b=j+iJu/X+7u8LIzpclX8VvGQ6osuEqwgxCjrJOS8Xvxu3CUG6+vX1+GqxHDjbhdnCrRnBIRFLHUqxLke2OEApHa8k39saFrcCRPts55onIRd76Az5qVQSPCzEQejINUrfVQ89C1EnGJuCxX4QbJvHF7rs9+UTTiyXlkxdCRk8WYA=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS0PR01MB6130.jpnprd01.prod.outlook.com
 (2603:1096:604:cb::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 23:33:06 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:33:06 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag from
 rswitch_gwca_queue
Thread-Topic: [PATCH net-next 3/4] net: renesas: rswitch: Remove gptp flag
 from rswitch_gwca_queue
Thread-Index: AQHZO4/XWkjOagyXYUyGke476gwxR67FN4YAgAB3t1A=
Date:   Wed, 8 Feb 2023 23:33:06 +0000
Message-ID: <TYBPR01MB5341C01EC932D1F53AEF188AD8D89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
         <20230208073445.2317192-4-yoshihiro.shimoda.uh@renesas.com>
 <4c2955c227087a2d50d3c7179e5edc2f392db1fc.camel@gmail.com>
In-Reply-To: <4c2955c227087a2d50d3c7179e5edc2f392db1fc.camel@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS0PR01MB6130:EE_
x-ms-office365-filtering-correlation-id: 6984de87-87d9-4b74-8bc4-08db0a2cd495
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgKbMKT2keGWh4Wg4MhpHiU+WI94xCE1DquoP6tJlNIxHA3/3sTT1CIncc4M+y3wf6jy1/XAZ15r62dstfOflitHv1LD26+YLpQ27q4i1dRAKu2D+E2YeiVM/TucZeUVZbh9pWMOKXCV2il9DObkavdzBO/lgc7mSQHgrv2rUQhTBtvl46caXV8BHxRlQ7AW6GZbM4HTTfKq1jnNcG6nR3ILLRgZUEfA6J3Jf6szd4OU2r8uwoxKGXD/DK7xJiLVrLUolPRYaau+wIP8riJMw6LOGt5mBIA3FliYDJWegAT7pmUEPc02ErVJXUByuHid3SSfYJ8nMdDVsciPe/mjxiLr7iWfk2DGnH0Zcl4HRh3fKwmuNCgPAYhC5i2jJZAHz5fVSDAvrV54Tgx3FUvAQ+KJ9fJneMcRbYXx3+YbhrM6kk6XB5oavqr2XwEosw44GsDjlbBUabEqz+AYZlt/mfwHzbkDWwogrQJ8R0S88iM1Pz/uZMuo5jQzOKDvlVO/rY7mcjRYzqfOPTo0P4BgiRHR3VX3pRj+l2F9TYS5f7INKqsp3k1tLOWQfMjmnhsOnN6D38Ua1OwIFuEXcWJqJK2WSGnEhL7cM1p3xLPa/o5OT8MqRdUQJurPinJSGfS4DnCVDr6CcLCsstXcxn/+B/x/JJ+EZg23mVYWdFDrpc/sFdx7C74N/ifU1PsD9bjccYNM0zzzHmixOVvyI9DeMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(55016003)(76116006)(38070700005)(110136005)(316002)(54906003)(2906002)(5660300002)(8936002)(86362001)(52536014)(8676002)(64756008)(66556008)(66946007)(4326008)(6506007)(41300700001)(66476007)(9686003)(186003)(66446008)(33656002)(7696005)(38100700002)(71200400001)(478600001)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ellIOEFIRmZUK2tzNXZqbmFxSGc2MEU3Z21GQ0piUTZSM3RhbzFLSUFnQmFI?=
 =?utf-8?B?dm1qaVpNZGRscy9yYmdCUlRuZERBZEYyd1lGa1kzeURNWHY0QmhRdUY4dGRC?=
 =?utf-8?B?d1djYW9zSjcyaENyUTlhQlBZek82R3pzd1ArZUVWUDVGMmI4eWVMZVVzcmwr?=
 =?utf-8?B?QXBoTHdQVG83U1hva05ybngvNFZkdm5JUERVVERqdHYxaDk3WkQrVE9mN3Np?=
 =?utf-8?B?TEwyeHZnS0NSemxWYlhCa0JidGRxcjNZdlRjbXM4M1g3N3VDOE9paVZkRjlk?=
 =?utf-8?B?ZERGcXYrb0lNaWlhb001UXZoTUtIbGJnTWVINXpMdFpFZUttaG9ldzNjUHps?=
 =?utf-8?B?dS9JQ2JJMkVraFcrYTJNRDFpYzdpZWF6U2JoOG55UzE3NjNJZ0V6YW5rakJ4?=
 =?utf-8?B?MnlxSzdBQzdpSGxkL2FoczVVMkZBWDh2YUV2WHIzZlBhZmZlVVcwK0xaQ3JD?=
 =?utf-8?B?azBnMEVHRlNxbGFZMGpmZzVyNVBteEx2T093ODJTd1BieGhLdU1RdjBNN3Fi?=
 =?utf-8?B?bTJqcGlpNmpGcytxVkhqQTBDeHUvWHA4NUVpZkJOM3YxZjdJYXhPd1BxZ0xW?=
 =?utf-8?B?R0xOWUNoZENPbURSR2sxZEZ2UTZ0eGVSNGtya09iTmhOeDdpZUt4cUIzZ2Er?=
 =?utf-8?B?ZWxSK1M1RlE1aG95ekZBd3AwNDczQ0I0cVZOTnNqOFVPalMrbHY2NzIvUnQ1?=
 =?utf-8?B?NmFWaEg5RlFTVkN0eE53QUtKUDUxZWxJUzl3Z0xJTDRSRS9OTmRySGRacDFX?=
 =?utf-8?B?T0JobUxRQUNEdVhtSXEwRFFBZUhYVDhJODR3d0wyNk9QcXh1M0VtWDY4V2k0?=
 =?utf-8?B?TFg0emdkOFY1WFdFV2lpdkc1Z3ByaXFTV29GTXN5V3ZpREFmbTZ4KzE2TFZ6?=
 =?utf-8?B?U2c5Z0NrcmIvSmEwNWtRb2FoLzVLUkttMUVHeWFqbWxLT2ZNdTBid0wxckU1?=
 =?utf-8?B?azMzSytQUkphUHVJQmJqNUNmTnJSeTBnczJrUkV5WjFJVWFBL0tSTzZZQTFO?=
 =?utf-8?B?dEtGTVRNV3J4TlpCZFVFb0lCNTYyYnBTRDB2cEliZUVYbi9KUGdqbUh2alZK?=
 =?utf-8?B?S21reG1LanlRZ3JoTTQ0OEVtT09JY0dvNjNCT2ZWREN4TTdHNkw2YkNYd054?=
 =?utf-8?B?WmpMdW1zUE0zakE4RGFxWmhWaGZhNUZmSExJbUlxcFVzL00vZUpoTzErdmVW?=
 =?utf-8?B?bGh6QjJtQnhJVW5DYXYzK0thTnFkaFZTSlZoZU5SRTh0eDgyeGM5cjNUTTdR?=
 =?utf-8?B?SHBsMEFHUzcreU9Ma0JYc1hDZ0loTnpUVmNUT2ovVVg5eFNNTWRCRFI3cXdR?=
 =?utf-8?B?NTRDSTlaUzM3T1JnRWF2NTBKeFphSytpM2QveTV6czRBTmUvemdGZlRvYUk0?=
 =?utf-8?B?VXN5NkRGZ1ZRSzhsVUE0WjNrOUpHREowOHk2MnRTTWRYU24ySlJuT2JaVVZN?=
 =?utf-8?B?Yk5JZTFFSDZCOG9HSXlqc1Qxdk84YTVTM2xpRC9SNXRZRVFCRWE2dGhoY3E4?=
 =?utf-8?B?bjhXa29ZYTUwb3ZSYUwwVk41dEMyeDJmTVRjdlhacm93SklGOVVFckpMRXJU?=
 =?utf-8?B?ejJ4UHk0dGdUNFpPZjdhL0wvWHZIZHVOdVlZVysxNU4zWlVLNE5XWUZOSXYw?=
 =?utf-8?B?VjRFMnBQdm5GUGttOHlGMk5NcmkrMWwyb2ZiMkdKODhlMzVMOHU4RW9MWDFk?=
 =?utf-8?B?QUxyNkJHaHhyUzVxQUw5TllKbkhobEhJTnJjYWNQWnRWc1pZK29IOHFCdEN6?=
 =?utf-8?B?SlF5dXlKb01zQjBOblRQMzlOeWw1QjVBSnZCeDJjdkhDQ0p5Y0JabFQyZ0tI?=
 =?utf-8?B?Q0trZ2lsNkUvNittZGl2R1RMc3ltL1gyVWZDQVkxcU0rR2dkbU15S21lQ3k0?=
 =?utf-8?B?WGl0ZnhIeHMybjNFaXlLWXJxZ0VVOXhqRVdUMkxBZzhqKzdEMUwrK0N6Tm0w?=
 =?utf-8?B?YjZoOFd2dG00OGRMVS9XRTdMVFpvYktKK082dkFmYmVhbmFEM2hSYnlpSHRK?=
 =?utf-8?B?UGQ0MFNHa09QdGNNcUZwOTlkcGhRcDFmclZtY25EU2xMNFF2b2hkbEE2ZnRF?=
 =?utf-8?B?OTY1MDNWcmd5S1AxRGZJcUxTU2pyc2lJbVN6cnF2YTBOQkFjUXVuMFJwODRI?=
 =?utf-8?B?dXhrUmhiSUdyUTdHOGR6WmtnUUVPYnJCZnlmbUJjNEVJVjYrZUdFUFpUQlYr?=
 =?utf-8?B?OWxXdXdMV3MwRG5XZXV5cTZ3eGgzRjQzNVFLQ0VXR0xXaFlpUDdJREJ0MFJ6?=
 =?utf-8?B?SnVYUUNpT0hiR290VlFWYmFFMWN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6984de87-87d9-4b74-8bc4-08db0a2cd495
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 23:33:06.3997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0h9qcs4Gy+8O19KVvOzPUBgHuHntGecgrcckQ/LtiMrL3x7fa51eK8CtEAa8lQngBC/fjn6+WyrsNrKuDzx6RJeYZO7YNZkVkAZkEQQVkGRw4mZQsnQ/Fynb4vRhHqxm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxleGFuZGVyLA0KDQo+IEZyb206IEFsZXhhbmRlciBIIER1eWNrLCBTZW50OiBUaHVyc2Rh
eSwgRmVicnVhcnkgOSwgMjAyMyAxOjA3IEFNDQo+IA0KPiBPbiBXZWQsIDIwMjMtMDItMDggYXQg
MTY6MzQgKzA5MDAsIFlvc2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPiA+IFRoZSBncHRwIGZsYWcg
aXMgY29tcGxldGVseSByZWxhdGVkIHRvIHRoZSAhZGlyX3R4IGluIHN0cnVjdA0KPiA+IHJzd2l0
Y2hfZ3djYV9xdWV1ZS4gSW4gdGhlIGZ1dHVyZSwgYSBuZXcgcXVldWUgaGFuZGxpbmcgZm9yDQo+
ID4gdGltZXN0YW1wIHdpbGwgYmUgaW1wbGVtZW50ZWQgYW5kIHRoaXMgZ3B0cCBmbGFnIGlzIGNv
bmZ1c2FibGUuDQo+ID4gU28sIHJlbW92ZSB0aGUgZ3B0cCBmbGFnLg0KPiA+DQo+ID4gU2lnbmVk
LW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMu
Y29tPg0KPiANCj4gQmFzZWQgb24gdGhlc2UgY2hhbmdlcyBJIGFtIGFzc3VtaW5nIHRoYXQgZ3B0
cCA9PSAhZGlyX3R4PyBBbSBJDQo+IHVuZGVyc3RhbmRpbmcgaXQgY29ycmVjdGx5PyBJdCB3b3Vs
ZCBiZSB1c2VmdWwgaWYgeW91IGNhbGxlZCB0aGF0IG91dA0KPiBpbiB0aGUgcGF0Y2ggZGVzY3Jp
cHRpb24uDQoNCllvdSdyZSBjb3JyZWN0Lg0KSSdsbCBtb2RpZnkgdGhlIGRlc2NyaXB0aW9uIHRv
IGNsZWFyIHdoeSBncHRwID09ICFkaXJfdHggbGlrZSBiZWxvdyBvbiB2MiBwYXRjaC4NCi0tLQ0K
SW4gdGhlIHByZXZpb3VzIGNvZGUsIHRoZSBncHRwIGZsYWcgd2FzIGNvbXBsZXRlbHkgcmVsYXRl
ZCB0byB0aGUgIWRpcl90eA0KaW4gc3RydWN0IHJzd2l0Y2hfZ3djYV9xdWV1ZSBiZWNhdXNlIHJz
d2l0Y2hfZ3djYV9xdWV1ZV9hbGxvYygpIHdhcyBjYWxsZWQNCmJlbG93Og0KDQo8IEluIHJzd2l0
Y2hfdHhkbWFjX2FsbG9jKCkgPg0KZXJyID0gcnN3aXRjaF9nd2NhX3F1ZXVlX2FsbG9jKG5kZXYs
IHByaXYsIHJkZXYtPnR4X3F1ZXVlLCB0cnVlLCBmYWxzZSwNCgkJCSAgICAgIFRYX1JJTkdfU0la
RSk7DQpTbywgZGlyX3R4ID0gdHJ1ZSwgZ3B0cCA9IGZhbHNlDQoNCjwgSW4gcnN3aXRjaF9yeGRt
YWNfYWxsb2MoKSA+DQplcnIgPSByc3dpdGNoX2d3Y2FfcXVldWVfYWxsb2MobmRldiwgcHJpdiwg
cmRldi0+cnhfcXVldWUsIGZhbHNlLCB0cnVlLA0KCQkJICAgICAgUlhfUklOR19TSVpFKTsNClNv
LCBkaXJfdHggPSBmYWxzZSwgZ3B0cCA9IHRydWUNCg0KSW4gdGhlIGZ1dHVyZSwgYSBuZXcgcXVl
dWUgaGFuZGxpbmcgZm9yIHRpbWVzdGFtcCB3aWxsIGJlIGltcGxlbWVudGVkDQphbmQgdGhpcyBn
cHRwIGZsYWcgaXMgY29uZnVzYWJsZS4gU28sIHJlbW92ZSB0aGUgZ3B0cCBmbGFnLg0KLS0tDQoN
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMgfCAy
NiArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3Jzd2l0Y2guaCB8ICAxIC0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRp
b25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcnN3aXRjaC5jDQo+ID4gaW5kZXggYjI1NmRhZGFkYTFkLi5lNDA4ZDEwMTg0ZTggMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guYw0KPiA+IEBAIC0yODAs
MTEgKzI4MCwxNCBAQCBzdGF0aWMgdm9pZCByc3dpdGNoX2d3Y2FfcXVldWVfZnJlZShzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldiwNCj4gPiAgew0KPiA+ICAJaW50IGk7DQo+ID4NCj4gPiAtCWlmIChn
cS0+Z3B0cCkgew0KPiA+ICsJaWYgKCFncS0+ZGlyX3R4KSB7DQo+ID4gIAkJZG1hX2ZyZWVfY29o
ZXJlbnQobmRldi0+ZGV2LnBhcmVudCwNCj4gPiAgCQkJCSAgc2l6ZW9mKHN0cnVjdCByc3dpdGNo
X2V4dF90c19kZXNjKSAqDQo+ID4gIAkJCQkgIChncS0+cmluZ19zaXplICsgMSksIGdxLT5yeF9y
aW5nLCBncS0+cmluZ19kbWEpOw0KPiA+ICAJCWdxLT5yeF9yaW5nID0gTlVMTDsNCj4gPiArDQo+
ID4gKwkJZm9yIChpID0gMDsgaSA8IGdxLT5yaW5nX3NpemU7IGkrKykNCj4gPiArCQkJZGV2X2tm
cmVlX3NrYihncS0+c2tic1tpXSk7DQo+ID4gIAl9IGVsc2Ugew0KPiA+ICAJCWRtYV9mcmVlX2Nv
aGVyZW50KG5kZXYtPmRldi5wYXJlbnQsDQo+ID4gIAkJCQkgIHNpemVvZihzdHJ1Y3QgcnN3aXRj
aF9leHRfZGVzYykgKg0KPiA+IEBAIC0yOTIsMTEgKzI5NSw2IEBAIHN0YXRpYyB2b2lkIHJzd2l0
Y2hfZ3djYV9xdWV1ZV9mcmVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiA+ICAJCWdxLT50
eF9yaW5nID0gTlVMTDsNCj4gPiAgCX0NCj4gPg0KPiA+IC0JaWYgKCFncS0+ZGlyX3R4KSB7DQo+
ID4gLQkJZm9yIChpID0gMDsgaSA8IGdxLT5yaW5nX3NpemU7IGkrKykNCj4gPiAtCQkJZGV2X2tm
cmVlX3NrYihncS0+c2tic1tpXSk7DQo+ID4gLQl9DQo+ID4gLQ0KPiA+ICAJa2ZyZWUoZ3EtPnNr
YnMpOw0KPiA+ICAJZ3EtPnNrYnMgPSBOVUxMOw0KPiA+ICB9DQo+IA0KPiBPbmUgcGllY2UgSSBk
b24ndCB1bmRlcnN0YW5kIGlzIHdoeSBmcmVlaW5nIG9mIHRoZSBza2JzIHN0b3JlZCBpbiB0aGUN
Cj4gYXJyYXkgaGVyZSB3YXMgcmVtb3ZlZC4gSXMgdGhpcyBjbGVhbmVkIHVwIHNvbWV3aGVyZSBl
bHNlIGJlZm9yZSB3ZQ0KPiBjYWxsIHRoaXMgZnVuY3Rpb24/DQoNCiJncS0+c2ticyA9IE5VTEw7
IiBzZWVtcyB1bm5lY2Vzc2FyeSBiZWNhdXNlIHRoaXMgZHJpdmVyIGRvZXNuJ3QgY2hlY2sNCndo
ZXRoZXIgZ3EtPnNrYnMgaXMgTlVMTCBvciBub3QuIEFsc28sIGdxLT5bcnRdeF9yaW5nIHNlZW0g
dG8gYmUgdGhlIHNhbWUuDQpTbywgSSdsbCBtYWtlIHN1Y2ggYSBwYXRjaCB3aGljaCBpcyByZW1v
dmluZyB1bm5lY2Vzc2FyeSBjb2RlIGFmdGVyDQp0aGlzIHBhdGNoIHNlcmllcyB3YXMgYWNjZXB0
ZWQuDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQo=
