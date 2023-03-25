Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA9E6C8BBD
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 07:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjCYGdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 02:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCYGdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 02:33:33 -0400
Received: from DM4PR02CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11013009.outbound.protection.outlook.com [52.101.64.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1930E1A8;
        Fri, 24 Mar 2023 23:33:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZT6eezU94Qwox0Iwf9a39waa47jhY++A4tIO8FIf3Ebf1ZRFk7B9bP+OUbb8s69GWRrjcTjnB7qmpuFPwkfW2+9vEOocNWgD+rXb7ono2yPpiDznr0xgrMzzVln7YoKKJikWoXx/0Cqz2IKU6/YnI+38Ril0EnvsmRYig4RnO936Kgqb80GA1wQ9aTPP2CQH7Pj64E0eNU/gIUeb5gl3tClFOwkGCvLHW7JKv7Bhse5dVNLXuYxM5UeJ7B1PPVNjSPCYO/6fiN/StLMlAqdo+JDMzMnOImvKRRJd+V2WJeErNpXd4GOwUIJ6aSUfixGpQiNScqLJ477wtLq5J4AEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ldz++q3S5IiPMSHaNQuoovCMjhO5AWQQ8AbJxABvWE0=;
 b=HJRAZsWxi4NNUFSzQBsccBYU8rjTjSPnLvROlIn30EU3bwzAYF7wfzwMwmPiAKy9tuVIJfVGrZl17lk9f08PBtv7uErTazSCgC/6AoUlZJlWTsOBmaInsb0yhz75MrbVE4Q2dq2T0L74b6WAGaQZ3wUQDukzV/hm7ZCD+TF/VhLeKOsn8H4a9Eo2KC/RCICXx3wAGYa+Bh3dkaztIDMvGB9SfbgD2DZ0P+U9H/uAKn9rpfEFWm26pi3j/8cyLxMLY9j3ipCKaAFi54/qUsh2X2w+qbOQNfeujqCjoV0grjufCAeDwO5JZYr+8Gjx+yvfj98hZhVkrOHEHPNTaC/3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldz++q3S5IiPMSHaNQuoovCMjhO5AWQQ8AbJxABvWE0=;
 b=nM50OnR0RYa/o4E4g7WLUyWPa4A8oCPrTIuTu7Huj2EzUM5bSViqawZjEtGMI296tsVG/y5gGBffhyTZBeu3GulTLFrd01lyhjyxBqazbYHgmmaJmhBFI28oD0cXl/pSThIQsTIixqcICoA4cXYOnLjiVMM/SleQWGGZis/kfFs=
Received: from BL0PR05MB5409.namprd05.prod.outlook.com (2603:10b6:208:6e::17)
 by PH0PR05MB9776.namprd05.prod.outlook.com (2603:10b6:510:28f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 06:33:29 +0000
Received: from BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::f634:136a:e2b9:a729]) by BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::f634:136a:e2b9:a729%4]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 06:33:29 +0000
From:   Ashwin Dayanand Kamat <kashwindayan@vmware.com>
To:     "simon.horman@corigine.com" <simon.horman@corigine.com>
CC:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Ajay Kaher <akaher@vmware.com>,
        Tapas Kundu <tkundu@vmware.com>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>
Subject: Re: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Topic: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Index: AQHZXMdG4h0xVBWDyEeNOj/spVySWK8HRTEAgAPH+wCAAFzigA==
Date:   Sat, 25 Mar 2023 06:33:29 +0000
Message-ID: <964CD5A7-95E2-406D-9A52-F80390DC9F79@vmware.com>
References: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
 <ZBtpJO3ycoNHXj0p@corigine.com>
 <4BCFED42-2BBD-42B0-91C5-B12FEE000812@vmware.com>
