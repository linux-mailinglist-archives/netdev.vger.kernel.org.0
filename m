Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159D76C592B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCVV5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCVV53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:57:29 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0903400C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 14:57:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s19so6136071pgi.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 14:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1679522246;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oC81s0R4owJzaSrcI/orLq+TNbYR5Abh/d7Znd5bLz0=;
        b=vogXYhqsYqdnydrYCQZzXMcW7MUThgStAm5dM5d6kuL1NMONYhpP24l/HM2zkwDIk3
         vLHqbjohWnLs8AGDFluk9TI7PDe20xPL6CGjVJioO9/nK+3gafFrXkPYWLd5uquFpf3m
         tLEZJXGc7Sd+lnW9P21Wa8h4+hcKaNHAX1v7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679522246;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oC81s0R4owJzaSrcI/orLq+TNbYR5Abh/d7Znd5bLz0=;
        b=e8+Q9vVUJ6Q0hsb4KlITYXq68a+AkbTKSVWBWWrdBzx3Qy27ZwVgzf0SA/K9xCf2H+
         hsMXwn0gKPgtXbz/rri1L1yBfrcCN4Nnw5Et/lqU1S4Wk70WBIyCFw8CQig8eGy8vt5M
         04RKOSAOKZCYbVIk38PgKJksoDE+GbnP4NBIc1HHspMAb9pZNyW5Mq6TzntjxCyBDmxB
         7xhS4HDYvtPtX6t5B/1f/bIa3i/mALxPi4yUD5GKNT5t4lfmUFdDqTOWpM2SB7AV6zdb
         TjR+GOC9hI50WZ77k0E2tuqTwnMe46xYM0l1sb4VOxI/hXV5cnQw/7/wRf+1Lh8aykhL
         nZiQ==
X-Gm-Message-State: AO0yUKVgwtGlXTkyBQVVaHzqXSbumgchruL/cU9RGKLAC+YctYaP3ON5
        5lKTYrwoC7RgfJLErcFv1NQ7kA9DF5DadBoniBSz5L08tq4VsrVBmdIDgg==
X-Google-Smtp-Source: AK7set+S1PW0U9eaFgknLHI2JV/YX63bSNI6bSKvtHdCn71/uCMTSLsLVaN5hhEVwhtOUjP24j3XdYETwdg6EELPlNw=
X-Received: by 2002:a05:6a00:1396:b0:625:dac0:5263 with SMTP id
 t22-20020a056a00139600b00625dac05263mr2647065pfg.0.1679522245911; Wed, 22 Mar
 2023 14:57:25 -0700 (PDT)
MIME-Version: 1.0
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 22 Mar 2023 21:57:14 +0000
Message-ID: <CALrw=nHWdZA=nGizO4hd1xineoNuhN7hh5nGrHFiint1m72afQ@mail.gmail.com>
Subject: Increased UDP socket memory on Linux 6.1
To:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Cc:     kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We were investigating unusual packet drops on our systems potentially
related to our recent migration to the 6.1 kernel. We have noticed a
substantial increase in UDP socket memory for the same workload. Below
are two servers in the same datacentre doing the same workload.

On 5.15.90 (our previous kernel):
$ cat /proc/net/sockstat
sockets: used 174831
TCP: inuse 112301 orphan 145 tw 23829 alloc 135086 mem 313582
UDP: inuse 7613 mem 1667
UDPLITE: inuse 0
RAW: inuse 7
FRAG: inuse 0 memory 0

But on 6.1.20:
$ cat /proc/net/sockstat
sockets: used 168911
TCP: inuse 108857 orphan 124 tw 23674 alloc 130096 mem 235530
UDP: inuse 7555 mem 10514
UDPLITE: inuse 0
RAW: inuse 7
FRAG: inuse 0 memory 0

For roughly the same amount of UDP sockets the UDP memory is much
higher. TCP memory looks different above as well, but according to our
longer-term metrics overall it is the same, but UDP is substantially
bigger.

Here's the snapshot of the same metric from the same servers in
graphical form [1]. The server indicated by a blue line was rebooted
into 6.1.20 and you can see the UDP memory jumped compared to the
green server (on 5.15.90). We're not sure yet, but perhaps it is an
artifact of [2], namely commit 4890b686f4088c90 ("net: keep
sk->sk_forward_alloc as small as possible") and commit
3cd3399dd7a84ada ("net: implement per-cpu reserves for
memory_allocated")

We don't know at this point if it is related to our unusual rate of
packet drops, but just wanted to point this out and see if the UDP
memory increase is expected.

Thanks,
Ignat

[1]: https://pub-ddb0f42c43e74ce4a1424bc33f965f9a.r2.dev/udp-mem.jpg
[2]: https://lore.kernel.org/netdev/20220609063412.2205738-1-eric.dumazet@gmail.com/
