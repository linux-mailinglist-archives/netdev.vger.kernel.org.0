Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29D96878C1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjBBJ0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBJ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:26:34 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0473929E
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:26:34 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5063029246dso18416687b3.6
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yMJLDKfiAh5d4q1e+8BHnfDMo0mUiYMeMc9aD1SEa10=;
        b=fzeQZSHyw47SxC8Rtj+m5yBF+0xwnHJBbuQKxaz0Iac7/qtsy9fHhvgm89w6nwL6C2
         w/4hH5m23kzrn5ChiLw1DtIeK9vkEqavU9lWOIfZbVp5g7FegM2+H3wdLVbMp6aTqXc0
         WCILhVZe/eFsMU1Thw4veNWUgxMeVUW/ZIXLkHXiPBXsKPJkVsZqGLF0Ehlv3D022i++
         FxV+9bkXjvpHaRNUCAraNsXt9ZhJ0E+HN24IoruY5J7mFvyDF2lgreSyJtqD0BZg8X5C
         izALpjgrgmEu7FQsQ+w/LyRQ/Nsu6w/KxDM+YhzFB2MGOLHYm6ldNxd2kQ2k0Zb8Nf2U
         dZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yMJLDKfiAh5d4q1e+8BHnfDMo0mUiYMeMc9aD1SEa10=;
        b=nrWzaeW6yIlvbnGfO5xGpU5nRsCndMm07jen/R+MrfPQjPBf39aIWhZREjskwDF264
         9gYRckrS0sMqtdWiLMp8YK8d1PvwTCXPWLklanHwUZdA4zZyNiPV9+GvpGw60VJ5kJUX
         KALq/Z+GzYvZkYPFrgL5/jgj4NqzCrh+CUZT+MOX+t4ZUVd/E8GoAVjZkUntpnZomAbV
         l96aLDz0z96BrSyVhzkGE+61y+P+ttYY1PMFyt3qFracn5kn74q1pw9XjGAWww3Rr7kU
         HiJXaGQbHBXPmeunp1xoqjC2kE2NlF4bRWFCffw3vMyDUd18RUud/+O7D5KZBqOS5+WX
         VFiQ==
X-Gm-Message-State: AO0yUKUqNgtTyMcE4DqoDwsnI4YsUdzU/GRe8DKlDXvR4mB1R4JrbXeM
        Abgb8breEF5VdGwfst0RHYIl19X1eYpABRani4Zssw==
X-Google-Smtp-Source: AK7set8aXMGpKuLxzy9fQl+dGgdEeWWeapuh8k4nJ6zlAccjUYwWS0b7tuE6Jv3NgHgtrKXm51wDkn85QhM/rxFquZE=
X-Received: by 2002:a05:690c:b82:b0:500:ac2c:80fb with SMTP id
 ck2-20020a05690c0b8200b00500ac2c80fbmr617309ywb.90.1675329992984; Thu, 02 Feb
 2023 01:26:32 -0800 (PST)
MIME-Version: 1.0
References: <20230123091708.4112735-1-git@sung-woo.kim> <20230202090509.2774062-1-iam@sung-woo.kim>
In-Reply-To: <20230202090509.2774062-1-iam@sung-woo.kim>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Feb 2023 10:26:21 +0100
Message-ID: <CANn89i+hAht=g1F6kjPfq8eO4j6-2WEE+CNtRtq1S4UnwXEQaw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix use-after-free
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     happiness.sung.woo@gmail.com, benquike@gmail.com,
        davem@davemloft.net, daveti@purdue.edu, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        wuruoyu@me.com
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

On Thu, Feb 2, 2023 at 10:07 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Due to the race condition between l2cap_sock_cleanup_listen and
> l2cap_sock_close_cb, l2cap_sock_kill can receive already freed sk,
> resulting in use-after-free inside l2cap_sock_kill.
> This patch prevent this by adding a null check in l2cap_sock_kill.
>
> Context 1:
> l2cap_sock_cleanup_listen();
>   // context switched
>   l2cap_chan_lock(chan);
>   l2cap_sock_kill(sk); // <-- sk is already freed below

But sk is used in l2cap_sock_cleanup_listen()
and should not be NULL...

while ((sk = bt_accept_dequeue(parent, NULL))) {
  ...
  l2cap_sock_kill(sk);
  ..
}

It would help if you send us a stack trace ...

>
> Context 2:
> l2cap_chan_timeout();
>   l2cap_chan_lock(chan);
>   chan->ops->close(chan);
>     l2cap_sock_close_cb()
>     l2cap_sock_kill(sk); // <-- sk is freed here
>   l2cap_chan_unlock(chan);
>

Please add a Fixes: tag

> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> ---
>  net/bluetooth/l2cap_sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index ca8f07f35..657704059 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -1245,7 +1245,7 @@ static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
>   */
>  static void l2cap_sock_kill(struct sock *sk)
>  {
> -       if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
> +       if (!sk || !sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
>                 return;
>
>         BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
> --
> 2.25.1
>
