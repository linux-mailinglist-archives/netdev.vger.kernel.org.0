Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1426B69F60D
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjBVODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBVODJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:03:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAD21D92B;
        Wed, 22 Feb 2023 06:03:08 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677074585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hh6CS8qKUrPHMn/iWoZ8r5ZGcNwlXhMeO8uYUYMXcp8=;
        b=njTt9NYq2UkXjEvv/iTHiJZuCTZwmtbNID9BGGOd2BB2HVa5PBG65mNPI746nxpK4sgwFh
        w6TkeNMwZOUXXvI3tYJJSXKb7EMM/1Xc0Ai4mYRA2NBT/89Zw0FYyY/Vg7JVh/aWB0YlHG
        Hw3yGbo7HtLMoFgA/RyZH5CxYsmFJ2M+o0ZsXRmEtDNemhFyS40ewMkJWe5XFYcs2A0pMU
        iJYt/SgoXuDRKrG2SECPMbn1ixKqviz/jImmUyJTcv68vjeqsc561iBP8qtlDKlc2ppveZ
        bIbprj0xQpNiqjIqx1hsyexY6ys+tUxvfZ4oHOjw++pUpuN8uGwuz6xzagYbbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677074585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hh6CS8qKUrPHMn/iWoZ8r5ZGcNwlXhMeO8uYUYMXcp8=;
        b=Wc8QvhRRh7UNaSixqqG4puaiJrokuOBJjxW+w3ten2kLzqIGqDHXccLaHy9p7XGS3ogwK6
        y9K8CRjNBwC1XICg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs
In-Reply-To: <20220915100802.2308279-3-vladimir.oltean@nxp.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-3-vladimir.oltean@nxp.com>
Date:   Wed, 22 Feb 2023 15:03:04 +0100
Message-ID: <874jrdvluv.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

On Thu Sep 15 2022, Vladimir Oltean wrote:
> taprio can only operate as root qdisc, and to that end, there exists the
> following check in taprio_init(), just as in mqprio:
>
> 	if (sch->parent !=3D TC_H_ROOT)
> 		return -EOPNOTSUPP;
>
> And indeed, when we try to attach taprio to an mqprio child, it fails as
> expected:
>
> $ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> $ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
> Error: sch_taprio: Can only be attached as root qdisc.
>
> (extack message added by me)
>
> But when we try to attach a taprio child to a taprio root qdisc,
> surprisingly it doesn't fail:
>
> $ tc qdisc replace dev swp0 root handle 1: taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
> $ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
>
> This is because tc_modify_qdisc() behaves differently when mqprio is
> root, vs when taprio is root.
>
> In the mqprio case, it finds the parent qdisc through
> p =3D qdisc_lookup(dev, TC_H_MAJ(clid)), and then the child qdisc through
> q =3D qdisc_leaf(p, clid). This leaf qdisc q has handle 0, so it is
> ignored according to the comment right below ("It may be default qdisc,
> ignore it"). As a result, tc_modify_qdisc() goes through the
> qdisc_create() code path, and this gives taprio_init() a chance to check
> for sch_parent !=3D TC_H_ROOT and error out.
>
> Whereas in the taprio case, the returned q =3D qdisc_leaf(p, clid) is
> different. It is not the default qdisc created for each netdev queue
> (both taprio and mqprio call qdisc_create_dflt() and keep them in
> a private q->qdiscs[], or priv->qdiscs[], respectively). Instead, taprio
> makes qdisc_leaf() return the _root_ qdisc, aka itself.
>
> When taprio does that, tc_modify_qdisc() goes through the qdisc_change()
> code path, because the qdisc layer never finds out about the child qdisc
> of the root. And through the ->change() ops, taprio has no reason to
> check whether its parent is root or not, just through ->init(), which is
> not called.
>
> The problem is the taprio_leaf() implementation. Even though code wise,
> it does the exact same thing as mqprio_leaf() which it is copied from,
> it works with different input data. This is because mqprio does not
> attach itself (the root) to each device TX queue, but one of the default
> qdiscs from its private array.
>
> In fact, since commit 13511704f8d7 ("net: taprio offload: enforce qdisc
> to netdev queue mapping"), taprio does this too, but just for the full
> offload case. So if we tried to attach a taprio child to a fully
> offloaded taprio root qdisc, it would properly fail too; just not to a
> software root taprio.
>
> To fix the problem, stop looking at the Qdisc that's attached to the TX
> queue, and instead, always return the default qdiscs that we've
> allocated (and to which we privately enqueue and dequeue, in software
> scheduling mode).
>
> Since Qdisc_class_ops :: leaf  is only called from tc_modify_qdisc(),
> the risk of unforeseen side effects introduced by this change is
> minimal.
>
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This commit was backported to v5.15-LTS which results in NULL pointer
dereferences e.g., when attaching an ETF child qdisc to taprio.

From=20what I can see is, that the issue was reported back then and this
commit was reverted [1]. However, the revert didn't make it into
v5.15-LTS? Is there a reason for it? I'm testing 5.15.94-rt59 here.

Thanks,
Kurt

[1] - https://lore.kernel.org/all/20221004220100.1650558-1-vladimir.oltean@=
nxp.com/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmP2IJgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgh66D/9EOgu+l1QTGKaS9GE+386iD4FBb7Q6
KFx7dJBmTYD3C7vJ1pVk7aYyNmTiRA5YA41c3Qdl4X1KgruVLUoEZ5kCJLyEbbCZ
YJfkbGAJDskyu6tumJ3JMnnCEBr6qgorh5OD7okQytlR3dk0yxFkYD/Wh+LB069f
GF7QOv7tB6qfbW9w00K4zY3zMiQrDKE3O0tSUA9EgsA3EiRtM9XP2OlQ1/aq2BAX
0+HYrq7Dhokj/7pCQxKoLmCxkD/1jXF0WXnSvFWlsMTfytYNhAYyaMVcZEEfltD7
UExThY/ujT+fGx819mSvOf8Kt0AKgbeNw+nDi4fHnX6hFVbH223MbAoQv3tFQNCD
Lv8IykI3jns2evnPog2MvYY25QP1IJYFJHzLZqdCOIEnT+yZJ8pQ3cNDtN0D1cRo
xvU53POWCH2dEH1n3eiEMFBniYsLpR4TsRM2HDkCfi8UvBjxXTLbWLW7MxzUYasw
cNIaov0N52mdUDG2RCcjdkUkJCcKDg0878K/o1Cm9ahh+QG87mPFrwH5H0JQ1yls
f9ScDR57jUwCyB1quEbGzbPSCQ0JEOOd10VNuuvZfLhQcf8OlWNb9+d8MTFM/zv+
oXsFSR9gVtUA/m5D0THaRVm4gW0620XAK9aJ12DoTZLdWB4vp5uhOWWMdDpd2XHv
CUWl3IZaz9luFw==
=Bqsh
-----END PGP SIGNATURE-----
--=-=-=--
