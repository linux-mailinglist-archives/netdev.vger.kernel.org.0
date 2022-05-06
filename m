Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A113551DA9D
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 16:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442240AbiEFOkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 10:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiEFOkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 10:40:32 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10060.outbound.protection.outlook.com [40.107.1.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C306A414
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 07:36:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azV/9KcGrbTaKetwWCi6l7eRbZt3CeAlHjTkKwX2z0Ekhm+no/cGCNN+zoEgEXwBT1KPEdT63E5kns9PgR5SmGyAZ56Gh3LZ3e6IJeqB/CtMx5URoIo7o2SwJA0pSbw5645hVjNqDtrslSWwmUK2xdDOejV5VgozJ5SzREO+yier7Eh2mP8adXeLzMXTqKOmOH3YXIzmrVq1ORsFmfFFodyRHSOW7G8SGaVd6fS2wKnRjE/fKYCUbnfPXh94hQVJ1CuDBApm2qs5EYtpv/t4QJ8/MXgFsMC3NXKpVAhAJKRFhseKBvg2G7Uq+fdUzzOAjG2rB27FUnNKYppUdy8Tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yRKnsqksDCSbn1gQAG/Im68So9MbU1So6FBxhsZpd8=;
 b=JWAfyfqvZoH2e1W22pWQeZm+xMXZmvPr7vQks9IjZ6Gt4QH/+A6z3/LASvzLE6z/jzRdr5MBxKJ6lxwLmPOD9oyeH55R5MuVMlHMC4AAB0GLc/z/F31+lzJss4LqvC7rslQSj40YpGHJqBnwdT7hADSDD3wjdfi1Gk/GVyUNM80ZihdNMzt8duaiP1l0crSU0xEdMtwXyYgdysZjW2EkrpyT1gB7o07ipZxad5PF678Sq1JzG0vg1oYZTiR82VTNpMNgp+B4vBAaHSeBHPwLHLMPHI36X181XS04b3dZ6fhtdDTzv3lnoQDmSurK5OW9pmKI7jEFIMAyLCryKPGEBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yRKnsqksDCSbn1gQAG/Im68So9MbU1So6FBxhsZpd8=;
 b=RDdkA5Dbc6E4WgN9K/9ty52KMpqODUrnet7H7nDXLqdQDRu7a0pNxF3SilOug3qOERDmr0/lXytlk8Lcw+zOARvC08Yh7gx123rXvhy0N1sRsgjyGXynD+IPzsoVt/fox29PYL7dtJFkRf/sPKQ4lfNCrYWwI8n1CJhermPWiHc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8269.eurprd04.prod.outlook.com (2603:10a6:102:1c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Fri, 6 May
 2022 14:36:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5227.018; Fri, 6 May 2022
 14:36:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Thread-Topic: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Thread-Index: AQHYYNPTxzTCj3geMU+nx4uF2Q5CIK0R68IA
Date:   Fri, 6 May 2022 14:36:45 +0000
Message-ID: <20220506143644.mzfffht44t3glwci@skbuf>
References: <20220505225904.342388-1-andrew@lunn.ch>
In-Reply-To: <20220505225904.342388-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f6a1d56-f823-413b-fa72-08da2f6dd850
x-ms-traffictypediagnostic: PAXPR04MB8269:EE_
x-microsoft-antispam-prvs: <PAXPR04MB8269FD42D28F589F8C57D55CE0C59@PAXPR04MB8269.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nRedBhwit8R4ci/KpFl4uQkCNXOKPeWhd2WEJAZv9HrCf2y3ACziKywl7PNrlvctEfi0E8HzWfjuognuzRael5ovKVcrs+wkXSwWxvc/HUZsVnqPwtP9HU5PSsSkXJCdyrSPVf0KJXh+xUnmSs6yr/FWUpYHkKalWaPVdxegC8vRW1yP/Gqmp+V7z3I6EUT52nF4fsuBGpfTut5iuhdKDRyPeOKrH4jJq5RyoACOg5K8zN4YxNTfLfaVpAhP+8pWewCIu0JwQe7TUCVvFyqGPTj4+ibeQjXUgHNdMuMmCIHrJfjwdLHzvNY74ntyaBSNTHdlmBZgrvmfpPdOM9f31yEgocDgTEMNu74ameBkM4QO1Tezn2chF84TaQPqzqj9Ii97JI+srktSh3co4Eq4tjQeDNh4W66b1Ztcu5CJWA+qb4idq9QF/gampFy1SgfVgFQM7rO20tlErgDWwKVBmOo88ZZazSpFCng6x5Djxt195EzCVd2DNRDGtXwmgNDHByKbUZqMXEPjeN0WPcVEpTG1sQeSy49ZzOOxiXJHg+lIDRMupb7nVHFtd4q84BW4FpfUwnvxISEKfTgaFOeNHE0AGNO65kkddzLbIhq6GEao5AJxRuRKmuKeGzokTLOGVBwYI2KyoJMCrAjZYz7NxP3shkx2XETsEKI3DjeGXJl12muxMuJXipqX4iaWQjQ54EpR1aDa9B590NaN4cMvpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(1076003)(38100700002)(8936002)(6486002)(38070700005)(54906003)(71200400001)(6916009)(6512007)(26005)(9686003)(5660300002)(122000001)(44832011)(33716001)(6506007)(86362001)(64756008)(8676002)(4326008)(66446008)(66946007)(2906002)(186003)(66476007)(66556008)(83380400001)(76116006)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kbug1EEX/QtYM7Jzy2FgsiFtJhD1PVYq6G1lLZt2UF21Ig6hYHs8iAobiFzs?=
 =?us-ascii?Q?1BbRdKp2PklSkAm5j5wef6KWZHmPHtCrDGq4GNkzGZ9yGgyAfuM1MJL7fv2n?=
 =?us-ascii?Q?RBs7LzF3gguxq8RIANSje3NKHIMJ0jHEAwVsCbppMIr4AN5o4CiNMTtIa3QA?=
 =?us-ascii?Q?0R3ZmGaD23IoIM/i2LQJfBYQxmTvxBcXPxp+V7ArsYGMHO6sebPHxHwwItnR?=
 =?us-ascii?Q?liTLNIimiFvf3yylBVWg3iU1RDPJ7y8bRdbqPjppSuP8ms/f9p1Lbz3BdgGq?=
 =?us-ascii?Q?Baz1FO5hD7ZigaDu0scAjZKADou8aDepLDiQKkpWGJzEc7Sj6cSOt56iv7o4?=
 =?us-ascii?Q?Fzka6rqiZxyl6YMju/fQLKLQ3qvfl40LOipz12irAUxgMWYRvkLvK7xBcroa?=
 =?us-ascii?Q?xhWcXu7J/2P9Jxrf2IiQabSFUe0LlQ6TLTn30Znp8Tt2XBgbUTqWsZgPIR0F?=
 =?us-ascii?Q?IJfp4ctK2iyImrB7rbmqPbDESEPllpmH+gPdA9lLbS3CLDU9VcYXgd/OEaqv?=
 =?us-ascii?Q?amb6zPRpsVAkgoEgc1y4/qnKmDsa6qU9d+12qO6ys+oL8oSut9te5TI5e7OO?=
 =?us-ascii?Q?hrmS+XsOj4FK0iDxCAj6WLQGJExmYPc0m2P2jqRYaX5p4MdQjJ/NGRCl+wZB?=
 =?us-ascii?Q?2Uhqp3LFcpbKvNzn7+jM8p9MdITfjtDiCve4O8N8U4TEJxqoMMEctxQ1iJ3+?=
 =?us-ascii?Q?tJwqv5IdgxjJR3UV9D7zk+YwWRifsyGRqSMaChu0tKfYcdOlY/qpI5j4V4em?=
 =?us-ascii?Q?udHIvtf4HcTy7lueBQbP2B57q3BKYchpDRPnIT3yLt6sOBLg/YvjD2o94wpv?=
 =?us-ascii?Q?nP4Z4ExdTHGpAyTyRRWNbjhg+YmjobjAB3t92w9BKfPcixorJd/mOmBnAdcl?=
 =?us-ascii?Q?qXcayuvm2g3gWT0BybbnWurUfhyV2OwFH2ywGEVssNDNJFij3Ldu03x6a0Ir?=
 =?us-ascii?Q?/QcXsXUF5zSbhWr0MUiWHqKfAdF67gtx+Ln/vikUAf8tp2yG/10Z6cK5P8qG?=
 =?us-ascii?Q?uB1uF/5n6OmrYk9qOojkGC046LZp/+AV7SbQDvZaDkwhQRYiUQmKutB4Eb5v?=
 =?us-ascii?Q?WfsnS/VDf+gpVscTSGXGNzvmvU35jb3GYZQ4YOY9n8lwGUjpB5MrmnBKotUB?=
 =?us-ascii?Q?KnVSHHlaeHIMJ1FKmPqkUsAIEdvWmlEFb/PwBlAaR6YTWaUxyrvJUmoeTjow?=
 =?us-ascii?Q?305TsK5PEPkFd5f+aFSfJxrF3sIZX0UnTOZqSnYpx7pUd2qz2YnI731HcyU/?=
 =?us-ascii?Q?Mg9EEoWBVNo+JoDuecFvk8yIJ2DmgRWquOBW+lunK+xnUWiMVHK2vxZaN2fq?=
 =?us-ascii?Q?P7DKmO1GzCfaBQlRO2cKytWo60i1RZuHQbpGgHOLa/gdojC/QJVPpnUipsLP?=
 =?us-ascii?Q?Yj8pduhhbPjuXhuXCBWOf1kak+JIvzN9F3x5KV1j4p16E/Lmc3sP6+LyCXy0?=
 =?us-ascii?Q?tiHeBqX0X7H6Y6HTWNNWLlU38yO4i1FmyCTyF1xsDfpSNBZFN4b51LeV0ff6?=
 =?us-ascii?Q?VWNKRe3nGjMJZhtCr7+AsfmGNjIy5bi0xt60hBw9WYg9li3RHeNeC+8pobVP?=
 =?us-ascii?Q?qjXpgvRpv3KCdcvBMwrjMsKqmPyvDiRlBgxD09qXfn3V60rViSSmRIyQGuiR?=
 =?us-ascii?Q?8CQ8T8uQxFnHJWr9h2ZhciWsvOnKeJD3O2hNMMDuQoqQTdw55GqNHq7vTGco?=
 =?us-ascii?Q?LW+35mCzeHVNy250RCl3vyztZ/yGldQgVmkjo9LpQOb6lYaS3OLSaajHztJ/?=
 =?us-ascii?Q?UmfT0krOYqsa9tNYNxw8Ue/ioPcv2VM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECEC713428F14E41B651B9D65089A9B9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6a1d56-f823-413b-fa72-08da2f6dd850
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 14:36:45.3004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b4ks+Fd7GitpAX0pr9G4ND3i1j3djN04NxzqEFjFPu3IfDMmG9VTJnUn/y93oHtNi60EZUbAqbGiW1A8MT48gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8269
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, May 06, 2022 at 12:59:04AM +0200, Andrew Lunn wrote:
> It is possible to stack bridges on top of each other. Consider the
> following which makes use of an Ethernet switch:
>=20
>        br1
>      /    \
>     /      \
>    /        \
>  br0.11    wlan0
>    |
>    br0
>  /  |  \
> p1  p2  p3
>=20
> br0 is offloaded to the switch. Above br0 is a vlan interface, for
> vlan 11. This vlan interface is then a slave of br1. br1 also has
> wireless interface as a slave. This setup trunks wireless lan traffic
> over the copper network inside a VLAN.
>=20
> A frame received on p1 which is passed up to the bridge has the
> skb->offload_fwd_mark flag set to true, indicating it that the switch
> has dealt with forwarding the frame out ports p2 and p3 as
> needed. This flag instructs the software bridge it does not need to
> pass the frame back down again. However, the flag is not getting reset
> when the frame is passed upwards. As a result br1 sees the flag,
> wrongly interprets it, and fails to forward the frame to wlan0.
>=20
> When passing a frame upwards, clear the flag.
>=20
> RFC because i don't know the bridge code well enough if this is the
> correct place to do this, and if there are any side effects, could the
> skb be a clone, etc.

Each skb has its own offload_fwd_mark, so clearing it for this skb does
not affect a clone. And when a packet is simultaneously forwarded and
locally received, the order is first forward/flood it, then receive it.
Cloning takes place during forwarding using deliver_clone(), so it
shouldn't be the case that you are clearing the offload_fwd_mark for a
yet-to-be-forwarded packet, either. So I think we're good there.

>=20
> Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward m=
ark")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/bridge/br_input.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 196417859c4a..9327a5fad1df 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -39,6 +39,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
>  	dev_sw_netstats_rx_add(brdev, skb->len);
> =20
>  	vg =3D br_vlan_group_rcu(br);
> +
> +	/* Reset the offload_fwd_mark because there could be a stacked
> +	 * bridge above, and it should not think this bridge it doing
> +	 * that bridges work forward out its ports.

"this bridge is doing that bridge's work forwarding out its ports"

> +	 */
> +	br_switchdev_frame_unmark(skb);
> +
>  	/* Bridge is just like any other port.  Make sure the
>  	 * packet is allowed except in promisc mode when someone
>  	 * may be running packet capture.
> --=20
> 2.36.0
>

The good thing with this patch is that it avoids conditionals.
The bad thing is that it prevents true offloading of this configuration
from being possible (when "wlan0" is "p4").

I don't know what hardware is capable of doing this, but I think it's
cautious to not exclude it, either.

Some safer alternatives to this patch are based on the idea that we
could ignore skb->offload_fwd_mark coming from an unoffloaded bridge
port (i.e. treat this condition at br1, not at br0). We could:
- clear skb->offload_fwd_mark in br_handle_frame_finish(), if p->hwdom is 0
- change nbp_switchdev_allowed_egress() to return true if cb->src_hwdom =3D=
=3D 0=
