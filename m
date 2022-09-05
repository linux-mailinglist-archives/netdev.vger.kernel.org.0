Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE42B5ACDB7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiIEI06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237650AbiIEI0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1162D3
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 01:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662366395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fAeNPdvIGvr/nxKNL5n6SelzY22s+NzrRFLCjQ9oIaY=;
        b=ULoW6d3gfc7FscSEufy8i5GxOWdQGoKUndwfi/LdVj9MTx39D2HG18MhD0JJ4AmgQlbYOB
        1S3Popq1fxLHVFD7wmsMu85OddZZvE3r9Xz7hz1xBZIKua3u6F5gZdWb/C6swwG6nIVLOJ
        h0nRQWP36qFmtsxOXvQN0YleaiS7aWM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-DsbtkHGvOIyGIDzNvofR-g-1; Mon, 05 Sep 2022 04:26:34 -0400
X-MC-Unique: DsbtkHGvOIyGIDzNvofR-g-1
Received: by mail-wm1-f70.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so7130170wms.9
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 01:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=fAeNPdvIGvr/nxKNL5n6SelzY22s+NzrRFLCjQ9oIaY=;
        b=eK/2Bp+k9dj4Yv9Jw8/J6sX3fQfnZeJRhHiEEDUWEI6UVHH2MDVL3uo11U8Lk8YfHM
         rFzZqgl/JGwU9o5m9tsUskuKeBl0KuYkzytkxhbMlfWLrqZGAszCUKLlrw22Ct0ie/mH
         /A38izRzk0kywER/0kV9aaHX8Ffp/Nzgp8G8LAdfDI3+YR2hTr6/W16TjEGO5nPyLCoz
         zfKAFrUIY5/Iv/r0lhJaob3f4ST1gr0EGNIgW+wx89mKrY1q5REhx1THDqR1s3qJTlp5
         MsU0YM4RCid72atxiBe+ZYKv2xqz3xAbrN8s06ZL1FC5u1Mwl6HAGwqFsODvbhdpLXBD
         fBaw==
X-Gm-Message-State: ACgBeo3D8Btj6L3fm4BIv2thi06vTCbu08dITT/b0eFDG8JlIF8RVvRJ
        7Mj+tTtXombXv6JJfXO44+YS9cBhUDgtrNIhIc5J/8hDObt3k+KKa49iovk1Q6qRM9MxXFSnvzV
        qn3/Qwm87l02pgeD8
X-Received: by 2002:a05:600c:254:b0:3a5:a401:a1e2 with SMTP id 20-20020a05600c025400b003a5a401a1e2mr9629985wmj.14.1662366392823;
        Mon, 05 Sep 2022 01:26:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4NVOMUCvaizvb26rANBB+lQiZc3OkLs5X1oe7PAUfIMZ0rWJCEMl/AfeZB4aFUEIf+M3E4pw==
X-Received: by 2002:a05:600c:254:b0:3a5:a401:a1e2 with SMTP id 20-20020a05600c025400b003a5a401a1e2mr9629969wmj.14.1662366392548;
        Mon, 05 Sep 2022 01:26:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id ch13-20020a5d5d0d000000b00226d1711276sm8485733wrb.1.2022.09.05.01.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 01:26:32 -0700 (PDT)
Message-ID: <da8998cba112cbdea9d403052732c794f3882bd2.camel@redhat.com>
Subject: Re: [PATCH net] net: mptcp: fix unreleased socket in accept queue
From:   Paolo Abeni <pabeni@redhat.com>
To:     menglong8.dong@gmail.com, mathew.j.martineau@linux.intel.com
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Date:   Mon, 05 Sep 2022 10:26:30 +0200
In-Reply-To: <20220905050400.1136241-1-imagedong@tencent.com>
References: <20220905050400.1136241-1-imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-09-05 at 13:04 +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The mptcp socket and its subflow sockets in accept queue can't be
> released after the process exit.
> 
> While the release of a mptcp socket in listening state, the
> corresponding tcp socket will be released too. Meanwhile, the tcp
> socket in the unaccept queue will be released too. However, only init
> subflow is in the unaccept queue, and the joined subflow is not in the
> unaccept queue, which makes the joined subflow won't be released, and
> therefore the corresponding unaccepted mptcp socket will not be released
> to.
> 
> This can be reproduced easily with following steps:
> 
> 1. create 2 namespace and veth:
>    $ ip netns add mptcp-client
>    $ ip netns add mptcp-server
>    $ sysctl -w net.ipv4.conf.all.rp_filter=0
>    $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
>    $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
>    $ ip link add red-client netns mptcp-client type veth peer red-server \
>      netns mptcp-server
>    $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
>    $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
>    $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
>    $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
>    $ ip -n mptcp-server link set red-server up
>    $ ip -n mptcp-client link set red-client up
> 
> 2. configure the endpoint and limit for client and server:
>    $ ip -n mptcp-server mptcp endpoint flush
>    $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
>    $ ip -n mptcp-client mptcp endpoint flush
>    $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
>    $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
>      1 subflow
> 
> 3. listen and accept on a port, such as 9999. The nc command we used
>    here is modified, which makes it uses mptcp protocol by default.
>    And the default backlog is 1:
>    ip netns exec mptcp-server nc -l -k -p 9999
> 
> 4. open another *two* terminal and connect to the server with the
>    following command:
>    $ ip netns exec mptcp-client nc 10.0.0.1 9999
>    input something after connect, to triger the connection of the second
>    subflow
> 
> 5. exit all the nc command, and check the tcp socket in server namespace.
>    And you will find that there is one tcp socket in CLOSE_WAIT state
>    and can't release forever.

Thank you for the report! 

I have a doubt WRT the above scenario: AFAICS 'nc' will accept the
incoming sockets ASAP, so the unaccepted queue should be empty at
shutdown, but that does not fit with your description?!?

> There are some solutions that I thought:
> 
> 1. release all unaccepted mptcp socket with mptcp_close() while the
>    listening tcp socket release in mptcp_subflow_queue_clean(). This is
>    what we do in this commit.
> 2. release the mptcp socket with mptcp_close() in subflow_ulp_release().
> 3. etc
> 

Can you please point to a commit introducing the issue?

> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  net/mptcp/subflow.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index c7d49fb6e7bd..e39dff5d5d84 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1770,6 +1770,10 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
>  		msk->first = NULL;
>  		msk->dl_next = NULL;
>  		unlock_sock_fast(sk, slow);
> +
> +		/*  */
> +		sock_hold(sk);
> +		sk->sk_prot->close(sk);

You can call mptcp_close() directly here.

Perhaps we could as well drop the mptcp_sock_destruct() hack?

Perhpas even providing a __mptcp_close() variant not acquiring the
socket lock and move such close call inside the existing sk socket lock
above?

Thanks,

Paolo

