Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421DE4C9BA6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbiCBC70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbiCBC7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:59:20 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2126.outbound.protection.outlook.com [40.107.215.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7A82B183;
        Tue,  1 Mar 2022 18:58:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC5q4Nv1jIH5nG3eCfXgZ7R+kywPjlcXX8avk6rVsnqoB3UvN7DiwhJvJKaqq1UwT0C2t49nZizbrFjZzG6gSIVw2QVhId1pDPB60Bkg1cPYRlfOEscXlUf9eLpNYTzGCXT6U3z56csJhMPsYSCDz0wft9bhSCvx5Fgj6HLHJh1ISyRdmdsCdE9gQHJvvGKu7xf2uMpaPfRyLMFo01XphMfRZaSHS37JmnIPik1aLIQWib5hwAYUulJx6DA5cj3MC2Y6G5zY6NJD1jGFLoJK/zljsW45cc0tAZp7Tq3J4uf9LSOS66AbVj2dW84V1rOrOZvVHh/zPntiovCwsEYn2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LaTGZLdREUj1aI8QyhfU51SnKc2VKKAKV5q6sBvMCM=;
 b=i1uDvYCz/T9609KznY36W4sCPBQk1IwSu2syHwHSZgxobhAMCxtlTKXBR8A+j1r18Yx50NCBrFEVRfJn7bNBhGE6pHnhmwZmYIZhFZo3WnhHi9ImqFEQtzTgjrhQMvw0V6luL228vBdQQqmyGjYQtECTpUFhOCFbVcK8X2LQ5YLr21obvXn3G3oNJMBeERhURic/lhuc0ftOIkkwlEKy90MUtnB1mM6Yktz9VUpBMl7QAohM0hgfasmEbLrqfruDXR3XHlLZZKk/aR5de4I3wJ/JtD7xhKWY+RIMdpVWLgSoAgsxRHD3ormN+8W3yQztqwkYPjkmG9GyffT8Yl6H4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LaTGZLdREUj1aI8QyhfU51SnKc2VKKAKV5q6sBvMCM=;
 b=Gg6Shne+wSqaWmrkvmYkBEbmSlDXIOD3dD7ImAdDEx4L1xI2GhYrW+7X0dHUDHBFZ+2oP2j8Jxwr6tCD4ZiLitIKv+YbR2pJpUcVGYBF63l03Qj5tdZ/fPx5mTEqIEz92hVBPcuupLpga+wh+t/YSmoV6+aTcdvpY1rOw6Ay+Zg=
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by TY0PR06MB4895.apcprd06.prod.outlook.com (2603:1096:400:14b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 02:58:33 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 02:58:33 +0000
From:   =?utf-8?B?546L5pOO?= <wangqing@vivo.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 RESEND] net: hamradio: use time_is_after_jiffies()
 instead of open coding it
Thread-Topic: [PATCH V2 RESEND] net: hamradio: use time_is_after_jiffies()
 instead of open coding it
Thread-Index: AQHYLd1hxdL6wbDbjUySpwvlvkBbZ6yrZhwAgAAAWbI=
Date:   Wed, 2 Mar 2022 02:58:33 +0000
Message-ID: <SL2PR06MB3082994522886A6E17C9D455BD039@SL2PR06MB3082.apcprd06.prod.outlook.com>
References: <1646188174-81401-1-git-send-email-wangqing@vivo.com>
 <20220301185506.64c3aa0a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301185506.64c3aa0a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: d4429c02-332e-a0bb-95f4-4a8980d7343e
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec24e70d-2e91-4c79-4c43-08d9fbf889e2
x-ms-traffictypediagnostic: TY0PR06MB4895:EE_
x-microsoft-antispam-prvs: <TY0PR06MB4895A3C04746C53F2F6290D8BD039@TY0PR06MB4895.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CilGY47FruFXRKsbZc1TK0GsWodjOq5al00MtfRLOhMc6Rw6MfWv9L+rtqPYUQBY+ByJPV8Sq9U1I2mIX4yR2qSWkuPmU0UqgF0KHybuQJ4yJlaRH6iJnlY1xAWcqVu3v8RTIuIR07jP74sVDiqdtGgKLtq1+0NuXfBPE0bKhE/2ETTu0hVemgdYLKNmHKI+C9mDDC7X8I3BD9h8DcCs/ZIJDJvun09IAfFbnrLlNto8rLa6m+b4EDMURW51ApawFAqITq43Ja1wFGP006Ba2rzmgCwca0QywgryvvXpMcxi8CNt2Z3h1ed7OGAF4MnHSYjCU7beLK8I3ro0RorkfAZKbfAY33iXif80eBAPtH4MTS2tID9vkiQm4p0Xz1fgseTMVeK3gBarbvFgXjdEiwHsK+R6lTW5HESV1pUbOBu7rejhPH2ODKi/OXoK5W2TQVEyUaC5J875TZzRZ128f8cE2qIzBnQjnJZzxVoJBwBrsYqffjpdkb2I9Ulc7i+RW205XEeGl+VL5gsE2LB31MUskihsubAIbcQGStEEO+fIkPvQ1p8hCgks+3cXzRv/rF+tUgmfCUWKOuvRTIyGu9odeVtxOL5SrEuZ+Qmc2dH4BH+Ag4Wl+rgVCncJH+KvZf31IlZwGi5pqkTWKdsmXoSvyEutYEhVDJFIcRIFotUuk60ZJ0dGGQDogw6gsI2FnbEJSXSTGysxgdqlzzyLtazMHUeiw/WFdMBnv+JWJEoC73rDI+ZoS5eqQIqamAKTZO3GuPZ79FhqsH4CyNpBG1Nk41aBfcluJH8o2yQhqhU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(52536014)(85182001)(6916009)(6506007)(86362001)(186003)(54906003)(26005)(66556008)(8676002)(66446008)(66476007)(316002)(8936002)(7696005)(5660300002)(76116006)(66946007)(4326008)(91956017)(33656002)(38100700002)(2906002)(122000001)(9686003)(64756008)(55016003)(508600001)(38070700005)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlcxaHVIbFQxS2tnMjhDRGFoSjMrdUVVZmZHU2JBOE4rKzZ6clJrTmVxSzJ0?=
 =?utf-8?B?VDFJQXo3RldnVEJFM3FDcHp5eTlDRWwwN0FwZTk0UnVGa3ZNcE1pWjhmY0Nn?=
 =?utf-8?B?UzQwNWd2LzlERDM1ZzdFMWZBYnlncHBKYmEvb2tEbjlEdXpva2pVVE5xSTcw?=
 =?utf-8?B?TlZ2eGJNWUVOVno3NjhEcUp0RkVnSFAxOFFsNGVSYnVqQXBmclZMWnA3M2lv?=
 =?utf-8?B?eU8rK3dDWGMzRnF6dTBlRnRNNlBnTS9XYUs2S2lFTVZhNW5xZUxtVG8wemxa?=
 =?utf-8?B?Uk81UVhDMTZrYUd6TE9lUWNUNm9DazhaRU1RUkE1elhZUUorbjVBVmlXQ2NL?=
 =?utf-8?B?TzRYQXJYUWZ2RGptelc2bEVjSWx0c2ZaNkE2cDZIR1VCNGVaaUNYNmtzL1k4?=
 =?utf-8?B?RXNwTWs4OFFMdHU0ZEpScU9RRnJScGtwU2htQTRkcmZHdHlTcFpZdmtRNE4w?=
 =?utf-8?B?Sm5TcmdDbE1qNEluVk5wdHdKK1pEcDl2SEtiSWwrQWxvVXp5aHUySW9oTXg1?=
 =?utf-8?B?K0RUSWU2Y2ZIZktVMURhYkdYeVN5NXdCVitQUkVXWUFENFBOaHF0Yjd0RlY5?=
 =?utf-8?B?bmZ6RkVlVXRmc2kxM1lQZEp0aHpmYU5jbTh3QXlsdlU1VEV1WTJvNVFBdGl5?=
 =?utf-8?B?NkVKSFNLdUZQRS9TWEQ0SmkzQVJwUnlpZU1ncU9Wb3N2U3daTk9VbHJOdDRQ?=
 =?utf-8?B?Q2lUS0dveDdXTG02Y2VpMERxSkF3bFY1WmJVc2dEWXR1SXlRaGNycVFFZ1pD?=
 =?utf-8?B?TUVXblJHZHViUGdsd1ZrQ2FySEFra2hQcmhpYS80UDZJNFBhRWIwekNIQVoz?=
 =?utf-8?B?OExzNWRCNUlLR3ZhZTNkVllnNkoxMHdvd2syNGxlWHFJMXg4Rk5WbmZmQjJN?=
 =?utf-8?B?cEhrVE1YSDVDdStpVmloYTlqKzBxN0VUSUNpTmFKQ1Z2TnF4cHB5UjN2dmQx?=
 =?utf-8?B?QVZneHBrKzNtczRTeTVzK2dCWjg0bEw3WUxZVFdWbjB0Zm5ReFpjeHRGTTRS?=
 =?utf-8?B?eHBYcHR3aUl2UzRNMmtSYmZPdFBXcGlKVHVnZThpMmt5eCs0S3FhMmJKNmpa?=
 =?utf-8?B?U3BmVFc4Tk9SMTd6M3pMT3BYOWhRMEN4N2hlb2ZxVXdZZ0NIalA2Mll6Y09o?=
 =?utf-8?B?QzJHb2d6bUtaeUhTdmFpTHUrQXJPaXRxZFcwV2NXY2ZCbE5FS1ZuU1ZnTndx?=
 =?utf-8?B?SW1Fa2NCRVZVajN4QzlWdkg0SEg2aEwwYkkxcmEzMUJWTGMxUmcxMWVLVTNZ?=
 =?utf-8?B?QkprMGtNbzFOV2xYTURKZE9CTGYwTGlITDMzNExnR2F3MGl5RTVoanNNMjdY?=
 =?utf-8?B?cU13MXdpSnloV3FYKzVwS0kyT2VWQ0o1cXp0bldhRk5scWhKMExEazhsK0Y5?=
 =?utf-8?B?VmxDU1Jma1FobVlWcXVxNWs2YVFZUHgxcHgwaXQ3N3h6VkUvWFFyVTllSTF5?=
 =?utf-8?B?VE5uRlRMd3BTblNmTFlYSHVwRjlUTTA3OVcwQ2kwbVc0YUswcGpzTEgwaWw5?=
 =?utf-8?B?Q2VLMlllbjRQMXpsWlowRVAwNFZaTk9tTVNzQzA3aXhpYnNxcVViSnRkNVEz?=
 =?utf-8?B?b0p5bFJobitDMWhhUmdjSjc2aTN6ZTYvOHFLbFVGRklycWM1K25nYmx2S0po?=
 =?utf-8?B?cU9KbnBPRjRmMW45U09LZTVuanZHeU5XUWR4SEtXeUUrb2VFNU1oSDk5bUhB?=
 =?utf-8?B?YmxLdnBxWmxubFBpbnNWV01OTGtBTitOUmxJTXJvRHRJZ1E4UTFyRFg3dEdB?=
 =?utf-8?B?Y0xuY0RYMWs4OWFmd3gyMEJzaDhKVnp1TkJwdWRaRGRJWmY5ZUxqOHZRUGtU?=
 =?utf-8?B?YjZqMCtiMkx3c1ZCaWhBNmlRSHR0bkd3YmFpR1A3VjdqeERrVXFENStBdEhw?=
 =?utf-8?B?Z3RraGIreTNDY2FhYS9yUGFCM1BCazBvT3V0eTVtZTgyM1REa1FKVXhoWXFF?=
 =?utf-8?B?ZHRoK2tkdFRXZEk4UDlXQjRMOE55R0swc0dnL0N5bVh3YWk2NmloeUw0YUhI?=
 =?utf-8?B?ZXh2U1ZkejlPdmQzNlVLV3JWTWhBZFl4NkVqMnpWQitGcThwSk5mM3JMNXh2?=
 =?utf-8?B?T2ZUUHFybFZVblI3N1lvM2tiWE4rSitiN1RuRXRxNGw3dkc2NVJIV3lnbmhi?=
 =?utf-8?B?QmR6c3lPWnpTd2ZobmV5TjltZ05tcWZPWEwyREU1bzNZM0c1SFJlLytXVlFl?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec24e70d-2e91-4c79-4c43-08d9fbf889e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 02:58:33.2000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sI3B2e0gBfoJjG8aoMAiMd4MMmMcj6xMCV+I7FtUwlAKR+8asTUnlzOg7MZ57iKTuRvR+L8MRGdl+p5aVTuWSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB4895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wqAKPj5PbiBUdWUswqAgMSBNYXIgMjAyMiAxODoyOTozMSAtMDgwMCBRaW5nIFdhbmcgd3JvdGU6
Cj4+IEZyb206IFdhbmcgUWluZyA8d2FuZ3FpbmdAdml2by5jb20+Cj4+IAo+PiBVc2UgdGhlIGhl
bHBlciBmdW5jdGlvbiB0aW1lX2lzX3tiZWZvcmUsYWZ0ZXJ9X2ppZmZpZXMoKSB0byBpbXByb3Zl
Cj4+IGNvZGUgcmVhZGFiaWxpdHkuCj4+IAo+PiBWMjoKPj4gYWRkIG1pc3NpbmcgIikiIGF0IGxp
bmUgMTM1NyB3aGljaCB3aWxsIGNhdXNlIGNvbXBsaWF0aW9uIGVycm9yLgo+Cj5JIHNlZSA6U8Kg
IFNvIHNpbmNlIHRoZSB2MSB3YXMgYWxyZWFkeSBhcHBsaWVkIGNvdWxkIHlvdSBwbGVhc2Ugc2Vu
ZCAKPmEgcGF0Y2ggdGhhdCBvbmx5IGFkZHMgdGhlIG1pc3NpbmcgYnJhY2tldCBiYXNlZCBvbiB0
aGlzIHRyZWU6Cj4KPmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L25ldGRldi9uZXQtbmV4dC5naXQvCj4KPj8gV2UgY2FuJ3QgZGlzY2FyZCB0aGUgb2xkIHBh
dGNoLCB3ZSBuZWVkIGFuIGluY3JlbWVudGFsIGZpeC4KPgo+VGhhbmtzIQoKU3VyZSwgaXQncyBt
eSBtaXN0YWtlLg==
