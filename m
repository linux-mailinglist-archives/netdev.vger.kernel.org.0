Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34F7695DF7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBNJEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjBNJEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:04:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA702DBE4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676365390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKyHrrwNK+QpS5/WBVKO6HyV9SisTL++6tU+W3D1oBs=;
        b=VqRNvghfBNdTWpzoMxNPmiCT+5tuZW3X6LuJ2gYHW7SRR624uw1WBR+ugcbd8KAn4bDW9K
        5VV1Wtctn3HKhcpu+hXg3dXrd11r2aygYdbBHGJGKR9okT/Icv7c21j2hmvDzkrAxKUuOF
        V0804YjyoMKY+3InBFd/pw4601sNU50=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-SpfuEl6APLezHymIw4gi3Q-1; Tue, 14 Feb 2023 04:03:09 -0500
X-MC-Unique: SpfuEl6APLezHymIw4gi3Q-1
Received: by mail-qv1-f70.google.com with SMTP id ob12-20020a0562142f8c00b004c6c72bf1d0so8216813qvb.9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mKyHrrwNK+QpS5/WBVKO6HyV9SisTL++6tU+W3D1oBs=;
        b=QigNLRQBEL8WhexScaKvf150U/aEzUppTVLqD39Ig8cktjldBcKZ2R0BeFkEdCMwU/
         tl/4nRA/ZfbTp8IjOQZSyU3ts15Rwl2Qo+LmDoDWrO02aRfy6N4Jb6yEFBsFFqSHURva
         2utjZQ2yoNldG+0nstF/LTPul6TcTCEpVpoZV3VuL68oU3faAjHrgz2U+Xvefvy3KpjP
         ugeTi+10He8uN0/C6PtzHBgqZZIon/6VRvbUIBUEqmhypEcbwJBGS/Ty5cem4nIbyvTw
         EByqx0Rg1IttmRZe3ODwmiB0mWsfjQeDB3CR6lMETylMERtXdaerTcjBvlI0sJWE+LwC
         z+RA==
X-Gm-Message-State: AO0yUKUVahC04E0Vk1xVRneCcKSME4y+hg8ymQ3JCv3yA1hNOR5yj9mR
        XZOV6P9kVXChSQz7ssHS7/cvbYjDKM/HaBlzS/IZgdNNV2q6CYUNcBvWF3x2AYwH8CnCBb3eqE7
        R8DtxTh0Am5unSx02
X-Received: by 2002:a05:622a:60b:b0:3b8:6d44:ca7e with SMTP id z11-20020a05622a060b00b003b86d44ca7emr2899408qta.4.1676365389251;
        Tue, 14 Feb 2023 01:03:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8+30CO0vCQ5vlgILJfb6lGGgEg7rJwCp8b7Gqfs8HWxm8PFRAfyTmK4hy36jyDleq++xqPpw==
X-Received: by 2002:a05:622a:60b:b0:3b8:6d44:ca7e with SMTP id z11-20020a05622a060b00b003b86d44ca7emr2899374qta.4.1676365388918;
        Tue, 14 Feb 2023 01:03:08 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id m16-20020ac866d0000000b003b9bf862c04sm10943546qtp.55.2023.02.14.01.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:03:08 -0800 (PST)
Message-ID: <09051dd20251cd521c253ed8d133301b03d90f9e.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] net/sched: act_connmark: transition to
 percpu stats and rcu
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Date:   Tue, 14 Feb 2023 10:03:05 +0100
In-Reply-To: <20230210202725.446422-3-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
         <20230210202725.446422-3-pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-10 at 17:27 -0300, Pedro Tammela wrote:
