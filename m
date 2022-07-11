Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2056D270
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiGKBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKBNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:13:40 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3502962CC;
        Sun, 10 Jul 2022 18:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POWW3GUBW2itPJAF/HqedY5QXNtcH7EebFcjXpW4Cl0J8oGDbbXQV41o0i2dwhXBlYziBSuaq+0Ri8fIYc43OlOSGcmBLRh95jOqQDW508K30WZznrXL+rfShc0NHCbAb9urNdIj2v5OL3L4/3gdIwwFzUQdbAiogvjEioRiTypGxvbpvL9TEC2ZSoIv7KrQLJ6jjiN3paMoh8r8xBIm7LLpo5dPYOR2RSFFpWtyFyM2ThrSOsgNlsX78a65KbPO5jShIXzwmJOR5XtBCodJUG3WJRBjhHu+A7giUkStS/jCpWnDkbkY/A6FFJe46qwyuBf86ov7PwCQTzXZkasw/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igKLHwPv4GqIbQL70KJfYuXnwqz8dLsdGmQApFuic7k=;
 b=WzYOSdY6gHl+hU6ISehCijzNqSXUO6U9t0SUGEhxPszMrkXXZc7JHnLxOWaR/CxyGj/ZC7bga+NcPaaIBeeG/+ZwwGG6iktwwfEX4wP3aS51YTVHaUmRY58GvG7QN2P0aBqM/BGPLQ0yHplTmmsHO9LpTjR8YJ4VQ7cyyShqH8aQHGlhVobaxmo0fwXqrVwhrA38qCmPFqluS2HnBPuz5vn3fO9uPc0qf9kRg6Q5pdlBslEMdrDRtNnYQV1sAcu2IXNJpOB6bRqeYt1Hb8Zz7y5ad7P1e+kNyKqDd+h0zfDLMbYo59G+bJjuz5tQdRSuV/oxnKT8Y6RkaLCuy10UGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igKLHwPv4GqIbQL70KJfYuXnwqz8dLsdGmQApFuic7k=;
 b=gCaFtvvMapU5ZQd6gXeBskcqshO7Wulcal3YDrNsIZE0pGDxm+L4S871GNKN55JXperqF4KjsO0MLceaG6Ho+4pgmFNpKHswwL3FyUvvMqo7Wm7/GHzR/ZBkrgd5KybDH3hhe7EzMKu1POxSTC86zoUrGiS6RmWo65hLXkPDBRI=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ0PR21MB1886.namprd21.prod.outlook.com
 (2603:10b6:a03:299::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Mon, 11 Jul
 2022 01:13:36 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:13:35 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
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
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXYol9VXusHkkKmbNSNzuXObK12yR6g
Date:   Mon, 11 Jul 2022 01:13:35 +0000
Message-ID: <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=faf0d1ed-5957-4b81-9b99-444f4042ea6f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T22:46:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a57b900c-89d2-4f12-a4bf-08da62da941b
x-ms-traffictypediagnostic: SJ0PR21MB1886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nklSY4bYMnkFjB0B1b+TlQ0TjwWDbMf+kJgLXWEGW4u3W0AcEVu7SdnBGm8GroPCrPHODMX2RBm2Rfl4yepMaLS4/V0jSGEX5Cq3fLJgEWKZagUhl0AHiwJ8jjXaCSOf0ccgQOhp6gvuQY8LBdZuJ8+rkB7vPCOdv7m4cy6J3L1zI3FniPYBT4Zn+yfsBeaeNibWGOuEpWv6zalaaFon3NCuPhUWBO9BwaSUZMlsp8p6vF1LBxglR0znDYlRUUrDrEtW5C6PDm041juwsXmlbTyunApu72NvnAB6GVQ80YIblSeT4zL6wP1ojjgpQ1dGg38i9+Xz2O/9VNOW4hdIlJQPHs++Ok2w59YR7C3kxuL5LhW4BsJt45BZ3Pr6FMyNo8oNNFXXr1kJdCbFpFYZ6AUl7W1IIho1ROgeeYQ7tWJUCj4vpSPmw4xjbkAXrm5nVFrZIoQUsczoViSA/KyUTNtlQsUubeVt0igZkCpRHd54Bg+8jVOHITVLUZFTeHZaB+JVrxQmz9C2D2CgNWAwNzqXPPr7G92Hhpd4/DKZ7IytebASmJ4oKJ6IVU4Uxo5xMKFyl1pPXNbpGKfl5BqSv1r3Gnt+DXigtLajmPGNibvJb/JwDVk8lEOUKxH/4t+hF/fm05bKDLo7XqxGVfm24sR1gdvyVyaPxU1OI4uHpUZEbVl6oXAHEQIcCkOSwn996TFDm5PMZfb2uVFsrmEo1aWFSozKd0QRRngbYgF22tBac+Zs60Wv6fOgDmR8Ol58WfpeJROKjS/jYn+e9r1OZuViBcNSft6v2kBCmh+hWdg8kJgwjWCj5qEuV3Ftx8ffpK3X9VjkaUNcMc346oE30Rnh6AMkPW+UHqPC9WJN7KOnLypUXwHBS7DyIKEVa6Sn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199009)(33656002)(186003)(26005)(7696005)(6506007)(9686003)(8990500004)(82950400001)(38100700002)(38070700005)(122000001)(86362001)(921005)(82960400001)(55016003)(54906003)(110136005)(6636002)(478600001)(8936002)(83380400001)(52536014)(316002)(7416002)(66556008)(66946007)(66476007)(76116006)(66446008)(64756008)(4326008)(8676002)(2906002)(41300700001)(5660300002)(71200400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G8Dhrg6Q7T07hPTCSOl/Zxw2AbsmCyrOOP/6HW1s0THFJFRTQ7MOIrF95XzD?=
 =?us-ascii?Q?iESt5TsFRsciwGbVWVxmUgOVYqyNKdEOZ8/tXvRneNaHl+ryAru0IazOijWp?=
 =?us-ascii?Q?mldH7D2mhnzz/g3yPcD9WyyDcyeL3OK8809h/1h0GUqhb5t2V8kTLlEhSpwk?=
 =?us-ascii?Q?RS8nWWkx9pIWHRdfOuJFXX8evincE5Y9wat1jzU6TR1pjw5jcAbkVveU62NY?=
 =?us-ascii?Q?Se6HFtfWh8xbCK9rBkC023jHHpG6UjpGOAbDDr8jJlMfYi7NwHJguaevxGD9?=
 =?us-ascii?Q?HHz4fHan5yDlFYT7sTLI8g1nG2cruU5OMRc8I0kaDL/6Z6KmwQ9U+6bBO49Y?=
 =?us-ascii?Q?NNFnc569XrxsfK1VLKMN9KfXLyw8HcdJAMax2Bb/OIgnLtRodrC5xYU+l71h?=
 =?us-ascii?Q?yF9eioFlBXH2yMZaTjGgd4gL0+MfXz3LukL4N4ob7Ubyso2IeV7C0apqnHoo?=
 =?us-ascii?Q?8tuZAg00dqqIfrw6W4TcUUQku2KCVAbL9iEc1ETjSBSiO0SVvMTUenRpItGt?=
 =?us-ascii?Q?a5z/VKDlmO10oNWNJkDIU7s6ofj8fSVvWXDv+23LfbNYkYKRuII3lTHm5uhz?=
 =?us-ascii?Q?PEMTZmCXiHFjfTfAqi8RNecqEr5kgMOSzT94VEhhX+plNtmm5VKbEDfQP647?=
 =?us-ascii?Q?8leM4wF1ritDPG7RTxWtbX1pkENKSi6Or7J06Z8Hlp/wZjJ+42jm3jXXzbu0?=
 =?us-ascii?Q?tW/6yWuO27SrDxHQdhThtV/kxGMVd9d79r4sb8C94f9l1xdoKZwap8jYqKe3?=
 =?us-ascii?Q?28z+yKRWrwdGgNKUSsZX5nsxqwDhp8LQz4aa7ram1aVkAj2nyoez0f0+Ewqm?=
 =?us-ascii?Q?FyTnwTY63Wdx//jME+FghjepLVdt6aoggEr5zUBQP+nqD/3ab7NOw6Ep5ZUd?=
 =?us-ascii?Q?TeF6yd8ThjvmnirPaYkg6KZbhQYRQmmYPC0txkX/qw5veYWTX6Hz0NULFJnY?=
 =?us-ascii?Q?P5iPRMghWyX69sGYqWUdhYcDxcq8wBur4FSdhyR02Ygm8MDOnTcoq7nNJ/Kv?=
 =?us-ascii?Q?o2Tp7yITUecuCvjcvSBcmoUWsqNTEdLjbpG3jvKSyIi6U9CWWyjJzTeib56X?=
 =?us-ascii?Q?H11N3ccnj5WvPr9sDF3OMHC5FzLZXyRCIvoHgd7etOrPJfYRznGfx6PwHR3K?=
 =?us-ascii?Q?lNzmuzn7aDvhgX7D3+hzj/kZ2WSBxuDe30TXbT3cIyfNPG+mJKVbwROIzRMi?=
 =?us-ascii?Q?JzPMxB1irxaXbdNYpUmWBPvmIBL9i0d8xyiiBV0uFIi89vN42yk/pPAxdgV+?=
 =?us-ascii?Q?/8Q0D2vRut2th6lWRZ9sSB/rPPFSoS3YHGxksAHcf4JIfthTndWtroed4d3Q?=
 =?us-ascii?Q?P1fACQlLmoo1bkQOblLVwuWdVC97whjNhpKIlF0IWgtB/WtgxfOPii1VGtwV?=
 =?us-ascii?Q?SrbFiczMWixQ99B8BXrzumqiLwsHzr+0vqpvLN2FLyl1IK4gSp+IPo/UVCfA?=
 =?us-ascii?Q?VqqDGaiBQJ0ZOpZ0kbjxtVYzJF0XRPUMBbqKfVl2fGsoqiS12+G3aGGCv56+?=
 =?us-ascii?Q?MOfm0kVmsiaJycY9dX28tNJ0Dj0Lv1vLPZrnEpmI8tFdMydQ4Qf0KP4xy0WA?=
 =?us-ascii?Q?n0qF4kcgYemPxunI/iZBrv8wkWK5+HkFtMjc0UqB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57b900c-89d2-4f12-a4bf-08da62da941b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:13:35.2953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ex/T1aLBFdbc7hxqIVwCck01z4mdr0SZWE6LKW/Nu1H1e9GHgRr17d3GsFlJeg9iYfrdY0MgOvjcIvDEAhVRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1886
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> +void mana_uncfg_vport(struct mana_port_context *apc)
> +{
> +	mutex_lock(&apc->vport_mutex);
> +	apc->vport_use_count--;
> +	WARN_ON(apc->vport_use_count < 0);
> +	mutex_unlock(&apc->vport_mutex);
> +}
> +EXPORT_SYMBOL_GPL(mana_uncfg_vport);
> +
> +int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
> +		   u32 doorbell_pg_id)
>  {
>  	struct mana_config_vport_resp resp =3D {};
>  	struct mana_config_vport_req req =3D {};
>  	int err;
>=20
> +	/* Ethernet driver and IB driver can't take the port at the same time *=
/
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->vport_use_count > 0) {
> +		mutex_unlock(&apc->vport_mutex);
> +		return -ENODEV;
Maybe -EBUSY is better?

> @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct mana_port_context
> *apc, u32 protection_dom_id,
>=20
>  	apc->tx_shortform_allowed =3D resp.short_form_allowed;
>  	apc->tx_vp_offset =3D resp.tx_vport_offset;
> +
> +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
Should this be netdev_dbg()?
The log buffer can be flooded if there are many vPorts per VF PCI device an=
d
there are a lot of VFs.

>  out:
> +	if (err) {
> +		mutex_lock(&apc->vport_mutex);
> +		apc->vport_use_count--;
> +		mutex_unlock(&apc->vport_mutex);
> +	}

Change this to the blelow?
    if (err)
        mana_uncfg_vport(apc);

> @@ -626,6 +654,9 @@ static int mana_cfg_vport_steering(struct
> mana_port_context *apc,
>  			   resp.hdr.status);
>  		err =3D -EPROTO;
>  	}
> +
> +	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
> +		    apc->port_handle, num_entries);

netdev_dbg()?

In general, the patch looks good to me.
Reviewed-by: Dexuan Cui <decui@microsoft.com>
