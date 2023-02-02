Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705BD688781
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjBBTY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjBBTY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:24:28 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2113.outbound.protection.outlook.com [40.107.220.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF1E728C5;
        Thu,  2 Feb 2023 11:24:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kpw2mP4hRltoRftUu527iv4H9HEgtcU+7n4ChR6Wy6OmjYmQMgzL90v/CtoGp9WNawJn88wN13Jd1Slg9L1umSSNA/iPg2/VVihVdMTuU79uN4AeiJZHNscTCUYd6E4UtMnWZoAuNodxkbIuuvymMuLiDahrtxBrcUUH/yz2TzkXeNoyAS/zKjXlY/2f17AbP2vq6v0CTKZkB4vXLbUI+nLh/+0c1qy5J+BXzZ6luUial0cBSz4fuci7ay7KLRI6btX8vUzSFCYHBYgMxfUbATneAn78iSatlwqm++pZmJRnMYJk1RtIjfF7LmjEEauyaRzgmrABuLailcmn6jK5vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzeFdDZ7zFxvIya5LglEDCUwLweqUa4o7Z8MuvqfpxE=;
 b=fDfUBwByBYvzjXtGQ9pJ3/kOPHUc9COcIjf6nrc2yZmhgYIpfzivgP1+iarjjXLEBg7D+bT2BDVzdmnD/Z1q1BuBgvglFDo3NofNTYWJQlfpAWMFgFGnQvm+eZzp5IikhQXjBeaBVOEj18mfEB+BdajPUwAAjBvIEyzTEKw8PdvQVTDk8vkUa88GdswrKpdfASJRGnZCjkUkwyiMFgdXaS2MyUf4dyvODRyGEh1w55ZJg+bHCHjjVQn70aTxnFsoVhGil4Sr6yrp89VPGB4luRejMEle/5wlq19lXcX9WMHH9FzlE0FrqJDnL+/j5yzcfLrxD0LjDkeIvnFGdOMizw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzeFdDZ7zFxvIya5LglEDCUwLweqUa4o7Z8MuvqfpxE=;
 b=NGaZxS1IZKVMT1OhtKydB/3Gz6GjHvYRtHJ142sXL6i03Q1Q5nEgKvUI8w43JXxS9Wh/Q8dh40i1hn7cNZkhUgA4yRbAZL4PgB7RKOkOBrvlS+mbqtRSFFNWPk7K4gNC7qz5XNF3kfe0sgP+MHH2RaAu2Hj5FhW+D7PAEsO0WYA=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH8PR21MB3813.namprd21.prod.outlook.com (2603:10b6:510:215::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.8; Thu, 2 Feb
 2023 19:24:24 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%7]) with mapi id 15.20.6086.007; Thu, 2 Feb 2023
 19:24:24 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Topic: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Index: AQHZNSTmJ1bDNw5Jnkqja7kiNGrDuK67HG2AgAAB1fCAADi9gIAAtkfQ
Date:   Thu, 2 Feb 2023 19:24:24 +0000
Message-ID: <BYAPR21MB1688416185F59759D4CBB365D7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
         <20230201210107.450ff5d3@kernel.org>
         <BYAPR21MB1688B7F47F9ADF2E40E9DEE4D7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com>
