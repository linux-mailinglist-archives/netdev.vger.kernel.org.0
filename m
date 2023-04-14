Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77E6E2404
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDNNJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDNNJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:09:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8CFE77
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAEJzA4iuDa7zMZ7+Jsv4jy5MuanmJb/4DIKjJk/FJg5X6rIzsbxNxBAmNXaRQKCHyYGE6jMoIREyTrctXSLpo2Shc0fTttrWiiS21XfsIKFXFa1K+GV0mLPkrMhJ/4a7Tsb9z5+s8c/Edu/p9ZYdNkwSpfcH1dl9oCxYZqDExInu4piyCRMuViIJd5OTqwtNfFT42mpth4H3ArPUy6KAbPM4Xcie2UdwRd/kGVaBP85f/brsUCFhvvs/tuGW/8jLrTPN3g5ls/2THdGlnMNgkuxlOXNNi/MGwKNwVDLqY4kEE6yGR/M3oW1BjgAoMGS3QT7lBWPa+3Fg+9ki8Yeng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q6S3Nlg2W59kXKTW0AXE8U8oq/9XyORRH2+5rm1UJU=;
 b=c/zM9/7k2R722q8rWZnbFxvlRzC6ocVJghliO25eTls6tuqkMg6eIwM7AKn7bt7t1DqtJZBtYkKDV2eJAS2QmvuFlLeKH8Rgdp8U2Tz62fmYOZ0pBgLAIZMoORtWA2lU955JaoyIbFIJxCpJ4oiRrFndITUnMyT8tcUM2le9pPzJ7MFFYiNekn7TY2PW3NSJtwuFRrMVYl5d/zWtMWdIDWp5TUgW62wWDbaP5N5rBSJ4veWYOBgosZ2z9buCZy7HgIBvKiuUDWjod0q8HBDrNMdD5Z92NAtFtinUDVYgNul4Nlo3AwtYOxpGMrgrRHNBGnRoI2uAGRgfMMfJG6Drnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q6S3Nlg2W59kXKTW0AXE8U8oq/9XyORRH2+5rm1UJU=;
 b=cAMsQzSr9JEcMxl0Ad9UNoKOqZkZWVc465HrbPMrEatjr1OIHj2eUfZl33VnqyyxfR/l5PHEgH1guTIQmWyR2E8xd6Lmx5BEgIvLXmDJRNdd/r/86KKbNE4wv5BW+edA2b6TMRJaLB7RcMk3aPPRqrCoBmoS9FWJ1HjVUJkKUw2pRBzBM//eF7LaiYUrz6qsxKcxrYXoi09N7l/6QxVav8gfToA4yyR5RDFvtN8InXCWEgSMb1hzW44vX8ILz8uTb4p8BRtGxXk7f/uVAmju6TW75U4i3ipKPazm5xOH8GpVXIvZAkNW7l1DdLzkuR1gJrlYLNUu99aPZL9/2bXeDw==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by DM4PR12MB7502.namprd12.prod.outlook.com (2603:10b6:8:112::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Fri, 14 Apr
 2023 13:09:30 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02%5]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 13:09:30 +0000
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "ttoukan@nvidia.com" <ttoukan@nvidia.com>
Subject: Re: [PATCH net-next v2 0/3] page_pool: allow caching from safely
 localized NAPI
Thread-Topic: [PATCH net-next v2 0/3] page_pool: allow caching from safely
 localized NAPI
