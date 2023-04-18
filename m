Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F89B6E5CA2
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjDRIzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjDRIyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:54:50 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2136.outbound.protection.outlook.com [40.107.241.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6759D0;
        Tue, 18 Apr 2023 01:54:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4WfWaJj91s/uXr3qkKBM6ygaFrIBx8Z0UHbMTamjonvecSMX6WW2EX/dcCXNEvgLSPB0A1m7AiH20PVFeWOYAI3bgiMck41R9VNePBrBZO1IB+Lw6Inq1OsS1WnR8su0+QcGIrWDTpGSCDH5ENesnHMBvOvgFaUvfZ/sXtXNDnl7lQkYE5K0PtwRuw3ryJ81TcnpJsUAq4sTuiKqeGr8rEvybsAEsfJWyHd0snxxHPTkAqPkFRZ/6TuWaIn7nhNyT5d3jnEEZTQOEFEXfQYrl8EaMO1MavSr9sRye1KtLVO55Wmk5r7wbjvcVqWw5EsTI3ben9NNTMXUzOEIeSZ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2aelDOms/xiDAk6dMDIdAa2kyeoj8uNtSVFCXJpXCw=;
 b=N1vH+ricKkh82KXoe71WtpMsb0MysjPWHtZrQ0e/KHTX2tu23XTGO4S8/SFrRBtM7jr1Jl6gHjhhx83SwNRPphM4exwCXmV9IKjIlxfYrEUJG0YX5iby83AdnnCJzPIlJGnAnkDh58dJBjj+s8YJDjvryE5QjkAlzGkj09xmC+5mYgqJwGHw1zYqP4ANiqEOyjvGDTsXQq0MLJlRMdBJXD0hMfvYtJt9HPlsuUiySGVuBVKx/8Qkzq9ZqT3oWN74TetVzPZAbWF9bFzMddFc64qs5H8sn+aRk+mOwwrOvG9XCsotvG1PWgofQRJk8wx500bYSMmer4GpNF7FR+8e4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2aelDOms/xiDAk6dMDIdAa2kyeoj8uNtSVFCXJpXCw=;
 b=ArA1D9BxlEjmHnfZwE2FZZd3OSQYMoKFa93N6PPBTdTHe/jyMEdCB9U+S30NPSYtJXBECf+a+JVwvlHZHp2Yp/9pESBdQLxdNM1wk8cjn3OhPr24/VDW5bzO8TCXjqrg5FuxrC8QrUBMJV+MeKfHw6+wjmThGnuHNZXzv7dfJeI=
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:26::11) by VI1PR01MB6621.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:18a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:54:42 +0000
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e]) by
 AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 08:54:41 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 1/3] net: mvpp2: tai: add refcount for ptp worker
Thread-Topic: [PATCH v2 1/3] net: mvpp2: tai: add refcount for ptp worker
Thread-Index: AQHZcU8rbrHts6rYOkmEFLMZ/VmImK8wOzkAgACI9IA=
Date:   Tue, 18 Apr 2023 08:54:41 +0000
Message-ID: <3cfbdcc1836d4569daf976221914464c305823d7.camel@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
         <20230417170741.1714310-2-shmuel.h@siklu.com>
         <cab62ad6-c495-48f3-91c8-5c27c43582ba@lunn.ch>
