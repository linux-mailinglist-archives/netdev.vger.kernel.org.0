Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50457568EF3
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbiGFQVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiGFQVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:21:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 499601117A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657124472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tJ3zS5MkhznSJR7NYaNGS/m0/ZTyP7XmIwgHtiZrnQM=;
        b=OwNQz6j2jO/bJrz3ojHDAWUjGWbYsPQ5nF7SEKQvbpIwu1ujYvssr1lxIMOdI1F2TDnOTo
        BvsVYpCb3kYUfRNaBgrU3h9oFpv2xVYzSdzHEycZkTdSKJN38M6IUAshjadZB/QjxOZzYE
        oMBn4vh/hV5iF5Snh42W/Po/L3d4skY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-3kzTuNc5PKao_w9ozoccYw-1; Wed, 06 Jul 2022 12:21:10 -0400
X-MC-Unique: 3kzTuNc5PKao_w9ozoccYw-1
Received: by mail-wr1-f69.google.com with SMTP id l11-20020adfbd8b000000b0021d754b84c5so1270519wrh.17
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 09:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tJ3zS5MkhznSJR7NYaNGS/m0/ZTyP7XmIwgHtiZrnQM=;
        b=uVsOMUMrlChF8coCLnaRFwozrBapjopP7WCos6KU00BR6venbgkpNQKkwSH+hvTxzZ
         ZERN08MH6uzq4nO0jIuAlt7TekhTC0U8T05P2sE2osBDC1et29C1r80RASPOOALEN672
         V0cygBKd+36xIf3pkundgmL4bV9gnpQO+VQ1NCCFTD0BxIgIt0yYRH+a7CXFc41HllFF
         iA2KxIQu6usSoPbaohDg0+nI7Po79TiZYnqIyyalsNaBBrFfKCCZPiDVBk6TS00ejiZG
         t4PYY3U9b8HfjyJazzYsl5zeKMj3Cr/Ov3LEAon4+aM8MqKagKZ2dJGzLUMzY8l5WPXS
         11ag==
X-Gm-Message-State: AJIora/Ngpf4HmvlPvAOhCYP7wRB6roxerNp/Lfg/5VCtOPMnYGavqdB
        B0wBm9IeZMzJ39bbaICbsDfascNvEECmDTGRS27SdEQIbJs4BwbLwEwtEfDqwEHsqzk7b0hk6p0
        aX7u3ZalpiROHH+Xh
X-Received: by 2002:adf:f78b:0:b0:21d:6fef:f4e1 with SMTP id q11-20020adff78b000000b0021d6feff4e1mr10719249wrp.92.1657124467517;
        Wed, 06 Jul 2022 09:21:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uHd1YDlAfmJSt4Mdtl/LKix9s4cgZKXi9RhWten78OdN9yhwUgK0DFfpVXi1XssCdKigWe8g==
X-Received: by 2002:adf:f78b:0:b0:21d:6fef:f4e1 with SMTP id q11-20020adff78b000000b0021d6feff4e1mr10719235wrp.92.1657124467248;
        Wed, 06 Jul 2022 09:21:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id b8-20020a05600c4e0800b003974cb37a94sm23450490wmq.22.2022.07.06.09.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:21:06 -0700 (PDT)
Message-ID: <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org
Date:   Wed, 06 Jul 2022 18:21:05 +0200
In-Reply-To: <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
References: <20220627085219.GA9597@debian>
         <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-06 at 09:14 -0600, David Ahern wrote:
> On 6/27/22 2:52 AM, Richard Gobert wrote:
> > The IP_UNICAST_IF socket option is used to set the outgoing interface for
> > outbound packets.
> > The IP_UNICAST_IF socket option was added as it was needed by the Wine
> > project, since no other existing option (SO_BINDTODEVICE socket option,
> > IP_PKTINFO socket option or the bind function) provided the needed
> > characteristics needed by the IP_UNICAST_IF socket option. [1]
> > The IP_UNICAST_IF socket option works well for unconnected sockets, that
> > is, the interface specified by the IP_UNICAST_IF socket option is taken
> > into consideration in the route lookup process when a packet is being
> > sent.
> > However, for connected sockets, the outbound interface is chosen when
> > connecting the socket, and in the route lookup process which is done when
> > a packet is being sent, the interface specified by the IP_UNICAST_IF
> > socket option is being ignored.
> > 
> > This inconsistent behavior was reported and discussed in an issue opened
> > on systemd's GitHub project [2]. Also, a bug report was submitted in the
> > kernel's bugzilla [3].
> > 
> > To understand the problem in more detail, we can look at what happens
> > for UDP packets over IPv4 (The same analysis was done separately in
> > the referenced systemd issue).
> > When a UDP packet is sent the udp_sendmsg function gets called and the
> > following happens:
> > 
> > 1. The oif member of the struct ipcm_cookie ipc (which stores the output
> > interface of the packet) is initialized by the ipcm_init_sk function to
> > inet->sk.sk_bound_dev_if (the device set by the SO_BINDTODEVICE socket
> > option).
> > 
> > 2. If the IP_PKTINFO socket option was set, the oif member gets overridden
> > by the call to the ip_cmsg_send function.
> > 
> > 3. If no output interface was selected yet, the interface specified by the
> > IP_UNICAST_IF socket option is used.
> > 
> > 4. If the socket is connected and no destination address is specified in
> > the send function, the struct ipcm_cookie ipc is not taken into
> > consideration and the cached route, that was calculated in the connect
> > function is being used.
> > 
> > Thus, for a connected socket, the IP_UNICAST_IF sockopt isn't taken into
> > consideration.
> > 
> > This patch corrects the behavior of the IP_UNICAST_IF socket option for
> > connect()ed sockets by taking into consideration the IP_UNICAST_IF sockopt
> > when connecting the socket.
> > 
> > In order to avoid reconnecting the socket, this option is still ignored 
> > when applied on an already connected socket until connect() is called
> > again by the user.
> > 
> > Change the __ip4_datagram_connect function, which is called during socket
> > connection, to take into consideration the interface set by the
> > IP_UNICAST_IF socket option, in a similar way to what is done in the
> > udp_sendmsg function.
> > 
> > [1] https://lore.kernel.org/netdev/1328685717.4736.4.camel@edumazet-laptop/T/
> > [2] https://github.com/systemd/systemd/issues/11935#issuecomment-618691018
> > [3] https://bugzilla.kernel.org/show_bug.cgi?id=210255
> > 
> > Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> > ---
> >  net/ipv4/datagram.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> if the maintainers decide to pick it up.

I think your reasoning is correct, and I'm now ok with the patch. Jakub
noted it does not apply cleanly, so a repost will be needed.
Additionally it would be great to include some self-tests.

It looks like the feature (even the original one, I mean) is IPv4
specific, don't you need an IPv6 counter-part?

Thanks!

Paolo

