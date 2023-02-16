Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5FE699A01
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBPQ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPQ3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:12 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8C02CC7E
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:11 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id l21-20020ac81495000000b003bd0d4e3a50so1002781qtj.9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676564950;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=390RJCzyrpoqTFGNC1vLcpxExQ9kyO3GLov4pUpGmzo=;
        b=Ezt/dWV2dnsTxfyI2RgaTUtH0+w6TImRZ30kd4BQ/PTcfZv5GWJ9vX5uXaUr/Jb+9z
         KH+fm54MDiyev/FgBpGJngQdRx4kMPqREJUn2PR2kSi0tJnx7HodazVuXa8IudpMeO2j
         pyEoD2eQFBkQ+HNo1AzqxhvNRRHeKwZIAqLu+wkHkNpYGdqIYISDl+vxp1E3QDYLmRrl
         ASK4RH91cvpQrCdsVwjlhnSGZOkRtN3kPZIptDqX5cJc4KkD2Y1aUApvjLgriViPxF+7
         FugzPElweDrBzE5dqZ2t6Uj0246gd/qneAdaKKHsSyBnD2ExZtbavSm0QV2YDLibZimc
         XxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676564950;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=390RJCzyrpoqTFGNC1vLcpxExQ9kyO3GLov4pUpGmzo=;
        b=y5eIJiT2DK0s5WZLOt/upVOVMk6DM7+CABKXpfecIhU8h/JhevEyy57N3aUxliaAXp
         3rqIeeg9odyDd3XG8F0fJoAd05TzGZeeDXTdUuBfCKiPyX2FrgfIDhKY1JqOx9DgLvyY
         9HPckHevvt3XrF1FuYsZB99+4yMDCxTf0bG6mGmRrK6dhVHMP/j4IM+0n05ynr9nFUGA
         H3/uCaMDjOoHtOgLmIRqYgGA/RkyMY/hnVq5S+w9gzxDWadT+yG28q4aeEB4PRkY5uev
         oJX1HyyNdE4Aie8+uDryIrg7VhwXpL2v6JKFBLGYZuCFyKIC/2FUYFXwXyu88hLPEGvS
         Kiww==
X-Gm-Message-State: AO0yUKWx5HEnt8lo5FcFnsqjit81/vOFsLA7HIro+bHbSDn2aOPH2AR6
        ahcnvs0nYpP+6CK4+XIhoKCk3OZ1H53h3Q==
X-Google-Smtp-Source: AK7set/jK8pV0tIq2Oaa9TVQolwGXz6AooAwM4m4QYucFL2P1mPniL+GtKtPlWUb9/EuzZRDzALmijc7VAAffg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0c:de09:0:b0:56b:8a42:d698 with SMTP id
 t9-20020a0cde09000000b0056b8a42d698mr488318qvk.54.1676564950656; Thu, 16 Feb
 2023 08:29:10 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-1-edumazet@google.com>
Subject: [PATCH net-next 0/8] ipv6: icmp6: better drop reason support
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

This series aims to have more precise drop reason reports for icmp6.

This should reduce false positives on most usual cases.

This can be extended as needed later.

Eric Dumazet (8):
  ipv6: icmp6: add drop reason support to ndisc_recv_ns()
  ipv6: icmp6: add drop reason support to ndisc_recv_na()
  ipv6: icmp6: add drop reason support to ndisc_recv_rs()
  ipv6: icmp6: add drop reason support to ndisc_router_discovery()
  ipv6: icmp6: add drop reason support to ndisc_redirect_rcv()
  ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS
  ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST
  ipv6: icmp6: add drop reason support to icmpv6_echo_reply()

 include/net/dropreason.h |   8 ++
 net/ipv6/icmp.c          |  13 ++--
 net/ipv6/ndisc.c         | 155 ++++++++++++++++++++-------------------
 3 files changed, 94 insertions(+), 82 deletions(-)

-- 
2.39.1.581.gbfd45094c4-goog

