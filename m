Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B93050626A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345875AbiDSDAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiDSDA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:00:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CE2654C;
        Mon, 18 Apr 2022 19:57:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBUcl09OKnN6RjMNMhZb8izHsPkDLHbPoEBMg0pv4NddllAW7ARyEIi4VKvfSCTXQ1BMMvTT41uzkf62IlWG+Ztj2ROI2+OO3PWsq6APGzKS39TsDzv/KCsZF8t2M84t/cC0vTO9D7SrMwvoWj5HPrtbuJ1w3UbNpj8ZbDVJMsu1X0ORVRvRKlmjGndsA7BR/AadHHWielhDIN8LLKP2AfFJjhFNwAHwXcs/lsYloHWV5wWbXWl+0iG5J1T3qHg8ohU4Us0ceiVzjboc+bCiHS3oEYD7dyPhsDRNw3B0lmCZZbN8w5bZrnjqkhOZLBUiuxviBOgo5+peoFF7Dj27dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywIBjsTeW7N602NiIL36HzzAbRHftDJkgOIYDkj3bM4=;
 b=C5bxt4nZDfKKAcFpQ1RpTEF4V94Mf6h/HDs1tgwVcHUTwmDtYbl1EfxZHDQvPtnfnDD+GGhEflp5ZZIdCxeuVq3zYPGO6/2P8jA5g5UrIBQjNaJ9EaE9zHA6Ur7XDuRqB9ur7x9dFITv0KRdo4dWbbN+wek+fmjoxEHHB3kKnx8FlbVVo1AAmW6F31gKrFdtxzvLiKECrmwJHmNhczRkoR7Ohy+F0hM1xAqBLUUohu0zwgxZrYB08zTob9eXW1OoSeEtJZGo7glOjkfgskH+HOKQk7/6/CoTPOZZSn0hCE0DxDLWRGRRZ5BeMzZQdu4S57sbnEYG2eqAOf/N2BV8iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywIBjsTeW7N602NiIL36HzzAbRHftDJkgOIYDkj3bM4=;
 b=gg6eT6lmW9SIBPityw5pFBrn4Gu8UrrIL4zGOrVDRYX5nieOQ0teO5lq6m6FcaL3EjGso31kZuR0KK9VbSlZ/s1PjgbibVlQRIu3NvwsUpkyxYAHUcVi6UKHwsToYmxNzAMtSLWl5FhROVGWtVYPnlTTciMJ4GBbSIE6LiGlHTk=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by PH7PR13MB5527.namprd13.prod.outlook.com (2603:10b6:510:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Tue, 19 Apr
 2022 02:57:44 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::c0b:4fda:5713:9006%7]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 02:57:44 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>
Subject: Re: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Topic: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Index: AQHYU0T20WiaobmnKkCy/6DDEwmcKKz2i/CA
Date:   Tue, 19 Apr 2022 02:57:44 +0000
Message-ID: <a771c65353d0805fc5f028fa56691ee762d6843f.camel@hammerspace.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
         <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcbb1dda-00b6-438d-9654-08da21b06076
