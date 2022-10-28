Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730DC6112C5
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJ1Na6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiJ1Naw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:30:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94448173FFC
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36fc0644f51so43957517b3.17
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R9E3bNvLrMpwdfb/QzYb6NZZXWEscrAEsan6x+L7n0k=;
        b=adnINpwz2+qPCwSPbG/cgScrGvFny2Rci8DfoWjhisFfihMlOk2iRXPttecq+NEUBM
         k7Afs2+IWta1RjlQCB4YE5gfu54Rr3ESRMn9AOSJARNrmCtRYuInns8fHv7JCUv6hrqS
         GqnyBV3Oinv0koN69iGekJ5JKaOls8nhJUAJQ8VInBY/j7wTcci5G0Pnq9DTWQPqTt4T
         o6AdB0G+jSzg8tblytDM8wUO4OBvSODqhi2mLUgM+I1QN2lvRiW+kWb/D0IetV9QFcXN
         HFW9R4BzZa6ylCWhps7sv3RVY3JrhSvoCZFN16CJoHvNShSHXTYZivGJ8ZiXd8rMOq58
         LQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R9E3bNvLrMpwdfb/QzYb6NZZXWEscrAEsan6x+L7n0k=;
        b=5ZroM/k/qJYNA0w3mGwRUPsXHnf30PjC1WAAAH4wAqhWnVXetEuoKgusBnFo6HRZcx
         xQI94y00RP5ZScIDaynP1S3EAVlvLROgthF4g3Ora2kwiW/dbzHb6KJSAkbLXxojX0FP
         1mysKzfUkQXrJoGz15qd4TcOxU0Wz7oWFumiNyosKYBXnAK6p6+wBU7HbpJ9Vox3Y+7V
         yyZ3GIZ5RKMTVpfns9HhjHta393lTQ7W0qmpRred65+xYiU0n0S5ssZc8aBaySMrGNh3
         kSLoPpz3LGx9gpx72rjQLnFrhAGoVEZKp44HEwmnsP1IMosWZDTuCX18vIHeLOOweKkr
         bd7Q==
X-Gm-Message-State: ACrzQf20g2Fah6VS8aCZB2SKkqTGoIgEbav7uhU3c4os+3syauTznwRx
        oDgkPVy/2XNndp2Yn9vwmj5ThZM7Rj7LuA==
X-Google-Smtp-Source: AMsMyM4UACppUNhHe1RlRgT56/GNfPivDk0WLBBwfwAqpQmNDHwqv2ZX3esHXCr8yhR5C9cI5QzdEgICnzk1CA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:10c4:b0:6cb:8aea:5f42 with SMTP
 id w4-20020a05690210c400b006cb8aea5f42mr0ybu.612.1666963847026; Fri, 28 Oct
 2022 06:30:47 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:30:38 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028133043.2312984-1-edumazet@google.com>
Subject: [PATCH net-next 0/5] inet: add drop monitor support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

IPv4 and IPv6 reassembly units are causing false kfree_skb()
notifications. It is time to deal with this issue.

First two patches are changing core networking to better
deal with eventual skb frag_list chains, in respect
of kfree_skb/consume_skb status.

Last three patches are adding three new drop reasons,
and make sure skbs that have been reassembled into
a large datagram are no longer viewed as dropped ones.

Eric Dumazet (5):
  net: dropreason: add SKB_CONSUMED reason
  net: dropreason: propagate drop_reason to skb_release_data()
  net: dropreason: add SKB_DROP_REASON_DUP_FRAG
  net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
  net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR

 include/net/dropreason.h                | 14 ++++++++++++
 include/net/inet_frag.h                 |  6 ++++-
 include/net/ipv6_frag.h                 |  3 ++-
 net/core/skbuff.c                       | 30 ++++++++++++++-----------
 net/ipv4/inet_fragment.c                | 14 ++++++++----
 net/ipv4/ip_fragment.c                  | 19 +++++++++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   | 13 +++++++----
 8 files changed, 71 insertions(+), 30 deletions(-)

-- 
2.38.1.273.g43a17bfeac-goog

