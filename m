Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914A852AEBE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 01:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiEQXjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 19:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiEQXjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 19:39:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2132.outbound.protection.outlook.com [40.107.237.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B9053B71;
        Tue, 17 May 2022 16:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ju1oLvKfEZm1Hhxf8CuxOSipZ7ZKLCccRTihd8/XbcdckDDxkGeqqGcd0sOU8oyi6jJoOgVqdExGfwlr31uT//YdoySTEMx0RwyzArfN/1O5HdOTa8pwutl/AuCNtwhiYRtn9UfMemTvcqL0zXuYm4rDnyxM//GxLY7a9WbvVaLXQuyj8E+UD8JuYrC7HvaAs2E1sP5rMYG8h0bEwKYNxuxeZapEC3ofkOIEm7esTLOmETHPugiR+Ocp5jhO/yLGdWejuWesJth5mt9O6aY8CtCBG2n8tgJYYzN0GoCD8UcNrgAPCFgth9ymHP7/FOaT8FqoD44cyBQFymzzY0QC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnVAByXcriCoL3d8gdK05T51A14AjXh5UvWQvC1Qnzs=;
 b=GHAaU+lHPHJKKJkb5HGy/hu9IaOg88CF42ILtQhkpLF6l+1iW7uUzZTFygcWt2878go3cJQIiIZl/Z0O+v/5XUrNlrlUT5VxtOd2JAan8Rpll+vbiTZIb9sB4+n5wptACikMQ4nsCyJ+ejShgimxnOnHbQBphows32OjVgDdq3uvT5yYwOEFMbXjVCYp2zxQsk9dMBeLMXsOaMWeo1J7k8bEkbBcZKofDfn/BCB8WgPKiUnaH6rG4ldqdrx7NkAhWQ3mEWx4dSmjhxkeifbuQGbMNlDTu9khQG6FmHbpRaz+mzBN3cKTYTPndSLLF7IV1BFEcIMwkoZZ8fJtDA1NzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnVAByXcriCoL3d8gdK05T51A14AjXh5UvWQvC1Qnzs=;
 b=ge1bWAdULzjKAOiG0avOX9xbGy1jWSNMljNYhrf3OL7EKi9wQByGxLn+ZvxcTztyApNRjDyt0Be6VvllqWQ9f0FwnWHWbj8l86/EKBQb/Xa2iy+TTesa7C8mdCERUJYNfJNIvj+4BaMJc1t74a/uigQLGeNwQ6CSQhqZcrYRx0I=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DM4PR21MB3537.namprd21.prod.outlook.com (2603:10b6:8:a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.3; Tue, 17 May
 2022 23:39:33 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.005; Tue, 17 May 2022
 23:39:33 +0000
From:   Long Li <longli@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [PATCH 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYac0t///OtEoRzUu23SSvLCLiM60jL1kAgACKxzA=
Date:   Tue, 17 May 2022 23:39:33 +0000
Message-ID: <PH7PR21MB32639AE0E4B6ABEED6419FBACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
        <1652778276-2986-4-git-send-email-longli@linuxonhyperv.com>
 <20220517081918.655fe626@hermes.local>
In-Reply-To: <20220517081918.655fe626@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b92ba5b4-0375-4791-9ec6-440367fc1c31;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-17T23:35:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bae0442-4e4c-493c-11fa-08da385e7edc
x-ms-traffictypediagnostic: DM4PR21MB3537:EE_
x-microsoft-antispam-prvs: <DM4PR21MB3537A1B7CA31A85EBBA83E37CECE9@DM4PR21MB3537.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XSOXGa4QrVv7TSy5X6ZfSPtfJg40plKq0BlpISOrEjtQUxWra+pGQ5+thCOArRcJH492r+XRbMLiGN0zFjG6eE08NT0CYIJOvJYQgZEomsnUQ80qe6J2EjnMu/rkcVnDNGSzSeaP45E0Unl6Sq4g9ZaqNEemLA58ae1hTuh9ODcsG2xotXt7USjU7/ycBThF5oaCYn5k/cW3zdvpVSMOCjbDF82pI5j1CnWWhcWqs2FHD1E0OjCF2DrRcvngfb90FVMmLuR7MW0EiYhj1VQJWNoaDis1mXhu7dgay2qgqdVbxEegamKmAA1LTou81xNwNySwfc+9h8BO9qF5TxTcizc9wqYGb01XuDceMzsmxSFW0h870CPqlyK0oMBdO6EWWI+ljhU/Z89zB4Yo+kdxLIr8soKOlu/sD89ytvJuXcp3c9kZxiVZL2Fwo8VI461DKi1n+OUEG+5a2r8s3MxNyCybO1u+Aza+3M3jBn3f+Ltc+c+B8cICuUT/78FEPdIbDseEKKSP8ahDQzKNiYUpGMQd3ESZ00VyxDR30EVKuQATk+U4ml4mMemR2SGDM5QhODRwTXRtfxcuQQ+pZ08rE2WgmaRL3h7fbQMLJOYl1HbVEpQCPVEiCe6gIhM1PoCJnTN0YytFD7xvyTBtu8hz6tsRtUPPE7oOTYUnwK36BcRkGaC8LTKBJohzlWZzdK8RuX9Ke7UZXwQ6uQ42WmdJkxWkHxdTG4mcwCgiXaTjQvspIWmiQS4G732SOhO21f+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(76116006)(4326008)(8676002)(64756008)(66946007)(66446008)(66476007)(66556008)(9686003)(110136005)(86362001)(4744005)(10290500003)(508600001)(7696005)(186003)(33656002)(6506007)(71200400001)(8990500004)(54906003)(316002)(2906002)(52536014)(82950400001)(8936002)(122000001)(38070700005)(38100700002)(82960400001)(55016003)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZnG32Hk8pUkh894FqDY2Iuc8QhNHsRRito7O+dpfpekty7J82sCM0unp1vHj?=
 =?us-ascii?Q?8WIo8cG4L/eX7zpfNhcHaQqUzQKeWnM9idgtf2FPMv6EEieH/ismRU2sU9Ax?=
 =?us-ascii?Q?IRsf/xRWqN3qu0rHGNDJyrKyQn1nShyqK9X+nR7cG9Uf7dCiSjAgHd1XamTZ?=
 =?us-ascii?Q?dWQU0xx5vhkVH3PSz4Q+bc6RTKESPXg7P+/n6KBYpE3GNTci+/UIhRCHJTaF?=
 =?us-ascii?Q?H8RG/0zgs0DOMDx2K8dyjyj3X26nwDQ6F9dYDdC/VLSR4kJ9Y2glYJSCVb9I?=
 =?us-ascii?Q?qrzvISqnelEMecIO9Sg0ZSosOtoOs/DUS0VmsioqTf3u33Obsspu55G8+L1T?=
 =?us-ascii?Q?1PtBwAlWNM+dM7zNJTmlZXN6wH0BMo32LIffHwURI4jeig4roRr8TO6gpIke?=
 =?us-ascii?Q?2GhAX2aCtoQ+zE53z9j6DkBsGVRlukrRPDagAoTp4v08JT4BFzrXncByVr36?=
 =?us-ascii?Q?hJW5A2RPQcm5/+sx93ZvrAH5BlMyMwlWZcW3bI4ivU1Nha6PQkT4pPTg9gyr?=
 =?us-ascii?Q?hj4BPLEW7JyZTmoyya1O7dKlrf7YFrGssTn/Kbo2PB7Uq3NQ2YNU1qdMIdpM?=
 =?us-ascii?Q?CD6RQ2fPAKsknAVrusleO5eGxqUl6b6LIHI8py8hEANbZ12vTZoZJl60kQGi?=
 =?us-ascii?Q?tJysraF1nzKYV6dNTuJJV5VgJYpEGuMLx29RsxymP6y72WfGfoQW+lnD+2VV?=
 =?us-ascii?Q?eAWP5VjqL7MczliuQoy6X4MO4Q8isUOeyY5GAux88mgCN5lQ1HLtW00d3W3p?=
 =?us-ascii?Q?ZnK6QwR5TF5/GPRsqmOXcCMc5QNbNijRQHVOHvYjYnStRGD15n+SE8OikAol?=
 =?us-ascii?Q?iilC3z1CNG3ahLqZNw252UVXhos1XiJ/9g1jicXUL8Q4XDz5O4ok+u7GVz7Y?=
 =?us-ascii?Q?I55oQ3itqjpZ8GpIE8wPSvCGaQ/UhfySzlVj35ghyOq+M3AkfsVNLrYl9UhO?=
 =?us-ascii?Q?ktAvwSmbWK3fmTJin6emoGqC+bpFKZiWh0EJJ7xomMWZDD9LzevMgLDdWIQu?=
 =?us-ascii?Q?QUVDo2fJxTUpZ9wB17Cw9W9rzz6URYUvS/1Ey78j8mZiburQ5RPhv+r+FWBh?=
 =?us-ascii?Q?n/Xj1lzxTLOIcml+46Fy7XPW4lMXSIDdtG7iUYxz8T85IDpad5bffTNIVL2m?=
 =?us-ascii?Q?nht/ar/CRZ/jcarPRM+maTyyfGmkYNTBDB5P2iZZ88JywiTtP+kmsoICi9/i?=
 =?us-ascii?Q?LwbjTzfhcuxbMRxKVpuWBtOvaucGJAIbflCyesEYMeoq3aNZSglPiBp1RZY4?=
 =?us-ascii?Q?nQNR0l5dmkoXmD1B0hCd6VTkC3+dt+Ws96amvUOPgqAr3Oib+nNBGGretTBH?=
 =?us-ascii?Q?DslLwvvWMpwZRLgQTwazNhuBpN3CSUvp74ZCbGfIs62VyAYSM55mLpj+ZoY/?=
 =?us-ascii?Q?zimlkAyYcMnm0qKk8s3c778SU59LYiYAmb4YMwBuR+ZJ1Zn6DdxfhlWxt6sU?=
 =?us-ascii?Q?b2F4HQJm/Y4nBde+rLJirEXUqaULExQSZpOYz6mOEVCexn6j+2Q8XmjnZqQT?=
 =?us-ascii?Q?XQxAbiKdh/NElSHHyS0mh2Cwv3MMcee+Ir4SEIJbSFMfy+HIXe740Ji6Wj7M?=
 =?us-ascii?Q?lgmQ/djc6R2vrF17B7hmOLXU1/L/6b7DUMifBl37s9LotzitWi9/YuMbPacG?=
 =?us-ascii?Q?w8kAObGTq6q1StN8ZVyU8hBqoYBOQ62WC4KkuzoHEXDJtc+asX6EDr0QCliA?=
 =?us-ascii?Q?7SbkOiTwf55ylohlR11FykHIiusDvoYNSUqen9UvcODRAIXoiaj1xtijgRR5?=
 =?us-ascii?Q?SIJAvxcu+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bae0442-4e4c-493c-11fa-08da385e7edc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 23:39:33.2118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ri5uJbtvJ5jOz7/wd1f0EaEuZF+4cj1+6/U2UaksRVZ20eCDFne4u03ytozLcmA28MlmBpKMiqwfzdjxPH0ZRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3537
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 03/12] net: mana: Handle vport sharing between device=
s
>=20
> On Tue, 17 May 2022 02:04:27 -0700
> longli@linuxonhyperv.com wrote:
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana.h
> b/drivers/net/ethernet/microsoft/mana/mana.h
> > index 51bff91b63ee..26f14fcb6a61 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana.h
> > +++ b/drivers/net/ethernet/microsoft/mana/mana.h
> > @@ -375,6 +375,7 @@ struct mana_port_context {
> >  	unsigned int num_queues;
> >
> >  	mana_handle_t port_handle;
> > +	atomic_t port_use_count;
>=20
> Could this be a refcount_t instead?
> The refcount_t has protections against under/overflow.

Thanks for pointing this out. I will use refcount_t for v2.

Long
