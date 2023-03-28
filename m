Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592256CB7D0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjC1HPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjC1HPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:15:21 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DA02118
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:15:20 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn12so45664348edb.4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679987719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5+zy5SoCYq6/et2tieaSXMpayerIKj860Onx4Vw8+I=;
        b=Ho8JSOryFKimIksqf5bO4XzT5xg7fQ8AUYrBISwwm/DvVDZe9L2hbzg9JWGCbwLxEp
         XUnFp0+mg2xv8hIDg7Axw8y6PX2zKbjlUy0YVr6FC89GdEb07jP+VWr83cuBzYroKgcJ
         J85vVDAWFSnQTmDZG/Jjhrfhnx8xxSdnmF0hcy5GtZ8VMnd+jxl8XkMcRDMkZJXL1L3c
         d/FvU3A74ViIu2yuM7vJSTJsPE4hRcUsaSl0hSnLz0lorbBZggwgGa8JmltCK65Oo5s0
         lcdPfmzNLxafuLVIqRm0S/K0DlhQTU23nNiCU6NokM0pF5QzTCwF6pdITYMybKNq+Nrr
         sIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679987719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5+zy5SoCYq6/et2tieaSXMpayerIKj860Onx4Vw8+I=;
        b=5yvkEhmsgSdJJ/sMAz2rGXnyvFMUqU0drXP6fT9mzYZmREFW57/q9j/YV3Rox2Blkc
         DiJswtBAoGLtoBeVDBhNdeB8O2HI000qL0tPS2j2mGohx66CWmOQGA1zkwRylEJL5Nsx
         W8iiQzdeQgNlSx/8foo7lutno36HJu99Jx57DWokd3uSYuYYh0zq+HvA/sQuMzswZamF
         aK7H7I5+NpQRMOPB8B/Y+vrmVojs1dq1IX4v3pOm6ULbkH6/n9TjxJhbjfnV3CSEnFz1
         RNOhXoWJvaJ4oub6D9qNBn0KIo5Opclt6XHca4EyFnG0o4l2Lum1tw6+tU7CYWjbEvWI
         8T9g==
X-Gm-Message-State: AO0yUKWD8BGO0Crgl/thf8Kq4Indo8Sb713BAu5NmyrvkOzdqW2VWktl
        tneGXHCqrd62UC6YZGePQRxoLT/EJrnLywTs32ZrGY5iDcYgsw==
X-Google-Smtp-Source: AK7set+w9HL6bZGjbPOTJ/gGhKn8M4plcIkYVae6XC9D3coqQ1Y2eAz3nFbgIxt3YfscIab2KGU4+aRfKHTbKKFPjU0=
X-Received: by 2002:a17:907:c084:b0:922:26ae:c68c with SMTP id
 st4-20020a170907c08400b0092226aec68cmr11293640ejc.5.1679987718858; Tue, 28
 Mar 2023 00:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230327230628.45660-1-kuniyu@amazon.com>
In-Reply-To: <20230327230628.45660-1-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 28 Mar 2023 15:14:42 +0800
Message-ID: <CAL+tcoD9zYs-6wT1mqx2Zu3v6S=9q3Wq_X_W0_XNFu6ViAvwiw@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp: Refine SYN handling for PAWS.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 7:18=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> Our Network Load Balancer (NLB) [0] has multiple nodes with different
> IP addresses, and each node forwards TCP flows from clients to backend
> targets.  NLB has an option to preserve the client's source IP address
> and port when routing packets to backend targets.
>
> When a client connects to two different NLB nodes, they may select the
> same backend target.  Then, if the client has used the same source IP
> and port, the two flows at the backend side will have the same 4-tuple.

It rarely happens based on my knowledge (at least no one reports such
an issue in my company), but indeed it can happen.

>
> While testing around such cases, I saw these sequences on the backend
> target.
>
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62=
727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length=
 0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2=
819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 102981=
6180,nop,wscale 7], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, option=
s [nop,nop,TS val 1029816181 ecr 1224784076], length 0
> IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62=
727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length =
0
> IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, option=
s [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156=
821005}], length 0
>
> It seems to be working correctly, but the last ACK was generated by
> tcp_send_dupack() and PAWSEstab was increased.  This is because the
> second connection has a smaller timestamp than the first one.
>
> In this case, we should send a challenge ACK instead of a dup ACK and
> increase the correct counter to rate-limit it properly.
>
> Let's check the SYN bit after the PAWS tests to avoid adding unnecessary
> overhead for most packets.
>
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/int=
roduction.html [0]
> Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/loa=
d-balancer-target-groups.html#client-ip-preservation [1]
> Fixes: 0c24604b68fc ("tcp: implement RFC 5961 4.2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

A long time ago, a similar case reported in 2012 was handled in commit
e37158991701(tcp: refine SYN handling in tcp_validate_incoming) by
Eric.
I believe we also can do this here during the paws check phrase.

It looks good to me, please feel free to add:
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks!

> ---
>  net/ipv4/tcp_input.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc072d2cfcd8..89fca4c18530 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5714,6 +5714,8 @@ static bool tcp_validate_incoming(struct sock *sk, =
struct sk_buff *skb,
>             tp->rx_opt.saw_tstamp &&
>             tcp_paws_discard(sk, skb)) {
>                 if (!th->rst) {
> +                       if (unlikely(th->syn))
> +                               goto syn_challenge;
>                         NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABRE=
JECTED);
>                         if (!tcp_oow_rate_limited(sock_net(sk), skb,
>                                                   LINUX_MIB_TCPACKSKIPPED=
PAWS,
> --
> 2.30.2
>
