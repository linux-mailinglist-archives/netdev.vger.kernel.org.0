Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AE61E541
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiKFSNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKFSNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:13:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644ADAE57;
        Sun,  6 Nov 2022 10:13:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksQcghv27A1WiQ34xklKY97/e8VS+LTprLClRSJjy1BDLk2tTgUr//Sba94JpjzyKmMjTgx9g2KcMRcxcy/5oV5ytPz88m8xrtqVv97UNu7S08odFqjIPUOP+MlgUc8yayG8KVCjv8H6cZOzL81uq6YYfxw4EM9jrlVvHSLgMUQdcNA2oQC9ExDh2ad77ebY7puSHzb0JXb8O+JLjRrSOaIlLaThQ7WiP4mv7u8xao0fDoCjRB2CyTgQYsud/Kku2b9jy0dEN+50wKFIa+lUijwxQ763zqpnLCzLSzgrWtwfIT8Lk1jqyJiTNgQeXso2nzZoVYq1zfJcqVcUNSAqNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPR6d76DivbNq66zdnxGt52quEF2ohhTOoha6s2BObg=;
 b=b7QyQPAV1+SLrJ5tayMHyYFQCxEoTizDaLg7/H8KE8wPbQa1qSfM7Bg7P3Ol8GRXM+fYHBOnolrZU//MNKCbVfSRNcxqXGZ6zt/RtC3gvnQMKnK0GrOesnYfM2pw+eYFu03TdOF97cY0yZawKBjdh1snNUuocVjqzL7nai/Mz+6uRL5rlo1z7yatfoLXB6KIvJRQdO8a68I8J4QotBKIOXDndmokFA95Ea68H+F+x7MjLVLm6qqlUtx/2CCcMBZe2vXfn7hmnZpMWfoZvlPNOujkgH3YgpJ2TDafn5OmCvrKEgcWHIkSyIr1+cvl9NT3nKDzYpUGtZm6/H1pKd3w0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPR6d76DivbNq66zdnxGt52quEF2ohhTOoha6s2BObg=;
 b=XyqY4KPd36BikTEFo9fxvcJaJCERY98KNz35rDioDYGT7iqX1xidJTqIa6PBPgkETg34khOSyt5Sumcu+h0hisPtnhyOcN5e986vFPdsO8jrbRWlf1Ily7hRvkB/yiwUYLIC9zv+BOeW0KVcZ53OTzFOEvSIUJWCtMVc6hJoZ6k5cjTNrzw8QIxhx8TLmuIJtGyEmMjNZVdu05NSFzBX5LlH5cNQDgq4YwaMD+F0wZiv5CptcHuKcMcSqEw41EMFPky+Yc1rOwxYzi63LgeSZNpV1I/prKkbqzgqPAGFP6ncOGSL4PZYncy28of1Uy5y1MbaDfW6cXjZrLI/S0HuCg==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Sun, 6 Nov
 2022 18:13:29 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::858f:556e:fc68:c2ac]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::858f:556e:fc68:c2ac%5]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 18:13:29 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC:     "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Thread-Topic: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Thread-Index: AQHY4rrj5yTYQO5x8keLlrVA7994K64eugCAgAA6pYCACE5PIIALDaQQ
Date:   Sun, 6 Nov 2022 18:13:29 +0000
Message-ID: <BN9PR12MB538158081EB8BD0CD452DF70AF3D9@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
 <20221014073253.3719911-2-daniel.lezcano@linaro.org>
 <Y05Hmmz1jKzk3dfk@shredder> <cb44e8f7-92f6-0756-a622-1128d830291c@linaro.org>
 <Y1e7MRozZYSHgV0V@shredder>
 <BN9PR12MB53816062FAE98EEFEF319644AF349@BN9PR12MB5381.namprd12.prod.outlook.com>
