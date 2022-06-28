Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A444055E40A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346077AbiF1NJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346088AbiF1NJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 982F4E020
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656421738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZdkM7xNQCB8WJiOU6TaPTrWUiWFK0Uh4eXtRd7/nq2Q=;
        b=W/7cpHMttP8HqPj+Dpj+eD4LDdf5fASn0UX1bjcyctVfpbMzXGMC27trMtjea104HB1mJ8
        YcoU9pI6ZOE54vfQJAtU5IvpntH+fHfYCe1gHBxw/Mt3xnWbpojvfaS9AUYAJIv2ziOQjb
        DPrhTSaChgQAI27mqn6Xg9Q9YNKMwog=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-yTcKxM7uNQK8EsfY-uSHOg-1; Tue, 28 Jun 2022 09:08:53 -0400
X-MC-Unique: yTcKxM7uNQK8EsfY-uSHOg-1
Received: by mail-wm1-f72.google.com with SMTP id j19-20020a05600c191300b003a048196712so3751520wmq.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:08:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZdkM7xNQCB8WJiOU6TaPTrWUiWFK0Uh4eXtRd7/nq2Q=;
        b=rIymF7gzTXR5Yhw/KtrfyDFmKZZmnMkohEnsFpIEAyFqQWj+V1xBMq8WP9yvjFi9s9
         TxugaVXvl1hsZze+oVVw51GOhZrcrudTWmmCncsrbC1gftx7SWnWA1sFdjkIQYinpWRG
         sLFXmb9qTkzlJcgSt+EZdj3FM0M1uIfZ6vderQO5PLob5sure9c/rO4EztjPTAtIPHEq
         yicqS05CQXxbc34K9dFyDNZbvfA/UNEzRnky4vxbhk36MKDvIwD1/AhKpULbWO3ySNMi
         ecerIosG+Q9IxOVrTm+eU2rpLcZk6yyehbxB9Uy/oh/UZBMcF9mVP0U/nlYwdnTUP4I7
         /nTg==
X-Gm-Message-State: AJIora/sw1jElHFuZZaBMEoh+rRBxCdHo5cC/ViH3wiOB+N+/gYXtI77
        u9KVyZQVKDJqa2FBYnPJ7Dmo11r5hhHkoQmqM7nofnL2C6/kFK7GADOFzRk/nsjerJ1y4QfG2uv
        xcY5f4YaTGmvFVE7k
X-Received: by 2002:a05:600c:1f05:b0:39c:51c6:7c85 with SMTP id bd5-20020a05600c1f0500b0039c51c67c85mr26320806wmb.33.1656421730888;
        Tue, 28 Jun 2022 06:08:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u65OGcoVpf8srZ4xW5OrfUWUCdFhEHT180xcV4M3SLIBs8yEQXys4B5junvyVh6I8h1kX+AA==
X-Received: by 2002:a05:600c:1f05:b0:39c:51c6:7c85 with SMTP id bd5-20020a05600c1f0500b0039c51c67c85mr26320771wmb.33.1656421730568;
        Tue, 28 Jun 2022 06:08:50 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-110.dyn.eolo.it. [146.241.115.110])
        by smtp.gmail.com with ESMTPSA id g16-20020a1c4e10000000b0039c5a765388sm17257018wmh.28.2022.06.28.06.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:08:50 -0700 (PDT)
Message-ID: <80b97cf6d0591c615a229d754805d989be9183bc.camel@redhat.com>
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 28 Jun 2022 15:08:48 +0200
In-Reply-To: <20220627085219.GA9597@debian>
References: <20220627085219.GA9597@debian>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-27 at 10:52 +0200, Richard Gobert wrote:
> The IP_UNICAST_IF socket option is used to set the outgoing interface for
> outbound packets.
> The IP_UNICAST_IF socket option was added as it was needed by the Wine
> project, since no other existing option (SO_BINDTODEVICE socket option,
> IP_PKTINFO socket option or the bind function) provided the needed
> characteristics needed by the IP_UNICAST_IF socket option. [1]
> The IP_UNICAST_IF socket option works well for unconnected sockets, that
> is, the interface specified by the IP_UNICAST_IF socket option is taken
> into consideration in the route lookup process when a packet is being
> sent.
> However, for connected sockets, the outbound interface is chosen when
> connecting the socket, and in the route lookup process which is done when
> a packet is being sent, the interface specified by the IP_UNICAST_IF
> socket option is being ignored.
> 
> This inconsistent behavior was reported and discussed in an issue opened
> on systemd's GitHub project [2]. Also, a bug report was submitted in the
> kernel's bugzilla [3].
> 
> To understand the problem in more detail, we can look at what happens
> for UDP packets over IPv4 (The same analysis was done separately in
> the referenced systemd issue).
> When a UDP packet is sent the udp_sendmsg function gets called and the
> following happens:
> 
> 1. The oif member of the struct ipcm_cookie ipc (which stores the output
> interface of the packet) is initialized by the ipcm_init_sk function to
> inet->sk.sk_bound_dev_if (the device set by the SO_BINDTODEVICE socket
> option).
> 
> 2. If the IP_PKTINFO socket option was set, the oif member gets overridden
> by the call to the ip_cmsg_send function.
> 
> 3. If no output interface was selected yet, the interface specified by the
> IP_UNICAST_IF socket option is used.
> 
> 4. If the socket is connected and no destination address is specified in
> the send function, the struct ipcm_cookie ipc is not taken into
> consideration and the cached route, that was calculated in the connect
> function is being used.
> 
> Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken into
> consideration.
> 
> This patch corrects the behavior of the IP_UNICAST_IF socket option for
> connect()ed sockets by taking into consideration the IP_UNICAST_IF sockopt
> when connecting the socket.

This also changes a long-established behavior for such socket option.
It can break existing application assuming connect() is not affected by
IP_UNICAST_IF. I'm unsure we can accept it.

Cheers,

Paolo

