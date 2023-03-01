Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C6E6A7417
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 20:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCATOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 14:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCATOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 14:14:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFACA34015
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 11:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGbxd/IfMHQdKSNPZCj2p4+G31SrjZoo+TCTSaPw2SbpuYu/IYfJnZ5z0S1v80F+kUwTFnkPJi9Id3W5xd2mJjkJvtPCXFGbOQjKNuuPUq5eUFDSnZ1wrOrK7yGWfFsYbHazn+oaA0fZ9I6ZKJl4FXQSWejs+rT22A4P5xk3FG7g1AQvMBfsfAi/AqQ17yIgk6Y+d76yhwNGkhfFh95cFriHDUihy98mJ9hafswqskA0H3ZhrPTMBKCtwGfNcLy+szHLkuoR0Fwch+hbP/d80x7dJ84iuc45RCraqAjyR7lJuEowkMToMutkmEwk25pSHojzNifPvMQu1AEM6KvKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Fvi/SXGHyJaIpUxXGYGu5j4SLXYPEGoedr5kEylJEs=;
 b=VVqHCvhWvRX1uUPrD/a27WwPGA1HJUdsbg4GyABSAaemoSwyoH8CEw6T4jfWjdg4d72yLagPm3z/+8N+VidtShB9sdYPBgJmyUS2lz+kbXgodlei9jWcZyPN21UOmRgKYKuOzeWsU+gfnZ5ZqG1YeBQtcAd90+r0Ik5yHjQPyuORTis2HSbC1jq0+BqP9recv7fKaYDBK4iVCLkNUI2QiRLjMMWCiZSwGm293uzKH+N/7rOq89bnejxFbLwOaLg+jNHSmq+h7B7z20OtZHYiETpcbeaOeeos5G8t8ykVstZnJuWFG/9gkbFoOPmh2RMr1g7W/yO+9Ue6cgLImj5QPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Fvi/SXGHyJaIpUxXGYGu5j4SLXYPEGoedr5kEylJEs=;
 b=EMhRhBtHF2HF6HatXWYoSuPa4gTWjatY3zbs6aKbaggy/RQLWsmDHCSEgNkFlNURZ6wI7nDRNijGT2P3XOGUEB6bPNyS/V1zxTk1GmYbE11q4kpO8/Of+dvYJ7UnRCAyO4Ap9Be2Xy1nCzMlnlsr8aE7BOyZ6Lauj8kA8Q/pIRKM16uifFXL6EWPCz7l1MTwnL6MwPW27kJSTGcQnwwRxxsl0hMYK7zgpcP0w0aI08jXhmWJEdJiPq3pzrVRPLwK1oab29Q3hlxFFyrspzp3dLrDqm3dxaAZO6LU2hFO7yrASjKJs6iRv5h3x4V25F+juwM7AxKPojZW4Q3RqZMBMw==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 19:13:58 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::d9b6:bf16:d587:f197]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::d9b6:bf16:d587:f197%7]) with mapi id 15.20.6134.029; Wed, 1 Mar 2023
 19:13:58 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Aurelien Aptel <aaptel@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: RE: [PATCH v11 00/25] nvme-tcp receive offloads
Thread-Topic: [PATCH v11 00/25] nvme-tcp receive offloads
Thread-Index: AQHZN9M7Fai+5L75rUm8i2XK7+RWMK7cyMEAgAmlGBA=
Date:   Wed, 1 Mar 2023 19:13:58 +0000
Message-ID: <DM6PR12MB3564B3D0D489B7F4325E69D9BCAD9@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
 <72746760-f045-d7bc-1557-255720d7638d@grimberg.me>