In-Reply-To: <BN9PR12MB53816062FAE98EEFEF319644AF349@BN9PR12MB5381.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5381:EE_|PH7PR12MB8123:EE_
x-ms-office365-filtering-correlation-id: b0bd9813-b18a-472d-9169-08dac0229b7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g833is3n8ovFm2r5piJviKBFaEVAQSRm62+8o9a0JKcr9QkHLldfBV1mkAw8CIC6dzFj3aevd9I1mlPmLpoCsjFjyz+D4oC5qSz/Uq1RbAmbF1sAMQ0rkETLrD2CL5sKvAIzuFYQhm/Wx/CuPaaFyTJf1ei4F1bwMCqMb5nUrdGnI2jQTxRXXcoNvkIYzY+1mbAhnn8l7hWI/3fu+hApdD13swOGprbUPvrXdYMMAQiF6kqWF9tG8sm4K6igxiiv+W3Et5dwoYMCgnlvXOmVWegQTL8ahMKWR7tVaY3zVW3cIlUoNnb3IP0uqM4xDmx5arq1WfROsxbCH/sVaNsI9W/gTWiqYw/d8CUws3qeASlX5Fb1umuEDHOqt27FLMhsNoKpeekvB2B+v06pzUSmHRD5YnkHJmHcHkzckjiNo0cZBX4atntCmQr4f3R8QYTDL+74/5P51Q/f4392+Bxtpa5wsnh7tP34KMzP0nCzzHo/mwxeOCiIM7HG6jyy6PK+AR0p8xTb18HRzJMu8H5UmJKHMzEx8P9a1kCd+1VIoKYa0UaqlMHB9ZVsP7pGvnQH5fIBxslJThs4hS9n5B+CSGvNa96rr+GQHE4/BQAEJCpnr5gOXE8e2AqoIMADYspOUfiFzhAROxyS8kWMyaCPSk/CFV9Zu2qlHZbWL2ZK1CBwRQ8m3tdsllOq3slJVVepcB0nN1doi5/iXnYd3YbieMiyWR/U2f1b2m3+04vGFvn3PUGv/BO8mKXzRzkZxMk8zMpHuwZOwXXCRtOYAkaGDxisUqJz9wXi40DqRJIntRg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(2906002)(38100700002)(4326008)(8676002)(9686003)(41300700001)(76116006)(66556008)(66946007)(66476007)(6506007)(7696005)(316002)(8936002)(5660300002)(64756008)(33656002)(66446008)(52536014)(38070700005)(54906003)(26005)(110136005)(122000001)(478600001)(86362001)(55016003)(53546011)(83380400001)(186003)(71200400001)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDc4Qm5wR0EvSFkzc3R6cnhoRFZWSTdGR0dPNUhLYU1vUHdvUklzRWh6cEd2?=
 =?utf-8?B?TzJSczh3VHl1dndKSTVFTk43eXVhWEJRRllveWdVQlhIVEMzR1dxUHBYdHI2?=
 =?utf-8?B?a1ZWenhzUnpraUZqeXk0RC9CWVEzWWtSVTVkWnV3MGg3Z3hMd05WMDEwbWNZ?=
 =?utf-8?B?V3l6SHhzeTRXTnJJaUhER1gxUlVMbEZBZVJOOG1qcmZZazZaU1JML0xDS25G?=
 =?utf-8?B?K3F6QU84dHdMV0JnbDNELzBOUDF3YnRIeW5XYVNHYis1NmZ2RFdPdlpzMmY3?=
 =?utf-8?B?NWh0VnlrL0NkblpGOGsyZWJkOVBIRi9YM1F4U0xYeHpURzBmc3FZcDNuLzV2?=
 =?utf-8?B?SVpET3FlZ1RNSDgyZDl3T3Mzd2xGcWFDUkVlTXBieFJab0VnTWovOHEza2RB?=
 =?utf-8?B?cjBNSjQyb0t1b0J4bGR6U213M3UwRm04Q2psZk1kVnMzRzYyN0FENTVSUGZX?=
 =?utf-8?B?N1hhVHo1V2pSdENyaHRYVTBDcTdjYmx4b3k1RG1PU1VjdGpTMEpER3ptK0dp?=
 =?utf-8?B?RmtVOXQwdjZqdDlEaUYxUVhsaVVDRE9Mc0VaQm4zZ21hZFRtRTlKMU1Fa0VG?=
 =?utf-8?B?OTZRcDhwZm4wZEdLRlBGckova3NCYXJXY0lLcmdHUVg4WmVaRVY4YytjeVpa?=
 =?utf-8?B?cTNXMEpNajZxMllQTG9qbTU0Vy9iNHJIWHZ1aXFRNThram80NlhiS2YvWVJj?=
 =?utf-8?B?R1BHQWwxNVhwOFliS2pTd2V4ZmVoQXhFdTVMNkF5YmRXemJYMnU1bG55TEdu?=
 =?utf-8?B?UWVVZUJMNVJodWpNaGp4N0E2ZnVTSHdQUTIxN3NhQlFiMDFtbUZIUTVhamd0?=
 =?utf-8?B?UUl1RjNIdmJxVHUwM0JpMFdkQnBpMkhHNmVkcDE2djVYQnlRdFJyb0pxTzBH?=
 =?utf-8?B?WG5tWk5lRHRpUkt1WlVacS9uVi85bWhtWEIwdFV0TnBCd3BpZ2VIOWFOTDRr?=
 =?utf-8?B?STR5eUd5RS9LSnlHSGl3eFVwU2sxRThlTWR6Q1RyUU8yRkJ1c2FiWHM3VnJv?=
 =?utf-8?B?UkpNOHZJRHpRSG1OWWhDaXVTS1MvcGhEOUVGVVZoeUlXUjVNMU1Pd0xVYlhN?=
 =?utf-8?B?TVRIemFzam1GMHNHdFV1ckNCVUc3Z2pWRWJxck1jRFVvWEoyYU9MZWZoL3dO?=
 =?utf-8?B?WHFjR3FXYnFvTzJHY2lBMzMwTVJ2UzZXSEZTNU5PckRFc2daUmVqOHE0N2xI?=
 =?utf-8?B?SjhXckhBN1RMQjJaWVVNTDVUUTJkQ0JjN1NNSzR2ZWNSRW45K2w2Wmk5NjBG?=
 =?utf-8?B?cTRzM3NMZHNKclhkYkNSRElNaCs1YUg0MGtlUzFCMm82MUhPVCtkY2Ntdlho?=
 =?utf-8?B?VXE4TnZYK3hldFhYdi9yMU5VaHYrQlg2VWxjYmZJcVY3dG5lOGpjeGhIcDQ2?=
 =?utf-8?B?bGdZUmhJelhSSlhhemM4Mm0wd1BDdkIxT0dlTlhUQU1DY0hBanFnWnQ2T2Ir?=
 =?utf-8?B?dDlQWVRsT3pBbC9HRVNnM1lVZ1liRVkzTWJwdDJMa0V0czdSS3RuN2JDZWpE?=
 =?utf-8?B?Rk9wbC83TE1DV2tycCtyamE4NFd5alZMeFlmWC9SVkw4cUhEWlU2Q2FEcXkw?=
 =?utf-8?B?VXd5alhNalowblZJeUNhd2tWdW5UTUo3cGhuY3BFUEF2a2xneEIvZDkwTTVj?=
 =?utf-8?B?d1AvYmdDTXpEU3dLcjdVWUFhNUJwdHQxQmpvU29IS2V5aklGL0FUM0JsQm5F?=
 =?utf-8?B?VVBjNkR5YzVlYlZuUkhVV2srVVBwMXE1RG1SWTFyTVZsejU5dWh4b1FEb00x?=
 =?utf-8?B?enA5TGJwTklncG10enh6WWpHWm9QTTJzYTg1eVhETlREbitrbHRZeWZUc3VZ?=
 =?utf-8?B?aXB2V01PVDkybHkrOXFzcWhWaDdnK1FRVStXaE1LNHlUV3RxdndrM09TNkpV?=
 =?utf-8?B?OUhIajEzQXBpNkRXcE9ma1JjVEZRL0pYT3dFTjdHOUYxRTBobGJYYzNMdHkz?=
 =?utf-8?B?bmwwanY4K0l0T01IQ1VtMWJEK0hiOU16aTgzWkxnamd4cVZLZXp6WmQ2T210?=
 =?utf-8?B?T3RLdXprc1VQNUVWN0FJTHUzOGxiZHRxbHpjaXJlblEzZ0xNbXczRUo4Zm9k?=
 =?utf-8?B?aFI0elp0V1BZL2wvMlN3YXJoQUFUSEdHK3VldFoydlpwenpaazc0UjNZM3A2?=
 =?utf-8?Q?MTX35BGO6anji46C6Ue+2pVcr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0bd9813-b18a-472d-9169-08dac0229b7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2022 18:13:29.6128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jh6KNms5jgMWhY5aRbtfxad2blxg+HqUKALhgsgc0huCjpIQMWXINF8mfYWKaBlR6Lvm6HawKifkQ7Fsv1gJWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmFkaW0gUGFzdGVybmFr
