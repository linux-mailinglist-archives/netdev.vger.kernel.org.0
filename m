Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2295679832
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjAXMjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAXMjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:39:19 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B04526847
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:39:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id k20so976399edj.7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Bj/72T3hOFWlOsjsHjTz4IctXjecbs4vpQ1DSir91RU=;
        b=GJXaXqFajUns53DAiNDWc8ajS3YNQEcXImgYJjZZzEef7Xu3chqK3aUddXisXgK65Y
         XDw3+IJN/kZPmzW8yDbMeVijJiQfx9RRHgRdB2Bgt8r5uXa1l/bD26T9VMO5WlepDPTJ
         p0De085Ci1UimNtN+uUbe7bmgJ7+0ofKP3NI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bj/72T3hOFWlOsjsHjTz4IctXjecbs4vpQ1DSir91RU=;
        b=yUlTRaLs1pHBfR0R6j0kXSae50TZYqHSPawSO8BD4L23hzebgRTsJukjZWk1QnFIMf
         x7iMFJEcg7/L/AT4TdmFOIoGUa5tYtd8TAtudGewOE4+LZ2EWa0IKnEU6R+4L2Nrcd3s
         g6b6x6MpKM5OVKuqoInc2Of+QJgE1TAt70GtEJTuOTzMvNAZEg78R6oaIsHikGNZbqLo
         Lf6WsdVHX4WLt2gbHsjE5RdxEEX9CjDjOcQWdJPPQ1Fy+WLWhju+0Klm44Go0kwJSZZn
         AaWfCQCyKDVeIOp56jXn74oXtNBlCXiRm/vCLbYxRvJUoyOJKiZqynz93rBpX6O6lF+6
         Pxiw==
X-Gm-Message-State: AO0yUKVMfG+5Rzq1KL8I2y9EjgQbaz3GMdT76RJL+JGk32HOzFgSnILU
        1vgJSeOTcZq6w5kACu4GliSOxg==
X-Google-Smtp-Source: AK7set/jnpEfzalf3Op4rPRwwUcaUEwKaowL7l7JBVHhhGpXPlXiiOyrppU7CMp56ZvF+ekowng8gg==
X-Received: by 2002:a50:d0dd:0:b0:4a0:8e6e:aa81 with SMTP id g29-20020a50d0dd000000b004a08e6eaa81mr1201640edf.19.1674563956087;
        Tue, 24 Jan 2023 04:39:16 -0800 (PST)
Received: from cloudflare.com (79.184.123.123.ipv4.supernova.orange.pl. [79.184.123.123])
        by smtp.gmail.com with ESMTPSA id g18-20020a170906521200b007b935641971sm855809ejm.5.2023.01.24.04.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 04:39:15 -0800 (PST)
References: <20221221-sockopt-port-range-v5-0-9fb2c00ad293@cloudflare.com>
 <20221221-sockopt-port-range-v5-1-9fb2c00ad293@cloudflare.com>
 <Y8/NrXosvah67bUg@unreal>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v5 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Date:   Tue, 24 Jan 2023 13:33:07 +0100
In-reply-to: <Y8/NrXosvah67bUg@unreal>
Message-ID: <87fsc0w1hp.fsf@cloudflare.com>
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

