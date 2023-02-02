Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7226874FF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjBBFUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBBFUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:20:36 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020023.outbound.protection.outlook.com [52.101.56.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C34B77B;
        Wed,  1 Feb 2023 21:20:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANXTE5YrKPXc2phyVcEstXSx5FJpv0iWCTDSL797Ocxi1NBiCfzmyp/t7fbtatC1h98EPXB2G1cGnJpiNoYmuYse6m+CTY1JveiNQkXbZH/vvHjCVy/fdxbgvkNNP3NrU4PGNxuDJtfvFV+6ZpMEZk3DEJThpYk9KLXcGDAM0MM1rHudhXcwJKPY+rAhvJT90SovDX3DLJRjxsEI3ZGC3AMgQ0ug/ULVwSpOoqvQeaWf43bSNBzr2vGhPBFS7V3lcGvIyzBwRHDwWMPYMybhDT/dl2LLuvXUUtilX6dbaSO2GFU+r45/pEyVYkpxaZgmWu7+Vuzv6BOemfy7Z8qyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEnJAIOypDVkiWovh79lC8OrK74QtCEAuoT2Ij/wQGw=;
 b=GsAbW/RpapYXCXeLCTgPZzZx0lYg98nrSZSBRbH5aJpQ+VFcihZrClnPEHrPwiaTJra+NV+2+ZXq/wIKHHDb4VirTwRCl6Y2J0VMBhd4quVYVg6tHLqDztTMJdHVG53i9O1KuzJ51uPcKfOuMDSoW/94CtpTEmA0hvAuRSwDOxQdw24WsYKdI1W5UP2F1NMqi3tqkTYjBl6nd40fuXU7qY6UtNN4OLEcPG2qKRVzYs79WILIZKXyV06qL9UpxE88X2jxJdeSpVSytqAZlSxAetac+6Bmjy+BwluPql8RiMkZ0VDwnjWhbXqXbT/7zQaCZ2R7Q+2iBdWtYr/cVgjRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEnJAIOypDVkiWovh79lC8OrK74QtCEAuoT2Ij/wQGw=;
 b=MQbHHCCrCKDJU2JRzmKW5BLGSWlxnEwIx9nh6iCHL5TT6jzbcNw80yPvZ4NQVHpn5xgOKwV23ebW0STnA0OvdPdDEYvHyPdyLxcmiUqdNHIAj2+R7JcdnmkbNrxaHujP8tm6LAv+i3cb8uUX4Ue5itlUIUF9+t7avDhSvTrFi2o=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CY5PR21MB3564.namprd21.prod.outlook.com (2603:10b6:930:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.6; Thu, 2 Feb
 2023 05:20:27 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::9a9e:c614:a89f:396e%7]) with mapi id 15.20.6086.007; Thu, 2 Feb 2023
 05:20:26 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Topic: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in
 netvsc_dma_map/unmap()
Thread-Index: AQHZNSTmJ1bDNw5Jnkqja7kiNGrDuK67HG2AgAAB1fA=
Date:   Thu, 2 Feb 2023 05:20:26 +0000
Message-ID: <BYAPR21MB1688B7F47F9ADF2E40E9DEE4D7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
 <20230201210107.450ff5d3@kernel.org>
