Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7246D22B9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjCaOeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjCaOeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:34:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D920619
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eihhjzyPzgSzqirIrkFFkclgOLXoWDuGIT7c80RIEF3dOhA+SP650bRsleGsJHfZyIHItwe4c4MVlT2Ap9nPG0AkQRyjGXU3uFoOo4Nf9eXGVQmbmVf3AsrOmTNmLxyllDuFH/oe060oONeKPQC0h0WlDXNvkGCNCWON8UiIiLsvw6RdjFOF/rMr7YjWcnCe3vOod3TMkAunVgebe3jx3izptdHH2s74KPPaByZJ6155b1BQv6E9GtK8jlueU6MOMRLeA8j838XI0HK7xUjqq1oxIW09x4hpcEMPmCWPWfRmwl1klViGvTcMIAWLuMP5MoMfqXUvBVCUhVJR+VOfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xjxuVSNrWXneagASI6MLOtbgO+WOOwEEN3VNlv0E14=;
 b=Xrma+QMybF56Ohm2ASddcknGpMJBF8COg1RGzUuI5wu0acpPQdljtp/Vd216p5QhHLlRWwkwrCJEEmx8+AAJ9JhsQUAnKxEXnvkSdwke6bimZSjR6muZOMUpODasFAikRNf7jfQSMp9gBdY7nfRdGb3z1b5evsepSLVnEaUuVZ8SVUBNiERYZASSjOqK5m5LbdtPAyKdR6AYIfUTNVaJkDGjSTeYLvula5Nb1nDVp97K6SBgG6Qx9c7HfNFV7AB2qwE0yXTy6678eO1Q5u9A+iJV3BecAHhajvLBJmy8lkzVrk/7SExiyzu3DQc5/I1jGNhMIlJwZO0AQjEjVxPgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xjxuVSNrWXneagASI6MLOtbgO+WOOwEEN3VNlv0E14=;
 b=KCMDEsv4ssxk0I/ZyceohSDI5ItXDSECR58OiPbj9LyU2mSe4SMtsgGYUziB9HioDzKRNhto7FyTejD2PCN/0K2sKp4wRnnVRcUurWYpbYfdTi5nwJ6ieaql1eYJ9aKVlk3GMUR0Epjf31MTnWIWF8R4sczmcedDBNar9r50lu2V5QuVhniiRSWClzto+AaLO2paptdICYHLsJN8Aj3AzCxC4aDm2NF8CLggKWfDdYxVv+jOR0YVmfBojxllvfmMJHUrNgC4WwCci0Jn4pKKaBQu42H3W+7eiYqFaSk8r/z4LPXz4IBMP+3XpBJZB1Z26FOX5WDmI106pjTqxZeXow==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 14:33:14 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%4]) with mapi id 15.20.6254.022; Fri, 31 Mar 2023
 14:33:14 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Topic: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZYjj7BMU6ZLQ8MEG7TiLdHIsIA68R1ViAgABCgoCAAXs8gIAABo0AgAFcy7A=
Date:   Fri, 31 Mar 2023 14:33:14 +0000
Message-ID: <IA1PR12MB635367C8019015A95FBCC2D5AB8F9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
        <20230329122107.22658-2-ehakim@nvidia.com>      <ZCROr7DhsoRyU1qP@hog>
        <20230329184201.GB831478@unreal>        <ZCXEmUQgswOBoRqR@hog>
 <20230330104248.2c884f5c@kernel.org>
