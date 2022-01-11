Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D440248A4E9
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346207AbiAKBYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243319AbiAKBYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:46 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C834C06173F;
        Mon, 10 Jan 2022 17:24:45 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id e5so9972635wmq.1;
        Mon, 10 Jan 2022 17:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ANct+OguCBO1Gd754vKRRXoiagvg224CngFA+Tt5aZ8=;
        b=d+RSDxzE4pZrAVrueFy/DDFZbzCAhR43h2TWL2KYcv97RG2fUgvx0+GRrbcctDJnkC
         dE2bF1j+mC96kqyy2kX6mYOD2/025jKe61U7KHPA6t+WFxBn+8OYxiaSTyCG8mB/PXGy
         8H0T0VLzsog1cdbNHcotiuQVOVmMIZN+nAUxoIBtguoqm97yPseCZ9cc8XnjOMHq3X6s
         3gXYxYHMQHsxgUuWPKBXNATttQ7alAwy8WVuw0NYRhndpr8133+S1mquM/Uxg3Cc1iQL
         7XaS12rwNeLM1BN/HOOhLBVWBJd9tZy2loOZYFkkRaWXkjUWAT+J/0nP53q6gVfvF5u6
         KqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ANct+OguCBO1Gd754vKRRXoiagvg224CngFA+Tt5aZ8=;
        b=itZiT76NGmQ03y7LCqeUpg0wZ5E6lKfJGKHNYGGzNKz6fpdR+wiDmJMNJIU5d83Zk6
         ofZqQC0TrOhhNiHjeKIBMv97VDzXX4gOkbFSa6f7Wrc+TEu7M/0pFLASkuInDO73WBl3
         gKzgI4vnlWsIAkCBWbUdorXdEz8e/gvCHFLJShCAVmNJx5Oen34OsaAau6aG3ZKvrkrb
         Z/KGOsoeTJJlMrDAEBGuifze6NrYxY10B5MD4+FvSL7eChl4q66thrcYTRfrdmSLIAvM
         zmZvDtPkabWv3CqBI/u00vGldBcmkgzMAC9kb1CQwul4qgi8wEfQyMdmZr5EP4YiJ+dn
         k9RA==
X-Gm-Message-State: AOAM5330FlYsJPibIlgc5G3A9D7XI4JIGiJiN9JD+HwJc+VHbUlPNby2
        5l/k2QO2ZuHV6RMmboezhcFsMpIXc9g=
X-Google-Smtp-Source: ABdhPJx7E+i0EBz37yl8aOmzJpWPSm6RxVW3JsPhDVnDdRZy9EdTUTHDKZNxLUst+Ge3rscQrXktSQ==
X-Received: by 2002:a05:600c:4e11:: with SMTP id b17mr337857wmq.66.1641864283998;
        Mon, 10 Jan 2022 17:24:43 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 00/14] udp optimisation
Date:   Tue, 11 Jan 2022 01:21:32 +0000
Message-Id: <cover.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mainly UDP/IPv6 optimisation patch set. Zerocopy io_uring benchmark over
dummy netdev (CPU bound) gives 2068992 -> 2166481 tx/s, which is ~4.7% or
over 5% of net layer overhead. Should give similar results for small
packet non-zerocopy.

- 1/14 and 9/14 remove a get/put dst pair each, so saving 4 atomics per
  corkless UDP send.
- Patches 3-8 optimise iflow handling, in particular removes one 88B
  memset and one 88B copy.
- 10-14 are random improvements, which are not UDP-specific but also
  beneficial to TCP and others.

Pavel Begunkov (14):
  ipv6: optimise dst referencing
  ipv6: shuffle up->pending AF_INET bits
  ipv6: remove daddr temp buffer in __ip6_make_skb
  ipv6: clean up cork setup/release
  ipv6: don't zero cork's flowi after use
  ipv6: pass full cork into __ip6_append_data()
  ipv6: pass flow in ip6_make_skb together with cork
  ipv6/udp: don't make extra copies of iflow
  ipv6: hand dst refs to cork setup
  skbuff: drop zero check from skb_zcopy_set
  skbuff: drop null check from skb_zcopy
  skbuff: optimise alloc_skb_with_frags()
  net: inline part of skb_csum_hwoffload_help
  net: inline sock_alloc_send_skb

 include/linux/netdevice.h |  16 +++++-
 include/linux/skbuff.h    |  45 +++++++++++++---
 include/net/ipv6.h        |   2 +-
 include/net/sock.h        |  10 +++-
 net/core/dev.c            |  15 ++----
 net/core/skbuff.c         |  34 +++++-------
 net/core/sock.c           |   7 ---
 net/ipv4/ip_output.c      |  10 ++--
 net/ipv4/tcp.c            |   5 +-
 net/ipv6/ip6_output.c     | 105 +++++++++++++++++++++-----------------
 net/ipv6/udp.c            | 103 ++++++++++++++++++-------------------
 11 files changed, 197 insertions(+), 155 deletions(-)

-- 
2.34.1

