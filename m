Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659C462D75E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbiKQJpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiKQJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:45:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C726B7C001
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:45:13 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id f18so3695124ejz.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=v6eoQe/b3qgCQtSYMJztYGqyUQLHJMLNxcSpq01+Vsc=;
        b=k5V66tFzHqtD4sUyUugWLBY9Thhc5g6cEPjIfUxU1goHdTnCZcDmu08zFANMXFOscz
         4ylkLCvspvhpYCbjpwPtHmovpa/vsSkBj50Mo3cOgnYsZLF0rzqVSazWPR9y2eGAffNc
         auO6rT0Wa6LwKF2stZhcc+zFSzxaykcXtGINo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6eoQe/b3qgCQtSYMJztYGqyUQLHJMLNxcSpq01+Vsc=;
        b=XLpVofCu7CcXa0NdpWQjpXGx2e068hH7hR8Mb1BZ7g/aChrU1Azw7qrT4liKVIaL9t
         AJVqROfLTlRz9dLOv+6sFBbfX0y8UTeGqafOjZxlhtNphignGkmW/C4Ok2RrXbkP7a2Y
         1Q+isg9h+rryiLr+BRR0kOCOr3hhaSTnc5bBm5EMry5qdC6tsDn5TauelS8NACvZaWJb
         vCrJ5j6yobx1FfBjKKoyshUerEp6ugp3b9DntfOhV3IuCh15QbrcsVz9rkjNqqfZKD34
         1wWMjgnpSWRR6VreAwdpVyzkRuIibghNHzUkigbkyZSojM9TF9J5viopCp4xorgFKFij
         Lspg==
X-Gm-Message-State: ANoB5pk0eFSsV/FqQBWa57Pi19F5Q322sBpUqPE2aVH9vzMB79sSxWY7
        gneQzImVDn8ubjwcnbfXaZinSsNgUqq/sg==
X-Google-Smtp-Source: AA0mqf7g5g4BW8g2Y/p5p4iIUwLq+RAeg0aLj1JoPwK1xEOhqz3OGdjbvn9dgdu0MFGNx+4JG+cd6w==
X-Received: by 2002:a17:907:2997:b0:7ad:b791:1390 with SMTP id eu23-20020a170907299700b007adb7911390mr1441361ejc.279.1668678312410;
        Thu, 17 Nov 2022 01:45:12 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id n23-20020a05640204d700b0045c47b2a800sm292661edw.67.2022.11.17.01.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 01:45:11 -0800 (PST)
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Thu, 17 Nov 2022 10:35:02 +0100
In-reply-to: <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
Message-ID: <871qq13oex.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:07 AM -08, Eric Dumazet wrote:
> On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>>
>> Hello:
>>
>> This patch was applied to netdev/net.git (master)
>> by David S. Miller <davem@davemloft.net>:
>>
>> On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
>> > sk->sk_user_data has multiple users, which are not compatible with each
>> > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>> >
>> > l2tp currently fails to grab the lock when modifying the underlying tunnel
>> > socket fields. Fix it by adding appropriate locking.
>> >
>> > We err on the side of safety and grab the sk_callback_lock also inside the
>> > sk_destruct callback overridden by l2tp, even though there should be no
>> > refs allowing access to the sock at the time when sk_destruct gets called.
>> >
>> > [...]
>>
>> Here is the summary with links:
>>   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
>>     https://git.kernel.org/netdev/net/c/b68777d54fac
>>
>>
>
> I guess this patch has not been tested with LOCKDEP, right ?
>
> sk_callback_lock always needs _bh safety.
>
> I will send something like:
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
> 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>         }
>
>         sk = sock->sk;
> -       write_lock(&sk->sk_callback_lock);
> +       write_lock_bh(&sk->sk_callback_lock);
>
>         ret = l2tp_validate_socket(sk, net, tunnel->encap);
>         if (ret < 0)
> @@ -1522,7 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>         if (tunnel->fd >= 0)
>                 sockfd_put(sock);
>
> -       write_unlock(&sk->sk_callback_lock);
> +       write_unlock_bh(&sk->sk_callback_lock);
>         return 0;
>
>  err_sock:
> @@ -1531,7 +1531,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>         else
>                 sockfd_put(sock);
>
> -       write_unlock(&sk->sk_callback_lock);
> +       write_unlock_bh(&sk->sk_callback_lock);
>  err:
>         return ret;
>  }

Hmm, weird. I double checked - I have PROVE_LOCKING enabled.
Didn't see any lockdep reports when running selftests/net/l2tp.sh.

I my defense - I thought _bh was not needed because
l2tp_tunnel_register() gets called only in the process context. I mean,
it's triggered by Netlink sendmsg, but that gets processed in-line
AFAIU:

netlink_sendmsg
  netlink_unicast
    ->netlink_rcv
      genl_rcv
        genl_rcv_msg
          genl_family_rcv_msg
            genl_family_rcv_msg_doit
              ->doit
                l2tp_nl_cmd_tunnel_create
                  l2tp_tunnel_register