DQo+IFNlbnQ6IFN1bmRheSwgMzAgT2N0b2JlciAyMDIyIDE5OjI0DQo+IFRvOiBJZG8gU2NoaW1t
ZWwgPGlkb3NjaEBudmlkaWEuY29tPjsgRGFuaWVsIExlemNhbm8NCj4gPGRhbmllbC5sZXpjYW5v
QGxpbmFyby5vcmc+DQo+IENjOiByYWZhZWxAa2VybmVsLm9yZzsgbGludXgtcG1Admdlci5rZXJu
ZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgUGV0ciBNYWNoYXRhIDxw
ZXRybUBudmlkaWEuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWINCj4gS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IG9wZW4N
Cj4gbGlzdDpNRUxMQU5PWCBFVEhFUk5FVCBTV0lUQ0ggRFJJVkVSUyA8bmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZz4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCAyLzJdIHRoZXJtYWwvZHJpdmVycy9tZWxs
YW5veDogVXNlIGdlbmVyaWMNCj4gdGhlcm1hbF96b25lX2dldF90cmlwKCkgZnVuY3Rpb24NCj4g
DQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IElkbyBT
Y2hpbW1lbCA8aWRvc2NoQG52aWRpYS5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgMjUgT2N0b2Jl
ciAyMDIyIDEzOjMyDQo+ID4gVG86IERhbmllbCBMZXpjYW5vIDxkYW5pZWwubGV6Y2Fub0BsaW5h
cm8ub3JnPjsgVmFkaW0gUGFzdGVybmFrDQo+ID4gPHZhZGltcEBudmlkaWEuY29tPg0KPiA+IENj
OiBWYWRpbSBQYXN0ZXJuYWsgPHZhZGltcEBudmlkaWEuY29tPjsgcmFmYWVsQGtlcm5lbC5vcmc7
IGxpbnV4LQ0KPiA+IHBtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgUGV0ciBNYWNoYXRhDQo+ID4gPHBldHJtQG52aWRpYS5jb20+OyBEYXZpZCBTLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljDQo+ID4gRHVtYXpldCA8ZWR1bWF6ZXRAZ29v
Z2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiBQYW9sbw0KPiA+
IEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IG9wZW4gbGlzdDpNRUxMQU5PWCBFVEhFUk5FVCBT
V0lUQ0gNCj4gRFJJVkVSUw0KPiA+IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPg0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMi8yXSB0aGVybWFsL2RyaXZlcnMvbWVsbGFub3g6IFVzZSBnZW5lcmlj
DQo+ID4gdGhlcm1hbF96b25lX2dldF90cmlwKCkgZnVuY3Rpb24NCj4gPg0KPiA+IE9uIFR1ZSwg
T2N0IDI1LCAyMDIyIGF0IDA5OjAyOjIzQU0gKzAyMDAsIERhbmllbCBMZXpjYW5vIHdyb3RlOg0K
PiA+ID4gQmVjYXVzZSBJIGhvcGUgSSBjYW4gcmVtb3ZlIHRoZSBvcHMtPmdldF90cmlwXyBvcHMg
ZnJvbSB0aGVybWFsX29wcw0KPiA+ID4gc3RydWN0dXJlIGJlZm9yZSB0aGUgZW5kIG9mIHRoaXMg
Y3ljbGUuDQo+ID4NCj4gPiBPSy4gVmFkaW0sIGFueSBjaGFuY2UgeW91IGNhbiByZXZpZXcgdGhl
IHBhdGNoPw0KPiANCj4gSXQgc2VlbXMgdG8gYmUgT0suDQo+IEFueXdheSwgSSdsbCB0YWtlIHRo
aXMgcGF0Y2ggZm9yIHRlc3RpbmcgYnkgdGhlIGVuZCBvZiB0aGlzIHdlZWsgYW5kIHVwZGF0ZS4N
Cj4gDQoNCkhpIGd1eXMsDQoNCkkgc2VlIHRoaXMgcGF0Y2ggaXMgYWxyZWFkeSBhcHBsaWVkIHRv
IExpbnV4LW5leHQuDQpJIHRlc3RlZCBpdCBhbG9uZyB3aXRoIHJlbGV2YW50IHBhdGNoZXMgZnJv
bSBkcml2ZXJzL3RoZXJtYWwgYW5kIGl0IGxvb2tzIE9LLg0KDQpUaGFua3MsDQpWYWRpbS4NCg0K
PiA+DQo+ID4gPiBNYXkgYmUgeW91IGNhbiBjb25zaWRlciBtb3ZpbmcgdGhlIHRoZXJtYWwgZHJp
dmVyIGludG8gZHJpdmVycy90aGVybWFsPw0KPiA+DQo+ID4gSSBkb24ndCB0aGluayBpdCdzIHdv
cnRoIHRoZSBoYXNzbGUgKGlmIHBvc3NpYmxlIGF0IGFsbCkuIEluIHByYWN0aWNlLA0KPiA+IHRo
aXMgY29kZSBpcyB1cHN0cmVhbSBmb3IgYWxtb3N0IHNpeCB5ZWFycyBhbmQgSUlSQyB3ZSBkaWRu
J3QgaGF2ZSBhbnkNCj4gPiBjb25mbGljdHMgd2l0aCB0aGUgdGhlcm1hbCB0cmVlLiBJIGRvbid0
IGV4cGVjdCBjb25mbGljdHMgdGhpcyBjeWNsZSBlaXRoZXIuDQo=
