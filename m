Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF5438C5
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbfFMPI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:08:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42220 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733210AbfFMPIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:08:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id b18so12947660qkc.9;
        Thu, 13 Jun 2019 08:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PKoiguvdOsKNMoylire+/80q+X2cUmMINdCgWVkvQq4=;
        b=RJ27S6NnwvYIrs2n89pYWkYIyY2rEA77Q7H27tsj9VEuTIw5yaAh53WL9p0GJ30Shn
         yzoyaosv22UMCZJvKmekrQksj+xyKqPUX5yGOQJtnNXhfrJ6HrtC6c8wP+k9YJipbUpX
         IopVqwGvjQRw8X5ReY8pGukRIBLT7VqMVgjkItjLJ4oo7F2AiAjkD33FzDJLj6oTyw5T
         AGB7xshAtbXBINDFHAaXRG++CJZ79mkWGTGBTGJgsasm4BVKMC0gpf7Q1C9/yXjJ4PlN
         JnM3rbo8qE6J3AvEBwM5ySIjGo0xZV1Jkb8rWltFGrdzctnVIKkmKsdKpPHzJ7srADMM
         NziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PKoiguvdOsKNMoylire+/80q+X2cUmMINdCgWVkvQq4=;
        b=KagJrULVDXOJ6D+b6i0uFGvLBrls7Lp7HMnEHb96599Kli2InAqivdqkIn8oBL5o+J
         Qjg26dD3NKUb+zC36xQCwWtnY2qCHJxdsj/5RK4uw3o4kCq/x8FEGA3FSWO5KI86eJ95
         j2S7vfMihaCaOGgK27qA/NFaXMCxGeUcsEKhCsEQl5Q5m5S3uOmwA6XCI1V9sc0Q6HTk
         zbE0lP12+pSc5N588vtAEEGdVr6SvKqkpX1SWO4en7gHyMaiCTMcIInc4PGF+OC+Et3v
         8xj8+IcQT6c0NMhAA2oHz7Dm2TOOMDgqCvdNyis9R52p68GY0kLA/W/mp5WTwKAE40S5
         Zepg==
X-Gm-Message-State: APjAAAUfZ/az6qFQyEkEdmyJg6BnEqIWJFYRh1sm2lUy9CyG5f41LMPM
        dat2rPyTUxk1Ai7Fxz6D/ag=
X-Google-Smtp-Source: APXvYqydIsClpk8mAH1HWuUD+/BmCDGGL6PYMPu0u7Z+MOQVii7G3eIl/xbIiIDVjBncXqBiwZk6qA==
X-Received: by 2002:a37:8ca:: with SMTP id 193mr19364139qki.124.1560438501832;
        Thu, 13 Jun 2019 08:08:21 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id d188sm1641989qkf.40.2019.06.13.08.08.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 08:08:21 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     jakub.kicinski@netronome.com, peterz@infradead.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 2/2] tcp: use static_branch_deferred_inc for clean_acked_data_enabled
Date:   Thu, 13 Jun 2019 11:08:16 -0400
Message-Id: <20190613150816.83198-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <20190613150816.83198-1-willemdebruijn.kernel@gmail.com>
References: <20190613150816.83198-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Deferred static key clean_acked_data_enabled uses the deferred
variants of dec and flush. Do the same for inc.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 08a477e74cf3..9269bbfc05f9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -119,7 +119,7 @@ void clean_acked_data_enable(struct inet_connection_sock *icsk,
 			     void (*cad)(struct sock *sk, u32 ack_seq))
 {
 	icsk->icsk_clean_acked = cad;
-	static_branch_inc(&clean_acked_data_enabled.key);
+	static_branch_deferred_inc(&clean_acked_data_enabled);
 }
 EXPORT_SYMBOL_GPL(clean_acked_data_enable);
 
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