> The tc action act_connmark was using shared stats and taking the per
> action lock in the datapath. Improve it by using percpu stats and rcu.
>=20
> perf before:
> - 13.55% tcf_connmark_act
>    - 81.18% _raw_spin_lock
>        80.46% native_queued_spin_lock_slowpath
>=20
> perf after:
> - 3.12% tcf_connmark_act
>=20
> tdc results:
> 1..15
> ok 1 2002 - Add valid connmark action with defaults
> ok 2 56a5 - Add valid connmark action with control pass
> ok 3 7c66 - Add valid connmark action with control drop
> ok 4 a913 - Add valid connmark action with control pipe
> ok 5 bdd8 - Add valid connmark action with control reclassify
> ok 6 b8be - Add valid connmark action with control continue
> ok 7 d8a6 - Add valid connmark action with control jump
> ok 8 aae8 - Add valid connmark action with zone argument
> ok 9 2f0b - Add valid connmark action with invalid zone argument
> ok 10 9305 - Add connmark action with unsupported argument
> ok 11 71ca - Add valid connmark action and replace it
> ok 12 5f8f - Add valid connmark action with cookie
> ok 13 c506 - Replace connmark with invalid goto chain control
> ok 14 6571 - Delete connmark action with valid index
> ok 15 3426 - Delete connmark action with invalid index
>=20
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  include/net/tc_act/tc_connmark.h |   9 ++-
>  net/sched/act_connmark.c         | 109 ++++++++++++++++++++-----------
>  2 files changed, 77 insertions(+), 41 deletions(-)
>=20
> diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_con=
nmark.h
> index 1f4cb477b..e8dd77a96 100644
> --- a/include/net/tc_act/tc_connmark.h
> +++ b/include/net/tc_act/tc_connmark.h
> @@ -4,10 +4,15 @@
> =20
>  #include <net/act_api.h>
> =20
> -struct tcf_connmark_info {
> -	struct tc_action common;
> +struct tcf_connmark_parms {
>  	struct net *net;
>  	u16 zone;
> +	struct rcu_head rcu;
> +};
> +
> +struct tcf_connmark_info {
> +	struct tc_action common;
> +	struct tcf_connmark_parms __rcu *parms;
>  };
> =20
>  #define to_connmark(a) ((struct tcf_connmark_info *)a)
> diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
> index 7e63ff7e3..541e1c556 100644
> --- a/net/sched/act_connmark.c
> +++ b/net/sched/act_connmark.c
> @@ -36,13 +36,15 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff=
 *skb,
>  	struct nf_conntrack_tuple tuple;
>  	enum ip_conntrack_info ctinfo;
>  	struct tcf_connmark_info *ca =3D to_connmark(a);
> +	struct tcf_connmark_parms *parms;
>  	struct nf_conntrack_zone zone;
>  	struct nf_conn *c;
>  	int proto;
> =20
> -	spin_lock(&ca->tcf_lock);
>  	tcf_lastuse_update(&ca->tcf_tm);
> -	bstats_update(&ca->tcf_bstats, skb);
> +	tcf_action_update_bstats(&ca->common, skb);
> +
> +	parms =3D rcu_dereference_bh(ca->parms);
> =20
>  	switch (skb_protocol(skb, true)) {
>  	case htons(ETH_P_IP):
> @@ -64,31 +66,31 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff=
 *skb,
>  	c =3D nf_ct_get(skb, &ctinfo);
>  	if (c) {
>  		skb->mark =3D READ_ONCE(c->mark);
> -		/* using overlimits stats to count how many packets marked */
> -		ca->tcf_qstats.overlimits++;
> -		goto out;
> +		goto count;
>  	}
> =20
> -	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
> -			       proto, ca->net, &tuple))
> +	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, parms->net,
> +			       &tuple))
>  		goto out;
> =20
> -	zone.id =3D ca->zone;
> +	zone.id =3D parms->zone;
>  	zone.dir =3D NF_CT_DEFAULT_ZONE_DIR;
> =20
> -	thash =3D nf_conntrack_find_get(ca->net, &zone, &tuple);
> +	thash =3D nf_conntrack_find_get(parms->net, &zone, &tuple);
>  	if (!thash)
>  		goto out;
> =20
>  	c =3D nf_ct_tuplehash_to_ctrack(thash);
> -	/* using overlimits stats to count how many packets marked */
> -	ca->tcf_qstats.overlimits++;
>  	skb->mark =3D READ_ONCE(c->mark);
>  	nf_ct_put(c);
> =20
> -out:
> +count:
> +	/* using overlimits stats to count how many packets marked */
> +	spin_lock(&ca->tcf_lock);
> +	ca->tcf_qstats.overlimits++;
>  	spin_unlock(&ca->tcf_lock);

I think above you could use tcf_action_inc_overlimit_qstats() and avoid
acquiring the spin lock in most cases.

Side note: it looks like pedit could use a similar change, too - sorry
for missing that point before.

> -	return ca->tcf_action;
> +out:
> +	return READ_ONCE(ca->tcf_action);
>  }
> =20
>  static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] =3D=
 {
> @@ -104,6 +106,7 @@ static int tcf_connmark_init(struct net *net, struct =
nlattr *nla,
>  	struct nlattr *tb[TCA_CONNMARK_MAX + 1];
>  	bool bind =3D flags & TCA_ACT_FLAGS_BIND;
>  	struct tcf_chain *goto_ch =3D NULL;
> +	struct tcf_connmark_parms *nparms, *oparms;
>  	struct tcf_connmark_info *ci;
>  	struct tc_connmark *parm;
>  	int ret =3D 0, err;

Please respect the reverse x-mas tree above.


Thanks,

Paolo

