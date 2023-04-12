Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB586E00E7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDLVbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLVbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:31:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB3F7D9E;
        Wed, 12 Apr 2023 14:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jp0WCEeba18CU9M4hAH6W6frWIxCvQ1r5mmw7vlvhVeNFJZOAcbi/ReXkYSr9+NNShQBYlokmWTtXCT44bFd+FrA0JIOMB/Wn7erDj8L5v8WuclAhs3R63y0W9I/YNWm0zA2M6fN/0IoU9Bk4VXzOTyvQGRRqQTmz1c97Bk/rbN/Qd3rqIGONCfhHEIcmHLQ4UUROgVyY0Y9QuHM3XVGsF2cvcwrTTYSIUV7bq8OwZNjdOxwfGcW/z2U1PH5SvTm0lq0LIc0EWEM8aSanZstxmMbOcOCv8y114xwN0F4oWqzoeA5XmMhmQjn3hf2+5qd2TQHsH/Rqhni0vNYSHmATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMhDTt8xHL3LyaU/8xpnfgRr2kjU0VVqdJ6icrhrECU=;
 b=elC0YFy/T4CkesxFyS0sYU/R3W5Twp/pQc/2E49y1j0z9QzTJL4T+lCdukFO4VmVvZEKlT1oTKR+GmDWXBlL6BOrqOmtWaoVpEKYISmDljchUj2Qo2jq86wVdpHbGnBc+yyhVfempKXZ4cHrj9fVLtIkYRPEQ8axW3eXD6BqO0PwqHSTyjWvgeBT5OlCwR3MdIjO63IWjiXqiFs69Pj16vgl3sQJ/CwrHzLj6Tzp/5aeAFF13c9VAuR2QzcGGtHFnsscf/RUIknnLidAezU3INO3qbu4c46QrG5vFAbRJoC06E6RtnLd2QBK8JgZimBV+6VWIJfT19m4rQKwpwk36g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMhDTt8xHL3LyaU/8xpnfgRr2kjU0VVqdJ6icrhrECU=;
 b=pF86ClAM+niZv2nWE26L0VVmoHWWlbv19RBTEmTAqRNTAIiwpJKP+XRP48IJnRbl+Snc2LKxdtpjWCrJfKsG+aRhkRdTSWh5UEJXxUFS7mtNMzvcezduNJI/BIwJ3l+grSIjtLQq08KNDUaDaQzL0Y9ZA3uLiWYamL+hqZqMWAM=
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com (2603:10a6:208:145::23)
 by DB9PR04MB9820.eurprd04.prod.outlook.com (2603:10a6:10:4c3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:30:06 +0000
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::8516:ebc7:c128:e69d]) by AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::8516:ebc7:c128:e69d%6]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 21:30:06 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, "Y.B. Lu" <yangbo.lu@nxp.com>,
        "Diana Madalina Craciun (OSS)" <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Thread-Topic: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Thread-Index: AQHZU6GBM20rPir9q0ygz08QWqv0C68oHDoAgABHrAA=
Date:   Wed, 12 Apr 2023 21:30:05 +0000
Message-ID: <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
 <20230412171056.xcluewbuyytm77yp@pengutronix.de>
