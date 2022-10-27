Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352D660F3F6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiJ0JrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiJ0Jq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:46:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B748A58DD4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 02:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKh1Hm8Kxwc8CMLxQ5xW0LeXfWk5+x81OhgXpSMfH9TGHWiVz1kDNSP7je4rKKSSBxeG/TEMf+dgZmrhH09GbSBf2bP8Xz/7VIZ7+OsJ+44PfdjgKUJkpLsGLZm+BC1sh1y+RARxF4IqZ1H7A8HXNUSWqE/dNjQp0VWpWscbVLEaW770DI2mCp3bEefgP0QAu0XKZlUWGeMB4piu6xUI0mV0hFaOqEkYopvU7H2uP1j4T2BdBkHhUUUetueGKzeCGprZxU4hCFbPD7/JgH/rEV9Y6vsYp2G5QgxcS6LHnW3h4/a9hwtF4kZGzHRnVWIf4WK38USKsOxgQSgLGwf6zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOIcX17JZrXkG8Kc3fs3Q9yFBJrusEIqb0Fi5S93kdQ=;
 b=a1lY0HMTknm9kNDw0zUURiOGmLqvt1x1VzoRnwjhzcSJJMXZ5X1UiVza5vZO1U5GTM8jZtFC3yhRfJXa9rA5Q69KVTnQjJ8xs2TM4tJ9pV2zr7OxqmPWtNzfXbPM7nn4x6ygmCG/pTP9Jo6mbeNm6uFt4rmM7J0b2jeOuv/VXkeHlgHT693imYszT/bfUTKwTWCC24rOFcgucXzCfjK716mjekDMO9rNSHLCh6HMwHYO5AQPB1F1zgZMe3xYi8QkpCrK4nMASGZU7nbWTesUFOMUNZRWooZGcLac3Z8I35JdfNsH9ulAIfJKuyaYj1JG2oOsDild0Yy1W4cJRRgckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOIcX17JZrXkG8Kc3fs3Q9yFBJrusEIqb0Fi5S93kdQ=;
 b=YdUh6Iyufh2z3C8f94uvQ5HqBjerAJZUDZ6UKo0yxyfwrXiwPm74mj3RLd33K7YC5he7+4Q1U5M6Igm0epyjplzEoCDplyc18t6yWw8PR/lEc7naS+vD4/6v1IleiApFXl+qsZzpxZsMGHlAvT+TC3leTJMUM43Cy177es35XVA=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH7PR13MB5892.namprd13.prod.outlook.com (2603:10b6:510:15b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.16; Thu, 27 Oct
 2022 09:46:55 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%9]) with mapi id 15.20.5769.013; Thu, 27 Oct 2022
 09:46:54 +0000
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
Thread-Index: AQHY48SFgqjha7IViEOJ8498J8TVQq4Wd1QAgAAJlQCACETKgIAAHZEwgAAYgwCAAAP1IIABxXOAgAC2Q/CAAH5YAIAAC1fQ
Date:   Thu, 27 Oct 2022 09:46:54 +0000
Message-ID: <DM6PR13MB370569B90708587836E9ED6AFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
 <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221026142221.7vp4pkk6qgbwcrjk@sx1>
 <DM6PR13MB370531053A394EE41080158FFC339@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221027084654.uomwanu3ubuyh5z4@sx1>
