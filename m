Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23B15FE2A2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJMTYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 15:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJMTYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 15:24:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8961669B8
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 12:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+wmVXmCGKyIvS3Oco7vaUNLs0mlsNB2ZlDkR4nuEb+6O8PCedUE+ibr6xg3dYKirm+mS9GPcegdrG0pRmEJhLqudwdxwdITDuCFfeUYw1ncOITnDFTaT+kfrncj8upXF94iyKAh/Ga0U6tURpWMmoT75nIUhCkAEo5f7V+LEPN1cPhrupa6gZ/8BqdMOZnCKRCPE5HtbWRP2SuAwS1IM+G0oAyyUG0rDodaMbqCV5xUac8wFzAhspWAMhBRg16tzf3GdsWVfnuribcHeCBxhQgMwaF35lWEWeC3v5GqebNqkSBEMRmHRkAFM7Xfxd9kB4VdZyh023AAI7DEQiayjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8hrMtETXG0YcBcypu3WvtkY9uffki//gcy2Zc2DxpI=;
 b=WrEEMrmrzR8ANhiuZU8+dtkJfVb4ZJHJa8oclVMwfJ2UpFIHfUZcdQ0HSKBbf9hUWm1Rmwzh1l23TEXRy9fEz6fRaurQeTzXQwy6tE60KtKBbMdfnvPe3S9iOkD5QbHRzsHmrMrzloHwp7iCN7ZX6478TcVFKvx+eLOVVTzMBbF7STfHLVRILf6DbXaLMv7lDKxsrsTX53DiJIlMNZIUEyI1MWqSJb1+2XZ1ikYDGVW3V6hLRFeERaWsPfTkgtWViExCBQX7RDYbjYBEyYWgILhMc1LM2pO7t9ss9B9JOMMxTsSWk051lqaWvGVzJmxop8kIwprX7uS/x4qnEb2aFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8hrMtETXG0YcBcypu3WvtkY9uffki//gcy2Zc2DxpI=;
 b=pGnZ5w580AAebhdF3oQCMLV/lNPNZL26HcvilcH5GgEYmui/HjpKYUhqhU7lJ61bw0z0ybvndtC55eluyORZZzWtuZXU+qvHngfPMNejuXbDgA1a3x6n1nNQAV5nBNkuzl/5jUpS5H4AREXKJVYA3z71Y3L9MioscNVcV7l8hZo=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM8PR04MB7763.eurprd04.prod.outlook.com (2603:10a6:20b:246::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Thu, 13 Oct
 2022 19:24:02 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 19:24:02 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v5 0/2] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH v5 0/2] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY3wk2CanzdntwfEWQ9Eg3sPAe964MfaiAgAA0e5A=
Date:   Thu, 13 Oct 2022 19:24:02 +0000
Message-ID: <PAXPR04MB9185777624723D0FE11C6E4689259@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
 <Y0g3tW26qDDaxYPP@shell.armlinux.org.uk>
