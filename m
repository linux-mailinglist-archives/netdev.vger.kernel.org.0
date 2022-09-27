Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667DD5ECC4D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiI0SoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiI0SoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:44:06 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2114.outbound.protection.outlook.com [40.107.96.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A151C5C91;
        Tue, 27 Sep 2022 11:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDuLQoL1q5/fxpPYeyZuJ/rPBq7Hx5n4NPprQ5tBLnz/spmbMUzQ9sFo9ReBZEy2yvb2M9Xl3EYpxebiCKWXcbML1OArZkka7tj1CGF62wGsGKQJTA5y1zxMBX4TtX0n6ZkfD7WwqeO1BYMEOTmzNgjgDfOgTgpbyT3UDLOSuY24xgJrKKf77ApEf+Uv4kwW82eGUusiLshUFH47xjbX7EZKDruIAOY6ecMSiLdQGY6/T34knXyTUgjP8d3UidIfXHrJJEMgVj2ZeHunjhPZoG3MhjUhKg4aJs6TtmDVz9W9NNzS6m/1iqI5IKZN58wZw4uNdOk82b9H8NB//zQqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOOIluDrrS6D42uUWaPM1Sqm/zyolDl/YjS2FO8+LDs=;
 b=MMVBCo/d/3b0EV0+1u4zsqvgbUkqoDvFF380QQ+oqAYpCkAfr/CEaWZyvWf/0RAMPzY3XfXP0KH74X9sTKnQoNfjBKP9NRtrBYBgElXngAlBsbHgk6UUqFqBuE3Vxqx2Ago1ODV/gnUU67iQrC7Fym4z9biqgCvrrkyMO13IOYfPdxb26ijce8z/+a/WjN0ru1BUxFRG/N0u7QN4Ra3gfQFIMHArILbmrzuRFDdHzq64Uf8MuWFvRVZHkTU9fzNbcWlIqwD+ykLovZxpPBCbcXFTAUqUYZwAC4Yfg1C1PQoA8VaPrREs9NvkDQJQjr6BzzY8l7JPLfSwq5iH4/nLcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOOIluDrrS6D42uUWaPM1Sqm/zyolDl/YjS2FO8+LDs=;
 b=SAq68meVyZgFrE0C3VPz6deV7VDIGOH5NGl0Kqt2efr9ZUEdJo4XHAtVT3a5Q4KfTDjahvK51qqTtKpxGiutIyVRtMUFjYbxKblQKf3X/aiSszJpvaGUcxvNQSmVCcuth65L0m2GPlkNzdlknVdhZ+oIXyZEvL2aMjCwpw+RnSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5347.namprd10.prod.outlook.com
 (2603:10b6:208:328::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 18:43:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 18:43:56 +0000
Date:   Tue, 27 Sep 2022 11:43:46 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 08/14] net: dsa: felix: update init_regmap to
 be string-based
Message-ID: <YzNEYiXx6UoJLEdk@colin-ia-desktop>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-9-colin.foster@in-advantage.com>
 <20220927175353.mn5lpxopp2n2yegr@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927175353.mn5lpxopp2n2yegr@skbuf>
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB5347:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e849877-3295-4636-bcfe-08daa0b83b7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PD4y87sbo6nEasXPEaLcPsq8730LI2zmDGjVjqwUGGxmpMuWRkCBRuv+bJvpgqGPZylv8wcYg3KkeRgY/l+F/lvD9tnkfY17gd+3orfCODnAHTQnKBsbg4P1M35OZaDtEvbWyXSZajCoaWYT5flDIWTLFPNnO2b1py/2HQE0TakUAqFS2HLb5BVSGo5HeHnv1McytdmFEVeoQUo7QAwBc4X0vCDULfiMwgTBExKw+Quw0z5hc1K4U2rIARTL1F8seTBg/5gNk0Afpi6bldiI6elYfX+Ib8uOREydHBienYzfBsF4VTdarl/DXlzpImuKeRk3mm5rYhyZGYy5JTsBDMj+OhSlMeVOK9zWEA5tbVgnqRdYrCoQJ7FE+i36ivcIape+r9a62NBNjMJjI8pguaj2Wm6kCaK3okANSLitp1Eqq2ZTYP/ZMVyaNTYiwCvrPJfmV6cvJs73Fsat5G3nYQ7jWuCVOKucsRj2y8YEdqIvkKwor4NJo06qZ8FsbeO2hbf6HzDyjZfxkfWaVulgnpLPwDVaWlBhgOjWaWuWhVUYmrJQPhdlbyeoAuI2C9JfHkNOtH4oE7ihlzlaoKKa0EFRZq/3UPumo3UY4RFyr8gSU5vdEjk/3Fz8Tnw/9r96IycF+41VWtFEI+w4kbYmFXwvk6ALh9QGbew7u/1xg3LjcS1/cibOIrcfZKGR4ANN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(136003)(376002)(39830400003)(451199015)(2906002)(41300700001)(6506007)(8936002)(6666004)(7416002)(44832011)(5660300002)(6512007)(9686003)(33716001)(38100700002)(186003)(26005)(86362001)(83380400001)(8676002)(478600001)(54906003)(6916009)(316002)(66556008)(66946007)(4326008)(66476007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JDdiPKrtBaJ85JmzGWM/z0hP65lQjOD1RWPMMyv9UXr05NK4uc6LIBAow6ME?=
 =?us-ascii?Q?XKt9i3zYhWkbeDM2WqRDRZjpnQks0T6mC7P3oByRxn2AelbN22tkp09DMTN2?=
 =?us-ascii?Q?ZsLNqs7Y3NtYwNW2pdlFmDrXvOxfR5alvZYaHp4w+oIl+Ce1CE+JDfhRvJsN?=
 =?us-ascii?Q?dPGwgjDdwN04MhNiCHm3SH4Khz/FbAdfNRYxJs6GQ2YS8tnrw4JHlv9vumAN?=
 =?us-ascii?Q?qhLNtv8ahO4/+A1Xwq7uSp3VMrGKO8EF/YL5O7aAhC7hLY3d44tamvLM3WAw?=
 =?us-ascii?Q?1rmNtG/sRawenQHKFS0m1xbPTJmDVXi2bsReFm8sMKsHTpcGyf2pky7Ue9kw?=
 =?us-ascii?Q?7ML25mETgvw9wwdtH5tJr8Etrbn6NHpEaP4i8mYvmIHLa8OIJ63QxSK/xwtX?=
 =?us-ascii?Q?7HzDKJGObqUbcCmzoOkhG0Jw4MuVal2MbhfTMdB6UtQ4U/9kM9AyKf4J++G0?=
 =?us-ascii?Q?3+ub1yhNmzbDlqb55gM70G+or237Ob6BXG7QeLT5Wlur9ZBylsXqtDUrCVgC?=
 =?us-ascii?Q?8nDdzvnLQYB4WkZbT3psDfO/w5Id0W79VvcgMa52sy+u/JjmzoXd/qMPi5Gd?=
 =?us-ascii?Q?ssES1ttiAYj1AgiJHQIBc2SXE4teJsmCU8AerAY8n8cDEaKk54Leh3wQdpor?=
 =?us-ascii?Q?II2GoPHlofVlwWzU+FUarEaB+/eDQRz+3PeCHH+wiO93L4yRJ2pVlQDYEHTf?=
 =?us-ascii?Q?tnEv+c/zGIabWeudodPPqdrztFiO/ib34+VVUWmqEV/fXoXB5kAugmDujKX1?=
 =?us-ascii?Q?Ckmcrv7BIShLQezTmhcvZ/sR5wPb1lhEFTV2wqosqydhdn6at5R2DiiKtET/?=
 =?us-ascii?Q?8ZxMH/qXUx7N1S3PCZdrgtfByMtbA1vpkCEzU9YMMPx0yJs2zpe6waSbh5TI?=
 =?us-ascii?Q?ooYXipUJgNc3vCpZcSbx8md0EtiOBySyGEkhB/LTjcm3jdfARIPtQsl/Ep1n?=
 =?us-ascii?Q?+aepKab06P0q6XjY3Vrfc6ufoBYbgadzqjd0oJ9NpREIyr6b8W2HjUMXxWIx?=
 =?us-ascii?Q?L8XajL36EWepXPjf11wM92EzOQm4IYkBqhr8J2IE3pn8NKeN8aqW7Q/2OFRF?=
 =?us-ascii?Q?j3tDHYecIUiwUNXc1SNUuNTAKPnHGfuH5Y9aD5hpDRBAmig05KTr11nOtalw?=
 =?us-ascii?Q?yvsfJR7WYi8KfyuzeiFcrxBQeA4Fo14KvwZAs/37spEfWZ1pXIcqKridVSGx?=
 =?us-ascii?Q?17pE6REYgNyjss1eeUP6a1ooWyHRyy/vF3YBBL4B86BdkW2zuzhd0ytCByRt?=
 =?us-ascii?Q?+iOousXARpVovmKpCbVf4WdmMQpJgaG8dBuDpy2RAKg7NWvce6j3rf2A5zcA?=
 =?us-ascii?Q?rr9RT1RU0rqqF23APQvw9Xk5J5LrMGqhguq0NeO3FgPPJpWRqwkM9uv/MmAZ?=
 =?us-ascii?Q?YWmXJNd+NDLszj4h/cwV5gtr2AG0/pNj4UhgXOUXG8a1BRWD2ojXpwRaYNO5?=
 =?us-ascii?Q?zjw4I8y8SzGr14qAdeiK4UKyqR42yupd54MviimeVWPcmwSYSRGgaKcY7uci?=
 =?us-ascii?Q?idvBoj6vxXSKxhUAe5qidCJoa5jW4iJKsfQUIcAmAVyZcUgZiTd8z5S+Nti9?=
 =?us-ascii?Q?v0GDJDwQODdPJ+7aFPCTar+BAyox5opDoL9VALv739LdodiNioPyzsjZ1e3E?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e849877-3295-4636-bcfe-08daa0b83b7e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 18:43:56.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agUwwwXjSdeRMO47myjBPcutqUvfivJhOd1iIIU1AeHKdXqVnvjsoiZMke9lepdJAM73BeZqm3udouYl9SrKz0yG3hln9cPUFnHiK8Gw85Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5347
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Sep 27, 2022 at 08:53:53PM +0300, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Sun, Sep 25, 2022 at 05:29:22PM -0700, Colin Foster wrote:
> > During development, it was believed that a wrapper for ocelot_regmap_init()
> > would be sufficient for the felix driver to work in non-mmio scenarios.
> > This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
> > add interface for custom regmaps")
> > 
> > As the external ocelot DSA driver grew closer to an acceptable state, it
> > was realized that most of the parameters that were passed in from struct
> > resource *res were useless and ignored. This is due to the fact that the
> > external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).
> > 
> > Instead of simply ignoring those parameters, refactor the API to only
> > require the name as an argument. MMIO scenarios this will reconstruct the
> > struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
> > scenarios need only call dev_get_regmap(dev, name).
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> I don't like how this turned out. I was expecting you not to look at the
> exported resources from the ocelot-core anymore - that was kind of the
> point of using just the names rather than the whole resource definitions.

I see your point. The init_regmap(name) interface collides with the
*_io_res arrays. Changing the init_regmap() interface doesn't really
change the underlying issue - *_io_res[] is the thing that you're
suggesting to go.

I'm interested to see where this is going. I feel like it might be a
constant names[] array, then felix_vsc9959_init_regmap() where the
specific name <> resource mapping happens. Maybe a common
felix_match_resource_to_name(name, res, len)?

That would definitely remove the need for exporting the
vsc7512_*_io_res[] arrays, which I didn't understand from your v1
review.


Something like:
include/soc/mscc/ocelot.h
#define OCELOT_RES_NAME_ANA "ana"

const char *ocelot_target_names[TARGET_MAX] = {[ANA] = OCELOT_RES_NAME_ANA};

...


drivers/net/dsa/ocelot/felix.c
for (i = 0; i < TARGET_MAX; i++)
    target = felix->info->init_regmap(ocelot_target_names[i]);

...


drivers/net/dsa/ocelot/felix_vsc9959.c
static const struct resource vsc9959_target_io_res[TARGET_MAX] = ...;

vsc9959_init_regmap(name)
{
    /* more logic for port_io_res, but you get the point */
    return felix_init_regmap(name, &vsc9959_target_io_res, TARGET_MAX);
}


> 
> I am also sorry for the mess that the felix driver currently is in, and
> the fact that some things may have confused you.

Vladimir, you might be the last person on earth who owes me an apology.

