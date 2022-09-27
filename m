Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211565EB63A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiI0AXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiI0AW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:22:57 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50069.outbound.protection.outlook.com [40.107.5.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C472EA570A;
        Mon, 26 Sep 2022 17:22:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/AozpzGjqGCqPiw5y/7Hzp0wu/bcp9rneCX/2eXTS3sBzimhg25VS+6So6yW+42VKnJN/2IPY6Otv59kmUzzPp1vCS0nHCg8804XT7Tond0Q+tJCjwQDaKjXKgmloSukCt4Bw11tZW65fRzPic7Dq4YIkHl42r8Sl6CgOWdtaKI+r7oUmZvgoAl3ALJeLcaRv04IQ9WK776/gzUj3jGjlXV+oLed2GJCOurDveuN9cxI7JMbwIWjo00yMQEMxGBC9Ug4rv/QWRas6YHVA0bCv+J/cmLgScs4Fd0PHFfNje4MG8bFQG6NMlPeRGIQnyHLIc8o8Bw/K+GDfP38+WekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRLDxIgdkM3W0Gn8gBe2VWX5Hs5dLJjFS8Pw+r3aAmE=;
 b=N8b+DZYNXzj4EvR3rVTri03uhC7sSLks7gq0DDWAIj5T6ZeYA+btZ8DjVQO0WUxtuxeVhETO04c5QIlqLXcTwTT6dP32YnB4+G19/qSbusdTzPK1Ws1c0wdoxIQS+KzG4ysMHLF7KokMCMC0f9+I0aVvPfkQAnk7fKWPvQERINaHIxRrKWq25smpmIdtAvIYBDcFX1/RQ0GT8iSlhnOnNTv8B6Odr3gzouTKDSQ8ASCC9ds6aSd46rW6nSvv3JGNQgdq3jItXDG9SLeX3ix/OiTYFqYLdOOoBUDTWpYtyxAqAj4So3mYJ+4XsdEsWJAiMA7nItTtkAy9R0kKHV1ulA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRLDxIgdkM3W0Gn8gBe2VWX5Hs5dLJjFS8Pw+r3aAmE=;
 b=LbbRVDZqhDCMCG+8/hcdJVJBi6MV9MZkOrzf38U/Vq0+JZmf45hQEjOIPShwbWNygBuG8D/2VX0eNDQOkZWAp9JPttORoWx7r/vq/PR20FeP0Ig7a8CP1FZhRui/YutqI3FTeirfph+XpiQjd6px/CDzL/U9XZBX8/PY4UbNCMQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9390.eurprd04.prod.outlook.com (2603:10a6:102:2a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 00:22:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 00:22:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to per-tc
 max SDU
Thread-Topic: [PATCH v2 net-next 02/12] tsnep: deny tc-taprio changes to
 per-tc max SDU
Thread-Index: AQHYz2o2kMm9MIsgNk2AWROGsQgg9q3yMZSAgAATq4CAABuYAIAADuQA
Date:   Tue, 27 Sep 2022 00:22:53 +0000
Message-ID: <20220927002252.mwrxp3wicew3vz6p@skbuf>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
 <20220923163310.3192733-3-vladimir.oltean@nxp.com>
 <20220926134025.5c438a76@kernel.org> <20220926215049.ndvn4ocfvkskzel4@skbuf>
 <20220926162934.58bf38a6@kernel.org>
In-Reply-To: <20220926162934.58bf38a6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB9390:EE_
x-ms-office365-filtering-correlation-id: 412d391a-d7a7-491e-745a-08daa01e6b33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xrxhPa5Mtff9tWGEbofovBvPJoz+MECi6KeLolSS1LhZxL/1wWpoYpB+bGQzKSPqu1AMfEsakhFAu+zBNRLx9R6xvBrTs/WYP1DFaQL2ckeIh2YLjsIuw4Ub1mkk7fqZ+i/Ss4ej/eWz1txP5mmveEneyHdjTTYB8At8qG++iMivLsmldg5HsfbSqzoCbNGIDUwvTr3n97PrkDlPpMze4nrXN3b3qh3SjfJWDvkqorioHshqMldzUGXj7a9L2TaRa+0tsAVOG0zzmt6+YWESv7HdHdCcCMjgh1EBKXxIctSFqKCNdcGYsQn2FSckgXGa8xGmhJm0FzTdTe88T1vYMfZZlIKR4GHUgwFUM14XaVf6nC90bT0Y9ABVh5OwOt4nXsJXoRGmd+YTQfU15dErShX3cJta+h5kTTREtBphAwR0FUZObkd8gDI3pkiqRS8Bsz2Bv78tmKJhteHmSw8CRR1Xkq4pGm0PUpp9tQym2cBKIlT4JYrc1hza3QNpYITh+kKTvif4Yo+DzMSPJNdg6KCqSt4vB7YjnPt4VEEnizd+zR+VwXu11ek3XwO4yPa50LRN1Pf7pYi7kCdpc2LE9YpJMGbCuHhyG8QgJQjtZzYPPk2rG37z18pI9uDTDUNANmQJLScpbCtCmODzTzzG/gh990QeHHWuWDkJ9ewpgwwyTgnghXOqU5noa8IG6tE06llXZ3PcluJWysmPlsoaYbSMFCvoxZs6iyJk29vJXLfciHsT0++NH7ZxbYjQijyB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199015)(122000001)(2906002)(7416002)(66946007)(83380400001)(6506007)(41300700001)(91956017)(76116006)(6512007)(9686003)(478600001)(5660300002)(44832011)(38100700002)(8936002)(71200400001)(6486002)(26005)(38070700005)(186003)(1076003)(6916009)(54906003)(86362001)(66556008)(64756008)(8676002)(66476007)(4326008)(66446008)(33716001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f8chh9IJWiEHNA5CFbr8Rv0X/YAZ++7lUHYTMWs2DYIuRjORz9uCjohKZd+d?=
 =?us-ascii?Q?JI4KSaTOsJsr3azyKknKxbHSZuAp1PcnHsL8GMdhBi4qCGF0Ut25j7/LOI4p?=
 =?us-ascii?Q?ht4V/HItuf4IyebDnNVm0Q94HwkpQdutK6FTO/MJWN4CbFyU0V0Hzis2nEIt?=
 =?us-ascii?Q?zta8raBAeTni1YO9NE8DcIwm1J8iVqSLg4LLJqUwb9Sj8zr12ocRPX7fpThN?=
 =?us-ascii?Q?QnjnKslvTgtrBbJWvtE+Ecau+fuiMVFrviMDZx81fP8bBBnEpPqWrG7t7EeW?=
 =?us-ascii?Q?vaL6SUpbU0IFWxjL4pHv+WmR/xF3KdaxT2y7OEXZtqHLPx8SSw0staERegzX?=
 =?us-ascii?Q?qal/GR/zvP1Yi1DD7sUGIeya4mbPcGXV7By1PE0FAr+0iPpfuq7YObR7HB/9?=
 =?us-ascii?Q?r+uteQ8nCNvkwGH12RRkLskMXxsO+h8OdJXKVIrW2ina2NFYN6KQ6WxM7pPl?=
 =?us-ascii?Q?ENMc5z244td6GihkRAMdQx1AhdweOyWhTnd5URhDldPlCvmM7BgjTTULK0VH?=
 =?us-ascii?Q?G0ml2tG5kofVAAa1UamfLhi16SesUKKU3RB82YION01+UdNT8VEbGil9xvQ/?=
 =?us-ascii?Q?va5VWBIYPcBDjgorql9F6vPXWRTN5UoYnAWt2YNylKCTLXeMHfilaLBb1WvR?=
 =?us-ascii?Q?YKnhzDC0SyLISIVh1xIxSUKKcvIHS59I5WvqrJdmk9gGwkbQefzgRcA83sAY?=
 =?us-ascii?Q?vBcjmIbm7Rnyeyz2lzCE7FueLrFQ6Tx0nPJ5XpiOKoNcSVXhJbbeT8K2HJlC?=
 =?us-ascii?Q?C7nmD7w5a1rnbA1v5g++tEkO/fGhsuJlyK7bXXJ5rQzBjt+jihlYZQ6C2v4P?=
 =?us-ascii?Q?bL8ztDo6BMG0BFn1h58WJzA1qB1r7VCyq3aVSJMr/dHxbmRRg240CrCoSlVe?=
 =?us-ascii?Q?Hw0w7VQ+F11twByjvpUnfW9hO81ceREY0amjcqTJWWhc2jvsDYByQ5q7I68Y?=
 =?us-ascii?Q?UsmybwKkL2EEWnn+9OSmZd0aqpsm78DeuqO9kzf91LcKlPQDSPfC926c2g8J?=
 =?us-ascii?Q?kmazfBZUC0ZM6lDr6cBeoW5D9XTooxtv6s0fTQwzUHrJU3mXh2Ll6Y2smE/m?=
 =?us-ascii?Q?GTmhQHap6ZWAjxoTg21W9Wz9iKwBqiAzdNlitdrmHagVw7c/FMe5bhrXJ3kq?=
 =?us-ascii?Q?AxU+b+rpct0woufKcCuFCwKCETVXT8wT77dF7ZeJ09Zv6rd+3OrKTtBBnsq0?=
 =?us-ascii?Q?pxz1ZODd4t6J75Ba3iEERjNVEfX8QRtKaSQvNIo9npH44Z8ojAVqbA07owb6?=
 =?us-ascii?Q?tcDuPc5XTfseIFCSSyYkZkHHKYzPa3f2ACmub2zGi7ofKqWk8/iFfIt6YbWC?=
 =?us-ascii?Q?lgqiIRsjLnNNJKD3tvIFDorVcUZGXgnvpRre/PNtZnvZkY/HNKBVoYlAOMMl?=
 =?us-ascii?Q?+EapafxS03Z4nb68gfNj2M93Lfqh2P/eP2NRR2b4AGgwuqwfqxrEfwW44XeF?=
 =?us-ascii?Q?Ria+14FI1vS7fyuTyGnwdDubGTeQ9d8p65277PQh6p0rlhrUHCOr85yXkaO4?=
 =?us-ascii?Q?m4z5nzIjGS8Ni4lw7hq7Cdpg0C/1+MIT5c09YbfXLTME+Zu/mfbgApBwcMIH?=
 =?us-ascii?Q?vXDK1KxmnxT95lxrBPaccy77hGy2Syaqz3X6GONn1NgpCp239z9D8dTss69Y?=
 =?us-ascii?Q?Ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EF9E1C2E0EB1048BB9860DF7E06A975@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412d391a-d7a7-491e-745a-08daa01e6b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 00:22:53.4187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZ5kSprkjraWusVcq8qi0OM1Mu1bLzLsKWk0DWAJo1aVV62e29sU23WCIZDic2SQYqwBEMjpEQcAW8JbjwgrtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9390
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 04:29:34PM -0700, Jakub Kicinski wrote:
> I usually put a capability field into the ops themselves.

Do you also have an example for the 'usual' manner?

> But since tc offloads don't have real ops (heh) we need to do the
> command callback thing. This is my knee-jerk coding of something:
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9f42fc871c3b..2d043def76d8 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -960,6 +960,11 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
>  	TC_SETUP_ACT,
> +	TC_QUERY_CAPS,
> +};
> +
> +struct tc_query_caps {
> +	u32 cmd;

actually s/u32/enum tc_setup_type/

inception....

>  };

> Right, but that's what's in the tree _now_. Experience teaches that
> people may have out of tree code which implements TAPRIO and may send
> it for upstream review without as much as testing it against net-next :(
> As time passes and our memories fade the chances we'd catch such code
> when posted upstream go down, perhaps from high to medium but still,
> the explicit opt-in is more foolproof.

You also need to see the flip side. You're making code more self-maintainab=
le
by adding bureaucracy to the run time itself. Whereas things could have
been sorted out between the qdisc and the driver in just one ndo_setup_tc()
call via the straightforward approach (every driver rejects what it
doesn't like), now you need two calls for the normal case when the
driver will accept a valid configuration.

I get the point and I think this won't probably make a big difference
for a slow path like qdisc offload (at least it won't for me), but from
an API perspective, once the mechanism will go in, it will become quite
ossified, so it's best to ask some questions about it now.

Like for example you're funneling the caps through ndo_setup_tc(), which
has these comments in its description:

 * int (*ndo_setup_tc)(struct net_device *dev, enum tc_setup_type type,
 *		       void *type_data);
 *	Called to setup any 'tc' scheduler, classifier or action on @dev.
 *	This is always called from the stack with the rtnl lock held and netif
 *	tx queues stopped. This allows the netdevice to perform queue
 *	management safely.

Do we need to offer guarantees of rtnl lock and stopped TX queues to a
function which just queries capabilities (and likely doesn't need them),
or would it be better to devise a new ndo? Generally, when you have a
separate method to query caps vs to actually do the work, different
calling contexts is generally the justification to do that, as opposed
to piggy-backing the caps that the driver acted upon through the same
struct tc_taprio_qopt_offload.=