In-Reply-To: <Y0g3tW26qDDaxYPP@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM8PR04MB7763:EE_
x-ms-office365-filtering-correlation-id: 5e8d1daf-5561-406d-9bf7-08daad507c59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frbh6ozReVn/Vlhu94CnS96pOzuqqfbqvziK5ROHjDwtR1Oo2vcGyjiwf34RPugn+HzzM2MlCMu/auXFYWj96ji26VIq17TldCaH9DuqyWZiHz64CdVTMD8iaE0UtwcYBRwKIyFKnYyCElkmRdP60fXRZ55Vva99K8MIeFfAsSSHMHc/mYsM7wXh6Rw7ETLVY/iZPNTde1Br1vugyjTSIAGPUU5Gw2EcrGTBTfjs3i+9SmrohzXJlTdHKZVq1bip33nOvZ/mai0vXcyJn/KcXQv/VTTmf/JN8/wE74eCIErlFaEx6jh0GZg/SJc1qB6nGsqgHKflFj5lVJez8wdUyDCABVxEpHzSkgNSetkKxj64ZKJhdWJ/EQDe+OGmKIS9fA+r1lkxaq4VvreyYHjovSz7QLCvMczD99tNRnqgqMiUn/fKr1kStMuJBMUsmJl8bEc/eACfcUbWRvquZPccMHjtuuWpJpr1cjIF+pGS0MOjffzu4dUxLd0rPXLZCnFbRMBo17YbZu9n4QEAUKiyKAchFfKUqBiLgwR/deSx20180ua0y2gsUTrS+KfXteF8ZfRE/WqjBnCIQnnWHy9TYO+G9PH4NFvNT13YjeO7jDHKfLV71PtdESaBefx/LJJawZDkhMsu17tJuiIZWBol7YOz3p+IjG3zcT5tVvFCyVbRWsBn4IEGbXv1ebhX8zrZr1D4nj7L+MBDRt1YfMZRTAlD12VGZmbzkihB0TviOn6uMkknPUGEuL04A7tWZrrghy4+KY/t51ZSAJ0gZ/O4az+gic8g+RHsdutbWCVUiyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199015)(38100700002)(33656002)(71200400001)(186003)(76116006)(66946007)(66446008)(41300700001)(64756008)(8676002)(4326008)(966005)(122000001)(6506007)(316002)(26005)(7696005)(9686003)(66556008)(55016003)(6916009)(53546011)(55236004)(45080400002)(54906003)(478600001)(86362001)(83380400001)(38070700005)(66476007)(5660300002)(52536014)(44832011)(8936002)(7416002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i4PMHOKXk1rJ7sNC5f+AmEhvVO2JYl8yNPbjp4Oi7i308KbjqbsR0PiAictx?=
 =?us-ascii?Q?vBJ+QmEqvH93uME3pl7/1PJpam0BAr4Aq619EL9L1tkxk0m3966ThJbpMMat?=
 =?us-ascii?Q?fT9QvUjoSqz3OBGXaDikdE6CPwo+ohKrwXvaGq57owgbkQ6IU/9oscl9bkRx?=
 =?us-ascii?Q?cXiukTJvxmVAkxUpwLnFzxPQKPNRQYItC2CyyvnnqWf5k04GL4JN16eQyTuB?=
 =?us-ascii?Q?849kUm5Cs9Bjh78cqK0XIG4MQkzN9+BJsBIPJRHcNcVC2aDXRVhPkCIzwY6D?=
 =?us-ascii?Q?hzdqM9fQM31UlSv4T7LdkxV3eGpY1VFUsVX2CbkA5xWbUKAdpKK4wMJWdf29?=
 =?us-ascii?Q?kVeTfHhunWYAv+dmzF4obgmVMi85nz1XGkqaaaDkozSW6+2gi8Apyq64C1ww?=
 =?us-ascii?Q?slQsSn4dRcD26KWc/TdL3/fCIs8YquPAXtSFgafalWBBl4nDRX9zXkJax28H?=
 =?us-ascii?Q?wUtRb2c/a7w7D16G/1NyYYKf2EvYr+FJgVTmxaZhmmbDovvpVZiWQJktsAV2?=
 =?us-ascii?Q?5ICbKi/vcOHYkPnTCmwOW6PICVzaEuZn1IKMIxWZYxyQVtQ2iINARteC8ra9?=
 =?us-ascii?Q?cmmVPrMbQx00eHVUS+DJ13a6kwhiS9uXpdyNfS2u2iHTIKQ7txvDxk1d7LOQ?=
 =?us-ascii?Q?Qv3BM4nkr32focagSwnUgmN+XA9fTvWBur36yhKUugSLnf13J6Wzqhy+VGAG?=
 =?us-ascii?Q?mWQAG1zE8RiEu7xNAfwUNqOHCkEm2+QqZyVSqrZFQcbZcU8NZfgC5cSeq+PR?=
 =?us-ascii?Q?Gll5B8vIdLYiNCEwRMy/l0tfU2pJJ1AzfsA7q+tZ+wUKFIHCwvJfUubvkDWR?=
 =?us-ascii?Q?8Ur9JU5GPoRY1YePHlT3Xrf/zWGbC9Gtv+xNG1M4oYvumq3i4TYpM72icCSl?=
 =?us-ascii?Q?5JcqEjWfcsvfN1btMWYBZU8cySMdHQG9JTsErq54rgOX9orch7o7BgVeVbj5?=
 =?us-ascii?Q?Fl9vXnd1gTUWnDRkkH6ADk2l6LJnz/ELzJDlrxP12q+9Cqht6bdYWo+yhfAt?=
 =?us-ascii?Q?lOZYJm6xaD8LEXkSXwliJ9mE7QpVp+AIFf0WZiVfH9TVxGCcaWIUIKLYre0O?=
 =?us-ascii?Q?1iI8LyBQWbGUifLRBl6sM1Wpqj2+QAueTnsfNm/zncuZnZTOQOqKmL4d9tpd?=
 =?us-ascii?Q?8qjplNEMTEImSLqkFIqehRwfEH7RzOBUEt875TZYR+hbcmVi3SmB7XpPnQBQ?=
 =?us-ascii?Q?hJwgW8U1xQsWcFMSdILlxAbzAI1I47fX34FV+DLStS3URacZD8Yl13CTTB0o?=
 =?us-ascii?Q?4r/tWwISjojsxLnJlWbHFy+oKfnw+gshfQeM5ZU2l0XeRzGVN0Sueee10PBx?=
 =?us-ascii?Q?XWAfeBZwyCLCW05c6LUMCFeOH9eWfWs2wUDkjz0RpWHrGDPZhc3s4t5gjJFL?=
 =?us-ascii?Q?pBx5PGQkV0ShbcJoBS257R2OXDMDoCcUV5HFvt6u3/OQGdqGQ8OVaobnd++K?=
 =?us-ascii?Q?2JYTqxQ3s13JEFR7Jsp9m2Dk2xgVbNL5XOF/DWEft2/9mgdfhFM/dCbmHRtI?=
 =?us-ascii?Q?Q/zFGmzQVpUMB++NOLQaBRYEMhPi2xGigDycz6QdkenMChP5sRqaQXeQMZyC?=
 =?us-ascii?Q?DPGYUngUuivXEdZOvfrQ8Hq6H5x2ZiHUT0q8vTNf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8d1daf-5561-406d-9bf7-08daad507c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 19:24:02.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7zT3dgrvUkVZOL4VogbzC/nkZCJlZHyeojCm2bkNhK3Cb2bv0O4JH++aK+mchwekFky2pj3+lUIVQ72tVxjgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Thursday, October 13, 2022 11:07 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@foss.st.com>; Jose Abreu <joabreu@synopsys.com>;
> netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com; linux-
> arm-kernel@lists.infradead.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v5 0/2] net: phylink: add phylink_set_mac_pm() =
helper
>=20
> Caution: EXT Email
>=20
> On Thu, Oct 13, 2022 at 08:39:02AM -0500, Shenwei Wang wrote:
> > Per Russell's suggestion, the implementation is changed from the
> > helper function to add an extra property in phylink_config structure
> > because this change can easily cover SFP usecase too.
>=20
> Which tree are you aiming this for - net-next or net?
>=20

The patch can be applied to both trees.  You can select the one which is ea=
sy to
go ahead.

Thanks,
Shenwei

> You should use [PATCH net ...] or [PATCH net-next ...] to indicate which =
tree
> you're aiming these patches for.
>=20
> Please don't repost due to this unless you want it to go into the net tre=
e, as net-
> next is currently closed.
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7C9eb73c5218ab4ca2e25908daad350702%7C686ea1d3bc2
> b4c6fa92cd99c5c301635%7C0%7C0%7C638012740506537030%7CUnknown%7
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJ
> XVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DZUtXNJ8wXqhi9Tvcg51uJJvcS
> 9CbJt6yxF3zjuoEfuQ%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
