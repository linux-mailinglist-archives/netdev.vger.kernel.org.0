Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01002579670
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiGSJge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiGSJgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:36:33 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EBF10571
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:36:32 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id j67so2873340ybb.3
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcODNYrp+VKkOtbBUD23HLsfyp2gv6gQrx0DgI07j10=;
        b=Zw7PrFKfP+/4qoL4plmuh+Ti44dlIeOdjEROXu/pO4UbBi70en+R4pYSONQpWhE03u
         Sc0Y2E2GEq1P7l8zJvfNyHS7ZJtjSnLByG43SbwQZ3pNzBF/ROWZvz0hrYlgdgD8Cl2Y
         Ez29bVQSZyegjrIAsyoqicMAHSsclmeETDayc1WJZvXFZAp1CQ9Zbg8X0FE35WgF9Xc2
         qfGcmLC9kRCbBjNulWYzZkwDfTHvi61NkFLLR1pUlPEe+Lyw8I7J3BnQBj7iOUOtIK91
         CZsLyScvAuoBurN7GSExxuRy77xhAvnRVusD1Byw3M3f0niKxQEHzdNTLEIqn02VrPI6
         26wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcODNYrp+VKkOtbBUD23HLsfyp2gv6gQrx0DgI07j10=;
        b=WEUmZ5zxRCexUkC1dZLfzTc3R2cIjJti4PdOtyS+ZcnhOTwwl+CtQE5AE/x4bGbHk/
         xFlBfmftDpw04mkspvV8GX979G5+4Ll7U6lXTeG1HJN5Ir7k/LC2WqsnX6KKqoFdhQvk
         OH0e6lyPnnlV4dnM77oVJlRMRg+JEnGXWq407y0z5AzwouX58tdFhsa5m8aAnXjJqA9f
         yhmAzUkq3T4qvMBczPwP2JmZ1oUpaAza4gv0nS0+XLY5mjWbyD9UQcolunZx8hdN88PG
         P2RvD20yvhHdlI5WIVbrLb35MQcW+533EaqoCixjm0bqpMwXRcAHP6QJToERgbmbO8eX
         HQsQ==
X-Gm-Message-State: AJIora+t5ZoFZm2zMh1mafDcVCbBQJWJjwAZ3XM6mqjC9EtPkhyAtdrn
        sEVkyLqznfe3npQ418wuf/IBPbN2XCr/scIEuZONZA==
X-Google-Smtp-Source: AGRyM1si3SKO3wIMa+R+kcy/+WJDzrsNzoE8pPQ+7zS9An7yZtN8WYu8iaNk1Ei/jx7GFw7xmt79YbWY5UV/CF7/LPs=
X-Received: by 2002:a05:6902:120c:b0:66e:fbad:39de with SMTP id
 s12-20020a056902120c00b0066efbad39demr30443605ybu.388.1658223392022; Tue, 19
 Jul 2022 02:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1657643355.git.asml.silence@gmail.com> <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657643355.git.asml.silence@gmail.com>
 <20220718185413.0f393c91@kernel.org>
In-Reply-To: <20220718185413.0f393c91@kernel.org>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 19 Jul 2022 11:35:54 +0200
Message-ID: <CA+FuTSf0+cJ9_N_xrHmCGX_KoVCWcE0YQBdtgEkzGvcLMSv7Qw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 01/27] ipv4: avoid partial copy for zc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 3:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 12 Jul 2022 21:52:25 +0100 Pavel Begunkov wrote:
> > Even when zerocopy transmission is requested and possible,
> > __ip_append_data() will still copy a small chunk of data just because it
> > allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
> > on copy and iter manipulations and also misalignes potentially aligned
> > data. Avoid such coies. And as a bonus we can allocate smaller skb.
>
> s/coies/copies/ can fix when applying
>
> >
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  net/ipv4/ip_output.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index 00b4bf26fd93..581d1e233260 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -969,7 +969,6 @@ static int __ip_append_data(struct sock *sk,
> >       struct inet_sock *inet = inet_sk(sk);
> >       struct ubuf_info *uarg = NULL;
> >       struct sk_buff *skb;
> > -
> >       struct ip_options *opt = cork->opt;
> >       int hh_len;
> >       int exthdrlen;
> > @@ -977,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
> >       int copy;
> >       int err;
> >       int offset = 0;
> > +     bool zc = false;
> >       unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
> >       int csummode = CHECKSUM_NONE;
> >       struct rtable *rt = (struct rtable *)cork->dst;
> > @@ -1025,6 +1025,7 @@ static int __ip_append_data(struct sock *sk,
> >               if (rt->dst.dev->features & NETIF_F_SG &&
> >                   csummode == CHECKSUM_PARTIAL) {
> >                       paged = true;
> > +                     zc = true;
> >               } else {
> >                       uarg->zerocopy = 0;
> >                       skb_zcopy_set(skb, uarg, &extra_uref);
> > @@ -1091,9 +1092,12 @@ static int __ip_append_data(struct sock *sk,
> >                                (fraglen + alloc_extra < SKB_MAX_ALLOC ||
> >                                 !(rt->dst.dev->features & NETIF_F_SG)))
> >                               alloclen = fraglen;
> > -                     else {
> > +                     else if (!zc) {
> >                               alloclen = min_t(int, fraglen, MAX_HEADER);
>
> Willem, I think this came in with your GSO work, is there a reason we
> use MAX_HEADER here? I thought MAX_HEADER is for headers (i.e. more or
> less to be reserved) not for the min amount of data to be included.
>
> I wanna make sure we're not missing something about GSO here.
>
> Otherwise I don't think we need the extra branch but that can
> be a follow up.

The change was introduced for UDP GSO, to avoid copying most payload
on software segmentation:

"
commit 15e36f5b8e982debe43e425d2e12d34e022d51e9
Author: Willem de Bruijn <willemb@google.com>
Date:   Thu Apr 26 13:42:19 2018 -0400

    udp: paged allocation with gso

    When sending large datagrams that are later segmented, store data in
    page frags to avoid copying from linear in skb_segment.
"

and in code

-                       else
-                               alloclen = datalen + fragheaderlen;
+                       else if (!paged)
+                               alloclen = fraglen;
+                       else {
+                               alloclen = min_t(int, fraglen, MAX_HEADER);
+                               pagedlen = fraglen - alloclen;
+                       }


MAX_HEADER was a short-hand for the exact header length. "alloclen =
fragheaderlen + transhdrlen;" is probably a better choice indeed.

Whether with branch or without, the same change needs to be made to
__ip6_append_data, just as in the referenced commit. Let's keep the
stacks in sync.

This is tricky code. If in doubt, run the msg_zerocopy and udp_gso
tests from tools/testing/selftests/net, ideally with KASAN.
