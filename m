Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C8241CE2A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344769AbhI2VaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:30:08 -0400
Received: from mail-am6eur05on2067.outbound.protection.outlook.com ([40.107.22.67]:23520
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343505AbhI2VaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 17:30:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gny3qK07eoB2TPEW7dMn9tOcb529a9t73g2epuz03Ho6/n24C1xgzhsQ8/4q7oioS19OHwZDtQlpD8H4eCh6M1aEd4mBQjYt9a/Mha926A+0JwlhT+YXiedjggeam2fhGrRMF/7xEzafenMLAuj67NFz6rFdR3cQbfrrxLthrq4kPI6yTwstZlant13js1ThVgczab8rY0ap4Srn9veA/Mg6JqvFxdD38Na8Vns4pcxJxkGA8+6dYS2HNVofcA+sl7Zg/2m7tc26pngMf2wfaim0BK31/xhu1z70bYuaGoexNhFFNixnwxp9Cmg6y4MqbMXGTHKYYqrc+Tg8Km8GHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KdYY2MDecH6LaTGC9icoqgQ+KIulhAyglSDUyCzqUC4=;
 b=Hq8yjVJ6ncDLAOiMDxl2m3XVCcMIs5wngtd/pfut1awVucgtA3C6yQQ8Zys5N6tzXUbnVIwFSchV/hVY04PyQ/+YUaiKEm/j3AxXNo8sjx/m3ExjJegX8bRDTmZhwfGoJTv+5W8BEaAd7IozPonLiC42XP0uDRAMGajscplSrlgkIfdrwA2ouezv2ZUENroXz84guJh0rZRHgfmoj+2TtlTX17+wwr1Rk2SpmwBd6fWKiPes12pgWcJC8rnbwiR2uSsgEe/mrsSrh+Qeqvmgd8Ncz+E6X8UwkWvwebtRq5cqPZ+2ftw1wqaUwmlHjkXwvZxlcZJDE6mGgpTWYD9yZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdYY2MDecH6LaTGC9icoqgQ+KIulhAyglSDUyCzqUC4=;
 b=jVO8cRdYlYM/vtP0Mqq8pVP7gGC3+3LliFChLwOkZmQVUlm+OMfQ7hf4znpMZBR3C4lY7rTBx6EfaS9yHSa6ETWgWYwb/Rhy8uC+N1+HUD8NsSsyafcx8Mj5bR7Gq1m3duZB2PW+3ruf5oKmqsSoYGFiBzBS40mBmlbEIYWndi0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 21:28:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 21:28:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious
 rcu_dereference_check() with br_vlan_get_pvid_rcu
Thread-Topic: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious
 rcu_dereference_check() with br_vlan_get_pvid_rcu
Thread-Index: AQHXtMHRkOyBlTVFdkqv37BQnrqTO6u7TFKAgAA8BQA=
Date:   Wed, 29 Sep 2021 21:28:22 +0000
Message-ID: <20210929212822.nvu4n2g6xubczwym@skbuf>
References: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
 <20210929175333.GW880162@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20210929175333.GW880162@paulmck-ThinkPad-P17-Gen-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba773838-7dc7-4871-05d2-08d9839010d0
x-ms-traffictypediagnostic: VE1PR04MB7471:
x-microsoft-antispam-prvs: <VE1PR04MB74710968D769DE6173D54FB9E0A99@VE1PR04MB7471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: za2SVuiEIjy7op8wgXzj1goirjFxYAUTrIFbFnNtP27u9l3L8MFc2yGh+TQVy3DfL5YRB+ee2qZanbosbZKSSgZXCBbRtnpACWG1yCPidaZp+iH1QzfqU2u6X7kMUvwrQ0qQ5n4n07yQum6x9tDXcF+N6H198Oej8vPODFNqYCSl1Cc/cdenfcb+iXNmd40O7cZGWp9Y14Dh1vKIzEquZxJlTHraQbEumXjnrOORBSraXWAz9J3YcET7/dZhMTKIZAGOteab6njhz7HnjQP3yC7m1OVfhUDPts8tp8I2n/KJHxw4cCYdhD5MJXi/3qENhTUQWt9gcekUeJp3zscfEHXwUKlqWBG0GsMluHCV6ya1LErB7sLnlnmA42L2gcCnXX3PRm2L6UUsllk2QKzgUZg634pzPImnEc8OVjnaPVwtC4QftJfApxT8mTdQQWqVxocW2SYigGnz0fzxHyz72A2ZJhExI1BGEuoXcaXYsoUMTzo8KOyDD1vSwlfkCd1NrPwId3lmDHAPDbEDFJT0Svh5Bff3Pc5LR8kvQjob7b3MMfO2Mqzr4aRPDyqWa9WjemCBBvxB0Jz20tI597iFGs018BMVanktoe/Cqgqb0K7KHCBbjBpXpBd3TNQf3fQGgrSQkOe41pn/aUTFbjVyKF/tncKCEtcmkZ3aTXTERdi20So1smcUchwrdnWRn9pmmeksPXRyfXo8bCjt8l8Rs/u8My1gTc4nlyKHb+b5juFT2/IPTwkWXnMBN9YlUjYNDz+wesA0DkZwOQq05kbIYZwRGpQyXmfN3ZngPxMoLBo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(38100700002)(33716001)(122000001)(71200400001)(6506007)(5660300002)(44832011)(8936002)(966005)(83380400001)(508600001)(26005)(8676002)(1076003)(7416002)(66556008)(66446008)(66476007)(6486002)(64756008)(91956017)(86362001)(9686003)(316002)(186003)(6916009)(2906002)(6512007)(38070700005)(4326008)(66946007)(76116006)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nk2UUfcqXzB7CTdFoQmtGdUDOIY4hu2gJ3VhdsEhznntBvzFmH6ukr4rgrsy?=
 =?us-ascii?Q?UeJcNUacg2hVaaQwO9uvpqpD6oqh6g5A9w7JOb2xQ2nQ/+l88lRmOi3sSeGN?=
 =?us-ascii?Q?ooHaUDjPR5fjTabkyF/AnYhXyK8QYm54RxusD2R8rtYgoyf01qkemEFCPDzO?=
 =?us-ascii?Q?iw06Fj4YjQFwpSnnIK0ks85Frch78y0n2vBFcjctciVNHUyz2avvzDwINk8W?=
 =?us-ascii?Q?+HzVSu32Ji0L1TFEsdnSQ63GTvHF/c3P9SDEoolXcvObouTsQqT0IYVNev4l?=
 =?us-ascii?Q?TzRh3ogQkfoB8L+ADfEtyIYRpFfzkgkulhqGguoGKSRTGgzlbav1KXF4+znF?=
 =?us-ascii?Q?1EPwwcjcv4gk24ADYf1wF+7wvUxEr6WIyRbOUxOhrbQf5wjZrTzL671UzGda?=
 =?us-ascii?Q?cXMrVSxB+fR8wG+Uua/tMWwKz6TQU8aQ4p7AoV8d9IxkUgaWJ/ZP8gWDiCjw?=
 =?us-ascii?Q?KVDJGhO/bHpgmItST3DvtKJntfVqXg9T3nYhCPw2PTjNqUpxdPFeGL+Ldsgd?=
 =?us-ascii?Q?O8NdEinu6yZ9O5rrIHE86tTHEhTkRv06hsZfQ2v341+oDmmlgTz2wS/DJApz?=
 =?us-ascii?Q?jzjz9q4TFwThMAELGbWfxXlNpqetzQ++ygUl3jGJGOrUf+VFR9coJYYyPUl7?=
 =?us-ascii?Q?dsgeWU7BJmTScoIipqIER4oawMJG6mMl+WQ06H/Nx2IU4UAoMxzE4jX5yw4u?=
 =?us-ascii?Q?VvkYyi8I+gFfaZ3BHQ5dE3/MyrtaOtZO1v6Krl9wy6G0IL9bYx2Tqg/+Xv3e?=
 =?us-ascii?Q?xP57nRVBbl4+McAqFS/8rzUbmgn1oM9fi12VjwGD2dqiG8a98KOWV6Zpc5vd?=
 =?us-ascii?Q?WrJBR9aC802AQDN70cUaED/u38FI7RWz73f5TSOaByz5HrKlJLBvvPexAVCo?=
 =?us-ascii?Q?KGrqYB045DakQsAQ7vF78ltBBJ+jjxFq96gPU7jIdZznDbM4eAQhFP3wHECG?=
 =?us-ascii?Q?EZArq4z3pgiptJHhewhGBFV2wmv9BZtLs8uyPo1hvtbgwYhXm02O5/iZYeO7?=
 =?us-ascii?Q?EIAc+nRs545sjetPbBgcJA8wcemayaTgQTlpDxV5/xQfOdlqABjYF+z56e8H?=
 =?us-ascii?Q?NlDjUIWez99aNXPPbjGCdOZ2LL6rXF91j+mUaFj9YgNP/VNzK6FYbJ/tQi6v?=
 =?us-ascii?Q?aVjBw4TWhGz7CZ5h4g8YhkjrVDnu3su2v8NFca8zehRNq8vpo2no5fFLI9+X?=
 =?us-ascii?Q?mncM0tTCh2P2z2SdaDOPSrcZiKMdBbaBr2gnxKBxMNqZu+aMVLQf+WGzXFO8?=
 =?us-ascii?Q?yrg6cKgfKLvOlyp2U8Sy6fMvOskSxJfD9BGrTuqF7OO41UOqelizyCFxchzy?=
 =?us-ascii?Q?+CNd4Cc5bylQTcQmWbkdbR1s?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <150921E934C216489D0849D8486ABF39@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba773838-7dc7-4871-05d2-08d9839010d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 21:28:22.9723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KQ9IsEh9nEE9FuOFveaCPcbAFvlihDuI1g0Wou92U8mLvByvhElpLXcxCkeBLXIT8xj77zFJ23+T4Bn4IjVc/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 10:53:33AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 29, 2021 at 02:37:08AM +0300, Vladimir Oltean wrote:
> > __dev_queue_xmit(), which is our caller, does run under rcu_read_lock_b=
h(),
> > but in my foolishness I had thought this would be enough to make the
> > access, lockdep complains that rcu_read_lock() is not held.
>=20
> Depending on exactly which primitive is complaining, you can inform
> lockdep of your intentions.  For example, you can change
> rcu_dereference(p) to rcu_dereference_bh(p).  Or you can change:
>=20
> 	list_for_each_entry_rcu(p, &lh, field) {
> 		...
>=20
> To:
>=20
> 	list_for_each_entry_rcu(p, &lh, field, rcu_read_lock_bh_held()) {
> 		...
>=20
> And hlist_for_each_entry_rcu() can also take that same optional
> lockdep parameter.

This is covered by my first option below, basically I don't want to
bloat the Ethernet bridge driver too much with a single user, and that
user being outside the bridge code itself, at that. I'm sure Nikolay and
Roopa would agree :)

The bridge xmit function - br_dev_xmit - takes the rcu_preempt
rcu_read_lock() too. Although I don't think it is very high-overhead in
any incarnation, I think it would be seen as a positive improvement if
it could be removed from that path too (or would it?)

> > Which it isn't - as it turns out, RCU preempt and RCU-bh are two
> > different flavors, and although Paul McKenney has consolidated
> > synchronize_rcu() to wait for both preempt as well as bh read-side
> > critical sections [1], the reader-side API is different, the lockdep
> > maps and keys are different.
> >=20
> > The bridge calls synchronize_rcu() in br_vlan_flush(), and this does
> > wait for our TX fastpath reader of the br_vlan_group_rcu to complete
> > even though it is in an rcu-bh read side section. So even though this i=
s
> > in premise safe, to lockdep this is a case of "who are you? I don't kno=
w
> > you, you're suspicious".
> >=20
> > Side note, I still don't really understand the different RCU flavors.
>=20
> RCU BH was there to handle denial-of-service networking loads.
> Changes over the years to RCU and to softirq have rendered it obsolete.
> But rcu_read_lock_bh() still disables softirq for you.

Thank you, I guess? :)

> RCU Sched provides the original semantics.
>=20
> RCU Preempt, as the name suggests, allows RCU readers to be preempted.
> Of course, if you are using rcu_read_lock_sched() or rcu_read_lock_bh(),
> you are disabling preemption across the critical section.
>=20
> > For example, as far as I can see, the core network stack has never
> > directly called synchronize_rcu_bh, not even once. Just the initial
> > synchronize_kernel(), replaced later with the RCU preempt variant -
> > synchronize_rcu(). Very very long story short, dev_queue_xmit has
> > started calling this exact variant - rcu_read_lock_bh() - since [2], to
> > make dev_deactivate properly wait for network interfaces with
> > NETIF_F_LLTX to finish their dev_queue_xmit(). But that relied on an
> > existing synchronize_rcu(), not synchronize_rcu_bh(). So does this mean
> > that synchronize_net() never really waited for the rcu-bh critical
> > section in dev_queue_xmit to finish? I've no idea.
>=20
> The pre-consolidation Linux kernel v4.16 has these calls to
> synchronize_rcu_bh():
>=20
> drivers/net/team/team.c team_port_disable_netpoll 1094 synchronize_rcu_bh=
();
> drivers/vhost/net.c vhost_net_release 1027 synchronize_rcu_bh();
> net/netfilter/ipset/ip_set_hash_gen.h mtype_resize 667 synchronize_rcu_bh=
();
>=20
> But to your point, nothing in net/core.
>=20
> And for v4.16 kernels build with CONFIG_PREEMPT=3Dy, there is no guarante=
e
> that synchronize_rcu() will wait for a rcu_read_lock_bh() critical
> section.  A CPU in such a critical section could take a scheduling-clock
> interrupt, notice that it was not in an rcu_read_lock() critical section,
> and report a quiescent state, which could well end that grace period.

I find it really hard to believe that commit d4828d85d188
("[NET]: Prevent transmission after dev_deactivate") did not provide the
guarantee it promised. It seems much more likely that I'm missing something=
,
although I don't see what :)

But the team driver, which I did notice, and which you've linked to
above as well, did have a comment which suggested that yes, if you don't
call synchronize_rcu_bh(), you don't really wait for __dev_queue_xmit()
to finish.

> But as you say, in more recent kernels, synchronize_rcu() will indeed
> wait for rcu_read_lock_bh() critical sections.
>=20
> But please be very careful when backporting.

No concerns with backporting, the code in question was added last month
or so.

> > So basically there are multiple options.
> >=20
> > First would be to duplicate br_vlan_get_pvid_rcu() into a new
> > br_vlan_get_pvid_rcu_bh() to appease lockdep for the TX path case. But
> > this function already has another brother, br_vlan_get_pvid(), which is
> > protected by the update-side rtnl_mutex. We don't want to grow the
> > family too big too, especially since br_vlan_get_pvid_rcu_bh() would no=
t
> > be a function used by the bridge at all, just exported by it and used b=
y
> > the DSA layer.
> >=20
> > The option of getting to the bottom of why does __dev_queue_xmit use
> > rcu-bh, and splitting that into local_bh_disable + rcu_read_lock, as it
> > was before [3], might be impractical. There have been 15 years of
> > development since then, and there are lots of code paths that use
> > rcu_dereference_bh() in the TX path. Plus, with the consolidation work
> > done in [1], I'm not even sure what are the practical benefits of rcu-b=
h
> > any longer, if the whole point was for synchronize_rcu() to wait for
> > everything in sight - how can spammy softirqs like networking paint
> > themselves red any longer, and how can certain RCU updaters not wait fo=
r
> > them now, in order to avoid denial of service? It doesn't appear
> > possible from the distance from which I'm looking at the problem.
> > So the effort of converting __dev_queue_xmit from rcu-bh to rcu-preempt
> > would only appear justified if it went together with the complete
> > elimination of rcu-bh. Also, it would appear to be quite a strange and
> > roundabout way to fix a "suspicious RCU usage" lockdep message.
>=20
> The thing to be very careful of is code that might be implicitly assuming
> that it cannot be interrupted by a softirq handler.  This assumption will
> of course be violated by changing rcu_read_lock_bh() to rcu_read_lock().
> The resulting low-probability subtle breakage might be hard to find.

Of course, the networking code would not change functionally with the
removal of rcu_read_lock_bh(). So rcu_read_lock_bh() would be
transformed into local_bh_disable() + rcu_read_lock(). I am still a bit
unclear on the details, but there are reasons why we need softirqs
disabled - we don't call hard_start_xmit just from the NET_TX softirq,
that would be just too nice :)