In-Reply-To: <8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ee971193-ff47-4af1-b721-e61fac7e2db1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-02T19:23:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH8PR21MB3813:EE_
x-ms-office365-filtering-correlation-id: 78845863-424a-4599-170b-08db05531802
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i49a2tovcHlQV9+vTlGk69ZdTEdbhgEcIYvMbP2eMBeoCGLYQC5xMhqlAFRtsf9dQO5QlTfMP5XsSGBWcdIYqsqB8UfqmoZBj7ivxbQbFk4Ck+4fyJYKnV/tHluo+qTga8PQVyBN2nVumtxJwElYm7p40PcyOud55XuInzA1z+z/63c7+O9f3ijZ7y9CO4fU/qQun1Kf7H18hPOF43ZjUtDpKzBnxVsspDMw1U3E8uDH+GcIuXhAsee8bUyNHneaclVa4HHythNH8xRCvYGtW6NMAmwTTZmisVyCDOo3NM1sXDhwOaTOcEelmZjfsIZJLibK5OH7yUDbUob6slGSqJkW6KUsdiRtU8w98b665Zg398ndQqHpOxCXPWtGe2HmZUsKBFGFV3uTypzdGx/kQImq+E50jJTrLJI2dlNkAl/sPi7kRQsrubijT8Afzj9/n5hKlMJnJ4xoUc0ycUZIAiG79RtCxZuPzH6Sx+a39BUvGE8z2urtUGaZvB0RUe95gGPUP3v5E+Tps6ktua1TRzlSTYuORatLMmEN8PgUW3yi2StrAxJVws9PsgEnq5zJnJyxuUeOXevvaqNo9iN7cehtva73mjP21PQm61bsko+rRbRvU9nccXkHERa71eZN9JrY2ErHPRu/8gum9OpYWKlU31mC868eXkHDh8jVE7VeY01b3Q6GkwjO0q78UjL01q1BSt+MOKeUbCRi7KgbooaxOQrGU95yLhUTDgcR4UeHuQgZuT5Fgol5elKjyNJR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(71200400001)(83380400001)(54906003)(110136005)(8990500004)(33656002)(2906002)(38100700002)(316002)(7696005)(122000001)(82950400001)(82960400001)(6506007)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(76116006)(478600001)(26005)(9686003)(186003)(8936002)(52536014)(41300700001)(10290500003)(86362001)(55016003)(4326008)(38070700005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWpaSnA1K0phZmlISUduQ09RTTNTeUtVRU1pYzJscjJtZVo1SGdpdkVsY2g0?=
 =?utf-8?B?TSs0TndFUS9kRVNyTzRvdGFnbTdVQVExNlA2MmxnMTROU0RqamRSKzVVU3p1?=
 =?utf-8?B?ZW5EOVZzUHRYeU1FUW1mUHJFSUszemE3UzdmZytITTBPckJteW1WaEVsZHQ1?=
 =?utf-8?B?bEhILzJJK24weUM3N29WZi9sVE1oM1Nuc0dMMEtNRmpScmw4UXRaVnpueTNz?=
 =?utf-8?B?d0RncUJCMWVObzdzZldRc2lFOGZEN2ZMMnRlVDNDYWhlaWtmTFlid2dGSWxP?=
 =?utf-8?B?M3pWTzQ3MVd3VWVEcFByY0VZMkFVNVlicUF1VWFKc1R6aHNPb0RVYkNvQnVk?=
 =?utf-8?B?K2QxVlNFRVQ3WjFLZWE2QWlzUjFRUWZ5M3dOcWZQTnZWWEE5bzRxeGl6cVly?=
 =?utf-8?B?NVRKaEVoeUdjSFpqQUo2cXd6OWk5WU14bUpPWTRoTlI2clNPRy9rYktPT2JE?=
 =?utf-8?B?MkhnUElZVzBMampOSWRNVEEyc0dMYU55WFlRUFRUcEdSeldjTnFsSThoOVUz?=
 =?utf-8?B?TEZ0ZVFGWStBMG9UUVBoQ0xNMzJGUERrN1dySElGdXljZkFaa2lkQ3UvQUpn?=
 =?utf-8?B?M2xVRXVBZDNaNTdSTmFPemEwSCtibnJmV2VKZ3hneDYvdGtyTEgxMWlTWG9r?=
 =?utf-8?B?N2hWU1JEVUNYTHlER0ZzQklHZ1dtWFk3cllCRTBFeXVrYmMrZTVQcG9mVGgw?=
 =?utf-8?B?MjN6OGtKcEJLUy9lR0lQUGhhT29aMTkweDVrSWNlREFIbzBCRDFVdzNyL1BE?=
 =?utf-8?B?c2UvQ0FFSWNnYkVxb2VUWldQdXUzd1ppbFdkbytQVzZRWDlROUJmRjhuTTBY?=
 =?utf-8?B?UHdNMDFGNzg4RnM3NUhIaE9CZzAwQ3R0MWYvajlaV2I4WUdIWnBnbGIwVnZz?=
 =?utf-8?B?Qm9MZHl6QmIvQTFFdUhlUFNBcGZWVjU3UFZrVC9BZmNrN0VLWnp5TTRoWHJD?=
 =?utf-8?B?TDVseHdUWmtXNGp4MnJ5V2YwakJqQ0Z2RnNVTUN6TFk3WFBpT3JSbS9tNlBZ?=
 =?utf-8?B?bXNYY2FHWEtMSWdzRG80U1BidmdLTm9Xa2prZ2Q5S2YrMWlHZk44NXVUc1Mv?=
 =?utf-8?B?SFg1eE5UdDE0R3B0SHJQZHl4SzlTMkJxQk5mUVlQd3ZTOU1Lb2tjNW9uUmhm?=
 =?utf-8?B?aWsxclRBb0FDYTRaanNYREcwaUk2d1FVMzFnNjZ5TFZRZXZOdEUyV29OM294?=
 =?utf-8?B?ZG8yOHVCbUxqVnJvNGJDaGtTcWtKYXB1cVJaVmpUaVVEMUk1ZVB1ZU5ZaUkw?=
 =?utf-8?B?RTc3NmxSL1p5ZjU5d2dTUnlmdDBlVmtnL0NlUVIwVnQ3RjFYemhaTlRLa0hB?=
 =?utf-8?B?ZGtnZXkrTk04aUw3UmtrblA4UHpjamNiWWFYYjAybGZMNkF6RjUwQS9tMUxN?=
 =?utf-8?B?TFZ0bVl1QmZPSGE1bEViUEtETVR1QS9qVCtHWit4MTQyOFA3TnFEZlFSbENl?=
 =?utf-8?B?UjROZmJlMEFiSStpaU9pK0taZ29JOGdjUVJFbi9aWUR0Ujlsbk52VXpsczdG?=
 =?utf-8?B?N3VFM01tSnU2NkJEYkl5TThidncrWVEyQ1RDaG9nTDNZdHNZUXA0S25MQ25h?=
 =?utf-8?B?T3F5TVJGTXBrcWpxOUx4bTJQWS9pSDBpV2NNYlAxUWI0TDI5OVZYZk81cFFr?=
 =?utf-8?B?d0NqTmFDdE4rR2F1RFg0SmlyaVZSQThoalJia1Z1dEFYdWlIaElCRXFWdVRU?=
 =?utf-8?B?Q3VZSElxK0RvQzNuZDNXY2R6NThGV1FIamtYYzFGTjdZZXpjTnFmTjR1Rk5y?=
 =?utf-8?B?R1lGSVV5YTJHL3pwSFlYdS9TRllnenNZN1pLd0Q0YUZrRzNqZU9MVEY5OFpZ?=
 =?utf-8?B?MWNobGhhMXhzanNJT1RsbGxMU1l3ZUhsbkU1cWhnRkFIeFRFTWFRaHc0LzVV?=
 =?utf-8?B?Nk9LL1ZYdGVyZGE4b0I1dmFkWXkway90bTA4alN0R3ZTdlhQQlQ5VzNjNFVW?=
 =?utf-8?B?eVhhbWVYN2VPbXl3OW1vVklQU291RXFKYTdIUG56YmNqVHdIdmNlZlorNUlY?=
 =?utf-8?B?eVhrdm4xZ2xWallkTFd4TERxSHBjTzE1K3ZWSWFaNnZYelcxUUs1K1VsVytu?=
 =?utf-8?B?UFhnRnE1bzBDRFMrdW1hcXdEUmI2TFU5OG53dUdoWVFpZnAyeG9VOGg4cktr?=
 =?utf-8?B?eTR1WmRJL0NqS3J4TkVDUUlMYTllY08rK3RPMmtjQ0JBMXc5Y0UyZWdQZDg5?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78845863-424a-4599-170b-08db05531802
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 19:24:24.5803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1Vczilkf4SLrCckm1jQh39845g8lPccGH5TXKrlAlOrVKjV77EV/0ahx6C6MBgsDPrc1+pAETycuC347toRYNLLj9hOtfDpF2tYNfZ/CFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3813
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPiBTZW50OiBUaHVyc2RheSwgRmVi
cnVhcnkgMiwgMjAyMyAxMjozMSBBTQ0KPiANCj4gT24gVGh1LCAyMDIzLTAyLTAyIGF0IDA1OjIw
ICswMDAwLCBNaWNoYWVsIEtlbGxleSAoTElOVVgpIHdyb3RlOg0KPiA+IEZyb206IEpha3ViIEtp
Y2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMSwgMjAy
MyA5OjAxIFBNDQo+ID4gPg0KPiA+ID4gT24gTW9uLCAzMCBKYW4gMjAyMyAxOTozMzowNiAtMDgw
MCBNaWNoYWVsIEtlbGxleSB3cm90ZToNCj4gPiA+ID4gQEAgLTk5MCw5ICs5ODcsNyBAQCBzdGF0
aWMgaW50IG5ldHZzY19kbWFfbWFwKHN0cnVjdCBodl9kZXZpY2UgKmh2X2RldiwNCj4gPiA+ID4g
IAkJCSAgc3RydWN0IGh2X25ldHZzY19wYWNrZXQgKnBhY2tldCwNCj4gPiA+ID4gIAkJCSAgc3Ry
dWN0IGh2X3BhZ2VfYnVmZmVyICpwYikNCj4gPiA+ID4gIHsNCj4gPiA+ID4gLQl1MzIgcGFnZV9j
b3VudCA9ICBwYWNrZXQtPmNwX3BhcnRpYWwgPw0KPiA+ID4gPiAtCQlwYWNrZXQtPnBhZ2VfYnVm
X2NudCAtIHBhY2tldC0+cm1zZ19wZ2NudCA6DQo+ID4gPiA+IC0JCXBhY2tldC0+cGFnZV9idWZf
Y250Ow0KPiA+ID4gPiArCXUzMiBwYWdlX2NvdW50ID0gcGFja2V0LT5wYWdlX2J1Zl9jbnQ7DQo+
ID4gPiA+ICAJZG1hX2FkZHJfdCBkbWE7DQo+ID4gPiA+ICAJaW50IGk7DQo+ID4gPg0KPiA+ID4g
U3VzcGljaW91c2x5LCB0aGUgY2FsbGVyIHN0aWxsIGRvZXM6DQo+ID4gPg0KPiA+ID4gICAgICAg
ICAgICAgICAgIGlmIChwYWNrZXQtPmNwX3BhcnRpYWwpDQo+ID4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICBwYiArPSBwYWNrZXQtPnJtc2dfcGdjbnQ7DQo+ID4gPg0KPiA+ID4gICAgICAgICAg
ICAgICAgIHJldCA9IG5ldHZzY19kbWFfbWFwKG5kZXZfY3R4LT5kZXZpY2VfY3R4LCBwYWNrZXQs
IHBiKTsNCj4gPiA+DQo+ID4gPiBTaG91bGRuJ3QgdGhhdCBpZiAoKSBwYiArPS4uLiBhbHNvIGdv
IGF3YXk/DQo+ID4NCj4gPiBObyAtLSBpdCdzIGNvcnJlY3QuDQo+ID4NCj4gPiBJbiBuZXR2c2Nf
c2VuZCgpLCBjcF9wYXJ0aWFsIGlzIHRlc3RlZCBhbmQgcGFja2V0LT5wYWdlX2J1Zl9jbnQgaXMN
Cj4gPiBhZGp1c3RlZC4gIEJ1dCB0aGUgcG9pbnRlciBpbnRvIHRoZSBwYWdlYnVmIGFycmF5IGlz
IG5vdCBhZGp1c3RlZCBpbg0KPiA+IG5ldHZzY19zZW5kKCkuICBJbnN0ZWFkIGl0IGlzIGFkanVz
dGVkIGhlcmUgaW4gbmV0dnNjX3NlbmRfcGt0KCksIHdoaWNoDQo+ID4gYnJpbmdzIGl0IGJhY2sg
aW4gc3luYyB3aXRoIHBhY2tldC0+cGFnZV9idWZfY250Lg0KPiANCj4gT2sNCj4gDQo+ID4gSSBk
b24ndCBrbm93IGlmIHRoZXJlJ3MgYSBnb29kIHJlYXNvbiBmb3IgdGhlIGFkanVzdG1lbnQgYmVp
bmcgc3BsaXQNCj4gPiBhY3Jvc3MgdHdvIGRpZmZlcmVudCBmdW5jdGlvbnMuICBJdCBkb2Vzbid0
IHNlZW0gbGlrZSB0aGUgbW9zdA0KPiA+IHN0cmFpZ2h0Zm9yd2FyZCBhcHByb2FjaC4gIEZyb20g
YSBxdWljayBnbGFuY2UgYXQgdGhlIGNvZGUgaXQgbG9va3MNCj4gPiBsaWtlIHRoaXMgYWRqdXN0
bWVudCB0byAncGInIGNvdWxkIG1vdmUgdG8gbmV0dnNjX3NlbmQoKSB0byBiZQ0KPiA+IHRvZ2V0
aGVyIHdpdGggdGhlIGFkanVzdG1lbnQgdG8gcGFja2V0LT5wYWdlX2J1Zl9jbnQsICBidXQgbWF5
YmUNCj4gPiB0aGVyZSdzIGEgcmVhc29uIGZvciB0aGUgc3BsaXQgdGhhdCBJJ20gbm90IGZhbWls
aWFyIHdpdGguDQo+ID4NCj4gPiBIYWl5YW5nIC0tIGFueSBpbnNpZ2h0Pw0KPiANCj4gV2hpbGUg
YXQgdGhhdCwgcGxlYXNlIGFsc28gaGF2ZSBhIGxvb2sgYXQgdGhlIGZvbGxvd2luZyBhbGxvY2F0
aW9uIGluDQo+IG5ldHZzY19kbWFfbWFwKCk6DQo+IA0KPiAJcGFja2V0LT5kbWFfcmFuZ2UgPSBr
Y2FsbG9jKHBhZ2VfY291bnQsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHNpemVvZigqcGFja2V0LT5kbWFfcmFuZ2UpLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBHRlBfS0VSTkVMKTsNCj4gDQo+IHdoaWNoIGxvb2tzIHdyb25nIC0gbmV0dnNj
X2RtYV9tYXAoKSBzaG91bGQgYmUgaW4gYXRvbWljIGNvbnRleHQuDQo+IA0KPiBBbnl3YXkgaXQn
cyBhIHRvcGljIHVucmVsYXRlZCBmcm9tIHRoaXMgcGF0Y2guIEkganVzdCBzdHVtYmxlZCB1cG9u
IGl0DQo+IHdoaWxlIHJldmlld2luZy4NCj4gDQoNClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBv
dXQuICBJJ3ZlIG1hZGUgYSBub3RlIHRvIGRvIGEgZml4Lg0KDQpNaWNoYWVsDQo=