On Tue, Jan 24, 2023 at 02:23 PM +02, Leon Romanovsky wrote:
> On Tue, Jan 24, 2023 at 11:05:26AM +0100, Jakub Sitnicki wrote:
>> Users who want to share a single public IP address for outgoing connections
>> between several hosts traditionally reach for SNAT. However, SNAT requires
>> state keeping on the node(s) performing the NAT.
>> 
>> A stateless alternative exists, where a single IP address used for egress
>> can be shared between several hosts by partitioning the available ephemeral
>> port range. In such a setup:
>> 
>> 1. Each host gets assigned a disjoint range of ephemeral ports.
>> 2. Applications open connections from the host-assigned port range.
>> 3. Return traffic gets routed to the host based on both, the destination IP
>>    and the destination port.
>> 
>> An application which wants to open an outgoing connection (connect) from a
>> given port range today can choose between two solutions:
>> 
>> 1. Manually pick the source port by bind()'ing to it before connect()'ing
>>    the socket.
>> 
>>    This approach has a couple of downsides:
>> 
>>    a) Search for a free port has to be implemented in the user-space. If
>>       the chosen 4-tuple happens to be busy, the application needs to retry
>>       from a different local port number.
>> 
>>       Detecting if 4-tuple is busy can be either easy (TCP) or hard
>>       (UDP). In TCP case, the application simply has to check if connect()
>>       returned an error (EADDRNOTAVAIL). That is assuming that the local
>>       port sharing was enabled (REUSEADDR) by all the sockets.
>> 
>>         # Assume desired local port range is 60_000-60_511
>>         s = socket(AF_INET, SOCK_STREAM)
>>         s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>>         s.bind(("192.0.2.1", 60_000))
>>         s.connect(("1.1.1.1", 53))
>>         # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
>>         # Application must retry with another local port
>> 
>>       In case of UDP, the network stack allows binding more than one socket
>>       to the same 4-tuple, when local port sharing is enabled
>>       (REUSEADDR). Hence detecting the conflict is much harder and involves
>>       querying sock_diag and toggling the REUSEADDR flag [1].
>> 
>>    b) For TCP, bind()-ing to a port within the ephemeral port range means
>>       that no connecting sockets, that is those which leave it to the
>>       network stack to find a free local port at connect() time, can use
>>       the this port.
>> 
>>       IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
>>       will be skipped during the free port search at connect() time.
>> 
>> 2. Isolate the app in a dedicated netns and use the use the per-netns
>>    ip_local_port_range sysctl to adjust the ephemeral port range bounds.
>> 
>>    The per-netns setting affects all sockets, so this approach can be used
>>    only if:
>> 
>>    - there is just one egress IP address, or
>>    - the desired egress port range is the same for all egress IP addresses
>>      used by the application.
>> 
>>    For TCP, this approach avoids the downsides of (1). Free port search and
>>    4-tuple conflict detection is done by the network stack:
>> 
>>      system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")
>> 
>>      s = socket(AF_INET, SOCK_STREAM)
>>      s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
>>      s.bind(("192.0.2.1", 0))
>>      s.connect(("1.1.1.1", 53))
>>      # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy
>> 
>>   For UDP this approach has limited applicability. Setting the
>>   IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
>>   port being shared with other connected UDP sockets.
>> 
>>   Hence relying on the network stack to find a free source port, limits the
>>   number of outgoing UDP flows from a single IP address down to the number
>>   of available ephemeral ports.
>> 
>> To put it another way, partitioning the ephemeral port range between hosts
>> using the existing Linux networking API is cumbersome.
>> 
>> To address this use case, add a new socket option at the SOL_IP level,
>> named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
>> ephemeral port range for each socket individually.
>> 
>> The option can be used only to narrow down the per-netns local port
>> range. If the per-socket range lies outside of the per-netns range, the
>> latter takes precedence.
>> 
>> UAPI-wise, the low and high range bounds are passed to the kernel as a pair
>> of u16 values in host byte order packed into a u32. This avoids pointer
>> passing.
>> 
>>   PORT_LO = 40_000
>>   PORT_HI = 40_511
>> 
>>   s = socket(AF_INET, SOCK_STREAM)
>>   v = struct.pack("I", PORT_HI << 16 | PORT_LO)
>>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
>>   s.bind(("127.0.0.1", 0))
>>   s.getsockname()
>>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
>>   # if there is a free port. EADDRINUSE otherwise.
>> 
>> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
>> 
>> v4 -> v5:
>>  * Use the fact that netns port range starts at 1 when clamping. (Kuniyuki)
>> 
>> v3 -> v4:
>>  * Clarify that u16 values are in host byte order (Neal)
>> 
>> v2 -> v3:
>>  * Make SCTP bind()/bind_add() respect IP_LOCAL_PORT_RANGE option (Eric)
>> 
>> v1 -> v2:
>>  * Fix the corner case when the per-socket range doesn't overlap with the
>>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
>
> You silently ignored my review comment.
> Let's repeat it again. Please put changelog after --- marker. Changelog
> doesn't belong to commit message.

I did not. I'm under the impression that you might have missed my follow
up question if the changelog-above-trailer convention is still in place
[1] and the clarification from Jakub K. [2].

I'm happy to adjust the changelog in whichever way that will make
everyone content. However, ATM we don't have one, it seems.

[1] https://lore.kernel.org/all/87sfg1vuqj.fsf@cloudflare.com/
[2] https://lore.kernel.org/all/20230123193526.065a9879@kernel.org/ 
