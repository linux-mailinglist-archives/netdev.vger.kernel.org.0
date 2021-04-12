Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83D535C941
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238789AbhDLOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhDLOzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 10:55:53 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81D6C06174A
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 07:55:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w18so15508926edc.0
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 07:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=p3fb0bGRJDa+gWnEG9CcLy9+XO75ZHFp+z6HBxZm4ZU=;
        b=WMDcIvmlJAbBCe9phjMjBBKOFyuv3ADN5tzRRkFKsrqrb/VyuftpraN+UVKIPUD4zF
         cABDi1sa25owXxenOa376HindbvGNY0CZ4kABhDCP8OKam75qIKCSaNlJ+TOPx1iwREg
         ofdY+/8Z+7gLf6kV0NUWvM/nm3MLOGctqVjFffEgEdmW/0RwKefSC6ZeQTIOwsvcTE1i
         4+MVPGszAr5q21qSQCR5tYoP8Fek/L+rLLXWO/DU31vCty/k/S1BvYx3qUfxEGLwxEwO
         We7tuAMa8v0icRrYYtCmr1TsWZbOpDqyPBhdyL9A3awv14uOf0Gcgz3Nyq7JKfBwQf08
         /pGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p3fb0bGRJDa+gWnEG9CcLy9+XO75ZHFp+z6HBxZm4ZU=;
        b=dJlb8TGdCEgSDcr9Ze9LfjNXfM+R3Ht49ZzqpCxTk8pid+p/Edwlj+9XCma+mAWB49
         THye/Df1JMZITSwKnbxPxI5TyKRqt+Z7/Z4t/jpr3xjgoS8sW/oHtb0dXP2pZYPqEjtI
         0AsMOHnX+BQkSV1zNY7ZcMTOEhakF5du2/TV92uoSB0dZh78Rwb7CD0Km5cbQ0Iv6uxD
         7T99Ea+x1ZhHJpUCEc9FkY1r7w9udnwGID/uvtT6cORSg1hopBlhMWojzI3SHmqWXYOf
         c3Yy32RevTrbih2GUJLSk2T5xcrjvyCkeNr6QDhVgkWESWS6mBmnNqbgKabXJo53D0od
         tZyw==
X-Gm-Message-State: AOAM530Gnot3nZWNo6nQ8Gm0FKiVjcX8DNZSkexV8VLoNl5tltU6886a
        0L6pMkrEfVB4xnsFvm8wnNe0Kkpj+/DVa+gDgo1lDJTrxEY=
X-Google-Smtp-Source: ABdhPJw3E2CaojH6VKVs8ACPHF/5F33gJEmG8Pi6vVPY1FcEhbZBe8H30pI+PIYDV8zH7ad6rim5nsbzl6C049f8V2k=
X-Received: by 2002:a50:aad9:: with SMTP id r25mr30033375edc.125.1618239334221;
 Mon, 12 Apr 2021 07:55:34 -0700 (PDT)
MIME-Version: 1.0
From:   Jax Jiang <jax.jiang.007@gmail.com>
Date:   Mon, 12 Apr 2021 22:55:22 +0800
Message-ID: <CAGCQqYa5kGxso9AcKzi0Nke+Gv2o2vwG1qMTXbk-5WHFFURe6w@mail.gmail.com>
Subject: [BUG] Thunderbolt network ip forward package drop problem.
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.
I am geek and try to build 10G NIC and thunderbolt network software router.
And I found there have some performance problem on Linux thunderbolt network.

10G NIC -> Linux Kernel -> Thunderbolt Network: downstream speed about 8-9Gbps
Thunderbolt Network -> Linux Kernel -> 10G NIC: upsteam speed only just 1Mbps.

OS: OpenWRT 19.07 (I also tested ubuntu got same result)
Kernel Version: 5.10.27 (I also tested Linux 5.12-rc4 got same result)
These days I try to learn and understand Linux network stack process.
And I found there have two MTU check codes on ip forward process.
1. In net/ipv4/ip_forward.c :
    if (ip_exceeds_mtu(skb, mtu)) {
        IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
        icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
              htonl(mtu));
        goto drop;
    }
2. In net/ipv4/ip_output.c:
      if (unlikely(!skb->ignore_df ||
             (IPCB(skb)->frag_max_size &&
              IPCB(skb)->frag_max_size > mtu))) {
        IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
        icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
              htonl(mtu));
        kfree_skb(skb);
        return -EMSGSIZE;
    }
Both two codes cause if found package bigger than MTU it will send
icmp "ICMP_FRAG_NEEDED" msg to client.
And I capture package by use tcpdump. And I confirmed there have
"unreachable - need to frag (mtu 1416)" icmp
package back.
I try to force remove both two codes(only remove one of them are not
work). And upsteam speed looks slightly normal. (UP TO 3Gpbs not just
1Mbps).
I capture package on normal 10GNIC: Because of TSO, Kernel received
bigger than mtu package. But on transmit side, it auto split to mtu
size package. On thunderbolt network, looks received TSO large package
not automatic split before ip forward.

I found where package drop on thunderbolt network. But I still don't
know why cause that. And how to solve it.

Could anyone help me?


Jax Jiang
