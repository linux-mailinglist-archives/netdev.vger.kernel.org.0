Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FBF618CB0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 00:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiKCXSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 19:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiKCXSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 19:18:49 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0607.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D091F9CD
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 16:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XORttKCzQAyL45Radp1N4dFbhAX5jB3jM8H2RjYjWqO0EqWizCU3pJHh/9tdo1VtvCSHrhqaoe9wTtubpIkBcPxGnchb5FF8KyPIJoKvzx+fRtMUpEf+AAuEH0EbM5cTqzRKK0Om9o3NrpJNfSLJsOJDJrw2US3iZy+7Sa7/GIoA3GLIpPBKFa0y1uhe3lURC1KqzpMXYR7HogyPYdSQPqhMk4wnqJOBulCSYAZJPll1KNNg+bqrFmnCE/oLvJVSLda1oP9OUUXnvhV5BAJuK1tt302UvXJSFD3RgtKPWuK85vFbKcXRBiZqHSw6WtqTf/dFk+w3GPPb6RzWtISOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybf34Ai1eF54rD+9wrUA75b/u2ARhK3JRMm9zemXFZw=;
 b=WZfVQ1vfVpwZVsq4G/3nPYjf/vwjR7Mlo3UaQTKOZ/mwwd2ekzaZwOGodV8xNLKcJpAGB17L+ThoS4IUzwd7Y2kCfgbNAD/G49q5NQvRWLKIXwhjg8OFmF9/MZkHJxgR+0porVjbs6KKWmpk92V1bb+2fyncxOxt20RULO0sg3zHdPGEoG6YYFxXQwJjNs+zgE6ZqijA+2aa4bWKduxViUykWJpierFmFYajCnkfBTeu0wJUSGqru+v7CxeqUEc55sHh2410Yi5GP8+Y2OA/ZUjG8u6Taqxxpzbqh3nwfBWEzjpFF/O7iEfpTfqA1FcgyYYf9nevdcKjPCSWWBYdCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybf34Ai1eF54rD+9wrUA75b/u2ARhK3JRMm9zemXFZw=;
 b=KSu+v/weoBWGo/3WnZFO9YYq+naSajmkRYrPobPPfHSKzdBCBzEqzwZ0OtL3Bl5aRpSWCieV8a4srHmloS4q5ZkoknqLdpjBo8zJH59kGlZih/O2br0cWMRBawrpkx7SWzRWKflZ3sv137YqJqQ16tG0dwbHzr7Cx6jQ7UCi98E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9412.eurprd04.prod.outlook.com (2603:10a6:20b:4eb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Thu, 3 Nov
 2022 23:18:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 23:18:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB)
 support
Thread-Topic: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB)
 support
