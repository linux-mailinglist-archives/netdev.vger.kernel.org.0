Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123945FE2B0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 21:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiJMT2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 15:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMT2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 15:28:51 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EDB16D89B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 12:28:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ljfi31VQpOFLGjfBZivfZ/h1KmArHZCONOl77LVMG/OZ+nxobyMLLFSwGrjefA1G0/vtKmRWffBTT6MGY/3dlB1Cn5FB2lofN7Nuz8h1RiUXXfjaNFDcJH0uEZpMAcKTegjo+0tcAVOW2IrW3y5U57GXdePsM8Ud5duL/FYpbhxEf5+YDB7qYlYo5p0ObTHBcL3SVDTQrGxqUdbbcDxshz7t+4TmEkcHFPp2LbTnfaaquILCAqnzhOIYLVrxkMtxbVTvBtmxX3nS/5D4E9pA/GX7JlVQ+f/TK1uZWrClOx/upBNaKXpfvQRa1Ktf6xE/pjBJvyLfbcgbuNdNcuuayg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBjuBoXp0HSk2jBkZgyCAUkpmHjAmDb8fO9vGhK4UiU=;
 b=B5YdAhxo+3aXQ7Oecg7DsJe51QOxeURiMxh/9Yq3uCTcXh+ySjNN1Z8LLpolMHgqcG7dElk8cz4/2wa/k42+w2Kyk9a2mmVNCBfJVYalbrajjs9GO0JZrwcT49w2JLHIQKov8BsisO7/esJlFF4uxt1eTXiIcz1u7p/ymXgH6LtfcS2qoOTFhqw9Yw97gA1YmDycFKnxazlpRN/5nUuBwoWblG5468FliRABiANdiEwDW0N/TS0/bdUcXKKu7BuLLMGZw8ssMYXorfD0gq6iaGO/Dpks90F0B+vyGrWELaoVtWMFGzHI3MYfRju+cBnhgUdjddaAKXwaRRpA6D3Fcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBjuBoXp0HSk2jBkZgyCAUkpmHjAmDb8fO9vGhK4UiU=;
 b=X3Td2A2lStJleKj5f4oE2Y0PwBmsUKCS1oCpBeqM7APSVb8EI1T8hwc4wj8kRXzOL+qHKLAM2P2u5OaMyc9Kp1zjFAUgEewB5gCHTJGm0sDVHZcqwQ8D7UPU7/o6Y3zb9QN/O/kO6fYFHvLUi1SO992RT+RZpHb2YfFpIS8Gyjs=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB7565.eurprd04.prod.outlook.com (2603:10a6:102:e7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 19:28:45 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 19:28:45 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: RE: [EXT] Re: [PATCH v5 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Topic: [EXT] Re: [PATCH v5 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Index: AQHY3wk+RdYbjETnMUqpkhkADdfnU64MqomAgAAKk7A=
Date:   Thu, 13 Oct 2022 19:28:45 +0000
Message-ID: <PAXPR04MB9185C63C94CE032DCEE60AE689259@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
 <20221013133904.978802-2-shenwei.wang@nxp.com>
 <2c861748-b881-f464-abd1-1a1588e2a330@gmail.com>
In-Reply-To: <2c861748-b881-f464-abd1-1a1588e2a330@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB7565:EE_
x-ms-office365-filtering-correlation-id: 639f9f92-5cae-4064-38f2-08daad51252c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93jsEM9yzHSqH49xEul3PFIy9dCtMU1Wb+KkLy7K3NDnZoyWWSz2IMEbpkc9p5DrrkLq+dkakadvqbqtAOtCsiiJ/jvmGIqh9u7WhBJ+4lG9MrbP3BJ+9vgOyRn9A5NyeTruukQ0UNyuxIRc17aYU/E/9WZifG/4hmkW/Eymx9AHityHqhN+KgpyzEHoXsJrJ1I+GERL20njxlJSKCYlxt7reJ4alvCwmwqgrc7EadreUeQ1xDfqaoZ8gBeU7PBD9cKFpCUo47pnMh5WvaORf35G3rEeuKSbIEGUnDr0k0KslKq5J9tHY9D7eCtsAk9AZ23LUGLmJzDAVPP7dbp1+ed5gg+/TGmp+68BJvhM1Ud6Ae2UYDhfFMH2aVNjMH2MZdhMFntN5I8YKdkI4Hzy+X1IK+DKL3iCdXTxY3jRZCYLhhQBUe5n4/CyivR8V6QodhgWbmPmg1AATapuofQ8y206N3yWlGzsijRBpI3sbxcSvPZY5nMvKlB0k0rOXh7OL1swYh1F4AzPBsu5C5lxNjC6JitibnsXCWSP/t33J+0//szv7qvSHGWfJ2yqDhbKbZs1lPPoiZvON3HwFcPaKMk2i8U22s3nsddzMv0TsXEYKDB3BonmAH2ogwitpWopolA4FAfU3WkQKy1E7sLnq9E1ZcTxoGM6sgCPeIwNYXlPE7ZFEr9HiDdrsQ1phSzVwKV9YuBCEY2FiUoX6J7PSJ5o2DvJ4bAXZRQbRKul0z8S/C8jY4wB1I+zCQlvyX2E8EQVktpNEgoOE+RGktvv6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(44832011)(122000001)(9686003)(110136005)(54906003)(8936002)(316002)(52536014)(83380400001)(76116006)(66946007)(66556008)(33656002)(4326008)(8676002)(66446008)(66476007)(64756008)(55016003)(7696005)(6506007)(41300700001)(2906002)(55236004)(53546011)(86362001)(38070700005)(26005)(186003)(7416002)(71200400001)(5660300002)(38100700002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjVMQUhFcGk2S2Zvb1pYR0JOc2JBSzZpcDNkTFByUjlKV1BJZnRIKzdmL09q?=
 =?utf-8?B?RzhVNGpzQkVlb2I5UmQzdE9iUWhqYlVhRWlBTWthbmVJbTBENll2azg5Tk04?=
 =?utf-8?B?ZHorWkdMVEpqZmxVMG1RVUZUYnZ2Q211LzM1SllKSzhqWjMvdWtXU1I1OFc0?=
 =?utf-8?B?TVFwdkY0QmgwTW1jSWw2dlpQM3ZnOU1kRDA5bzJKdzdvQ3N4MFpkT1ZMcnlI?=
 =?utf-8?B?Um1ZSWZGVlloV1RJNExMcHZLMlVGdDNSRkI0WDhXenNvbVBSa0tLOUZwZURx?=
 =?utf-8?B?c3puTmxKOENxUTFKMDlKSTJycXFOTmFBMVJGT1pVSzI5NU01QWxtL0p5cEh4?=
 =?utf-8?B?QTRNbmV5UVlxaFVLNWxQYyt6V2dmMmRJaWd3ZndMd1lmSVNvWkllUEQ3Q1lD?=
 =?utf-8?B?L21hbXVNTmRKYnRFRmNkSG5ETXBMMlFjRnZSeGQ1NWdiQ0FhUjlhelhLL25O?=
 =?utf-8?B?dlNYSzN0Z0tnY2tKNUhaSUltT1p6cGJUVWNXZFpwV1o5Mk1tcHoySjNxTVRF?=
 =?utf-8?B?MXlVSjQ4NlZHL2ZFd1dTNFRQTWtBb1lKRzB4NzdBbkFuQkEwaCtBOGswdTBG?=
 =?utf-8?B?N3U1ZzVqTWMrZ21sNlhFM3FhTUhhcndYaFlDd2JsZXltRTVlcnQ3RHdUcnpi?=
 =?utf-8?B?NmtLaG0zeGp2OGFmMTZDN3NXVU00aEdiNVZwbDhKSHVKb2RhYkV4SlZhVFp3?=
 =?utf-8?B?MlliUUU2aEJPaUdtYlBSM1duSVJ2dXRlQys3eXJ0djg3NVNlRGxjd1hqdnlX?=
 =?utf-8?B?Tm9EQXdWeGdZSlMxT0RnMW5MMWVOZGZ5RDhZQ2ltZ09wRWQ0UFBqa1hFcWg4?=
 =?utf-8?B?bEl1TFc5akJhVTF3WWlLdnVPbndqd0lWYU9KanRrRG4yR0xaUkw3V2o1bFZP?=
 =?utf-8?B?bG1qcDZBMzlleUhHbmNsN3ZEOE8wcGlJdGdBWnh5SmQ5S01kaHBYM1hGQm1O?=
 =?utf-8?B?YkpJa3d0OEdZcWRWWHlWNFlXbjlKeXIxSEZvVHVybVRkem5GYTZvNzlRVTVa?=
 =?utf-8?B?cTFRSEFlNW1ScUllU2ZoM2VVZnlwNlRlWmhUcUN2Yy9tMU1Tck5xSWRwc3hK?=
 =?utf-8?B?TFlrMDdLSzQvSG9ocUV1eUhiTGZaL2ZKTkI1WXh3MERsU3RUTEo0UCtZYmU5?=
 =?utf-8?B?MnZMUTYrMlVzOVZFbm1SRzN1WVdyU2FlVEdCa3F6MFJBQlI0Nm1ma3BCKy9m?=
 =?utf-8?B?bXBDclFiMkcrcWNMcEpLZ0NtR2RsTVFPSWZFbS94Ymg0cDR2dTJLK09nQm1X?=
 =?utf-8?B?cFBZQkpYUWlZUUJYWUUxNmdFQU9tNDdiM3lrUG1TUUdBSlRSN1h6aUpTUGQ1?=
 =?utf-8?B?US9rVmllb2FxU21EaVh2SUgreFdHc3JqTHJLNTlVbmNDRytSVXZRUE05K3Jt?=
 =?utf-8?B?RSt1L2lOcHUyQ3hzU0RyS2FabEdxZFRhd21pdERreEd3WGxIZmlWOVhCYjNO?=
 =?utf-8?B?aHNhSDRHSnp0WHRLSmliNy9xUHJjSjVTM1BFZHRhdFJ4czdiVnljSVJndm5u?=
 =?utf-8?B?MXhoVVQ3ejhWR1E1NWNSM2tPdXBwbUhRemdseWROWkN6dlVnanZyZkxNVmxu?=
 =?utf-8?B?Z3lHek83MVFkb2N5bTNuK1hWT1U3MW8vVmpxS2x5Sll1c1IwTFJtTndJTjRw?=
 =?utf-8?B?dVZkVkM0RU5JeTA2OVhPTnlxak9iQXVFZzBsY2I1K1lkM21SN3BFODVNWURh?=
 =?utf-8?B?Yk5WKy9xL1RIUlA4T2xHQUFzTm85K28xcHF0VVhlTEhNRjd3QWZMdHRObFl3?=
 =?utf-8?B?emRJWkwvYWVuNVB5TWx1YXE4c3hua0tvbXViZkxOeEJFaVVFNXkva2d2M2FR?=
 =?utf-8?B?QkY4WnA4VkFVSGIvak5vOE1jVkFCaWNUaW9seUZtKy9CWENoK09kS2EvU3Ir?=
 =?utf-8?B?d2Erb0w5aGQwREF1d2RtSUV1Wkpyb3RHWnlUSkN1Q0I5RWE1ckc1UDdEdlhj?=
 =?utf-8?B?YWE3dHZYQTZEZEtLR0JSV1I0RUNacmpWVElTamgzWldCYTJ2VmY2NStqeUl2?=
 =?utf-8?B?THNnVHlNTU02WDhKeWlESk9YWHdNaG1OTWJlREpTaWJwZXJrUFExVURabVlZ?=
 =?utf-8?B?V29BUzRMMFYweDduY0xHVnQzaGhzdDVaNFJWYVR2VVRhaFpXQW1PdGF3YXdy?=
 =?utf-8?Q?kH9wr3PVhgtFpX4gjrR0r07i6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639f9f92-5cae-4064-38f2-08daad51252c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 19:28:45.3801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35oN2BYcPWJ7Ed4tbG2sk+ZQeHRYE3nMtckkaD9W/Ih/ImSVn5/AVoude53FCHPNa1wkGAJbA6b4KGIt1GbS6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDEzLCAy
MDIyIDE6NDggUE0NCj4gT24gMTAvMTMvMjIgMDY6MzksIFNoZW53ZWkgV2FuZyB3cm90ZToNCj4g
PiBUaGUgcmVjZW50IGNvbW1pdA0KPiA+DQo+ID4gJ2NvbW1pdCA0N2FjN2IyZjZhMWYgKCJuZXQ6
IHBoeTogV2FybiBhYm91dCBpbmNvcnJlY3QNCj4gPiBtZGlvX2J1c19waHlfcmVzdW1lKCkgc3Rh
dGUiKScNCj4gPg0KPiA+IHJlcXVpcmVzIHRoZSBNQUMgZHJpdmVyIGV4cGxpY2l0bHkgdGVsbCB0
aGUgcGh5IGRyaXZlciB3aG8gaXMgbWFuYWdpbmcNCj4gPiB0aGUgUE0sIG90aGVyd2lzZSB5b3Ug
d2lsbCBzZWUgd2FybmluZyBkdXJpbmcgcmVzdW1lIHN0YWdlLg0KPiA+DQo+ID4gQWRkIGEgYm9v
bGVhbiBwcm9wZXJ0eSBpbiB0aGUgcGh5bGlua19jb25maWcgc3RydWN0dXJlIHNvIHRoYXQgdGhl
IE1BQw0KPiA+IGRyaXZlciBjYW4gdXNlIGl0IHRvIHRlbGwgdGhlIFBIWSBkcml2ZXIgaWYgaXQg
d2FudHMgdG8gbWFuYWdlIHRoZSBQTS4NCj4gPg0KPiA+ICdGaXhlczogNDdhYzdiMmY2YTFmICgi
bmV0OiBwaHk6IFdhcm4gYWJvdXQgaW5jb3JyZWN0DQo+ID4gbWRpb19idXNfcGh5X3Jlc3VtZSgp
IHN0YXRlIiknDQo+IA0KPiBUaGlzIGlzIG5vdCB0aGUgd2F5IHRvIHByb3ZpZGUgYSBGaXhzZSB0
YWcsIGl0IHNob3VsZCBzaW1wbHkgYmU6DQo+IA0KPiBGaXhlczogNDdhYzdiMmY2YTFmICgibmV0
OiBwaHk6IFdhcm4gYWJvdXQgaW5jb3JyZWN0DQo+IG1kaW9fYnVzX3BoeV9yZXN1bWUoKSBzdGF0
ZSINCj4gDQoNClRoYXQgd2FzIG15IG9yaWdpbmFsIGZvcm1hdC4gQnV0IGl0IG1ldCB0aGUgZm9s
bG93aW5nIHdhcm5pbmcgd2hlbiByYW4gY2hlY2twYXRjaC5wbCBzY3JpcHQ6DQoNCi4vc2NyaXB0
cy9jaGVja3BhdGNoLnBsIDAwMDEtbmV0LXBoeWxpbmstYWRkLW1hY19tYW5hZ2VkX3BtLWluLXBo
eWxpbmtfY29uZmlnLXN0ci5wYXRjaCANCldBUk5JTkc6IFBsZWFzZSB1c2UgY29ycmVjdCBGaXhl
czogc3R5bGUgJ0ZpeGVzOiA8MTIgY2hhcnMgb2Ygc2hhMT4gKCI8dGl0bGUgbGluZT4iKScgLSBp
ZTogJ0ZpeGVzOiBlNmEzOWZmY2ZlMjIgKCJuZXQ6IHN0bW1hYzogRW5hYmxlIG1hY19tYW5hZ2Vk
X3BtIHBoeWxpbmsgY29uZmlnIiknDQojMjA6IA0KRml4ZXM6IDQ3YWM3YjJmNmExZiAoIm5ldDog
cGh5OiBXYXJuIGFib3V0IGluY29ycmVjdA0KDQpUaGF0J3Mgd2h5IEkgY2hhbmdlZCB0byB0aGUg
Y3VycmVudCB0YWcgZm9ybWF0Lg0KDQpSZWdhcmRzLA0KU2hlbndlaQ0KDQo+IFdpdGggdGhhdCBm
aXhlZDoNCj4gDQo+IEFja2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWls
LmNvbT4NCj4gDQo+IGFzIGEgY291cnRlc3ksIHlvdSBjb3VsZCBDQyB0aGUgYXV0aG9yIG9mIHRo
ZSBwYXRjaCB5b3UgYXJlIGZpeGluZyBCVFcNCj4gLS0NCj4gRmxvcmlhbg0K
