Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339A5B3640
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiIILYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIILYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:24:02 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20058.outbound.protection.outlook.com [40.107.2.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BF75FC5
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 04:23:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNZ0CqqzTX/U+6eiU1sRP5EglBTC3NrdIPllCPpYT22mGa449gAWwUr7G5bMNJmOUOj7Ipw9LPvH4vA7MU+V/YMk5m9Sia7iop+fEwtKOSy053V/svtcUMPOU1EsxVD2IMEC1BIAh5XE8ohOMOZbn9LwAc8jNCVjW8QZxL4Qc6cMeFYYbBrrZl+yjV8k+btU1a0r0VCOVuQWlvfVd51PEOrIr4zsAy8q3SJebktghaq3aO5jAfD+pehMf30CagE4v8GGQ4onZsPyusswCh57zvyp9rUh/R6lek4s5x0jXJ5iOyXqGA2Iq/i6POL5RNwmxmMXR7OLRLopLCFCh1fGtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6dVuxSH8bD8BDPwri1FZgrkKtMku9yYeY/mLYaYgSA=;
 b=CXTI2vwEm5vBX7aIqtN57z4jL9GlA+XChX2y05Q9eerPOx+06p5QGHwdbkgDmWW+cd8JhMxlVC5iJ/q7RrgI5pKa0G9nKQeNu448g63H6CdXDnqg8P32sWFbAP9XWZRLq4nIppqSGsZhyt1yBYHPCA+9Tz+QQi6ztO+fTeFTLDGlft6V/ILCrgTruAOBsl87NkKVpMnsqUx3dtqwSW+G9FWfgxVuGoLV+a2hoF5MFFcQX/hx7P/eAxJGkaVV4qFhqL0nvCBguEiJlLNMHonru9E8ynWFLv2lyk03GcaGWnOxv8Sti2N065MiHmPFEF6q2d9LYjgXBKTUimHNBMxasA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6dVuxSH8bD8BDPwri1FZgrkKtMku9yYeY/mLYaYgSA=;
 b=kO61wnT468KNAtuZ0PKXQU4L9adqH4yxpMmelkfjcDB9bEMik2wdd6eZpnp51+SzVA4f4hTyWNJ1fpb1Y63mOZTvAkdUh45zP1iBCnpXBZsqE0b4/oo1vQV+5dpOVlCBnJVZMlYVCeE6TR7YPntzc8g3AY2DWvfTaFTQGAvCcVs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4040.eurprd04.prod.outlook.com (2603:10a6:209:50::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Fri, 9 Sep
 2022 11:23:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 11:23:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Topic: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Index: AQHYwJCiMb7bHcv8sUSdQE+5fVlfzq3Sia2AgAAUKYCAAAPqgIAAJryAgAAOdoCAAAetgIACo56AgAAVi4CAAAS7gIAAHYwAgADqWQCAAFe6gA==
Date:   Fri, 9 Sep 2022 11:23:50 +0000
Message-ID: <20220909112349.gyrqjojo6f4dhzdt@skbuf>
References: <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220908125117.5hupge4r7nscxggs@skbuf>
 <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
 <20220908072519.5ceb22f8@hermes.local>
 <20220908161104.rcgl3k465ork5vwv@skbuf> <YxrYrhSRayY03ahF@d3>
In-Reply-To: <YxrYrhSRayY03ahF@d3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbde65b3-ba2e-4ad7-231a-08da9255c541
x-ms-traffictypediagnostic: AM6PR04MB4040:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AQJlA+dbELrIYVLxObmOjVkzEPU2NWfGzvww2RvOy2Vuhsfwkv5GIMrEnx5mm1qRq7X0KJY8h1jgY2TEQJs2MSI4Uw3Eba3jhs3UYu14hX9ajgCBVtpMfeeUrEeQ/y7mCpJtcgNerb3Y4xbrLiT5HBMFryD3XJOmzLcH03aUB1B+idXSU8aFCp+xyLsaiCtAwWygodOGse63sCic6IZJREzVFM4YiFbsE5vhP6jHs3YgMxAYP9xTNS0/ZBnGcf5SuB+gXsGHp9HTF/ORXc7MmLoKUlvfvNNR+YkTg99PcjeSidK1JVTy0ROjkzYRc2G0vZzorwhYOmacbzheHqGMv416ecx6oSDCmLAUmpUYBjZxjyl8fB+10MHYNskF2CBBbuWtxVGYV6XmaoMQ/dsDVHnNPr/BaFABNDiujXary1Wfs2/SUOJO6xlNwBAC3sJvuF1clViMd+u0MPQpRvCmpQrK3iOWYN/AguW/sFMZsfGANWrZuh8uGktFoclvJ6rYDFEqnHryEdM1bKvu8BUN1JXwUSP29mel5ec8MMI+HTfAu/v8pLBa0HAmyAeWkdy1c3U/Ajh1Io9qlG9ZgxbCVSeurGCnBVS92vZp5jzquJgUlAcfoZ0C2cl41iKA5Kn9gYJazG6lASFnpOF+j7hYbbQUVn2fdXwYoLKZWWt3l5alPqWmsa7VU8mieG50J5xi+nIqGvW/CnqvvHd7Uqv/nOdWv+L0zX+ewCet52V1FR1+tLbsVEYLqSJHuiC7pGbFowYdpXtI/zgEiWR3AcOgJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(66556008)(186003)(316002)(1076003)(8676002)(64756008)(38100700002)(66946007)(86362001)(76116006)(6916009)(5660300002)(91956017)(66446008)(44832011)(54906003)(26005)(66476007)(9686003)(6512007)(4326008)(33716001)(38070700005)(2906002)(71200400001)(41300700001)(478600001)(6486002)(6506007)(8936002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFJKTGdvemJsb2tHenVrVWlYR2RCbUtzUjBqYUI3cHl6TE4zdnQyMTlqNTE1?=
 =?utf-8?B?Z25GcUtTN250VkVmR2xsTXBQZ3lRT0tRYjBmTGx2NXJEYUVXbGVtUnYvSVZJ?=
 =?utf-8?B?em9YbjdJWktaeTdBYmlqQWlKMU5mVjJWdyt6ZjVaeUhybFZEQ3hRR3BkdnJ5?=
 =?utf-8?B?T3Z6cUNxY291aTM4amt6Q1ZvRkt2b0d0K0U3aDhxNHJPUC81YTJEaTA4NWhh?=
 =?utf-8?B?U016OEhncXZUVDlnUkpPamNHT2tPMkVFTENCS01Id3MrdWhKQkVIN2xPdjRZ?=
 =?utf-8?B?R0lZbTNmNHNPRXY5SGNHYmhsMlVabHNkUzBPN0pKV2cyRWcvRFhmMml2anF4?=
 =?utf-8?B?aURFdFRRSWp6SE9adW4vTXpwWlpBQ281TVNWQTJWVHZ6dWlsaFVuWFhVVUt6?=
 =?utf-8?B?U2xyVHR1UGIwczVmWS9jWGx0VEV5TjdRdGM5cXhsYnRST1doOFRNNHQzU2xx?=
 =?utf-8?B?RUsra3I2WDkweVZFbUxDUFVxdG9QTVd5MEhzcFFUV1NsRUp4b1Vxdi9GdnEy?=
 =?utf-8?B?czhFSWxhL1JONjVxRDZhV2k5K3Fnc1VZQm5jT1d2M0l5UTBLVGUrVEppekY2?=
 =?utf-8?B?Rjk0RzZBUDVvSUprWVEvMXFQaDliSitWZWp5TVpZNWlIb3N2aFZHdTQvMmRS?=
 =?utf-8?B?ODNrRmlneEdhZUxsVWNuemo5Y3Fwb2E4R1pjYzVBTXJhVFJjSTREZFpPQlk2?=
 =?utf-8?B?WGZUbTJWRGNjTjRMRlBaalk5QjkvT0hhNCtEK21wN2MyOVBQeGI5L0xxVTRQ?=
 =?utf-8?B?cldwYnJMV28wSmQwT1FRREVRSERUeEhYaHNWdnE3SlVzMUM4TG1YVHhaYkFN?=
 =?utf-8?B?NUM4S0g3eVJsN1pkVWVkaHpiTy9Md1lqTnVxY2Z0Ty83LzNrbXg2VFpyK1Ew?=
 =?utf-8?B?RCtxUFZYN3hqN09HcHFxNXNPMzgraHpVZEt1MWhURy80MmQ2NUp6UEZpeXF2?=
 =?utf-8?B?ZDZoNWxDNzN5djY3QVJNYm84NWFaMFhlUkpOdnpqQ2xWNWIxVHQxWnZNdzgr?=
 =?utf-8?B?Y2YvVzdOVHhCSXA2M2w4UC9ObW5uUmszYUd1OXNlbjB6R0tVa0h0MmhTYWll?=
 =?utf-8?B?cytBTHJMS2VzaTFrdlFPNFcxTHVYekJyMHNhazdYY2lQRzNaTzRXd0FzMmdy?=
 =?utf-8?B?QVVDbDUrUmFyaDBteSs0VG5pR2l2R2htSXZSVFFuNlMwSnErQ2pnaFB5TGRJ?=
 =?utf-8?B?RTNJc1BLZzVNNldyOGI2Ym9YVU1wS2xjUlJuUVBBUUJLSUw0QnZJVWhMYVZ3?=
 =?utf-8?B?bmdJYXRyTGxJMVR3WlplUHdkMlFWZzIvTWl4eEVyQjhZdzdySXVNMFhOdzIx?=
 =?utf-8?B?QmxoVXhKeEVybmVJWWg3ODlkUmN3UlhmbmNnTnM5ZnBRTDNCQUpCMlN3VlFN?=
 =?utf-8?B?eXRDd0JDMEFZSHVPQkdaclBFQnl1cm40ajRGc3Y2YTMxK25IWlE5ZGM3dUoz?=
 =?utf-8?B?aE5VSGJBWUFEb25kMTVXMkpwcS85b0tQQnQ4WXp2RnErSlBMb2wrdHVMbm1E?=
 =?utf-8?B?S05Mdnc1enpwMSsyMnVONUtZOUVPV0Q1VzlFOFh2em1UbklucXEzK1lnclFV?=
 =?utf-8?B?SHV0SG5zOGMxZURnRkJSNEdabFFvdXZpUlNvdmlQNlhBK0Y3WlBkL1V0N291?=
 =?utf-8?B?MnpGanVpZ2JOWnRBS1NZN3NyeDIySUtuWUhOYW9lNGVUSytKanBQdnBXaVd4?=
 =?utf-8?B?bExYS1FJRElWTkQyYlB2eVZzZGU1eUlCQXo1T1NXbnVSOFQvam9FdW43eXZH?=
 =?utf-8?B?S29uTlF5cGdqMkY1SEhvR3dsWnR4S0VuQk5ZbFN6bWF4NFYyMzg4SEhGZzlH?=
 =?utf-8?B?QkI3T2RiUWFlN0ljQ25ZU2xGditTVUNvcEZ3RWRKM0JlUkJXdkpTMkUxUG5r?=
 =?utf-8?B?YTVyRHNpOWlQcUhvblNPU2YvejlNQjBoWTJnK01SSGg0RDVOOWxVQlh5L1lx?=
 =?utf-8?B?S21vM3VPdmpMU2tFWVI4cm5qTlpKU3B1MkJMRU5WbkcxbGgwNUJuVzNFbG9Z?=
 =?utf-8?B?QjNmejVaQy9kYTFRdjUzWExVOHVoNXBXOUpNd2NIeGU0UDg0RzFCQnZHMk9h?=
 =?utf-8?B?YXpGYjlkcmxKMlUveEYrTjNSYlNZTytEMHd6SDJUNk5UMjVNb3RLRjVjZkpQ?=
 =?utf-8?B?NWVXZ3ZUNjdUM3RJTTZoMGVTVGV4bW1JcmRKVXhNSFp4aEpKb2o0S1UrVm5x?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E0C5F4238BC634CB5198173DC6A6741@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbde65b3-ba2e-4ad7-231a-08da9255c541
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 11:23:50.5292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7X3wtoYF90CwgYmqS2hpmBA19iJVLk+SIIGfdX8dBbU1bzB1KMGHV43igmyZvAyRrzWPYDm4kj7q2Y1Ez0UdSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBTZXAgMDksIDIwMjIgYXQgMDM6MDk6NTBQTSArMDkwMCwgQmVuamFtaW4gUG9pcmll
ciB3cm90ZToNCj4gPiBTbyBhcmUgd2Ugb3IgYXJlIHdlIG5vdCBpbiB0aGUgY2xlYXIgd2l0aCBJ
RkxBX0RTQV9NQVNURVIgYW5kDQo+ID4gImlwIGxpbmsgc2V0IC4uLiB0eXBlIGRzYSBtYXN0ZXIg
Li4uIj8gV2hhdCBkb2VzIGJlaW5nIGluIHRoZSBjbGVhciBldmVuDQo+ID4gbWVhbiB0ZWNobmlj
YWxseSwgYW5kIHdoZXJlIGNhbiBJIGZpbmQgbW9yZSBkZXRhaWxzIGFib3V0IHRoZSBwb2xpY3kN
Cj4gPiB3aGljaCB5b3UganVzdCBtZW50aW9uZWQ/IExpa2UgaXMgaXQgb3B0aW9uYWwgb3IgbWFu
ZGF0b3J5LCB3YXMgdGhlcmUNCj4gPiBhbnkgcHVibGljIGRlYmF0ZSBzdXJyb3VuZGluZyB0aGUg
bW90aXZhdGlvbiBmb3IgZmxhZ2dpbmcgc29tZSB3b3JkcywNCj4gPiBob3cgaXMgaXQgZW5mb3Jj
ZWQsIGFyZSB0aGVyZSBvZmZpY2lhbCBleGNlcHRpb25zLCBldGM/DQo+IA0KPiBUaGVyZSBhcmUg
bW9yZSBkZXRhaWxzIGluDQo+IERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2Rpbmctc3R5bGUucnN0
LCBlbmQgb2Yg4Lii4LiHNC4NCg0KVGhhbmtzIGZvciB0aGUgcG9pbnRlci4gU28gaXQgc2F5cyB0
aGF0IGlmIERTQSB3YXMgaW50cm9kdWNlZCBpbiAyMDIwIG9yDQpsYXRlciwgYSBtYXN0ZXIgc2hv
dWxkIGhhdmUgcHJvYmFibHkgYmVlbiBuYW1lZCBhIGhvc3QgY29udHJvbGxlciBvcg0Kc29tZXRo
aW5nIG9mIHRoYXQga2luZC4gV2hpY2ggaXMgcHJvYmFibHkgcmVhc29uYWJsZSBpbiB0aGlzIGNv
bnRleHQuDQpCdXQgSSBkb24ndCBoYXZlIHRoZSB0aW1lIGFuZCBlbmVyZ3kgYXQgbXkgZGlzcG9z
YWwgdG8gdHJhbnNpdGlvbiBEU0EgdG8NCmFuIGluY2x1c2l2ZSBuYW1pbmcgY29udmVudGlvbiwg
YXQgbGVhc3Qgbm90IGluIGEgd2F5IHRoYXQgd291bGRuJ3QgdGhlbg0KYmUgZGV0cmltZW50aWFs
L2NvbmZ1c2luZyBpbiB0aGUgc2hvcnQgdGVybSB0byB0aGUgdXNlciBiYXNlLiBTbyBJJ2xsDQpr
ZWVwIHVzaW5nIElGTEFfRFNBX01BU1RFUiwgbXkgcmVhZGluZyBvZiBpdCBpcyB0aGF0IGl0J3Mg
b2su
