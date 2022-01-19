Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB00D4937E9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353339AbiASKES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiASKES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:04:18 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5A6C061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:18 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id a5so2103324pfo.5
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4j3DT9CdeXZVCEAHXK3UARBhiHHTMBX+mEkpaSrfGM=;
        b=excRNQV8Jv0JoE8NZ2+09w1v0BCiGKtFux+chSNtcmsmVJDCjobiHFrzWyYBiOoSyh
         Id5aCJcCUKVd8TO/r5/iW0O5dmf0qfPpRy44Bp1Z2K3QrC9CPUSapb+SFK7ELu45yBcJ
         RJzI1BhjiRnoXuQKaEHceeJIyjPX3JVGLiymgYbIBVcFqegAY9dE0c7zpihE5hIEWUjF
         yqRwQ0rV2U+X9tHwUkvB/cyT1Zf7upUDym+hfJQvLdQAGIONlwZm20C6eRMViBEBS2og
         8LHVTc1d4hj457lTvf2JrSkAnQRbEfUms5amVJUkz1/Y+I9nGbsdme+BrDav74jYFBzE
         5YoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4j3DT9CdeXZVCEAHXK3UARBhiHHTMBX+mEkpaSrfGM=;
        b=lG7v/ObctgclECqVdbLX88whC90+wmNRYqZma3MBVEVtQJTSKp/ortqrt5c2gXrztS
         l71SU8A7babiV+nBi4ShqSTc3wNS95cqJW0hYILkYnUxfdsSqbhSm0DNZmWXMTApPlQs
         kcVVpm7iKKOhJQBkrJkORzYdMJhmtzG2WQb1F5adWmfjxaijxBQ4A0iYuResGWqobyql
         RWnnsuI+BwMtsPBP8D5hRGWz2DHN37rZG5FLCQly8veNJd9Ds8+4VKkF9fpniz3m3S1r
         GouaCRRNEs8p8qH35PqAMku+cbmwqsg/iql/69cmkz8bAe8pM7QuLtsyeuG+vJuvy5Go
         U13A==
X-Gm-Message-State: AOAM532VOYMh8Hnofx2EBcpBxpND7f4vmHollNzLypf/sdGyauhn3w1e
        NS4gg9WoRQKBoKrC6XXH9ZYWoUsLHeb6uA==
X-Google-Smtp-Source: ABdhPJwZPBpEJRDy5AKSLcNIXmgkKYvCMcbhiK2dVrT660gmSEzUYFNe7/JAIuoGGo+4wb0f7vWAVg==
X-Received: by 2002:a63:3e02:: with SMTP id l2mr26503616pga.412.1642586657672;
        Wed, 19 Jan 2022 02:04:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id a20sm11695323pfv.122.2022.01.19.02.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 02:04:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 0/2] ipv4: avoid pathological hash tables
Date:   Wed, 19 Jan 2022 02:04:11 -0800
Message-Id: <20220119100413.4077866-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This series speeds up netns dismantles on hosts
having many active netns, by making sure two hash tables
used for IPV4 fib contains uniformly spread items.

v2: changed second patch to add fib_info_laddrhash_bucket()
    for consistency (David Ahern suggestion).

Eric Dumazet (2):
  ipv4: avoid quadratic behavior in netns dismantle
  ipv4: add net_hash_mix() dispersion to fib_info_laddrhash keys

 net/ipv4/fib_semantics.c | 65 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

-- 
2.34.1.703.g22d0c6ccf7-goog