> > Last, it appears possible to just give lockdep what it wants, and hold
> > an rcu-preempt read-side critical section when calling br_vlan_get_pvid=
_rcu
> > from the TX path. In terms of lines of code and amount of thought neede=
d
> > it is certainly the easiest path forward, even though it incurs a small
> > (negligible) performance overhead (and avoidable, at that). This is wha=
t
> > this patch does, in lack of a deeper understanding of lockdep, RCU or
> > the network transmission process.
> >=20
> > [1] https://lwn.net/Articles/777036/
> > [2] commit d4828d85d188 ("[NET]: Prevent transmission after dev_deactiv=
ate")
> > [3] commit 43da55cbd54e ("[NET]: Do less atomic count changes in dev_qu=
eue_xmit.")
> >=20
> > Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding =
process")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Of course, if no one really needs rcu_read_lock_bh() anymore, I would be
> quite happy to simplify my life by getting rid of it.  ;-)
>=20
> 							Thanx, Paul

The basic idea that updaters could be resilient against softirq storms
sounds great in principle. Although if I understand correctly, that went
away with the consolidation. So again, it isn't that some resiliency
wouldn't be nice, but I'm looking at the current code and I just don't
see what the benefits of rcu_bh are. If the answer is as self-evident as
a naive person like me thinks it is - i.e. rcu_read_lock_bh is just a
glorified version of rcu_read_lock which also disables softirqs, just
with different lockdep rules - then is the consolidation really complete?
Couldn't the bh-disable readers be modified to just open-code the
disabling of softirqs, and resolve the lockdep issues that ensue from
having a separate flavor?

> > ---
> >  net/dsa/tag_dsa.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> > index 77d0ce89ab77..178464cd2bdb 100644
> > --- a/net/dsa/tag_dsa.c
> > +++ b/net/dsa/tag_dsa.c
> > @@ -150,10 +150,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff =
*skb, struct net_device *dev,
> >  		 * that's where the packets ingressed from.
> >  		 */
> >  		if (!br_vlan_enabled(br)) {
> > -			/* Safe because __dev_queue_xmit() runs under
> > -			 * rcu_read_lock_bh()
> > -			 */
> > +			rcu_read_lock();
> >  			err =3D br_vlan_get_pvid_rcu(br, &pvid);
> > +			rcu_read_unlock();
> >  			if (err)
> >  				return NULL;
> >  		}
> > --=20
> > 2.25.1
> > =
