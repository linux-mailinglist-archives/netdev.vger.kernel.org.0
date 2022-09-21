Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D230B5E54D9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiIUVAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiIUVAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:00:48 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD603A0338;
        Wed, 21 Sep 2022 14:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKOGRrxSQBkztPuPrB9ghUSLKxxxGPAoqwWGqyOVc6RnJ74M6SpP3K8Zx7UZ1yfbldpdI864hvRg0aFjIr5tZC37kbXTSbPBpMTGafm+3Qjwuwnrflf/wfZsYB2SiTzeJtpbm+tYdWgPe6mo+4yMXGLImfMq/oETt76ZlF4mNsqy2ji6Gpfho6K1tcXcuJugAMCVj/I3FAiwhvehYKPLZsLMGpBY44COPCFY1quZuVjm83BqFwB0+uFS1boZcleiD9weW9C9jUwN+wqTQl2KUh6cA3j0tE+8K14P4MGqpM3rHpX9LmU2TWNfyvtEzc7Z/udHQ1DlnKAydQ98MUcNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hradftqB3Hjfw0BaGcVcFlSY8Nz5eXrfZoYzSSsmGq8=;
 b=cWtANGbq59MLFJ+G8DOhLxgVjz7Y4MT/EUMxPUobW1gCX5fam/WdW2q+MZ9I/QMzylkb5Xy34oscVz0RXLusK0UzojNNmp+p+gB6PnutStbTRskW2Nj71O5QWWplJFqExp/YazU+pEJTdsDrbuCeiK3VmUdyAorKT5wE6HRFERp3So6oWR66OmB+abg9+Y/ilxAqir9cjVe5e0Iq/aWyEbz+oq4xP16h3XwVGha+qdpSUAn5UL7JgCz0FmHihBhg0t0cz/z2g90xv/5R7gHkm5IXhZypj4nbF/3M8nzrmnxs+mwrCIRQbSB9TxLLte6A0u6LuOU6nV5KkS/1igVd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hradftqB3Hjfw0BaGcVcFlSY8Nz5eXrfZoYzSSsmGq8=;
 b=PHr4ATzGdjYLGUe2tQfx5IQG+93CQaqSA62a+k1BxElWbC9IqZMIRlpMx+NpZfqE6rRR3c3oHmbA+PLsS0TXxNmgX4h81DiWatI5HCrFNOlwPcEKoIVrtpIRAimIcWs4uIqVIHHIcYcNya/3XEYSHHfJtLsKF5xclr8tvKWlPjk=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH7PR21MB3287.namprd21.prod.outlook.com (2603:10b6:510:1db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.4; Wed, 21 Sep
 2022 21:00:44 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Wed, 21 Sep 2022
 21:00:44 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYzVi1rl2GvOblR0qql1cMBRcleq3qEx0AgABMhkA=
Date:   Wed, 21 Sep 2022 21:00:44 +0000
Message-ID: <PH7PR21MB32638583BFCB941BFC22CE4FCE4F9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1663723352-598-1-git-send-email-longli@linuxonhyperv.com>
 <1663723352-598-13-git-send-email-longli@linuxonhyperv.com>
 <Yys7NoXN45IVD67O@ziepe.ca>
In-Reply-To: <Yys7NoXN45IVD67O@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=02b50bed-eb51-446e-9cea-d6883a83bd69;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-21T21:00:22Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH7PR21MB3287:EE_
x-ms-office365-filtering-correlation-id: 0d15bf49-4985-4f6c-5db9-08da9c14597d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cf4QkG9N1XSwReiEzb1ejUsyAyEQCCP10S8jcnF7s0A4K/J8v04GPnEHU/QeXbrjP3KUXbI1uLZ4htTqdQPBluOH992AbNxzx78iEz+/3/L8QUzadROMkD8Oz+B64dgyGEfhWqWb7Uj1IhMIUcsD21DuFJjmhy4XAanxP6BuWARqSuxx6kd09T/yLsTfzfoN0zoE/0qV1Lc3UAFip3aSvISER57TM5Ut3R9395TO05glPdYnNASq/XvUReT2ZExuJ5eU0qqIizznMlW5v8PmyiYyCh5nrfvflTVzzkE3s+t4eGNobV/FE0LfqNxmZdM5GNpgt6jAS55chYty0iHUOAoHmbowFtPnBZT1cDl6Dlj/W/yglQJHpDGTJ5t+SdWNcpTZu7+oww8T4v9m33MQSRHemAeYOaU6119S3WTRWjdL/vS3WpC/EtAVomuKevhTDz2XjuSd8EC2rPd/qfWjSXeE9ozRqOTRGhn04L61YvEiERo2MWhaO8R/4FLADWramTaWypkzg2dJsxlN7/lK0NRpZSVWiB5P1K2Z1yfBXIwmQwcPfOqP2N6/2NCU0I23N3zwJTuksUsyOGsbAlcqTSENvcs9JUBBl/t0hggDGPA9WVEZjOAzhmaGGZb5BaWj/s9CVqH8j+JMlwT1VK9MLnvqVvO0AGE2WsxgArxlJ4F0XnjNL0DbVjWqvsNNBoq9FkQc4Ez9spgRGACW5aeVuNboddVDhiyLhE39rWW1Sx2/Geid010hOEAMNBAdxbARzBZtLJHG+56vG3vXgv4xeU2yS86Yb53R28+c2lrxolUatB+f6IzIOfDbt5RztRiy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(47530400004)(451199015)(6916009)(10290500003)(316002)(478600001)(33656002)(55016003)(82950400001)(122000001)(83380400001)(186003)(52536014)(38100700002)(38070700005)(5660300002)(71200400001)(66476007)(82960400001)(8990500004)(7696005)(54906003)(86362001)(2906002)(6506007)(9686003)(26005)(66556008)(41300700001)(64756008)(8936002)(7416002)(66446008)(4326008)(66946007)(76116006)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ReRYvjtB7tNNK4VFoAfFskuSgjISXO2AaffT0wYohnQ6gFXYn2jqTZs1u/Hk?=
 =?us-ascii?Q?3dKBQPh0+9Nt7+c2HslVZFZb8ZM5PTqO6uxYhJXsn9+AzeCeX2iBIhlBsgKN?=
 =?us-ascii?Q?49h704fqaZxIx5lzzXxMW7pjvzNL8e1ovOW/lRoGIo3ZSJcSOfhwd3y2Zd1I?=
 =?us-ascii?Q?Qd2tfbK8i27l4b7z1g+Fe2hYzhKqjf6ihNsiP9JNBX3OIsZpPSUwE21/e8GR?=
 =?us-ascii?Q?hw+1r/28+K4i8pgtaigYlEFX3CmhsabwoSzcC9R2Q6bMZuAnVW/UdZ3XUvlv?=
 =?us-ascii?Q?G6kkF9YEu8e96wkILqcF82sHf7lCbe83z+Gqx61JCUTKbfGSz7TWAfsEJSjM?=
 =?us-ascii?Q?PW7XBVrH3dTRoueOzjuGWB2v3fiOfNUlMxb0KSliPv5vBQ7Y5i/PyErtsRcM?=
 =?us-ascii?Q?zXD7ZDplYRm/m344sEPPmdDgvxdhn1GjcMTsxOu5qvIMtRkodO6b3tYUPbJD?=
 =?us-ascii?Q?e+N3j9IVKT3hc7wtlKZViMXfItNCwF0HkjY6cnxPSoz5Sfzy+YdEz3nr7IUh?=
 =?us-ascii?Q?QO3K1VSuzvGk/pJSYYpscSNnozxn4NVJaUuWplVjaUSeSG42HCcZtQSa4iQH?=
 =?us-ascii?Q?PlZxAI+/Ffug0YGVodsBRFcFefCG8fnYNiI/PRx9L+GbOzefwnhi0BaWq2hm?=
 =?us-ascii?Q?PFrOLQA81tsUZodGzicVXAodWVRdH/OQIh//HGIuUxz0BS/AFkxpixRBL2xB?=
 =?us-ascii?Q?r7fqRM0mH4STJ/bFuxMiTaNBpeZoz+ZKpiK8dzXBx8F5iRWdz1VpS5e1ejOe?=
 =?us-ascii?Q?jjTYHb9KCgaQ2+4y4WMGBRwOSCXDgrrPtMeokHPQnK+T9qgHu7QXmBaCVcz9?=
 =?us-ascii?Q?YegYKEKO2L0u5KUIAX9gsBZZKm9x/q5Uvtdkn/1Bse/hbJG5QCfJ2/nZVwmT?=
 =?us-ascii?Q?LY6w91FgxaDZFHkHG0OGdh91+///mPBQHlMQNYftaeIuauYsjohNKde1QBWa?=
 =?us-ascii?Q?y9g0aRrqn3xOJjEONJxL3aesn13Zo41ZpXXyIwNnPBHO1szZFB7WyRn5zptp?=
 =?us-ascii?Q?lNZvthQ4lLjfOMWpJqYRyY0HobxSWhLw2o1fYmiWacWew7ZsGtmIPVSgfTYo?=
 =?us-ascii?Q?iysOTdJWNXIgX2Fw8FgBTVtZXcLWuU452G49t1t1tiduhQf5khS3VSqjdRal?=
 =?us-ascii?Q?nQFknu78huSCMsfDOpnx4K6xokyNTRHyCYGePheTE3Q0TEHPpQPGutba7b0K?=
 =?us-ascii?Q?WmT5mOd0taSU5g7G/fu9rAF2tPTx0md7Zt64Plh6oTvzcAc6JHbNxgtAikt7?=
 =?us-ascii?Q?9oclW/jW0C4x/KgKOUz12i1mrITKWQfr7bCLCNxkseB5Mhss6MMzb/T952Re?=
 =?us-ascii?Q?GPEMK7ho3TL3HKy6aOabrkY3MnC3UobSDIhccKFxkQm0TwlGTYtTqoolRuq3?=
 =?us-ascii?Q?nbibYs1aWR4zy0LhGYX1bAys/PtQpFkQrl1rtJCGK3UiZDIz20/a28T8yRaL?=
 =?us-ascii?Q?craq+/ZHpy/3NcD6k66pP5a+nfG6Jq5F5b5pbnS7oI19pHOjcOmdcC+y2aMH?=
 =?us-ascii?Q?9FV0oIKlZ4FjYXLy9YGSJHsdihLJ6QfQR4YFT/ocPFdA2GFn0XlKDKM9WBQW?=
 =?us-ascii?Q?Vy9xykjeK+men9NJfKP+7ZoLwjlxBS2GoYN3CGrb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d15bf49-4985-4f6c-5db9-08da9c14597d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 21:00:44.0701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qKS4A6j+40i8wf0HzOGenusVlYWmv27JIkArzzch8kaRbX1Mlxs3d1l56Uk/PP2ZTFNOn/9yqezOce5eoaIb6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3287
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v6 12/12] RDMA/mana_ib: Add a driver for Microsoft
> Azure Network Adapter
>=20
> On Tue, Sep 20, 2022 at 06:22:32PM -0700, longli@linuxonhyperv.com wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > 8b9a50756c7e..7bcc19e27f97 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9426,6 +9426,7 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
> >  M:	Stephen Hemminger <sthemmin@microsoft.com>
> >  M:	Wei Liu <wei.liu@kernel.org>
> >  M:	Dexuan Cui <decui@microsoft.com>
> > +M:	Long Li <longli@microsoft.com>
> >  L:	linux-hyperv@vger.kernel.org
> >  S:	Supported
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
> > @@ -9444,6 +9445,7 @@ F:	arch/x86/kernel/cpu/mshyperv.c
> >  F:	drivers/clocksource/hyperv_timer.c
> >  F:	drivers/hid/hid-hyperv.c
> >  F:	drivers/hv/
> > +F:	drivers/infiniband/hw/mana/
> >  F:	drivers/input/serio/hyperv-keyboard.c
> >  F:	drivers/iommu/hyperv-iommu.c
> >  F:	drivers/net/ethernet/microsoft/
> > @@ -9459,6 +9461,7 @@ F:	include/clocksource/hyperv_timer.h
> >  F:	include/linux/hyperv.h
> >  F:	include/net/mana
> >  F:	include/uapi/linux/hyperv.h
> > +F:	include/uapi/rdma/mana-abi.h
> >  F:	net/vmw_vsock/hyperv_transport.c
> >  F:	tools/hv/
>=20
> This is not the proper way to write a maintainers entry, a driver should =
be
> stand-alone and have L: entries for the subsystem mailing list, not be
> bundled like this. If you do this patches will not go to the correct list=
s and will
> not be applied.
>=20
> Follow the example of every other rdma driver please.
>=20
> Jason

Will fix this.

Thanks,
Long
