Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686FA68F768
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjBHSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBHSsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:48:50 -0500
Received: from CO1PR02CU002-vft-obe.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152E49422;
        Wed,  8 Feb 2023 10:48:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckkua5pjX0V4ffZnsDgtVG9CChjkeAKiwtY9oapGJhhaibkcMBC3U+T+sKdYdslIg5MUe83LN8EfvtXSx0xtf6veLH+ZqGaX5+w1fFj+/O9gr5SaWhhn5/V1d+y9L64rcb6y3lq6a1vuMAgUeCkXdBPsH1ZnjkpiOrNHewdhQjUZfyvzI4EUWEf1cqxkFtawg1lKTsOSGgUdsJmP6ixzezeNVQ4sflXio30k0e+Ro9SDo0fVeuAfFOLlJLx5GGybDoPqlVC+9LpkxHxATA0NPaAZNmZxARuQQMUs8G+jNMkmTbYCbu/B2SivUIuoosYg+1SkCW4W0aTvrCn0bbyObg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou8a/XpLmnxh/GF9l0v2ZzGkZa4CpCOstensypg+Yos=;
 b=nM9YLggR0t+IbxqwOhYbUAZr62URr9vlpItHGvyIEI1N9VCGbe4j7vQwhWcN+3fxSnHt9LNswh7I7Ua9Tg2lM6oul04yaQUyS+zNMPkohZprJOQRXVkU5c0VVQq5Q0qCASsBZcPeOkp1onpShKbDHbnQjPxfW22YHV2srCC8K0IUhSJVyj81o0PrSxH3uR4ZR78jVuPyStP4s7oaCV36phaQa6lGDdDgEw0KyYK6PAIv7bYKD1AcHVmCZCaPCXv1+nt7HDILchgp5wR6KgKAMWXEA7nvSncIXbZCXlcfsKJ8IZ4aAEy31rvJ//RB2Ju0HsmSrAYv4e+X2Z6dPzE9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ou8a/XpLmnxh/GF9l0v2ZzGkZa4CpCOstensypg+Yos=;
 b=hSItfM7NZRngSeRurkGsjIogAi5jLMTX0LWeItm+kNbEIUyu19USUIoHsjGodOU/5F63CINilDGcbZQcOZ6wwWb+ChBZSkLmKa+KlnFbDYLvQOIr5WDK/VjMci8HtRBn0MVySviFNS8PkBgbx788J+Zjp5o/qcdtcIQv4zoVdzA=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by SA0PR05MB7291.namprd05.prod.outlook.com (2603:10b6:806:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 18:48:43 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::47cc:2c8:4b7c:6e2e]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::47cc:2c8:4b7c:6e2e%7]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 18:48:42 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Thread-Topic: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Thread-Index: AQHZOypxXNmqDt6CokOhKzm7AYATM67EkkaAgABNNYA=
Date:   Wed, 8 Feb 2023 18:48:42 +0000
Message-ID: <3051468A-19BA-4CF4-AA4F-61ECA561E5F2@vmware.com>
References: <20230207192849.2732-1-doshir@vmware.com>
 <20230207221221.52de5c9a@kernel.org>