In-Reply-To: <20230201210107.450ff5d3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=07e70cf2-685d-497b-bebf-313b24316200;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-02T05:07:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CY5PR21MB3564:EE_
x-ms-office365-filtering-correlation-id: cce2fc24-19a0-40bd-ad13-08db04dd3171
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vKAvQ0oQAef2rZk69mBi4MxhXd06++qb2Jnx6SUnXHBIuQdeCmj097NWgeCD3euA82l5eYjbWC9My0R+QFP66UdRvo/6RithG0b9lNIJ8Smp2FlkyJFbqgvX4pO2Vju6O7ZKaB6+l31znMF4/6VaUBm/sF1Gxzn5SlZ1GE+R9TbsKaUlsDo1tIEMyRHXJ60TNFleRWQTy1MCXbLsYwftCMgR2yu0Zhxm0me0xVYZgjmFZlGqVxVSlXF1S6DYdwKHaFUWC80/u6zyqCZvCE+WkosZFFmuJukgqv/EDX3a1BwMuSDij0Hpz9jrvOriNUeSdKDIGBH99wBH8WzxNzXSmHlperWHsBjQuGc3FrDlRMEN0jnNAunUtO4u6aLfj5UUKr7IDKrv3LvMSRALIFXlhS94f/cJdj5S15QIwkzSgxw7FA718ha2p4CdMdMFauVUQfnjZbQVQPseQNQRKnACDxIfIh/TfIzFjS4T7qQhhyloaZK1PJK0wNkWzokUxa7Z0uF5WBViKSQaYh1APE3qWFD3qkToyoQ+USr8ba+01JmuFKYOxGex5oiUs4Ch2CQusgkvBNxG68GNIH9X58QNdeYYkUkXhmvZR5TKv4xNKgNXjlSj/qM2skH1tn9iLCnM2ecuylsHQyeM83pC1GUsZDbzb9BLtGst/Gs1RBQMAM66ZTAsufcD6u4bwO2yH/f/N4W4LgT9vfPPtMpm6WsnTl78WASlwtgp+xSYUBOyUKyHjRbSPHpacE//N7cRLRRL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199018)(5660300002)(7696005)(71200400001)(86362001)(2906002)(33656002)(9686003)(26005)(186003)(55016003)(478600001)(8990500004)(6506007)(10290500003)(83380400001)(41300700001)(122000001)(82960400001)(82950400001)(6916009)(8676002)(8936002)(54906003)(38070700005)(38100700002)(4326008)(76116006)(316002)(66946007)(52536014)(66556008)(66476007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1EEpbO9ZIhz6zL6IP760zINxdkfTNRqDwd5MV83H+69RMwFqvwL7LeWTACw6?=
 =?us-ascii?Q?MKY1ELcVPW5frzwwo7WcASanVjh4Gnh3focLU0gHj65PF0sLY1Ynqt4TMgFQ?=
 =?us-ascii?Q?g4DxnQZDkfnhgQFXxGU9SczzuBPH2wxgm4C2/KkIx/FxXnvwJ+ZDs5jGDzBp?=
 =?us-ascii?Q?MvYv/8i1w39m+U1wUA5sySuyVd6CIItwui52+02dnkqfV+yIxgztEf0QM9Tv?=
 =?us-ascii?Q?ainaS/o1PeoJZoNWi/EgWkz87mwbiCZuoA1Uv2FjAt3Rua1osLMuGc7VSNHo?=
 =?us-ascii?Q?1DsdrRHyQcy6Pr7FlMtvLGE89AbP53mfKmqOW68QryMfCTnSg5Jh5IGgZRXi?=
 =?us-ascii?Q?GrVRJE8JV5ZiMskw/IzOFq14TOWm4Xh2jipNo1LADO3X8mCyoLqXla74qQJV?=
 =?us-ascii?Q?T6B5gV3RJhjY7w7obY/yXl2jR4Uj3Mj/CL2d9h3MVy2miKdwsfT1dH+o78NY?=
 =?us-ascii?Q?1NbJv+EsypGIMq3Xy01Sc2ykgqjL056sUwwxADFGQMi3simLftlEcIymxYXv?=
 =?us-ascii?Q?Tqnj/oM/uXpQoPG5nyL+B5bg+3wCklUe754gMIt90/7fnqBf4Hp0TaxAs3Lo?=
 =?us-ascii?Q?0tbvridg3zHmHyqt1qyXb14xgJ2CoceFIKAUpBH07FMz+qe0fzP6aHhpApYy?=
 =?us-ascii?Q?5ySLenFdO733MWQYIsRCZEs1zQPGSFx3rYt6BrRhixLHtCcdK0pKSery0DC5?=
 =?us-ascii?Q?BJHAal3VYTSD/H9gd7sVUvPtyC0ry43pTYYKvTCykIcRup8pxlfpXn2LXNB7?=
 =?us-ascii?Q?JB0xfzmwSI1rxVk/kyaI/3un2y05nX9FCvdHb3j9ykpI+Y05PkF8nQwwr5Ot?=
 =?us-ascii?Q?IH4NahAtEjb8mLGl24lI0QyNwLhONr7ntgAxIi7tWHJBEMyAN9xhfMAUq6ot?=
 =?us-ascii?Q?GMtKNQCERu45J2litUWVcNVwpoa5QRMr4ljVfHZpl103hKfuCuXNnXpfIjdD?=
 =?us-ascii?Q?J3AP78fVqmDytY6jxpLjEMeYSdMVolSpyt7kjncBAs8q/kriWw139pJ/oegD?=
 =?us-ascii?Q?C4VRZmv7kmgVidl2NMdeeeoJYaelpaJNSZO0OARXVi15jAatbbvozxHrlMH7?=
 =?us-ascii?Q?/fhqqagV7wyKkD3llTNqPylvvUZfObfxzrCn6d8PLx3OIUcaeEMuJ5xL2lLF?=
 =?us-ascii?Q?I+ttcT2inxjb+Ie7gRtwWvGX1y+WIcePy4W4CofGXy2xovWqRzHHrqu/cnd9?=
 =?us-ascii?Q?ZOlOhU+3fowDbAdGUZrpa+EDwjXATu/0KHHliP0mYZVemalD+M/UxfJQQCEB?=
 =?us-ascii?Q?VD3XfPNm7pKOcOqahTNMvNCVnDApTRuvSBbI30AhqimkdiMhVc7TY7tvw+/c?=
 =?us-ascii?Q?AGmQgHj/xdMo5+RJfY1v3pg/MJ4+xVLLgreD0m5fi/+Q9KZz9FBmp4Kvdfvu?=
 =?us-ascii?Q?H4ZatO7p50jRGYmZRyfWzGg35vneq+r/py543qjOFbw1a/sqFpbkgZtBJVQz?=
 =?us-ascii?Q?y+TtwZo4sXS6kd2IzUWt3AHcs1jGihdHG52eb2j59/WWJCRAIauvGBm7e8SE?=
 =?us-ascii?Q?XidnE2TC9YCvaIAxsTZwear2KHhCNFClASV9qlebTx/oFzmNpLL5QoONwaUY?=
 =?us-ascii?Q?Uem9gPjzJCcfn/nbe+bDZMPOfDBoUEfZz5b5sK3on81zt5U+zXfX/7O5Q8Nt?=
 =?us-ascii?Q?vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce2fc24-19a0-40bd-ad13-08db04dd3171
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 05:20:26.6717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xhbPondiDkXRgecqwKLGG74KL5DcG5Vw9GAnJsuHPcDC/ifv7e4A/fLzFGI+aR/ilO3nLHQtbtNy+RNVh086qIPgy1aoOvArGRzfAC3yOh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org> Sent: Wednesday, February 1, 2023 9:=
01 PM
>=20
> On Mon, 30 Jan 2023 19:33:06 -0800 Michael Kelley wrote:
> > @@ -990,9 +987,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
> >  			  struct hv_netvsc_packet *packet,
> >  			  struct hv_page_buffer *pb)
> >  {
> > -	u32 page_count =3D  packet->cp_partial ?
> > -		packet->page_buf_cnt - packet->rmsg_pgcnt :
> > -		packet->page_buf_cnt;
> > +	u32 page_count =3D packet->page_buf_cnt;
> >  	dma_addr_t dma;
> >  	int i;
>=20
> Suspiciously, the caller still does:
>=20
>                 if (packet->cp_partial)
>                         pb +=3D packet->rmsg_pgcnt;
>=20
>                 ret =3D netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
>=20
> Shouldn't that if () pb +=3D... also go away?

No -- it's correct.

In netvsc_send(), cp_partial is tested and packet->page_buf_cnt is
adjusted.  But the pointer into the pagebuf array is not adjusted in
netvsc_send().  Instead it is adjusted here in netvsc_send_pkt(), which
brings it back in sync with packet->page_buf_cnt.

I don't know if there's a good reason for the adjustment being split
across two different functions.  It doesn't seem like the most
straightforward approach.  From a quick glance at the code it looks
like this adjustment to 'pb' could move to netvsc_send() to be
together with the adjustment to packet->page_buf_cnt,  but maybe
there's a reason for the split that I'm not familiar with.

Haiyang -- any insight?

Michael
