Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E015A5B7F34
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 05:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiINDKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 23:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiINDKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 23:10:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF946CF5B
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 20:10:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDzBD44DDtr0TWk0epicWfeL44nbjm9xMvkluBpReMHigTSIjproS4RFTZescHuQ4/3EVso0MGX9oUs022s/U192ErtIuL2IqMV4apqaK9UC86hEmNlAkETMz5Mnprm0TeGUOm+h9cPfNkGIBsZUSEQ19U1XrL+ut0ofCxG6IhgQ8SH1KrFDeA4lMvK4KNnRfVle0cQibQ5UsxyHZxDYjr0Guazwm/8BqnXIuWb8nB69SFKNeUnVHonQm/2bkEy5ojNYea64FtHPdgkcvjKTNDx653net/f2c4PnKWXYT1sdgd8uuID+iW/zWOD6IbxYdTyRgCccDzINJQq+E8GU4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weMSr5wh6OL4xg7e2QdqfVYO9vn9dWBB0SvoTsYNaJI=;
 b=PhhNVWnswahnTw1rduQ5iavE6sXHd3uGJgBXtOp69+pansXwAuo8CLQlRUNzIalLWB4xxRLHLEpJv7kbfwhLrjFz9KSrt7L8bMmiq2gUv0Tb4tBQuq7rB1frwjsLjPG49sWe/IHQxjjynrV3Er7vJiSpmBBWxmyJLwTJwjSrtWFn37MmTgePDFbGayaRWx00i5SEE+jrQm8l2LyLSJITZC9uOBD2kyjqt+2LLIPxLIGE6Fy0g9Y7HvlaONvPSN3zPxEWGoZvS3rLaFeNKuWSG0leJkX6RvdnjCqJ2RRBN3r5chumNzL7TjaICvntCfexFh7DDALtNjyfSB1dceY01g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weMSr5wh6OL4xg7e2QdqfVYO9vn9dWBB0SvoTsYNaJI=;
 b=cNg9bVpSjgpjAJIhQO4gjCSQyzzbjN168zi5olROnk9pku2Lg0tytW2YhzjYZDgMr1vNBPGtVja37CwoFK6ojN2HLrWIeplLGcqtcp/aZWxNATP4N1Lu/AwAcy7vf819AAu6jfCIc36EZHLBinh7dQYT4ONq+xkCgTlur/6fLTQ=
