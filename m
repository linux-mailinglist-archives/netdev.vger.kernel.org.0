Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41F5683465
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjAaR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjAaR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:57:17 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081C06A46
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:57:16 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id d132so19178882ybb.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GG8/kT0PKwqWP3AvSWmrhBSKsdjFhFnl36yGJFNM3fg=;
        b=LoEJyeRKXVaDA3jB5BkGvy1teJGGh0e0Ywen6onFL+nR+So1lE66eOtPUpkVHVNyKW
         uyqQ3eRPcGXbMiZNEa5QxhVmjJHXl9nxhs8py0nTcvwXy0h71zTqC06khUYb17HEu4U+
         lnqbbtQxkVJBCDwfgW2L18cMhK8MEo/XQ3rKYo/vGqoGFOAJojRsrQf5F9p0zUoz1wtW
         hTEL27N0htczV7Rk1h3/i7OUVjJHc22B21LNvQ2mZe/zDG1D+sohOwHWm9yZCqMk3zSo
         xbUFR0u7QPTlt9jQZvlEsol23pfXlxi0sCUOAFvVlbm2m+6Dq/QZo2058ZcClRN04+k2
         Hd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GG8/kT0PKwqWP3AvSWmrhBSKsdjFhFnl36yGJFNM3fg=;
        b=JolP0BCKApKjzU6q1CfyIneE4VEsyRiHFCLJ+ETjk9715meJBF/M1gZ1MnIGbxXwIz
         vWwEQO5NM2IVbNFglTtxqY8dsA1ZCQghfxwU3VvCSis7fi629VlFxFnH2tzMTR0kgPt/
         6+Bsi0pFcXASDy9SXGtjNhAj1Z/LHqHaJM+5pH6rajau6t8Q14EUqbFv6MZZlYW1w2PE
         eS0CM5ZMppDrCAYhjJQjDKGWDsaR2nXcgIWcC4Qv1gChoy+1R4id+cKXGoTuuPBjRDnM
         KB6RCoynx654URc4dyNL+xlKhrVkL2mZM85Jj8MGyjev7u9M/of9JPLhxlM/FPWhh1Ox
         YyVA==
X-Gm-Message-State: AO0yUKUg/HXmwLHODucAvD/Kt1waxfA+pPcENRAQl7Ons/PWxKeonsnO
        +qrzf1jbUGwLI0qpMpabyWr1PWcIQybMkeSVBBQgtA==
X-Google-Smtp-Source: AK7set/HXKaUvajeee5zFP4Daz3XLDIYlWTeJcObla17wC2qxZV3s87DRuri8yGnlGYOH0r0FHNhjvG0pfer3B8MUto=
X-Received: by 2002:a25:ef51:0:b0:80b:a45b:fd37 with SMTP id
 w17-20020a25ef51000000b0080ba45bfd37mr2088227ybm.387.1675187834972; Tue, 31
 Jan 2023 09:57:14 -0800 (PST)
MIME-Version: 1.0
References: <20230131174601.203127-1-jakub@cloudflare.com>
In-Reply-To: <20230131174601.203127-1-jakub@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 31 Jan 2023 18:57:03 +0100
Message-ID: <CANn89iL2PCnC=6dOrozW0309W==tWcKpj2iwZgZAD_s0amvzLA@mail.gmail.com>
Subject: Re: [PATCH net] udp: Pass 2 bytes of data with UDP_GRO cmsg to user-space
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 6:46 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> While UDP_GRO cmsg interface lacks documentation, the selftests added in
> commit 3327a9c46352 ("selftests: add functionals test for UDP GRO") suggest
> that the user-space should allocate CMSG_SPACE for an u16 value and
> interpret the returned bytes as such:
>
> static int recv_msg(int fd, char *buf, int len, int *gso_size)
> {
>         char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
>         ...
>                         if (cmsg->cmsg_level == SOL_UDP
>                             && cmsg->cmsg_type == UDP_GRO) {
>                                 gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
>                                 *gso_size = *gsosizeptr;
>                                 break;
>                         }
>         ...
> }
>
> Today user-space will receive 4 bytes of data with an UDP_GRO cmsg, because
> the kernel packs an int into the cmsg data, as we can confirm with strace:
>
>   recvmsg(8, {msg_name=...,
>               msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
>               msg_iovlen=1,
>               msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
>                             cmsg_level=SOL_UDP,
>                             cmsg_type=0x68}],    <-- UDP_GRO
>                             msg_controllen=24,
>                             msg_flags=0}, 0) = 11200
>
> This means that either UDP_GRO selftests are broken on big endian, or this
> is a programming error. Assume the latter and pass only the needed 2 bytes
> of data with the cmsg.
>
> Fixing it like that has an added advantage that the cmsg becomes compatible
> with what is expected by UDP_SEGMENT cmsg. It becomes possible to reuse the
> cmsg when GSO packets are received on one socket and sent out of another.
>
> Fixes: bcd1665e3569 ("udp: add support for UDP_GRO cmsg")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/udp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index a2892e151644..44bb8d699248 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -125,7 +125,7 @@ static inline bool udp_get_no_check6_rx(struct sock *sk)
>  static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
>                                  struct sk_buff *skb)
>  {
> -       int gso_size;
> +       __u16 gso_size;
>
>         if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
>                 gso_size = skb_shinfo(skb)->gso_size;
> --
> 2.39.1
>

This would break some applications.

I think the test can be fixed instead, this seems less risky.