In-Reply-To: <cab62ad6-c495-48f3-91c8-5c27c43582ba@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR0102MB3106:EE_|VI1PR01MB6621:EE_
x-ms-office365-filtering-correlation-id: be29ad3a-10b0-45f3-bed9-08db3fea8cbf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nu+VmpV6I0RralJvF17bHaRbouqV/lWzmkg5Li7yHAWfmQXMvDUFH5SYTwHCPQcZBKbDv0FPwx6II6L3tMiLLyHaYPRjvYzKz61L9oS2HAX34xgpvsEakTvy2aJo/p/Mj7Y2QuVcK4HOx9/8a+FMyXCMYa7AK+opuDZrxgMsrMNYLCPqU9X9F03wqPXIXQQAkzBBOMWnHpomHE5/v3HzixAAZmxGRxbJmSM+197iCHc+r2gWvUWBugQ7Ysf/e3/iFeDaocjAtvrimU4X/U58a17gmj62rKm1SLaBYE4Xa30OTMTytwLctlPi1+cdgGJ9/p644CIk7XIe8kACwr582rRk8fanVaMHT/yLAMEnBr5ibcWZGcfqjJhz/FaCrpovXpa5P1h5kB/CLaduv+lVV5cujmVDl0iqHP0D9RoL0gxdI9/StyTne6jhboG6CD3cRk4dX7XxEwvvEHWGyPj4r27hdl3c5UqzFUs7GLvSYhwfC+9Rep50UOgFp/020R65sjwzFVh8oviYyeiN85k41PZ6u72xuyWW+n786X6MDYnYmlEEtoL/vNq6QhV5y3Pl0qJh5h2o5L8bbDJN2IWie+Z/mW+b+7SHb4fg6/MBgTAXgibYb4GqZrFHaUSD7o1T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0102MB3106.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199021)(2616005)(54906003)(6512007)(6506007)(26005)(478600001)(76116006)(66946007)(66476007)(66556008)(66446008)(64756008)(316002)(83380400001)(6486002)(186003)(71200400001)(91956017)(6916009)(4326008)(8676002)(8936002)(41300700001)(2906002)(5660300002)(122000001)(7416002)(38070700005)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qkw0dUoyZkw3Q2FzWVVvTGtaMHQxL1psOGVnS0RXVjh4cUxlSHZlVmZhcDZH?=
 =?utf-8?B?UFloUUduYXpFVUN2V2pLQ0lMMFJlSTkyeGJBaTVXZFNaYjJhZHVlSEJ2NEFG?=
 =?utf-8?B?U3B5UCsrcU9yK3A3a2pTNmtXOXBrUkY5ek4vVksreFJlSXMzT1ZNZlJBdWVy?=
 =?utf-8?B?M2Z4b29uKzFOUnQ2aGNNYXJQZC9DTTIzbW1GQTdLcFFYUkZhT25kSS9YWVNI?=
 =?utf-8?B?VW5Say9HSTJrWXlJdWdTaTRoNUZyaHJ2bjBBWFp3bkdPYjlJSUdKUjFzQ3Yr?=
 =?utf-8?B?ZEZoUGpNRnBFdVg1M2c2NnV0TVpsWWhZdldIVFdjR2tnRTdEeGZVV1RYK1V6?=
 =?utf-8?B?aG5sOEVsMnpZeERxZitFcWpPanR4MEFJcUdLSlMrRzd3UWdDVmhzWDF6NFZX?=
 =?utf-8?B?Tk94Lyt3T0dPY3NYKzdzN2pWS1M4ZlRBNmdUQmFvRkZtS2g3dUpuQk9mWDh1?=
 =?utf-8?B?N2tFRHFMR1FxcGtiMHI3OHM0a1lraXcwbXo3ZFd5Q3VnTGR3MW5sYVhHRDFY?=
 =?utf-8?B?Zkxick9velF6dE1iSXhLVGQ5VUxjWGNpU2VhNmQ0aDlSdzVqcjhRdGI4UUx6?=
 =?utf-8?B?VFkwR0VXRzBaWkJ6bSswbTZkdUdzb1Nxc3duWHRwSVVscUVmcFRmMEhPT0RD?=
 =?utf-8?B?NzFlWjVoaUY5T25GVHNjOVFDU1FtZFl0MXdLQlI5MjFYOVF2WlVQdG9RSk5C?=
 =?utf-8?B?c0QrZDFwMzdndEdiY0l5UjVnSVhYdnVJRVJCa3JtdEFZNW0yUTZvUEVyVzI1?=
 =?utf-8?B?eldUVHJlU1hyeWpBelFxaHZENkhxL2h2VTVic0xvaHFZS3FONk56MDVDNEpw?=
 =?utf-8?B?cFE1WFlhV0N6T2VaQ2xKSkY5OThvL04rY2QrNDRvd0VVYjRrRXBvRHREYncx?=
 =?utf-8?B?SHNQVmFqa2NVb0FTZmJkWkpQa1F1Y1lZQnB3TVk1RlViOWdWcGpDWC9yaTdl?=
 =?utf-8?B?WWxrTUhTRjhwK0JXT3FDa2FQVDgyUSswdHBGWHNTKzNQWW5xckNpSnhSemhQ?=
 =?utf-8?B?WlVhTTZRdVIyZHlYWkcwbk01QktMQlNUZTF2NHlSdko1dDRyTHNacDc5Q05E?=
 =?utf-8?B?djhmN2picSt4L096VHNMOXpFUlk3YStjczJTeHlWbm5YUU1FaFdiNzhVSmNY?=
 =?utf-8?B?YkU4KzUrYTl6WStqbkNwSzBNeXlNNG1IQkFFVlBmWDE1NDYvTXdidyszMkUy?=
 =?utf-8?B?eDZtOUxKL1IvYWdFdTcyQk93UThhSnFUdWo4UlJDVnFOVUJqVWlyQTgrMVEv?=
 =?utf-8?B?Z2pvRFBMR3lGakFrNjMxbUtrWkorb1FSVWg3NlJtWm1ENDNZaHhac0FJYXRr?=
 =?utf-8?B?azJVT1dCVjFuT0NLbENLVWp3UFVuZDVLSHJJTHlhaU5rT3hWU0tFSC9ub1RM?=
 =?utf-8?B?MzUwTG9wd3JGZXZsRm5iUzRQckpWdXNaWTR3cEtkK1R2aG42Zmh0UldPMWM0?=
 =?utf-8?B?Ly9tTmdEQXBqUzBWMCtucDNTM29VbFZCTlg5YzdpeU9RbWgvRmZIVGNQOEJt?=
 =?utf-8?B?WFZ4TUhCVTJ4TEc5ejBSUkpNYkRSM2xEVGFHQ1dMdzIzdnpEOW53ZWxSY01D?=
 =?utf-8?B?cWdZUGhaMHVkaE92VmZvYUF5SGk5YVBQNTlKYWtpYlI3S1l4UnN4VjU0Ymxk?=
 =?utf-8?B?cDJrMVBmM0Noa3NEUmtXRldRV1gra0R3TER5cXJqdWRmSWJ5Q0Z4TU1Yd2VO?=
 =?utf-8?B?b1dlZEtUd3VIUjdHL1N4cWNXK1Z5U1FRdXV6aDNYSnhHeE1IeFZvREhLV0RW?=
 =?utf-8?B?ZjlHOVpld0c3WWkwV0VTa0JsdDUwNExyb1Y4SEhIMDJoYjRSTFg2VzBmaEZj?=
 =?utf-8?B?c0RMaHVFRUd3ZGFINmYzemY0aSswV1hqTnRFZGR2dlZ5aWtnNFUwWk1mY25I?=
 =?utf-8?B?UFpIaFduWW93RldybmZkaXQzdTE3OUZJcE1Od0pGQlNhb0hTaDZrYjQyeFlS?=
 =?utf-8?B?djlRU2NrajJLZ2g0bnE2a0ExWmsvdTBnNWowd3V5NUtFRytyU2JaMUh4REZz?=
 =?utf-8?B?YXJ6SlB5RDF5S1IwbUN0ZVAxYVR5R1ZWdnV4WFNzazI1ZFJsNFJZcGZUNm5B?=
 =?utf-8?B?SDVkRXNJN3NMVnNKMUhUelZGY0NRWm1YZkRIMXh0R3kvWWtUV1dvWHAvZy9h?=
 =?utf-8?Q?fuiIFIIH4E+uHU+ochb+ojKLG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41219427186B9A49A10CAB56A3E809F2@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be29ad3a-10b0-45f3-bed9-08db3fea8cbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 08:54:41.8991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6oVAytMSRR5FP1s/94L7diJx/kw1uhhwnYluoAVgo5LPXz3Xm59dLLwJPeQBOd3t+PcxmhEtGI3h503kNTRckQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR01MB6621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTE4IGF0IDAyOjQ0ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
