Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63EA4B8BD7
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiBPOzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:55:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiBPOzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:55:45 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80082.outbound.protection.outlook.com [40.107.8.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31041F6B88
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:55:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INhxoThn5mlUWDexiWBawdnyT7/Gm1yI+UsWLO4qknGUPVIp2GQOCTH5qDJORwbkGqKqYtFRq7DZNCadU5uV24gGqm5v2hXnOA8fc2cWoGYnf5lPrFO8C08VlFJlg10bnSIFEsl39mM3631ldQoKBjsol0BohykWUNadPSovc6zy5BZtYfbyyd8oEr2x0KzryvlUpN6y1o0JawpYqW64xyme9YjkWFlS981FuoXygxMc8RReypXOzQpEEGhc79ByLAHFx1ZL8DeZYZj9hVlPTZGiI9E/Y0tSEO/TdP2jT91VsRLdduA/uXnxbRJk+ZINPh34ftVYZuuMSzQcgg2kZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKoh16fpd1PaMVoVGCto870GKiGT01AbOkjA44ti8Hk=;
 b=IrJ7yhGpqRZzD5FRtk4QAUbPKOqfDa94tSaqOaShJJihp42BWMg0RjSTRhsf2aIJkC70KsL/JPjvvWsiMZ8L2SME43qGqAguTIESrFmWe4N93+m6Pb/OBYPdCqasT/QfWB8gO2QAs2dT5VaBLgR6bP96lJiju4wYHcJEG4DEClufogBWAPYffcUwL6kn1qE+y/V8gjqe5VVFh1SbtO9I/fChlMLIT31L4dvT+//CNFafxnmuUIN1GOaxywVvZDb8obhF4VNZHmx07ItRjnEzHAs0aQK1ORincjER+Pe1nBus93em7FIzkOnVGA/pX1vrCPgxJ+s043KLWElyU01imQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKoh16fpd1PaMVoVGCto870GKiGT01AbOkjA44ti8Hk=;
 b=pA4lEuG69QcKmKW4NmnY/EL6yGsJU8/92kfESjnymL/W6IFyGrGC2rTGPzcsAYgjCKxsGbN7Y3YVn7hYJXDk83NrtdqPiJBcwVZ/rjw/k+CZJubsls9RXeDx1aig/Wo6E5rkT5U9qrX+g7XbjboxyMOA0otP53D7338xUTqTW/4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6215.eurprd04.prod.outlook.com (2603:10a6:20b:b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:55:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:55:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 00/11] Support PTP over UDP with the ocelot-8021q
 DSA tagging protocol
Thread-Topic: [PATCH net-next 00/11] Support PTP over UDP with the
 ocelot-8021q DSA tagging protocol
Thread-Index: AQHYI0IJq3zzg92xLUKeKWd01UxvJayWQ/GA
Date:   Wed, 16 Feb 2022 14:55:25 +0000
Message-ID: <20220216145525.tekpe2xhuzmz7lyb@skbuf>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3674240-f31a-4da2-fcca-08d9f15c5db1
x-ms-traffictypediagnostic: AM6PR04MB6215:EE_
x-microsoft-antispam-prvs: <AM6PR04MB621546049B3D337E29DBD257E0359@AM6PR04MB6215.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tz96qlvjb1AZBUNywbuNQRD8fDQ7jQBKojd2eHWW+UcIQyHnCHtAIUjz23d18caWSTwu5SEfBUcopOW0UdXzlHmHpHHxmSS+HbIDEvmJUA6tNl4qCpHROAA8nh0xqxqHM9tpk/KuPE+LQzkgnBotYiMWYQtTC3QTrQ9Og2TMXCaonn8DPQGR01zhsuGtMdpAkoerPHVZLn0BrSuvOobnzr6NBQdTZRMjexnfw2KZUFvg0USWbOGSiVYgDYVSUfoYYeVaxGpv3I3B8vmRaJRka2RL2lghdq7n3jtTn8Wka5ugXorroxWt6qZvpw0SuEPkqgSUSs1NYEFNxLzYlpVsBCEQ2CcYCJV5mnVBYO0EFAt0aNOH8CwOKgWmJ2i+kyFIyzZhrv2a2lWJRVy848EVkCMaCT6XEAApuqUMasf3vUme78b9FI79mDDKUf3B6Z/Jo/ucdwcbWclaSnebahY9BUewtHbqz7RfyQ9vYNne+s/o/taXDsHxVpT2ilLkHIeJUY2eFJjv0CLqTG3o6PTS/8ZZafVWNpOYHPkMHf1AgwP3cC54HecWDpOv+qBiP0s9jE7sxSYjSDD/gi/X3H+9z8LDsMSG9hZFzh4rKfaL9IORWRpDBrI98HnMdOifvkUBgBsM++9w96DqYSsa3aVK1Mcs8WZD6ZzBazWAV7FlqGKt34J199EH38PkE6wbVy5eeXCcX9VnygurMICMY3+nfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6486002)(38070700005)(71200400001)(122000001)(38100700002)(508600001)(2906002)(7416002)(4744005)(5660300002)(8936002)(44832011)(83380400001)(91956017)(316002)(33716001)(54906003)(6916009)(186003)(66946007)(26005)(6512007)(9686003)(6506007)(86362001)(76116006)(66476007)(66556008)(66446008)(8676002)(4326008)(64756008)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cq7vFEsxDtlGLmZo16L3TuF3LBnnkSbzqs8ua8QykGMBpgO/88PHDiJ+v0V2?=
 =?us-ascii?Q?aFnKnF1XPussINOEbqJXYpNwQMl3oqr8Q3kjUjaQartfizidzy4cRvtweiyP?=
 =?us-ascii?Q?jyETO/9cuy5EDUD8mEuirJAWHU6VJR+FP2Vk6o2XwOCoCBz5IHy305ABt3c9?=
 =?us-ascii?Q?vq2gQYCR2mu6zuDftvivEVxJBv6RRUrve4rfnAx6g4e+8xkr1tu3EGFBTvT/?=
 =?us-ascii?Q?nwDIUvlwtvv106LKy7SlReomCkGScxCgm5IGdCPjkgUvvIipi/UrBughqsqb?=
 =?us-ascii?Q?9tLkcW5HXMgD2fyspVJpBiR+n0vjZZkPkvkl2b+XVFOmjVDT/fyovfgrQT+r?=
 =?us-ascii?Q?tA6wXMReL0fpJMrINI4Abvo2Xi/GUJmI2lRqqzG0Q0t6nu3+Y61g5US6HwYX?=
 =?us-ascii?Q?wxAycLSYhcER5GDAy1GunIv8V2hT5n2OcgwIJCwnEanYtAqWyCy19RUQAe28?=
 =?us-ascii?Q?I1FjSb16lKGy6tILpf3JMissK5b4wi0BXP8sU2bo2pKMM6+sC+A17/9C+Fg4?=
 =?us-ascii?Q?6+EbjiaDcAISkUsr01X4B940aEZu3kdfCoHmYllDxD6TSifUbupBe7HrOgb4?=
 =?us-ascii?Q?pVFQfMmBq4NhbELeORIhP5nZp9257ZF68Wgmngw7KRUBTJ+qX7gEUPQGx/ZZ?=
 =?us-ascii?Q?H1uRiJAFAxJcou0XOr6t0hFD8eaxwSK7Oppk7FvETAgjZRw00lEfIu18bdjd?=
 =?us-ascii?Q?30iostBF7u7KBovcx+4ZDmMRng1pGOxMgIu7lDYFQEWEk7+md89V/goe4XMb?=
 =?us-ascii?Q?JDHfY5ubYyT/QWG3HWu/Q+20i/HDKxeHeIvwUG+0WHj2TPu26NqhDEk4DYpn?=
 =?us-ascii?Q?hx8swscxRnvd6LD9PqJ8B1zHkJh3lR2OpnCnswPJ2jym0qs352r6tK6/9hZg?=
 =?us-ascii?Q?R8NYIjS36xiZzNY60Ld5owM6AGdrlPYiU+cQfoDhQlX3gXtVBYK2mcIQo4jQ?=
 =?us-ascii?Q?h8Ivign2KIRzXJGpv2F7vUMq6t3mJ3L3D6ci1PYaPyqLtZUcdOUt8jEEhdLL?=
 =?us-ascii?Q?2pPcbumv/fB2JIrxiQLQ6O4iBNLGhVEzoRGodT8S6jdNrEAXw1BhtqUmR/qN?=
 =?us-ascii?Q?LPvZ1Rl/oKYpnqNNlAZpprS3E98rbVzP7hcIDE4IdhGhdqfa8vCQJELeViz7?=
 =?us-ascii?Q?mRwdgKQXC9t7VfmLw7xb2dsBp//8Xou93qVOldk0lJ6QAGTA/fGrA0K3eS3u?=
 =?us-ascii?Q?UC7mPtOFhlhoxcuXfaWzQNTwr53K60cCWURB6MidGLX8munt3FvtRTxYHxcu?=
 =?us-ascii?Q?b0qPevJyixQr4idV7j8vzVRaymKw5VDE5jaHshsLTb4vfhGjKPRlot1yWpn5?=
 =?us-ascii?Q?PvUleFw324bA1sNX+f22KrD8GqUyKkRLdayqWLaG1aho87sfYuZtu/gzROvE?=
 =?us-ascii?Q?D8QA09HQm5e4/XeqABp04yKKwrzJzfUeU3y+ezQM+PqYIvgjo0W6UUxfm2Hr?=
 =?us-ascii?Q?nCA17nt+WSYAuOCQFTx9qbdYV2DiJhb038tVmyZApiw/dsctz9kycXkDGPy1?=
 =?us-ascii?Q?gbdrdILY7oR7B5xnS40lbn/PPslhbjALtnwO88WjLV6uPr+8Li+7sKoxstzB?=
 =?us-ascii?Q?t6cjKvIcX2rbInZUm5ggjM/7+eMvn+p0GkUPpneTiHbCqIXNS88Z32fR9w+4?=
 =?us-ascii?Q?tTEvMW/VVI5Zt8eOaL6NsEk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ACA4F92A9A951D4EB36080C569866368@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3674240-f31a-4da2-fcca-08d9f15c5db1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 14:55:25.9304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xPjahhmRPKRUGkF4wj62wYOTjeio+mXvENJyxgJK4Q4b4YslaMWqocLW+AMEc6OYXQHKjPxdsL5c3zIZt5cWdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 04:30:03PM +0200, Vladimir Oltean wrote:
> There is further consolidation of traps to be done. The cookies used by
> MRP traps overlap with the cookies used for tag_8021q PTP traps, so
> those features could not be used at the same time.

Huh. I always wondered what would happen if I

(1) run the "git send-email" command
(2) do some last-minute changes on the cover letter
(3) confirm the "git send-email" command

The answer is that it doesn't pick them up :)

The last paragraph was supposed to read:

The work done here has nothing to do with PTP though, and is just a
consolidation of the traps installed by this driver. The cookies used by
MRP traps overlap with the cookies used for tag_8021q PTP traps, so
those features could not be used at the same time - another limitation
that is being lifted.

Anyway...=