In-Reply-To: <4BCFED42-2BBD-42B0-91C5-B12FEE000812@vmware.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.71.23031200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR05MB5409:EE_|PH0PR05MB9776:EE_
x-ms-office365-filtering-correlation-id: 0f8e33ad-d65a-4a56-f919-08db2cfad8b3
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fgysPEN0L9BNudHLV153LPDWBZlftYGVN3ziQDusSTE93KIr3ZITSzKMfUE1imxc03rWTi1wI+U41i3jM7BSbxu6echMgaeU9dSHWk/XnlXR7BzQ1upvT2YjCy9gtdmWG/G5OPnoR1lJNykokeQjVSaAwK70DfsFku2D6LEMM3K3qNO2sZ3sRAqxz8eIQGGwCvFJq+lBYq5PsSd4PRYz+VRKPmMjEqQBqdS8KBEf99BJqSiCWohQap0Z3mMovUM4bl3o9W82F93ew+lk1IbR42XH8yo6WDd5Mbo0gAxEiyQ03h/uEFEAA0rqzGiNBPcJwuptb+nR218S4AM+jmpcxM0wkIaPDQ1rcQnbEju5bFozVKQ29hdX3Ev1GyDYXbbwWN9H6mYA2JQEQOm7yx46nVZpNkxLqRaMFUkl/b5xMbvAxL31CUMbqK60TGH2lZRBWShYZyK8Wt4vBGqQl6OLn9aAwTxwd5zsZBuYorDKaQCPEFIq9aLDDuDxcbQGgAxPKY9wFpTYg3/VUNDwDPGTVn3kukkYbvZMSyBuRzLCn3k5kPxMbP9OKNb1bvCnLN2cEdC22n/JHC9WLMJdO2novjKOr8eyoAvgE79arjUcVtauSaSVVa7eeZ77zaPeRSBGTxE59C5rAKmIZqcU0A8AwHY8ssJhV16uuHaIYWHh/0qz0oG+0J4bCbzOjSm2URka7QT6ndtkz814+v+5ZFKYdr3n90RZy9I6ykIxvgMQE87D7U2HVS45ejNWWjFglwHpnpde19sX8nSSGL0LxKy8J6LqKKqE5pR85ehc9Fc9g4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5409.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(2906002)(86362001)(83380400001)(186003)(2616005)(122000001)(38100700002)(38070700005)(8936002)(5660300002)(66446008)(4326008)(6916009)(8676002)(64756008)(66476007)(66946007)(76116006)(41300700001)(66556008)(7416002)(36756003)(6486002)(33656002)(26005)(6506007)(6512007)(53546011)(316002)(107886003)(91956017)(54906003)(71200400001)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEp3N291RUZCVTR3U0tSekRvTTh2QXYxSmtXQnZuTUJCUUQ2K2dycUZkSmUr?=
 =?utf-8?B?YiszVVFVa2ZXbi9FQWczRHIzdHI2RUZjVEI2TUhBQ2toQkdmUWovcnZXdnhW?=
 =?utf-8?B?Q0hmejM2SE1WY2FiMlRrTTlidjJzTnFFSURGb3VtQ0pkSnAzL2VDWGw0L0NU?=
 =?utf-8?B?cmVwdUN6YThJN01pNFBja1ZTelpCdWxMczFaZDhIVUxVYUV3Rm9oMjEzNG5q?=
 =?utf-8?B?eGMrcExWRmZLWk05RG5MUEdya3VocWVHQS9SaEFpZVI1TVp0NzFVcWlSNjEr?=
 =?utf-8?B?Yk9jb1RYNUcwUVJHWDc1QlhSRlNtRUtXdFNDck1kYTh3dlRkaVVEbCtNc0hp?=
 =?utf-8?B?c1RqZTMwWlEwTnNGOUtpajlPa1ZvWWpkeFhYL2ppM05FcENHL2srVTdZTUsz?=
 =?utf-8?B?U2JXMExVMndMVTVCbXVwL0Z5ZGpxZVM5ZWdzdnZWRjh5VGt6bnZ3YUV5WXBX?=
 =?utf-8?B?dmhrZVdTdXg0ZTREU1YxYW03NHI4WlFRT2RlTXRzQ29Ra250YTdTa29LMEpj?=
 =?utf-8?B?MFVuNUI4UXIvMWR5aGtEdEMwQnVhZXFCeVh2YTVYUk1TRG0rdVNLOENZVW02?=
 =?utf-8?B?S2QwOGVZcHFnYlQyb3hySHF5ckNhckVTYldkTEJTVGhKbmxWQkRSK3IyYUdG?=
 =?utf-8?B?M1VrK256NFVZZlRDVFE2bllCaUJobWd5eXpJOUhxcXQ5MWJtYmF6OWhPK2p1?=
 =?utf-8?B?bTZhOTRlaU9vOXVBYlJ0NklpTGlHZGhkci9jN3dPeCtTaXhweUpzYVpYdVlK?=
 =?utf-8?B?SCtjRjJ3YTZjTGMvSHhNVEcxTGVkcFNFRzNZT3VnRGtIS1c1WXhtOEdoVy96?=
 =?utf-8?B?T3RuWWFBN0dYMmNYTHhnSkVjWDhsUndKZ2xEczg1VnZGRWoxd1lqYzVmMlF0?=
 =?utf-8?B?S29jK0FKajVhZmR5a1M0MjE4cEVLeHZ5V2MyMGJkaFRPUnVyUC9VVW5nbStj?=
 =?utf-8?B?b3VaK085dExmTUtKemJIK05TV2ExTE5SWFMrS2I2RVdGa0tsSEdRWXpYTlFh?=
 =?utf-8?B?b2ZnL0xwTmI0U2VWQXdLeWUxZ2NxdmhyYlgvTG9mQTk0LzdpNWY5RC9kOUwv?=
 =?utf-8?B?RUlaQzRveGZBRklwU0ZOSExETktmRUlCMW9CN1g0d2pmVUE0MkkwMXZ6V0NG?=
 =?utf-8?B?eW9jN0FVd2VOdStQdEZJMEJoYlNVbjJMV1M2UUxKY3orcE9Ob1diTXplemk1?=
 =?utf-8?B?aTJNTTBVN01vK3g3eGZ2cU5xYWg2NHJDZ3IxVkJpZUx2azR4V2lhN3h3ekI1?=
 =?utf-8?B?Z2lUMC81RWpaN0NyelJhazdaZmxQSWpQUEd4TzJLWnZRMWJsczZJWGxnY2U0?=
 =?utf-8?B?aHZKTFJTamtGK3VtWFBwOGVVbWJWSC9XSjllRXRPWXFIdm9YblRxaDBCQlBM?=
 =?utf-8?B?K3d6djczT1ZpMTRLSmdBYjV1bzJUSFZKS3dzOWhxK2NEWVJlZThGZzRNKzFO?=
 =?utf-8?B?L0FUZXNWaUpBMTNnNCsxVTJzWkhVZFY4VlM2bXFIcDMrZUJHUitZaEVhbUlO?=
 =?utf-8?B?VkVoTERrRFIwT2NuTEU0NVlrd0dPZ28zbkhhdUZsdU1EUVhXdlZ2VHdWK3pQ?=
 =?utf-8?B?cmlnNkRWR216MFFSZjBYOEZxYTZtVllZZThBeHpkbGVNTjZNRXRURXBqMklN?=
 =?utf-8?B?MWpKeTh3WHZMbzFScEJIWmxGZTkrdHVrN3BKWFpxbjU1a0JxdnpQWXFuNWtN?=
 =?utf-8?B?bEpxSWhqRTRTQ2ErMTNOSyt5bUVmb3hzN1NoTkQ0QThWRHN2eU9tT0haWjdI?=
 =?utf-8?B?Snl3dURSTFlwU1pqWlFIZW5OYjUzV3ozUkpSdDlhYkdUeE5QS01Cb2lYTUtj?=
 =?utf-8?B?QVUya1Z3WmFoOHVkc0NUWWNhK1JXbW9Bb25URk5Zb05oR3hlWmZieHl2VXRu?=
 =?utf-8?B?K1p5V2wxaUx3bEJ6YU0wckpVRy9zYW5lMDdKT3V0RmZ4Vk9GUzZBeThSVGlp?=
 =?utf-8?B?QS82VTVpTFBrSERmSXFkZ2YvZnc1TlFGNVBKcUhoU1RkcjlXMXBFQkZnaGZh?=
 =?utf-8?B?NWtBQi8yaDlZOXpzaEczZitCNU1zYWNSY000TGFJWEZMdVJrd1E4Nm5kVHNo?=
 =?utf-8?B?VGlWbkthcldwSFJaOEJ0eUZjUlRBTGZBSDZHOFhmYjEwUzNSb2VrVmhHWmRt?=
 =?utf-8?B?MVhCSTFzV0JIVERXZ1hZUzkwWWpSYjBUcFl4VzZDSEoyTmYvQXpJM2dEZVFn?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE9AE9FC9086334984D765E03FC422E1@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8e33ad-d65a-4a56-f919-08db2cfad8b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2023 06:33:29.1864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5OZN06K3CN6g+3odgE+/hwjsLJekFO7uCoG1V98aUM9QaQ0kvLOjq7EbYsJwdqzXtqcK6uf9ChGs4Ro2Q2ljFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB9776
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIDIzLU1hci0yMDIzLCBhdCAyOjE2IEFNLCBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1h
bkBjb3JpZ2luZS5jb20+IHdyb3RlOg0KPiANCj4gISEgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9u
IFdlZCwgTWFyIDIyLCAyMDIzIGF0IDA3OjM0OjQwUE0gKzA1MzAsIEFzaHdpbiBEYXlhbmFuZCBL
YW1hdCB3cm90ZToNCj4+IE1ENSBpcyBub3QgRklQUyBjb21wbGlhbnQuIEJ1dCBzdGlsbCBtZDUg
d2FzIHVzZWQgYXMgdGhlIGRlZmF1bHQNCj4+IGFsZ29yaXRobSBmb3Igc2N0cCBpZiBmaXBzIHdh
cyBlbmFibGVkLg0KPj4gRHVlIHRvIHRoaXMsIGxpc3RlbigpIHN5c3RlbSBjYWxsIGluIGx0cCB0
ZXN0cyB3YXMgZmFpbGluZyBmb3Igc2N0cA0KPj4gaW4gZmlwcyBlbnZpcm9ubWVudCwgd2l0aCBi
ZWxvdyBlcnJvciBtZXNzYWdlLg0KPj4gDQo+PiBbIDYzOTcuODkyNjc3XSBzY3RwOiBmYWlsZWQg
dG8gbG9hZCB0cmFuc2Zvcm0gZm9yIG1kNTogLTINCj4+IA0KPj4gRml4IGlzIHRvIG5vdCBhc3Np
Z24gbWQ1IGFzIGRlZmF1bHQgYWxnb3JpdGhtIGZvciBzY3RwDQo+PiBpZiBmaXBzX2VuYWJsZWQg
aXMgdHJ1ZS4gSW5zdGVhZCBtYWtlIHNoYTEgYXMgZGVmYXVsdCBhbGdvcml0aG0uDQo+PiANCj4+
IEZpeGVzOiBsdHAgdGVzdGNhc2UgZmFpbHVyZSAiY3ZlLTIwMTgtNTgwMyBzY3RwX2JpZ19jaHVu
ayINCj4+IFNpZ25lZC1vZmYtYnk6IEFzaHdpbiBEYXlhbmFuZCBLYW1hdCA8a2FzaHdpbmRheWFu
QHZtd2FyZS5jb20+DQo+PiAtLS0NCj4+IHYyOg0KPj4gdGhlIGxpc3RlbmVyIGNhbiBzdGlsbCBm
YWlsIGlmIGZpcHMgbW9kZSBpcyBlbmFibGVkIGFmdGVyDQo+PiB0aGF0IHRoZSBuZXRucyBpcyBp
bml0aWFsaXplZC4gU28gdGFraW5nIGFjdGlvbiBpbiBzY3RwX2xpc3Rlbl9zdGFydCgpDQo+PiBh
bmQgYnVtaW5nIGEgcmF0ZWxpbWl0ZWQgbm90aWNlIHRoZSBzZWxlY3RlZCBobWFjIGlzIGNoYW5n
ZWQgZHVlIHRvIGZpcHMuDQo+PiAtLS0NCj4+IG5ldC9zY3RwL3NvY2tldC5jIHwgMTAgKysrKysr
KysrKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAt
LWdpdCBhL25ldC9zY3RwL3NvY2tldC5jIGIvbmV0L3NjdHAvc29ja2V0LmMNCj4+IGluZGV4IGI5
MTYxNmY4MTlkZS4uYTExMDdmNDI4NjllIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3NjdHAvc29ja2V0
LmMNCj4+ICsrKyBiL25ldC9zY3RwL3NvY2tldC5jDQo+PiBAQCAtNDksNiArNDksNyBAQA0KPj4g
I2luY2x1ZGUgPGxpbnV4L3BvbGwuaD4NCj4+ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQo+PiAj
aW5jbHVkZSA8bGludXgvc2xhYi5oPg0KPj4gKyNpbmNsdWRlIDxsaW51eC9maXBzLmg+DQo+PiAj
aW5jbHVkZSA8bGludXgvZmlsZS5oPg0KPj4gI2luY2x1ZGUgPGxpbnV4L2NvbXBhdC5oPg0KPj4g
I2luY2x1ZGUgPGxpbnV4L3JoYXNodGFibGUuaD4NCj4+IEBAIC04NDk2LDYgKzg0OTcsMTUgQEAg
c3RhdGljIGludCBzY3RwX2xpc3Rlbl9zdGFydChzdHJ1Y3Qgc29jayAqc2ssIGludCBiYWNrbG9n
KQ0KPj4gc3RydWN0IGNyeXB0b19zaGFzaCAqdGZtID0gTlVMTDsNCj4+IGNoYXIgYWxnWzMyXTsN
Cj4+IA0KPj4gKyBpZiAoZmlwc19lbmFibGVkICYmICFzdHJjbXAoc3AtPnNjdHBfaG1hY19hbGcs
ICJtZDUiKSkgew0KPj4gKyNpZiAoSVNfRU5BQkxFRChDT05GSUdfU0NUUF9ERUZBVUxUX0NPT0tJ
RV9ITUFDX1NIQTEpKQ0KPiANCj4gSSdtIHByb2JhYmx5IG1pc3VuZGVyc3RhbmRpbmcgdGhpbmdz
LCBidXQgd291bGQNCj4gSVNfRU5BQkxFRChDT05GSUdfU0NUUF9DT09LSUVfSE1BQ19TSEExKQ0K
PiBiZSBtb3JlIGFwcHJvcHJpYXRlIGhlcmU/DQo+IA0KDQpIaSBTaW1vbiwNCkkgaGF2ZSBtb3Zl
ZCB0aGUgc2FtZSBjaGVjayBmcm9tIHNjdHBfaW5pdCgpIHRvIGhlcmUgYmFzZWQgb24gdGhlIHJl
dmlldyBmb3IgdjEgcGF0Y2guDQpQbGVhc2UgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IGFs
dGVybmF0aXZlIHdoaWNoIGNhbiBiZSB1c2VkPw0KDQpUaGFua3MsDQpBc2h3aW4gS2FtYXQNCg0K
Pj4gKyBzcC0+c2N0cF9obWFjX2FsZyA9ICJzaGExIjsNCj4+ICsjZWxzZQ0KPj4gKyBzcC0+c2N0
cF9obWFjX2FsZyA9IE5VTEw7DQo+PiArI2VuZGlmDQo+PiArIG5ldF9pbmZvX3JhdGVsaW1pdGVk
KCJjaGFuZ2luZyB0aGUgaG1hYyBhbGdvcml0aG0sIGFzIG1kNSBpcyBub3Qgc3VwcG9ydGVkIHdo
ZW4gZmlwcyBpcyBlbmFibGVkIik7DQo+PiArIH0NCj4+ICsNCj4+IC8qIEFsbG9jYXRlIEhNQUMg
Zm9yIGdlbmVyYXRpbmcgY29va2llLiAqLw0KPj4gaWYgKCFzcC0+aG1hYyAmJiBzcC0+c2N0cF9o
bWFjX2FsZykgew0KPj4gc3ByaW50ZihhbGcsICJobWFjKCVzKSIsIHNwLT5zY3RwX2htYWNfYWxn
KTsNCj4+IC0tDQo+PiAyLjM5LjANCj4+IA0KPiANCj4gISEgRXh0ZXJuYWwgRW1haWw6IFRoaXMg
ZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90
IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhl
IHNlbmRlci4NCg0KDQoNCg0KDQo=
