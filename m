Return-Path: <netdev+bounces-11905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C247350CD
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CFB0281030
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6E1C152;
	Mon, 19 Jun 2023 09:48:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60FBE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:48:07 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE731A8;
	Mon, 19 Jun 2023 02:48:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka0WNT+4ULvT+XAqg5J0EMhVcH9IX/N04gYmjs0Q5ck9b8+gL//hBZcERug/YzbVWjbRFYAjRIXippzY76sh2VMfziMwmGxaI+DirKbMBKBBAzaXt5eEQE37j6PfbGaeCbuZOqIFjMjkFc+L11SQUeIY68PsU45P/CckeQozkXxxLYiArHfR7f4R6ouxsBT8fGbjExZe2LQ52a6QvFoFcoRd/0zeF93xUGd2bpT16ngIJJj2AN186W2fOhj+Lm1jSh7BwaX8760InOWiUK/34Z/sn1V2XGp1lxAp1dFLxMnA8KObjlYQbLUvz0yx+q9UvqG0SO6oYOJyaoYtxBW5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SgsSS87+1UOGoTbd/wunjfEVKBIg41SFTW/GIOZd+dI=;
 b=OzQZMerH7khRCzaswlC3gncb9+64L/D8VSquUlq3ATEC1w1OECt6SfdhfEnhiEk2IrRhviZoVHq+GTRbOPKDORPZiypFqKjcTspeCqg/EDASgM1zn31gwSVJiR0pLyfKNdZeDa8RQPUmtD7AfGk5qwIJ1J12KFkOVFdJVy9SrbtLUNinrDM1q8XsEtQmPTzRlmq0IdA583gUVmpDfe3VODUZ5hWrsJPXEfB7N4wextf8I+CPWgwSj6v09Zqd2t/9+8oo9VgkqrU9g/4vR5BJiV/lJ23DkPi8bc1U7FHBODB05kKRgHFZCedZJkHPzReDEqzM25mQ9FWWlihm3hVRcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgsSS87+1UOGoTbd/wunjfEVKBIg41SFTW/GIOZd+dI=;
 b=Ot/QiHUQUvutL8rh+eEAu+h3Jova/DiuvXK+V7z9if342NfLdAUWnwT6Mc0hEIRpfvqFmrRsYnCt/0cF44fU99p289VXcTdWH8kLzUC/DvUD/2qdQCkoym1kjeV2V8UZGTP1RZ7kcl2QnCuv0xYbgnzJCkCA9rJ/RZZEs2GtPBc=
