Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C994C6069C6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJTUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJTUql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 16:46:41 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A9C1BB542
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 13:46:13 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r3so1007787yba.5
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 13:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1jAIJWdP6IvOo3sWNyuhjuKQsFnO2B5x/pVbHqvUC0=;
        b=Jzh7nqmfYKwfFRFJDhqn/3EDpkr0q5fULTeYvAwpVKk4preyU1paZf8eOs1XegrgpF
         AW27FIGiWmGZ9/3hM4i99Vohiat3cdysdzhTs8NNtCwFK+41VSg31RywT4n85AUY09xB
         qg/jVWBvgboTUSSAFwiohZPCz3zohhIQMtJCHE1B6qZKjawrOaM8C45EcDypbrhf8x3w
         315wUzD3uB6tiuO5ssTgHcgeg0/s/42JQeLPLknOakOPqLoJblfAQxV74j5VlAXzLhcK
         On25DKH7ZaP2mCUOmWQViOEKsL5SWEybxLnl7zrs8SRPTnJom9FCcEaSqLIlpys4rsTu
         x6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C1jAIJWdP6IvOo3sWNyuhjuKQsFnO2B5x/pVbHqvUC0=;
        b=r7WgQlOjebdobXXpJpn02k3mRLoKP7hcBaSl0vNpP53D/a0DvGjGy8C53VZyFfVT6c
         UAtyJHL5ef1UjfRb8JMe5T2sFnRdxWVO3CsJEoZyut4T88rKXIB0J6+XSDl/iGUwRpAX
         G2f4U7aNAcQYR19pV8Z6+QmKUAMq/REK6U2Pat0v2wsY0tMdzixO8wabvqJxD9tkUD2t
         tA3W2VnanoDE9Qqptj5o5SxdpymHRgzwYMWQsHAhu5Nd0MBhIJFiFJrkrZywkBpTOtzK
         jrtWMntRMPNdjOkDJ8D//p7FLkVkjkox0SEAI8zxUugopcSZb4pHlCATzIokSsEFuPcS
         TyVg==
X-Gm-Message-State: ACrzQf1t1VCoXm9nOxU3DgXahZTpbGATd2Q6Al1ZzW6k9uSm/XxMSuz9
        hPtLviQhYY2tHLHtMF85w4sB3P4wZSYOlkEVN7+BEg==
X-Google-Smtp-Source: AMsMyM4lZ/Bh8h1mhBSsfg6hy8TnaX8qXfMIa8YtsouDUw/sQprldhqWbTwk9XYFZY0IHWKPAUVe21ofhrrIF3bUloc=
X-Received: by 2002:a25:26c1:0:b0:6c3:bdae:c6d6 with SMTP id
 m184-20020a2526c1000000b006c3bdaec6d6mr13895710ybm.36.1666298716903; Thu, 20
 Oct 2022 13:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com> <20221020182242.503107-2-kamaljit.singh1@wdc.com>
In-Reply-To: <20221020182242.503107-2-kamaljit.singh1@wdc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 13:45:05 -0700
Message-ID: <CANn89iKaEqkcOooXY0EpnBScNXY1HhwwgeZuivQYmN4jxLUcJA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] tcp: Fix for stale host ACK when tgt window shrunk
To:     Kamaljit Singh <kamaljit.singh1@wdc.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Niklas.Cassel@wdc.com, Damien.LeMoal@wdc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Oct 20, 2022 at 11:22 AM Kamaljit Singh <kamaljit.singh1@wdc.com> w=
rote:
>
> Under certain congestion conditions, an NVMe/TCP target may be configured
> to shrink the TCP window in an effort to slow the sender down prior to
> issuing a more drastic L2 pause or PFC indication.  Although the TCP
> standard discourages implementations from shrinking the TCP window, it al=
so
> states that TCP implementations must be robust to this occurring. The
> current Linux TCP layer (in conjunction with the NVMe/TCP host driver) ha=
s
> an issue when the TCP window is shrunk by a target, which causes ACK fram=
es
> to be transmitted with a =E2=80=9Cstale=E2=80=9D SEQ_NUM or for data fram=
es to be
> retransmitted by the host.

Linux sends ACK packets, with a legal SEQ number.

The issue is the receiver of such packets, right ?

Because as you said receivers should be relaxed about this, especially
if _they_ decided
to not respect the TCP standards.

You are proposing to send old ACK, that might be dropped by other stacks.

It has been observed that processing of these
> =E2=80=9Cstale=E2=80=9D ACKs or data retransmissions impacts NVMe/TCP Wri=
te IOPs
> performance.
>
> Network traffic analysis revealed that SEQ-NUM being used by the host to
> ACK the frame that resized the TCP window had an older SEQ-NUM and not a
> value corresponding to the next SEQ-NUM expected on that connection.
>
> In such a case, the kernel was using the seq number calculated by
> tcp_wnd_end() as per the code segment below. Since, in this case
> tp->snd_wnd=3D0, tcp_wnd_end(tp) returns tp->snd_una, which is incorrect =
for
> the scenario.  The correct seq number that needs to be returned is
> tp->snd_nxt. This fix seems to have fixed the stale SEQ-NUM issue along
> with its performance impact.
>
>   1271 static inline u32 tcp_wnd_end(const struct tcp_sock *tp)
>   1272 {
>   1273   return tp->snd_una + tp->snd_wnd;
>   1274 }
>
> Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
> ---
>  net/ipv4/tcp_output.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 11aa0ab10bba..322e061edb72 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -100,6 +100,9 @@ static inline __u32 tcp_acceptable_seq(const struct s=
ock *sk)
>             (tp->rx_opt.wscale_ok &&
>              ((tp->snd_nxt - tcp_wnd_end(tp)) < (1 << tp->rx_opt.rcv_wsca=
le))))
>                 return tp->snd_nxt;
> +       else if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
> +                !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))=
)
> +               return tp->snd_nxt;
>         else
>                 return tcp_wnd_end(tp);
>  }
> --
> 2.25.1
>
