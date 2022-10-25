Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D19F60CB0C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJYLjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJYLjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:39:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2120.outbound.protection.outlook.com [40.107.95.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37964115437
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:39:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwoZkX+bsn7oW37ax9oj5wJOzCEjvq1dUfzGKX9Emm5ctGLx5S2Y3DZ1ryPndupEiEpizFFJU9KG6Hfr5YHLZVLgCNT/17uhs5fMQPlFhduFBtuU76+VgwPF/tSaXYvoYJ97v2CDwYItH29/CJQQa+o/4kdx/lLZynVGnVLKqi9//o/2ohnGA4ICzzwHhvkXJ1dTmXCLGDhKM1ICQa+1rq8yWu3UgIIFI9dkBkCjJrpwUUE04k5HRn/Q/4dY7scOzLA997VbT8bzxEJMAv0cegJhjWa85AaOdmHTKlo6jNIdrhEROylUQifMgqS00JUiMNZV6+tVccIH2/XXXrJcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kptY22M+CRIthUBbMEC+iPO5r+MuI57K/qN8tDUCD4U=;
 b=DNDQtBuPWRwBR/k2yH8+H2k2AYLZ2feqopgqWlvvUFLxfBt077DinbkPgClbLUhcbqsRJbHIKLfDFEaec9V/2VQS2J/CMBqRoDcmH0RHGUgVrb2eJLI1/ltsv7360lOYoftKxvzye5vpqtAkCSlEkWc2tLEIBzlst51XtTo4P4+jKrLaAYXXviwEGsrmxPMmnZr0rHY/R3fKwEojMs5uJ18QqGnTl+gExxqr3QbFYj6Gu9E1AbjB1hOtEoPEc8FZD0xJsvOaBoIadMKjXfgQKlvhJXPt5NVSOT86KWRNqkTb0hntX7mkcBPVdw+3RDrBcJ3SGOeu1yNebjz3yU5I/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kptY22M+CRIthUBbMEC+iPO5r+MuI57K/qN8tDUCD4U=;
 b=Ta8YQvgrkCWi1HdWoWm8XNsz4N71VWFgyC9RdyiK0fEz8M/LrTdW8HjF5FsFh6drq5AgHSJmqWtwZOKAv8otwEe60AoVLZC3LPMiJq5uLVcZCrziQ0SR0UU4o6QsZ4UxXlrBzvwFhaPN32XIvI4kCFHsX4rQBwbWF+ojTHdFd+U=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MW4PR13MB5457.namprd13.prod.outlook.com (2603:10b6:303:181::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.19; Tue, 25 Oct
 2022 11:39:13 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5723.020; Tue, 25 Oct 2022
 11:39:12 +0000
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
Thread-Index: AQHY48SFgqjha7IViEOJ8498J8TVQq4Wd1QAgAAJlQCACETKgIAAHZEwgAAYgwCAAAP1IA==
Date:   Tue, 25 Oct 2022 11:39:12 +0000
Message-ID: <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019180106.6c783d65@kernel.org>
 <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
 <20221025075141.v5rlybjvj3hgtdco@sx1>
 <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20221025110514.urynvqlh7kasmwap@sx1>
In-Reply-To: <20221025110514.urynvqlh7kasmwap@sx1>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|MW4PR13MB5457:EE_
x-ms-office365-filtering-correlation-id: 0df1f3cb-87c8-4320-5066-08dab67d8a05
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bz3YpmLcpTPQfgQnpae7E9lU9TL8MvwzfG2zFuzcLO/DakabqJWZLbEZfs1mWQw3SS7JcUK/Rk53MhDEhSr8BRMsof014giHvkD1mEdFicN3SWzRqDYRdKakIwIhwYZQmBA/yKJjVyp5ZLbqQ/YZpGppwvjvQC2cqz2oJzGr0LfNAHmhFUDfRXU/3ofe8YJavFWT2gE02QtsNFLHY/fGxflRjEOMVVKfqefc2zrqxJKvwA2qlGbSs5E1rjcuY0LYZ6mTmt//SP0fy0nq0vNVmmXQY/gwCjuqK1Yjc83kjeGiLh/utK5sIrELF2ZAqU+4fdEzUvv63NBFSzxzSZGjSJvS+QAEw1Zfe1GJ4PWbhFMsH47X0Hd5IAdKlH/ftCTvMqKyz65hAXeZ1OL6JKspAHqh098+cpuactmze0PXyx3jCRg/4srlypNtdjXn+jj4cDTb3Tw0pJZD4Jj9bA1+clppmp5HP+ek3tdTHd0K6lZTlwPAWQJjk9P4R4oVr+EFCvooPm8dhNkUH3dKMclp47zW/pzwaDTeacM/INdtl6YKd43zWk8dPKN9y6S9gBxQabRg47ywpptBEA9jCeFTITSmTmOTUrGxKAmawUOjrbxFyNFNbG5fv92sUc4VXZTAr00+m96l0VJ8Sj6ck7BSI9pbYfQWUeMOdtPbQ1GO2XSJ19widaRvbmxShVARnHjbSYVvRS1dYcfPi4jOyMwumQOExk+L+RhRidZyqsftWKhp8nhg77+eoK1KEAJixEZLhtQYGomLOLvzrcAH/Mm4SntGqmoEKUb9hc73CIq5VeM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39850400004)(376002)(396003)(346002)(451199015)(71200400001)(8676002)(7416002)(64756008)(478600001)(44832011)(4326008)(66476007)(66946007)(66446008)(76116006)(66556008)(52536014)(41300700001)(5660300002)(316002)(8936002)(33656002)(6916009)(38070700005)(55016003)(122000001)(966005)(54906003)(38100700002)(9686003)(6506007)(7696005)(26005)(86362001)(186003)(107886003)(66899015)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6o4W5StqnIF4BzCqdfvZUi0K/rVoGoZ0Aa50Fh06n++4siaK5FhsVwQNJ2Ih?=
 =?us-ascii?Q?71xiuf+SPXlXOE1FvWEAtJ0kPhtR1PV00vnJ1stSG4Ye7wDedZxMk06Yl3x8?=
 =?us-ascii?Q?39rBVcou/S+heixMQHj4RBF817i+GXODWbhcWjEfMDDS5oHipgy0L0yuU/1R?=
 =?us-ascii?Q?rS5iWcSIyu818BbsPoxhDURgsuj7V1yBMsigKXoGYN1Gte9MI4u4QDjpfkQL?=
 =?us-ascii?Q?RfrVAtlZXlMdcM7UhMzsUjfxPK/5wYLoc9w0L8+5vds99fQirSXtV+g0+3Ox?=
 =?us-ascii?Q?ixBhhAuMER5ysPzDd4aq+4yRQKJC8P1+uz00Ohnz2PdrisPJERmLREWWvpXT?=
 =?us-ascii?Q?Nrd1bm3Q0btgCo6NUQccbogoOpBN9qqnSWggIKB9oaeG9ymnRwYnkihD37dq?=
 =?us-ascii?Q?DXKYUDHIhPnS/p/EEFaloyZhkJov32J8oyW+QI3Dl4Na3/jR1h4SzCJPjWQl?=
 =?us-ascii?Q?VuRNAds3JM5I+wnpmsdms5bySp0XO1tJv2hu4PfuwCgrfFFQaJKdocOLSfy9?=
 =?us-ascii?Q?aT/xbtbpJjrz1KoYS62yEVHtM3uAGO+ahYjw6fU++bLQPqVq/1qNJhPKu/sA?=
 =?us-ascii?Q?B1Ht2smIfXJF/gFXyL2c+z1RjIeXd5UnDPCqudqa22sfVfKfwkgfOjQl9cyG?=
 =?us-ascii?Q?KIx3cjxNHNcGi8jjs1fQoxZl6OJ0UVNCJI7y6BhoCafC1ubk7Gjp24A+G1E+?=
 =?us-ascii?Q?P41SdCPRpcm26B2lf23oS5RSo090gPyfbdUmi6ZrI41Ol0QfDXjyx9Y/2t2Z?=
 =?us-ascii?Q?lp/oPH4faZAG5B2eaaoJtJxFkX4nWKwk2ouoZOR26oVPsuW1lyX8t/BZNxZI?=
 =?us-ascii?Q?/sEBr80F4yy4siBsfeQmgC/iIe9/nVNscfeJYbXYVhKTL9Qk9uLOwMlfa32Y?=
 =?us-ascii?Q?5r7JJLUSt9xkXvPe0ZzaJBuP/CHHfumy8+mOrJj9OTNc5vw7jR1Y/3I3pbon?=
 =?us-ascii?Q?WcUeq96yHL4grzlzPTuG3kW7ZNrZBEDjCAIwul8VVU/F/5ViXZx+pwwzowre?=
 =?us-ascii?Q?u6VeTsd2MMujFJHcTwNjC6KgYtItowl5AdHpL2rmuqfGx471JRbotzMzGBgx?=
 =?us-ascii?Q?D/Bc0fLpGzPEoV0CnrPfUShsuQPIZedQ7I6lGNQIs1Y3fSIip9CItmUQQz1k?=
 =?us-ascii?Q?k8dWMwABOB7cpA03FvkGSvLBd5gd56PtLrIOUw/Dn6fAf99o3HytbxLB3DK8?=
 =?us-ascii?Q?TXDgWsRrw/049Gc4s9o3q1cgGLfne0bQspezlocsXtI7hWZgOxe9baBUH9Qt?=
 =?us-ascii?Q?6dq6zwQkUii70b/cQPOcpHTFH2IvMa1tjusaBplJZjy6KkAXz14/A0TB0f0F?=
 =?us-ascii?Q?XFFVb7vpvpN6Zw3pHNH3IrH4IYm9bwXrqqxSl8qO/WJRJd4N9Ox9bJ0xWiCF?=
 =?us-ascii?Q?4XINyo9qa11ZK+bQzW3JTCO8tVgjWUcUhNGh0Fuj+ep+ONIyEYh89AI2mqD0?=
 =?us-ascii?Q?YO+4oYllbg/mCVmBaWO/CYfmF8GbPNk58BCpL+k/m2rcv3BFkrGg55qJOnAp?=
 =?us-ascii?Q?uRWFBPbHta1cgCmywp2BZjfDTWNNji8h4fEO5hsikH7yA/GfRMYiUc9azVjo?=
 =?us-ascii?Q?QlL4UdyEZ3fapNYhNY/lahY7kHcKpCtSKHbpvmW+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df1f3cb-87c8-4320-5066-08dab67d8a05
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 11:39:12.8479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MV0wgp88S+OGRFCN7rj1cWyVUUoiW6jKtYfxx5nmWhmjrSFU7UQPbEB0l82XTaPT23oE7zvdR2ughfEeHWcHG8j1/wMLIKsBEvr8zzetO+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5457
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Date: Tue, 25 Oct 2022 12:05:14 +0100, Saeed Mahameed wrote:
> On 25 Oct 10:41, Yinjun Zhang wrote:
> >On Tue, 25 Oct 2022 08:51:41 +0100, Saeed Mahameed wrote:
> >> The problem with this is that this should be a per function parameter,
> >> devlink params or resources is not the right place for this as this
> >> should be a configuration of a specific devlink object that is not the
> >> parent device (namely devlink port function), otherwise we will have t=
o
> >> deal with ugly string parsing to address the specific vf attributes.
> >>
> >> let's use devlink port:
> >> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-
> >> port.html
> >>
> >> devlink ports have attributes and we should extend attributes to act l=
ike
> >> devlink parameters.
> >>
> >>    devlink port function set DEV/PORT_INDEX [ queue_count count ] ...
> >>
> >> https://man7.org/linux/man-pages/man8/devlink-port.8.html
> >
> >Although the vf-max-queue is a per-VF property, it's configured from PF'=
s
> >perspective, so that the overall queue resource can be reallocated among
> VFs.
> >So a devlink object attached to the PF is used to configure, and resourc=
e
> seems
> >more appropriate than param.
> >
>=20
> devlink port function is an object that's exposed on the PF. It will give
> you a handle on the PF side to every sub-function (vf/sf) exposed via the
> PF.

Sorry, I thought you meant each VF creates a devlink obj. So still one devl=
ink obj
and each VF registers a devlink port, right? But the configuration is suppo=
sed to
be done before VFs are created, it maybe not appropriate to register ports =
before
relevant VFs are created I think.

>=20
> can you provide an example of how you imagine the reosurce vf-max-queue
> api
> will look like ?

Two options,=20
one is from VF's perspective, you need configure one by one, very straightf=
orward:
```
pci/xxxx:xx:xx.x:
  name max_q size 128 unit entry
    resources:
      name VF0 size 1 unit entry size_min 1 size_max 128 size_gran 1
      name VF1 size 1 unit entry size_min 1 size_max 128 size_gran 1
      ...
```
another is from queue's perspective, several class is supported, not very f=
lexible:
```
pci/xxxx:xx:xx.x:
  name max_q_class size 128 unit entry
    resources:
      # means how many VFs possess max-q-number of 16/8/..1 respectively
      name _16 size 0 unit entry size_min 0 size_max 128 size_gran 1
      name _8 size 0 unit entry size_min 0 size_max 128 size_gran 1
      ...
      name _1 size 0 unit entry size_min 0 size_max 128 size_gran 1
```