x-ms-traffictypediagnostic: PH7PR13MB5527:EE_
x-microsoft-antispam-prvs: <PH7PR13MB5527C8346E54E22C15055B3FB8F29@PH7PR13MB5527.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZkywK9PT3+PkNs/8pjMJr2Fsw86JziP7HgUU3spfqWRL5iOs97Dk7LffDEj2KxGeesJeAT2h+CTWtIX+tI7tRo7bcnTZGRupbm2W0scQ4dEFmURl0pufLTjFPLrBfBwIUiuFlM4p+LLpJ9ACFwA9mil3YHvxWk7GWRDgFbIrMFJ9L1A7b8hQSRSSl6RaWdv/2eDS3jBgBp2jqBzDAqY9ZzcP9zy4S/NWLAv2rAoa8UHHpjxQkxEhGdKoYpIm+GJjWcn8QTbzsMA/cv1UJ3jXm98mODlEPDI2Bo2UBF9ALiMYfBXD5Do/UyZCsRKCKo088+++L5ZSEyVzye27zgJt8qYE+z9yTs4wwXdBiJus81z3G0RFAtS2hS36GCd9qmEizjSpvHD5WycxElml2TJH1jtNYlm3aGdwM3YMCmyPTOQZBOsJvPsTNY9yEeNz4DUsNv7p+64LqNoiZNmE2bIUn+t1wAkTP/MC9MnfiGfPtPRR5CFcR2/kiqGv8f7HmrSjYU+W+tLXUbZ9TmbUrmIsbpKgZ1Q/uNskN/IN0Ory6WcHIOSJtk0hnOeeZ1W8KIeszRj6LJO8cRQF5KoTmZ6LGvMqXpL30KM4g6EDjiQaysgNjV9uktOFIBfaG6vV0rBoulpBC30C+te5Z0E3PJhTK+dKadGMs5FL2ZsnpNQWIkEUYFbw+g+nLJ3D5cAf+p7hTiYGV73sDA2YoawoI5I6iK5zxzR4qfAWr3hVRjA2+i9Ca5BRfBJfvDl7+qBM5Wvl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(5660300002)(122000001)(8936002)(71200400001)(508600001)(6486002)(86362001)(83380400001)(186003)(6512007)(2906002)(2616005)(26005)(6506007)(76116006)(4326008)(316002)(54906003)(66946007)(110136005)(66556008)(36756003)(66476007)(64756008)(66446008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3QxNGtWNnBiQys5TTVqZ3ppbVdTQjlnTlhwZnZYR0p2V1hRR1ZEaDVKOENS?=
 =?utf-8?B?VlJ4SVhwOXdVUEEyQll3OThnSHV4QUVhNFpPMTdPWGVXVjRjeUtlM1dQTGNM?=
 =?utf-8?B?em9pUDNRaUZZWU1nVU5vYVZRMnpjYU0wY0FreHM1VW1zRFpwRE13M1l4eWVX?=
 =?utf-8?B?SFhaMlREUFRwRXhWM3dTZGdEbVRrL3lsRzk1MGcyQlEvdjVpNkp1eVZZdnho?=
 =?utf-8?B?THlRU0hIVzNyVzdYbkFlTjhiYm9oQXZuNW1yQkNwanJjbFo5bHJjS0RocURj?=
 =?utf-8?B?VlNCZmozMys5R21senAvaUFFdW1EQjNWeHRpU0RsVDBCK2pmM2lXSHZTZTQx?=
 =?utf-8?B?S0xhYkNneThteDllTnVTUjhvWVpLbHhkVXZsekJVVXFmQlFPMEZPYTM1TFFl?=
 =?utf-8?B?VHBHcTB1alZ2akgxZUVNNkhvZDFCMmFaVW5jU3hScmQrOHN0azZxT0FUU0JG?=
 =?utf-8?B?WkN6bGx6MVY1WE15d05jZmtZTFZsWG9nUjVGSVVRYnpvZnJ3MVlwMkFnRW5X?=
 =?utf-8?B?WjNjbFRzY1lOTG94Ni9WSmpjSzN1TS9HSFdEN2x5bklQWnF0NlZHSnhQamJI?=
 =?utf-8?B?ZkdxRlJDb2FCVXBod3dBRGloWVVSMUZrb1B5bTF3dTVtY0JETnJJdG94RGVT?=
 =?utf-8?B?dnAyc3J4RDNuQ3Erb3FucC81UVdPS1k1aVFDY1gxUE01dkNCSlhwUStUdHFK?=
 =?utf-8?B?MHRQLzVISEVyLzVDNm1KOExEWmttMWdLTkJGb0s2R3RIMlEySHJRWGNGSmcr?=
 =?utf-8?B?a2cyeW5qTUJQQWhOdXhnQTU2MXhYUnhVTkVIRlFiMTluN3NwbFJPTjk3aFUy?=
 =?utf-8?B?Vzc5M1Y1YURkcVhMRXVULzBvV01sSE1IMzFHdDRMak9qdTg2TVZuem9LUWZV?=
 =?utf-8?B?S3l3OXVOOHYzeHVxQk4zMGlQblNzUk5tOUZkRllxRW1ZYzlCbVVKUDI1bm04?=
 =?utf-8?B?YXBMcWpGajJOOWdpOW9xOG5Fa0prRzdyWGpYVXVGNzFpNGVaWU55YXlsOExB?=
 =?utf-8?B?d0pnL2pqaXVTVkhIM2EwRGRQTm0xZzBMN1dha00wSWlXV2ZqdWRsUHNYamNT?=
 =?utf-8?B?WFhBT1R3TUJTMC81bGRhU043eHpveU1KaGhQWVNEZ0czRWFkS0FtMUhXand6?=
 =?utf-8?B?enVaV0hiRE1ycGUveWpGOGlUeWs3Y3JLSFVpNVNkSVhPV0xkWVJQb1NheWts?=
 =?utf-8?B?VFRORGJTMU16UnFrZEhhaURmNW5GVEozNlo5V045SWlhVWdBTHlkOTVOWUgv?=
 =?utf-8?B?T21Ec2FSWk40dHVIUmlnOGtKUHZ6blF4WUlCRnltK2kzRERnSy9ZRVdZenFu?=
 =?utf-8?B?Q202WG5MM3p1bFo5b0xzSzZuUFFmNE9RTSt4UVBNa0VOOFJRZkp5Y1IvM3lC?=
 =?utf-8?B?bDE1YjhOMjZOaERlUFRFOThrTmpDUmNyZlc3c1dZY1NYUzRVZEJCU3ZTZzNL?=
 =?utf-8?B?Y0NYb0FBMitPTVlTS0d4YzdDSWpyOUNMZDVEeE13UGNxYldVWHc3VzhDZWIx?=
 =?utf-8?B?Y2dtNURLL0pPSk1GTm1zOUVhN3A0TkhoUHhPMEQ0RHB3a0o3bkJqRnh3cmtK?=
 =?utf-8?B?S2JMa2xnQ2xNQXlzZmVXWUVuR014ZUZqM0k3MlNSa2hkbitYN2lueWVMVDVj?=
 =?utf-8?B?Q2g5N1ZyMExPMUFGWUErd1lwSkw1eFgxSUYrUkpDY0c3aC9NdlhjYUJ4Y1FV?=
 =?utf-8?B?K0tCeTBQYTVHVEZHTWt0ZTVuQUtlNEtvNmE3Szdkd1Mybmk2NWorUmgySyt2?=
 =?utf-8?B?VWNzOGY4U290RlIvZUl1TlE0blBKV3ZtWWp5UGFTc3dveXJ1M0JKVVFlY003?=
 =?utf-8?B?ZlNFbVpMUGIzb2VxS3V2dm1LUkZzck1VRmdObC9zOGxmY0EwbytVbnNlYm1D?=
 =?utf-8?B?bGFLMTA1NTdCUHc4bGVZdzg3RkdHOU16WW5VaXBoRG90WWh2azJPK1NsTWVi?=
 =?utf-8?B?RFZYNHhvSHpPK09HOUNneUFFbUxtOG9FeDZSS29CcnY5eDEyYU1DUkcxd3U0?=
 =?utf-8?B?UWU0dWdUNlJTaG42TGJsNW9hOVRPUEJ0aWNVNC9GQlQvTkY3NnY3M1dsd2dv?=
 =?utf-8?B?RTB5U0hDdFUzZkJxb0tNZXo1cFFydjRiTzFMYUV1S2xFZW1Gc3ZTV210eEJh?=
 =?utf-8?B?aWZyYng2M2ZmUzg1T3p0SFRtbGdKbTBPRC8yc3Y1Z2U0NVV5QWZqWm1zai9X?=
 =?utf-8?B?Y1VteC84OVI3aFNLT3B0RWlBamRFVENseFNOeFlVcXVReGQybllrNlhBVjg3?=
 =?utf-8?B?aExwK3RNakRQWnJDUnVtSVVjK0h0WnRqQXptWWhGSlcreXJsVDJ6emdMVS8r?=
 =?utf-8?B?Mm1aLzVaVmVlVG5YNHhBaTlsd3lJVlh2NTV2VGZtNVhYaUFQOG1JcFp0azNV?=
 =?utf-8?Q?0VUIQ1lefF6G/NGQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <150CD6D5B8E32444B8E1DEE799A02689@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbb1dda-00b6-438d-9654-08da21b06076
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 02:57:44.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LldBuGp6l/lxZNpbsFvdt/kVjPKVNMK1+ebWk1lTSTAnZlGvQlS4zkLzfrlDsGthST6nFHwkcRhFUdUUdjob8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5527
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA0LTE4IGF0IDEyOjUyIC0wNDAwLCBDaHVjayBMZXZlciB3cm90ZToKPiBJ
bnRyb2R1Y2UgYSBtZWNoYW5pc20gdG8gY2F1c2UgeHBydF90cmFuc21pdCgpIHRvIGJyZWFrIG91
dCBvZiBpdHMKPiBzZW5kaW5nIGxvb3AgYXQgYSBzcGVjaWZpYyBycGNfcnFzdCwgcmF0aGVyIHRo
YW4gZHJhaW5pbmcgdGhlIHdob2xlCj4gdHJhbnNtaXQgcXVldWUuCj4gCj4gVGhpcyBlbmFibGVz
IHRoZSBjbGllbnQgdG8gc2VuZCBqdXN0IGFuIFJQQyBUTFMgcHJvYmUgYW5kIHRoZW4gd2FpdAo+
IGZvciB0aGUgcmVzcG9uc2UgYmVmb3JlIHByb2NlZWRpbmcgd2l0aCB0aGUgcmVzdCBvZiB0aGUg
cXVldWUuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNs
ZS5jb20+Cj4gLS0tCj4gwqBpbmNsdWRlL2xpbnV4L3N1bnJwYy9zY2hlZC5owqAgfMKgwqDCoCAy
ICsrCj4gwqBpbmNsdWRlL3RyYWNlL2V2ZW50cy9zdW5ycGMuaCB8wqDCoMKgIDEgKwo+IMKgbmV0
L3N1bnJwYy94cHJ0LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAyICsrCj4gwqAz
IGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3N1bnJwYy9zY2hlZC5oCj4gYi9pbmNsdWRlL2xpbnV4L3N1bnJwYy9zY2hlZC5oCj4g
aW5kZXggNTk5MTMzZmIzYzYzLi5mOGMwOTYzOGZhNjkgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS9s
aW51eC9zdW5ycGMvc2NoZWQuaAo+ICsrKyBiL2luY2x1ZGUvbGludXgvc3VucnBjL3NjaGVkLmgK
PiBAQCAtMTI1LDYgKzEyNSw3IEBAIHN0cnVjdCBycGNfdGFza19zZXR1cCB7Cj4gwqAjZGVmaW5l
IFJQQ19UQVNLX1RMU0NSRUTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDAwMDAwMDA4
wqDCoMKgwqDCoMKgLyogVXNlCj4gQVVUSF9UTFMgY3JlZGVudGlhbCAqLwo+IMKgI2RlZmluZSBS
UENfVEFTS19OVUxMQ1JFRFPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4MDAwMDAwMTDCoMKg
wqDCoMKgwqAvKiBVc2UKPiBBVVRIX05VTEwgY3JlZGVudGlhbCAqLwo+IMKgI2RlZmluZSBSUENf
Q0FMTF9NQUpPUlNFRU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDB4MDAwMDAwMjDCoMKgwqDC
oMKgwqAvKiBtYWpvcgo+IHRpbWVvdXQgc2VlbiAqLwo+ICsjZGVmaW5lIFJQQ19UQVNLX0NPUkvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDAwMDAwMDQwwqDCoMKgwqDCoMKg
LyogY29yayB0aGUKPiB4bWl0IHF1ZXVlICovCj4gwqAjZGVmaW5lIFJQQ19UQVNLX0RZTkFNSUPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDAwMDAwMDgwwqDCoMKgwqDCoMKgLyogdGFz
ayB3YXMKPiBrbWFsbG9jJ2VkICovCj4gwqAjZGVmaW5lwqDCoMKgwqDCoMKgwqDCoFJQQ19UQVNL
X05PX1JPVU5EX1JPQklOwqDCoMKgwqDCoMKgwqDCoMKgMHgwMDAwMDEwMMKgwqDCoMKgwqDCoC8q
Cj4gc2VuZCByZXF1ZXN0cyBvbiAibWFpbiIgeHBydCAqLwo+IMKgI2RlZmluZSBSUENfVEFTS19T
T0ZUwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMHgwMDAwMDIwMMKgwqDCoMKg
wqDCoC8qIFVzZSBzb2Z0Cj4gdGltZW91dHMgKi8KPiBAQCAtMTM3LDYgKzEzOCw3IEBAIHN0cnVj
dCBycGNfdGFza19zZXR1cCB7Cj4gwqAKPiDCoCNkZWZpbmUgUlBDX0lTX0FTWU5DKHQpwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoKHQpLT50a19mbGFncyAmCj4gUlBDX1RBU0tfQVNZ
TkMpCj4gwqAjZGVmaW5lIFJQQ19JU19TV0FQUEVSKHQpwqDCoMKgwqDCoMKgKCh0KS0+dGtfZmxh
Z3MgJiBSUENfVEFTS19TV0FQUEVSKQo+ICsjZGVmaW5lIFJQQ19JU19DT1JLKHQpwqDCoMKgwqDC
oMKgwqDCoMKgKCh0KS0+dGtfZmxhZ3MgJiBSUENfVEFTS19DT1JLKQo+IMKgI2RlZmluZSBSUENf
SVNfU09GVCh0KcKgwqDCoMKgwqDCoMKgwqDCoCgodCktPnRrX2ZsYWdzICYKPiAoUlBDX1RBU0tf
U09GVHxSUENfVEFTS19USU1FT1VUKSkKPiDCoCNkZWZpbmUgUlBDX0lTX1NPRlRDT05OKHQpwqDC
oMKgwqDCoCgodCktPnRrX2ZsYWdzICYgUlBDX1RBU0tfU09GVENPTk4pCj4gwqAjZGVmaW5lIFJQ
Q19XQVNfU0VOVCh0KcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKCh0KS0+dGtfZmxh
Z3MgJgo+IFJQQ19UQVNLX1NFTlQpCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZXZlbnRz
L3N1bnJwYy5oCj4gYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9zdW5ycGMuaAo+IGluZGV4IDgxMTE4
N2M0N2ViYi4uZThkNmFkZmYxYTUwIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRz
L3N1bnJwYy5oCj4gKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvc3VucnBjLmgKPiBAQCAtMzEy
LDYgKzMxMiw3IEBAIFRSQUNFX0VWRU5UKHJwY19yZXF1ZXN0LAo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgeyBSUENfVEFTS19UTFNDUkVELCAiVExTQ1JFRCIKPiB9LMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHsgUlBDX1RBU0tfTlVMTENSRURTLCAiTlVMTENSRURTIgo+IH0s
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHsgUlBDX0NBTExfTUFKT1JTRUVOLCAiTUFKT1JTRUVOIgo+IH0s
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgeyBSUENfVEFTS19DT1JLLCAiQ09SSyIKPiB9LMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHsgUlBDX1RBU0tfRFlOQU1JQywgIkRZTkFNSUMi
Cj4gfSzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB7IFJQQ19UQVNLX05PX1JPVU5EX1JPQklO
LCAiTk9fUk9VTkRfUk9CSU4iCj4gfSzCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHsgUlBDX1RBU0tfU09GVCwgIlNPRlQiCj4gfSzCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4g
ZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMveHBydC5jIGIvbmV0L3N1bnJwYy94cHJ0LmMKPiBpbmRl
eCA4NmQ2MmNmZmJhMGQuLjRiMzAzYjk0NWI1MSAxMDA2NDQKPiAtLS0gYS9uZXQvc3VucnBjL3hw
cnQuYwo+ICsrKyBiL25ldC9zdW5ycGMveHBydC5jCj4gQEAgLTE2MjIsNiArMTYyMiw4IEBAIHhw
cnRfdHJhbnNtaXQoc3RydWN0IHJwY190YXNrICp0YXNrKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgKHhwcnRfcmVxdWVzdF9kYXRhX3JlY2VpdmVkKHRhc2spICYmCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIXRlc3RfYml0KFJQQ19UQVNLX05F
RURfWE1JVCwgJnRhc2stCj4gPnRrX3J1bnN0YXRlKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKFJQQ19JU19DT1JLKHRhc2spKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBjb25kX3Jlc2NoZWRfbG9jaygmeHBydC0+cXVldWVfbG9jayk7Cj4gwqDCoMKgwqDC
oMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgc3Bpbl91bmxvY2soJnhwcnQtPnF1ZXVlX2xvY2sp
Owo+IAo+IAoKVGhpcyBpcyBlbnRpcmVseSB0aGUgd3JvbmcgcGxhY2UgZm9yIHRoaXMga2luZCBv
ZiBjb250cm9sIG1lY2hhbmlzbS4KClRMUyB2cyBub3QtVExTIG5lZWRzIHRvIGJlIGRlY2lkZWQg
dXAgZnJvbnQgd2hlbiB3ZSBpbml0aWFsaXNlIHRoZQp0cmFuc3BvcnQgKGkuZS4gYXQgbW91bnQg
dGltZSBvciB3aGVuZXZlciB0aGUgcE5GUyBjaGFubmVscyBhcmUgc2V0CnVwKS4gT3RoZXJ3aXNl
LCB3ZSdyZSB2dWxuZXJhYmxlIHRvIGRvd25ncmFkZSBhdHRhY2tzLgoKT25jZSB3ZSd2ZSBkZWNp
ZGVkIHRoYXQgVExTIGlzIHRoZSByaWdodCB0aGluZyB0byBkbywgdGhlbiB3ZSBzaG91bGRuJ3QK
ZGVjbGFyZSB0byB0aGUgUlBDIGxheWVyIHRoYXQgdGhlIFRMUy1lbmFibGVkIHRyYW5zcG9ydCBp
cyBjb25uZWN0ZWQKdW50aWwgdGhlIHVuZGVybHlpbmcgdHJhbnNwb3J0IGNvbm5lY3Rpb24gaXMg
ZXN0YWJsaXNoZWQsIGFuZCB0aGUgVExTCmhhbmRzaGFrZSBpcyBkb25lLgoKLS0gClRyb25kIE15
a2xlYnVzdApMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlCnRyb25kLm15
a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20KCgo=
