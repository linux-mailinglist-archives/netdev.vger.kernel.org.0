Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FD52AC925
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgKIXN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIXN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:13:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8812C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:13:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id e7so9600448pfn.12
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBc0jRpnMotBJPPpr+nMafrbVcY3nHLtkPpcqs3OA9Q=;
        b=Usw6A3/rc1FSTBdhpUiwnwnKrgbqhbFXPibseee6my0D0xm7kngnoIxXtMo3L+KLUY
         lqhl2QOuiAq2GGHZ9OnAp388FH0StXQ+h7Z7zwF5RyC3F7E3CYKjY7Vt8EIQzW+WSRZ3
         eSVm/Mfx0L1AuLqx82LGZXRPJu0TjimLJtodm9I2OlVXhG9XJw3shF+78i0525mleD+e
         631wqYWeIS0uEb0DAfeqjG5O6Wvh3e8ucPjfDoB7NBPZqSAknpKyjAATw/uPEt7s0no6
         QtHTCg83OQL3qMw8ZCzyTbRV8TO6BVYhcmrmbRacV/v/zV6ZOQ0pZpm3BXKeL1RJ6Drl
         k9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UBc0jRpnMotBJPPpr+nMafrbVcY3nHLtkPpcqs3OA9Q=;
        b=P2kyA6V68/r7OccwGR1GykZjzHwRTYH6RNYDXDJS5a6G/F+aNEclQXxy2YSqIDAciJ
         bduHNmZmDS8OVW5P+fcTiHDmGBf+3j0LQToBL94EHDzxhMFI7UZBrQxNYHbGOTAVccGo
         +dn10gLOXG6PQv44LyF4Poe0uOpEQYDiR39JGJjXfe6ZU8Lgc2GlkcCeQxuvJ0ww86d4
         jxb0V6xhiuqZiRi46es8A3/pzFOjuEW4PWkmLE7UpBtWg0W2+T1NFqk/MBNbxkGc4hq2
         d4KrI5AuYQAZtmMG1ObB3NpF5gCMYVV0zEiC2RuO4yURZ1LqGzsb5vrA559xdIHgI94t
         QURw==
X-Gm-Message-State: AOAM5305bxOp/tcPAS75X/MZ/7OypAeVU7UO5z2seljVFYpb6XTrIrm7
        PdYuAwMF/7NHeU2wXfKPPFk=
X-Google-Smtp-Source: ABdhPJwffPRMl2FzLBTHaHmirzKnUqPlTjpMCIctZ4tBNeZQSAjC5MsRdIcDbva46i4Qo8ESqrws5Q==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr1724356pjb.67.1604963634376;
        Mon, 09 Nov 2020 15:13:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id w16sm12375365pfn.45.2020.11.09.15.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 15:13:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] inet: prevent skb changes in udp{4|6}_lib_lookup_skb()
Date:   Mon,  9 Nov 2020 15:13:47 -0800
Message-Id: <20201109231349.20946-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This came while reviewing Alexander Lobakin patch against UDP GRO:

We want to make sure skb wont be changed by these helpers
while it is owned by GRO stack.

Eric Dumazet (2):
  inet: constify inet_sdif() argument
  inet: udp{4|6}_lib_lookup_skb() skb argument is const

 include/net/ip.h  | 2 +-
 include/net/udp.h | 6 +++---
 net/ipv4/udp.c    | 2 +-
 net/ipv6/udp.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.29.2.222.g5d2a92d10f8-goog

