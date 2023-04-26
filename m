Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11506EF96E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbjDZRa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbjDZRaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:30:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C00983C6;
        Wed, 26 Apr 2023 10:30:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/uS6HDPSBKpwLGmGq7nJ6j8ZpyzDIGQguEEJZg90+xII6YNoN2tvYe7M39Ec7PzyUoClHc3gON91B+3mUq85QQYuKQALFEH7Hv7UvKx2Slr+DHWisAsHn/o0v1M03IR5k5GxlEqbAa8YuFIqW9zest9pVirhsdw6FAecPgbOd+nKUKnJNqx3ZyHtUWVC1O62GA9MeIkfr+1sF2jB//wpUPCwFTxui6FZX6hO5ES8Sc9HwGRCtJVTokD1vHl+2BxHy/7A8GuZKLPJoS2CspDUNRy2K/eojx3iOupZPuwBFiZyzGdp026pzXb2CfH55qSdAwwRHAEO66Ho2BRk1/Nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6nlOJBdzKzj01VuFEWmmoupS6e9OXnO8PI8/xXfiUQ=;
 b=EV4+RMowVDCc2EAHQWLPeehfHqNCB+LGQxI+z4vLXyyfLyhzo1ikqjrEoZ5GDKISx5jUSV3LnNGfr7WWg8Vll2oeLBQAHjTFNDN6DKLuYESkjCVWElcKflcJCRI/LcQbjwXlHk+ca1aryIWjTRHBH0HNg6VASLOAKpmeGvTwqLpvCQLEgdNegFSLowWMlQF7gRPRYw/lnvyqszqpWKprinFoJThMRulCKwZe13yguaacvnC8aI5yFTEv3Acb6Cr5vYuGzB0JX00pxOUehBwj5aJigQMQg7BWqwz5V6wPonWToZz9d2XzZtOdP9+y4zeJPLx5hQVKB/2hXjMJg6chwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6nlOJBdzKzj01VuFEWmmoupS6e9OXnO8PI8/xXfiUQ=;
 b=AiKLGJno06Yk1UUrbn1kuM6OOr2yUeR1DT25GvcF9+Tst5CsK4z8nwfDXf6p45mpVSC0GTnbTY188xyXfOlGmCQ8DmsEKZmiUQprbK+RAuhPwwTQoYuzaa841j2a7SsRX6TwsxVhmS4367Ee9LPzbmbPtdFU+VF6mJDcwdSRqZM=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by DS0PR12MB8041.namprd12.prod.outlook.com (2603:10b6:8:147::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 17:30:04 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::d3f1:81d5:892d:1ad1%6]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 17:30:04 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
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
Thread-Index: AQHZeCv6AGCFWckldUa9v4r2nKGr6K89mzIAgAA9jhA=
Date:   Wed, 26 Apr 2023 17:30:04 +0000
Message-ID: <BYAPR12MB47733FF862989B02CB7056119E659@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
 <2bbbe874-2879-4b1a-bf79-2d5c1a7a35f4@lunn.ch>
