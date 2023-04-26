Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C536EF988
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjDZRjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbjDZRjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:39:49 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B9E10C;
        Wed, 26 Apr 2023 10:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU3V279Ne0WpUqmzTgwJTK+ckMnIBdxsRDCShEWtEmQ/eEomNpohKh4H96ag1Y2ao252mfDgXV3YLXl3aBpxIi4HFRLjm5boRSsym5xMvJRwA9mSEcNzj0UEMzqHWyS7KCYawglo3p+EZTBPUGEz/TRT5MElM1nBTPgXauDpiMn9REE2WMFrChZwoesoR89PAAIVClOvLYx1N5A5TEZiZHYhaRhYCmDCa93hffTLl9o7JteXwypMyaPVsbsPew3253xuwVmX4Ojmcz5G4y4Wd+/x7jzXesbGQ9wunY1B+J+86bOUhMOVDrHVZjzil8fhCcwHVq6i7pPcWVmaoD6PEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACoDAkE5YrPQZB/+2UJdVhfc5EjmvVwGiET0oWzyHf4=;
 b=FvhtkSpMsN8nsbdDlp+b9l4Cnjktzhg9ahLzZuXU0RcLq77YEdJDmv0FA8HM9Yr5o7E8oJ091asKkF9550EDKTcntyA9NOwuknp7Sw80uHSvHvzR4dNZ8b9KjSd6izXL/4juDPivUNA3E8S6poJnTxyV0uOgu+fMsLTYhwzYVY0iMOsEiiexvExM9rShD/qeKMEfKR7z0No99A1x89BwfT0OefCOQRsCBPbNX8MYkSyVc+ajDXC83bQPvtxjyr190LqYuwBa9fk26oD8r/fsU0XqzE6JhRyPn5ntLIQmNm/w8fzzYixyo8/WSN1WEH8m9rEb+E5GAw39KWreXqvbjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACoDAkE5YrPQZB/+2UJdVhfc5EjmvVwGiET0oWzyHf4=;
 b=3pNGD53bjKjoYvNtWnwAvw0fE1a8w73txrxbiKeA4ScWRTYuOm8ZTkPllH1+dJFNOvVHsTQUQ8VsCl1/d0OEm1ugTWSLNI/AEAUDGK5UAcrK+1MUitaynVNeWzS6CgVmrZnFv6forKZowKTswBVyV8EADwpJBkj1NAy/17OdU7Q=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by DM6PR12MB4580.namprd12.prod.outlook.com (2603:10b6:5:2a8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 26 Apr
 2023 17:39:44 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1%6]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 17:39:44 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "wsa+renesas@sang-engineering.com" <wsa+renesas@sang-engineering.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Thread-Topic: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Thread-Index: AQHZeCv6AGCFWckldUa9v4r2nKGr6K89cUQagAAJECCAAClIgIAANeFQ
Date:   Wed, 26 Apr 2023 17:39:43 +0000
Message-ID: <BYAPR12MB4773EC5AC6DBEEE7BF0E08239E659@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <20230426111809.s647kol4dmas46io@skbuf>
 <BYAPR12MB47738A21AE76E4CDEE28DFFF9E659@BYAPR12MB4773.namprd12.prod.outlook.com>
 <20230426141831.cxurksrsnj2c47vv@skbuf>