Thread-Index: AQHZbcAbYyH2ro2yMU+hUYcYTNwfTq8qyS8A
Date:   Fri, 14 Apr 2023 13:09:30 +0000
Message-ID: <3dd7675fcca2ce4d7ca93643d7507219bd7fa825.camel@nvidia.com>
References: <20230413042605.895677-1-kuba@kernel.org>
In-Reply-To: <20230413042605.895677-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|DM4PR12MB7502:EE_
x-ms-office365-filtering-correlation-id: f5395cef-0f95-49d3-5710-08db3ce97b8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKe6mcPwbtAX47PzTYgqdYcQMECE7Ufig7SFJyS2c8G47SNAIn2L6/IBYh6EaNHWmHAYNaeLLIbISdDEIoVMoHNd2JqBHEumRbbvkhk9Cp9sgbcg1PXhG8prOSQ/OuJzXr5L9jTrPl3+dQNBNaWiUgi5Jp8cKtPxC517b0XTtv2QA3q2R9Dk+VimCPJMcyErGqCxQw86FZOw4EgYwGiHgiTxdhUJC+lMDz16gV3ecMITJUo7bJ4MV8UNjF4yRyIjtEIZXtLSB1yfxS1nlhILcIAWTK91mSQycap6EmQRlNdjKgFxiZwhMFbIflU8ZPpbf9pzou48c3mNzFSyNJ2HkR15lMfToVAHHBrgyDzax1BUm7cP5TiJo1/avsHY/jNEGylw6us1WAv9fFgF+zySfOxtW0MJqO+RHTuv/g9z1ltADb3zCR4CcRWNa+Ez3iwTEwRD7GdQfVPCnjf7eMp/SYylGQaPuF9ify0KCC+AVivlBvGbidSyxKoCPmn+UpcXrliauv6KzzU5xhyBXbql1xX1Vw1+QGTIOplwZI+BVIdLp048ppHD7VW0/L9BtIbpSWwoL2UjH/udNYPWcJVgVD+z4i0b9sC7uuTIHwwuZyyJJy+EDcy5YrRC9xBBepR1PGzVygECL8ZVwWkg6OSwRq1V/oKxvTOxnccPqFhZd+rsbDyA67rsiASK76xHHJejH6o6OxaKjafuMiZB+7eb2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(478600001)(71200400001)(6512007)(83380400001)(36756003)(122000001)(2616005)(38070700005)(86362001)(38100700002)(91956017)(966005)(316002)(2906002)(5660300002)(186003)(66446008)(64756008)(6506007)(54906003)(66476007)(6916009)(66946007)(4326008)(6486002)(66556008)(8936002)(41300700001)(8676002)(107886003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RndsM0JyeWVKSytsM0NEZnZlSUZQYmF5Qmc2MWdEejk4aFpBS3hvcXl4VjF5?=
 =?utf-8?B?TGJHQ01SYUdVbmhZbEl5M3pjb0d3bUx1eE00ekNldDdZYjk3WER4UWFuSWtB?=
 =?utf-8?B?djFPUXlXVTE2a2lQUkUyVnZuK056Qm5Yc1VlaGJMOTdtTC96L3VjYWJLeFNw?=
 =?utf-8?B?c1VoVmdqKy9BQVpESHlzWmZYNGIrUjFsc0NqSGdXNUlBUmU3Q0FFYnA1aTd0?=
 =?utf-8?B?N050L2pQdE9FSGdCYjRidFN5bUcrTHdXcElwTTFOaG10cGRVQWZxK21ORnVi?=
 =?utf-8?B?cFQrSExpQjVkWW54Q0hNSnVTeVhPbDkyVnhsMUtYKzFLOG5TVDdMbFFNQWpt?=
 =?utf-8?B?NjlLc2didkUxc3R6L1ZLb2ZWUktRdWprWHFEdzBJeFNIMGR1czloajV0YnZ6?=
 =?utf-8?B?THUvMWxKOFEzV21HeU1xV0dBYjI1QUdDUDZ5U1JlMW5vNGRPTXVJRmJ3dEgx?=
 =?utf-8?B?OXk3SUtld0htaFIrVTV6QlNVc0NGTDZzQUxlcGZSWUdWcmF4NVpwaFBJT29R?=
 =?utf-8?B?eVhHNjZuM2M4allRSGIvbE5LWm1mNmJ0ZnlJZ1FmdWFvZHJldXZta09haU5M?=
 =?utf-8?B?eUdJeEs5NHhsTHRlbGg1VnpRWk5icHJCbmNIbWg4UDkvcnFaSWxsN0k1OTZw?=
 =?utf-8?B?Q3hvT2hmSDZuUVRMS1lEZ1FQdGZZcjdaMVRkVzhaSkdWWmVGaTluRE9yRzVH?=
 =?utf-8?B?YVVDdlVNc3NacmFEWUswN2pmT3FCaDdLZkUrUFhGei9CSkt2eXNzSTJ2VjNv?=
 =?utf-8?B?VlpHWkpMMlplVUFSc3RPQkxtSk4wYkdBdEJSNFFNa0hHSllVekgwVTlKTDBz?=
 =?utf-8?B?Q1BkdTcrQWtoY1FKaGFkWkQyUzBxTW9VNnorYjZHRWF4MEczSSswd0V3Znlv?=
 =?utf-8?B?YmtVNHdwMzY0a2trcXAwMEIrRlhSVmNaZ3NIYW1pY2VTVHg5Z3JjdXh0dnZ1?=
 =?utf-8?B?ak5pbFlqbWFmMk5KejIzZ1lVcFlzUjFwUGNYdjVxMGVHbVRLNXU1SmV0R3Fm?=
 =?utf-8?B?TmtWY1YzcDJhVUdaVjRUdnFObXJwVnU1MUwrU2pNZ1VFbHk3cThxWk1pbUJH?=
 =?utf-8?B?NWJ2dEg1UzdyNUtmYWhWOCtmY2ZmbUU0NTdpWDJYQ3dPbUtZdmtFWGtiYzlY?=
 =?utf-8?B?cGlWUUtJOFE3Qng0TzdVSEIybEV3L24wRFJ6N2RnenFzQnlPOXVpZGlzTFcv?=
 =?utf-8?B?dHpVeXhhOUc3aVhXVkZrMVZsWXY5NFAzeWRaZDlrVUZPZGtJRWlSdzdRUDZJ?=
 =?utf-8?B?VUpSbnM5Q2hkbGI2c0VSTjdJcG0ybWxOSTRqOHJGRzFIMHdmRzBTc0JaRVVN?=
 =?utf-8?B?RnpDNWhEVVp0NzNuSzRNNEdjSDR4TG1lR1lmSS83QUdRNDhYaVdUZ2NVc01p?=
 =?utf-8?B?Z3AwdU51RW5vbjRtVXBiQ3VxZVpOTnpuOW9qYWxzNURySmQyR1lBbmF5K3RE?=
 =?utf-8?B?MWg1OFB3bDlscWlYT2lJUlc5a29wVDNZYUNqdnRrYnJjUTQrOEFBU3Ztb3NW?=
 =?utf-8?B?WUFLUW8vTnI1UnY5WnRCQ21OcVU1RjdmUWIvaFhtdUJ6M3Z4U1JXVStpN2pr?=
 =?utf-8?B?WVd3T0ZWZzFsUkpRd0VKeFQ3QmkxODdqYTZnaXY0QWxlZVVFejFBNVRLSWJO?=
 =?utf-8?B?U1haWXlZaG1MWW1ROVdVYVlwWTFNYWpudVB1SDlCaHJLRjBITWdZZk11WUFo?=
 =?utf-8?B?U2JZemx6Z2twWks0ODZMc2dZY0dmY1BHN24xQ1gwQzRwQ0xNbTArZzdKelJ1?=
 =?utf-8?B?REJNZUdaSFpSTndiRVBzVWVJZm41TGIyZ3hML3pOa09iSWVEdEJqM0trNWNp?=
 =?utf-8?B?SWVIM1BENmhsVEYwMlJBbHlkQ0dyQkV0bHdFVVFTL1J6d1VQYklwZ0NPMlZY?=
 =?utf-8?B?NkxYYkRZMmozR3VuakNEelBRMENidTFzTjhtTXcrSjBiQTh4MVRYNWsxUDFn?=
 =?utf-8?B?N05hRVJ0SGprQStqaUZOWERaeTVmdXhyL0NqcGZyM0QxdEpBY1lCbVl4TDc0?=
 =?utf-8?B?emVjalU5SmZnTzVzYzZGOUtabkRIR3I5Q3VKLy9WU0VialY3SjlaVEFldnAx?=
 =?utf-8?B?Qm82TFRRTVBvSjBoakxYbVVNN1JQd1UvbDQvZTkzS3JuWDd2TFJnczQyTmk2?=
 =?utf-8?B?S2pxczViajZrUUFTYkpmTGRoQXpEaDZUajVFRjI1bnpSalZjOFpmemR3c1lq?=
 =?utf-8?Q?5TwW1na+s8RoezdpfOm0HC3FSjPBsW1ixE/H7XhgHpOA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBBD8B43653D0A44BD5ADD9C09396798@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5395cef-0f95-49d3-5710-08db3ce97b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 13:09:30.0397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebCu0Bah0pwqBsnOA7cbtvsYNziFfiNEtClEQqqh2ciusEHyUKOl2Av4QqBZZn7iqHQvb8rNK+/AFhL+Ra/MrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7502
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDIxOjI2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToK
PiBJIHdlbnQgYmFjayB0byB0aGUgZXhwbGljaXQgImFyZSB3ZSBpbiBOQVBJIG1ldGhvZCIsIG1v
c3RseQo+IGJlY2F1c2UgSSBkb24ndCBsaWtlIGhhdmluZyBib3RoIGFyb3VuZCA6KCAoZXZlbiB0
aG8gSSBtYWludGFpbgo+IHRoYXQgaW5fc29mdGlycSgpICYmICFpbl9oYXJkaXJxKCkgaXMgYXMg
c2FmZSwgYXMgc29mdGlycXMgZG8KPiBub3QgbmVzdCkuCj4gCj4gU3RpbGwgcmV0dXJuaW5nIHRo
ZSBza2JzIHRvIGEgQ1BVLCB0aG8sIG5vdCB0byB0aGUgTkFQSSBpbnN0YW5jZS4KPiBJIHJlY2tv
biB3ZSBjb3VsZCBjcmVhdGUgYSBzbWFsbCByZWZjb3VudGVkIHN0cnVjdCBwZXIgTkFQSSBpbnN0
YW5jZQo+IHdoaWNoIHdvdWxkIGFsbG93IHNvY2tldHMgYW5kIG90aGVyIHVzZXJzIHNvIGhvbGQg
YSBwZXJzaXNlbnQKPiBhbmQgc2FmZSByZWZlcmVuY2UuIEJ1dCB0aGF0J3MgYSBiaWdnZXIgY2hh
bmdlLCBhbmQgSSBnZXQgOTArJQo+IHJlY3ljbGluZyB0aHJ1IHRoZSBjYWNoZSB3aXRoIGp1c3Qg
dGhlc2UgcGF0Y2hlcyAoZm9yIFJSIGFuZAo+IHN0cmVhbWluZyB0ZXN0cyB3aXRoIDEwMCUgQ1BV
IHVzZSBpdCdzIGFsbW9zdCAxMDAlKS4KPiAKPiBTb21lIG51bWJlcnMgZm9yIHN0cmVhbWluZyB0
ZXN0IHdpdGggMTAwJSBDUFUgdXNlIChmcm9tIHByZXZpb3VzCj4gdmVyc2lvbiwKPiBidXQgcmVh
bGx5IHRoZXkgcGVyZm9ybSB0aGUgc2FtZSk6Cj4gCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBIVy1HUk/CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcGFnZT1wYWdlCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBiZWZv
cmXCoMKgwqDCoMKgwqDCoMKgwqDCoGFmdGVywqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJlZm9yZcKg
wqDCoMKgwqDCoMKgwqDCoMKgYWZ0ZXIKPiByZWN5Y2xlOgo+IGNhY2hlZDrCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoMKgMTM4NjY5Njg2wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoMKgMTUwMTkKPiA3NTA1Cj4gY2FjaGVfZnVs
bDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqDCoMKgwqAgMjIzMzkxwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gNzQ1ODIK
PiByaW5nOsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAxMzg1NTE5MzPCoMKgwqDCoMKgwqDCoMKgCj4g
OTk5NzE5McKgwqDCoMKgwqDCoMKgMTQ5Mjk5NDU0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgMAo+IHJpbmdfZnVsbDrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCA0ODjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDMxNTTCoMKgwqDCoMKgwqDC
oMKgwqAKPiAxMjc1OTAKPiByZWxlYXNlZF9yZWZjbnQ6wqDCoMKgwqDCoMKgwqDCoDDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IMKgwqDCoDAKPiAKPiBhbGxvYzoKPiBmYXN0OsKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAxMzY0OTEzNjHCoMKgwqDCoMKgwqDCoDE0ODYxNTcxMMKgwqDCoMKg
wqDCoMKgMTQ2OTY5NTg3wqDCoMKgwqDCoMKgwqAxNTAzMgo+IDI4NTkKPiBzbG93OsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxNzcywqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxNzk5wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDE0NMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IDEwNQo+
IHNsb3dfaGlnaF9vcmRlcjrCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoDDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgCj4gwqDCoMKgMAo+IGVtcHR5OsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTc3
MsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTc5OcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxNDTC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAKPiAxMDUKPiByZWZpbGw6wqDCoMKgwqDCoMKgwqDCoMKg
wqAgMjE2NTI0NcKgwqDCoMKgwqDCoMKgwqDCoCAxNTYzMDLCoMKgwqDCoMKgwqDCoMKgIDIzMzI4
ODDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gMjEyOAo+IHdhaXZlOsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoAo+IMKgwqDC
oDAKPiAKRW5hYmxlZCB0aGlzIG9uIHRoZSBtbHg1IGRyaXZlciBhbmQgc2VlaW5nIHRoZSBmb2xs
b3dpbmcgcGFnZV9wb29sCmNhY2hlIHVzYWdlIGltcHJvdmVtZW50cyBmb3Igc2luZ2xlIHN0cmVh
bSBpcGVyZiB0ZXN0IGNhc2U6CgotIEZvciAxNTAwIE1UVSBhbmQgbGVnYWN5IHJxLCBzZWVpbmcg
YSAyMCUgaW1wcm92ZW1lbnQgb2YgY2FjaGUgdXNhZ2UuCgotIEZvciA5SyBNVFUsIHNlZWluZyAz
My00MCAlIHBhZ2VfcG9vbCBjYWNoZSB1c2FnZSBpbXByb3ZlbWVudHMgZm9yCmJvdGggc3RyaWRp
bmcgYW5kIGxlZ2FjeSBycSAoZGVwZW5kaW5nIGlmIHRoZSBhcHAgaXMgcnVubmluZyBvbiB0aGUK
c2FtZSBjb3JlIGFzIHRoZSBycSBvciBub3QpLgoKT25lIHRoaW5nIHRvIG5vdGUgaXMgdGhhdCB0
aGUgcGFnZV9wb29sIGNhY2hlIHNlZW1zIHRvIGdldCBmaWxsZWQgbW9yZQpvZnRlbiBmb3Igc3Ry
aWRpbmcgcnEgbm93IHdoaWNoIGlzIHNvbWV0aGluZyB0aGF0IHdlIGNvdWxkIHBvdGVudGlhbGx5
CmltcHJvdmUgb24gdGhlIG1seDUgc2lkZS4KClJlZ2FyZGluZyBteSBlYXJsaWVyIGNvbW1lbnQ6
Cgo+IEFmdGVyIGVuYWJsaW5nIHRoaXMgaW4gdGhlIG1seDUgZHJpdmVyLCB0aGVyZSBpcyBhbHJl
YWR5IGltcHJvdmVkCj4gcGFnZV9wb29sIGNhY2hlIHVzYWdlIGZvciBvdXIgdGVzdCB3aXRoIHRo
ZSBhcHBsaWNhdGlvbiBydW5uaW5nIG9uIAo+IHRoZSBzYW1lIENQVSB3aXRoIHRoZSByZWNlaXZl
IHF1ZXVlIE5BUEkgKDAgLT4gOTggJSBjYWNoZSB1c2FnZSkuCgpJIHdhcyB0ZXN0aW5nIHdpdGhv
dXQgdGhlIGRlZmVycmVkIHJlbGVhc2Ugb3B0aW1pemF0aW9ucyB0aGF0IHdlIGRpZCBpbgp0aGUg
bWx4NSBkcml2ZXIuCgo+IHYyOgo+IMKgLSBtaW5vciBjb21taXQgbWVzc2FnZSBmaXhlcyAocGF0
Y2ggMSkKPiB2MToKPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA0MTEyMDE4MDAu
NTk2MTAzLTEta3ViYUBrZXJuZWwub3JnLwo+IMKgLSByZW5hbWUgdGhlIGFyZyBpbl9ub3JtYWxf
bmFwaSAtPiBuYXBpX3NhZmUKPiDCoC0gYWxzbyBhbGxvdyByZWN5Y2xpbmcgaW4gX19rZnJlZV9z
a2JfZGVmZXIoKQo+IHJmY3YyOgo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIzMDQw
NTIzMjEwMC4xMDMzOTItMS1rdWJhQGtlcm5lbC5vcmcvCj4gCj4gSmFrdWIgS2ljaW5za2kgKDMp
Ogo+IMKgIG5ldDogc2tiOiBwbHVtYiBuYXBpIHN0YXRlIHRocnUgc2tiIGZyZWVpbmcgcGF0aHMK
PiDCoCBwYWdlX3Bvb2w6IGFsbG93IGNhY2hpbmcgZnJvbSBzYWZlbHkgbG9jYWxpemVkIE5BUEkK
PiDCoCBibnh0OiBob29rIE5BUElzIHRvIHBhZ2UgcG9vbHMKPiAKPiDCoERvY3VtZW50YXRpb24v
bmV0d29ya2luZy9wYWdlX3Bvb2wucnN0wqDCoMKgIHzCoCAxICsKPiDCoGRyaXZlcnMvbmV0L2V0
aGVybmV0L2Jyb2FkY29tL2JueHQvYm54dC5jIHzCoCAxICsKPiDCoGluY2x1ZGUvbGludXgvbmV0
ZGV2aWNlLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyArKwo+IMKgaW5j
bHVkZS9saW51eC9za2J1ZmYuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHwgMjAgKysrKysrKy0tLS0KPiDCoGluY2x1ZGUvbmV0L3BhZ2VfcG9vbC5owqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAzICstCj4gwqBuZXQvY29yZS9kZXYuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMyAr
Kwo+IMKgbmV0L2NvcmUvcGFnZV9wb29sLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgfCAxNSArKysrKystLQo+IMKgbmV0L2NvcmUvc2tidWZmLmPCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA0MiArKysrKysrKysrKyst
LS0tLS0tLS0KPiAtLQo+IMKgOCBmaWxlcyBjaGFuZ2VkLCA1OCBpbnNlcnRpb25zKCspLCAzMCBk
ZWxldGlvbnMoLSkKPiAKClRlc3RlZC1ieTogRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVhQG52aWRp
YS5jb20+Cg==
