Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3F9492DE6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348428AbiARSxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:53:50 -0500
Received: from mail-co1nam11on2128.outbound.protection.outlook.com ([40.107.220.128]:26036
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348235AbiARSxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 13:53:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOabtFsPt6HEJkAMSyD1VpbGpg7vbTK4MFv5e3090kpTVv4S4fyB0a1I3kS6t/ywCd1mpL+9T6364yRMJw8OcJ85J4RFv6IQTM8ea6XmGem7OqdtzTIOgRsGKIIl0n/GpaZ1yywUHLamQRsGUswAsyjqhsS04J/k7WBfpnDpZCA7dV1+9skuiPQlfyWTc3QGq2grvJYckbCKG/IiS1D3+KDh8nBjLj+vx1p8CBbm6hviLTsFVHF/UKY4g1J+pW726LTd73dn2odof7BLyoYNBveQdK3LOsY3mpo5PiwL7jl7vb7Q0298oyy3mMsSRU0z2sI9FQcY83oGpPy2QTyuXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7FEFqh5YhLIeI6uz8fIMZ8pRuRaJUOlchNin6AnY/4=;
 b=jW1a/5DauCezCQMZ0ncAesApwa+Xz11/WSF2iMMV91AWtvjsXy91pkWVIlsEMc6N4NCTsAu4ZTEQiaiowB7kIW7U5Dg1V5JyyMpqAwC7vd+9iyI/jRdyLPPDFlKwM/du1aOcmew5g3vtdKPC8c/8/gz2wVwppwzK8n+FLNhODLIOo9IP4AjArphfJM24/w/kCsnMS9QXccVbBymERPd7qnjA2ZFjm/GaNOUYf+nB+qB1KvLp/zYReoryQ7ahJYtfPuZ1tssD8TJ91GRfI+uOq5ltJj9nhd5hQ91rIDZY+1n56/kmwIdCOnOsXBSqQu51BDERXvKCiiGHlEfv5L68MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7FEFqh5YhLIeI6uz8fIMZ8pRuRaJUOlchNin6AnY/4=;
 b=PMbkgu0zeHMy2YlD6psYlbHxmZC4CS8G7gL3aSMpLYP9NbJZmPYeQN1Pb3gw855D/ZIRRy8ErxicwpQhw7AX0cw2kQSJkEgIGSpb14jtzKlTjT9TEj9lvQiRaDzO+PEyixSx/zWPOjt0Zsi4J55DWqaXS6tGGMVsAwhjiJLynfE=
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 (2603:10b6:301:33::18) by MN2PR22MB2013.namprd22.prod.outlook.com
 (2603:10b6:208:207::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 18:53:46 +0000
Received: from MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e]) by MWHPR2201MB1072.namprd22.prod.outlook.com
 ([fe80::a42e:ece:ffbf:4b3e%7]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 18:53:46 +0000
From:   "Liu, Congyu" <liu3101@purdue.edu>
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "rsanger@wand.net.nz" <rsanger@wand.net.nz>,
        Wang Hai <wanghai38@huawei.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "jiapeng.chong@linux.alibaba.com" <jiapeng.chong@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIG5ldF0gbmV0OiBmaXggaW5mb3JtYXRpb24gbGVha2Fn?=
 =?gb2312?Q?e_in_/proc/net/ptype?=
Thread-Topic: [PATCH net] net: fix information leakage in /proc/net/ptype
Thread-Index: AQHYDDkp902/uKzwgku6KEgEh1qeR6xodcUAgACq19o=
Date:   Tue, 18 Jan 2022 18:53:46 +0000
Message-ID: <MWHPR2201MB1072C10AFC2C4C1AD68A4382D0589@MWHPR2201MB1072.namprd22.prod.outlook.com>
References: <20220118070029.1157324-1-liu3101@purdue.edu>
 <CANn89iJevGzP5r6sPXpX=pSxPJWZQHjKKYekZpFTG9xEq50pMg@mail.gmail.com>
In-Reply-To: <CANn89iJevGzP5r6sPXpX=pSxPJWZQHjKKYekZpFTG9xEq50pMg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: f194b114-0f83-8524-95b3-230096c07799
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purdue.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e64bbb29-fa50-4240-f2d6-08d9dab3db8b
x-ms-traffictypediagnostic: MN2PR22MB2013:EE_
x-microsoft-antispam-prvs: <MN2PR22MB2013CF6EF2ED47035510F4E3D0589@MN2PR22MB2013.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CqzNzfOhkFO8CT5Ikt6gnoq2LE/GBBPPMiPFP+Vm1hrzwBqbDya8rcTcwjK0ynuuuq8zfi73T8hBkKDqRGN02n0PtYeuVc65ptSL+aqfaB84xOKV5W7fbw5s9jdhQ1s5gfHEKjaltQaIIB2+0+c7pdtiCiJtVWe16uZn5yS6uRstmi+MeLrU0ZfvjD501BHH/EkkxsydmEq290WOiEgguGWZPKymh0s6VUQ4IsFCOXAeq+cXic4SpScFwNxPrDxyw1R9G6aXgPYc/pqvm1F1dc9hGdQdQio1Izup63/V/NrUsVIidsCIT5WuQZInASX1uzEyCLrc3Y+yzgNQCm9DRlA9OQBtGlHZj+yjJlUF1AmpoGeEWwa9Ak+pissGlhDPgv70eWkHf0dBdnWUba1WPFYvHVJWA2lrpUwQ3NV2VrML4Bi6f89vHB+9rQIN0SQNU/+gjBuQgcmkRv1iIHHGzHmr+qXT7ptjz2vgmMckRn0vxWSW3i/oLp3wBTs03HeBynY8HcZMkGDOSs3ul3VdBJzER8cawTUL7zWQy6GNXfdCQCLl1EFXWw67NX+XIaw0RW5Ukx5ENtRlE4o5WVGYiv/McM8ERuU3ffL/YULfrmdpQMeIIxFLScMMYA4aPKnEA4QsshzyKSfwO13LNhsTAVNww1qz0Z9A1itEvR9aa5eemxjJp6d8+NlBsrUnkmeO2VRTxbvrgnFW/PtHHpbz5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR2201MB1072.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(66476007)(55016003)(66556008)(786003)(186003)(122000001)(4326008)(7696005)(54906003)(508600001)(66946007)(71200400001)(224303003)(52536014)(76116006)(91956017)(66446008)(316002)(6506007)(64756008)(5660300002)(9686003)(86362001)(53546011)(38100700002)(33656002)(38070700005)(7416002)(83380400001)(75432002)(8936002)(2906002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?a1hwZTBJeVE4MGtQZnVvSlZ1dFVSMzBONG5qVVJlc1I3QzVDNlA5UXVIZGdp?=
 =?gb2312?B?T0lHUkJXQ21ydThUREs4bisrY2NXa2c5dk45V1dwdnlaUzZPQ2xsVS9KOGF6?=
 =?gb2312?B?L25ydXNQMmZoNlp0RXJkcU1pcFRqZFJ4am1rVWNjc3ZpY1dZRjQ0Rm1LM3F2?=
 =?gb2312?B?N0QxM1UyYm9pNmFHdlF5UnJNYUdOaGI4dkdONGdFTGQ2UDA0ck5HQXVQRGEy?=
 =?gb2312?B?MzJ5aHphUzkxWlhSSG90N3NwZi9CK2pHQ1NqdHJEUXh0dWo3RlpGMG83ZHky?=
 =?gb2312?B?NWNRTW1WQXBSQnNxMVM1N3lieEVROTBlMlBZL1laUGVqSThzM1BSNUVjWmd1?=
 =?gb2312?B?Wm1JRXZENUpnNzl0WlB3UmgvZFFGbFRmYTNrOXBWV3VSeC9ON3ljNDc1S2xj?=
 =?gb2312?B?UUkzTVhjU0RDaWhZZ3hWU1BncFVyR2x0RElFWHZKV3NXTHdjSFJLSDdkeDlD?=
 =?gb2312?B?TmtQQk9yUTFmVW93eG5JWlBjQlRyWXN2MG1TaDhZNGRYZVYzQXBlSEtXY09h?=
 =?gb2312?B?WFNIWFNuYjNNUUo5UFNkUTEwbWlqZGVNT3FCbXVzS3hpbVVlSHNkSzhMT1pK?=
 =?gb2312?B?OWcvbHI0RitieXloN3NxcEJRdWlPRUFkczN6TTNpT3hUTDFtNVVqRDhtZlRa?=
 =?gb2312?B?OGdraWVyUWM1ZWUwZXNwTEFBMTFiK1RwRThPZTBCMW5tbVc5Q1B1ZllEVmlC?=
 =?gb2312?B?VkdXbE14OVlCcHE5MFM2OFBaalRWbDExWkF0bGQ1SXpldXk5U0J4NDU3cHFn?=
 =?gb2312?B?SEwrNGYwVldKQS9rRnF2aGd3ZFgycjFVZHN3WUN6MTd4V05VYU15bkJUVTR2?=
 =?gb2312?B?allzdXFlb1hkdS9kcFV6K2d4bnVhTmh1VERVZHNRWkdXNEdUVElDUWpXc0FE?=
 =?gb2312?B?cFc3dU1qS1ZXd1dLVkdMdnEwdGtnN0pjYUVRY05rUWJiK2dXekwxb0Nad29i?=
 =?gb2312?B?U0NvQjhwUGNkMUFGYWovNzc3Mm1KbW01ME8wKzRHNGlGMElJdE9PRkJDV2hO?=
 =?gb2312?B?YS85MkY0YzV3WVZyVW9IUHcvWlN5bUNKeTE4Q1M2REduYldmQ0IvOEx1Rm43?=
 =?gb2312?B?T1ZtYjRrRFVrN0grZUlkQ3VyVkNqSmpvZEtIeUVWaEtaSzhIU0VXWUY3a0lv?=
 =?gb2312?B?R09qV3B5Y01uL1pScGg3b2k4YUJuTmJvZG9Od016aFBXV2lIT05hbHQ4ZlNl?=
 =?gb2312?B?NFQ2UUFLYVVYdkRPY0RzYm5qcXkwRVZNSGN2NFNSc0pNenhicW96UFRHUEZX?=
 =?gb2312?B?MVRDeGVmZXdOcXI2WVJsaU56dlI1QnJ1TVZXRVAxNENmUCtpQUx5eFZ3NDlw?=
 =?gb2312?B?ODl0TC9SSnlFV09oTVRrWG10RCtEU1BrVVpDUHNVc3d3WndoYURTNkdkYisw?=
 =?gb2312?B?eE1wZCtDMHNDWm5tMGRmWEhKTlZZQ1l5SGl6MzRzTG51Y2l0L2tVQ0ovWGd2?=
 =?gb2312?B?Mk03OHA4Wk1tMTg0Q1Z2eGNMQ0N4azFXTUFwVzM4WElvcGpiRzg2RENCTkJV?=
 =?gb2312?B?VVdjRlNoSGw0OGc5a3U0cjRxZ3N6WndFcWV5U3BlWXRtQWgzYk1jK0xxS0ZJ?=
 =?gb2312?B?c1huQ3NRZU4yQWVYT0hYczdWeHRVOU1hZGlmQkFPaHJOWGdRRzNSRklDVjNZ?=
 =?gb2312?B?T25pTGxYQzlNUHd4UVVoVDYyOGVKNlhPUlBQUDRGaDZ3YTV3K1JSOGlncS9I?=
 =?gb2312?B?SGRPdEExdXNiSEpyaC81RktacmN0T1dIRHpmZk4rcWdDK0x2QXVtNSsyMGRw?=
 =?gb2312?B?NVVOUDBRaE9aWHFzelJXc3pQMUpGRnRvMmpId1h0VC83amxac2FUR3ZXeFpJ?=
 =?gb2312?B?cWQ1anV5WVBxYkI5T0FPNFc0TVo4NDFHOHpSeHVtMmFhQmVIWVRGczkxVkRM?=
 =?gb2312?B?cGROL2FhRndkdXpJcjVhajZ1Rld3QlFFRVk2SXBBZVl5ZktycSt2cENqdGtN?=
 =?gb2312?B?WnJQTm41c3d2dDBGOUFmdjREdVdpSXh3NytoWjM2eDNyNWhWOGQwa2FpK0Ft?=
 =?gb2312?B?c2ZaeEQ1bjZsNUJSWXhSazhwMk80R05BaHIxanpvRkdOTzY5RlkxYVBpdFRw?=
 =?gb2312?B?Tm5KRUZwVzBHT2JFQ0gyR094eWFtb1grQVBJZHltdEZ2WUpQVk1kNExWZzd0?=
 =?gb2312?B?ZkwzUVBDNmwvWGZHYzMyZE90L2UvenV4eVpSV3JCWkNYRnFMaWZvbkVjR25h?=
 =?gb2312?B?NGc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR2201MB1072.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64bbb29-fa50-4240-f2d6-08d9dab3db8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 18:53:46.5769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBzFfZtDMSC+W0EyG8KwjhGtclXxpnt0VOgMC2aVeSoG2VEXEdBizngli82iQK+PPYvBhkc0tJi+CElrDh2g3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR22MB2013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzISBUaGF0IG1ha2VzIHNlbnNlLiBJIHdpbGwgc2VuZCBhIFYyIHBhdGNoLg0KDQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IEVyaWMgRHVtYXpl
dCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCreiy83KsbzkOiAyMDIyxOox1MIxOMjVIDM6NDANCsrV
vP7IyzogTGl1LCBDb25neXUNCrOty806IERhdmlkIE1pbGxlcjsgSmFrdWIgS2ljaW5za2k7IFlh
anVuIERlbmc7IFdpbGxlbSBkZSBCcnVpam47IE1hcmMgS2xlaW5lLUJ1ZGRlOyByc2FuZ2VyQHdh
bmQubmV0Lm56OyBXYW5nIEhhaTsgUGFibG8gTmVpcmEgQXl1c287IGppYXBlbmcuY2hvbmdAbGlu
dXguYWxpYmFiYS5jb207IG5ldGRldjsgTEtNTA0K1vfM4jogUmU6IFtQQVRDSCBuZXRdIG5ldDog
Zml4IGluZm9ybWF0aW9uIGxlYWthZ2UgaW4gL3Byb2MvbmV0L3B0eXBlDQoNCk9uIE1vbiwgSmFu
IDE3LCAyMDIyIGF0IDExOjAxIFBNIENvbmd5dSBMaXUgPGxpdTMxMDFAcHVyZHVlLmVkdT4gd3Jv
dGU6DQo+DQo+IEluIG9uZSBuZXQgbmFtZXNwYWNlLCBhZnRlciBjcmVhdGluZyBhIHBhY2tldCBz
b2NrZXQgd2l0aG91dCBiaW5kaW5nDQo+IGl0IHRvIGEgZGV2aWNlLCB1c2VycyBpbiBvdGhlciBu
ZXQgbmFtZXNwYWNlcyBjYW4gb2JzZXJ2ZSB0aGUgbmV3DQo+IGBwYWNrZXRfdHlwZWAgYWRkZWQg
YnkgdGhpcyBwYWNrZXQgc29ja2V0IGJ5IHJlYWRpbmcgYC9wcm9jL25ldC9wdHlwZWANCj4gZmls
ZS4gSSBiZWxpZXZlIHRoaXMgaXMgbWlub3IgaW5mb3JtYXRpb24gbGVha2FnZSBhcyBwYWNrZXQg
c29ja2V0IGlzDQo+IG5hbWVzcGFjZSBhd2FyZS4NCj4NCj4gQWRkIGEgZnVuY3Rpb24gcG9pbnRl
ciBpbiBgcGFja2V0X3R5cGVgIHRvIHJldHJpZXZlIHRoZSBuZXQgbmFtZXNwYWNlDQo+IG9mIGNv
cnJlc3BvbmRpbmcgcGFja2V0IHNvY2tldC4gSW4gYHB0eXBlX3NlcV9zaG93YCwgaWYgdGhpcw0K
PiBmdW5jdGlvbiBwb2ludGVyIGlzIG5vdCBOVUxMLCB1c2UgaXQgdG8gZGV0ZXJtaW5lIGlmIGNl
cnRhaW4gcHR5cGUNCj4gc2hvdWxkIGJlIHNob3duLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb25n
eXUgTGl1IDxsaXUzMTAxQHB1cmR1ZS5lZHU+DQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9uZXRk
ZXZpY2UuaCB8ICAxICsNCj4gIG5ldC9jb3JlL25ldC1wcm9jZnMuYyAgICAgfCAgMyArKy0NCj4g
IG5ldC9wYWNrZXQvYWZfcGFja2V0LmMgICAgfCAxOCArKysrKysrKysrKysrKysrKysNCj4gIDMg
ZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvbmV0ZGV2
aWNlLmgNCj4gaW5kZXggMzIxM2M3MjI3YjU5Li43MmQzNjAxODUwYzUgMTAwNjQ0DQo+IC0tLSBh
L2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9uZXRkZXZp
Y2UuaA0KPiBAQCAtMjU0OCw2ICsyNTQ4LDcgQEAgc3RydWN0IHBhY2tldF90eXBlIHsNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBuZXRfZGV2
aWNlICopOw0KPiAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgICgqaWRfbWF0Y2gpKHN0
cnVjdCBwYWNrZXRfdHlwZSAqcHR5cGUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IHNvY2sgKnNrKTsNCj4gKyAgICAgICBzdHJ1Y3QgbmV0ICAg
ICAgICAgICAgICAqKCpnZXRfbmV0KSAoc3RydWN0IHBhY2tldF90eXBlICpwdHlwZSk7DQo+ICAg
ICAgICAgdm9pZCAgICAgICAgICAgICAgICAgICAgKmFmX3BhY2tldF9wcml2Ow0KPiAgICAgICAg
IHN0cnVjdCBsaXN0X2hlYWQgICAgICAgIGxpc3Q7DQo+ICB9Ow0KDQpQYXRjaCBsb29rcyBmaW5l
LCBidXQgdGhlIHF1ZXN0aW9uIGlzOg0KDQpDYW4gYW4gYWZfcGFja2V0IHNvY2tldCBjcmVhdGVk
IGluIG5ldG5zIEEgY2FuIGJlIG1vdmVkIHRvIG5ldG5zIEIgbGF0ZXIgPw0KDQpBcyB0aGUgYW5z
d2VyIGlzIHByb2JhYmx5IG5vLCBpdCBzZWVtcyB3ZSBjb3VsZCBzaW1wbHkgYWRkIGEgJ3N0cnVj
dA0KbmV0JyAgcG9pbnRlcg0KIGluICdzdHJ1Y3QgcGFja2V0IHR5cGUnLCBubyBuZWVkIGZvciBh
IGZ1bmN0aW9uLg0KDQpUaGFua3MuDQo=