Thread-Index: AQHY7inCrbPCJEIs3UaHPF1x4C21mw==
Date:   Thu, 3 Nov 2022 23:18:39 +0000
Message-ID: <20221103231838.fp5nh5g3kv7cz2d2@skbuf>
References: <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
In-Reply-To: <20221101193922.2125323-2-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9412:EE_
x-ms-office365-filtering-correlation-id: 5c5b03d6-2d7a-467f-3906-08dabdf1bdee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9X1KRHLi1znEIC/2JjHMP+EvDUlicQInnWbPAp5Mlpsr9IrPo8aXJy3WnxOAmdBCssJB5QqOgaPO+VbkEPlcbdScKZ8M2QaZXl1H2PjDZawtDUN0BF8gePfVkx87cQPtXvQChc2DF/MEJq0hWZvnBR7b58+3lccfSQsAfPx+GOqH0+9oDE1fSCbBUadh9U27QqEY0V42DYzOsM+mqBQy4q/8pHdEasIzP/OIjxfhBhKuesOlabTpy+prYZdKwb7EZrJwKEWCBh/6sNsBZ9f+J2PnwPs22dlzj3ZVhO03P7dNwEY5Ju6pNOVVO+SMxBR/ksJKSb8yqW1DATNgfLfu+hKvha4uhbqRZBjFYH16bANQKQP1MmKe6iegLoQyrkBfK3ufzYLd4P7iqrVPbROmUgLGLDxiyScou5cOXYnBTSKCeYbpIZkdS+1GAE9E+LfJ/qHGW+Cf1W3pHmwklBnU87LtlEX6w0YNB2lwL5Ld2y6YNxoYK+BD3HaKGF45f0fIGREKED+FCgJctivXI7v30OSeb1WWHhfjxHuye60sS8Ggrmyu6yQIeCAdlcZMLLRFvS/CYI/QYfpz2tl1lIFgq7BIV+pr2QTUXPZwwvQtsrbPQu12AyK7OR+G6s6fVpFXnAphpK+8aGCaQLUXIh9A7PA6woGQx8d4Q41NjlVoSGFXK8KJpZvc8o1Dqr8xAyZx5HjDRk28JBa7rau/KPI7C/rDK9IQAnfrlrK18sfXso9ihNJwME0rOHDUoDsMfRPSD+vkwOgtEMvPjs1B2os0OQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199015)(6916009)(54906003)(91956017)(316002)(44832011)(5660300002)(4326008)(478600001)(33716001)(86362001)(6486002)(8676002)(6506007)(71200400001)(7416002)(186003)(2906002)(83380400001)(38100700002)(66446008)(122000001)(66476007)(38070700005)(26005)(66946007)(64756008)(6512007)(9686003)(76116006)(66556008)(8936002)(41300700001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0hni9jjqAkkLucqykTtIk1LJJY9PJ6gOgJhjGDBtpw6DTGfi9ckW/MLTKvyv?=
 =?us-ascii?Q?H8wkWsO9EPLfUuzRZtpHe8o/1fQkZ58/xB6cbDatUrS4AboqGI836OANTRxW?=
 =?us-ascii?Q?BisVcY0d6NyjjwTN70HWzM1iJZAGZMv9j1o9bXQBsiQvrZWmYzwpmUtR4tOg?=
 =?us-ascii?Q?tfY+Wf0BlsSE2m+OROIqhLcs2btwfOewIEWMuoiso6rPdMdcHnzpm/u+B7Qr?=
 =?us-ascii?Q?U8eMldhENCfJUC2uOY7C4giNVOvxCuProIVnuoueP/qSu6zuRKyYlhlBNo+K?=
 =?us-ascii?Q?typLmP7ap9j9iuGrYwxn4mwPYqz1oP0xCDUzc9k0fz5kctKuugOro3nmPgUD?=
 =?us-ascii?Q?h2BKOdCVXrty/ANF+S1lJ3PCcEDWC/51QV2S4S9891ghqX7azHMhte7egrck?=
 =?us-ascii?Q?pMx1tnqECjG9bMa//7Lt3VidhKaOdIzeCvA3WV4/k6Ox3rsC1k2SLma6JcQa?=
 =?us-ascii?Q?KPeL5CQq/fQtIEcGJqk5C/9QKpxCgQWuVDoWM4m+IQ1l46PQYJp7fgwrCFzE?=
 =?us-ascii?Q?biLz/eLVwy3NvQwU5T8DG84U9OmaGOv1gxrz5wQm7RHl0lk7ldnVeio0snXu?=
 =?us-ascii?Q?vuQWz32lr3DMPqjBL2PPtmqeK88c8D4POGxl9p0Ku9xM/p8L4I7r3SYOvKrG?=
 =?us-ascii?Q?U+51oQeMl8j81oMHtA8cW/GUaywmlbD/SHBRDsiSLYFhmMAKxM7WqJ6IXL3A?=
 =?us-ascii?Q?0rVNMIFhGrEumLDrFp0v5/KAodWIf5YS471SRHAm3McCCMxEZkrLVqSDpbwL?=
 =?us-ascii?Q?cdvs/x2cUA9FMyPBa1cn/MwkpxY4EsF7+3tOj+vkiiDMklxmX4ecCTZd9J2A?=
 =?us-ascii?Q?tH2lZQF3FGjsK4hgs7PjT7PCyNr7EloNqDb6uZT4RTG2BAeWARjDZN10WYps?=
 =?us-ascii?Q?xDj5/lY+aPNnzlMmqr+HxcjxaVWngF7Lx0giWFElOXl3RlMkyly098kLdEcg?=
 =?us-ascii?Q?MPWnDBWoCgeXTUpvmKwUGUlGyF1ttyQjKVLwcji8UiaZUvOBk44H1GQ6A7dx?=
 =?us-ascii?Q?ttZhMyziwR/bTZt8FlMMnc5xsX07aHOZN79Cs1nUc7PeXKwUw/ku6EDkInme?=
 =?us-ascii?Q?XvwotuJbbxv8VdDRb30v5tiMNbLOJg69I+5P9CswcLs/2gTtQfOtRuWsCUKv?=
 =?us-ascii?Q?MijL0Bawi1tbOHe8DXsBftj+dHNbWMbYy5fhjiRxXlLOWxyPryjn3Tt2WRvv?=
 =?us-ascii?Q?K3ILfSMjI15sbVX6qxaVTEhTKgAB2OfwS7a4v4gbZJDKcGflwmDGu16frtPv?=
 =?us-ascii?Q?Egj/UfnYnocU+RWDd0S6CuI/M0GkWRBqEnYU8dJhwDsDrrW8xYN+o5qBdkTk?=
 =?us-ascii?Q?9LFXz15yuXLvfGhK0dvvBg76GG30SIningvVTHgr37kFX1OVgpPy0mZOJMu5?=
 =?us-ascii?Q?/6sVhYqwc96vKlk/RjFv18qZTwbolKOq1iYBdt9Jt8nfEAstvTmHpKZE6ec7?=
 =?us-ascii?Q?4N2vpOxAWlGQqEmHTip8vCH7pXxhsYR98gXtGILhM6mSi/Pv2/KqBSBo8YJK?=
 =?us-ascii?Q?jQcvWV5xzKmqKeL7kDgajpWnIWEKlcsjjM7hOdBn4ynWFcIaIIryWio/te56?=
 =?us-ascii?Q?GyfF/DAvDB9x42t2aTdXhepL4GkKNHOVo1U1kue4IW72Pa6CQXK47E+9kMrT?=
 =?us-ascii?Q?Jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3B0EC894D80D647882DF483137FCEB8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5b03d6-2d7a-467f-3906-08dabdf1bdee
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 23:18:39.6995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfFqSy2Zhl3fsVQLS1FKUGqTLsGd4SVn7RKoNrK2l9r5kZWNRzV3Mlee54MR3NN8Xpg6LMJ5YM06YAu2sH+CHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9412
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:39:21PM +0200, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>=20
> Hosts that support 802.1X authentication are able to authenticate
> themselves by exchanging EAPOL frames with an authenticator (Ethernet
> bridge, in this case) and an authentication server. Access to the
> network is only granted by the authenticator to successfully
> authenticated hosts.
>=20
> The above is implemented in the bridge using the "locked" bridge port
> option. When enabled, link-local frames (e.g., EAPOL) can be locally
> received by the bridge, but all other frames are dropped unless the host
> is authenticated. That is, unless the user space control plane installed
> an FDB entry according to which the source address of the frame is
> located behind the locked ingress port. The entry can be dynamic, in
> which case learning needs to be enabled so that the entry will be
> refreshed by incoming traffic.
>=20
> There are deployments in which not all the devices connected to the
> authenticator (the bridge) support 802.1X. Such devices can include
> printers and cameras. One option to support such deployments is to
> unlock the bridge ports connecting these devices, but a slightly more
> secure option is to use MAB. When MAB is enabled, the MAC address of the
> connected device is used as the user name and password for the
> authentication.
>=20
> For MAB to work, the user space control plane needs to be notified about
> MAC addresses that are trying to gain access so that they will be
> compared against an allow list. This can be implemented via the regular
> learning process with the sole difference that learned FDB entries are
> installed with a new "locked" flag indicating that the entry cannot be
> used to authenticate the device. The flag cannot be set by user space,
> but user space can clear the flag by replacing the entry, thereby
> authenticating the device.
>=20
> Locked FDB entries implement the following semantics with regards to
> roaming, aging and forwarding:
>=20
> 1. Roaming: Locked FDB entries can roam to unlocked (authorized) ports,
>    in which case the "locked" flag is cleared. FDB entries cannot roam
>    to locked ports regardless of MAB being enabled or not. Therefore,
>    locked FDB entries are only created if an FDB entry with the given {MA=
C,
>    VID} does not already exist. This behavior prevents unauthenticated
>    devices from disrupting traffic destined to already authenticated
>    devices.
>=20
> 2. Aging: Locked FDB entries age and refresh by incoming traffic like
>    regular entries.
>=20
> 3. Forwarding: Locked FDB entries forward traffic like regular entries.
>    If user space detects an unauthorized MAC behind a locked port and
>    wishes to prevent traffic with this MAC DA from reaching the host, it
>    can do so using tc or a different mechanism.

In other words, a user space MAB daemon has a lot of extra work to do.
I'm willing to bet it's going to cut 90% of those corners ;) anyway...

>=20
> Enable the above behavior using a new bridge port option called "mab".
> It can only be enabled on a bridge port that is both locked and has
> learning enabled. Locked FDB entries are flushed from the port once MAB
> is disabled. A new option is added because there are pure 802.1X
> deployments that are not interested in notifications about locked FDB
> entries.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