Received: from BN7PR12MB2835.namprd12.prod.outlook.com (2603:10b6:408:30::31)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:48:04 +0000
Received: from BN7PR12MB2835.namprd12.prod.outlook.com
 ([fe80::d277:e70c:5a24:45b6]) by BN7PR12MB2835.namprd12.prod.outlook.com
 ([fe80::d277:e70c:5a24:45b6%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:48:04 +0000
From: "Maftei, Alex" <alex.maftei@amd.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: "richardcochran@gmail.com" <richardcochran@gmail.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] selftests/ptp: Add -x option for testing
 PTP_SYS_OFFSET_EXTENDED
Thread-Topic: [PATCH net 1/2] selftests/ptp: Add -x option for testing
 PTP_SYS_OFFSET_EXTENDED
Thread-Index: AQHZoKTa8WeRAYs9nkac9J649TkaHa+R4okAgAACEwU=
Date: Mon, 19 Jun 2023 09:48:04 +0000
Message-ID:
 <BN7PR12MB28358D20A59F18F07E031652F15FA@BN7PR12MB2835.namprd12.prod.outlook.com>
References: <cover.1686955631.git.alex.maftei@amd.com>
 <e3e14166f0e92065d08a024159e29160b815d2bf.1686955631.git.alex.maftei@amd.com>
 <20230619093916.xxfkzj576hwz4tjq@soft-dev3-1>
In-Reply-To: <20230619093916.xxfkzj576hwz4tjq@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR12MB2835:EE_|IA1PR12MB6044:EE_
x-ms-office365-filtering-correlation-id: f26b8e1c-442d-4bb1-d2e3-08db70aa4733
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 nkD8tG8ZdPYjdYqq411vaV2B5cxaflvSJFW79RQlkdzGoZfvAlAqq0XzoJfL6VPggz/SBj48xN9dZLbX30yMiAWKgbZchIdc5u/RsNBYuP4xPxfkvS7pmtQD2NkQd1GKLQc5FWwKbQZPXdRB/azAtYBHgllnZbClp5SCq/Nn9SugHTs7HzSR6sSvUPEA5TnbQdMbT6oV0vasGqmcr1u6qG0u7Cvr56UwBfzhWmfxftrm6yYZSGzWb2QaFD+0wU57ZjT0HQDvnQxAYYVgWsX3jXyW4m3FD8S256Ny9qvFeKAJSE6CdB52jhqq7cqwUKlp1nil9mrqow2F4BzspZdkm1NaYfE/XejceLNXkc2PHxwjwJzMARK+8y7Av7EJlOEu59Gt3JDCzycuGhqI9Rja77qkgm/wZWMyH4qTg0TB3AiJuQt46k3DS1q4mKhkjNLbqKLCmC837RdkEG+yPjyGrX9Tglec71p81aRkjqRC5AYh18ojTMDJPNL8yLOUEHLCqUTrHFi+IETU3lfQfuEFLCODX6lBmyIWqtKsavzgQ+/EX8S8DQWO4AiBHUJ+Th7NEu5uis+v7/4IsrhnbnY2cJ7df4hOGEnnPDwi7uajS8FNbGByTwrdi6IUx2CZAKgy
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(66946007)(8936002)(8676002)(66556008)(64756008)(76116006)(66446008)(66476007)(38070700005)(26005)(186003)(6506007)(9686003)(41300700001)(38100700002)(91956017)(5660300002)(4326008)(6916009)(316002)(52536014)(54906003)(7696005)(558084003)(55016003)(478600001)(2906002)(33656002)(122000001)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?SqmzW0AGL+GHAFYVktTnrUeqpcJrsw6FohZi7KiG21KImES1glbZ5F5XWy?=
 =?iso-8859-1?Q?sgGSVQHNZUE1Swh0er/yGSJMm0ubInCbsa8/CpT+9FnfajUc9/yhfgOtlv?=
 =?iso-8859-1?Q?7yy8eK1VwF44ZVRlI4/7adKJcVMoHgK3WChKATumVUfa/LQt4aJa5BG/s4?=
 =?iso-8859-1?Q?Z2LC49phgNkOal/UzZTT9VlthHJ3Q+H8EogUg97t2WRJNfTZQQ6FGYKny7?=
 =?iso-8859-1?Q?gAPHusLFG2BX5hKK0b2OvZx7FByB/TX165/rlZkPD0thr3SoUktHCeQbwE?=
 =?iso-8859-1?Q?vSqOnC50ry81N/GRRWZWHrLDkcczxe9U/CFPUjmZbtkNhxjoD/+Z1mN9i8?=
 =?iso-8859-1?Q?nvWz4hZxNFitQOo4WFaRb/DMsQbb1PDrL6SmKvqHURe3nyeAuAthrl7S2O?=
 =?iso-8859-1?Q?XZom4zfiI2KHoWGcbb51+KriD8jrAznoCTZ7vL+IZPv7SIn958s5Mft/8K?=
 =?iso-8859-1?Q?X+QATqwc/v/AeSpU1SzJBNDjRZT0A5zo+d1a6GJ8PC3gA5uWMjR+Cbwgzl?=
 =?iso-8859-1?Q?4QpGwt8V3fujmkRTwLICnP4erXI99x6hULoq9Sghyoq/P6vCPO2Wi9hZVZ?=
 =?iso-8859-1?Q?hZfhYLqWQsVDPt77OEwT3L5IdO8VxWg8tY2qGXv2q+7YdXPET7sKOP5f2T?=
 =?iso-8859-1?Q?pp4jkZMyXRqgcl9HOtUC7ZN2oGXL8bwVdwQ7pPuKKSCHxvgg5mjM1iW27A?=
 =?iso-8859-1?Q?YbkzJQ8+sFiNPizlm5jP65sDvZ3yu8NZCwcKVsNnsy2rIh0Tu1SyDm4csZ?=
 =?iso-8859-1?Q?pjlxR24Fc2sOEn+1WTgGqG7bk/F8yOAUOuEhx2/OYCmRbqeCQWOmTE2qNI?=
 =?iso-8859-1?Q?hNk6q2tGEx327TmJML/cDLC2uHh0sDiuuSj3hWB4gYyIUlTEW82ak3pxih?=
 =?iso-8859-1?Q?cpMZBYmKpOJ6uWA79U0dtWsa4eTkhzK77NS2/0sNK4QcraMAe0Y/sQQoj+?=
 =?iso-8859-1?Q?UztVep4J6p4DSirlDtX+M5BWS0MJlkBQkTbtCMtwiOhgNpmCujiZJGO0bH?=
 =?iso-8859-1?Q?mjYpzgg8BUmtLbz5B/Vmw4Ym1JO4D6s2WR0HeKYIgwWAZan0xqHsLsI8X2?=
 =?iso-8859-1?Q?BBGW9OFJvZwxHfTTZozWO2jFBX6gsw6Mcr16f/4Fh/5An3TYg9zGqor/ru?=
 =?iso-8859-1?Q?GmIhPvRABjJS6EWs8YXS5VOCcJemb9i7xJZuF3KcvU8SMyYdi6swH/P3rJ?=
 =?iso-8859-1?Q?ozSIZvB/uoXENvCfv8cx6/NT6JkgdTOlgaAoLuTY/fFHVC+gz/L6eR+SSw?=
 =?iso-8859-1?Q?I/+xhmSR71EplyvBkbfgmRdubWU9+AUQYiwjr+KOWKcjZKAGd9ELw72qAY?=
 =?iso-8859-1?Q?22UIl7mHruqXWGlQKpme32iW9NRv1otRuc62Oe578zsYdDv3viOro6aesf?=
 =?iso-8859-1?Q?58PtHk2OGS6jbcjrpNNsG+CnWLsWdUFQBc/tTr0x+q72TS9hhd6DWKZr9/?=
 =?iso-8859-1?Q?hkL2PoWsRfVVJiof8EK0TFNNPEx6G6uOgXIj/iG389uU0RZ/sLGooKQ+ZS?=
 =?iso-8859-1?Q?O4FMUX4WiYvR7cZkjBSibKybQFGYjOeaWsuz6xcGwAPBI2ywZdRDtKoYAY?=
 =?iso-8859-1?Q?TjmBgjcjZPDsvR5xh95prx6JfbGMMqb8F0/SfbHvD3pg9LFmDVYRHgg+8b?=
 =?iso-8859-1?Q?jyhc55TzCCMOU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f26b8e1c-442d-4bb1-d2e3-08db70aa4733
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:48:04.3906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZ3q9TN1NVJn9WYAH0jSLrO2S3H9hjy9oubemILJBWwlX1HoCdvnuTZ6m1VK+6QA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Horatiu,=0A=
=0A=
v2 of the series will have that fixed.=0A=
I've accidentally sent an older revision of this patch series, before I've =
rebased the changes properly.=0A=

