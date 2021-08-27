Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5699C3F9F45
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhH0S4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhH0S4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:11 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E187C0613CF
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x16so2853065pll.2
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=L2WSuRi+JpY0bMyIpx0lbuuq6k9EuaeWT+X9FptDExE=;
        b=l9PyLwtYByS7ZyOaFWPJGIFT0ldh9Qvuum7/Qmch/KhpWaKPaHDjK3xxZqfhPlmBSl
         WNLGFOv7J6C5RoXXOHH6pN3gNVrN7YF4tDDqh5lqtEUSsN4JWp42R2Im3K6WyoX2ENW6
         ynnfTn17beOwljb1ttYYvav79MOhB/wIKy/QMBBd4AYkoT/fhCCWpQQDrg3sW/LKxLAC
         Du7rLXYoIPKuJ4TfcUmBdpqWkZD4n3FM44rE6mQazLMhD677hWwG0BSHHvDtNmUEWX8A
         BDRLQceQb7WXKeixieoEhO4zGZBFabi3WS8+rG8A7EM6LGhDq05PGn6KT/qnKnMqCnI1
         puyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L2WSuRi+JpY0bMyIpx0lbuuq6k9EuaeWT+X9FptDExE=;
        b=efQ8cTgs3mYHyzG2KBAoiSSx/8u8Q6fBDeoG6fgd4yWrxvuesq/1U0mllXeqw0XX3k
         CeXO196vlWNIVtLGT5z0Wdg34d7QZO9C31gzpkPYU+Y5H4j19t0yfKyMYweUetQ+VLvP
         dO6u0+UJR3Ydosaz9+DVbSijHIyd7rjkDRkDOXwzbJ0uE0RSBt+tN/bP1VB8LKajnDia
         SkEXZluX9rn9wDNAoPVQerSKBoi34Xnt1Mb8szsWbuAp+wtBQYbArhnr2NwUjirxUKPT
         +fF9lA6kyuR61tPXuizeSNt9T+ltGYwqvZwiKt8CUQ+JyU8KHv/NTmlFNxAQ5hccZmSt
         MwZw==
X-Gm-Message-State: AOAM533NkrHhh6Za9tduxOPivn1poSeKObC8hk0gr0NOA0Fm9F9A0nCD
        0vkPiwKJR+vPYzALR+CkTIQbvA==
X-Google-Smtp-Source: ABdhPJwPgDsU5msPVIoxTZZCW3H1hJks8b/vdgmiCA2MhgXyI1wMFZOJ+sH4Euxo1uLqn1zBC/CB6g==
X-Received: by 2002:a17:90a:bd02:: with SMTP id y2mr12091780pjr.202.1630090522119;
        Fri, 27 Aug 2021 11:55:22 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic: queue mgmt updates
Date:   Fri, 27 Aug 2021 11:55:06 -0700
Message-Id: <20210827185512.50206-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first pair of patches help smooth the driver's response when
the firmware has gone through a recovery/reboot cycle.

The next four patches take care of a couple things seen when
changing the interface status.

Shannon Nelson (6):
  ionic: fire watchdog again after fw_down
  ionic: squelch unnecessary fw halted message
  ionic: fill mac addr earlier in add_addr
  ionic: add queue lock around open and stop
  ionic: pull hwstamp queue_lock up a level
  ionic: recreate hwstamp queues on ifup

 .../net/ethernet/pensando/ionic/ionic_lif.c   | 45 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   | 28 ++++++++++++
 4 files changed, 59 insertions(+), 20 deletions(-)

-- 
2.17.1

