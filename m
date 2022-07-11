Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E9D56D884
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiGKImt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiGKIma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:42:30 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D733911A11
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:42:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 37A2E200A3;
        Mon, 11 Jul 2022 10:42:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EYWOaZEUXThq; Mon, 11 Jul 2022 10:42:04 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F265D2050A;
        Mon, 11 Jul 2022 10:42:03 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E7D9180004A;
        Mon, 11 Jul 2022 10:42:03 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 10:42:03 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Jul
 2022 10:42:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B89663182E41; Mon, 11 Jul 2022 10:42:02 +0200 (CEST)
Date:   Mon, 11 Jul 2022 10:42:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sewook Seo <ssewook@gmail.com>
CC:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        "David S . Miller " <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Sehee Lee <seheele@google.com>
Subject: Re: [PATCH v5 net-next] net: Find dst with sk's xfrm policy not
 ctl_sk
Message-ID: <20220711084202.GO566407@gauss3.secunet.de>
References: <20220707054008.3471371-1-ssewook@gmail.com>
 <20220707100139.3748417-1-ssewook@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220707100139.3748417-1-ssewook@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 10:01:39AM +0000, Sewook Seo wrote:
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
> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED).
> 2. Client tries a new connection on the same TCP ports(src & dst).
> 3. Server will return challenge ACK instead of SYN,ACK.
> 4. Client will send RST to server to clear the SOCKET.
> 5. Client will retransmit SYN to server on the same TCP ports.
> [Expected result]
> The TCP connection should be established.
> 
> Cc: Maciej Żenczykowski <maze@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Sehee Lee <seheele@google.com>
> Signed-off-by: Sewook Seo <sewookseo@google.com>

I'm ok with this from the XFRM point of view, but
can't speak for TCP.
