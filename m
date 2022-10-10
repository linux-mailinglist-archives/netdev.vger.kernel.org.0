Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450D95FA094
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJJOyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJJOya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:54:30 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F386474FC
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UN/Cc2urysVsC+kBlw/oJuUS8zt9plzn6uSRzq/fTRwDtrhWOKtsw4TU9MOOPqgnPVN1g7AEVXJSX2EvrAaerzWNbkRbNLnghT9Xdecv6jPtLmcmEwcSmrplQetoSaouvzVmwWXflCMbC0CKxuBJf1McVJGdKjRP9rg1nVthnXtBXqqzJvLItOtL2QZDa0qAWjP472LXoQD83zXyiWxn2OH0CcBi6jcJzH1kS8qZHs092Q81qVf2bS3uS+8IfXMb/TqRNt1aRQ2+tzLQxB4jrZK8YdZ/XqRfjp8dSQjynm5RUMK7kG+/wqN4+O3KkZvCubfrcN6gPw3+6/O6X4BGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUrabHhVYJsl+xP4BjqGjm8MaBMbvolRvRBAgNepnNE=;
 b=Wyy/7S0Hb1ssiAirIw+WYm7LfZAiMr1GVA8rLC7/jIFzO5iNDWOHGinG5WpCnSRwUe5YG3d8XAMPJrieGL3gldGV7EdaPpxdsrDZmjrQpjqnceYaX9WD5rc6zzIcQG6EqhCOM/1oQo2vWdxQcZcsuqMBSfA7ZT494Qr0kDLA6mtIRnC41FxE0DMQmxj2bhpFUkbS9ldjvP9Z8qlm7T4WUqCldUOWzruwhEozzIyRQ7GxWbvvqZfPSaWUWjyXG5cqBH3Nn7D36iz0Ee4EnY1ZxWUXkV1crf1QUZfwhr8RwBnO9ThbK0FXV5Dy+zQKuHf98DtatQMacxIxvDlxsKA73w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUrabHhVYJsl+xP4BjqGjm8MaBMbvolRvRBAgNepnNE=;
 b=Fv8Mm8X6ekDME6/msmjH9oLhX6S+KcFggB7XAwie476tZAcLvFSOuFuWaYlvaoBe0Q/ysNslWRM9itMBfqinykxlilidaNH9aTV5urtYVS2qdxFml/JrCfKibKg3G5xmLMVyY9neW7+jCR1FsgnfvuVOFRQT1qao0tj7eSNZ1TA=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU2PR04MB9050.eurprd04.prod.outlook.com (2603:10a6:10:2e5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Mon, 10 Oct
 2022 14:54:24 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 14:54:24 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY2mN8NiUdjFp6H0SMw6HHEkZ4lq4EGh0AgAOcBDA=
Date:   Mon, 10 Oct 2022 14:54:24 +0000
Message-ID: <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
In-Reply-To: <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DU2PR04MB9050:EE_
x-ms-office365-filtering-correlation-id: 2497f0a9-507f-4b80-78a2-08daaacf527d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLxKq8Ld1MH/hwbzf2dW1bMeNgVl1EZlFOgl/Xbjr81ZzR9Pn/Z/oITYri51MpBkP5awTQ0SDwKLilUlimEr5E4SY0RPZRtnNNqOx/L8fKzM4eHMpmxjBwuVShL2bQ3an7G4ihsK+nDADoIlINm7GkUm3jNQlqKmtj/e/L6pHjQixXNovEjaz6lfLLBnzYLtH3ukr8xwgVHADlV78u/lcLTNycaDtF1LZHrFRdWKn/ODJ58DD3YY3ihga0JO2aaQYED871m5Rg6QQZ1Jo88gBFFGFBk43mKNPnkWcVYfpfzON5kblhNdWAYqVmYYSy4/GiiEQI0oqT1QAsFm2ZNGy4azAdjs+4sngYSr6cNIC6VWMn48B4lFXPH/p9+A3q/9JcrtfAYABO5xRPtFADyQmtDfzTXlxpSHuCXeO/BLqUiyQ1V8/ZUa12lO0WujuM6/Wvope25Jy/SPTkEUoYSVHprbQnxjdJxXV+/E+epXJFwd/vcBatdYIoJiBDoH1SVgu8+9XStzC+4DUnWL87y7eXDXR5r6XUYzcnm2INGoACR8PC5RabBX5eyux966LAhyZi6lcLpXEjwt7aUh2bvcuvvZGOa2K4jURkgCxHWQsZeJQVO8WHYBt5/SZvtibo8pE0LaUz+WBmqRMrbNVvqZiT4SDrfyl16xMrSVF/yRDheg5cTO31lOyEL8RDgMyuh15kxh3nZUprgwoGuktOXnCJRTa1Npy9LuG0n9QZlvzZtInGE2ztTwAKm++hOejLvZKrk2FlXXiJWcq0mpwKoNF3HWssppYWQFDIW4O9qqtgo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(38070700005)(8676002)(316002)(6916009)(33656002)(66556008)(186003)(38100700002)(4326008)(122000001)(66946007)(478600001)(53546011)(6506007)(7696005)(66446008)(966005)(8936002)(64756008)(76116006)(55236004)(86362001)(52536014)(26005)(45080400002)(9686003)(66476007)(54906003)(71200400001)(83380400001)(5660300002)(44832011)(41300700001)(55016003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d02ctXwUNgFmY520u9i8g/UoewQAwCFXCGWXsIA0BWK9c653jgHI4HfzOaqV?=
 =?us-ascii?Q?cZHRQe+Zpmhp/hn8YFp/IQMf/3/nS6KItB1LQPlsBF1PFJO+H26Y+W61Vvda?=
 =?us-ascii?Q?ZRsmYrY2+IMMu3w6GYnDlelFgheGZHVm49F8VzL6bkswSTDBqyRGB5dWHPlf?=
 =?us-ascii?Q?zqepSuPY/YBYo86gwSTWkmTmu1XNmj9ofo7TxQbIOz2dVgdsJal7mWWaj7oi?=
 =?us-ascii?Q?xYaktSLl75WM1cMfLAjeqXot9r9sV8xOb0Z+lDiX7KFWhgGF0MgKWEnJ4IL+?=
 =?us-ascii?Q?0wkEErixWK7xY0PTdR1qEjGEYn5DDZfvYZMG+pB2nggtGBY4xAFubD37hEr6?=
 =?us-ascii?Q?mu7swUL32VUACeCZZH/dPbK9LlsoXW14YsEctDan7zXaDgI+B3aD0UsbCoMq?=
 =?us-ascii?Q?Sl1hmjy/SmHD/8ueHa23AW7yS7VYoxJErMcHNv72L6NOWhQzGXavneCTfmFd?=
 =?us-ascii?Q?HYmEaqqb2QYx0vBvfQLgXYJHNxO73rPWn44R6T+OobffDyZ0g1coHmF8mL3x?=
 =?us-ascii?Q?noQXmKk6TjfC2dA1WYgatA4Tz3Qj58CE3cEuPHFNTxi11z7/hbAJv6wS6d4w?=
 =?us-ascii?Q?NtkldS32voPilDDTRP74LMTX+Sn5tJDti0NO3N3NCNCxcsV3ZlF4QMwLSlfB?=
 =?us-ascii?Q?sR047oR1FaY/AFYVxFCjKnqjBFoQrC/qx6vdDaXOyfEMQlsuxvUQAc2b0zqP?=
 =?us-ascii?Q?4Pk7qYM6wxXIobF6KEiZfGOOK5skfFgfZCMFsN0fuytEo6G32+2o6jSHCDAO?=
 =?us-ascii?Q?DD3Rxuy92B4uI3wqoxgeTxqHaOofyF/oIxRrghTMbkyPaE0Tu4bZ5RFMfCje?=
 =?us-ascii?Q?u88rUTuSXLvllSjnvl/ziW1Tbvh5ySYWyHeQBcyguMU0ivTI+sBIV158OCdi?=
 =?us-ascii?Q?NBp4Bo7yaogvKG4iUe+Vh7pk5J8COV69CRMr+uvXrtcCLEYEk8VpWPoKHsrW?=
 =?us-ascii?Q?HcdLFfoL/I57YGZbEh06hTtbyXzN5dtesTVax0b31Kr8ewj4mixNB3L5nvXB?=
 =?us-ascii?Q?m/Yi0qG969DnRYl+dFxK3QcUtBQh5nz7hHDGZXoVWTiBzg6nWTXeiQFHLRLR?=
 =?us-ascii?Q?ELRS2B/EoN9hEh07kiHUrPUPvpujcdnwtMllF93rPgzevK0XOOhJXuVt0MlJ?=
 =?us-ascii?Q?ixX+OWNRnc6YjeQ5eEXcFjpGSL2xxpOWkUgTI17YAyIkvdwfE7/qblfIVEuT?=
 =?us-ascii?Q?6AR0nMlXb/JNUlTJlYKFvC8hHdM6ojDp2MU4iKK0m45Ei9zLQ6uXJH0kVxlJ?=
 =?us-ascii?Q?wQ8y48leshdzCw4WAKaOGml+R4WR+oLmJYd11jRoomeiIE+rN3BX5VWC1cLO?=
 =?us-ascii?Q?4/1v4czT79Cnnz7htoSGm86v667Aj9LaKP87N8rcPZXdsT/5pc3+45U/W+CT?=
 =?us-ascii?Q?K5fzPMLxm6Iy9Q1x+0WG+hHF6Rk553zUEULL8V4MJNURcxl2bLDlhmfe+qpS?=
 =?us-ascii?Q?GNMDXXlZCkiekFYOh8u6auMeFOgvbpWpCoY/6gwXtWQlmQMGuw0h7n7v2eV4?=
 =?us-ascii?Q?vWmNK4stxOjPmDPX4HIYh/G731bOc5cgXBlzSCdwMx0O2Nmcu9hoL4/2Jj/x?=
 =?us-ascii?Q?pyd+w5+3hYmyNgWZzPiZy0FHMbCJNtPV1MjYRubk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2497f0a9-507f-4b80-78a2-08daaacf527d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 14:54:24.4940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0X5uJnxUHZTGjPDZI5ejiF3PDufob5vCm0iHRSSthk28fv+mLK8l37yZgFYKA4y6cDgDrWoS9sYfwSLpanqY8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9050
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
> Sent: Saturday, October 8, 2022 2:28 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm() =
helper
>=20
> Caution: EXT Email
>=20
> On Fri, Oct 07, 2022 at 10:42:46AM -0500, Shenwei Wang wrote:
> > +/**
> > + * phylink_set_mac_pm() - set phydev->mac_managed_pm to true
> > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > + *
> > + * Set the phydev->mac_managed_pm, which is under the phylink
> > +instance
> > + * specified by @pl, to true. This is to indicate that the MAC driver
> > +is
> > + * responsible for PHY PM.
> > + *
> > + * The function can be called in the end of net_device_ops ndo_open()
> > +method
> > + * or any place after phy is connected.
>=20
> May I suggest a different wording:
>=20
> "If the driver wishes to use this feature, this function should be called=
 each time
> after the driver connects a PHY with phylink."
>=20

Your wording is much better. Will use it in the next version.

> This makes it clear that after one of:
>=20
> phylink_connect_phy()
> phylink_of_phy_connect()
> phylink_fwnode_phy_connect()
>=20
> has been called, and the driver wants to call this function, the driver n=
eeds to
> call this every time just after the driver connects a PHY.
>=20
> The alternative is that we store this information away when this function=
 is
> called, and always update the phydev when one is connected.
>=20
> There is also the question whether this should also be applied to PHYs on=
 SFP
> modules or not. Should a network driver using mac managed PM, but also
> supports SFPs, and a copper SFP is plugged in with an accessible PHY, wha=
t
> should happen if the system goes into a low power state?
>=20

In theory, the SFP should be covered by this patch too. Since the resume fl=
ow is
Controlled by the value of phydev->mac_managed_pm, it should work in the sa=
me
way after the phydev is linked to the SFP phy instance.

Regards,
Shenwei

> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7Cedf38f379deb4eda9ccb08daa8fe995a%7C686ea1d3bc2b
> 4c6fa92cd99c5c301635%7C0%7C0%7C638008108695053955%7CUnknown%7C
> TWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJX
> VCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DDiHVcXkqri4qtbsp7BwR6kPhW
> GqLzr%2BVf4tj9JXPzoQ%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
