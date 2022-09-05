Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776CB5AD95C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiIETFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIETFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:05:50 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4347131239
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:05:49 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1662404747; bh=81xDJkqlBtWOjoTc0Yh8oDALTquAaij/49mXC/vyKSo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=CC/C3BXBCZ0dWLO2Db5/RTMZHxf+yc531Hfy+UoJu8oPRObHxoom/CefiMkHmJlYP
         ElmvDmmulhYTw01OyWByT5+qp+0UQsCJbySK1Exo653PGrbsp0RQMa3NxlXtzDIDre
         c9lXGqf+KCQr2EJvxcQbe6LTCqIaXxcZUk5X9vHrXeU1GGv50XydXV5/z95JYoQjJe
         +8CVCZa+1yluD6G0uYa8BQ0xY+2l3e2d7A+HBBcbIxo1Pgz7ebOQ6PTG3NdHEw8xin
         MQWnIdBr5L6NH/MSEmsT9F6ncVcUi6k+oBaSk0NFtWQ9qxsc97xH7X5l1yAVGrE1WC
         aAccV76GgxoMA==
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        zdi-disclosures@trendmicro.com, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] sch_sfb: Don't assume the skb is still around
 after enqueueing to child
In-Reply-To: <YxY4DR8hoMUDgpxu@pop-os.localdomain>
References: <20220831092103.442868-1-toke@toke.dk>
 <20220831215219.499563-1-toke@toke.dk>
 <YxY4DR8hoMUDgpxu@pop-os.localdomain>
Date:   Mon, 05 Sep 2022 21:05:47 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87k06hzlo4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Aug 31, 2022 at 11:52:18PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> The sch_sfb enqueue() routine assumes the skb is still alive after it has
>> been enqueued into a child qdisc, using the data in the skb cb field in =
the
>> increment_qlen() routine after enqueue. However, the skb may in fact have
>> been freed, causing a use-after-free in this case. In particular, this
>> happens if sch_cake is used as a child of sfb, and the GSO splitting mode
>> of CAKE is enabled (in which case the skb will be split into segments and
>> the original skb freed).
>>=20
>> Fix this by copying the sfb cb data to the stack before enqueueing the s=
kb,
>> and using this stack copy in increment_qlen() instead of the skb pointer
>> itself.
>>=20
>
> I am not sure if I understand this correctly, but clearly there is
> another use of skb right before increment_qlen()... See line 406 below:
>
> 402 enqueue:
> 403         memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
> 404         ret =3D qdisc_enqueue(skb, child, to_free);
> 405         if (likely(ret =3D=3D NET_XMIT_SUCCESS)) {
> 406                 qdisc_qstats_backlog_inc(sch, skb);  // <=3D=3D HERE
> 407                 sch->q.qlen++;
> 408                 increment_qlen(&cb, q);
>
> It also uses skb->cb actually... You probably want to save qdisc_pkt_len(=
skb)
> too.

Ah, oops, didn't realise qdisc_pkt_len() also used the cb field; will
send another follow-up, thanks for spotting this!

-Toke
