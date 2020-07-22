Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA95B229CED
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgGVQRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbgGVQRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:17:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DF3C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so3075817ljg.13
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YcCci5oZDTRx2X/8yjdaRKhoWryBvlmTtX6fXcGwwbI=;
        b=opywprfQ8qPOuJPzpjMUMV3i9P66ak+X5KShiDQDZM80sbm61ffQg2OPB/9Drv/LfP
         MKN0uIarAUBAApexD3HZ49vIM4Yzv8+7Jvfc/XI2xe86gmGMrZyaOZWJcotGqTaD7FFX
         C3yXE4AAu4OXUQj11gaLQ+EPjcJ+HFCV0Wk0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YcCci5oZDTRx2X/8yjdaRKhoWryBvlmTtX6fXcGwwbI=;
        b=J7qxLR62aqfoao1Z2RB39/ifdZkz3OZj38Q4/o47Guek2qYNKxLIMji/SdDLGduX1I
         3FcMiuiHWrRwF7KQuYAcVfDXdLmFRLNTqOCc9VuGw3sjV5gJV02PBGQhWiWUcN3a0CZl
         OxUho1hNOeL5ChGoiF7ufTfO58lkGVNJlmfZSyxdDG4OxdAwDk8h01IZDmgJ4IkASgSn
         eUWmVS9duRSjGvOP/zk9np2tezTPd4k+mOvKcjN1UnNjVCipbgKUiuZi4W4PiT5RyVKS
         IBCOYsaQ+jMHANZfqyOX0+G8hdk/alUElDh62S5EP47iMWjl7fwJiKyf2RdR45RVj++a
         XNow==
X-Gm-Message-State: AOAM5326wGkxeVMHXCGDn9OIBwfgZ+kl1KqE0akiJtXNC3TGRFqnI+zT
        sn2h8gBFuBlvm72nbQ/YZVPFqA==
X-Google-Smtp-Source: ABdhPJz/hRyKjb7squ+7NeEyEMA5gDos75a8lA62+aO0eJTFadEqqoQEjH04sn7IScc1oQoKNK5T3Q==
X-Received: by 2002:a2e:81ce:: with SMTP id s14mr7079ljg.57.1595434642560;
        Wed, 22 Jul 2020 09:17:22 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y2sm119806lfh.1.2020.07.22.09.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 09:17:21 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH bpf-next 0/2] Fix BPF socket lookup with reuseport groups with connections
Date:   Wed, 22 Jul 2020 18:17:18 +0200
Message-Id: <20200722161720.940831-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This mini series contains a fix for a bug noticed when analyzing a reported
merge conflict between bpf-next and net tree [0].

Apart from fixing a corner-case that affects use of BPF sk_lookup in tandem
with UDP reuseport groups with connected sockets, it should make the
conflict resolution with net tree easier.

These changes don't replicate the improved UDP socket lookup behavior from
net tree, where commit efc6b6f6c311 ("udp: Improve load balancing for
SO_REUSEPORT.") is present.

Happy to do it as a follow up. For the moment I didn't want to make things
more confusing when it comes to what got fixed where and why.

Thanks,
-jkbs

Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

[0] https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/

Jakub Sitnicki (2):
  udp: Don't discard reuseport selection when group has connections
  selftests/bpf: Test BPF socket lookup and reuseport with connections

 net/ipv4/udp.c                                |  5 +-
 net/ipv6/udp.c                                |  5 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 54 ++++++++++++++++++-
 3 files changed, 55 insertions(+), 9 deletions(-)

-- 
2.25.4