Q2F1dGlvbjogVGhpcyBpcyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3aGVu
IGNsaWNraW5nIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMuDQo+IA0KPiANCj4gT24gTW9u
LCBBcHIgMTcsIDIwMjMgYXQgMDg6MDc6MzlQTSArMDMwMCwgU2htdWVsIEhhemFuIHdyb3RlOg0K
PiA+IEluIHNvbWUgY29uZmlndXJhdGlvbnMsIGEgc2luZ2xlIFRBSSBjYW4gYmUgcmVzcG9uc2li
bGUgZm9yIG11bHRpcGxlDQo+ID4gbXZwcDIgaW50ZXJmYWNlcy4gSG93ZXZlciwgdGhlIG12cHAy
IGRyaXZlciB3aWxsIGNhbGwgbXZwcDIyX3RhaV9zdG9wDQo+ID4gYW5kIG12cHAyMl90YWlfc3Rh
cnQgcGVyIGludGVyZmFjZSBSWCB0aW1lc3RhbXAgZGlzYWJsZS9lbmFibGUuDQo+ID4gDQo+ID4g
QXMgYSByZXN1bHQsIGRpc2FibGluZyB0aW1lc3RhbXBpbmcgZm9yIG9uZSBpbnRlcmZhY2Ugd291
bGQgc3RvcCB0aGUNCj4gPiB3b3JrZXIgYW5kIGNvcnJ1cHQgdGhlIG90aGVyIGludGVyZmFjZSdz
IFJYIHRpbWVzdGFtcHMuDQo+ID4gDQo+ID4gVGhpcyBjb21taXQgc29sdmVzIHRoZSBpc3N1ZSBi
eSBpbnRyb2R1Y2luZyBhIHNpbXBsZXIgcmVmIGNvdW50IGZvciBlYWNoDQo+ID4gVEFJIGluc3Rh
bmNlLg0KPiA+IA0KPiA+IEZpeGVzOiBjZTM0OTdlMjA3MmUgKCJuZXQ6IG12cHAyOiBwdHA6IGFk
ZCBzdXBwb3J0IGZvciByZWNlaXZlIHRpbWVzdGFtcGluZyIpDQo+ID4gU2lnbmVkLW9mZi1ieTog
U2htdWVsIEhhemFuIDxzaG11ZWwuaEBzaWtsdS5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYyAgICB8IDMwICsrKysrKysrKysrKysr
KystLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
bXZwcDIvbXZwcDJfdGFpLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212
cHAyX3RhaS5jDQo+ID4gaW5kZXggOTU4NjJhZmY0OWYxLi4yZTNkNDNiMWJhYzEgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJfdGFpLmMN
Cj4gPiBAQCAtNjEsNiArNjEsNyBAQCBzdHJ1Y3QgbXZwcDJfdGFpIHsNCj4gPiAgICAgICB1NjQg
cGVyaW9kOyAgICAgICAgICAgICAvLyBuYW5vc2Vjb25kIHBlcmlvZCBpbiAzMi4zMiBmaXhlZCBw
b2ludA0KPiA+ICAgICAgIC8qIFRoaXMgdGltZXN0YW1wIGlzIHVwZGF0ZWQgZXZlcnkgdHdvIHNl
Y29uZHMgKi8NCj4gPiAgICAgICBzdHJ1Y3QgdGltZXNwZWM2NCBzdGFtcDsNCj4gPiArICAgICB1
MTYgcG9sbF93b3JrZXJfcmVmY291bnQ7DQo+ID4gIH07DQo+ID4gDQo+ID4gIHN0YXRpYyB2b2lk
IG12cHAyX3RhaV9tb2RpZnkodm9pZCBfX2lvbWVtICpyZWcsIHUzMiBtYXNrLCB1MzIgc2V0KQ0K
PiA+IEBAIC0zNjgsMTggKzM2OSwzOSBAQCB2b2lkIG12cHAyMl90YWlfdHN0YW1wKHN0cnVjdCBt
dnBwMl90YWkgKnRhaSwgdTMyIHRzdGFtcCwNCj4gPiAgICAgICBod3RzdGFtcC0+aHd0c3RhbXAg
PSB0aW1lc3BlYzY0X3RvX2t0aW1lKHRzKTsNCj4gPiAgfQ0KPiA+IA0KPiA+ICtzdGF0aWMgdm9p
ZCBtdnBwMjJfdGFpX3N0YXJ0X3VubG9ja2VkKHN0cnVjdCBtdnBwMl90YWkgKnRhaSkNCj4gPiAr
ew0KPiA+ICsgICAgIHRhaS0+cG9sbF93b3JrZXJfcmVmY291bnQrKzsNCj4gPiArICAgICBpZiAo
dGFpLT5wb2xsX3dvcmtlcl9yZWZjb3VudCA+IDEpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm47
DQo+ID4gKw0KPiA+ICsgICAgIHB0cF9zY2hlZHVsZV93b3JrZXIodGFpLT5wdHBfY2xvY2ssIDAp
Ow0KPiANCj4gU28gdGhlIG9sZCBjb2RlIHVzZWQgdG8gaGF2ZSBkZWxheSBoZXJlLCBub3QgMC4g
QW5kIGRlbGF5IHdvdWxkIGJlDQo+IHJldHVybmVkIGJ5IG12cHAyMl90YWlfYXV4X3dvcmsoKSBh
bmQgaGF2ZSBhIHZhbHVlIG9mIDIwMDBtcy4gU28gdGhpcw0KPiBpcyBhIGNsZWFyIGNoYW5nZSBp
biBiZWhhdmlvdXIuIFdoeSBpcyBpdCBPLksuIG5vdCB0byBkZWxheSBmb3IgMg0KPiBzZWNvbmRz
PyAgU2hvdWxkIHlvdSBhY3R1YWxseSBzdGlsbCBoYXZlIHRoZSBkZWxheSwgcGFzcyBpdCBhcyBh
DQo+IHBhcmFtZXRlciBpbnRvIHRoaXMgZnVuY3Rpb24/DQoNCg0KSGkgQW5kcmV3LA0KDQpUaGFu
a3MgZm9yIHlvdXIgZmVlZGJhY2suIEkgd2lsbCBhZGQgbW9yZSBjb250ZXh0IGFib3V0IHRoaXMg
Y2hhbmdlIGluDQp0aGUgbmV4dCB2ZXJzaW9uLiANCg0KQmVmb3JlIG9mIHRoaXMgY2hhbmdlLCB3
ZSByYW4gdGhlIGZpcnN0IGl0ZXJhdGlvbiBpbnRlcm5hbGx5IChvbg0KbXZwcDIyX3RhaV9zdGFy
dCksIGFuZCB0aGVuIHNjaGVkdWxlIGFub3RoZXIgaXRlcmF0aW9uIGluIGEgZGVsYXkgdG8NCnJ1
biBvbiB0aGUgd29ya2VyIGNvbnRleHQuIEhvd3Zlciwgc2luY2UgdGhlIGl0ZXJhdGlvbiBpdHNl
bGYgbG9ja3MNCnRhaS0+bG9jaywgaXQgaXMgbm90IHBvc3NpYmxlIHRvIHJ1biBpdCBmcm9tIG12
cHAyMl90YWlfc3RhcnQgYW55bW9yZQ0KYXMgdGFpLT5sb2NrIGlzIGFscmVhZHkgbG9ja2VkLiAN
Cg0KU28sIHRvIHN1bW1hcml6ZSwgZnJvbSBteSBwb2ludCBvZiB2aWV3LCB0aGlzIGNoYW5nZSBz
aG91bGQgbm90DQppbnRyb2R1Y2UgYW55IGNoYW5nZSBpbiBiZWhhdmlvciBhcyB3ZSB3aWxsIHN0
aWxsIHJ1biB0aGUgZmlyc3QNCml0ZXJhdGlvbiBpbW1lZGlhdGVseSwgYW5kIHRoZW4gcnVuIGl0
IGVhY2ggMnMsIGFzIHdlIGRpZCBiZWZvcmUuIFRoZQ0Kb25seSBjaGFuZ2UgaXMgdGhhdCB0aGUg
Zmlyc3QgaXRlcmF0aW9uIHdpbGwgYWxzbyBiZSBkb25lIGZyb20gdGhlDQp3b3JrZXIgdGhyZWFk
LiBIb3dldmVyLCBJIGxldCBtZSBrbm93IGlmIEkgYW0gbWlzc2luZyBhbnl0aGluZy4gDQoNCi0t
LQ0KVGhhbmtzLA0KU2htdWVsLiANCg0KPiANCj4gICAgICBBbmRyZXcNCg0K