In-Reply-To: <20230412171056.xcluewbuyytm77yp@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6289:EE_|DB9PR04MB9820:EE_
x-ms-office365-filtering-correlation-id: ec435dec-bf04-4c33-4637-08db3b9d1577
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l620WJPT3VkipPNCLsry1/kdB+xD3GmAW3g9UpIVetJ/lHz382v/ia81eQRGHPJXVFzs+EUerJCA4a7pjGoWHCf2A8EREUNlVD7oYiroQ/29tbtq4G7kd9EPp3NhNA1fprsi1Sb4U1AWS3GzMN+yvfkC77po29F+0+UkUxZi7nUbIuf55ULcGnkiVmJ8UiN7FpAx7GrL5rhVkJGph1yoBfzAK6ZOMVB+zg2FDXC11Atz4sQXJsm17MSmvtQC1ky7sQbluBcowjvX4lu0hwGj9+EO6ccoWqNQy/OMAUth54t7bvlxaNkTAU4xRkor5t4wyTaStquIi0QVYA1j3JJuOky+QVcZzeNhKnfXrV3FJuw2P+b8CSisJ2a+r2iHI6JOhiAFtSXuS3D9FRJEzL/5LJdf5fkK9HeXcrlRsSeUhHedka8v8H7pLpO1z1YlkOwSfCmQyY2DGhf19IBXylx5yhgPLG3BxyQpO8Ljtxb/AcJu9UUsJkabmiMq0/xzNrFMl3bswl9ZPx//SWZHPmA5x4mZA4OZ+Xx4CyyIrbObjF94pBTQQFuI2IAVkB7rTy+ds08gpHn8o0tyGv6+iG1tO3dpQeYXIqrtlBGi4CSky7PyxBTA4h8EwJ/yvHstG6WBiUHQwEZ8e6C21zDwT+NwyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6289.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199021)(4326008)(71200400001)(41300700001)(66446008)(66946007)(54906003)(64756008)(66556008)(478600001)(8676002)(66476007)(76116006)(110136005)(316002)(33656002)(86362001)(66574015)(6506007)(9686003)(83380400001)(26005)(53546011)(7696005)(55236004)(122000001)(2906002)(7416002)(5660300002)(8936002)(55016003)(38070700005)(38100700002)(186003)(52536014)(921005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xHHAQeDctD/F270s0NOMW3udQV6+E9ONJDyVp/Z5nTT13dvmqotKumSUiL?=
 =?iso-8859-1?Q?2+YVrqMhCN60sE1F/AkVltk6aJd7ykZmbIcrZhDX4j+7ZjUBhAj8YfHAe0?=
 =?iso-8859-1?Q?MV8GGQE6Fqzdln92KYmEwOlIIypbAtwOXnyQi3+m8PL0NLopDBurILF1ya?=
 =?iso-8859-1?Q?Gwp3Covh4jbknZ5Q59z7UxFtOuRP3jL7D0x8n1BJpMnxkU/gD5qYp5U0wQ?=
 =?iso-8859-1?Q?o/WBtTqLrw2syMkKS6KG+vy05dcJXKJNPn/opMgtPuZwwD4gFKPvt41G1z?=
 =?iso-8859-1?Q?JlqKSPbqIy11jgfG6K/2o9P7VjLDQD6CZX7owjeyPBhWUReKsbh2jLgQzQ?=
 =?iso-8859-1?Q?xOOOBCMIXJY71WQT4lLiTgr0pPXEz5NKgsNNteNeECXIW23Z2fzbCiBP+L?=
 =?iso-8859-1?Q?nXjRwRaPv27UUond8DVc+ntXEN2Pmx1oBimb6rB8HATcIaHiRuPIoPngLI?=
 =?iso-8859-1?Q?yRG4YjSImjUez5tFbUdkwFMT5hmHYF2OxkgNWZ7f3ugVugIgWwRT/+4Vtk?=
 =?iso-8859-1?Q?0SCEmBafFnIn5+RvpypobBANDXHXqWDDm/cUGFLSUzSdkAqK8BQGFzT3L+?=
 =?iso-8859-1?Q?YehN657Y8xj2SY3fsHXxnSMwub1oSGNVeS7NC+wFAp5i74LWLSbWGEui7d?=
 =?iso-8859-1?Q?SPQl5cpehQ9Ph+pan9Vsrti4gbSfJzZNcLUukD2p5pHgaE0PNboTC953O2?=
 =?iso-8859-1?Q?16Akz7lX/iS5vn+eQfr9fOzPKw+iWegUICqZtBZ82MR08Rjd5gWnADkS7y?=
 =?iso-8859-1?Q?Y7BWYmFcWVWnk0sCCz5piyfyj5/iLsHWhRIHDWtM/asCNFnaMpI1POE61l?=
 =?iso-8859-1?Q?m0vSmgvT2XRBhlhuiUcrg85LKY1FSGyaPJxjjAO6SC10Rf2Ra5c4shXdpm?=
 =?iso-8859-1?Q?BtMqPdod9/dNiclG8d2YGSCRy9qQvhNaTyWauDzz/EFtX8r0iLufjKPhxO?=
 =?iso-8859-1?Q?YNYuqVoYYBtPuDUo84/gd6kxre9jDvfhYcxD4RhAdAW3mlICDdnemvJQWN?=
 =?iso-8859-1?Q?RBcrF51EM7p7OAGYx0DN+6f+i9ZZWZN+uWM3Zgd5LFEwzdFffuMXxYKmq5?=
 =?iso-8859-1?Q?d0L1XH0xAoEUZ1+9Z5SX/Bb3qWAYlT6yQb/Jd2Qz/RKax3iq0ZPscWqbiS?=
 =?iso-8859-1?Q?Abnh6teSFa6y2c0jhcMgOnz4cmMRY0uAzdbU1ur4m2rkzEkTJyqCe0p54D?=
 =?iso-8859-1?Q?rudq1SaHDv9O1ab0REMeDLUlyXTj18wxK5uPf3ptF2tnH6MP3uzHmpJUDJ?=
 =?iso-8859-1?Q?vL1EDOz6tzyn5oRuq7/eB6wojahFtfbQi9HjoT6D67h05jVvU7crhPM/X8?=
 =?iso-8859-1?Q?scJyTIOwC5NaBgkUg61IyaEMaEhJp/JxO/yiW9jfdghJt74Pw4rV+LnHlA?=
 =?iso-8859-1?Q?5ru9F23ucXYjC6/Koceu7Sf6n4jj5cUfGr1/p9xVRUqX2rVO8OCzAd0hJ4?=
 =?iso-8859-1?Q?3oI21WDPxu/nMUjBPvnlpPuwrPdgidtDe0lF9Gwqpg5ehbrOr0AM/F3dZL?=
 =?iso-8859-1?Q?AwxNB6jtadDeRi8QL1mgAgagCzfYnaWud8CRdsHXgKwxYSKB5cXIRcW03z?=
 =?iso-8859-1?Q?67sOzUjAQmIq3kwUqLp0lDZmWW13pqPkwmK/J64eg1hKz2sQReYavpuPgG?=
 =?iso-8859-1?Q?SXxDDi+ZGNnVE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6289.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec435dec-bf04-4c33-4637-08db3b9d1577
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 21:30:05.8805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hErjG+UfQLjzL0rI6Yw8rghqhqB6H/aytPqCbJA9AjxtE9/JJ+W5Q+fZd5WJdD61lMVZgYIalchiL+Kv2OduVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9820
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Sent: Wednesday, April 12, 2023 12:11 PM
> To: Stuart Yoder <stuyoder@gmail.com>; Laurentiu Tudor
> <laurentiu.tudor@nxp.com>; Roy Pledge <roy.pledge@nxp.com>; Leo Li
> <leoyang.li@nxp.com>; Horia Geanta <horia.geanta@nxp.com>; Pankaj
> Gupta <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>;
> Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller
> <davem@davemloft.net>; Vinod Koul <vkoul@kernel.org>; Ioana Ciornei
> <ioana.ciornei@nxp.com>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Y.B. Lu
> <yangbo.lu@nxp.com>; Diana Madalina Craciun (OSS)
> <diana.craciun@oss.nxp.com>; Alex Williamson
> <alex.williamson@redhat.com>; Richard Cochran
> <richardcochran@gmail.com>
> Cc: kvm@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-crypto@vger.kernel.org;
> kernel@pengutronix.de; dmaengine@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
>=20
> Hello,
>=20
> On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >
> > many bus remove functions return an integer which is a historic
> > misdesign that makes driver authors assume that there is some kind of
> > error handling in the upper layers. This is wrong however and
> > returning and error code only yields an error message.
> >
> > This series improves the fsl-mc bus by changing the remove callback to
> > return no value instead. As a preparation all drivers are changed to
> > return zero before so that they don't trigger the error message.
>=20
> Who is supposed to pick up this patch series (or point out a good reason =
for
> not taking it)?

Previously Greg KH picked up MC bus patches.

If no one is picking up them this time, I probably can take it through the =
fsl soc tree.

Regards,
Leo
