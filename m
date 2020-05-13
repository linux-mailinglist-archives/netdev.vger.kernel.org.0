Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806861D1B43
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbgEMQkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgEMQkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:40:18 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2AFC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:40:17 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id t3so13917072otp.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=kTrqL2W5DUzgwWBjsWp+2rqR6Sz4mRfsdt8fOfviqVY=;
        b=U2Vel9DTy3faimKlchRNN+YlpfGhiLtYtvARSZigoNEzwx7o4lDy6yDYqEGPhoz7Xf
         c/Wim6FKp8y5N0C27rXyb3KdbklMXb6Db7J4hyUJir/SZ/d+mYzoomwKeh6L2+y+Op4l
         B5UIZdUMkH2wpxBgeZ6fYWloAx7VM2/LTOGsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kTrqL2W5DUzgwWBjsWp+2rqR6Sz4mRfsdt8fOfviqVY=;
        b=nXDWJFpXemtFxxDH2B90cHF/vVHI2ZbgYkrdGHZ6rqmBfB1DAgAgLKerwN8ItVYWoc
         m7tw5AsaaXPWIJu8dLMQqCbIB8PCRx4knb4LlYIV0do3Hk94lSkT3+HP7uMT8rc/VM9A
         qT7Yiy/I7C1tFqKxfaOA/YMS1r5hQxe6VMHp98V96bVFBfVTHZkeCLiyq9jvWyuFsT7P
         NS53tV9fo5J3ibKdehhdk7Um//si4M2e+GYUojDX03AyHZzbFG9sNBlCkbFvTrbdJPkc
         mIH7N4g/qYMcIExqkBq23qZknWhvlcqYpxccgjZeL+55+zVuFJelRij1e6BW8D3EgTRL
         hF5g==
X-Gm-Message-State: AOAM530oLzqZLUKF3MkVUW/tfjfrAHlBU9BJ54eDRN7+nsyekX+B4Kq5
        f4J7ZKCD3aesik9fjylfdHd4hD3GfKhKQ5ApRQ+RHw==
X-Google-Smtp-Source: ABdhPJweyJjdarJGe4tQLA2OEgYISIqXMF2+YpYopeDNkWMbkFpqNjlLBCdkhXcNoxRXC3k61xxi58MCMDX0b2bPglg=
X-Received: by 2002:a9d:70c1:: with SMTP id w1mr154293otj.132.1589388016297;
 Wed, 13 May 2020 09:40:16 -0700 (PDT)
MIME-Version: 1.0
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 13 May 2020 17:40:05 +0100
Message-ID: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
Subject: "Forwarding" from TC classifier
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've recently open sourced a key component of our L4 load balancer:
cls_redirect [1].
In the commit description, I call out the following caveat:

    cls_redirect relies on receiving encapsulated packets directly
from a router. This is
    because we don't have access to the neighbour tables from BPF, yet.

The code in question lives in forward_to_next_hop() [2], and does the following:
1. Swap source and destination MAC of the packet
2. Update source and destination IP address
3. Transmit the packet via bpf_redirect(skb->ifindex, 0)

Really, I'd like to get rid of step 1, and instead rely on the network
stack to switch or route
the packet for me. The bpf_fib_lookup helper is very close to what I need. I've
hacked around a bit, and come up with the following replacement for step 1:

    switch (bpf_fib_lookup(skb, &fib, sizeof(fib), 0)) {
    case BPF_FIB_LKUP_RET_SUCCESS:
        /* There is a cached neighbour, bpf_redirect without going
through the stack. */
        return bpf_redirect(...);

    case BPF_FIB_LKUP_RET_NO_NEIGH:
        /* We have no information about this target. Let the stack handle it. */
        return TC_ACT_OK;

    case BPF_FIB_LKUP_RET_FWD_DISABLED:
        return TC_ACT_SHOT;

    default:
        return TC_ACT_SHOT;
    }

I have a couple of questions:

First, I think I can get BPF_FIB_LKUP_RET_NO_NEIGH if the packet needs
to be routed,
but there is no neighbour entry for the default gateway. Is that correct?

Second, is it possible to originate the packet from the local machine,
instead of keeping
the original source address when passing the packet to the stack on NO_NEIGH?
This is what I get with my current approach:

  IP (tos 0x0, ttl 64, id 25769, offset 0, flags [DF], proto UDP (17),
length 124)
      10.42.0.2.37074 > 10.42.0.4.2483: [bad udp cksum 0x14d3 ->
0x3c0d!] UDP, length 96
  IP (tos 0x0, ttl 63, id 25769, offset 0, flags [DF], proto UDP (17),
length 124)
      10.42.0.2.37074 > 10.42.0.3.2483: [no cksum] UDP, length 96
  IP (tos 0x0, ttl 64, id 51342, offset 0, flags [none], proto ICMP
(1), length 84)
      10.42.0.3 > 10.42.0.2: ICMP echo reply, id 33779, seq 0, length 64

The first and second packet are using our custom GUE header, they
contain an ICMP echo request. Packet three contains the answer to the
request. As you can see, the second packet keeps the 10.42.0.2 source
address instead of using 10.42.0.4.

Third, what effect does BPF_FIB_LOOKUP_OUTPUT have? Seems like I should set it,
but I get somewhat sensible results without it as well. Same for LOOKUP_DIRECT.

1: https://lore.kernel.org/bpf/20200424185556.7358-1-lmb@cloudflare.com/
2: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/test_cls_redirect.c#n509

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
