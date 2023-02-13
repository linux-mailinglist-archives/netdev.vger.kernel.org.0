Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD8B693BB5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 02:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBMBXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 20:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBMBXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 20:23:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2137.outbound.protection.outlook.com [40.107.93.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B232975F
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 17:23:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luiqpdHjbo4Ji0SpsxVImJe3yeRpCQ60OU782YMj22CUUWDm3KOoPirY4HnJL8xiI321p5lBviNJmrLwXSzvm/PMTX0VGArZKXdZIGxWOoc+/thAzNOlJ/K9f6O3zKyXiq1R/Z4mMftJgqWTtFOTkTH+s7L56PgJq3vbXNcAFi43FJNtop0gwEkQ/pVbBadu6DROVe2PXwLhKDMYoOK2aDkIadiPZiaUMAmVo4M05edWLVGfN5dtLLdev1GKbtUGUYzD4EBFWgWGr5RSlguE/FPhmEdXaRsawDwzVaPh5ka/MCDMhzwwqGtz9E4I1Z9Ib39FdsyPuyoYBs2nFfarpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBRvY5T3wwnD1RupUaZJcmp/rZLs0WHy1u0ShWL24DA=;
 b=cQh+LUKEWT7bBFWEXy0UT5xV9XcFSJmKbsUTGaRAVn1LpePlahpD/401ECJYM3odF9JcntSbHktoDB44F7f1mi/ovqGJ8m1yfb5tqKKpz1vRXXadpuNoce9trZUzJ3bCq8EEpiZ9e8eKzKn+gs/9KuCyHuKJrEyCc5wQ5o1tKtxc9MMZ4GMgTn4IrPXVkZ043XIAPOwjjsDFqDsJNJmGI6izTL7C5fYF+UREkhNYbP2OK10YYRUg0WVhSQrlEO8PwbnnR6b5eFNdokH04Ap3v9C7tBBLPVC8wZ91P9j1zJTm67Q7eYagoZuuoHy/OLg1XAk7e7sihaYNlkJya0MM/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBRvY5T3wwnD1RupUaZJcmp/rZLs0WHy1u0ShWL24DA=;
 b=czxdvRCXaRdlER4QvKMpsscr53ByXuZsCKUO98DHcWIxxXz346K9gcKNjZ57ceR9+2F2iIzyEDv7UrOy529RZWx7K9onHbo7JxWlQxZ9tW3hKLPmcjrimZNOM7+W4MqxMzNWA1Dr7LvkmyrV6RzVeVcX6onYpzlFEvCOisD8L9g=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by MW3PR13MB3964.namprd13.prod.outlook.com (2603:10b6:303:5d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Mon, 13 Feb
 2023 01:23:00 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83%5]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 01:23:00 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Macris Xiao <yu.xiao@corigine.com>
Subject: RE: [PATCH net-next] nfp: ethtool: supplement nfp link modes
 supported
Thread-Topic: [PATCH net-next] nfp: ethtool: supplement nfp link modes
 supported
Thread-Index: AQHZPTWRgOBOvS/0Tk2Uq0Vd9HFUd67LpaeAgABx6VA=
Date:   Mon, 13 Feb 2023 01:23:00 +0000
Message-ID: <DM6PR13MB3705C4BB6A45461E6569C33CFCDD9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230210095319.603867-1-simon.horman@corigine.com>
 <Y+kwMecYgmFdtmMb@unreal>
In-Reply-To: <Y+kwMecYgmFdtmMb@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR13MB3705:EE_|MW3PR13MB3964:EE_
x-ms-office365-filtering-correlation-id: 9218f850-4bdf-4276-3873-08db0d60d8a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2a1arSDhq6k+QeHx0XlY3D51jhWKuYv9ZG1pm5f7wPdm1bZEync9AaRtXioXAWZFaIkfDurHguNlwgYDZ4wP313jGbX2BnsyrMXVNo39AUnjxBceLg5c7La3Krcv5vCvUnw65yztPeCdQZ61h7W8prbpTIkM2/SBhumX2QYu1aWFPib6sCO3kDFOZRpMDTbledsmd22iPBL4t/UqcPMUJ19+CG3m4Zseyc49w0DTvoXpKtCuqpjrkngGazQ5fKRTCmayD2vlCSn3yIHBiNpwkKkfeytAY5+CrdnnyQHeyBn21UEBiSFr2d+hGoosXPnKxzfUHEIex5lAgh4jT7e0P9QZDSWOtMcuSxnbGxYm63P16HgTow3l/4WmgPgmY8jMiYslXTbSyJUgNELAgSYYauKZErErNVwELCP2sRZyI+cp+EkMQKXs8rH51TReDim+vR4gdVJaAWBCc1a/kkdtWNfbOn9ktHS2Hk5QWCbguRmUWPaVCw+NsYF7sQm6bfRaRZmfSNjDWumK0CdX95aVq+Im335841fkLWUIRUS222gl6Yvs8m3YTiS5Z0Ovcum00AzRNz/3JCxmJ1fhZx9Flzi9i3vT3RYA32JeNTtwHl0q98INiY6ClkymjM+Vo9UlOYMLhA3ol7/wwcQZRJbmhY7pCIzxauBqzuJ3ORCci6MoOUjwjsP4YpWUM36r4da5ZwYarQzF702+EuGXAXwErA6UyD26AZMEIzZXwvCXbuss6mS/tnN7JCkJZoFxliW4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39830400003)(366004)(396003)(376002)(451199018)(41300700001)(8676002)(4744005)(9686003)(83380400001)(107886003)(26005)(38100700002)(186003)(122000001)(66556008)(54906003)(33656002)(55016003)(6636002)(66446008)(76116006)(4326008)(66476007)(5660300002)(110136005)(8936002)(66946007)(64756008)(44832011)(6506007)(52536014)(71200400001)(7696005)(86362001)(478600001)(38070700005)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?khhwUPpA2Yoxks6WVYUhr7x3sYOjbPAEGz9y5QFln0rvvRlDWUgc8UJkIUpd?=
 =?us-ascii?Q?ZhCZui7YqQj4Ii+qEc9sJhNklffLWDnWCd0EbLrdnNocZP3npe/764vx6PEa?=
 =?us-ascii?Q?LaRF7IJrK7SD7khgvrTjglB19tG/JVhoUfoGfs9TyIZ8J/KjF1sUdpV+jGmB?=
 =?us-ascii?Q?ForEBLIlG6yfj/6uXaA4AskjvdML2XqjEdxHl4lDKpkO3qVKBBo5qBV4jmfg?=
 =?us-ascii?Q?wKaBsiJ9WIWxJzJndRk71E1sD/D+RFWE1WFDcppfB8cAE1KoAxv6TOvSbRJZ?=
 =?us-ascii?Q?D53EEy6RYvr/mnoiu8k1HLDapwq+F+0zxpgf3JjUI6AEN186JsF58sYXRJvx?=
 =?us-ascii?Q?PTtsW5Cbr4DgydD8AAYb97Gbkjw5UetId3KfkEZTtrwQm2lRwHH8cpJinsTY?=
 =?us-ascii?Q?KrNLooZFFQGzGS9DZ3Ny4UvWNOxiPEHixC5rFPAbj0UyEs7qHWo5ByYG7ycx?=
 =?us-ascii?Q?S7WfraJMdNmi/perjueiJkyf6to+Gv9DH6mW1G63fdYSDSapxAD+EXk3iyEr?=
 =?us-ascii?Q?/O9jEm/f6ooPxOYVaIhrObYHHIdUzd+vmIyQzddVjQ1/FR9vt2UUSO7ckOdK?=
 =?us-ascii?Q?0SBv8d8RCKqSYk592AJkm2QEeypOR6twViN63ABXpn9xi+2PJXDlZ62LNF9e?=
 =?us-ascii?Q?vn+dJMJG+GK990P3qatkMrj7iDHm3iVVYSXs3ec3qQh4SuT90eF4mkcYtRtH?=
 =?us-ascii?Q?cpyK5PPdJABFlI204FDrf3jYQwfMJGW3TVnGjbXKD7mcI9oGX+yt++MKpQ8p?=
 =?us-ascii?Q?5ONFpxYjZMvSXFSL0NeKrlMCeA4srOfyb6EKBSdGVhn704Ek358pchXslnRk?=
 =?us-ascii?Q?BJqmbqn4BJai5+xg5pSk2s1ecBmpNYf1yyXqRa+XN4c6hpc9bbkkIC/oWO30?=
 =?us-ascii?Q?eDWEGCKoLAh2raAMo1reAEGrPnnZzrggpZ2ii+Nizh1tIRo6DVE5aOS9J3rJ?=
 =?us-ascii?Q?3OvPhcuf5gYYW8zq2x7xw9a2ML45aVPgGxdl87NbLNXs59Mkg/pCgGNEkF7r?=
 =?us-ascii?Q?HvvKSm8bCs9AcAy9uOUTAS5dusLhvbRd90Cc2fxuvzrhqv7lmfaKyWyMTXDa?=
 =?us-ascii?Q?xuwDtNuUhTDIuiFqAW3bZraKGzBFKyF7ImYyqzBAx2uki4roANXt+8XUcqUw?=
 =?us-ascii?Q?nAOXslt+Pzz/k4tvpuuKA18H3jIEhR9RP3BG618dpqfiQlzec1bojvJPRHvj?=
 =?us-ascii?Q?1dhoaioC3j26/gwzlBELNlKZCRvLzImU9wYsotJUCh0gPiehnl2pZzJ1KHa+?=
 =?us-ascii?Q?7Pq2qE2iOsFqGRWg8Xm5TXGMc8aUOpuRYb1OuNDlckQKCqeubgG/ZadatNVX?=
 =?us-ascii?Q?Oq3dFuWf2jCKFRSxnBGEFCyNkEwoxGJD2nVWdipZw/oes7mZvswmrYEs2Iup?=
 =?us-ascii?Q?VAVVBoDW3bAsA9d+/WpiAHbrvkwDi/6rU4kudCYfJ3xMxhDNfsXfSW8hMr/f?=
 =?us-ascii?Q?VK4I7/DpruiI4/G8zrvYGWcLGCtJ4l6UYy9IgaJbLL1AIVvFqV4rOMoT3T4o?=
 =?us-ascii?Q?HQUId7m9VRJ2EVGhQH7KkawxA9j1pjb5PAvZNCc0k92eMAfoNZYVB6oC1hFI?=
 =?us-ascii?Q?3XB7ngPg0Ktt29Y71e0Bzk0ZEzRny1QkgKSP0ULI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9218f850-4bdf-4276-3873-08db0d60d8a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 01:23:00.5276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R6gSNCZaEE83bvxLFWoDAuUenRhK/7TKWXWMtaiuW+TJzgiMv6E310kV3XwkLR/SqczI1l2XQxVnXsaHvJ0G5QD2dq+16fQKPMwP5jYcDfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3964
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Feb 2023 20:30:09 +0200, Leon Romanovsky wrote:
> On Fri, Feb 10, 2023 at 10:53:19AM +0100, Simon Horman wrote:
> > From: Yu Xiao <yu.xiao@corigine.com>
> >
> > Add support for the following modes to the nfp driver:
> >
> > 	NFP_MEDIA_10GBASE_LR
> > 	NFP_MEDIA_25GBASE_LR
> > 	NFP_MEDIA_25GBASE_ER
> >
> > These modes are supported by the hardware and,
> > support for them was recently added to firmware.
>=20
> Is it backward compatible? Will it work if I run old FW?

Yes. The new ones are appended, not inserted.

>=20
> Thanks
