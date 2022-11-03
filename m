Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F801618B8F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKCWcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiKCWb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:31:57 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767C622BD0
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZoafPnv7iG3TH6umuFhm9Cjo6KS9LTsSatgR6TR6UcJP/MXE+lSCcT4zAVsNgpcxag1TVLVmMZIEl/7uOSaFBRTjhZTKCpPNLoOOtt2GZR58U4ubRA4P5kQkRfQwTWP0WLXo9R7INmgJ4y17Psfs2QM77e8Apqd7cpJywqQbDUQV6lki2ejP0zXOYcGROhXlpXDHZIzIjG7dCwE0SagHrEZRTE4/+dd2DftQL54GlBPa2dhTUSN2QEy3sYLBH1SttbUzHegDVgkfrYDYKjFDqUE596SuZjEA8oyANcvZYblZDnT7OyihY1xzY01sLB7Jx25K9TnXzlxjr6iMRQMxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYPVAx00pruXWCdYLN3zWIHZveGr8VlYBMy2AuGBMd0=;
 b=YGWILvRS1/izj7+/XDg0f2UO/XufB48a3dwXj38Jzja7NraSGeZVhM4Fc0eTk2xuENtiR02sEHKV8ExFTog4tKAELdulCF0oWu3IDlkYnoqwfjTD3OjFjIYdXbXvOkJkJnHB4hErYF5npqIw2gLd3QukihxcbQ5STpY/J9lpimUUcdI97fujx74RRlVqs1lt39MXcZkJRovT/YjGEK+fbCFBNb4MQhH8eh7K3WIo2y1cO3wnBLj9vxnJVUFsueM8amhxtaN/F/DqL6vOf5elnOLC0qTK1isjMjpuD1O1RhuW6r3z9dHfs56lvdseMk93vgvRp906Amw2NW+7j4ek1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYPVAx00pruXWCdYLN3zWIHZveGr8VlYBMy2AuGBMd0=;
 b=FLCCbNDUO7vhfJJ6/DkiQrQjcyThY0NYOtdUnzV1UWpbJt0mUw/TX5/RFDdgGjCBbWX9D0SvAzjMtxNswXRKKJLRff77T5O0mN/B+wATbv5f6Y752zmWJ6i0e+MGMfelUwWKUzskjdDU0m5YJ/CxgbGf01atG7Map0qn7Bb1hlI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8818.eurprd04.prod.outlook.com (2603:10a6:20b:42d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 22:31:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 22:31:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add support
 for locked FDB notifications
Thread-Topic: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add
 support for locked FDB notifications
Thread-Index: AQHY6FjUVuDB5/kMGkqgz4g+zKbN+K4moPuAgAGU3ACABaGZgA==
Date:   Thu, 3 Nov 2022 22:31:52 +0000
Message-ID: <20221103223151.cnmlvgnz3maj75iv@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221027233939.x5jtqwiic2kmwonk@skbuf> <Y140a2DqcCaT/5uL@shredder>
 <20221031083210.fxitourrquc4bo6p@skbuf>
In-Reply-To: <20221031083210.fxitourrquc4bo6p@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8818:EE_
x-ms-office365-filtering-correlation-id: 8521477b-834f-4ea9-8016-08dabdeb34b6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: plb79DAE/LpLx6KfnA9eL8lJ8ZNTuovKw2nbTNoaCR28Hr7JphAHyEa+wCJmXl8ZY2JrFrWNn8csrqLiCBEH39/ooy8AJruY11VMP7U/H4abFXMVZacek2xFrOounXjrPyMHzyk6hQvwAudRQFgXn4djPCufoaN3W7sIGo6ScROpTQwOz25p2kIDZeEXXNQd5co1/n+kODwjzns6yRIgIkgd2LIrgBuP3wb4OGSoDxpCp5Lw2cCrQpCMBmRzBVETWLuqSPmEy7UbeTvjMNsd0rlAq4XQXSYIb8yHIjZHmegn/6SgIo3qbpI4zfQ4ROHkfrGyWcLTDO2EI2Z6fQIv1uXwEnufrzYraVVemAYC0i9G4JXjOJ/kNQlVw/fywNVoZWC97q2tHPIzyM2InZhKTThCQi799hm1VX0ORYalOkumZ0I7K3UJsHExMVHymoVxclg9WU0OZPI/Dqu3EKnZMKKPBP7gtZJKAdXw6w850HqgBHYsXly0L9DUKTYjTT0r9wSmHa/C7EW+LxYU7A6MtOdJuctk5gxKu65XjyEyw96ZRwtQYuBk5ZeLrEk/B2qACSVk3na+JJ0gj3Mobm9Ogt8f1Pqm/uAibPHNodPK+AIC8lNhXBzdAK9Mo0C7+BwjUY5bpeh+rn5zMnwQgJrmk07Uc4AL7mYvmcymgCKLpNZ3NamE+g/jmPX9cHurBY48hYvMWtVy6ZwNQo7lUBCdfKADAARBAUJfB3riCWRO4OlmDI5yBeXVodcqQrnC/D40e+vEC8/y5jXS/bjbiglj7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199015)(2906002)(38070700005)(64756008)(83380400001)(7416002)(5660300002)(44832011)(91956017)(6506007)(4326008)(8676002)(41300700001)(6512007)(8936002)(86362001)(6486002)(478600001)(66446008)(54906003)(66476007)(26005)(9686003)(1076003)(122000001)(66556008)(38100700002)(316002)(186003)(33716001)(76116006)(66946007)(6916009)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JmKA0ZMFT87qYwb5gQ7xB4zpqUJJ3oJPXG8qPbKN+CHakZep1LoLkYa3q/AD?=
 =?us-ascii?Q?n7gjJJ8Ak2Cj0ebql1WMjvXPZ0G/yQNu+rSas4mZ4/AivaYYY9Q0xbm/9M7b?=
 =?us-ascii?Q?YeLST9OwNSP62FeOBFDfi3odaRuCHBykyvwgZ/4WL7zrWN+MdoOV2enyh0ML?=
 =?us-ascii?Q?di4NZcfLOIFHhQATOiaCvAkSkK0+tyIf0A6mZFD6VcODNOOCDTfq3fX6X4KA?=
 =?us-ascii?Q?q3AfMNo8Sw2dRaj+CDqVb369kEg4KW9i0+TunjR23hJfBIM9tCgY/FQ+WUuT?=
 =?us-ascii?Q?1z19AGsbThVlF0GHVu5ueUASnZBOqx32yBpSPDaocCHapbIG3In2g3zCpH/V?=
 =?us-ascii?Q?gBaF2tbIXhSHrMTbOVNGVmXeCkA8bnyMkeLfYZN0gOKBqAilh5aj4NFBcgyj?=
 =?us-ascii?Q?FWKrMJzywOHvw92+kfnjxEDf7GqEpibaQN9yBy4rbehHO9m6qKNN5DxGb6lD?=
 =?us-ascii?Q?ZfVYprZtn1b3M7MnAeu25uTZo7EM4pnE2DyFhrjT7l+3HPOYFrfPMLOCtRgS?=
 =?us-ascii?Q?QBHgkolZNTqKUwXiWc3qJTsRxfFA6YorlUJOEPz1t1RRZT4RJIaOB+XWbb0H?=
 =?us-ascii?Q?3A3nSFTNPeJt8QfK3vqaCRVt/a3S3KyTgcJJG3bWWQdqFMJloLg9UoLlsULn?=
 =?us-ascii?Q?HEKjtX068MDLA0wtiaa7lW8WSiN21FMK9J2KVgFL6VdVDDbEeyqtOp/o7Oqx?=
 =?us-ascii?Q?pCnQi5TDXhrFbTi1vcRgilTQRQW7vvSwoS87zGJrIbetvXHvWmqJMSZz++Dr?=
 =?us-ascii?Q?NzmRLowPkhzV2XP9qs9SnivUcrF68BrocE39ufeYK5e2bKfzg5VXVhCTeYGX?=
 =?us-ascii?Q?/8kiHMnxcchBr6q8c4CIpQYBKaZ9HRPm2NpWoLFPYYcnUCSaHnQ+Cu2ChRYr?=
 =?us-ascii?Q?BEUNCTAFjLFn5aFh+59HUKaStNvJMWNCbGK3i+41Mff1wpuhxcgc7EAah8AT?=
 =?us-ascii?Q?D/q21wtpI6YAlQdoOHxo2xS2LcIuA1AJvTOQsDfHpswNjaVmmhwBeVPbg3CB?=
 =?us-ascii?Q?aaHOBi0q4K0Kpp8HNLMhihN8jRG46qP6M3B+1Lq9jxymHNYW4U4nevgwMF2D?=
 =?us-ascii?Q?r0jLzM4JdSyXWj3w66e37uHgCs/0hc/MppaxudUSW9HSmKgJcdFTHMsO79cC?=
 =?us-ascii?Q?hAuqWH0aWGGZ325QLczN5Th98wBvL9qTVETorY5JV4X/74m7D+sM0qgpQ+RG?=
 =?us-ascii?Q?eU/aqdqiwVLbFttQTdlm6rXF8zvOIkveZ2hpHCWjpAeuyYZRJvGeYM0OETU7?=
 =?us-ascii?Q?tqYdOU0YhBrtdEJINYgtQF7vDUttHgZ8ZV39MDdKpoD/VWnfbnQbVQQjlq06?=
 =?us-ascii?Q?mL8VLlJZrnoBL9ozosoMNgARJ33mfB/8DL4pjCp9fSPH9MNF04SoLh1wG2lf?=
 =?us-ascii?Q?Ywyb35mDvcUpvt/PhrYDfjQCsRFv4i9FTITs2gFwmhas82NrjlL9m2x1LFOD?=
 =?us-ascii?Q?Mk37dExYjJmLtl/MzdN1op/XOrS2J5qApicr2vctFfeciIAioOqkhdKqZp9f?=
 =?us-ascii?Q?yAF1c72dWpWlfH/gLI3KV0c2J6s+xRajUKdP+alHUCRYYixjqYrXlCrOF0ix?=
 =?us-ascii?Q?kiNH6CBTonKrgDQW3kH1/Sh/LJP/Za2C7z9yGZKG+WMsFpoMpZ6hCBeJ+H33?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6F645F835A7934F8F5F062CF56253DD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8521477b-834f-4ea9-8016-08dabdeb34b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 22:31:52.5373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uFTH+pqizUEidhrmtPP795IuThS4gR3tWl+gk/32zpRXdMAksc8XJtjkaEpsK9kD4MVrCtRJ+WVjXeHh8/RQKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8818
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Mon, Oct 31, 2022 at 10:32:10AM +0200, Vladimir Oltean wrote:
> On Sun, Oct 30, 2022 at 10:23:07AM +0200, Ido Schimmel wrote:
> > Right. I'm quite reluctant to add the MAB flag to
> > BR_PORT_FLAGS_HW_OFFLOAD as part of this patchset for the simple reason
> > that it is not really needed. I'm not worried about someone adding it
> > later when it is actually needed. We will probably catch the omission
> > during code review. Worst case, we have a selftest that will break,
> > notifying us that a bug fix is needed.
>=20
> For drivers which don't emit SWITCHDEV_FDB_ADD_TO_BRIDGE but do offload
> BR_PORT_LOCKED (like mv88e6xxx), things will not work correctly on day 1
> of BR_PORT_MAB because they are not told MAB is enabled, so they have no
> way of rejecting it until things work properly with the offload in place.
>=20
> It's the same reason for which we have BR_HAIRPIN_MODE | BR_ISOLATED |
> BR_MULTICAST_TO_UNICAST in BR_PORT_FLAGS_HW_OFFLOAD, even if nobody acts
> upon them.

Do you have any comment on this? You resent the BR_PORT_MAB patches
without even an ack that yes, mv88e6xxx will not support MAB being
enabled on a bridge port, and will not reject the configuration either,
and that's ok/intended.

Do you think this is not true? Irrelevant? The "fix" (to implement offloadi=
ng)
might come in this development cycle, or it might not.=
