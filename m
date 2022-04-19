Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EF75079C9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350232AbiDSTHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbiDSTHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:07:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9950B3FBF7;
        Tue, 19 Apr 2022 12:04:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlF+oo+U2kydqGeKVuptCCSrQGcLiSBwiRbAOzsRXxpJ+gGygtoF5oryRP9gIb03oQZJ9kHkcTFaSb2Lh/+XlwkCxMB+bA7xfPggwFsAM3AZGDdyuGn+0dxXCtl3fzj14klWoDmmwFuleXG5PuGtXOze4hbmyHnJWnvFKMxgm9u8xODoRAoidFIDUDsCSgpTrmmHdstSwE01xNsXt6IJwsK/k/a8JkLIvsbRXTGPP1GRrwW8FGjAmmcKaiopEg8EGWlsxluZwGazpLp7RaTc1AZ/U/eDPMwM27VrMU6DNH8kQlecOPjxw1LS8vdh4eLdUh33RIoaYpFq9Ek78/6+dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38UJeFh8Zs+oQdeXsv9FVBVeKBQo1SWSefXCh2htyGk=;
 b=DFk3SKOpLTPfb5UqDrxT4ZoFjDSeWU1c8cIV3xuRbHq3LKBdXSYfhHZxqafAQoeCxEu7JSHogQs7fCc0Kk/fCzHQrAPsTiUh0QDNGUYhZ5tv735CJFB9gJQ3XuXytRzQPFZ/tSFNVC9OQznTgnbJqpAog2KwFDpyNxyPtFNqx0/YnE1FWQkKIx6or/dNaIopnnSv3PHPSnatvrDkoS0zkVR2UvdiqucY+aBkxR2zQSOkJBWxOaK28HBcnVTdBrAc0SIGMOvZ1XqZ2ng+JVJOvQpp/CZFyRD4k0gq/aVNMgtCfeQnPHZok6PmjPRSOCxqjZm4rkhDqC2IXR6yUIouug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38UJeFh8Zs+oQdeXsv9FVBVeKBQo1SWSefXCh2htyGk=;
 b=BUu2cKPcYxfMEnst+hbaa0Iuncymd+BqCS24rgCAVL/lNaeUv7FRSxTPR2hjGlkXAIvBVafdghbRb9QpnZrg7TOWi9uOpoitytTlAalq2hiyKfO902iW5s6qJr34/I6lvSyzpZaVh2MDX5KfgRpi5a79EzE6Y7m7wEbI+OjnkWs=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Tue, 19 Apr
 2022 19:04:30 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006%7]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 19:04:30 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>
Subject: Re: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Topic: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Index: AQHYU0T20WiaobmnKkCy/6DDEwmcKKz2i/CAgAEAwwCAAA1QgA==
Date:   Tue, 19 Apr 2022 19:04:30 +0000
Message-ID: <36618d90e44961aed7b40c4640952fd574fce60c.camel@hammerspace.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
         <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
         <a771c65353d0805fc5f028fa56691ee762d6843f.camel@hammerspace.com>
         <AE1190F4-EDE4-4C2D-94C9-02A5EDAAFBC6@oracle.com>