In-Reply-To: <20221027084654.uomwanu3ubuyh5z4@sx1>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH7PR13MB5892:EE_
x-ms-office365-filtering-correlation-id: f2dae760-863d-4700-0a84-08dab8002e8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ftUUb1bfde4W0P+ix1A1rPZH+7C1wpFtaTJge9I1eGnZbMlluyYe/Dq4wrlJ4SwMn+kJ9rx4yFpvcpWDqGUWMxduV+734D9VEC32IeDJy8WN98JuXoei8YS4r6A4IVBBIANhDUO14vlD6RnFAfqlsh05/3qP3MJEBvjYKATrVSGhrlw5UMaW3LN/WsOSfWvsIxXJF4F+PE5ma/+5/hUQGG75PuibJclnYvWRsFz+O1TI/MQnHfeN1u6Eyqnu5ypmPhr8rgkfJTF6LToejF+0COcG62aVV9K7JQig377CZmbvSshdrD3y+yM6m3yjEc/q1VGl3+vUcY+hw8tJ2fy5SMZKK1Fw9HQt3uxDcGw9rv75LcmgFal/E+NN3vtH0msKeScnk67NREmxVU+jWgxF9/feMBeCRzNeoWVuBUq2wUMYjh4nMvlsb4H60YnAV2H1F1DASPzHH+l3aeISB8/s0E0yNoOFzM60pPOzx0pPI5C8mFO9vOCCh/nZ3WTz7y5RCMAnaDGsQO9snMWHzRnYe2TLkuAcaJ6DKAa3rR+QwBPVyt5o3Em4VCTEmT9+XdZzna3byXh+BmD4kzTn6pDnXvjvwzsWxYllBB6P9t1NlGRDv6UvGEIz0HdKSngcN/hpi/0sucq1xuGfsRYkULDuzlHB6QYdCs+F9kx5RAq42C1ruLiceEEm3HJH1LMlYLhRVPjW7qvFXk45QqY+5gESvcFYoITN1tgTvRVciKFCdaNNBDczYDQNyFILzns22aOIFTMmj5XB+DQrFmr4NPLK8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(376002)(136003)(346002)(366004)(451199015)(186003)(6506007)(55016003)(83380400001)(33656002)(2906002)(66446008)(44832011)(107886003)(122000001)(38070700005)(26005)(38100700002)(71200400001)(86362001)(4326008)(9686003)(8676002)(7696005)(52536014)(7416002)(66556008)(66946007)(41300700001)(5660300002)(66476007)(316002)(76116006)(6916009)(478600001)(8936002)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I8Rs4KBi5RQdgzlzTJ0vCoPIofxRyUbhejtNF9QhA6+BclpcJ39WhjK9CfKh?=
 =?us-ascii?Q?qku74zR7Laco95IACnFcTXnxzK74QdX03s1etunGMucgY9DvzxAwIdHpo3Cu?=
 =?us-ascii?Q?fH9zCvs5gFlZsLITPSfUhGO/t9xwpUy+c7H7PbLLV2HQWEb8m7XAbRe/uTCQ?=
 =?us-ascii?Q?pAstqb4UB4SjIALmzNGE6LQ6c52Qryg7R7p5Z1OtmxV/en+frsDZOHMBXFsi?=
 =?us-ascii?Q?nN3N3Z4Po7kU9czYhH51Tjer8fDXHLXKxQcoih3DtRHecZdRrONNJl19A/Zm?=
 =?us-ascii?Q?MlcBq762WP5OJV5v8LvHWlfLKJmruVGSC8V5CPSAhA4HBEm41+wycIzjaCS9?=
 =?us-ascii?Q?1MguByXl4NzjVA4MS2f0oWBuxoEsJjZ4FEN+Ezli/om4sMHAqTqzky0RTLDh?=
 =?us-ascii?Q?FmmMgA2i+xkZVMsOk7gHU6wxbDqZCxu0F8l5/jFwcnziV9gu7JrblIwpZWhL?=
 =?us-ascii?Q?NeSXRAcHYpr9e2q4Ewqb6io1g0EriEqzScY1DNjFJhQa4CRR6dj7LcZw9L8u?=
 =?us-ascii?Q?2t2d0iupJs3vGuwKYuWVGdxWZFrFogJKm/5DrhdIlz5eU6c9go9kpFFxaTi0?=
 =?us-ascii?Q?gCmC9P3/AbHDJCdU2QCWefR5MZ5E5EvqEeCryGOu+0BG8ydHUg7Luj0cQP/O?=
 =?us-ascii?Q?um9U1sO2nuFtmYvUJmd6biLxpekZumTt1ya5HgQOeYFgYwg1afNjbq1Iicpl?=
 =?us-ascii?Q?1Ux1NQYK0YMpNce4HmOjz21rErGZyNvpTGnzU1+2/NSRMIYmVchcYUzLHUa5?=
 =?us-ascii?Q?rGsjGzMSopx3Qjwh1BWf36ar3nnqdklJtmn1cB5aP3bERaef4T+PBbp5noIX?=
 =?us-ascii?Q?YrMg4ugaoENT9mwvzAoVvYavO74QSvY3yPRsZfrjmgYn2QpowYJoDP2kGvxm?=
 =?us-ascii?Q?x381Qdz2naA+dGjHpcbw34KOnYgzkoCbFGHyrhi/oFg7S1Ch/Gvho38Zf/Wk?=
 =?us-ascii?Q?xXxbTqsK9sny/mC9OkGA/4B/uNU+QDErisurgBre7DfG5jLX0oYd2SK/VMy2?=
 =?us-ascii?Q?XE7sFSxTbnM0kbBEQCwa//wqpLgM2d+4R9bziO/ILVxctCLzLih4/hiFIw7i?=
 =?us-ascii?Q?jWH5y9Du/Wr8nPEh+kHN1VOBAFauVEgs7+QEQczB0DvrdQ3SspUJhAheqWuG?=
 =?us-ascii?Q?4w/Xp27aOQAUrmHpXaWnUWFXWH7dhLsA6LP9LPN+OYCtAtE6ktv9+4zBsQAk?=
 =?us-ascii?Q?r6fBIrt843ThzZLvs8Y286k15RNp8YkgPlyeU3Bx07DMfJZ18eEzwMwvlw2T?=
 =?us-ascii?Q?N29aOpSPBeZRJ9wF1S8sc3dxHcHDURw/pg4b5bkGNp852b9DHb6aZyW7NB04?=
 =?us-ascii?Q?XeKsMK5Xy0aH5MGHLU+brfd3fuXZLO6xaZAGJyRpjqlewNjYt0fiF2+SOaJ9?=
 =?us-ascii?Q?tR8q5g0Q705sJK04BetfsQIAHZXjNVCvALVEd6O5odrIALXNKTZuWh8+jE0u?=
 =?us-ascii?Q?t2hRdM94rw1tviMkKwAlXCs3v/lViYDxr4v5aezaS7JJnlQvL5w5ESJLPkvc?=
 =?us-ascii?Q?DnrcBTZwVLqnglb4p1vU691DP2yOzkdCAO/6SycilRU0ZDeXJ23N59a5zHlq?=
 =?us-ascii?Q?5tzWC//djmqT+FxvSbA6Y6SBibzulvGgzkD8QDP5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2dae760-863d-4700-0a84-08dab8002e8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 09:46:54.6514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1AuGNBfnLOU4Jr5CrWrPBH6NzB1MiBUnqpa4ExOJgWsBadBj3hqrmQLzY11HvfgmSa7010BKpf8hvKUMld1XB8RisNc7W/m77aT8eQUD20M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5892
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 09:46:54 +0100, Saeed Mahameed wrote:
<...>
> if you want to go with q as a resource, then you will have to start
> assigning individual queues to vfs one by one.. hence q_table per VF will
> make it easier to control q table size per vf, with max size and guarante=
ed
> size.

Excuse my foolishness, I still don't get your q_table. What I want is alloc=
ating
a certain amount of queues from a queue pool for different VFs, can you=20
provide an example of q_table?

<...>
>=20
> Thanks, good to know it's not a FW/ASIC constraint,
> I am trying to push for one unified orchestration model for all VFs,SFs a=
nd
> the
> upcoming intel's SIOV function.
>=20
> create->configure->deploy. This aligns with all standard virtualization
> orchestration modles, libvirt, kr8, etc ..
>=20
> Again i am worried we will have to support a config query for ALL possibl=
e
> functions prior to creation.
>=20
> Anyway i am flexible, I am ok with having a configure option prior to
> creation as long as it doesn't create clutter, and user confusion, and it=
's
> semantically correct.

Thanks for your ok and thanks to Leon's explanation, I understand your
create->config->deploy proposal. But I have to say the resource way
doesn't break it, you can config it after creating, and it's not constraine=
d
to it, you can config it before creating as well.

>=20
> we can also extend devlink port API to allow configure ops on "future"
> ports and we can always extend the API to accept yaml file as an extensio=
n
> of what Jakub suggested in LPC, to avoid one by one configurations.
>=20
>=20

