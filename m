Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9C6991D4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBPKkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjBPKkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:40:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30307518F2;
        Thu, 16 Feb 2023 02:39:45 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676543675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UuBL6kmwmBuSZ2ZP6ebJ2zMsiIjued5u/Up36kiGCNY=;
        b=EBQ6jr9Ley19igYWmsUoe6JX88InrFFuZgk7Utu+R5SPdP1h9nEHan1tbM34aD8PsTqfOS
        dAy1mHrnhGGsMKV0uE96N+YHG+fItY2In4s1iTIdy91bR2iV6zAR1sxjpF5oqEishzd5w6
        MMDB8+1m48G6c00R9AyJrzwOARcHdKFom4TYBUFgkP7oAZw51SsChUUg/ea9W3AL96o2ms
        AoN4A5irUhDyB3lbL7jcH1v/T5bwrCpTD+Jh3UTUp+nJ5UrG09dE25H+KlXEH55dZGT1mj
        gLrBiVxrThv+/1AHLiOgdvd071DHOhw3hWhTqVe9Fialuj45umEsCeu9ToMwDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676543675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UuBL6kmwmBuSZ2ZP6ebJ2zMsiIjued5u/Up36kiGCNY=;
        b=/lTwDTPnhoaK+uuoNhbUw/q2HsM8a3K012wUOGOa+mfIli2jCFYiAAWHBuz8+qsG5+2WMf
        9nrY6SXudb7xXkCg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/sched: taprio: dynamic max_sdu larger
 than the max_mtu is unlimited
In-Reply-To: <20230216102914.wat37qsih5xx3wk4@skbuf>
References: <20230215224632.2532685-1-vladimir.oltean@nxp.com>
 <20230215224632.2532685-4-vladimir.oltean@nxp.com> <87cz6aot67.fsf@kurt>
 <20230216102914.wat37qsih5xx3wk4@skbuf>
Date:   Thu, 16 Feb 2023 11:34:33 +0100
Message-ID: <875yc1q4p2.fsf@kurt>
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

On Thu Feb 16 2023, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 10:28:48AM +0100, Kurt Kanzenbach wrote:
>> On Thu Feb 16 2023, Vladimir Oltean wrote:
>> > It makes no sense to keep randomly large max_sdu values, especially if
>> > larger than the device's max_mtu. These are visible in "tc qdisc show".
>> > Such a max_sdu is practically unlimited and will cause no packets for
>> > that traffic class to be dropped on enqueue.
>> >
>> > Just set max_sdu_dynamic to U32_MAX, which in the logic below causes
>> > taprio to save a max_frm_len of U32_MAX and a max_sdu presented to user
>> > space of 0 (unlimited).
>> >
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>=20
>> Doesn't this deserve a Fixes tag as well?
>
> No, I don't think so. It's just so that the user (and later, the offloadi=
ng
> driver) doesn't see arbitrarily large values, just a simplifying 0.

Yes, exactly. It's visible by the user.

> I guess it could potentially make a difference to the software taprio
> data path with TSO, if the max MTU is comparable with the segment
> sizes.
>
> Anyway, with or without the Fixes tag, the patch lands in the same place.

Yup. It doesn't really matter that much.

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPuBrkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgskYD/0Zog5rr3p4qNBwduQ6KPvpiZ08v/US
HBd3+saD7yak+a27mkITUfgagYrQgWNJmMYTTiklKl35upA5/+5LjFDNCCM3neWr
3X9R0FpdAxM42KqaD6chvt5vh8GBwJ5iidDTk/+iaMNDiyta5wrOK8x1x818a+Dp
uJG+SyEexCw8OS2XalovNHQW/xLFtI3U1N9nC9GzX88LDw2qWQ0rkSXFyg7Pdx6t
ZybpezZGDmVD0Hrs86KNBZXoyv/ae4hdCtwmQYOkKQBN9LhFPgZbJZBLbD5l4QH6
Q8XYxP8XYLw9UrJ8/97jYuNtcPalz3w3ir7Xv28iGLcrECMI7Z2fdi2JmPS4FOAk
IgoFet/4ZwK8ugsjnjWb5djP7JgAf0hjM9nNUx4Au0cbQ3ooiYj1ZDVMNHKhtt3P
k1nNO6wViq4bBaIxxg10VL4Q9fHDLnNfM7jS8X16V3zv5oPD4HvooMgb3y3Ece3b
acTbRUFIyxPYsFYD5MzxUmR1+6v5fP6K+WpzaAXi50Gkc13RWbA/aZOhibj/zBSA
BC+DTEUrDEpOMnvAko/+jIPofgH08ekWW6kv359iD9MCMkyDzliosYpQs842Fz3U
ASjYyycqbxA2QbNcVu9D4D5zTyLlG3B49v9M3YRtu5+h65d1Uy0fD8Zo6+r4WcUd
nDlKVPUgtup/DQ==
=XlUA
-----END PGP SIGNATURE-----
--=-=-=--