In-Reply-To: <AE1190F4-EDE4-4C2D-94C9-02A5EDAAFBC6@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c360ca4-62e9-48cf-164d-08da22376eaa
x-ms-traffictypediagnostic: DM6PR13MB4431:EE_
x-microsoft-antispam-prvs: <DM6PR13MB4431E4E3DDA1CA7E861F24A0B8F29@DM6PR13MB4431.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcUty5Vh28C/dhWU3Xd987CQppAWLR7qNIrkf1PAybC2Vl4f4kFQMoRUGqTN2mmNakEiiz5o34uNuH+EMwYQEJKRBIDfxOkJCeyD67FezgsmnwoxEL67uiAZdI4hVkuPzem4gnZznlom/X3WceqKUzglzN93gDR+qHZnhuF4Kh9EF+az8NcrZHz/N4zHnZq+/iTRBl52NR46JeN0RTwF+xEpVXIbXJpvCTNsnM9hwt0/G0QrlpMIG0bYOCqcS+oWX8k2eazTxhrIICdRpaCyuCNEgB3/RB2J7Gbrhx1MMS2zt/+VxHMnc5V6tlYKfP6BJUhByLsYpPluHb9KLFzNR+1zhQEdnDp5Q4MAN5uyK7s0B1dMyA1E8u5BDI8iAd844F0GYsrbvirjkGgrBr3ot8f4C3MHapcJ//RpE+Bldo5sYQqXkmCBltJV1Rk3H+KLYc/p6nSHY/iwz6/VSoeeG574zNuuALY9VFwf6q3WcI/FmRfTHajyS789w1xljaqVjFR8fSYn5wNB7naclIq8crQUMRH3L5iojsMNOgAKaKO/Rq59yCGYuqzyBUcBdwo+2MZcYwSy2lin1jsn+ka95vDNv0T1y+nWSbOSACW/qHkcw0ZEq20OfGdgAB8acvd3T6ZeS2FzhisgNeFErGU40M1JcHnMUbJ24ZHykHRevTV7uXYtrEGL0kGlls+xx8BfWljhqnxQWP7iMkAFVz2Qg+/WQ309VOqmecoPwOcC10jUSxze4qpN3FdNvaYrWvmW+Fc78po5Lv6xu9pQ0PT3qTLt9H+toO264C8zz65nXqo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(64756008)(66446008)(8676002)(4326008)(76116006)(26005)(8936002)(5660300002)(83380400001)(15974865002)(6486002)(508600001)(66476007)(66946007)(71200400001)(66556008)(6916009)(186003)(122000001)(36756003)(38100700002)(38070700005)(54906003)(6506007)(316002)(6512007)(53546011)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2w2RzBmZ0dVTVZnWHdDQWdybFd5dHlVYW02MGdQQ1IwMG1RYmlHcFJRc0ZZ?=
 =?utf-8?B?VXBFamM4azBiTWxQNWtrSVJMZjhhUVhpSXhsK0lUKzVCZzVlRFhuUWFOQmhD?=
 =?utf-8?B?OERrcU5wWDY3ZjVkT0VUSzBwUHNaREZpMGdNZWxkRlQwWWNGSGo0SlV1ZlVl?=
 =?utf-8?B?R1pZMmJJd3I5bk1jSnpVM2NMb3dxVlR4NjduQkE2K3RYZy9kdndoNjBPNVZO?=
 =?utf-8?B?a3ZHQVVyaU9iUTdXVlNrK2FYbUFzeHRYMXQ4RTNweVdYSS9nRkRQMjVpQ0tz?=
 =?utf-8?B?VXBHYmdvd2g2VXo4WTdSNHlaM1djbTl0OTVRdkxvNW0waWtDYlRHY3ZpSjVV?=
 =?utf-8?B?OW9kcTdQWUU0cGNuYU1mVlpnRG5sdy9SeitFRXlvZkpwN0RnQjk3WjhOemor?=
 =?utf-8?B?OWp3U1E2VVhqRU5QNlh0YWFRRng3aXlIV2w0eE9NeHV3dXRqYm1CNmVBVHhV?=
 =?utf-8?B?Zy9xTkRtdTBaRGxDWllFS0lLNzVESWRqbnFvUVlaYnljR0NJWDFiN1NUMzVS?=
 =?utf-8?B?YUl6ZHIrZktwRisvQ0JDc0RCMDNDb2t3aHc5bWlVLzFIcXphQWNIbjFYdSsr?=
 =?utf-8?B?UHhwR3pwT0h1b2Y3c2FPUElPRUw3Vk40ZjZKVDB2NEhDdE1lZFE1NWlOQjRW?=
 =?utf-8?B?OTlTMUZSUExaend1ME9Rc0NHMUJaUHhTTUZTNGtraWs3ZzRyQWExa2JUSCtU?=
 =?utf-8?B?K3lsMlN5UXJwK2lkd1JDTFBCaGdLUndBVzFxVTRUOWVFMTNIc0xQZ1VSYkk5?=
 =?utf-8?B?b09RbGE5MjVrUmhVcm5MOWlaei9YTk82NTFaTHg3eWRYVXZJSDJTQ0Myall2?=
 =?utf-8?B?aVdjVkNtTDN4UitaZWxuN0lIMTdHRnVUZStxSDNUbkcyR05mejR5ZzZLUmhD?=
 =?utf-8?B?cDRpdHFkSUkwc2FhRTFKTnpndVNCV1l5V2hCSStRbXpncEN6YVVJSE1xWkQw?=
 =?utf-8?B?MFFkK1c2bkxKQzh0T0ZrbnEyamVzaUNJTVp4RS95WFRhRVN0NjN1NzlvalNo?=
 =?utf-8?B?OVFEL2hwN0MrejNnV3ZCdi8zUEE0M0JyTFp1VFFDWUZ5c3p6Z0FCeHI3Ulo3?=
 =?utf-8?B?MERaK3cvRnpZYThMQlVSV2FXcXV1Z3d5OGZKOE4zSVcrREFWeGE0dklIVkZP?=
 =?utf-8?B?UStZTGowa0FoYk5BVWhnWDdndjhqa1pyTGxZMW5iNDV5MUwvRFdXK2ltMVhR?=
 =?utf-8?B?cy8vb3JZbjZhVG8vSHNOYUZkc05rM2IxdU5ZU01vdFRqS3pScFJnZmV6QWZ6?=
 =?utf-8?B?UlFhbnBSSVJCN3pFU1J5elRyMnlvdDhVWHg1KzVSY0JDVTRBOU5PMHI5aFpp?=
 =?utf-8?B?NkNFbXg2SHhDb053SnR3SDRWT2pzQnJFalRNRW50aGIyblFCYmhpNjZrTlg1?=
 =?utf-8?B?akxWcWNTNnlkWXNMVDlaN1NlNDFoYjZtTlh5c2ZKVzBsMXN6OWRQazJYeFRO?=
 =?utf-8?B?cTVpRkZJN2pLTmlhWDI2SGxIcWhQaEdaSHBtSWtGN0hPbDY0U3JpbHVvcnN2?=
 =?utf-8?B?UkVlWEMzQUY1N1QwdjI5dGdBSXQ5TDVUS2wyaFFONFRvZEdRVHVmY2x0WWpB?=
 =?utf-8?B?b3FsNkFTc21ONE5IejJLNnVHdWdMT0ZiWlB2NzN1a0ZPbzNPY1o2VWdOakxJ?=
 =?utf-8?B?UGJqaGJERDBuVTJmZTg3YndCandLcmc2MElFMnhsMDBxaU4yZFRucml0WXhj?=
 =?utf-8?B?KzRDWjJmZS81bUxUL0YvWmY3VHhXRDhQYzQzRXJMYzZuSW4zKzdiRTJ3QTZ5?=
 =?utf-8?B?WWlpQ1FkS3daTjFyOTB6d0ZCYldKZUlFeDdDUC9XbEFHbTlGcUlMQVdWNWN4?=
 =?utf-8?B?bEdSTnVRQmhMWlBuRkRUeEVTU1Z4Uzdhc2IzK0hpczNuYXFMdUJydDBMUnJh?=
 =?utf-8?B?Uk4rdi8wWFRKVWZmYzhMNmtEMTgrekcwMTB4VmlXTHZKMTZEeVB4NEM2cjZx?=
 =?utf-8?B?eGdpYUgrNldOaXp0RmtmYjZQYlF1MTdHeTFwTEVWMHZkZXI3M3FqS1IyTUhJ?=
 =?utf-8?B?SStpdHJpMkRWVnl3TC95V0NuRTI2NXhyZUpyZ0lrVDlxOVRMWGxTTDN0azdk?=
 =?utf-8?B?ckRRdmxyV0x6cnA0UFZ0OE8zb21pN1BpdWx3dzNERkxkZWRmM01kamRQbExU?=
 =?utf-8?B?Ym56MjZoYy9BdmdTZjNuRVFqNG9SNHduQkdQTWR3angrUDVRbGdYUXAyUDRN?=
 =?utf-8?B?Z0R6VndXd3ZESTNCVkVzUVZxNUMweHUwd0hXK3RaRWdEUmNVOWRFNEl1SE51?=
 =?utf-8?B?c3l0bXgzd3kyUHlQaVV4MEtVRUNtTmZBNWdPcVZoVWhjR1UvRk5HSWp4OEpT?=
 =?utf-8?B?T3hrWE9OakZuMVI0cEs5bWF1UnpuR2ZRZE9PLy9ZZEthZ1lDYTUyNVJOTjF1?=
 =?utf-8?Q?shplU/YMmym8vSAU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C310B4D5C5DF44EBF287358EE0893F6@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c360ca4-62e9-48cf-164d-08da22376eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:04:30.1220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7MwMLOOpMiKk9438oQJi/HMbdU7cAqJOsX1lptrNc5D+gHrqvSGpzcSV6QqcN8Q4BSyVCR2+MYkEvlARNcWJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4431
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA0LTE5IGF0IDE4OjE2ICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6
Cj4gCj4gCj4gPiBPbiBBcHIgMTgsIDIwMjIsIGF0IDEwOjU3IFBNLCBUcm9uZCBNeWtsZWJ1c3QK
PiA+IDx0cm9uZG15QGhhbW1lcnNwYWNlLmNvbT4gd3JvdGU6Cj4gPiAKPiA+IE9uIE1vbiwgMjAy
Mi0wNC0xOCBhdCAxMjo1MiAtMDQwMCwgQ2h1Y2sgTGV2ZXIgd3JvdGU6Cj4gPiA+IEludHJvZHVj
ZSBhIG1lY2hhbmlzbSB0byBjYXVzZSB4cHJ0X3RyYW5zbWl0KCkgdG8gYnJlYWsgb3V0IG9mCj4g
PiA+IGl0cwo+ID4gPiBzZW5kaW5nIGxvb3AgYXQgYSBzcGVjaWZpYyBycGNfcnFzdCwgcmF0aGVy
IHRoYW4gZHJhaW5pbmcgdGhlCj4gPiA+IHdob2xlCj4gPiA+IHRyYW5zbWl0IHF1ZXVlLgo+ID4g
PiAKPiA+ID4gVGhpcyBlbmFibGVzIHRoZSBjbGllbnQgdG8gc2VuZCBqdXN0IGFuIFJQQyBUTFMg
cHJvYmUgYW5kIHRoZW4KPiA+ID4gd2FpdAo+ID4gPiBmb3IgdGhlIHJlc3BvbnNlIGJlZm9yZSBw
cm9jZWVkaW5nIHdpdGggdGhlIHJlc3Qgb2YgdGhlIHF1ZXVlLgo+ID4gPiAKPiA+ID4gU2lnbmVk
LW9mZi1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+Cj4gPiA+IC0tLQo+
ID4gPiDCoGluY2x1ZGUvbGludXgvc3VucnBjL3NjaGVkLmjCoCB8wqDCoMKgIDIgKysKPiA+ID4g
wqBpbmNsdWRlL3RyYWNlL2V2ZW50cy9zdW5ycGMuaCB8wqDCoMKgIDEgKwo+ID4gPiDCoG5ldC9z
dW5ycGMveHBydC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgMiArKwo+ID4gPiDC
oDMgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCj4gPiA+IAo+ID4gPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9zdW5ycGMvc2NoZWQuaAo+ID4gPiBiL2luY2x1ZGUvbGludXgvc3Vu
cnBjL3NjaGVkLmgKPiA+ID4gaW5kZXggNTk5MTMzZmIzYzYzLi5mOGMwOTYzOGZhNjkgMTAwNjQ0
Cj4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvc3VucnBjL3NjaGVkLmgKPiA+ID4gKysrIGIvaW5j
bHVkZS9saW51eC9zdW5ycGMvc2NoZWQuaAo+ID4gPiBAQCAtMTI1LDYgKzEyNSw3IEBAIHN0cnVj
dCBycGNfdGFza19zZXR1cCB7Cj4gPiA+IMKgI2RlZmluZSBSUENfVEFTS19UTFNDUkVEwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAweDAwMDAwMDA4wqDCoMKgwqDCoCAvKiBVc2UKPiA+ID4g
QVVUSF9UTFMgY3JlZGVudGlhbCAqLwo+ID4gPiDCoCNkZWZpbmUgUlBDX1RBU0tfTlVMTENSRURT
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDB4MDAwMDAwMTDCoMKgwqDCoMKgIC8qIFVzZQo+ID4g
PiBBVVRIX05VTEwgY3JlZGVudGlhbCAqLwo+ID4gPiDCoCNkZWZpbmUgUlBDX0NBTExfTUFKT1JT
RUVOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDB4MDAwMDAwMjDCoMKgwqDCoMKgIC8qIG1ham9y
Cj4gPiA+IHRpbWVvdXQgc2VlbiAqLwo+ID4gPiArI2RlZmluZSBSUENfVEFTS19DT1JLwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAweDAwMDAwMDQwwqDCoMKgwqDCoCAvKiBjb3Jr
Cj4gPiA+IHRoZQo+ID4gPiB4bWl0IHF1ZXVlICovCj4gPiA+IMKgI2RlZmluZSBSUENfVEFTS19E
WU5BTUlDwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAweDAwMDAwMDgwwqDCoMKgwqDCoCAv
KiB0YXNrCj4gPiA+IHdhcwo+ID4gPiBrbWFsbG9jJ2VkICovCj4gPiA+IMKgI2RlZmluZcKgwqDC
oMKgwqDCoMKgIFJQQ19UQVNLX05PX1JPVU5EX1JPQklOwqDCoMKgwqDCoMKgwqDCoCAweDAwMDAw
MTAwwqDCoMKgwqDCoAo+ID4gPiAvKgo+ID4gPiBzZW5kIHJlcXVlc3RzIG9uICJtYWluIiB4cHJ0
ICovCj4gPiA+IMKgI2RlZmluZSBSUENfVEFTS19TT0ZUwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAweDAwMDAwMjAwwqDCoMKgwqDCoCAvKiBVc2UKPiA+ID4gc29mdAo+ID4gPiB0
aW1lb3V0cyAqLwo+ID4gPiBAQCAtMTM3LDYgKzEzOCw3IEBAIHN0cnVjdCBycGNfdGFza19zZXR1
cCB7Cj4gPiA+IMKgCj4gPiA+IMKgI2RlZmluZSBSUENfSVNfQVNZTkModCnCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKCh0KS0+dGtfZmxhZ3MgJgo+ID4gPiBSUENfVEFTS19BU1lOQykK
PiA+ID4gwqAjZGVmaW5lIFJQQ19JU19TV0FQUEVSKHQpwqDCoMKgwqDCoCAoKHQpLT50a19mbGFn
cyAmCj4gPiA+IFJQQ19UQVNLX1NXQVBQRVIpCj4gPiA+ICsjZGVmaW5lIFJQQ19JU19DT1JLKHQp
wqDCoMKgwqDCoMKgwqDCoCAoKHQpLT50a19mbGFncyAmIFJQQ19UQVNLX0NPUkspCj4gPiA+IMKg
I2RlZmluZSBSUENfSVNfU09GVCh0KcKgwqDCoMKgwqDCoMKgwqAgKCh0KS0+dGtfZmxhZ3MgJgo+
ID4gPiAoUlBDX1RBU0tfU09GVHxSUENfVEFTS19USU1FT1VUKSkKPiA+ID4gwqAjZGVmaW5lIFJQ
Q19JU19TT0ZUQ09OTih0KcKgwqDCoMKgICgodCktPnRrX2ZsYWdzICYKPiA+ID4gUlBDX1RBU0tf
U09GVENPTk4pCj4gPiA+IMKgI2RlZmluZSBSUENfV0FTX1NFTlQodCnCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKCh0KS0+dGtfZmxhZ3MgJgo+ID4gPiBSUENfVEFTS19TRU5UKQo+ID4g
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvc3VucnBjLmgKPiA+ID4gYi9pbmNs
dWRlL3RyYWNlL2V2ZW50cy9zdW5ycGMuaAo+ID4gPiBpbmRleCA4MTExODdjNDdlYmIuLmU4ZDZh
ZGZmMWE1MCAxMDA2NDQKPiA+ID4gLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvc3VucnBjLmgK
PiA+ID4gKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvc3VucnBjLmgKPiA+ID4gQEAgLTMxMiw2
ICszMTIsNyBAQCBUUkFDRV9FVkVOVChycGNfcmVxdWVzdCwKPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHsgUlBDX1RBU0tfVExTQ1JFRCwgIlRMU0NSRUQiCj4gPiA+IH0swqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB7IFJQQ19UQVNLX05VTExDUkVEUywgIk5VTExDUkVE
UyIKPiA+ID4gfSzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB7IFJQQ19DQUxMX01BSk9SU0VFTiwgIk1B
Sk9SU0VFTiIKPiA+ID4gfSzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBc
Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHsgUlBDX1RBU0tfQ09SSywgIkNP
UksiCj4gPiA+IH0swqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBcCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB7IFJQ
Q19UQVNLX0RZTkFNSUMsICJEWU5BTUlDIgo+ID4gPiB9LMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgeyBSUENfVEFTS19OT19ST1VORF9ST0JJTiwgIk5PX1JPVU5EX1JPQklOIgo+ID4gPiB9
LMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB7IFJQQ19UQVNLX1NPRlQsICJTT0ZUIgo+ID4gPiB9LMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+ID4gPiBkaWZmIC0tZ2l0IGEv
bmV0L3N1bnJwYy94cHJ0LmMgYi9uZXQvc3VucnBjL3hwcnQuYwo+ID4gPiBpbmRleCA4NmQ2MmNm
ZmJhMGQuLjRiMzAzYjk0NWI1MSAxMDA2NDQKPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy94cHJ0LmMK
PiA+ID4gKysrIGIvbmV0L3N1bnJwYy94cHJ0LmMKPiA+ID4gQEAgLTE2MjIsNiArMTYyMiw4IEBA
IHhwcnRfdHJhbnNtaXQoc3RydWN0IHJwY190YXNrICp0YXNrKQo+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKHhwcnRfcmVxdWVzdF9kYXRhX3JlY2VpdmVkKHRhc2spICYm
Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICF0ZXN0X2JpdChS
UENfVEFTS19ORUVEX1hNSVQsICZ0YXNrLQo+ID4gPiA+IHRrX3J1bnN0YXRlKSkKPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKFJQQ19JU19DT1JLKHRhc2spKQo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb25kX3Jlc2NoZWRfbG9jaygmeHBy
dC0+cXVldWVfbG9jayk7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgIH0KPiA+ID4gwqDCoMKgwqDCoMKg
wqAgc3Bpbl91bmxvY2soJnhwcnQtPnF1ZXVlX2xvY2spOwo+ID4gPiAKPiA+ID4gCj4gPiAKPiA+
IFRoaXMgaXMgZW50aXJlbHkgdGhlIHdyb25nIHBsYWNlIGZvciB0aGlzIGtpbmQgb2YgY29udHJv
bAo+ID4gbWVjaGFuaXNtLgo+IAo+IEknbSBub3Qgc3VyZSBJIGVudGlyZWx5IHVuZGVyc3RhbmQg
eW91ciBjb25jZXJuLCBzbyBiZWFyIHdpdGgKPiBtZSB3aGlsZSBJIHRyeSB0byBjbGFyaWZ5Lgo+
IAo+IAo+ID4gVExTIHZzIG5vdC1UTFMgbmVlZHMgdG8gYmUgZGVjaWRlZCB1cCBmcm9udCB3aGVu
IHdlIGluaXRpYWxpc2UgdGhlCj4gPiB0cmFuc3BvcnQgKGkuZS4gYXQgbW91bnQgdGltZSBvciB3
aGVuZXZlciB0aGUgcE5GUyBjaGFubmVscyBhcmUgc2V0Cj4gPiB1cCkuIE90aGVyd2lzZSwgd2Un
cmUgdnVsbmVyYWJsZSB0byBkb3duZ3JhZGUgYXR0YWNrcy4KPiAKPiBEb3duZ3JhZGUgYXR0YWNr
cyBhcmUgcHJldmVudGVkIGJ5IHVzaW5nICJ4cHJ0c2VjPXRscyIgYmVjYXVzZQo+IGluIHRoYXQg
Y2FzZSwgdHJhbnNwb3J0IGNyZWF0aW9uIGZhaWxzIGlmIGVpdGhlciB0aGUgQVVUSF9UTFMKPiBm
YWlscyBvciB0aGUgaGFuZHNoYWtlIGZhaWxzLgo+IAo+IFRoZSBUQ1AgY29ubmVjdGlvbiBoYXMg
dG8gYmUgZXN0YWJsaXNoZWQgZmlyc3QsIHRob3VnaC4gVGhlbiB0aGUKPiBjbGllbnQgY2FuIHNl
bmQgdGhlIFJQQ19BVVRIX1RMUyBwcm9iZSwgd2hpY2ggaXMgdGhlIHNhbWUgYXMgdGhlCj4gTlVM
TCBwaW5nIHRoYXQgaXQgYWxyZWFkeSBzZW5kcy4gVGhhdCBtZWNoYW5pc20gaXMgaW5kZXBlbmRl
bnQKPiBvZiB0aGUgbG93ZXIgbGF5ZXIgdHJhbnNwb3J0IChUQ1AgaW4gdGhpcyBjYXNlKS4KPiAK
PiBUaGVyZWZvcmUsIFJQQyB0cmFmZmljIG11c3QgYmUgc3RvcHBlcmVkIHdoaWxlIHRoZSBjbGll
bnQ6Cj4gCj4gMS4gd2FpdHMgZm9yIHRoZSBBVVRIX1RMUyBwcm9iZSdzIHJlcGx5LCBhbmQKPiAK
PiAyLiB3YWl0cyBmb3IgdGhlIGhhbmRzaGFrZSB0byBjb21wbGV0ZQo+IAo+IEJlY2F1c2UgYW4g
UlBDIG1lc3NhZ2UgaXMgaW52b2x2ZWQgaW4gdGhpcyBpbnRlcmFjdGlvbiwgSSBkaWRuJ3QKPiBz
ZWUgYSB3YXkgdG8gaW1wbGVtZW50IGl0IGNvbXBsZXRlbHkgd2l0aGluIHhwcnRzb2NrJ3MgVENQ
Cj4gY29ubmVjdGlvbiBsb2dpYy4gSU1PLCBkcml2aW5nIHRoZSBoYW5kc2hha2UgaGFzIHRvIGJl
IGRvbmUgYnkKPiB0aGUgZ2VuZXJpYyBSUEMgY2xpZW50Lgo+IAo+IFNvLCBkbyB5b3UgbWVhbiB0
aGF0IEkgbmVlZCB0byByZXBsYWNlIFJQQ19UQVNLX0NPUksgd2l0aCBhCj4gc3BlY2lhbCByZXR1
cm4gY29kZSBmcm9tIHhzX3RjcF9zZW5kX3JlcXVlc3QoKSA/CgoKSSBtZWFuIHRoZSByaWdodCBt
ZWNoYW5pc20gZm9yIGNvbnRyb2xsaW5nIHdoZXRoZXIgb3Igbm90IHRoZSB0cmFuc3BvcnQKaXMg
cmVhZHkgdG8gc2VydmUgUlBDIHJlcXVlc3RzIGlzIHRocm91Z2ggdGhlIFhQUlRfQ09OTkVDVEVE
IGZsYWcuIEFsbAp0aGUgZXhpc3RpbmcgZ2VuZXJpYyBSUEMgZXJyb3IgaGFuZGxpbmcsIGNvbmdl
c3Rpb24gaGFuZGxpbmcsIGV0YwpkZXBlbmRzIG9uIHRoYXQgZmxhZyBiZWluZyBzZXQgY29ycmVj
dGx5LgoKVW50aWwgdGhlIFRMUyBzb2NrZXQgaGFzIGNvbXBsZXRlZCBpdHMgaGFuZHNoYWtlIHBy
b3RvY29sIGFuZCBpcyByZWFkeQp0byB0cmFuc21pdCBkYXRhLCBpdCBzaG91bGQgbm90IGJlIGRl
Y2xhcmVkIGNvbm5lY3RlZC4gVGhlIGRpc3RpbmN0aW9uCmJldHdlZW4gdGhlIHR3byBzdGF0ZXMg
J1RDUCBpcyB1bmNvbm5lY3RlZCcgYW5kICdUTFMgaGFuZHNoYWtlIGlzCmluY29tcGxldGUnIGlz
IGEgc29ja2V0L3RyYW5zcG9ydCBzZXR1cCBkZXRhaWwgYXMgZmFyIGFzIHRoZSBSUEMgeHBydAps
YXllciBpcyBjb25jZXJuZWQ6IGp1c3QgYW5vdGhlciBzZXQgb2YgaW50ZXJtZWRpYXRlIHN0YXRl
cyBiZXR3ZWVuClNZTl9TRU5UIGFuZCBFU1RBQkxJU0hFRC4KCj4gPiBPbmNlIHdlJ3ZlIGRlY2lk
ZWQgdGhhdCBUTFMgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvLCB0aGVuIHdlCj4gPiBzaG91bGRu
J3QKPiA+IGRlY2xhcmUgdG8gdGhlIFJQQyBsYXllciB0aGF0IHRoZSBUTFMtZW5hYmxlZCB0cmFu
c3BvcnQgaXMKPiA+IGNvbm5lY3RlZAo+ID4gdW50aWwgdGhlIHVuZGVybHlpbmcgdHJhbnNwb3J0
IGNvbm5lY3Rpb24gaXMgZXN0YWJsaXNoZWQsIGFuZCB0aGUKPiA+IFRMUwo+ID4gaGFuZHNoYWtl
IGlzIGRvbmUuCj4gCj4gVGhhdCBsb2dpYyBpcyBoYW5kbGVkIGluIHBhdGNoIDEwLzE1Lgo+IAo+
IFJlY29ubmVjdGluZyBhbmQgcmUtZXN0YWJsaXNoaW5nIGEgVExTIHNlc3Npb24gaXMgaGFuZGxl
ZCBpbgo+IHBhdGNoZXMgMTEvMTUgYW5kIDEyLzE1LiBBZ2FpbiwgaWYgdGhlIHRyYW5zcG9ydCdz
IHBvbGljeSBzZXR0aW5nCj4gaXMgIm11c3QgdXNlIFRMUyIgdGhlbiB0aGUgY2xpZW50IGVuc3Vy
ZXMgdGhhdCBhIFRMUyBzZXNzaW9uIGlzIGluCj4gdXNlIGJlZm9yZSBhbGxvd2luZyBtb3JlIFJQ
QyB0cmFmZmljIG9uIHRoZSBuZXcgY29ubmVjdGlvbi4KPiAKPiAKPiAtLQo+IENodWNrIExldmVy
Cj4gCj4gCj4gCgotLSAKVHJvbmQgTXlrbGVidXN0CkNUTywgSGFtbWVyc3BhY2UgSW5jCjQ5ODQg
RWwgQ2FtaW5vIFJlYWwsIFN1aXRlIDIwOApMb3MgQWx0b3MsIENBIDk0MDIyCuKAiwp3d3cuaGFt
bWVyLnNwYWNlCgo=
