Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117F7313B91
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhBHRw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhBHRu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:50:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDCDC061797
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:50:17 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cl8so8690157pjb.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qscmPxY8INHcD4PaWIz3e7iBultL6HCU68lLM+mYgHc=;
        b=pTLXdZgvMdMdlKXP/Y2xn+o07RFwrDPF82Rg2YAg78b5m5xTorLvp1n0ABAhXwklJf
         cqE3SpljW1HT3pDC04EOABcpUu8kDtqhN95ClCPqrx9FO97c7YnGAx2Bu8Ugnqo7jV5n
         1iGK1okbdkVORs8nUSwe9YQBJvACq/Rw+z1MTesRUlIrmj5MO2ps46+msgxrvTp3rADO
         +EIFfuOws3VKWbGYcaVb6v3WGSOdEkD68n6nPsx1NH4bu1h2NS1+0haiIm1gNqzGHvlZ
         KKwfaV1Lz/sFaBrW7dmRXvaiRhEssnpOlsFuh6I9l3EiQsYQmoPPBeQFpqvsojqEaQc3
         kUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qscmPxY8INHcD4PaWIz3e7iBultL6HCU68lLM+mYgHc=;
        b=jAXm7x7AX6B3cbAkBZoL7SDL+wgE5UpKAjHV3kurM+jZZae+tWbiTaBwb2MZJeqaBL
         sf1PJtu7+5pBoPXLKc24DSu/1L63IPKwBUTf45YUqKGWXX7y0wcHyKNfF5bGox2DJwdH
         zN6TuTKQ6S3xMvoPcl3c2H3knh65FFErHYgsg1rqoRg4iYW5jei5cX/6XKq6uDfGxOlL
         gIGPrZqyVghdgTZlMQ/Xeo2kEHv0fnymp2yhJRLc3gE4YkXUdy1Vq8s1IO74gf6Gm0rg
         JPrk/3YO1CjbZEdmZDo1HPrkqMDY85f75jP4lCXaGkqNLiyn42n/8ZBkX+NeWJBAxtxW
         ruxQ==
X-Gm-Message-State: AOAM531tVCognCLpON2LrMMsimqdYlmB2Z1nPdQ7kJ5oZzbGK+FnL9jw
        AVzBMrEc3zvM5UqOMChigGM=
X-Google-Smtp-Source: ABdhPJzwVs2ZVhL9WKh7oh5rgAs1OXt6iWTDCvpUQnd2tqNmcmy/pNSMH2Obwd+pG6YO0CsYponi+g==
X-Received: by 2002:a17:902:6ac2:b029:de:3560:391e with SMTP id i2-20020a1709026ac2b02900de3560391emr16922702plt.60.1612806617267;
        Mon, 08 Feb 2021 09:50:17 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id t6sm19748186pfe.177.2021.02.08.09.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:50:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/8] mld: change context from atomic to sleepable
Date:   Mon,  8 Feb 2021 17:50:10 +0000
Message-Id: <20210208175010.4664-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset changes context of MLD module.
Before this patch, MLD functions are atomic context so it couldn't use
sleepable functions and flags.
This patchset also contains other refactoring patches, which is to use
list macro, etc.

1~3 and 5~7 are refactoring patches and 4 and 8 patches actually
change context, which is the actual goal of this patchset.
MLD module has used timer API. The timer expiration function is
processed as the atomic context so in order to change context,
it should be replaced.
So, The fourth patch is to switch from timer to delayed_work.
And the eighth patch is to use the mutex instead of spinlock and
rwlock because A critical section of spinlock and rwlock is atomic.

Taehee Yoo (8):
  mld: convert ifmcaddr6 to list macros
  mld: convert ip6_sf_list to list macros
  mld: use mca_{get | put} instead of refcount_{dec | inc}
  mld: convert from timer to delayed work
  mld: rename igmp6 to mld
  mld: convert ipv6_mc_socklist to list macros
  mld: convert ip6_sf_socklist to list macros
  mld: change context of mld module

 .../chelsio/inline_crypto/chtls/chtls_cm.c    |    1 +
 drivers/s390/net/qeth_l3_main.c               |    6 +-
 include/linux/ipv6.h                          |    2 +-
 include/net/if_inet6.h                        |   69 +-
 include/net/ndisc.h                           |   14 +-
 include/uapi/linux/in.h                       |    4 +-
 net/batman-adv/multicast.c                    |    4 +-
 net/dccp/ipv6.c                               |    4 +-
 net/ipv6/addrconf.c                           |    9 +-
 net/ipv6/addrconf_core.c                      |    3 +-
 net/ipv6/af_inet6.c                           |   13 +-
 net/ipv6/icmp.c                               |    4 +-
 net/ipv6/mcast.c                              | 2243 +++++++++--------
 net/ipv6/tcp_ipv6.c                           |    4 +-
 net/sctp/ipv6.c                               |    2 +-
 15 files changed, 1284 insertions(+), 1098 deletions(-)

-- 
2.17.1