In-Reply-To: <20230207221221.52de5c9a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.69.23011802
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB4470:EE_|SA0PR05MB7291:EE_
x-ms-office365-filtering-correlation-id: 03f8e84b-b7e8-4aaf-a60e-08db0a0519b6
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tIuAziov0MNp64svXueLO4Ul6r/iP0vEJtkpXaiy3NAPw5HcxiKBPEJYpmuIzzPVAogpZq4w6QgWjIrgYLwAOK6aGG58cofVVduO7TMwQkwua3ZOH9k7Y96eDr10ATKiM/fQwCkKEWtmgL8lJUJ29DekwDNTtOA3FIwQKhUBJLpK5TD7jEUnjEnXArWZFuCzct2xiv4d9uhJSNxKMILqBuRXsLWJPWhkeFdyzz0Uk2S7i8iDEmaBllKNGN9eZCgAOo7CRjossdsJa/AG0q8aLWG43039QwNuHqqiIXQsrqcrRViNVHkN9bwv0CDcYraqj/G2UCiQywfOMzYUqirZIWKmubJLieMcfaypFXKfNxjFikGbot6tDTPXp/3B55CgGgHEcxzme6m2qyOeiLu9Rti9BKS6+LmJtBgBqo3C+bNIm1IUHggIPSzljpKXkqux0WrpYq3mQVaa6OPrn2Y8/D7z77Uz0z/HgQ6Tihf2UQTGbCkCqvC/yOyCzTyn7suS28RAvhoUeeUmrPvZLG8zRffNA63S1QhUXtpP2MLIP6g7A/lbW5ZZzYGNSxiEegm0fQNdedKx2AFuw8oEVvu3CLTvCxHG9bQNO62lyD3R2xxXOsdxVO4VWAK9Pa0nU9TnKN1Ev64b3TuplT4rixLwpg+2yzmleXQulG9rc1I8SSyn/BKcsh0V0DXamXB9Cq8UXnc472pGHVBBckunbn+pQpqEbFzqVtB0y0OezLCrxxE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(451199018)(478600001)(6486002)(71200400001)(2906002)(186003)(6512007)(53546011)(6506007)(8936002)(41300700001)(66946007)(6916009)(66476007)(66556008)(64756008)(66446008)(76116006)(8676002)(4326008)(4744005)(54906003)(316002)(5660300002)(122000001)(38100700002)(33656002)(36756003)(38070700005)(86362001)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjMvYTRuL3k3SUM0eWRsZXpORTFxMnRsQ2JtOCtNYVU2eW9RMTdzNHZ4ZCsz?=
 =?utf-8?B?dWkvVStUaG1BUXZFTUlOd3NzaHpGWjBMSXpTMERjNVAwZDVFNnVGRTRoczhF?=
 =?utf-8?B?aDdOYnZwRlprWWZNTmRCdVBTQ0ZxcGFXTjZHaUJqYS9mZjlUYnY5ZUE2dkkv?=
 =?utf-8?B?SGxrQ1AxQ2t0amVJeDFIeW5hYU5vdDBSTnB1V1EweWQxYlRyQTAvYjBmdmdU?=
 =?utf-8?B?OWI2bTA5U1pka1B4VG1XT29lU3p2VENWNkpDUCtxeWlKLzBhd3RtOHpHR0VS?=
 =?utf-8?B?dlVSYVFMUDlFVGpuRTgzRVFuZHNYYlBrT0dXTW9LbkV6QUh4Lzc3dVc3QTNC?=
 =?utf-8?B?ZEZSWXZnSzBXRTZjOWtuZm5lR21sZ3YySDRVZGRJQ1Npd2xNbkM5SFhIUGNH?=
 =?utf-8?B?MjAyVStIT0dGM2k3aGZTRmowKzQ3eExVYkt0cVV3QjdRK2xQb2hjaks2bWl3?=
 =?utf-8?B?MEg2cExsTTN6TnA3YXEzNUpmK04rN01reUd6aFB5a2NHSWdWUUxDb2R2ODVQ?=
 =?utf-8?B?dmJMY2Y4b3VZVDk4UU9xRkxTVmc2NTN3VVllcmdrVlRGTjlib1RxYXRaVjhJ?=
 =?utf-8?B?eHFqLzNWa242RVV3ZHpVVG5FOTBTclRDZ1VmcHpjeFJ0aTliaGJuZm1yTU9l?=
 =?utf-8?B?QTQxZVR2akgxSjhBZkpHc1p1VzB1NW9WdVpncWV0eE5NVzBqWkRINUNpMGUx?=
 =?utf-8?B?bDFIUXhPbndFSmJ5NE5RVDZaQ2pBTTRzSEYydDltekJUYU9lOW5qbTJEeFVX?=
 =?utf-8?B?TGRIZXB6Tk5KcjRyeWRYeDJMUkJQZnFydFprbjhjdUdWOSs1emhoVE1veS9P?=
 =?utf-8?B?SzMyTWdtTjVpcDEybW0yL3crTE8zWEYzekcyRnVSWkxINDNOcXJyTENnTFl1?=
 =?utf-8?B?ZldEMEZzdkRrblp1UE9LajNteTRmM2E4MnB2U1J5ZVVIMkxrRmFuT2QyVE4r?=
 =?utf-8?B?MS9mUDlGQTNlb1hRREhUK0tET2hMbXFUcU16ZVpzSm0veVpCV0FreXdac1NR?=
 =?utf-8?B?R2hYeU1obUJ2T3llMmlmb2QyZXlSZ1hWTmNqZjUrYWpRK2gwaWRkWGU4RC92?=
 =?utf-8?B?WXFYdjV0US9QUjFUbi8vQTdVekE0WUN5Q3lEUW9VWmJYdXVlVjU0WURER1Yv?=
 =?utf-8?B?S2o0eGY4dkdXRVcwSnVTZTRKS09JTElJcTRJd3JMekpBUWlpQVdTRHc3VjRL?=
 =?utf-8?B?T3JJREtkaUMwVC9NWlVOUGdtNEhLL2Y3QWQ0c2htTGliSFF6blhZZXRTenZu?=
 =?utf-8?B?SWJmTlJSRkMxNzQ4QllIWFUxTkpiNE9meHpWUVJRRnhFSkFVR3hPQnMyTHNF?=
 =?utf-8?B?bndTRlM2S2JCdW94VXNHYkpMZm1LYmluRURrMHd3QjB1cXRZV0xhcUxHUkZr?=
 =?utf-8?B?ZDdQanFyZzcxSHc4Qlh2Z2xFM2k5K3RVaEpvMWxMeFc3MWF6QjA2eDEzaTFW?=
 =?utf-8?B?MFp1YnN6ZFR0ZWtHOE9oVkZjNU1vOXRzcWw0QUNmQ0tkM1pxeE00R2J2TFc0?=
 =?utf-8?B?TmloTk5sb1hwRjc0M1ZlaGNqSlNhV2JhSGFnS1pRbENPRzVlMjB3QjJEZU1F?=
 =?utf-8?B?aGJIRTFqNHY2WmhBclJtWENTQWYyemQvK1E3aXQwak84VldXdDdLb1ZTNVJi?=
 =?utf-8?B?YWxWU0xCZFl3c05BMnBMMWtSQyttcDdWYnplTjdzbGxpWE9TRXh2YzZtWDJ6?=
 =?utf-8?B?czRubmdYWEJuMmZEZzM1ZGxPdFFmczJWWm5EUGxsL1kwRlA4Mi9FUDUrNzFR?=
 =?utf-8?B?d0VNM1Z5NW5Zdll5bFV4TzYwSDY0SS90V3dIUDF6RmsweG5WcUVVR296SHRU?=
 =?utf-8?B?VXloMStyVkp6dEliM0RkSXVETHNLYmFQZnlGSnVVdTFMQjZvcEVKbXRNV052?=
 =?utf-8?B?ejlCRmZMdG9sYXFTbDZjUWlUMUg2WWxoOEhJUjJRY2ZYZVhPcSs3MUQzTCto?=
 =?utf-8?B?WmlkYmtDNU5aRHBRZVlrRTF5M0E0RzFFdnpXc1JFWnJsbWs3UVpETm9RQXFR?=
 =?utf-8?B?ekFaRTBhVTJwN2dnQ1BBYVdTNDNyWGprZHNQbWowSWtKRFZNV2xNR3Z1M1Bi?=
 =?utf-8?B?MjFyVFhZUVE5Q1Z2WlAzdGtxY2lIYzNqMHBzQldwRnpxNWJ0NUtSUUltazcx?=
 =?utf-8?B?QUwyN0NUUExsQ0s3eW5WdTBFOGNRa2JVODdqUXhobVBiTWYzZVliaGNGUHUz?=
 =?utf-8?Q?jSO4gxUjHtV0m+unyw+X0T0lAysOXMzyRZ7KkIUvEMCO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF6AF2DE7A81514CA66CEF03BCD0BBB9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4470.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f8e84b-b7e8-4aaf-a60e-08db0a0519b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 18:48:42.5103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q4RoaD5XE5SvFMm3/HK+6jVrJiTYyY0Fw8toMaFqlJLJHGo7Jb2G0EKsJbwrgrrGxn4LqSp/M/zvxpAeZeTrIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR05MB7291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu78+IE9uIDIvNy8yMywgMTA6MTIgUE0sICJKYWt1YiBLaWNpbnNraSIgPGt1YmFAa2VybmVs
