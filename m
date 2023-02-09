Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209D268FD06
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjBICUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjBICUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:20:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2096.outbound.protection.outlook.com [40.107.220.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A431F233D5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 18:20:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+j8epVj5moMMsTKclUk8XJ//gKxFdkjepB5wv5XA5kimt0LysWHWCXRHxI9QCc2AccoF6yGWtknN/+lLzD9BEc87WSxpY99GHC6qbB6F3fwETRFCHb/uocy/+ztTKyaxaiIcPq0cBOfeI6iexpg64S+96kod3ajqvmcuEjwp6mgEZogBpLNvgQ61YipoEekX5dWDnXmSayQ4iAyJAMZZP3sypOCHDx66L7UWGF9hrTXo3fQBqciJM0cYeHDtD5yto7+VKokxToQ9F1GQX+9GExPDDsJ68Ffq/Y0a/4Vj7fKgJBsKaub0EL2T3poW5+UxbozHyHusdGzOrnkAbaHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWbbr8iLA29EfGUka6QlmYyOY5YExeynP7V+Tvz5jn8=;
 b=BPO02VZUGkqrlBsv9h3O6CIkXMd3nphTxlLo86pMvEBmNtaT/tLsmDsmFZoImw4qAaTJ3JDbXXLFGYLvrhjhz3Mf7LgyyA1vKljIyuWDX5z5IZ95N+8I86nREq9+MWbqYmdY21V2qf0N9xJPlkmYzqxPjM3k88Pn9fNiawZ+VL+iNJOGMXwfQQxA4Ax41gt2YmmBtUI1yE3lhlrDMlgbc5DMiT5XqrFaA9O39l7Fgl05yfmZHWJhEtJFMyHYyfmjDrbLEyZEkUm1d71Eu4UhTJJzLqyIuaSs0rmxtqa9EQo1I0HuJG3WN0frRYZP0yIMCil0/csu6QAM5yjiO9CpfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWbbr8iLA29EfGUka6QlmYyOY5YExeynP7V+Tvz5jn8=;
 b=f7cQhO7wgJ7d+SjHvcOFJvkI6Dp9wLBNp/oRqF3QGw8iLDmEZ6crjmqPRAgutFufTtlUe7+oY4w860/HXkIdoo6m+PFIjUbzxaXM479Z6zHAIiJnaNClDZeHOX780uwZg6yebWC+nYTXdFeSpFDiFrOn4Ynsjxvxy3XCO0zzuk4=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by SN7PR13MB6158.namprd13.prod.outlook.com (2603:10b6:806:323::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 02:20:49 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83%5]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 02:20:49 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Thread-Topic: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Thread-Index: AQHZOkDn+f5zju3nNkCFsgzPnuBTBq7Cxx+AgAIjUQCAAARWgIAABLoAgAADIwCAAJ/YAIAAISwAgAAWKwCAAAk10A==
Date:   Thu, 9 Feb 2023 02:20:48 +0000
Message-ID: <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org> <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com> <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com> <Y+QWBFoz66KrsU7V@x130>
 <20230208153552.4be414f6@kernel.org> <Y+REcLbT6LYLJS7U@x130>
In-Reply-To: <Y+REcLbT6LYLJS7U@x130>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|SN7PR13MB6158:EE_
x-ms-office365-filtering-correlation-id: 1cf73d13-79f4-4163-949a-08db0a444240
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tjyh6JYmy38jxubOErBOB779IrD/kmOaHvVryQXDhZh/RjamqCBdYLZBd3Oalck7qvoOsj5QhwMxHJvx/Sy8xHfG/btWprQ1TUQQteNv1ask7t/9kLkAfXRtcfCevahPNYf5fAt66u7/iC438NsE+xNHfZ9W+7Z1wslaPwLcGdrC+DD75zdZlpWhf3tehb8LeoPQTzFJZRghC+EnXgr200Yi/0qYV3mV3FtIsWaSoq1C5sICvNb0eCAX2RPw+Crk5qQum1EwGw7njol/6FceWKZ31BfHg/YVNCG4RYiWGLu4/gMkr9J+f+n1sA29flyr0lMZPrw0yLoGvwuN11wFL6CEULK0xOVyhoOIsLYbW0D5Gd9El2fE4T1AFKjRf8FyNpa0lwdaxdPeolmbvQWgFinHKfYpaFQfrNLORLo+ZeMsuYcL979JxA6BQIV7tukWPDGP2H2goYK8llOoJlYeeeeJ+9c0bho4cnsM2hrh+oQAJsOb3gxjKOqDLp6FI4LHY54A6VKMGatfix+r0nfEJMtODY/hmPtKkRKu8zxPVQE9RbO4vLxwE12CuwsN5m1EpGMHxtxDFBVYIBRGSJ2ZSpUZYnvlqtm27XxOYdOYXcUR9Nx2lJxdJdcP2vmOkA5B5QsGgRxK6NlkByky83rydjeWl9TwB5fNXo2CWmHtZOxIonqOGZ1JRfk1mUOfEkqS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199018)(8676002)(83380400001)(66446008)(4326008)(66946007)(64756008)(66556008)(76116006)(66476007)(107886003)(33656002)(7696005)(26005)(6506007)(9686003)(478600001)(186003)(110136005)(54906003)(316002)(55016003)(71200400001)(38070700005)(86362001)(44832011)(52536014)(7416002)(5660300002)(8936002)(122000001)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RYWu1uddn+Xkkax/AeUpKD1xOtwdHEd5kGscHL+rDHb8agI/Wswvir8ycTeC?=
 =?us-ascii?Q?B15ejbGFcLpUDOfuq9U6C/fFrvaWA2O79okjZyPnHrJ5rgcLyoUzDEcT+Vrl?=
 =?us-ascii?Q?oVQeehthwrqpl2i/5TP46RDHRzTvOaYgrpt9Wrd2NeNavdVHSlj5OF/B5qZo?=
 =?us-ascii?Q?xIEJpl2y3A0kQ+OnlOz8iXfDeXa1S/AL84aTbMlV4gvUf7xZ06g7foAFjgaP?=
 =?us-ascii?Q?HdliNsLrN2md7ou2o1pmTnzOO5viAWxmvb7u9w6MJLJyQPte3Ei4Fa8g00bW?=
 =?us-ascii?Q?sdxhbFMy3bGZZ/lHB5AQr0GTn1d+qXxbsEqEU2f/wIhoSwsh4A1c3XVAWrtT?=
 =?us-ascii?Q?JiBaJvJvmarHRETV08hAkdn7dMWIj6UBfZ0JESH24/Npdzu/pT92cfa2U05c?=
 =?us-ascii?Q?SwTEtF+6G6W20Rp10au5B4wj1eJGGKMm+zIrYacgKaM5Z756nRFF0Rlhh8Sl?=
 =?us-ascii?Q?ABdremXT7BN9DeBFL6JVRmwzYc/FnMh3hCHji/LyecT1CYuaFGQvNB1vCbLp?=
 =?us-ascii?Q?ppoisst+AQT64GFr0ByUYtnkuNr+YlT56b3+VXrTo7yAX0VhQUkZdZesxHZf?=
 =?us-ascii?Q?AA3n2WftH6pfcawwOIunE3WrFwjFpTJsEd6aS5M4mcpxLdeGDShZ3gAtgHqn?=
 =?us-ascii?Q?uhBDZY67ijHcwMco6SEr9krok5yQHGHqP/2y/GYGinPD5eUzYzDXHllRkdEU?=
 =?us-ascii?Q?ohQ/8pwED7jn4BEdKSjtQOsZLkdjQGrSN6s0rJb6VyEr955Fl3qCAOjZBELz?=
 =?us-ascii?Q?Wnj4K3vsWBryh98Qk6nkuJGfXPumPK5O2vjoluwwTIjheT98OCoMchrkLNr3?=
 =?us-ascii?Q?h4r3kmi6aol4kJgMdHdFNHZSLDSl+Em0SSzuPbWZE1xrERGGSR3Y/YHlS95a?=
 =?us-ascii?Q?4yICPdMpoBGOOV/ba13yUcLwznCvUYtVXVR1xRz8x2sQI30C3jNcljFqdcEc?=
 =?us-ascii?Q?ijXatz1XdbUOgvAtdoYyT7haFjGnTsehPN8eJBEqxmT3Xvwje/J+5MGGl0vw?=
 =?us-ascii?Q?Oz2zNUNSiNNYYtDJCX8AGlq1n1TMCD9RVRt5KdmNNbEVYc7EX1qEveCIbBIt?=
 =?us-ascii?Q?kC+w7iUlcXxKcd6qPKvN8iJErOaU8gP8Do+NJ8Z6qcHIT8yFhbJaXmXtF9Vs?=
 =?us-ascii?Q?qEbk1sFo7rBta7PrrFS3ArSwaaNHFlQp+Tp5v7QD7hRbiM8MKY8mfBGRt76n?=
 =?us-ascii?Q?XjyJsBJ+03pIy5xtooc2QdVZOkUlQtKSQI/Bwfs6uFiZ5hm6jARS6cyPpgdG?=
 =?us-ascii?Q?T1WneTYE5WFBE4Kfn+3XKL0O5gSlBSuRczECGbUEkT7iPimVDTDNEwxL5ii4?=
 =?us-ascii?Q?hd5BmyWgEdCuRZVu0zM4e80WZ6+1gSAAWUTR1jmoNqRHBaOiVyrfLCeBtCqL?=
 =?us-ascii?Q?Ka1r4JlcFjYCR47bjsZVa8vzcOu7rLPgQ+q7DY84vfPLRuw3Oh/Dr0WLt8iH?=
 =?us-ascii?Q?KaKRcquDNVE+AT+RC7934MrqJiPqA2CgRBjtFx2C/RXtUTfC2xN6vE5SjTmq?=
 =?us-ascii?Q?/86iVGYKuWh5maoe9JfrR8wf7RTGnLptHSW9dxf9Xdx6X8ri6/AGOx5kmi8P?=
 =?us-ascii?Q?eBtxmSjLBesR665c6vBAH4+0dZwdjgB1Zv264MH+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf73d13-79f4-4163-949a-08db0a444240
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 02:20:48.8169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srHRQLcG42b8JwvU5LiNFzknDj33PZTL0ETpIcjVdWFfatyYYpi4qscOe9fQVfWIXclkIC6xhQcB6+F4qzRNhrOb23jX9ZvXxJrM+zKfkLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Feb 2023 16:55:12 -0800, Saeed Mahameed wrote:
> On 08 Feb 15:35, Jakub Kicinski wrote:
> >On Wed, 8 Feb 2023 13:37:08 -0800 Saeed Mahameed wrote:
> >> I don't understand the difference between the two modes,
> >> 1) "where VFs are associated with physical ports"
> >> 2) "another mode where all VFs are associated with one physical port"
> >>
> >> anyway here how it works for ConnectX devices, and i think the model
> should
> >> be generalized to others as it simplifies the user life in my opinion.
> >
> >I'm guessing the version of the NFP Simon posted this for behaves
> >much like CX3 / mlx4. One PF, multiple Ethernet ports.
>=20
> Then the question is, can they do PF per port and avoid such complex APIs=
 ?
>=20

To answer your last question, it needs silicon support, so we can't for som=
e old products.

Then let me clarify something more for this patch-set's purpose.=20
Indeed, one port per PF is current mainstream. In this case, all the VFs cr=
eated from PF0
use physical port 0 as the uplink port(outlet to external world), and all t=
he VFs from PF1
use p1 as the uplink port. Let me call them two switch-sets. And they're is=
olated, you can't=20
make the traffic input from VFs of PF0 output to p1 or VFs of PF1, right? E=
ven with TC in
switchdev mode, the two switch-sets are still isolated, right? Correct me i=
f I'm wrong here.
And the posted configuration in this patch-set is useless in this case, it'=
s for one PF with
multi ports.

Let me take NFP implementation for example here, all the VFs created from t=
he single PF
use p0 as the uplink port by default. In legacy mode, by no means we can ch=
oose other
ports as outlet. So what we're doing here is try to simulate one-port-per-P=
F case, to split
one switch-set to several switch-sets with every physical port as the uplin=
k port respectively,
by grouping the VFs and assigning them to physical ports.
