Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703DC4F45FB
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiDET7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 15:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573403AbiDETHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:07:33 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7BDFD76;
        Tue,  5 Apr 2022 12:05:33 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1649185531; bh=SAA9dfx55MysOmiQzcHDMnPsN4/x681hTalOLovhpPE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SBHOSgcXwcMafMQKThYaJOM7QfgUspeVO8YsgV+jXTp14qIw7kLMTjpP/4HI0J1XC
         uH6ZeKg5K2t8Hn4E/zDhjQa01z01Cxs7lBNar6GXKpAHN/V0TNRvoIqCH7gvVLGDA7
         g1K6/cIXTPUb4jkXy9TONf0QPYnMRjWNwI0LPb7paU3M97Dkv90mS6kKzhIASYuokC
         tMJ94WaRh08SGM7JE+rgNNDwL2exRtl/f6uGuCej3eX3u/oReRMeuOFItgCL3Tx5XI
         c1OACToIa5uv2vxHIK3XaSPc+VR3d9f8fql3DbAniQH31fOFjazzsLw7jjds3a+dP8
         wgD6ZMPyI00UA==
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the
 rate list end tag
In-Reply-To: <20220404225212.2876091a@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
 <87ilroemo4.fsf@toke.dk> <20220404225212.2876091a@gmx.net>
Date:   Tue, 05 Apr 2022 21:05:31 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8vncpvo.fsf@toke.dk>
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

Peter Seiderer <ps.report@gmx.net> writes:

> Hello Toke,
>
> On Mon, 04 Apr 2022 20:19:39 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@toke.dk> wrote:
>
>> Peter Seiderer <ps.report@gmx.net> writes:
>>=20
>> > Stop reading (and copying) from ieee80211_tx_rate to ath_tx_info.rates
>> > after list end tag (count =3D=3D 0, idx < 0), prevents copying of garb=
age
>> > to card registers.=20=20
>>=20
>> In the normal case I don't think this patch does anything, since any
>> invalid rate entries will already be skipped (just one at a time instead
>> of all at once). So this comment is a bit misleading.
>
> Save some (minimal) compute time? Found it something misleading while
> debugging to see random values written out to the card and found this
> comment in net/mac80211/rate.c:
>
>  648                 /*
>  649                  * make sure there's no valid rate following
>  650                  * an invalid one, just in case drivers don't
>  651                  * take the API seriously to stop at -1.
>  652                  */
>
> and multiple places doing the same check (count =3D=3D 0, idx < 0) for va=
lidation
> e.g.:
>
>  723                 if (i < ARRAY_SIZE(info->control.rates) &&
>  724                     info->control.rates[i].idx >=3D 0 &&
>  725                     info->control.rates[i].count) {
>
> or=20
>
>  742                 if (rates[i].idx < 0 || !rates[i].count)
>  743                         break;
>
>>=20
>> Also, Minstrel could in principle produce a rate sequence where the
>> indexes are all positive, but there's one in the middle with a count of
>> 0, couldn't it? With this patch, the last entries of such a sequence
>> would now be skipped...
>
> According to net/mac80211/rc80211_minstrel_ht.c:
>
> 1128 static bool
> 1129 minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct minstrel_h=
t_sta *     mi,
> 1130                          struct ieee80211_tx_rate *rate)
> 1131 {
> 1132         int i;
> 1133=20
> 1134         if (rate->idx < 0)
> 1135                 return false;
> 1136=20
> 1137         if (!rate->count)
> 1138                 return false;
> 1139=20
>
> minstrel although evaluates a rate count of zero as invalid...

So my concern was mostly that the documentation (in mac80211.h) says
that an idx of -1 indicates the end, but says nothing about the count.
Which implies that in principle you could have a rate table of { idx,
count } like { 1, 1 }, { 2, 0 }, { 3, 1 } which would mean all three
rates was valid but the second one would just be "skipped" due to a
count of zero.

But it seems that the code populating the rate table that you linked
above (lines 742/743) actually do abort on either condition, so I guess
it's safe to do so in the driver as well...

-Toke
