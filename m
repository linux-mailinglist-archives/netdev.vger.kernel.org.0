Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F46925B4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjBJSrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbjBJSrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:47:23 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740CF4ED9
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:11 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5005ef73cf3so57389017b3.2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tUD7ZeAAOAkD9jO7WIDk4LQ1CrmBlqsB6j+EihTcGRA=;
        b=bRLvzlXYrajr6cndMryN61WsJTUIoKNTHaheSlDivW8+hEtUGDrioqYEXSphzKpH/W
         zlkLbnKj0KMhp96BY1jRPkR8oDrGxvt5PZHQs05YMhvp8odBJjNFJg+Eq/PXb3nnw22B
         YW8EqOtXW8ILl1WzptTgbAh0vnAaDzSY4MuZq5My769vCf14qzy6GG1hZqZG0SU5/SFQ
         r68pedrFQTFPcbMJT0HPxNXvcwOusCG0ReJBk/y+r9GBlZZ6jMsUtElWyzD+Fk0WTH1y
         h1tb7kJc550gP+1rFxGqFPPgLBmR4eej/nHEJs+wE1pjqKnOKJrKSCbaKQ5k/eIZAoR/
         f9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tUD7ZeAAOAkD9jO7WIDk4LQ1CrmBlqsB6j+EihTcGRA=;
        b=QkSbj4XGXo20F+yx49gBCD/YJn7TPsiWpp5UxObilgtKmkDmDCUQZCSCkzOiZwJQPu
         FvSiCRjh1H1pG8nYsXrBzFXkceD3ouicdz40KOgaiNDMq5LG7xyZ8+fEiG99Jfp9LGJG
         tQEiith8F7eQFmqBY/UuhEXjDQ0bGVInXUB0mzpiCasUz5bBKNyXdwgi4pOtMtJlzAwU
         aFkVELalNyegwME0idUZuNql0De+56e8lM8vVoQnTAvytEQieNaCBFCb834tbWucfLFH
         PJEynKupHo0SlQSPRq1Q/DuuCL8SonZRpAmbVxddqNeYAEX9Aq1yu7REsP7Qu9WdB5FG
         A6bg==
X-Gm-Message-State: AO0yUKWctZZWd3X4nHoCGEj8NL7qrnkinc4z0c0P5HdO1qwgteKUAd/Z
        lnNKxTCpve4eyKxYJm/7/Y4PftZghQQf0Q==
X-Google-Smtp-Source: AK7set+EPOK9kfGwLyKDVh8xvXvwPsoOkIW5HS82wJe2ylzbnG5e3rxyKyIdXjxe4LxIv+TNJtdVZfWvMV+S1w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1b95:0:b0:521:db02:1010 with SMTP id
 b143-20020a811b95000000b00521db021010mr27ywb.0.1676054830181; Fri, 10 Feb
 2023 10:47:10 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:47:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210184708.2172562-1-edumazet@google.com>
Subject: [PATCH net-next 0/4] ipv6: more drop reason
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

Add more drop reasons to IPv6:

 - IPV6_BAD_EXTHDR
 - IPV6_NDISC_FRAG
 - IPV6_NDISC_HOP_LIMIT
 - IPV6_NDISC_BAD_CODE

Eric Dumazet (4):
  net: dropreason: add SKB_DROP_REASON_IPV6_BAD_EXTHDR
  net: add pskb_may_pull_reason() helper
  ipv6: icmp6: add drop reason support to icmpv6_notify()
  ipv6: icmp6: add drop reason support to ndisc_rcv()

 include/linux/skbuff.h   | 19 +++++++++++++++----
 include/net/dropreason.h | 12 ++++++++++++
 include/net/ipv6.h       |  3 ++-
 include/net/ndisc.h      |  2 +-
 net/ipv6/icmp.c          | 27 ++++++++++++++++++---------
 net/ipv6/ndisc.c         | 13 +++++++------
 6 files changed, 55 insertions(+), 21 deletions(-)

-- 
2.39.1.581.gbfd45094c4-goog