Received: from CH2PR13MB3702.namprd13.prod.outlook.com (2603:10b6:610:a1::20)
 by PH0PR13MB4876.namprd13.prod.outlook.com (2603:10b6:510:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Wed, 14 Sep
 2022 03:10:41 +0000
Received: from CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::cc43:129d:fbc1:54f7]) by CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::cc43:129d:fbc1:54f7%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 03:10:41 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Topic: [PATCH net-next 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Thread-Index: AQHYwp77dm/i1USQaEGyCSFpnuT7Dq3UQ94AgAn70rA=
Date:   Wed, 14 Sep 2022 03:10:41 +0000
Message-ID: <CH2PR13MB370270E849C46D94BD9291FBFC469@CH2PR13MB3702.namprd13.prod.outlook.com>
References: <20220907094758.35571-1-simon.horman@corigine.com>
 <20220907094758.35571-4-simon.horman@corigine.com> <Yxjdpt42BAiZe0sK@unreal>
In-Reply-To: <Yxjdpt42BAiZe0sK@unreal>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR13MB3702:EE_|PH0PR13MB4876:EE_
x-ms-office365-filtering-correlation-id: cc3d8ebd-084a-4b75-d164-08da95feb4d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYoeESuzN7iPL3WvUKGD6JZ3MsSzA115/pxQ175cqhNhCPIAEPG2Hbe5vA60wesZpvE+2hgo+fXnKO8kSFXZH3dkDeq6IXCl3EaiI/f8GJhjmz2VpEBDfYRjCcMGQlHYOTLGFzZPuuw1sbRV2mF4lgbu7ANCSYicTP9SOTo+sT4XriXYVorcGKstZf83lf6altYo83ylsg8pS0IhwbCV48dvyxK9/8bwJ3+RyiB4fps0LY8++iOyA34n1q3uCWg6iXatqCesTJHB9+/UT3hLj0Zm0IfEEnE13pAdzBFNTP6xYbSWQO+hVznPfDOY1J5Sz1kvbBodkLtvRaUpCMT/G+kKBd5xsNoPXcdpIH2wuPoXzBRzthKCKtGYkNr6UtEAT6gE9gvgy3e26XfjDqYu7hKzPhKUL7I8gNecFs0gwVQGIfNW8qFSc2+BBtnnI9Km+w6SaumF7gazLa0TC1c3txxnAz4J/ipkIVrw7LPCL/mSshQqlsQAdLcGLJ7yPex0aeKHFT8SZFTbmF/yS7/sy7n/93GPVaaAGDF7t3qEFpiuVCtTBSICRopvcJhpijxdd4F0dYq5bDDzkV76niY5aX05bZsqO/vjnpPU54ZW/OMToH9xhMn8ZVbBhJ5YmF+S+z1D3MwquaNN/NbDtUpc1/pySZ6fi8rpUSOc1U1b6C0wSeUfSA+R6PFLbVpMTn7/suLvQo5LGEkXBHjtnK18bsw2a3+WFnt4F4nWfSPegNMnLXR8gVoHP8eVF66xjiIlsGrDgMggUke9G2CRRzPp34WYXGhccjxb8JXcGc30qIg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3702.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(451199015)(26005)(2906002)(316002)(38070700005)(478600001)(6636002)(122000001)(6506007)(9686003)(76116006)(64756008)(110136005)(8676002)(86362001)(83380400001)(66476007)(55016003)(52536014)(66556008)(8936002)(54906003)(5660300002)(71200400001)(4326008)(44832011)(66446008)(41300700001)(7696005)(186003)(107886003)(33656002)(38100700002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y1tORVsIVN+i/E3/Y+PXcPJxWRBjW4dWNWJNHO7J98H+HKF6H42Y0Ke3zR3m?=
 =?us-ascii?Q?WPbe7osIMjDL9TrW1zSUFfhCASiOrhbbZohi3p+KFQwiST/gpPaZDcMdze3a?=
 =?us-ascii?Q?di+gjmPEnkiAyy4EwHDQoyjRBKplbLJ866OHvmrJf+qdR4a0fwh9V+YbMxm4?=
 =?us-ascii?Q?M0mT0GFtEL/Rnn8PU3BpsUr9ZK4ASHg9/UwyTkKZgELTOfheLSv0vwj4p6by?=
 =?us-ascii?Q?LU29xBzB1jzkBntMF670yQtcmsG3HiZ2bD5dbLXeCa4Nike+4z13QRhERBt6?=
 =?us-ascii?Q?jB3myPbBVxKR4GdeHIoJsUJ09IAWTK/ACj2Y13ezHZEXnKlTRxPqYwrRvI4c?=
 =?us-ascii?Q?YhQRdvoW6vA1g8eN2g/zIq7MIymSY/YsGJK3+Hf150bU2I1eVPPYJLzieKGy?=
 =?us-ascii?Q?BG2YdudJ8Z5K6SWDrITVXGwE5h/6OLsirkvgp7RWW0o+84yBJL+5asoplnsJ?=
 =?us-ascii?Q?z8Vgm8E9gYLxqe/4998xH701UJ+WYfIqJ/fA3K+fp3qJmVCfdVB7OKkzSUH8?=
 =?us-ascii?Q?d/wd88l9NVDN4YHSzG5qCiHoApC0pWxWZt5MHGTOSnUOr523FbyM0fckoh5k?=
 =?us-ascii?Q?jvPn6l0Jg6RbzFH//icHpR7WjSN8TOs/8/ciF6HWD2bMP4HQIwIkKUmEppWi?=
 =?us-ascii?Q?lHOgd4Oo8CHYZLNMvQcMY9h8Mj7rqNWwuGbHPAo3iTNSbcNePtVkML3yOTz4?=
 =?us-ascii?Q?jCihbsKZTyzLDCiNXo3cGq12Qv7sZ184wtlTmCyefyZ9j0jF0hW2TOgQ8isp?=
 =?us-ascii?Q?DGHv+tEbp28RZSabL6kaGRCjVcH1rK5RXyyEMeM2eSIxaEMLoMXlGsHeoEvj?=
 =?us-ascii?Q?nffPAQLaS9aB8x96WqEHlzfxeATYIxsptuLuNu4KzJmECu1FEAhDCCZ1f/2+?=
 =?us-ascii?Q?RSctvvkDZFOky2fga93y58Xk4gEEOdZI1yvJnqq+THxHNZ3fPyaNTFb9+HQC?=
 =?us-ascii?Q?iCr3xAz5RwkhllQn3Z6SEsCkayYWsoBALnL6qOcesTonB+bOKPxavZP2jPwC?=
 =?us-ascii?Q?orcvzjpBgnKKBDB24QFvZtmpr8/1XX33B774vO58cv2xUt/CdwYMinyXqOpg?=
 =?us-ascii?Q?d06ph3fGdl0qfWs5Wq3qcyTfGHRJ/wDzDfRXJNfKK9CXAwDV/GC4LFFDhdNq?=
 =?us-ascii?Q?Fo0g4charFxtP3qUuzcBo3qTBdSnbzcIULV0cUCy8oGwLwKe/lU3+8Pq5Fah?=
 =?us-ascii?Q?dz7BhiBVYiCeLfcNcVPmVGzFiTLWh+ElSTbse3S+fm7QfjGOL75juyA9Yejd?=
 =?us-ascii?Q?09XfdW8WxE//Mwpdwhb0EBIvosIzvZTKZFcXL4XDJKv2lah4c+05j7JOoYiR?=
 =?us-ascii?Q?U25LUvYW8j9upxl2+ua8WttjMA1nUg4f/F2syvS8pO8pJEcrbxY045mq0cJE?=
 =?us-ascii?Q?Wu/vuI9DXHl91LxTxyeVGQms2cd/dtsvSg1LmqrtpW6abPu2feuwdftgCueZ?=
 =?us-ascii?Q?FAg/ROr6XIi0bmfdPF0/RenDLSgwX9zlGDboQb1DfB+f5HXr/5AhmdUAwlWB?=
 =?us-ascii?Q?933lFGp7q2eKkCrvk4GMoTkN5R/uo0XkdXbQwfDjz5vPNQDhjxVOIINs5Ilz?=
 =?us-ascii?Q?XZJwqC5uCy6in+3jeScyIfif+fCiQZvJZg/qdYNH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4876
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Sep 2022 21:06:30 +0300, Leon Romanovsky wrote:
> On Wed, Sep 07, 2022 at 11:47:58AM +0200, Simon Horman wrote:
> > From: Huanhuan Wang <huanhuan.wang@corigine.com>
> >
> > Xfrm callbacks are implemented to offload SA info into firmware
> > by mailbox. It supports 16K SA info in total.
> >
> > Expose ipsec offload feature to upper layer, this feature will
> > signal the availability of the offload.
> >
> > Based on initial work of Norm Bagley <norman.bagley@netronome.com>.
> >
> > Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> > Reviewed-by: Louis Peens <louis.peens@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 552
> +++++++++++++++++-
> >  .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
> >  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
> >  3 files changed, 558 insertions(+), 4 deletions(-)
>=20
> <...>
>=20
> > +	if (x->props.flags & XFRM_STATE_ESN)
> > +		cfg->ctrl_word.ext_seq =3D 1;
> > +	else
> > +		cfg->ctrl_word.ext_seq =3D 0;
>=20
> Don't you need to implement xdo_dev_state_advance_esn() too?
>=20

Actually ESN is not well-supported yet. To clarify, we'll prepare a v2 to e=
xplicitly
return failure here. Thanks.

> Thanks
