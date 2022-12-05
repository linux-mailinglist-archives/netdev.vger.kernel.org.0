Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539E86425B7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiLEJX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiLEJXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:23:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D995B9
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670232140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpHSIT71aPbIpJ11tJPadV7DNh1RKePeuvvcXPGN05o=;
        b=KTdxNxlVDotEqJVbvC+7A37jvOPCBG4bmCKHE4IHNmZd7hmjElUAfZFUIAjX85/3a4EfLC
        voUGztKYp7+i7t7sEXhASU4d4b7b2l/1b+Vu7rhAl72IpnH4qecifAtan7lPfL2wE5tbAP
        CsL/RCSJmdjhj9I0Ep18GW6hkfuQX1I=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-4mSupBXCMq-nciFWB5_t8Q-1; Mon, 05 Dec 2022 04:22:18 -0500
X-MC-Unique: 4mSupBXCMq-nciFWB5_t8Q-1
Received: by mail-ej1-f69.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so696600ejc.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wpHSIT71aPbIpJ11tJPadV7DNh1RKePeuvvcXPGN05o=;
        b=CvUOPhqORChjQAEPV3ony0uNpZa2kT6lh3t4onUZduos8rRODgCI4bjjyDJWpPGuWD
         BPPXcRTNxjuTlJhMWGyPNfV708rWLae8N4MOBUxXWVmrsRYeXkINcEjDfWaDAy2Jx5pT
         qF1G4m3Vqc9I25w8AHAaKFw2Y35X/wGm3yKWDg4066AfEGCd7nRuJ7zqFPpJ2/U2oRlW
         bUhrqgkj6p+cB6MD1aYicYIYziViYHvW2ZyZdSR/1LZ3qgMT8n361ZnNDQJ3dZsUfJfX
         zhuWSe7QM3hWIdzkFm8CRLAWNOlw+bceA9tp4itVSwYmcS1+k4QQ6Lda3rlGTAd/gWsx
         qHOw==
X-Gm-Message-State: ANoB5pkbFbPR7aqCyA5zL6oKlUwI8qW9d4rFv5b9+H1KOunT++uSSlOI
        3hWu95b3AlSVWCMsKsMx1HvwfX+RDAzLBot3iAfsHcvN8FIlVWahYk9AvOIn8yd1ELCKGYOBfEY
        6RroprJXf5sFeXJk9
X-Received: by 2002:a17:906:fc9:b0:7ae:ef99:6fb2 with SMTP id c9-20020a1709060fc900b007aeef996fb2mr68019879ejk.761.1670232136939;
        Mon, 05 Dec 2022 01:22:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4/g8UyaTqIzNCTJBnwP8F+FMgZxlFT0KeLXMGm2vErvuEBOqDPOczXOntNCfZjgG2KKmrOYw==
X-Received: by 2002:a17:906:fc9:b0:7ae:ef99:6fb2 with SMTP id c9-20020a1709060fc900b007aeef996fb2mr68019863ejk.761.1670232136682;
        Mon, 05 Dec 2022 01:22:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-166.dyn.eolo.it. [146.241.105.166])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906318900b007b839689adesm6008400ejy.166.2022.12.05.01.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:22:16 -0800 (PST)
Message-ID: <216de1827267077a19c5ed3e540b7db74afd1fc0.camel@redhat.com>
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>,
        Kirill Tkhai <tkhai@ya.ru>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 05 Dec 2022 10:22:15 +0100
In-Reply-To: <53BD8023-E114-4B3E-BB07-C1889C8A3E95@amazon.co.jp>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
         <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
        ,<b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
         <53BD8023-E114-4B3E-BB07-C1889C8A3E95@amazon.co.jp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-12-02 at 23:18 +0000, Iwashima, Kuniyuki wrote:
> 
> > On Dec 3, 2022, at 7:44, Kirill Tkhai <tkhai@ya.ru> wrote:
> > > On 01.12.2022 12:30, Paolo Abeni wrote:
> > > > On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
> > > > There is a race resulting in alive SOCK_SEQPACKET socket
> > > > may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> > > > 
> > > > unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
> > > >  sock_orphan(peer)
> > > >    sock_set_flag(peer, SOCK_DEAD)
> > > >                                           sock_alloc_send_pskb()
> > > >                                             if !(sk->sk_shutdown & SEND_SHUTDOWN)
> > > >                                               OK
> > > >                                           if sock_flag(peer, SOCK_DEAD)
> > > >                                             sk->sk_state = TCP_CLOSE
> > > >  sk->sk_shutdown = SHUTDOWN_MASK
> > > > 
> > > > 
> > > > After that socket sk remains almost normal: it is able to connect, listen, accept
> > > > and recvmsg, while it can't sendmsg.
> > > > 
> > > > Since this is the only possibility for alive SOCK_SEQPACKET to change
> > > > the state in such way, we should better fix this strange and potentially
> > > > danger corner case.
> > > > 
> > > > Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
> > > > to fix race with unix_dgram_connect():
> > > > 
> > > > unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
> > > >                                       unix_peer(sk) = NULL
> > > >                                       unix_state_unlock(sk)
> > > >  unix_state_double_lock(sk, other)
> > > >  sk->sk_state  = TCP_ESTABLISHED
> > > >  unix_peer(sk) = other
> > > >  unix_state_double_unlock(sk, other)
> > > >                                       sk->sk_state  = TCP_CLOSED
> > > > 
> > > > This patch fixes both of these races.
> > > > 
> > > > Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
> > > 
> > > I don't think this commmit introduces the issues, both behavior
> > > described above appear to be present even before?
> > 
> > 1)Hm, I pointed to the commit suggested by Kuniyuki without checking it.
> > 
> > Possible, the real problem commit is dc56ad7028c5 "af_unix: fix potential NULL deref in unix_dgram_connect()",
> > since it added TCP_CLOSED assignment to unix_dgram_sendmsg().
> 
> The commit just moved the assignment.
> 
> Note unix_dgram_disconnected() is called for SOCK_SEQPACKET 
> after releasing the lock, and 83301b5367a9 introduced the 
> TCP_CLOSE assignment.

I'm sorry for the back and forth, I think I initally misread the code.
I agree 83301b5367a9 is good fixes tag.

> > 2)What do you think about initial version of fix?
> > 
> > https://patchwork.kernel.org/project/netdevbpf/patch/38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru/
> > 
> > Despite there are some arguments, I'm not still sure that v2 is better.

v1 introduces quite a few behavior changes (different error code,
different cleanup schema) that could be IMHO more risky for a stable
patch. I suggest to pick the minimal change that addresses the issue
(v2 in this case).

Thanks,

Paolo

