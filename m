Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3626C56F977
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiGKJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGKJAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:00:06 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D75A21E16
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:00:05 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31c8bb90d09so42065867b3.8
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K968b5/tq2F/k8wTikaAiwbkCotiAPXw/V+R2s6IwJ4=;
        b=aKogk+jkk2xqbiqOSxeXT1NV45I6P/qdjrFkDzmtKHBvuMdxfo7QLK5AM83QDPcmux
         2WEWDqR5QjFbOiboNQn0H7yo1GQ+QUaizVzL+S2CveDEpY1IJDfRinHvMpVkrW0C+4fe
         pUvueuwVwS0vaJhUSUCrP+RuyTdxfOfo7nWcwy1QAANDdSyOkx7ZAk7CwKtNh+B0dkXO
         VI00+aBH3FeVjtbWOz15JZoTTUE32WEv2tOKI0WAYPTaKzk1C8gsERDpuYbSXNZnuSwB
         SoIzGPvbn2itGluiMOMO/2UUojm8oW6TJDVeXOBkjr0b06DSZFuoh80pfd1SKR9fi3WK
         TTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K968b5/tq2F/k8wTikaAiwbkCotiAPXw/V+R2s6IwJ4=;
        b=XWDFvhO2pA/mPc+d9N2g/riAzIgANr+lmfA4RXjnglXH+OvmRy32yL4JQbSdc575eM
         j1mZXxms5UMtOdZV2VayzkjYfNLCLg/uNsTriNczGPdcUUImlSrAslC0hPi8KC1QcxFa
         KwnvByoh+AtCAofxnJq8pRTSwpC9/g5sOj1ngybtZQFPP1udQCSeo0LzH0T32uMH6nNg
         oWAamj7D/yLdrmo9NGtqmd9tprYwmET5tgi9og4c7F+uMu3mq3/D++SXmu3gJyvcKkCi
         TmIiKo13+X89qpl8s6tKAiE8TGsuRWofr39imqrLoL57V0AljxqZwIaIYrTRH7VN+4O8
         JBIw==
X-Gm-Message-State: AJIora/1mIUNT88e29/qSbpwE0LsGp/mC6O1O8T3oJrIkNeIacdY6M9C
        wm2yDTMfDLKtS8QKitMS849El9D2jdpWrfzLVdGvVA==
X-Google-Smtp-Source: AGRyM1sAEDGLM6g7x45WAsx0YLciDaHK4zEpLzBH2IHMKYHjTPwNuOZlH7gFFzTaYRl+FWg6sWpD4Nk34WZCeitHokk=
X-Received: by 2002:a81:1586:0:b0:31c:80cd:a035 with SMTP id
 128-20020a811586000000b0031c80cda035mr17426420ywv.332.1657530004268; Mon, 11
 Jul 2022 02:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220707054008.3471371-1-ssewook@gmail.com> <20220707100139.3748417-1-ssewook@gmail.com>
In-Reply-To: <20220707100139.3748417-1-ssewook@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 11 Jul 2022 10:59:52 +0200
Message-ID: <CANn89iLGDpKoZK5jFa5yfAUdQnBi-D+aJ9+YOGPRhW_pgQNhTw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next] net: Find dst with sk's xfrm policy not ctl_sk
To:     Sewook Seo <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 12:02 PM Sewook Seo <ssewook@gmail.com> wrote:
>
> From: sewookseo <sewookseo@google.com>
>
> If we set XFRM security policy by calling setsockopt with option
> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> struct. However tcp_v6_send_response doesn't look up dst_entry with the
> actual socket but looks up with tcp control socket. This may cause a
> problem that a RST packet is sent without ESP encryption & peer's TCP
> socket can't receive it.
> This patch will make the function look up dest_entry with actual socket,
> if the socket has XFRM policy(sock_policy), so that the TCP response
> packet via this function can be encrypted, & aligned on the encrypted
> TCP socket.
>
> Tested: We encountered this problem when a TCP socket which is encrypted
> in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> state. After receiving challenge ACK, TCP needs to send RST to
> establish the socket at next SYN try. But the RST was not encrypted &
> peer TCP socket still remains on ESTABLISHED state.
> So we verified this with test step as below.
> [Test step]
> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED)=
.
> 2. Client tries a new connection on the same TCP ports(src & dst).
> 3. Server will return challenge ACK instead of SYN,ACK.
> 4. Client will send RST to server to clear the SOCKET.
> 5. Client will retransmit SYN to server on the same TCP ports.
> [Expected result]
> The TCP connection should be established.
>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Sehee Lee <seheele@google.com>
> Signed-off-by: Sewook Seo <sewookseo@google.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
