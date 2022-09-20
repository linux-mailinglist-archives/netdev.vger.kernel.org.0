Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D410A5BEFC0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiITWIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiITWH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:07:56 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F08786DE;
        Tue, 20 Sep 2022 15:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFmzen88U/iRBXrbyF7iKBokzQLLm7yOZvKjEpWpKKRv0S0ThoRBNXIufXb4ORG2GnbXTQPnExxn9+QiZwKYSf/rAamc7I/UngC0if5Rw/K0CiaqFBe5596YhXBhcGmXHWh3cGewoEwcOZLDszy7QgC170Th+XJJUP5dR3s8reyS5jlCy2T+0ug4HNHVZqAXG2wafhbWpkXhN3HGwFigs5XdqEmYu7cjcLQI/5qq0bPr9/kH/1rQmSm+yzFWCmKk1zhvwYEmMlmBeGKdikxXrMN24RSmyi1uXG9PfGKCTOwFE9ArD2qmztF5skal2fAExZzHXFBdlRLmLZDwKVTR4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUjEiix1TNRcGytBMihJTs7i8pP3wRw/8qCE4o9fG4k=;
 b=JuKxhm6DRiP2wrpMkSy3x7pbcmYbr2lfHiwK6XjqazccRxOqq/TISG0pLIEUv/GoSvZKAcAjDmpiBXy6G/mvZVqju8VY/rJ+FG9+PjcVl5MQZ2JViWIhWGaoOeEWznLkSZlAQEzrioWH9n8GuQyG8SZp9VrgA83AhIsOXVPobQ32kMuYFrz4ZkvyhUyZzoc6mhCIDQ6X7kDpAHQ+rmgGhBK4Z36kHnh4CCn/NXTRoHY+O4FG2orXRT9uYrWvp7IeTszGWgznuboS9FYB954c+K+9QkaX2ltJ8ZRM3hhV0vARMgHL3oF/vwmbGmoLetE06zXoPAsCHGqQI5r/LWIYyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUjEiix1TNRcGytBMihJTs7i8pP3wRw/8qCE4o9fG4k=;
 b=IKN73Px5QyCUHl/js1U3NShQfr96MKMBAXjlYcOGaDZVteLvs4oBYpqhW3zBUHH4G3yahcBheeqyTd3tfV3zJrRWuCczcVdPqPqVJ+lci83+aIH5nheJ4zvN232EsGI5dk1CyNOPrIq3MSI1FZbsiydFFPJkmy2nlSyPfPuXhow=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3683.namprd21.prod.outlook.com (2603:10b6:8:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 22:07:45 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:07:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 10/12] net: mana: Define and process GDMA response code
 GDMA_STATUS_MORE_ENTRIES
Thread-Topic: [Patch v5 10/12] net: mana: Define and process GDMA response
 code GDMA_STATUS_MORE_ENTRIES
