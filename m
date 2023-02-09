Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE73C690770
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjBIL3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjBIL2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:28:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693C36ADE5
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:21:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u10so1182674wmj.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 03:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ng5TvHySCscqtUpYHoE85LimT+qmSdF5Bo8bWfeXdMk=;
        b=Ibk2bavIzVOxoQx+B4gXBPp39ljzNb2fRy9rXogTbRkeQaWaMepLc67GnTXrZGH+kJ
         56cf7Xm0d7NIpdTsahhVll76P7hUkNwNXiVv0XmtET6/ZW5kDC4h5mjNHNxNzbFMXTeu
         6Ju0f/4KcrQF5IxNy3NnYZrkkgfo87hJxIwpUh/hzIOmZio+HsBzlhRd4CtYPFj1h2BI
         vlDD4VYNIZ+z/1Wiadr9rNOk+4OLlo3th3+eHIz79HnTwIhmVkHmLA0EmwWbBP3usa2b
         vo60F8qjsMOqfvR/DdjHP0RgJLxG3FeAl6lTspOs0dasi0x2MvKHZej/E3dzlnoqAFoR
         Lfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ng5TvHySCscqtUpYHoE85LimT+qmSdF5Bo8bWfeXdMk=;
        b=403LSttT4w7RR2tYhUuJk+9+SqCOrz8Ghn+854WXKal+EBYZefVteifXoa/8/73mCv
         rqywmU3PyDH1GTHcysBPgSPq6dLD5RXhAwAwavLNeTaL+Y7AY2c9bu0t39QTOzWPCnOu
         dnwsvaC4SSguSHrWVaThKFt3sAURq9UhOOus2YSHqxbhaq304zMzPEbJglm4OhbF92yu
         bsfi0W1VuYgNN397CvJWMTh+ZlaZ/NpGIFWZplBNtpGje4roa9smMeGN2Biu79uOpdci
         y8kOgi4T0sc4+EYHQcF+DhE2xE7oD2NegWuZj4/vANhNrDGchGI6IqDoRHeU5jdrJlp4
         XHrA==
X-Gm-Message-State: AO0yUKWsbVag2QkSiY8uZt8q75d0mg57JFZCkWfi+A+xzfzGs7HVHyDW
        SHzwAd7VeUosIbS6te12kmNXuHxGwKL8rvAQxLXuUw==
X-Google-Smtp-Source: AK7set9eRkNSeHA3Gsc8ko4tY0alpg4FhVDHMlbnLH+GkKVBSSI6THy5oS4UlugCEaLKrjdhd2LOGnT7SAoQORKeons=
X-Received: by 2002:a05:600c:1c81:b0:3db:105:85a4 with SMTP id
 k1-20020a05600c1c8100b003db010585a4mr521547wms.124.1675941616871; Thu, 09 Feb
 2023 03:20:16 -0800 (PST)
MIME-Version: 1.0
References: <20230209013329.87879-1-kuniyu@amazon.com> <20230209013329.87879-2-kuniyu@amazon.com>
In-Reply-To: <20230209013329.87879-2-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 12:20:04 +0100
Message-ID: <CANn89iJ2SpzuL9wyCeDjadogiUfk2C1niJD3RG7tJHA+T1aiJA@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Andrii <tulup@mail.ru>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>
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

On Thu, Feb 9, 2023 at 2:34 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
> for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
> resulting in a negative sk_forward_alloc.
>
> Note that in (dccp|tcp)_v6_do_rcv(), we call sk_rmem_schedule()
> just after skb_clone() instead of after ipv6_opt_accepted().  This is
> because tcp_send_synack() can make sk_forward_alloc negative before
> ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.
>
> [0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/
>
> Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
> Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Thanks, but I suggest we add a helper to avoid the duplication...

Something like this (this can also be made out-of-line, because this
is not fast path)

Name is probably not well chosen...

diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b23006051d651630bdd966741cbb01..f5a97aed14345c403b25339fcb86d99bc51233a7
100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2977,4 +2977,19 @@ static inline bool sk_is_readable(struct sock *sk)
                return sk->sk_prot->sock_is_readable(sk);
        return false;
 }
+
+static inline struct sk_buff *
+sk_clone_and_charge_skb(struct sock *sk, struct sk_buff *skb)
+{
+       skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+       if (skb) {
+               if (sk_rmem_schedule(sk, skb, skb->truesize)) {
+                       skb_set_owner_r(skb, sk);
+                       return skb;
+               }
+               __kfree_skb(skb);
+       }
+       return NULL;
+}
+
 #endif /* _SOCK_H */
