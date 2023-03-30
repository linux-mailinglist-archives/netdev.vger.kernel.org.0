Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CCC6CF8EC
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjC3B4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC3B4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:56:16 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2092.outbound.protection.outlook.com [40.107.94.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0BBEC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:56:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmP2ovLuHcDN9aO4kTDLbaV3nx2DU9Atdf40fuoWhWNCLVs6G3AaNgYcGZNs8YqKdshu2WeIl3/jxCLqRPWJPMwlxK/bEDlQPGDdLhK4vNCRavuF4C+xHbbDnWWlMu9GQhherMOxEIBiza7ce1B37f7YgxKFWGiotmDRDBd/35wJJJFZAUoKo2kQhdHtTeCW/EMoZ5ioMoXLc/yItjDkFwyVL5zzYeIXRL7bFRKSrlNs3ByPd8ilPuNowBuEyXKRF21LzLeD73QQN0fKF/J9dQJSoWuiQzGyhynwlfcXTHZVyqAYlg4P7IP/zbJzHv3YIuPhivQmIK2dWsAKxgzeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAPAR29iY6yuQqexxlqsM+91p6T16ufypYAWHAT0QVI=;
 b=WpHTbQObbrjy6PJIcmBO4F3lrUECAvlKWWI1pIwzE2Dvu+6gJQnNURwpQC2PaGLhqJvWlgjIt1QxdvmP44TVmINuhi/QXMpFl9RXeHavMNQsec49qXJYgt91mr8NuyqhUiNBHB4Jy/LDG/BnyANt8ZBMa5/CjxW7Vh/LcdrTpx1AZqU+dsUDBrFJNmniXiu5QqMJ5XfJ5D8ljuc6zatR+Y37MSyh24LguSHBr7hJiUykYR8edVp/gySORtgSxbwQMUuzoQ9cGIBD30zDn8DufRegwzMOmOLRC3OaVpYQOnWcPUOUQ2LKWw3AQ3ODAiopwIpMNMpBjw0QvHqtRvCWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAPAR29iY6yuQqexxlqsM+91p6T16ufypYAWHAT0QVI=;
 b=f7iaLcLIefRn1I5pql35seSzFxgVlhrDdv6rq4hBr+XedYU3vN8sPZVRFuh3qFiHV0vtcc9d/4fF4kpnJ4WBak4bV4yrACLGJJT0/em3mqBZlc5gBnzKom1Qt0wDDuYH6Q9aV7ApukIOsZSxfZO47juhLPHs7m2EGMR/H0lnDb0=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH7PR13MB5456.namprd13.prod.outlook.com (2603:10b6:510:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:56:13 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::8795:a7ba:c526:3be6%9]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 01:56:13 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Topic: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Thread-Index: AQHZYk07XTN/U7MQDkW8TxKgBUt5LK8SI4YAgABrcdA=
Date:   Thu, 30 Mar 2023 01:56:13 +0000
Message-ID: <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
 <20230329122422.52f305f5@kernel.org>
In-Reply-To: <20230329122422.52f305f5@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|PH7PR13MB5456:EE_
x-ms-office365-filtering-correlation-id: 413d1455-4f46-464e-a301-08db30c1f0f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C7PxWqZ4eaiU4Lb69wyZJ6VQqd33U7HxfvpN67W8C+rCMgsWMCDg7E46bix0/0u4J8VGcI4tskFUJEWMWut4GcGVfXP6UvEy+lHPG68guxbIxCrWS4vkqaz6PXv8MJRbG7Z+Mlok2DYLjWG2uFlMPpXKLldTBaL/w1ENSUcha4NrTU9WcLz1mBwj8THz369P09UAotiR6iZueuzQ5zZ8+l2XyzNhH8QRtAFCdDmQMEmoIKSlr25IngV9wLGmGaFPAuY+pB+proToe83o5lmTmfqUqN2HKe+irfSnDA169xb6DqQOOPaL3B8S9geDDdy1vNLIsddVJNn7bIHJbKiMurLf8tDZj11SsNlYLpjsyp/S0WVJG6Y1fVErFfBhkfZ9rUegYElDu5i/lMzS997upY23Rw2z8bZcyqYK9sBoMK70LJD21f9te6K4DX3KxOnk/35eVwZUcI3pKWiq7TX2ZGIWi1Zc6XqX0ihxCW/v81opjbmfYGKEi5HUp9afFLKaymGmAkAiN2T7ZmajA3KPphAXi+eI9WljXiJD2YKFrR4ZTz+e6cMMnDRyf2uEwsH5GjHa2hdFh+d/NsFqmNHFzlhzbj7j5vAA6peZspPGvE7Smfb7XrvFqNIoZdqfPKkt9Mn+3bRUPuFTl71DFHsj7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(366004)(396003)(376002)(451199021)(52536014)(5660300002)(186003)(55016003)(8676002)(41300700001)(8936002)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(4326008)(33656002)(71200400001)(7696005)(122000001)(38070700005)(86362001)(38100700002)(44832011)(9686003)(83380400001)(316002)(26005)(6506007)(2906002)(4744005)(478600001)(107886003)(54906003)(110136005)(6636002)(20673002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RLZB3zaAvjFAAxlBHWiDrTfz+Bnxp/Q4nCfRM9jwjB/Cc9uG43k3fBgYUd5O?=
 =?us-ascii?Q?2WUS78xJpfHcyJVaZuYOK1axY7yuDPMDMYLw5FExoimI+pE21OhoQOxhHuzH?=
 =?us-ascii?Q?YqpnhSUFdi6putoTw+BV9YQ0nLXLQGExlTrajn1KIIpXmvmR/AdDcoERWimN?=
 =?us-ascii?Q?M8o4SJG3KGVDMgfTdQbRG+psnQDc3EC7itp8Uz1wAatxtdP19IIi9ElaBXxG?=
 =?us-ascii?Q?I1XQxtP1qEuupvGvyup92Uv58Yh+VuBy85y2KdAYmeQn0xvICwoY4ECIJMvv?=
 =?us-ascii?Q?BzikrVj4Nc1L/+70f77EoSoOsX+cJGbgnkCCrQjPjfV0oFFeeOO5yRISG9z4?=
 =?us-ascii?Q?Yk46UK1dCbs7Y0q1K+KJ7NkJlc1dLjFL+FUSBD7EmmemIVuAej7IPEm5iJwA?=
 =?us-ascii?Q?dXJzZPejhEgUfEyRpgfikd9bweFCatdmOWSzwG7jIzMYlPCz2stQelUZxRwC?=
 =?us-ascii?Q?RZSIvH8oXBKglbwJy5tEQ0vEBygaBI9yK3wjG964DGqLgytnywEdzlXaBGFB?=
 =?us-ascii?Q?7gak3OlXutzEBxvnuv/+vqDmrpoDG8VmyhYvWlDF9V4QIIMztpuFr7VkTWb5?=
 =?us-ascii?Q?3l3yNoY+9ksbDYLxGzBhyxeyZH4p1lTzlI1+Uejpx6mnQzVGNLsxN+SDpD3W?=
 =?us-ascii?Q?DYBOFmoeSPueUslcBM88h6KlP0f2sXabjSZ394acElBrHhFN5zDkvMZIshQ/?=
 =?us-ascii?Q?XP+dnP/2RBnxI5FObm1vAFeQFyt5NuPLvZVCwoyUwppehVkp8e1TAjyA3hXU?=
 =?us-ascii?Q?WlCQF5lbqTeumqbx4EbuwFewsc9cgiq/11voZmVBjRvSXp9tBtpMrikgXvog?=
 =?us-ascii?Q?IMDC2mNz2HVVW7SYoTG8HePgC5cBjigP8CPHadqGXptdBsTmy9+TMijzVV9c?=
 =?us-ascii?Q?D0MeZiC3ps+xig0kxMwtiuxF5DJSG8w9UG0JJMa+RW8/r74pPCEeQ0H5Mkwg?=
 =?us-ascii?Q?kY9ERsC6wXYwUBr2bSE6tvgwxHmXMBS/lDM3MEbahx1+rlpavaSVht+t5OV8?=
 =?us-ascii?Q?iwNHdmjlunoGoT2ECwg8tx2ad4qog7ptPsE5/sfJZNO9eJFJzwwib5eYEoqr?=
 =?us-ascii?Q?0Vx8Vvm4XyDdzsRJJqpANZdDtbpuW22D0LFoJdFHQ2trG4FY0rsAaZMdUF4N?=
 =?us-ascii?Q?n2CYZaETHS2E5dDifuu+MQLHJG9WqlijL9A6fadQk1i46ZEP8arTT2AdtXC7?=
 =?us-ascii?Q?9Wc/x/ZOTGvneTICnFLUcau7H1/skOrJOcFq4/mq90gmGfzFxLV+OObvoLfF?=
 =?us-ascii?Q?xq7MxB4LJqpG6MPq9yAiGrZZ/B5Fpl++3yydlyzmpH+ZEvEet1uSkg05m5ZC?=
 =?us-ascii?Q?sA/QWVC+j7Aw336oLZx5oIq2fAM7rK3MCTo5gssr+kht6osIqjilS/Ajl9D+?=
 =?us-ascii?Q?P10xyd4H3XoaYykeUJ+3nc1dh+kr/gX+IP/i78/mGHX/BY/8KNE8Ad3gSoQD?=
 =?us-ascii?Q?eOoW2I4wPDN4vQhOz4R+f9MNeeIJ7prKG2ROrGRt3+GTPzyagryAMUb1DQRb?=
 =?us-ascii?Q?zcmZPkag1t/SKTTx82J94Kn7VLrV5MJ+XtcNmrqz1Mzoz0G0a023OVXAoJRv?=
 =?us-ascii?Q?D+9IzKuFUBBQFaDJA0FGMEu/gcRFnj4uAm/UFD6R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 413d1455-4f46-464e-a301-08db30c1f0f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:56:13.2288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJ5nSAZQ/BgwzSLQn+6EXeWlANcKedjXe3CW4ORGvDJ4FBaHvYiwqqy88gPDUbgbyfffHpc7ewRT+WfkTBBv0+OsVCLuyN0oJpIzE3EdQJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5456
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 12:24:22 -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 16:45:48 +0200 Louis Peens wrote:
> > For nic application firmware, enable the ports' phy state at the
> > beginning. And by default its state doesn't change in pace with
> > the upper state, unless the ethtool private flag "link_state_detach"
> > is turned off by:
> >
> >  ethtool --set-private-flags <netdev> link_state_detach off
> >
> > With this separation, we're able to keep the VF state up while
> > bringing down the PF.
>=20
> This commit message is very confusing. Please rewrite it.

How about
"
With this separation, the lower phy state of uplink port can be kept
link-on no matter what the upper admin state is. Thus the corresponding
VFs can also link up and communicate with exterior through the uplink
port.
"