Thread-Index: AQHYvNF6qvmv77Jq6kyb41HUcPJc563pASOw
Date:   Tue, 20 Sep 2022 22:07:45 +0000
Message-ID: <PH7PR21MB3116357B9B843F9581FC92F7CA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-11-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-11-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3caff989-fba9-4ecd-b8de-4877a0628202;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:07:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3683:EE_
x-ms-office365-filtering-correlation-id: 77078812-7779-4eb1-9fbd-08da9b548bd2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QhOwj5u5xUsRyLKdCkr4HHdBv1rZPdLeuR4Q5oIGVpnxIJqx10UbBJE1hKCthiR8KQx5iJ64H3o3S+uMNdsNAXBYz5Job97kOA75TtJ6W7UEbvsPsOsUiZLCNEwoLJG8Orqy2+/mWD+uoYHjbU2GQy1iuDKWCUOyMKhed414BJgka8pA/tsHS0Ms9pbDKff0qjQJ1wn0qZdn1IydFUJrprXOUfnOQUvYHO9fz8opIGN03D+d6DHe6FEB/ajfZQfpIu6+8nSZWeQnEsc1GezCH9bNZr5wRLVITiyWnOe+4aE/4EmjQzE7uicewRrnmVufYCzsaRacCdQYhAGZx50006/9OfBjqXJCULVfYuy8BfNkXCKw7eXBoJtMZUIzMZVA1GtOBmEVDaUOz60jmbfrbKlBnSmBLGHn0AqnM7tfAD30edGTQ80h6I7ollWVLJ4vrfj+USvDM8H2lBJ7IlRG/Znpkcpg1bNvppR7RNmuHGx+6VWsSSupZC4XT4nnh2Ke1ggNH9JO8LHn5Cwf9yRD6gw43RV/P+CC9XKuWTiNAQYDePGbTKiFN0Nzh/hC/FO9F6X2b+83bc5HoEJOIZeXVvTmv2w5z4AnYw1nlStJtCCFHvOqW7kP7rwQYO1gwm4PBfQYSoirhX/oHDz7xLfuIsV5AaNU79RoyeCbw5xO/WIazo4Hs0GOlElJLb9kStv1VSIAmN3jqLXocVnJuavnUeqL7WMb167PcdyUA6IVDYzj7XiMPd8UEi5b1Tp2mpGwOlhyls0vgDqK7M3ey5Dppo6rtvcSqwy6q+hnpcCPQafLIJq/h5Wo5vsBc4PJNXfTTk2AxU86p+bSOwbPd+mvjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(8990500004)(921005)(38070700005)(86362001)(122000001)(186003)(83380400001)(38100700002)(76116006)(82950400001)(82960400001)(6506007)(2906002)(7696005)(53546011)(9686003)(26005)(71200400001)(478600001)(54906003)(10290500003)(66946007)(6636002)(316002)(110136005)(66556008)(41300700001)(4326008)(66476007)(66446008)(64756008)(8676002)(5660300002)(52536014)(7416002)(4744005)(8936002)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s4Gya75vLJBGxlEUFd0oP5c8qFFUgtGlW6y0AlIbqSf2xEIlKg9edgJ1UR3I?=
 =?us-ascii?Q?dxjGUKMVhL122CwfrMBN1XMSr1/e1T07XN7UEMCQWdNVp+IzvV451fit22De?=
 =?us-ascii?Q?vy99yQjpzXSlbrtxdTk5QJF4Ku125F+aYynP0KUWVQZxeKlejLFHe66CpIrW?=
 =?us-ascii?Q?XV2jddklMUR1By0RlNQJZcKXFcUWut6VlI6mYXbs3KZum07mTx6+UzSREuwe?=
 =?us-ascii?Q?C5sO383IjVTctQT3c52YUF0/ZhS7ZP3zv6rjLxgFybEC2z8ygC0Nn998SSro?=
 =?us-ascii?Q?XADVQqfxWSYvZUcho43f1uTxnoq8ZuXBEVa+ofOcbejQtxg3rqIgWY7dPdlk?=
 =?us-ascii?Q?ZhvMI8GfcDNFDnXXjzF4Y6OhUIzjJ6elrxs00UVjMgC1bCjMyS28U7/ptr3U?=
 =?us-ascii?Q?jnMWkNyhewBkkKik5SMaKBOtlr8XcndlL09bLspR5S2YQa9Up4GLmza+diTP?=
 =?us-ascii?Q?lvxj4hJPAuUOhkKApxvdlHNkd5t0lWOYkBlrmMBa237TlnBYcQxzyBq0uakO?=
 =?us-ascii?Q?L8MutOS8gprDA0u5Pwvy+J4CzXbQTeckjiyHb81cpkEjNgwhYoMXoWyHvuz6?=
 =?us-ascii?Q?zjRqxqQismlk+x2X9oLmeFfyfS/m4GWAsGlrxliKyhmGCN1xpuN8r3BT3oGf?=
 =?us-ascii?Q?Y16457PXTS8Awsybb2FApQKZYhCy8+U/Udm/VGlsaSD9kzfs6Km6+OWccrKN?=
 =?us-ascii?Q?o+7LC7O2aPjAOTUCelF15GiJ1/IOlw14L/sqNAQ05V7R0vhCM8f+uWUNBXne?=
 =?us-ascii?Q?3AcSfSjSHBes5bR/QQzLIUI91bmbtP61a8pPPLZjTkf3Xt5OYtcJDYKWTmAc?=
 =?us-ascii?Q?KOlQ8q1r9K9g1PLvUEbBMzE3zU9o2baSY/FOoWT6mbdG/C5kcAUhulPMtorW?=
 =?us-ascii?Q?BOtp4l+GYzPk37bG7Ad301pqMa5Ln80/kZxF1ghL/jsVKM2ad1KPXs1tqWrs?=
 =?us-ascii?Q?s5rv+uqb4+iZbPZnE54mDO13hyJWwXm5fYuE2F26cI4GUS2fYpuNUeftfQHE?=
 =?us-ascii?Q?cqEi7xMXIa1KYnLtgzDoGi721Yo9KyseW7SME0DqA08vwB8MJlT8r+AFYtPW?=
 =?us-ascii?Q?zSjJwWzDCDCeCPgKjU3OJlIDKAer/17REHBX/s5P0/ClHSR56Bp0AGrygFPY?=
 =?us-ascii?Q?EFTepfg2katXxpHbODJACjb3nhv0jwTZ+ibDCcKFxZ1cdxWSNRYxv/FN/zpL?=
 =?us-ascii?Q?fQxCQ/q5TtQn5xO0kiIquG5LJRq579lGv8LG+7LrP8lvp9QA+Ychnzm/Uz5r?=
 =?us-ascii?Q?n9Rnfk3lWqgy5wfRwH32Je1pr7kCfsD41GyPsUTfj+2MRBZslO5L+4IDBqFs?=
 =?us-ascii?Q?bvC5rDiLFmTFYmfzwhq/v/UlvvYULuVojsIZV6jxHZeZbyzm2PZDMcZLPFmZ?=
 =?us-ascii?Q?dcDnT37tPGs7hwrRKAa2DwNy8sVVpvp/sNtScQRNn2nQ8HYQ+oHShtJtpcP4?=
 =?us-ascii?Q?f7l52Cv8kyVmi5FAUOoBUcO8/gKIgq6GGxEHXcHpdaQIIVZ7hDIEJaJgyho1?=
 =?us-ascii?Q?8A5tnVAFsDbL6Zg2TCd5LRLQpxK2seDnAdVsbExNxpWHk6JwwaNdSNlKVTEb?=
 =?us-ascii?Q?EFyntbqpPPgGsQH+YaIACyxnw5HPd2z2s6HmJYEf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77078812-7779-4eb1-9fbd-08da9b548bd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:07:45.1414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eR/aJVltdZ5B9y6xnRhBcy/jEg0c9wujr3Zm2IfRAkMaDvtFVSnjYrwOT2PN5bPcXMm6ZVZQOPGRegE8r5piBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 10/12] net: mana: Define and process GDMA response
> code GDMA_STATUS_MORE_ENTRIES
>=20
> From: Ajay Sharma <sharmaajay@microsoft.com>
>=20
> When doing memory registration, the PF may respond with
> GDMA_STATUS_MORE_ENTRIES to indicate a follow request is needed. This is
> not an error and should be processed as expected.
>=20
> Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>


Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