In-Reply-To: <20230426141831.cxurksrsnj2c47vv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|DM6PR12MB4580:EE_
x-ms-office365-filtering-correlation-id: 710c4a68-cdae-48a6-42d4-08db467d38bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: df3MssxXGLA/CQK0hQVu0aq65CVUtIbQQt68EHtMh7yMyazlxbpXxhDeIXGuwG3p/r4l4ejWnTbciag9sBguJ8uw1oQ3o4Udkvo4bm4BVsg2F40iFKh+xNm90vxH9AeUYW1s2hIhXlqNWzckCRwTqf/XpDIQckwDppeKicvw+/78iblCoK77ppKgEI8/tPbsHdSGr5uOzs2pWFpivPU1UtRlFteL99WToi5Dkq+VRk6NHX/ymXoSKuYZAVC0Q9gFx2rGXzJWPZHkQYraVmVJBQ9SrKYotQ1xSKIMnE/sQJuiwwpbgCYfPp5JnmhwfdKKnNLn4e8AMaTIJaTAG1MhiatzgPxn3KAO74lRqyo5hW+BJQEM+jkAXXgFjhvXL7EpcDeIQIH1d3I8bHp/xnT2fy/Xgz37LpzjqZdt8/yBxEXRO3q48Wn8Y36QRgUPQGxn3sDDCMysUbfds/0k2GBY9c77uPXhQ1UXtVf3rLmzoMmMkvFkWqa7ud5seQhedb+MwhTLuikvZy2Lg4ZmO8qP2p1QA5GPiozLNmM5DSDoSBdT2sMIOo5Ddj4tf7iS30MwrfhAE4DOhngRf8yA584qrZI4CBMlWfWleqbJPGndk8w+PvL8M9etJ5OuHJz0cfyX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(66556008)(41300700001)(76116006)(316002)(66946007)(26005)(4326008)(54906003)(6916009)(64756008)(478600001)(83380400001)(8936002)(33656002)(7416002)(52536014)(5660300002)(66476007)(53546011)(9686003)(6506007)(66446008)(71200400001)(186003)(7696005)(8676002)(38070700005)(2906002)(38100700002)(122000001)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mO+snv3Hp5R6phLFJZr7PHHvqLa6gCQVAGNEDuj95gJ09DUAVHuQuRAoKoQU?=
 =?us-ascii?Q?iM6rqfUOVsh2Q2Xq7Xd60iRpWyWB81p/w7EQ+gkiAMQJa1YukK1+nWKuxf4c?=
 =?us-ascii?Q?QolygVF/R+3EtWudE/d180HUeRUvVitiCanfWJdO4x6pXH2fhHM9xJjmXtI6?=
 =?us-ascii?Q?51gW/UcyFhd5x99jJQjRznM8rtGyoDej+C38PVkr8Fid4/3vPP5nwY2o9EET?=
 =?us-ascii?Q?fzZMorePx/JM3/GdEn6qoa9eDknOQlUMr7MWRAnn/J2MWiUhOzdpOKL1AaqS?=
 =?us-ascii?Q?aa6bkRetnRvs/2ftXNK2M0udHN9wqEw1LHyGBzir291L+fErUMjbSPUK0otp?=
 =?us-ascii?Q?yE5M4hrfuIuGCovfVOidXAaYAPe6TS7VEbRiFQO+PQJk+mX+xLMxUnhzuEO0?=
 =?us-ascii?Q?SDAD12mpVWc4SQRI0p0NG2IHg77RHEUBM2RmFbz/SRPq7sb35yrD/5jAsRDk?=
 =?us-ascii?Q?jmE1XcP5ENuH321CMJZUJcbugm22dWmMbasqf47GaUkNOO/mgR8uyZtESuQ0?=
 =?us-ascii?Q?Un95H8RlWHl3KChAeH27cpP6vajgOp7RlZvupC4FCFSyV6shfVArQSeVIeLl?=
 =?us-ascii?Q?bzgZ8rYSWOgbvKpenrIInz5k8ZPTs+sMXOQuh9lJ4poWbJXI7kKlOTOLO1hZ?=
 =?us-ascii?Q?4p6YYl3jXzp5c2txOw9Tu7cZJbgS5OzsmeQ2eAVoIM0b4u2+sFlEC6uRCsnG?=
 =?us-ascii?Q?x40N2yBiOHyEBuaysK5d9i2tsPXqyyYMdXnT9+rlDAaGXuKNIlaL+MYxB1NQ?=
 =?us-ascii?Q?1IuVVWB5XKhuyzodDe3uSrkhjO40Oc6i8LLVRLAUOxzeGZsZalWD/Af2Ac9K?=
 =?us-ascii?Q?hQiKtgWO00oqVfy0xz4+fGGsarzbRvAt2NsuMSGZveQq5rKOzMb2GsGOmVtg?=
 =?us-ascii?Q?a9hMw6Gg7cgXt8PL/fAuMZXyY4JRWnHoIUbe/gIm7GjO+n/2GoC/qO4cP2lo?=
 =?us-ascii?Q?oyLmhBo8pdBbIH9j1dSExg6DA5vgPNL++/ygANPbgCo8DLlP8jhV9exLmxLK?=
 =?us-ascii?Q?sZMYznV+3K9YJ7UFhhIouou+K8ox4zmYXEMWpQdznL6gxMe/YZPq1wzPsNWn?=
 =?us-ascii?Q?CNaAXd+WQyDqoiUs1ksd4nLVMQvA/9nX85le+RLcPH6kvvy6VIIAvENcDAMA?=
 =?us-ascii?Q?Kzm1yPp2vUYeIw+Qv7eK7SWEqMMTHPu0s4IDt+Cl1hd4CHQgfdZG13JMdAhf?=
 =?us-ascii?Q?o3DGdNAFXHexTmnaoinbCLFDalH75mvgfV6MlCR1s/zsF1rE24WcwPsNAj4c?=
 =?us-ascii?Q?ouTV2NhRX7ZJ4OrNKEYO4JLXFl3bRRYh2OvyOhtR1fuy2j4j9NiytG4/G/h5?=
 =?us-ascii?Q?UctVmgI1GgMxqtE9S99meNyDcBbWR8X/yOeWCJBYoMLHF9Sm2NKBFtUcR5nT?=
 =?us-ascii?Q?EWVk9vriYGI4hkQbHTVmctAdSG9CiHim1vYUVxL03qttR/W7C0FWLxQsusll?=
 =?us-ascii?Q?Xj+J795/1kbLcWKNr1yp2K+XYfycQd3zNFMvv8u3/c75L0L5W8Yg9Cr4AnVX?=
 =?us-ascii?Q?cw62mDxtJj694M4R/s/z7b02SUbokLdtApyYhPswoDKu3p8TO1CKgSEPd/ew?=
 =?us-ascii?Q?o0/OwxWJCHrxL9R8NMk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710c4a68-cdae-48a6-42d4-08db467d38bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 17:39:43.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nht4MJojBTjI3eygKW+zPvPvxS9uIVevV82lMUmmjuUkLueR1+/Ik1wyWbgcOVVc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4580
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, April 26, 2023 7:49 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: robh+dt@kernel.org; andrew@lunn.ch; hkallweit1@gmail.com;
> linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org;
> edumazet@google.com; pabeni@redhat.com; wsa+renesas@sang-
> engineering.com; krzysztof.kozlowski+dt@linaro.org;
> simon.horman@corigine.com; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_0=
2
> with RGMII tuning
>=20
> On Wed, Apr 26, 2023 at 12:21:47PM +0000, Katakam, Harini wrote:
> > Thanks for the review.
> > The intention is to have the following precedence (I'll rephrase the
> > commit if required)
> > -> If phy-mode is rgmii, current behavior persists for all devices If
> > -> phy-mode is rgmii-id/rgmii-rxid/rgmii-txid, current behavior
> > -> persists for all devices
> > (i.e. delay of RGMII_CLK_DELAY_2_0_NS)
> > -> If phy-mode is rgmii-id/rgmii-rxid/rgmii-txid AND
> > -> rx-internal-delay-ps/tx-internal-delay-ps
> > is defined, then the value from DT is considered instead of 2ns. (NOT
> > irrespective of phy-mode)
> >
> > I'm checking the phy drivers that use phy_get_internal_delay and the
> > description phy-mode in ethernet-controller.yaml and
> > rx/tx-internal-delay-ps in ethernet-phy.yaml. It does look like the abo=
ve is
> allowed. Please do let me know otherwise.
>=20
> I understood what your intention was. What I meant was:
>=20
>  phy-mode                       rgmii                          rgmii-rxid=
/rgmii-id
>  ------------------------------------------------------------------------=
--------------------
>  rx-internal-delay-ps absent    0.2 ns                         2 ns
>  rx-internal-delay-ps present   follow rx-internal-delay-ps    follow rx-=
internal-
> delay-ps
>=20
> I agree with Andrew that probably there isn't consistency among PHY drive=
rs
> for this interpretation - see dp83822 vs intel-xway for example.

Thanks, yes I noticed the difference here and also in older PHY drivers tha=
t
used custom properties (see dp83867 which is what I originally aligned it t=
o).
But the table you mentioned above makes sense; I'll re-spin accordingly.

> My interpretation was based on the wording from the dt-bindings document,
> which seems to suggest that rx-internal-delay-ps takes precedence.

OK I understand.

Regards,
Harini