In-Reply-To: <72746760-f045-d7bc-1557-255720d7638d@grimberg.me>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|BL1PR12MB5144:EE_
x-ms-office365-filtering-correlation-id: 08301b6c-5e38-4104-0fb4-08db1a891be3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qd1bNbLhttiG4ujqTSiDo9SLc8A9qWooZ56dX/I/DTbtIQAeCKJhc2szZEycc16F11x/AWUFD5bcL+uSoqsOBirMUkbURvPUgDJoGlUtIGULlbQmvXPeS0OoSJVR3cV4PNQAbqajCU+F9FSnJnBqd8h87V9wv8jbKnLJMM2RILdweWwaLUAX1t6P51wkWWSkloJYIQA8a3Qssqq9Tw4SbQuZeGHxMde9QY+Gz2pB6lte7X5wGIw3KWti0oxXfH/d6iAUDsyAcGLy4yGOaEvDsT0AqNtbPmLHeGUGza1tdN1VnpoHzF6MIRmtRqsHbZjyVwOUaowvRNht6HaIFJgZX7zVjwU+TbON01N3exYy5H7G7RxxMvDt9U+2xIVCwK7LR/yVexGhBBgAUt9f6zLaWgLhF6XNc+i7JWhGC1Ry8TXj1/URsZ8MMunScTl73TnAjzNgedmTUmTFcG0t1y6kl5rouWX1zV+laL+JzaUZaD3r4bhMQ2EV+FMiXqbZrUfK6LaGuS5IXp+mZlswQTOvEA5LambNjAUfWG+F4Ovrav71OFd/oei1c26dopxMtk34dritii6IOOfkDYZS+1gqI6OgZTKYhTr1N5Dz0I2kE0PxjUkxuib4OY/5OriiX9YFfHHHv27/sdW0dwz5iPQILOTK56kehMNPXl1XlOraIaWrNASpplsszTGHdLGfZqMyD5k/eBQYpWEy9PZztKYkbyCZYd+VaHngg2Vdlva94N8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199018)(478600001)(83380400001)(110136005)(54906003)(316002)(33656002)(4326008)(122000001)(66446008)(64756008)(8676002)(55016003)(38100700002)(66476007)(76116006)(6506007)(9686003)(26005)(7696005)(107886003)(71200400001)(5660300002)(7416002)(66556008)(52536014)(66946007)(8936002)(186003)(2906002)(41300700001)(38070700005)(86362001)(921005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDh0VDgvT2xpQTZzYmhwTWtIQTVkRVpKZ3Z4dG5KUS9jdXZ4eGxnMUlJZkVV?=
 =?utf-8?B?UitBSzgyUGNDVjJVMnpxYTBVNS9NbWd4L2pCSy9RNWF0cytJNCt0ZnJ3ZTcv?=
 =?utf-8?B?TmZBVmRTTEh5ZnB0VW1EVGxIN2U2ZVJIWUc2WDgrOVV5NjVWbVhSaWxEeDVQ?=
 =?utf-8?B?d0NFcWc5WDBTNmxhbE05MUJDa0RpYndpclZFeEFGUlhxZmJQT0lZU3dybFZU?=
 =?utf-8?B?RVg0Z21IRUthdVhxZms0OGRJZ2FqMWQ5YkdZNExSWmIvWEhiM1NUQlJCWDk4?=
 =?utf-8?B?Qk5uQUQ3d2NmVGdWeTV2UVpUaEc1cmQ1dE5OQllSWnlQWTlCeC8zczc4ZlhX?=
 =?utf-8?B?ajN0bkVXRisyOHZKcWxnMG5ad29EUjlQV3dkR285UlpKaVArVkpsS1NQc1Jr?=
 =?utf-8?B?Ni9keGdzelhVRzV2SHBuams5UmJyMDUyQ0lyeW1LdnVsZDYzUlhnejZvQmw4?=
 =?utf-8?B?N2NlU0F6bUtNTmIycmNPa0ZCNHZVK052M2h5QThZeVJKOWpDei9wSEEwazJY?=
 =?utf-8?B?NkdaeTFLRmExbENaRnVnK2pwcERWckU0c3oybGZlcGZBcmhqaEFpM21FYjFj?=
 =?utf-8?B?aHJwUXY1NmFySmk1ZE5xSDhBMU5vSzYrN0gvVE5Kd05jeEowYTRheC9SUnA1?=
 =?utf-8?B?YVQzcHZXOGNpMVNIM24rckNtT29pZGV0MXlUWm4xZjBmM1pzNkNKT2ZMbHpS?=
 =?utf-8?B?TDVZVU8wK2RSa2VPM3RWaXlSd01Ma1RKa2M2czZCYzJQV2ZlTGJWeHcyL3FJ?=
 =?utf-8?B?cHgwVXBodUdWS0F6MThTYTk5Sk9zd3kxYUJVTWNMOFVLcjdQRFBFYTJVQy9Z?=
 =?utf-8?B?VVpwMUhGejN6cVlQcXBqWnVjWFo4OG5neDVwTHFyUlBtREtnZUpEMVBkZ1Rr?=
 =?utf-8?B?YytIT1RRblAxRm9NWXB3dUdZT2s4Z211TmlkOXhRYittZGl5NjlCRjlnelhF?=
 =?utf-8?B?QldVZ1BMV0lBZzFsTmVORTdaYmFqMXNTcE0wZ2NYd05mVHEzbitBTUhEV3E3?=
 =?utf-8?B?Uk1PR1BQdVh4M0xvK1VpNEN1aVZhRUwzL01mZzNlVGM4WlpxS3NBK3FYL1JH?=
 =?utf-8?B?UnhWZGhGWm1yMTZRTGNDdUhKeE9SK0pDZHNKaU5NSDI4U3l5NzNPU0VTSnpx?=
 =?utf-8?B?MTVrcmNRT1lrSC9paWd2QzQzalIzYnNxYXh6MmdlV3ZFOEMwdVFObEtjT21l?=
 =?utf-8?B?djlCdTlaU2poR0FtV0ZYanVVUWhXRVlSVHgvWXFLWVVWR2Z3UDM4TGlqcytJ?=
 =?utf-8?B?K3BxZ1pDYjZPQktiSUp1WUVHTUdXYUlBbmhiYlhNNGQzM1lNMTc2WmdWVENR?=
 =?utf-8?B?UGE5YmIySXlSOWtrREVwRGR5Rk9vbTdCKy9HUFRDbHc3MDZpRHJyc21WSCsz?=
 =?utf-8?B?RUxuYW4zdmh4S25Mb3VLRHJZcmZWQ3dqVEgySTVua1dwelk2cGhsdHdZd0Z6?=
 =?utf-8?B?ejBOMHJyUlNkbzZSQlo1YWxqMlVxZGZXOVlqdVBGS2hML0t5SElka0djZ0x5?=
 =?utf-8?B?TDdxK3VablJ1eENvV0ZxWmR0aVV0MG11eHBNclBiR2tJeHE1SHMycEVNN2tH?=
 =?utf-8?B?cUxGc3lPUDdZVkNpU09JMnZTams2bG16ZTdSRy92S1FWbVN6dGUwdDZkSHpL?=
 =?utf-8?B?VDZ2d3p3TWE5SEJES0kyUEFDNlRaZWFKclBjZ1FFSFJxeUkzRXdmdnIxK1A2?=
 =?utf-8?B?cXlEb0dkV2NkWGk5aXE3RXZSVHlwYitoYmtaREFJVEZDczU0LzFjTCtiL095?=
 =?utf-8?B?eFI3L2lET29RZUdYUUJFWkoydzNURkU2dGtEdnZVN3NkRmh5RnR6a0VBNTFW?=
 =?utf-8?B?VTNFMmxodE9zRVowZDVFczRiSEo0UTNsT2tTVzVRYks3bElVQkFSMERtaDVw?=
 =?utf-8?B?YkV2RnFweFhyUENoQURPTEd0SmY1cTFvdUlvUGtDa01UQ0FQUjJCNzRUZlNM?=
 =?utf-8?B?ZmlBbS9wWDFJeWx4ZEx4NzJqSENYRmdYOUNxRnluY2xRYVNUL2J2RkdKQnZq?=
 =?utf-8?B?ZEszWG5XbVg5UHJSZFMxc2t5U01FM0FVbi9CdkJoU2xwZE03dkgxc2E5a2NV?=
 =?utf-8?B?cGltN0s4T3h5djF5bUtiU3NhWkhIdVpTdjQ1MUJ1dngyeTBHWFZSREhORXBK?=
 =?utf-8?Q?+JkDkZOcBulZ3w9zPxZyInKxt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08301b6c-5e38-4104-0fb4-08db1a891be3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 19:13:58.3451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UkGc82K5Oo9xGvjZFrQLjca2K5zTX7vTEyzAMtQwv0lU4tPmjK6AIsDreE/jyRXnMvWyirbfCanTFmDUROBdUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FnaSwNCg0KT24gVGh1LCAyMyBGZWIgMjAyMywgU2FnaSBHcmltYmVyZyA8c2FnaUBncmlt
YmVyZy5tZT4gd3JvdGU6DQo+IEhleSBBdXJlbGllbiBhbmQgQ28sDQo+IA0KPiBJJ3ZlIHNwZW50
IHNvbWUgdGltZSB0b2RheSBsb29raW5nIGF0IHRoZSBsYXN0IGl0ZXJhdGlvbiBvZiB0aGlzLA0K
PiBXaGF0IEkgY2Fubm90IHVuZGVyc3RhbmQsIGlzIGhvdyB3aWxsIHRoaXMgZXZlciBiZSB1c2Vk
IG91dHNpZGUNCj4gb2YgdGhlIGtlcm5lbCBudm1lLXRjcCBob3N0IGRyaXZlcj8NCj4gDQo+IEl0
IHNlZW1zIHRoYXQgdGhlIGludGVyZmFjZSBpcyBkaWVzaWduZWQgdG8gZml0IG9ubHkgYSBrZXJu
ZWwNCj4gY29uc3VtZXIsIGFuZCBhIHZlcnkgc3BlY2lmaWMgb25lLg0KDQpBcyBwYXJ0IG9mIHRo
aXMgc2VyaWVzLCB3ZSBhcmUgb25seSBjb3ZlcmluZyB0aGUga2VybmVsIG52bWUtdGNwIGhvc3Qg
ZHJpdmVyLg0KVGhlIFVMUCBsYXllciB3ZSBhcmUgaW50cm9kdWNpbmcgd2FzIGRlc2lnbmVkIGFs
c28gZm9yIG90aGVyIGtlcm5lbCBkcml2ZXJzIA0Kc3VjaCBhcyB0aGUga2VybmVsIG52bWUtdGNw
IHRhcmdldCBhbmQgaVNDU0kuDQoNCj4gDQo+IEhhdmUgeW91IGNvbnNpZGVyZWQgdXNpbmcgYSBt
b3JlIHN0YW5kYXJkIGludGVyZmFjZXMgdG8gdXNlIHRoaXMNCj4gc3VjaCB0aGF0IHNwZGsgb3Ig
YW4gaW9fdXJpbmcgYmFzZWQgaW5pdGlhdG9yIGNhbiB1c2UgaXQ/DQoNClRoZSBtYWluIHByb2Js
ZW0gd2hpY2ggSSB3aWxsIGV4cGxhaW4gaW4gbW9yZSBkZXRhaWwgKHVuZGVyIHRoZSBkaWdlc3Qs
IA0KdGVhcmRvd24gYW5kIHJlc3luYyBmbG93cykgaXMgdGhhdCBpbiBvcmRlciB0byB1c2UgYSBt
b3JlIHN0YW5kYXJkIGludGVyZmFjZSANCnRoYXQgd2lsbCBoaWRlIHdoYXQgdGhlIEhXIG5lZWRz
IGl0IHdpbGwgcmVxdWlyZSBkdXBsaWNhdGluZyB0aGUgTlZNZVRDUA0KbG9naWMgb2YgdHJhY2tp
bmcgdGhlIFBEVXMgaW4gdGhlIFRDUCBzdHJlYW0g4oCTIHRoaXMgc2VlbXMgd3JvbmcgdG8gdXMu
DQoNCkkgY2FuIGFkZCB0aGF0IHdlIGFyZSBhbHNvIHdvcmtpbmcgb24gYW4gZW5kLXRvLWVuZCB1
c2VyLXNwYWNlIGRlc2lnbiBmb3IgU1BESw0KYW5kIHdlIGRvbuKAmXQgc2VlIGhvdyB0aGUgdHdv
IGRlc2lnbnMgY291bGQgdXNlIHRoZSBzYW1lIHNvY2tldCBBUElzIHdpdGhvdXQgDQppbXBhY3Rp
bmcgdGhlIHBlcmZvcm1hbmNlIGdhaW4gb2YgYm90aCBjYXNlcy4NCg0KPiANCj4gVG8gbWUgaXQg
YXBwZWFycyB0aGF0Og0KPiAtIGRkcCBsaW1pdHMgY2FuIGJlIG9idGFpbmVkIHZpYSBnZXRzb2Nr
b3B0DQo+IC0gc2tfYWRkL3NrX2RlbCBjYW4gYmUgZG9uZSB2aWEgc2V0c29ja29wdA0KPiAtIG9m
ZmxvYWRlZCBEREdTVCBjcmMgY2FuIGJlIG9idGFpbmVkIHZpYSBzb21ldGhpbmcgbGlrZQ0KPiAg
ICBtc2doZHIubXNnX2NvbnRyb2wNCg0KSWYgd2Ugd2lzaCB0byBoaWRlIGl0IGZyb20gdGhlIE5W
TWVUQ1AgZHJpdmVyIGl0IHdpbGwgcmVxdWlyZSB1cyB0byBkdXBsaWNhdGUgDQp0aGUgTlZNZVRD
UCBsb2dpYyBvZiB0cmFja2luZyB0aGUgUERVcyBpbiB0aGUgVENQIHN0cmVhbS4NCkluIHRoZSBw
b3NpdGl2ZSBjYXNlLCB3aGVuIHRoZXJlIGFyZSBubyBEREdTVCBlcnJvcnMsIG5vdGhpbmcgaXMg
bmVlZGVkIHRvIGJlIA0KZG9uZSBpbiB0aGUgTlZNZVRDUCBkcml2ZXIsIGJ1dCBpbiB0aGUgY2Fz
ZSBvZiBlcnJvcnMgKG9yIGp1c3QgaW4gdGhlIGNhc2Ugb2YgDQpvdXQgb2Ygb3JkZXIgcGFja2V0
IGluIHRoZSBtaWRkbGUgb2YgdGhlIFBEVSksIHRoZSBEREdTVCB3aWxsIG5lZWQgdG8gYmUgDQpj
YWxjdWxhdGVkIGluIFNXIGFuZCBpdCBzZWVtcyB3cm9uZyB0byB1cyB0byBkdXBsaWNhdGUgaXQg
b3V0c2lkZSBvZiB0aGUgDQpOVk1lVENQIGRyaXZlci4NCg0KPiAtIFBlcmhhcHMgZm9yIHNldHRp
bmcgdXAgdGhlIG9mZmxvYWQgcGVyIElPLCByZWN2bXNnIHdvdWxkIGJlIHRoZQ0KPiAgICB2ZWhp
Y2xlIHdpdGggYSBuZXcgbXNnIGZsYWcgTVNHX1JDVl9ERFAgb3Igc29tZXRoaW5nLCB0aGF0IHdv
dWxkIGhpZGUNCj4gICAgYWxsIHRoZSBkZXRhaWxzIG9mIHdoYXQgdGhlIEhXIG5lZWRzICh0aGUg
Y29tbWFuZF9pZCB3b3VsZCBiZSBzZXQNCj4gICAgc29tZXdoZXJlIGluIHRoZSBtc2doZHIpLg0K
DQpPdXIgZGVzaWduIGluY2x1ZGVzIHRoZSBmb2xsb3dpbmcgc3RlcHMgcGVyIElPOg0KLSBkZHBf
c2V0dXAgKHJlZ2lzdGVyIHRoZSBjb21tYW5kIGlkIGFuZCBidWZmZXIgdG8gdGhlIEhXKQ0KLSBU
aGUgZXhpc3RpbmcgZmxvdyB3aGljaCBzZW5kcyB0aGUgY29tbWFuZA0KLSBUaGUgZXhpc3Rpbmcg
ZmxvdyBvZiByZWFkX3NvY2soKQ0KLSBkZHBfdGVhcmRvd24gKGZvciB0aGUgcGVyIElPIEhXIHRl
YXJkb3duLCBiZWZvcmUgcG9zdGluZyB0aGUgTlZNZSBjb21wbGV0aW9uKQ0KDQpVc2luZyB0aGUg
cmVjdm1zZyB3aWxsIG9ubHkgcmVwbGFjZSB0aGUgcmVhZF9zb2NrKCkgYnV0IHRoaXMgcGFydCBp
biB0aGUgTlZNZVRDUCANCmRyaXZlciBpcyBub3QgaW1wYWN0ZWQgYnkgdGhlIG9mZmxvYWQgZGVz
aWduLg0KVGhlIGRkcF9zZXR1cCBpcyBuZWVkZWQgaW4gb3JkZXIgdG8gc2V0IHRoZSBjb21tYW5k
IGlkIGFuZCB0aGUgYnVmZmVyLCBhbmQgdGhpcyANCm5lZWRzIHRvIGJlIGRvbmUgYmVmb3JlIG9y
IGFzIHBhcnQgb2YgdGhlIHNlbmRpbmcgb2YgY29tbWFuZCBhbmQgcHJpb3IgdG8gdGhlIA0KcmVj
ZWl2ZSBmbG93Lg0KSW4gYWRkaXRpb24sIHdpdGhvdXQgZHVwbGljYXRpbmcgdGhlIHRyYWNraW5n
IG9mIHRoZSBQRFVzIGluIHRoZSBUQ1Agc3RyZWFtLCANCml0IGlzIG5vdCBwb3NzaWJsZSB0byBo
aWRlIHRoZSB0ZWFyZG93biBmbG93IGZyb20gdGhlIE5WTWVUQ1AgZHJpdmVyLg0KDQo+IC0gQW5k
IGFsbCBvZiB0aGUgcmVzeW5jIGZsb3cgd291bGQgYmUgc29tZXRoaW5nIHRoYXQgYSBzZXBhcmF0
ZQ0KPiAgICB1bHAgc29ja2V0IHByb3ZpZGVyIHdvdWxkIHRha2UgY2FyZSBvZi4gU2ltaWxhciB0
byBob3cgVExTIHByZXNlbnRzDQo+ICAgIGl0c2VsZiB0byBhIHRjcCBhcHBsaWNhdGlvbi4gU28g
dGhlIGFwcGxpY2F0aW9uIGRvZXMgbm90IG5lZWQgdG8gYmUNCj4gICAgYXdhcmUgb2YgaXQuDQoN
ClRoZSByZXN5bmMgZmxvdyByZXF1aXJlcyBhd2FyZW5lc3Mgb2YgVENQIHNlcXVlbmNlIG51bWJl
cnMgYW5kIE5WTWUgDQpQRFVzIGJvdW5kYXJpZXMuIElmIHdlIGhpZGUgaXQgZnJvbSB0aGUgTlZN
ZVRDUCBkcml2ZXIgd2Ugd291bGQgaGF2ZSANCnRvIGFnYWluIGR1cGxpY2F0ZSBOVk1lIFBEVSB0
cmFja2luZyBjb2RlLg0KVExTIGlzIGEgc3RyZWFtIHByb3RvY29sIGFuZCBtYXBzIGNsZWFubHkg
dG8gVENQIHNvY2tldCBvcGVyYXRpb25zLg0KTlZNZVRDUCBvbiB0aGUgb3RoZXIgaGFuZCBpcyBh
IHJlcXVlc3QtcmVzcG9uc2UgcHJvdG9jb2wuIA0KT24gdGhlIGRhdGEgcGF0aCwgaXQncyBub3Qg
Y29tcGFyYWJsZS4NCldoaWxlIGl0IGNvdWxkIGJlIGRvbmUgYnkgY29udG9ydGluZyByZWN2bXNn
KCkgd2l0aCBuZXcgZmxhZ3MsIGFkZGluZyBpbnB1dCANCmZpZWxkcyB0byB0aGUgbXNnaGRyIHN0
cnVjdCBhbmQgY2hhbmdpbmcgdGhlIGJlaGF2aW91ciBvZiB1QVBJLCBpdCB3aWxsIGFkZCANCmEg
bG90IG1vcmUgZnJpY3Rpb24gdGhhbiBhIHNlcGFyYXRlIFVMUCBERFAgQVBJIHNwZWNpZmljYWxs
eSBtYWRlIGZvciB0aGlzIA0KcHVycG9zZS4NCg0KPiANCj4gSSdtIG5vdCBzdXJlIHRoYXQgc3Vj
aCBpbnRlcmZhY2UgY291bGQgY292ZXIgZXZlcnl0aGluZyB0aGF0IGlzIG5lZWRlZCwNCj4gYnV0
IHdoYXQgSSdtIHRyeWluZyB0byBjb252ZXksIGlzIHRoYXQgdGhlIGN1cnJlbnQgaW50ZXJmYWNl
IGxpbWl0cyB0aGUNCj4gdXNhYmlsaXR5IGZvciBhbG1vc3QgYW55dGhpbmcgZWxzZS4gUGxlYXNl
IGNvcnJlY3QgbWUgaWYgSSdtIHdyb25nLg0KPiBJcyB0aGlzIGRlc2lnbmVkIHRvIGFsc28gY2F0
ZXIgYW55dGhpbmcgZWxzZSBvdXRzaWRlIG9mIHRoZSBrZXJuZWwNCj4gbnZtZS10Y3AgaG9zdCBk
cml2ZXI/DQoNCkFzIHBhcnQgb2YgdGhpcyBzZXJpZXMsIHdlIGFyZSB0YXJnZXRpbmcgdGhlIGtl
cm5lbCBudm1lLXRjcCBob3N0IGRyaXZlciwgDQphbmQgbGF0ZXIgd2UgYXJlIHBsYW5uaW5nIHRv
IGFkZCBzdXBwb3J0IGZvciB0aGUga2VybmVsIG52bWUtdGNwIHRhcmdldCBkcml2ZXIuDQoNClRo
ZSBVTFAgbGF5ZXIgd2FzIGRlc2lnbmVkIHRvIGJlIGdlbmVyaWMgZm9yIG90aGVyIHJlcXVlc3Qt
cmVzcG9uc2UgYmFzZWQgDQpwcm90b2NvbHMuDQoNCj4gDQo+ID4gQ29tcGF0aWJpbGl0eQ0KPiA+
ID09PT09PT09PT09PT0NCj4gPiAqIFRoZSBvZmZsb2FkIHdvcmtzIHdpdGggYmFyZS1tZXRhbCBv
ciBTUklPVi4NCj4gPiAqIFRoZSBIVyBjYW4gc3VwcG9ydCB1cCB0byA2NEsgY29ubmVjdGlvbnMg
cGVyIGRldmljZSAoYXNzdW1pbmcgbm8NCj4gPiAgICBvdGhlciBIVyBhY2NlbGVyYXRpb25zIGFy
ZSB1c2VkKS4gSW4gdGhpcyBzZXJpZXMsIHdlIHdpbGwgaW50cm9kdWNlDQo+ID4gICAgdGhlIHN1
cHBvcnQgZm9yIHVwIHRvIDRrIGNvbm5lY3Rpb25zLCBhbmQgd2UgaGF2ZSBwbGFucyB0byBpbmNy
ZWFzZSBpdC4NCj4gPiAqIFNXIFRMUyBjb3VsZCBub3Qgd29yayB0b2dldGhlciB3aXRoIHRoZSBO
Vk1lVENQIG9mZmxvYWQgYXMgdGhlIEhXDQo+ID4gICAgd2lsbCBuZWVkIHRvIHRyYWNrIHRoZSBO
Vk1lVENQIGhlYWRlcnMgaW4gdGhlIFRDUCBzdHJlYW0uDQo+IA0KPiBDYW4ndCBzYXkgSSBsaWtl
IHRoYXQuDQoNClRoZSBhbnN3ZXIgc2hvdWxkIGJlIHRvIHN1cHBvcnQgYm90aCBUTFMgb2ZmbG9h
ZCBhbmQgTlZNZVRDUCBvZmZsb2FkLCANCndoaWNoIGlzIGEgSFcgbGltaXQgaW4gb3VyIGN1cnJl
bnQgZ2VuZXJhdGlvbi4NCg0KPiANCj4gPiAqIFRoZSBDb25uZWN0WCBIVyBzdXBwb3J0IEhXIFRM
UywgYnV0IGluIENvbm5lY3RYLTcgdGhvc2UgZmVhdHVyZXMNCj4gPiAgICBjb3VsZCBub3QgY28t
ZXhpc3RzIChhbmQgaXQgaXMgbm90IHBhcnQgb2YgdGhpcyBzZXJpZXMpLg0KPiA+ICogVGhlIE5W
TWVUQ1Agb2ZmbG9hZCBDb25uZWN0WCA3IEhXIGNhbiBzdXBwb3J0IHR1bm5lbGluZywgYnV0IHdl
DQo+ID4gICAgZG9u4oCZdCBzZWUgdGhlIG5lZWQgZm9yIHRoaXMgZmVhdHVyZSB5ZXQuDQo+ID4g
KiBOVk1lIHBvbGwgcXVldWVzIGFyZSBub3QgaW4gdGhlIHNjb3BlIG9mIHRoaXMgc2VyaWVzLg0K
PiANCj4gYm9uZGluZy90ZWFtaW5nPw0KDQpXZSBhcmUgcGxhbm5pbmcgdG8gYWRkIGl0IGFzIHBh
cnQgb2YgdGhlICJpbmNyZW1lbnRhbCBmZWF0dXJlIi4gDQpJdCB3aWxsIGZvbGxvdyB0aGUgZXhp
c3RpbmcgZGVzaWduIG9mIHRoZSBtbHggSFcgVExTLg0KDQo+IA0KPiA+DQo+ID4gRnV0dXJlIFdv
cmsNCj4gPiA9PT09PT09PT09PQ0KPiA+ICogTlZNZVRDUCB0cmFuc21pdCBvZmZsb2FkLg0KPiA+
ICogTlZNZVRDUCBob3N0IG9mZmxvYWRzIGluY3JlbWVudGFsIGZlYXR1cmVzLg0KPiA+ICogTlZN
ZVRDUCB0YXJnZXQgb2ZmbG9hZC4NCj4gDQo+IFdoaWNoIHRhcmdldD8gd2hpY2ggaG9zdD8NCg0K
S2VybmVsIG52bWUtdGNwIGhvc3QgZHJpdmVyIGFuZCBrZXJuZWwgbnZtZS10Y3AgdGFyZ2V0IGRy
aXZlci4NCg0K