In-Reply-To: <2bbbe874-2879-4b1a-bf79-2d5c1a7a35f4@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|DS0PR12MB8041:EE_
x-ms-office365-filtering-correlation-id: 84b9c0c1-7bed-4e87-c6c5-08db467bdf27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eGC3p2i0Kfh+M1qyapFyWj5OMx19c3zNA7oZwhHyEtufq0noxrtExA2P4ILbpSXZwrn00HGIh6nzwv2+4lav/R7y3+8j7nx89E5NeCB7QDDkf6CleJoIm7JAy/dUToSKlGznwscQrjgtvidcrHv0su4FYU8ab6ZpHX2uGB7katwdMfo+jrkJPcNH5KJ4q7gX0veC3tPOc7G5Ti8BjfoCwhxaRj7UUKkqC8SgFRXr2JimjKa2MYM4ZSB+nZVxTjxY71GKa2ubGZPgIBrklqdO2h4rWozISV/A/8WX3NjTm+3Oi8SSJJT9rDK9ZUrV6YBQ9CGtVfMBXZBCCkaPF4KGIaacx6SK5LNqIUCRSULsKaVkqDQiLnKg86OIoPZPxODl4NAH2tyxY7vz8p0BdjLCyLIzGrauWFByLfpiMz+Ruij4xhCLTjPUUCx6cli0vDlDU2ZmEhzYlA4ZlKBsRkJq+AiBWGn64mosz1Qz0MfVY4gh12Od7LQXxGSgLFG8ABVBjaD3KgcDU3ePFOcOpV0NLp8SgecfT+YNFLj+x/YXduZPHA81IAgcZ5Yl6DgfdCL0EYbHmO9uWyGE3KSAG2fGSg1ZuQ7d7M1wrIn5nTk4Nk5KMAfCCC7hqdWptpiZvqVq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(83380400001)(33656002)(86362001)(9686003)(53546011)(6506007)(26005)(7696005)(71200400001)(478600001)(54906003)(7416002)(316002)(66476007)(76116006)(64756008)(66946007)(66556008)(66446008)(4326008)(6916009)(8936002)(8676002)(38070700005)(41300700001)(38100700002)(186003)(2906002)(122000001)(55016003)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a8jn4eyKV3sHCHz7tDM+RpAALOQqc+JX5CIXOcwG8JPZV07Wvp0U5m/1ORRQ?=
 =?us-ascii?Q?kwsm+Zh+JHw25PwMQYuMM0qP81xMMQ0kl1Ks+zLxwcD6yZIGLfRSKPatdeHa?=
 =?us-ascii?Q?/RFYUvGW9uqvuQUZWYeDaJguPXXNYqn0QrYH6pguAs280kL5efUwZ2IAQuZr?=
 =?us-ascii?Q?0vDJUKvaX5R+XKtr/mA4QK2jlgtXR1Hwo2jurZU2YKTYZMtk5KC1u4AAGceX?=
 =?us-ascii?Q?6lzIPoTns2XM9ByE6BKIalnlMBBNVAP6/dMe3nvgb3vZEvs/k5p301TLaLgH?=
 =?us-ascii?Q?HbWMOvjjmhz7MLmV87KZ4FeSjUWHUfQDR+dCLMSDBDNHr8UcVaIuRguwh2hL?=
 =?us-ascii?Q?+6H8UQCsHE+7hZAYZWBSZYMDvTGE87oYJNyrt9tVlvlAEibnY++44S4MRopF?=
 =?us-ascii?Q?uosRYNEK0LxiRA4kz683WXyuDyqOifxgQ5x7lnUjmqZhEhfFc+SgUuDCSYHa?=
 =?us-ascii?Q?FrejQW/l5PoSU3J73LrcwpcdAfvIIxk1VEHgyrM3L3UBgBk+Za++DhZcocyo?=
 =?us-ascii?Q?jRPrqmUMgr0lrQaF88pIAMMyeNPhbveHPzdxA9EDaz5DSOMdHq5CQcGl2dbF?=
 =?us-ascii?Q?vzLofoVhDawVobBWX0Mw3mhpaYnwtBzZGGZ3PvTp2sW3XqHtg7wOGwKP/qOG?=
 =?us-ascii?Q?GfNMP61Xj3wV0i96sfJsJm/Py40GYrgAzbGTH0VgqHpQVkgupzrZEbmVrMDU?=
 =?us-ascii?Q?mzPED+XSb9D002Al3L40QNEVfj2IbZXBjHhZcKXBvw8NAtrc3vuE1dqyjlmE?=
 =?us-ascii?Q?A3Ij/0EykVC5WkBHCj4baSu+2HpFAwNuUvEWFDjWeFfFTg5ISiUCKhXNk9dv?=
 =?us-ascii?Q?z1wXYmFhbxXh7lyp420yMt5q0OdN3BN8XVbNQTX37+XtIvfNJMMiLiRiIrfC?=
 =?us-ascii?Q?T1m8vBB9ydN9UBZ5PexIRSycLwT6LsEKAamqZKUg+a+N+wTuL366e5RvHRPw?=
 =?us-ascii?Q?nALmaZxBewzrgrnfSbRg9wNNcQY2kUi2kgIzM12j2yMQaorUyIu2BOVPS2mi?=
 =?us-ascii?Q?CYM3eV5sD4h0WYPNvatnbw4KxWnaVkpS/rqQ5GGnShCMWjpPhCw9ORq3Z1wQ?=
 =?us-ascii?Q?r5mYlL1ECqpidPZRuRG4EhCKVuHvbLsmhPI62hFe265/pPwxNxRJQSviyC6m?=
 =?us-ascii?Q?OZsUyawc2ADDec/FGeYm2umsXWYHQZ2cZqZhexFQ2p+T3cPVac08rfAfHLyL?=
 =?us-ascii?Q?S3aXOrNYSQko0KE2pwxtdDFEprp/jBsBAxecVGETpKOu7Msi3OzlcNaGfClA?=
 =?us-ascii?Q?AaFybYS3SK8Id+IKGgTageRpEPzBsXvaXM/wteZJBz1K4iKepiMh63tFRWW6?=
 =?us-ascii?Q?rl3IWGom1R2iezFnIxCpOxEhK1kxi/hU8YReLMpTqsGomZFgiy6SqiyIFd2s?=
 =?us-ascii?Q?N3TJaSemJ8b8Zr+I1q3atQ9L0dnSDkf9qDCV8hWMuoZ1NRUiB7+J/lf8vdfa?=
 =?us-ascii?Q?bZUXKRzb3/lAxwWQ7jeJnnNaYCk1h0RWmbUdsXgovXAHmuh+yEnBijrrU8Iu?=
 =?us-ascii?Q?x4vhfD/JpmkGlhvpld2/T3E+0ytLA8/XbS3g+ByI+g9P3Uk5m+TOED7H0Id/?=
 =?us-ascii?Q?LKK+LSsgD/Ew6d4zZmU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b9c0c1-7bed-4e87-c6c5-08db467bdf27
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 17:30:04.1723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WST4e2U4i2szcxEcBK3Woi4JQ19X17AO0hfvkbSH8s6OOAJg5VwaojSuc4GKyk27
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8041
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

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, April 26, 2023 7:18 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: robh+dt@kernel.org; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; edumazet@google.com;
> pabeni@redhat.com; vladimir.oltean@nxp.com; wsa+renesas@sang-
> engineering.com; krzysztof.kozlowski+dt@linaro.org;
> simon.horman@corigine.com; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> harinikatakamlinux@gmail.com; Simek, Michal <michal.simek@amd.com>;
> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_0=
2
> with RGMII tuning
>=20
> On Wed, Apr 26, 2023 at 04:13:13PM +0530, Harini Katakam wrote:
> > From: Harini Katakam <harini.katakam@xilinx.com>
> >
> > Add support for VSC8531_02 (Rev 2) device.
> > Add support for optional RGMII RX and TX delay tuning via devicetree.
> > The hierarchy is:
> > - Retain the defaul 0.2ns delay when RGMII tuning is not set.
> > - Retain the default 2ns delay when RGMII tuning is set and DT delay
> > property is NOT specified.
>=20
> tuning is probably the wrong word here. I normally consider tuning as sma=
ll
> changes from 0ns/2ns. The course setting of 0ns or 2ns is not tuning. I
> normally use RGMII internal delays to refer to that.
>=20
> However, i'm not sure there is consistency among drivers.

Thanks for the input, I understand. I'm planning on re-phrasing this
with phy-mode and property values to describe rather than say tuning.

Regards,
Harini

