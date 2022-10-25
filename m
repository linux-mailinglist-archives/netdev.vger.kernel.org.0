Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28B60CA3C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiJYKlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiJYKls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:41:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBE55245D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:41:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7Ld5hpe8nJNQIgO80QvRYXbUPq569IhdGVXVFpsA4mY1wn5RAHsjwJUSWyIMYaHLCDOpU+D0PFiLRxKPic1ue1Bfzs54u0QVr79Is2/hOqpoTY92ghITSmJFuy/LlYFqqBwNgjF6Eua9AN2l4j89p/IRFxEPrin83GDmKONCG8KYMdwAbvV1Yo2VFLslHQaMtsnEAQ0b2wbziM57rHcq7SWx9DNo94VGwlRri7yQWOxONVeRGbuXiZGHVLSJ8vkU/RYRgh7zUfdbT74iovBfrgi8odxQuY/TO3kkjEqyc+Oi3s8UtILN6YRy0UnilpNpMLWx5IG8dADh4b72f2dOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYnIkf597HSXdRl3LmcPBWItdzbUU/v5o2+oXPYkTSw=;
 b=awV61LEcqkV8XPAuITJ49HHvbFoHmyEq7gfsAO7flmmU4O5LgnAcX30do7tXK3zbgQnRcFp+RYbVVWC+z7/J5o8MS3SziIb7UKh6RUvgueZ/sZp9f8OOALd+7QQmkHbAXaKLkg/KPV8bu0EJWSrqb+7kebXlEPI0S1KuBKVJOfmKUMACiCLLwfjac7GC7eWsl9eVdPs5UQFQX1Yv3sE1aLFQbXfnLpuScpALtU8jKK0JoU6qwzb1EqMG/Dom3P6pKEna7XQ7FNj4/r29+f3mSsJrip5fkpF9KR/jIlBraS1JWoeuPeEojPDmZaY2WwouKAYCTO4W79/mdQyoBmhchw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYnIkf597HSXdRl3LmcPBWItdzbUU/v5o2+oXPYkTSw=;
 b=ne0iPKqWQRJqN35qw7PIx23cp6PBEVdSA3xV/v69P4VcMhGj0V/D9I1x9lr71eqjlUGL/yiX7SHlgL+HBIZXFYrHJuqwUN0ZxjqJKETi4CMYQj4f6kP9ZeJ+CD+5+JDN1b2MNAZWmtav1lox1lu8DKDr61Dniz1jftdbn8jPBhc=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SN4PR13MB5295.namprd13.prod.outlook.com (2603:10b6:806:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 10:41:43 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5723.020; Tue, 25 Oct 2022
 10:41:43 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Thread-Topic: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Thread-Index: AQHY48SFgqjha7IViEOJ8498J8TVQq4Wd1QAgAAJlQCACETKgIAAHZEw
Date:   Tue, 25 Oct 2022 10:41:41 +0000
Message-ID: <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
In-Reply-To: <20221025075141.v5rlybjvj3hgtdco@sx1>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|SN4PR13MB5295:EE_
x-ms-office365-filtering-correlation-id: 81b83071-574c-413e-7e5f-08dab67581d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4gVj9j0RQ8wDA5euRtyez5fxgi/WyvUBS83RuOWeUTgikoPUxKM/6tK+HOPecnRKOlnuia7Uenrw+vtXsg1NHmIIhen31GZnDoM8kW2/BRTqd8TwaMzoV+J/XJGT4eIxunXp6moqQfkTnglu2jUvxFXV23VQueoMo/MqCQYevv1Uhs1R6q6UXws/J+UmXSyF3sy1tzVtuM6Pv+z6mNWafGd+pDdIxGlDPbjW51q1lAZ5+GhYzXf1POmRfDaEzy+/Kv/M41NkBfvntZHwNnfiqboLohCA0kiUmmu69wL/L0OyQYV2DSvgG0ByEcvx1PkZ/AGp0RLuapjEOJQCcdGd7sEhG+OXbPOwZ/HtIDw3qcmV0i5WA2x/Zy/wZdiJX6ossd4H4AzwHJhYBakp0H05fY0iB3wcGnBI/V/B2514oV7bMrFT8T+4nzZ9je3vnpx1ECIOn0xsoRKW7vcqGDGQg7fRAMVJBoFre4uXuhrofUjtx/n9l2QI3Cx5co1pKKaHSGMVwSA3jHh3VM7UmVInOiB2dOCyyBVVBnRfZKLkPSKgdPspsMmypKZp+rqDJTBPredoUOHePDEXn1n1NN/CrENejm/d9iYgVrHJ0l0DGOuZOKGha9KeFJoq1K8kewdcrCuwp+P/vzPYNfx49TIrtNJbyramwus+uCelbvhlOZ5q7I6Pgwy/L6zjXLarr+832pMIf1IndACX/7pLYr/poLzNprGbCvenmzWgabI/uWvpTLWFkm8IBtdCHsXPVLccS6qiahBhmfRVMYtigoEa4DXNbJCFJL79QXbr35rW4EI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(346002)(366004)(376002)(136003)(396003)(451199015)(8936002)(76116006)(38100700002)(316002)(8676002)(6916009)(33656002)(54906003)(5660300002)(44832011)(7416002)(122000001)(2906002)(55016003)(41300700001)(64756008)(66946007)(66476007)(66556008)(52536014)(7696005)(6506007)(83380400001)(107886003)(186003)(26005)(9686003)(478600001)(966005)(71200400001)(38070700005)(86362001)(66899015)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XiCmTPRnmHFRksjAbK5r9QMS9Sze/62m4cJaX/udgAs/QobRGOqG/py8Y8PB?=
 =?us-ascii?Q?veAJD1Nv6kJt+i5UQDgxIt6Uear3fI5x0f+hMtYXZbSi6lXjlFqSzAy5ztGp?=
 =?us-ascii?Q?EsSwDdD7a7GJh9oMtmtQh2vQ97s2QKabgHvNO5BXOP7QB2MAOHe9roiFI0tR?=
 =?us-ascii?Q?zT/9/VZ04KOr0s/CuvZl3Gvg5sq9sTnPzv0gS26OOrPV0k8XpYY8pGMTdKIm?=
 =?us-ascii?Q?jbVxvxvJmpCE1K4A7TD6/KAFkWEvJ0YQS+d42HWg1nUO8KXTRwiA7SoUdarR?=
 =?us-ascii?Q?8Ci/zULGdgGqZcr3WQV6I5mqy9vFuSi8ixkU95L1ZqDwG18uHwRsVCIWACT0?=
 =?us-ascii?Q?t2pogY7mP1QjUx4FZxsiaYUHvso3zj/fIoAn4ieFzbOC+GA477B/RZJij1gc?=
 =?us-ascii?Q?iyL2UWIoIhcciNB7Idlj2xGXvqq8weoTO+mZBzg6f6F0r9vH9T6T+IrbeBWk?=
 =?us-ascii?Q?M2WSO5FH0pRLpk1nY4ouQs+WbhPgJQoELbI+Gyw+8GEeRrzp1I2bx37kvSrF?=
 =?us-ascii?Q?VpiRvpagEBDcCpVdbf/rlEmdBj3qB7PNRZ+qwzD0v13uCgloRHuoQmIHZFPF?=
 =?us-ascii?Q?kTCuwPrL9y8f8JQyqPpv76HRDN3WylRPd1bBOIIF2rEj8fJqDa8z5+pHSSvI?=
 =?us-ascii?Q?x8J6LSXAjPgmeoPOm9PMsvHrT1OsXVDbBqkezbDr1A9bzjt7kS+QwM8pvITR?=
 =?us-ascii?Q?Ss3ufwTs9xLmDbc+ljoMWbIhUR7f5PsOmEYRbdyC4CQR2Jt6BzdVPuXfvYDn?=
 =?us-ascii?Q?dRKxV3Hm2MTbpKu1ukOp4O+6J2APCEqBbma8IaAGtUQMwHuCst4M9yLtbtsd?=
 =?us-ascii?Q?Xmf+neNEqzMhzu3YmFsrLmdzsp/xQg6lVI8u0Lx3z0aakshPgrehvhkKJfVY?=
 =?us-ascii?Q?wWKfNQXg5B4DKU7Rl8cShJ61Er+OyshXZOsRJaT4iXPVF4hUhhzGIVGKpL1K?=
 =?us-ascii?Q?SucGiC60Se79H13clUMGAZAda9h9KB10+dEGYBZghmYVLrvCLJ6/Rb2gVpak?=
 =?us-ascii?Q?23poRJPs7pcerzQzt9HP43YrTDz9PRsBvmffdPp52ay/2GAOzGUnqZzF5IAU?=
 =?us-ascii?Q?qGbB7KHdZ6IytrROchFvU1MXfrYKv/UQKDTqpCFCftOpu1oTaG/JgYy4YPjQ?=
 =?us-ascii?Q?rGc0uc9ybYq4rylBttJn7fzuqUvn1WyGnGTsijJFOYY+1KoHo3ZVP+O2xjyI?=
 =?us-ascii?Q?1o6ashn53ilwg7zX9APorvUl40Sn4aMGXOtyHSpR3QtLq3SpkIpGVfIC0BiI?=
 =?us-ascii?Q?l3rPiJDC1TqiahdL3pE/Lq/zVz3RH5Or4/YQ8uEyaXLrH0Ks/eKUb79gOEW8?=
 =?us-ascii?Q?48U8LOI8lfSCedzuVju95QIN74ED1/npsZu3rB3ddoVw3JEnBo+Saedrjw1h?=
 =?us-ascii?Q?8rdbQ4Pq5XLPPhzeIphszzNrQA29/k2Xp9cDbBg1KQ+Z5rReX9v3L19xTwFo?=
 =?us-ascii?Q?aWOvet5l0+vrBlNOTclEyWSnU2pNfEQ1LjluJwKGEC9NNNjgejsou4S9JsKy?=
 =?us-ascii?Q?OJE8QocL7bo8yYMm/1sLYO4deJb6gm6mHaxSDrcL0gOmh+BWehLlHB0UlccI?=
 =?us-ascii?Q?fgWQX3xRI7AjaJSIzl2AnOh8cMklkl2PwZDPPBNC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b83071-574c-413e-7e5f-08dab67581d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 10:41:43.1402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wEBh+yanhcIlhKXj8iqlyAKuF2oeq8AGykSQ4nbUZzGgT8lXuK72J/jGv4khcBp5BlSjDSn0GSezN2ji5iEiWKui+twlMfQJ+r+Iy5bdfWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5295
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 08:51:41 +0100, Saeed Mahameed wrote:
> On 20 Oct 09:35, Yinjun Zhang wrote:
> >On Wed, Oct 19, 2022 at 06:01:06PM -0700, Jakub Kicinski wrote:
> >> On Wed, 19 Oct 2022 16:09:40 +0200 Simon Horman wrote:
> >> > this short series adds the max_vf_queue generic devlink device
> parameter,
> >> > the intention of this is to allow configuration of the number of que=
ues
> >> > associated with VFs, and facilitates having VFs with different queue
> >> > counts.
> >> >
> >> > The series also adds support for multi-queue VFs to the nfp driver
> >> > and support for the max_vf_queue feature described above.
> >>
> >> I appreciate CCing a wider group this time, but my concerns about usin=
g
> >> devlink params for resource allocation still stand. I don't remember
> >> anyone refuting that.
> >>
> >> https://lore.kernel.org/all/20220921063448.5b0dd32b@kernel.org/
> >
> >Sorry this part was neglected, we'll take a look into the resource APIs.
> >Thanks.
> >
>=20
> The problem with this is that this should be a per function parameter,
> devlink params or resources is not the right place for this as this
> should be a configuration of a specific devlink object that is not the
> parent device (namely devlink port function), otherwise we will have to
> deal with ugly string parsing to address the specific vf attributes.
>=20
> let's use devlink port:
> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-
> port.html
>=20
> devlink ports have attributes and we should extend attributes to act like
> devlink parameters.
>=20
>    devlink port function set DEV/PORT_INDEX [ queue_count count ] ...
>=20
> https://man7.org/linux/man-pages/man8/devlink-port.8.html

Although the vf-max-queue is a per-VF property, it's configured from PF's=20
perspective, so that the overall queue resource can be reallocated among VF=
s.
So a devlink object attached to the PF is used to configure, and resource s=
eems
more appropriate than param.

>=20
> Alternatively you should also consider limiting vf msix, as we did in mlx=
5
> https://patchwork.kernel.org/project/linux-
> rdma/cover/20210314124256.70253-1-leon@kernel.org/

Msix is not the limitation in our case.

