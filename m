Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729B557246D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiGLS76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiGLS7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:59:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C10F420B;
        Tue, 12 Jul 2022 11:48:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eK1TOx/KrKDS7mgznhpbYmzBSGl6OVSZ7OOjsSsjwoJs/IH53XmQLYb2m5KXpuO8SuMkAZlZ/yihokyO3Ftg0K5ErXnujSlMA28wi8YPAaEhumfQyZZIzncjiW2I2IV+N4EdjSxLq6XyHv52X0fQMLOx3uSBwx4as9adfjq+RT4M15ZGERTrG21VyZONjJIBCsAv53/iXqv1AIc0AT337kKk0GIId2bAztFs3/h5iVts3NQ8FHTlb0SRH6vVthPPBPSQmpNxbapMLJ2g7RCAT4R+/jNfKWvXBCCWarwN7Mh1/8sxBINNapeQl8WnwVUEt7NK29AK2DTrD1ou2VcrWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NX1Cb+DeW9sFu/jfI3LOvtrY2pauxW8qWe716MTOL0=;
 b=mDxAM1V1bcTcjoP29qcvEDj+vyKaLfArApdXsDqjI0xXO/wdjJwoRARM97EjFfiWTvsLA43hS1dnsjY/TZSE1H/fp6XXrdZ8QT0wtxMYQwG0JesLdO83Gzh3zQq+H0/bJW/7sYFpRtxZ1YLozH3v9WST7GbXKRJU2Wz830YFwq4ybwB8ne2vPX4zKaLIVT0bEvYzY7Dv8Sn7zFeeSdTpaDIOlWsNlJcNASAb1WcyQP7Ww1xKItwWKvmCDA0d63ZBaMRVZy3sJm6t627xseUDOqdGJvZn8tWFQjt0olRTQHcihJxo3bapdPltGNeOQebM8Uuq8W3cfCUEQm2pYzD5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NX1Cb+DeW9sFu/jfI3LOvtrY2pauxW8qWe716MTOL0=;
 b=EGJO/bXdpqGpqrAm2YdbVCjRbsuundMCatl0SH2nE/pb8WamtIIWdyxz0ZSEEW1C8ewr7M7GIZjspOEVEz419oyde/sn887c4S5QmtWwUZXUTFpfAGYEnclxzmV08YUpBD+flHO6NIPxMVN5H2hM9V9F7tC42zwSLKas4SHBfqg=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH7PR21MB3260.namprd21.prod.outlook.com (2603:10b6:510:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.4; Tue, 12 Jul
 2022 18:48:09 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 18:48:09 +0000
From:   Long Li <longli@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137A=
Date:   Tue, 12 Jul 2022 18:48:09 +0000
Message-ID: <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=faf0d1ed-5957-4b81-9b99-444f4042ea6f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T22:46:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1ca1013-8738-4906-79f2-08da643710d5
x-ms-traffictypediagnostic: PH7PR21MB3260:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MlxXk4rOAkfDvS/RJoag4wTFpn1l66k+IryenvpYrC+Vp9UZJj8vmghjtnveMuTJ6US3qcAwNRsO3P9s+Fvh5dcQk3p2ul4jRMFBa4Eyfl4Owa+NJOz7tyGgbb0LVnJZCAhe4m3GTQCwnzwbc/atXeK7NAZtBMvJVX2f7LC80ypOB+FEYgNnSliom5ml9T8p8DyvDaZvwilYmo9UISyTb5x5nwRuh9Qxf8ZjhAGc8jnTDwMcfiZklB04sTZlu4MMYfEYIf4uGXboD2fV8NIegsBfmou8ySMaGU0WxKM1o6ePUfXPVMYiWFXHTE1i2xTKDD0ZL6kogakNI2ACmpo25bm4Uufzqxy2hmVOtdLCqHHebwiOlVHtc6+t5XNcR7ITUY80n8lRoqvTABM2sRcFSstjuNxPy0VmvW5VVJO7t0quHCpgAxRS+7pE22tM4ZzHMlOlb0tmCKSJvmP9FZynZUxX+PPADnFmNxlfY+VWKZ27J7NfAjeZ6Msaj5pWf4bbzrO0CCnpF1BsSe4pK/A1FFuDe4Uay7TXdRLjzNFfdNSjMnGHs9iz1Ox77j+YE9Ae5Qw5ib6cY5Ah6F6lvXHi7eHUEBhWagfz+fFbSXWCUKBaUTfSoFWyS7Zv7/vim+VwRIzgZ3CpTjbICPJXStYREKAKtchmxpVRcBF/0ZgvgI8ofBY/yT1JophzKSfCV3WuzYe3cb0Pld5dPzr35xsHAMdZTWC2IJMXPt06kzAjONcev0uCjtPBocWUs1T5yY6cA7P/kx79FQP43hLBLTmLH9icidnsBJzUOLgAWTuQy102G1ZbZDrytA6RAks0PIpz+BpqGxMmJ9aYLOUbjm+eHGiKIBeLPvqeoNv4T0RjNn7OSkCUekuzD0zQHfco8mBq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199009)(38100700002)(64756008)(66556008)(186003)(6636002)(33656002)(83380400001)(82950400001)(82960400001)(66446008)(110136005)(54906003)(122000001)(66946007)(10290500003)(71200400001)(4326008)(8676002)(921005)(86362001)(7696005)(26005)(41300700001)(478600001)(55016003)(8990500004)(52536014)(9686003)(6506007)(2906002)(38070700005)(76116006)(7416002)(5660300002)(66476007)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eJV7XMRrvET/7naDGjAl020wMv2/IrUvqUBwhziVZ8f7IjsQAPzY7l2xFTfX?=
 =?us-ascii?Q?iG3FuJImgyGJ/jNwMHJ8GiPyCy4szGWZibnwtcgkELQFt4VAnHAXbG0hYwZn?=
 =?us-ascii?Q?xicVFj40293GAmoRTP5LStwxBLkcz+uR8iyjIY3Jip+2AV2UjvLRThTQ6B9n?=
 =?us-ascii?Q?D7TaiNWsRzWpLk+tyLNjMpFy5Heoz1WW7sM/qxHv9x7cOMyad7InDE1aTqiv?=
 =?us-ascii?Q?OBDGJRpNH1WFOyLN3JWKdSIf4AW8tCyryz81R0/xEkw20f7m/0W/pVlTfdPv?=
 =?us-ascii?Q?Yrd/c4iCw0NmwRf9mVq77YfFXSarbPy2DfIIp2mK/1KKwYFY32CAer7n72k6?=
 =?us-ascii?Q?85bvvcIoguOiftiISdV9VYdWs7L/w/OwetXO6PAhaROROXq2q9YbaHeRyWCY?=
 =?us-ascii?Q?vIXneu1Mc76GNqbrjvUhBhAHnvTP7dUta0Cd20Q4BHUCuefW06I+T41BMN0l?=
 =?us-ascii?Q?ogSLnQIFyKtpI4PcNglCeqW8gE8qGtBuBv6Hs7vYKvQx1rQ+kxTA0wf1MbCz?=
 =?us-ascii?Q?en8hOQ4cxpI/Sn55OjckOB20TwAImhPp6QijsV+f0EO7SuJbY9MC3j/m5X53?=
 =?us-ascii?Q?F/6ZGi42QozWhMYwQqgDmfKxKiX3EFA3uMZEyQyCFqN6zbKtbVK+/1l+BKso?=
 =?us-ascii?Q?ptN/VbrYY1l9+MPhKD+q8YNHE+PshMs8w17iTPDrz370LjkYtBJNRvs2FV73?=
 =?us-ascii?Q?O/y7yXNeTu7jYwk6+C/SguelF7mi44jRIeiqh9HAFZDH1N51aWwle8WM5AnQ?=
 =?us-ascii?Q?dDGn48sP2vMc2C6VLY6jZUAMFbRGeoM3w/HGbIiHYP4VgUPuT5bsLcBJCM6M?=
 =?us-ascii?Q?gc5zg6f7Fk2biunkgCpVIL3GJ4vnPrZj6Bv9HtSlA4LBCHGKMk4un3dHq4sg?=
 =?us-ascii?Q?AgGJ06lnr9mSt/GeR9T6AWwyMzW5D34PAgZJalslYADPUQ3iJ8V7S+uADPGE?=
 =?us-ascii?Q?/6mMnyW7kYV+6We5oIRvPNSJB1E6G9qyewK919errimOpC02+gObl0VQVNny?=
 =?us-ascii?Q?Lsqgp9lZRLf1nbikOR9KkKcCyeQT2nvrJjV2dPuFB0OCzE5QgQGTYK5BCMIf?=
 =?us-ascii?Q?gCJZYzBC9hgLFj9ZtHqyFJ3grgirwYS0kkzMkp4k8ANeIiRhlbrFDHeqRmoQ?=
 =?us-ascii?Q?HpYIPL7f50HjEWqv8/vLf+qIahQC0WG8HcZSV/52twU5C5l7TbtphAVPYQk6?=
 =?us-ascii?Q?MtufdqmVK7SamasY3sZKiLyEXAbLCZ9hdKLBFcrqW0WeCW5jq+DGnEwXFI6p?=
 =?us-ascii?Q?gdfH7k6QYKNOP2qayn98PlEJyslwTNyl+EQHV4GNiBVhB//rHJkU/l93LBH+?=
 =?us-ascii?Q?aixbXRHVNBDwQghC1viqYfAH/iS/UlzJYkYuUOZZxTJjhvt1BVEGTu0k3Neh?=
 =?us-ascii?Q?se4BoSB9H0uT0pElheqTyWPMZtBQ/ulazCvToEtcKaleP1uJ5RwKyqoAKTYl?=
 =?us-ascii?Q?hBadONAoh8tAQo+uQvn2eNXLtTG9r0tOhJQtWprqmYuRQHUJ5bP2hzZcAlkb?=
 =?us-ascii?Q?oprTTG6YjwqHnCJJarp20J/DtESsBEHrdKSb7p0cMwaVYlBIZlBkaidbc9o/?=
 =?us-ascii?Q?fv8ZAr9ZqfXNN/fSIL/rWldLFl4+9Zdx+Z32qQjE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ca1013-8738-4906-79f2-08da643710d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 18:48:09.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pgMaTkWCHqQ0D/mUOjfOsXvMVTPPjVnTEAf929tiVFz2dOCrRQFbVHa+nkqPJ5oI9Qi/LGWpoyWS0ZsTphGSZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3260
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between dev=
ices
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM
> > +void mana_uncfg_vport(struct mana_port_context *apc) {
> > +	mutex_lock(&apc->vport_mutex);
> > +	apc->vport_use_count--;
> > +	WARN_ON(apc->vport_use_count < 0);
> > +	mutex_unlock(&apc->vport_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(mana_uncfg_vport);
> > +
> > +int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_i=
d,
> > +		   u32 doorbell_pg_id)
> >  {
> >  	struct mana_config_vport_resp resp =3D {};
> >  	struct mana_config_vport_req req =3D {};
> >  	int err;
> >
> > +	/* Ethernet driver and IB driver can't take the port at the same time=
 */
> > +	mutex_lock(&apc->vport_mutex);
> > +	if (apc->vport_use_count > 0) {
> > +		mutex_unlock(&apc->vport_mutex);
> > +		return -ENODEV;
> Maybe -EBUSY is better?

I agree with you, EBUSY is a better value. Will change this in v5.

>=20
> > @@ -563,9 +581,19 @@ static int mana_cfg_vport(struct
> > mana_port_context *apc, u32 protection_dom_id,
> >
> >  	apc->tx_shortform_allowed =3D resp.short_form_allowed;
> >  	apc->tx_vp_offset =3D resp.tx_vport_offset;
> > +
> > +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
> > +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
> Should this be netdev_dbg()?
> The log buffer can be flooded if there are many vPorts per VF PCI device =
and
> there are a lot of VFs.

The reason netdev_info () is used is that this message is important for tro=
ubleshooting initial setup issues with Ethernet driver. We rely on user to =
get this configured right to share the same hardware port between Ethernet =
and RDMA driver. As far as I know, there is no easy way for a driver to "ta=
ke over" an exclusive hardware resource from another driver.=20

If it is acceptable that we have one such message for each opened Ethernet =
port on the system, I suggest we keep it this way.

>=20
> >  out:
> > +	if (err) {
> > +		mutex_lock(&apc->vport_mutex);
> > +		apc->vport_use_count--;
> > +		mutex_unlock(&apc->vport_mutex);
> > +	}
>=20
> Change this to the blelow?
>     if (err)
>         mana_uncfg_vport(apc);
>=20
> > @@ -626,6 +654,9 @@ static int mana_cfg_vport_steering(struct
> > mana_port_context *apc,
> >  			   resp.hdr.status);
> >  		err =3D -EPROTO;
> >  	}
> > +
> > +	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
> > +		    apc->port_handle, num_entries);
>=20
> netdev_dbg()?
>=20
> In general, the patch looks good to me.
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