Lm9yZyA8bWFpbHRvOmt1YmFAa2VybmVsLm9yZz4+IHdyb3RlOg0KPg0KPiBPbiBUdWUsIDcgRmVi
IDIwMjMgMTE6Mjg6NDkgLTA4MDAgUm9uYWsgRG9zaGkgd3JvdGU6DQo+ID4gQ29tbWl0IGIzOTcz
YmI0MDA0MSAoInZteG5ldDM6IHNldCBjb3JyZWN0IGhhc2ggdHlwZSBiYXNlZCBvbg0KPiA+IHJz
cyBpbmZvcm1hdGlvbiIpIGFkZGVkIGhhc2hUeXBlIGluZm9ybWF0aW9uIGludG8gc2tiLiBIb3dl
dmVyLA0KPiA+IHJzc1R5cGUgZmllbGQgaXMgcG9wdWxhdGVkIGZvciBlb3AgZGVzY3JpcHRvci4N
Cj4gPg0KPiA+IFRoaXMgcGF0Y2ggbW92ZXMgdGhlIFJTUyBjb2RlYmxvY2sgdW5kZXIgZW9wIGRl
c2NyaXRvci4NCj4NCj4NCj4gRG9lcyBpdCBtZWFuIGl0IGFsd2F5cyBmYWlscywgb2Z0ZW4gZmFp
bHMgb3Igb2NjYXNpb25hbGx5IGZhaWxzDQo+IHRvIHByb3ZpZGUgdGhlIHJpZ2h0IGhhc2g/DQoN
ClRoaXMgd2lsbCBjYXVzZSBpc3N1ZXMgbW9zdGx5IGZvciBjYXNlcyB3aGljaCByZXF1aXJlIG11
bHRpcGxlIHJ4IGRlc2NyaXB0b3JzLg0KRm9yIHNpbmdsZSByeCBkZXNjcmlwdG9yIHBhY2tldCwg
ZW9wIGFuZCBzb3Agd2lsbCBiZSBzYW1lLCBzbyBubyBpc3N1ZS4NCg0KVGhhbmtzLCANClJvbmFr
IA0KDQoNCg==
