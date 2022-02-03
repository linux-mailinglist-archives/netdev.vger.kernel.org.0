Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18F14A7D96
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348915AbiBCBw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348916AbiBCBwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:15 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9529C06173E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:15 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 132so1021573pga.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T7BnMCw0EYKUlYx7XzC8BlravVnmyJaY2eHhNbmdLJU=;
        b=lWiHZiB6xZ8cLCn2P+J+hBrw+PJe7Kk15a0u+5U8aR8rY0F+2OA4RrUkC21W/sdWO9
         RSfWgJTT4v0oaxuyJXllHmeUyBrzwO5UXrGeyfL/I19Yf1ekXZMNhxO57jvWhR13XtYV
         vv7VeBd5fKIAcs59RxyPzN4B/XXJDNtwAGj9rQjAqlXGvfbMPaVwl2Emumi/UtL9g9w9
         SjRggFk15UzDP//tFSxkK5lYgcmmuRDbRtq5lr/MuOMEIeaReNctdo8QljxykaGMwi/K
         bHXNJTh4UdaDCyqIO7JPRmJTloroZk6T5LLYjR9Z05uaf8r9hzixLAJklku4X40yhIHV
         zTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T7BnMCw0EYKUlYx7XzC8BlravVnmyJaY2eHhNbmdLJU=;
        b=fDURg31zdRbTw2aJurLPiQA8wnA9GrezxcR4wX7cBAo01LlEyKaXqQButlZuIAzpy6
         Wz0CvohtHyZ8S6LzriRCAVsXQ2yYBLr2dUfj+PtFvQDpbzNRipjar02Ohg9NTBkymw1N
         1FChSADyrWna47g++K+/FD/q5tLAfE+dATM5QMi7ZbdfqU00wv5cKfirxnoMrfJ/zpk3
         5VuzR6s2WKzSO1hZ/PDQtbXPQoydSejTJYNLWuJWsGcaD5/dt23ZzQfO1rz0I42vFqnc
         YL+rHGZ7y5aNQAZfS0FNeo6KEgI2R0BL0RK8d0NFXCPINRYjuI0jDBikuaVXlcmoG0hX
         02hw==
X-Gm-Message-State: AOAM5305rpEolRljQOUNJs6XV0fOqULEcdfbczG7HFHKTFH0Nl+rD2/9
        CFnfK9jUMDRIRHe5poLcDDk=
X-Google-Smtp-Source: ABdhPJxNMMfabFO5UX0caLTpzuuZa3LhFtusekQrJKeuW8MZGEOghlLg1jbNkSm15CJHeLFACeCs2Q==
X-Received: by 2002:a63:1cd:: with SMTP id 196mr5743737pgb.312.1643853135482;
        Wed, 02 Feb 2022 17:52:15 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:15 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 12/15] macvlan: enable BIG TCP Packets
Date:   Wed,  2 Feb 2022 17:51:37 -0800
Message-Id: <20220203015140.3022854-13-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Inherit tso_ipv6_max_size from lower device.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6ef5f77be4d0ad49b2ef1282413fa30f12072b58..ca2e828de5b09a62ebc9cf1c10506e6ecef34330 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -902,6 +902,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->hw_enc_features    |= dev->features;
 	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
 	netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
+	netif_set_tso_ipv6_max_size(dev, lowerdev->tso_ipv6_max_size);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