In-Reply-To: <20230330104248.2c884f5c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS7PR12MB5981:EE_
x-ms-office365-filtering-correlation-id: ffc908b3-84ac-44f2-a900-08db31f4dc7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AjIMs4e0BDJZbX2H3kV9nWVErwxNwOphn8WIhtw9YH/t4XV3Ghtzx0HdvgTOnm11AEOa92lDsC5FGK6I8Jt692WxwgM22g96bQ2Ha9EMoIy9hE3/GiNjuXEkB9quVFtbCYw6knv8JaA/sEOYPHlCjgquUvaHIJ6WfD+Wl8QFmqp2+tjZ6ajqNPaO3ONIGODmI+NS8QGa7zOwLVciRmFrG3ufj677fRc0rD34MFyy76LBewpwD/ZlvcOBtjjH8talEnIqBt/qx4EROXLRaldv2fRUA5GNXyPbYWkpq3sNnlfoUqkT21I6HJFQKJH+6uDqZGigPwmuQ8J+qKSLGWagRCscEkw2KnbRsgXtNowX0LzW2VNjdDasrmaaDnsaCj96d3kR8e+gc1XMfg5lN6t2cyXrukoQB0khdAcB5/BG3mlDxr/s6CvZ0AohRfAFjORMmkTJHZsLtwbiPQZA0dTxGKupb/xsABVNNfoIkHJO1m4LsAc5C14aeNl9y+HkpeYtBJNEfVRIYg+Uv8E/MUfztCV5pq0oXmdJeXYacH1ionLrStMYJj2DR1tzR4xGGSBxCY01AusSWiO8MwEx2IuFcOLKs/ou3j7h0OB7WpQRoJdoAIX7Ne0ttH/XnwmQ0Pob
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(64756008)(83380400001)(6506007)(26005)(53546011)(9686003)(186003)(122000001)(38070700005)(38100700002)(41300700001)(76116006)(66446008)(52536014)(316002)(8936002)(4326008)(5660300002)(478600001)(71200400001)(110136005)(66946007)(66476007)(86362001)(7696005)(8676002)(66556008)(54906003)(55016003)(33656002)(4744005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1VuUXlBMUpnblRmNnNPUlh5WjAzMUxXUkVJNkNCa2tRZlFPYVpMOGplaTU2?=
 =?utf-8?B?bUQ3Tk85M2hKUDVCSW1VVTJvVldCUzJmaWtYM2xVU005VGxHZGlrdWxvbE9J?=
 =?utf-8?B?OTdJZndMS0VWMGJDdTgxOFZnRHp1alRWNlRDeWpOTmV2TjZzOFRBd2lkZ3Ev?=
 =?utf-8?B?OGEvS2JJYS94SUxJRTFJcEJUanlIam5yUTFXTFJRWjlXQW90T3JQQktZWUFF?=
 =?utf-8?B?bFlHWENrNmdQa3d5cEZRcnZFVDliZ0VPY3RYSTNUQUt2NWZTcXF0SWdiNjQy?=
 =?utf-8?B?V2d3N2pTYkdaZ3hTd1JIaVhmRFZzM3hLYWhCM2hhVEM5Qjk2NkIzQW9ESU5E?=
 =?utf-8?B?emF0Wm9GR0NpSlNCdVNSVEYvcjkxQ1ZOcnM1b3dKbVVYeE94NktuNHZJRFFo?=
 =?utf-8?B?b080TnYzUVppN3lsYkFXbEMwbVNKcjF1RmFRaGlnRXZYaTI1a3JrdG5Pc0d2?=
 =?utf-8?B?YVh0VDhRbFpUSEdlN2xpWlhoeHRFNkRqR1JEa01UbFVvZ2JVWVNzSTVuelRH?=
 =?utf-8?B?NnhlcGZjeWVUVlk2bEhKOTAyQTJxaEdSay9URDVwdkNVQ3ZIVW5MU3ZpdGZx?=
 =?utf-8?B?WENrZGtseWtkQ1JKQmNKN0VkTGdxV3hEc1pQRUEvTHMzMVNqcnJjc1B0cWcz?=
 =?utf-8?B?TnNSNzZkOGNoaTA0Sk1GYk5leWtLckVIcnBITUdGUVFuNFVzbGQyWjllT2tN?=
 =?utf-8?B?NVlNbkdrTDFVUDUzWHp4SGZQdnJaTm12RXZYU29SRE5OTm00eVJGaGJYeU5K?=
 =?utf-8?B?UUtvaFdidmNTa0RndTZmYmYwZ2o5R3NsWjF5bU9IMm5Ta1A1YUpWTGk3Z0d5?=
 =?utf-8?B?MkFUODQ5ZGlsd2VsRXR6c3NMeUQyeVM1aklkVXdvSmlBdmx2b2ZpYmJxMUJu?=
 =?utf-8?B?MUIxRXhFNWxvU1NkZ2xORGNKR3NVMGZsb0szdGhBc3lvUjZ1NGlFeHpGVnpm?=
 =?utf-8?B?VU9xZVNPdjVLN2wwWUh1VTdQTktIczJjTXhydnlzT2hsZjVBN3lRbVdhTUxp?=
 =?utf-8?B?bDhtend3bktieFR5RDUyMVZaVXFLUnVyd0E2VEZ3Qk1iTmhqOWp3UlNBUGcw?=
 =?utf-8?B?UFZhMWpEQmxkTGVnWXBpYnB2NTB4Vjc4ZW9mY2dzNTFtQ3huOU5NeWlhZ1A3?=
 =?utf-8?B?amlYV1NQTWE4a09ZLzloRzZNaC93Z1FqelFHcGRzU3ZaY2pVRks2SWEvekpN?=
 =?utf-8?B?WTVnUC9YUUdqdGx0enpiRkgzTFVmVXFFYnFDVDA5ZlZCQ2F5TmxXRStoVndq?=
 =?utf-8?B?VytJcDIwd2FqS244TnVkZTZ2WHh4dTdRR3ZxTFVoSFkrNDI2YmU2WkxCRnBY?=
 =?utf-8?B?NWFsZGwydTBPUEV6Q1FyUmtXdThWdlZYOXQ0VG1sQjZzdGNqdE5lQ0ZqSHA2?=
 =?utf-8?B?ZER5WnA4ZS9PZHF5cFlJcFNvMWRENlhpLzNsVGdqbDBJcDJOQmIyOVFLblha?=
 =?utf-8?B?aXMvcVMyaTI5N1VxUlVGV2VQdUhadEtBaVRleXNVWFVjUXhydThJQmgvOFNl?=
 =?utf-8?B?K3JHRzA1YUZybWlWU1VKK3ZmeWE1aFQ2V1JzdlVxM3M2bjAybmwwMGJyZkly?=
 =?utf-8?B?N2JVSlR0TkVMMVZ6bnhlVENkaFZGN3ZVMzJkakVjdUhXN0lHbExsRzgwK0FB?=
 =?utf-8?B?WjdjLzEyWFJYNFFxOFcwUTk4YTZBRmhScFdxckZOOGZFVHFwUFBUUVFBRmVP?=
 =?utf-8?B?QmJUNTNlRG5PU1RHSFVIZnl3ZmlYd1FQcHBFVzZVTGFpUnZUdFRIUUVsSXM4?=
 =?utf-8?B?MzVFUFNuUFkycUdFMWw5N0QvQnhiT1RzcTYyRStBa3dJb052M2NzalVLazdh?=
 =?utf-8?B?bnNMUzFIb2xiNHVRcWFMa1lkNFBJRS9PTnh4a2ltQVgzUXpoUXRkUS9aOCs3?=
 =?utf-8?B?MGhoWXlaSVRxUmtWUktPSGg0Zlh0WG8ydzF6S0JHMFZianFvcjQva1RMUjJu?=
 =?utf-8?B?Y3NYRjE3NW5wbkcvWXc1K3FjbjErYXNzZnM5ZVkrWElESTU5dXBHMmcvZnNs?=
 =?utf-8?B?c3dnVU1GbzhCcmFsNko2WmhZZEJpNUlIM3dRei94dlFXT3cxbzR6SFhpOFJm?=
 =?utf-8?B?YWFabzkxK3JkTlV1b3VVTmc3K1RCZTdFTVRhVDFqMUgrc0p5bWRjeG5iNEN0?=
 =?utf-8?Q?N+Ks=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc908b3-84ac-44f2-a900-08db31f4dc7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 14:33:14.3960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAsUln/u4d0FXGkp48WWZbh7jAS5CzPQJKwyHAdtudi6skBFjoUkX+Zf3xfAMcy+6uaqL600As8RMv2djvp4FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIDMwIE1hcmNoIDIwMjMgMjA6NDMN
Cj4gVG86IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0Pg0KPiBDYzogTGVvbiBS
b21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+OyBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5j
b20+Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBwYWJlbmlAcmVkaGF0LmNvbTsgZWR1bWF6ZXRA
Z29vZ2xlLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0IHYyIDEvNF0gdmxhbjogQWRkIE1BQ3NlYyBvZmZsb2FkIG9wZXJhdGlvbnMg
Zm9yIFZMQU4NCj4gaW50ZXJmYWNlDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24g
b3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IE9uIFRodSwgMzAgTWFyIDIw
MjMgMTk6MTk6MjEgKzAyMDAgU2FicmluYSBEdWJyb2NhIHdyb3RlOg0KPiA+IEkgZG9uJ3QgdGhp
bmsgeW91IHNob3VsZCBiZSByZXBvc3RpbmcNCj4gPiB1bnRpbCB0aGUgZXhpc3RpbmcgZGlzY3Vz
c2lvbiBoYXMgc2V0dGxlZCBkb3duLg0KPiANCj4gVGhhbmtzIGZvciB0aGF0IG5vdGUsIHZlcnkg
dHJ1ZSwgdjMgZGlzY2FyZGVkLg0KDQpTdXJlLCBJIHRob3VnaHQgaXQgd2FzIGNsb3NlZCBhZnRl
ciBMZW9uJ3MgcmVwbHksIHNvIEkgYWRkcmVzc2VkIHRoZSBjb21tZW50cyBhbmQgcmVwb3N0ZWQu
DQpNeSBiYWQuDQo=
