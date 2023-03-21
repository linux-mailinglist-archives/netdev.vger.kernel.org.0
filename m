Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95906C28FB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCUEGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCUEGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:06:13 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B623D0B3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5419fb7d6c7so140867737b3.11
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679371277;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rtUNITpGKJsM1ShGkXz8m7Fb24wRIdarlQgaEtFBVrc=;
        b=tYI1xzErKmKnQ6ropgUep9bc0kEXqVKaKilIqt6EweLZqCdtrXzgbJ7i79l9RJ7aGi
         rgJj6ZaP6FYF6LKIG8Ye9FAcbNUEal3qr32XqwXtDqT2BFD6PfQfomsIi5pEEnpnhAYY
         1zjFHHFMcBRukkX26VLKLsOvwKF2uSX6/PPQmW+GAkBVPt2egQRK70AbHTOTB3YRi+Z/
         4j9d0Al6az8YVhVjlUudguhSA9A9G03+FmwgIE/VIquVGxRTyDM4lq1IceIEn8dhFKnC
         p1FsdHdzPpWhVTOosDq0TFV7hDVbPdwGdY+/crGq5a70bkIuLHasSaV0ZyGP9wMuIUdx
         z9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679371277;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rtUNITpGKJsM1ShGkXz8m7Fb24wRIdarlQgaEtFBVrc=;
        b=CY+4G9+hChoFDyxRPbhfww9zwFd7qun1QpxBfVDz5LJ0LlTb+EclblASc3HHs/LfIV
         FTuln/ThoKKP2pPRBbDehMSExIL6A3ZmqBDyChCenCu1zTMzKv7maEL9hcaEK+edT+Z+
         wAkjf//Xdb5Er65DeGp3cTFBIVCyPdsG2Le3RR2TkgAz7EcEaOB6hKUIfw1YEM/TKOkI
         m3FcE3PjwNCHAKkldHeBl5/J5zIGPgw01m1EffdTg0rvPEePMoHVvhU2uJFCFA16adA9
         b+KDROvuC6GPprCttlTikOHMp8yYBUOh5Pd1YOf7HeixvPGCPMh9WhRN4j05bSFxI95U
         JYxQ==
X-Gm-Message-State: AAQBX9dybtFW5LcOEMWSme6XWuMF8OyK32C/GoLV2QPTne9SNm1roLBH
        w7I8u2xGSWFSmJbvY7HOC/RYD/uGcVFkEg==
X-Google-Smtp-Source: AKy350bG7CZXhPjNMy601+a49WFpK7oD5/+WxNTNXf2VR08eRWX3WWXoz1qzQ44zxcllvApa++edR2FPf54XKg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1083:b0:a8f:a6cc:9657 with SMTP
 id v3-20020a056902108300b00a8fa6cc9657mr412680ybu.7.1679371277152; Mon, 20
 Mar 2023 21:01:17 -0700 (PDT)
Date:   Tue, 21 Mar 2023 04:01:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321040115.787497-1-edumazet@google.com>
Subject: [PATCH net-next 0/3] net: remove some rcu_bh cruft
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point using rcu_bh variant hoping to free objects faster,
especially hen using call_rcu() or kfree_rcu().

Disabling/enabling BH has a non-zero cost, and adds distracting
hot spots in kernel profilesm eg in ip6_xmit().

Eric Dumazet (3):
  ipv6: flowlabel: do not disable BH where not needed
  neighbour: switch to standard rcu, instead of rcu_bh
  net: remove rcu_dereference_bh_rtnl()

 include/linux/rtnetlink.h | 10 ------
 include/net/arp.h         |  8 ++---
 include/net/ndisc.h       | 12 ++++----
 include/net/neighbour.h   |  6 ++--
 include/net/nexthop.h     |  6 ++--
 net/core/filter.c         | 16 ++++++----
 net/core/neighbour.c      | 64 +++++++++++++++++++--------------------
 net/ipv4/fib_semantics.c  |  4 +--
 net/ipv4/ip_output.c      |  6 ++--
 net/ipv4/nexthop.c        |  8 ++---
 net/ipv4/route.c          |  4 +--
 net/ipv6/addrconf.c       | 14 ++++-----
 net/ipv6/ip6_flowlabel.c  | 51 ++++++++++++++++---------------
 net/ipv6/ip6_output.c     | 10 +++---
 net/ipv6/route.c          | 12 ++++----
 15 files changed, 114 insertions(+), 117 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

