Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5761542DA
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 12:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgBFLRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 06:17:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35604 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgBFLRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 06:17:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so6585328wmb.0
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 03:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIlzmnuGbQ2s9OOF5KBjiszKfyvFG7EgReUilYMF170=;
        b=CL1Z3Xv+QKCxkFq0NnohuC58jj5Qxj1TTqUyoPs1QgWHRXdTSl6mjkxQUBQ00tMUsd
         cHuA/yxZd8fy9dTFJbGXb+S/wJ954oB8/XpBhbDvp0zJMLqD8eZL+kZdi2MV9FvBWFp6
         4ETn/kFdZggRb4dwyzt5Af8G23EKgbpE+Yw7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nIlzmnuGbQ2s9OOF5KBjiszKfyvFG7EgReUilYMF170=;
        b=hLxMo2bK0JYu8jYatVIlPrMpT/XCnLHsDaRG2gmgLCyJgpsJhPzw93DlrSYaBIbnQt
         1lRsKPldyr76doP5dNZPL5fwesvPOBRpdrymcml5Y1k/Kd8nyCqU1Ejrz+fcSHFS/Uey
         B4Vv09i/tOUUbEEuxesDnjQlAdCzPHywA60MOjMp6jGMSBLAV84KFUe4f1B5/gcS2SYN
         iKTPXHsyrJfXlj9xaTKwNynJiJOgNXniwiUtIxB03OfYCW366Om8oCCdXS8DwlJdLYjG
         5vUhD1fwFRoohneQ+q9cXybezX86yUZf4Yhrv3RbqRgUa6ZvXc1RXNQJ7n5/NY7PbAOZ
         k/bw==
X-Gm-Message-State: APjAAAWYxe5YWpambodZm3KXU5CvMcB+rtZLdbnY/ovSSEvA0R3302WX
        AboyvfYbBy9NtIvG1Mph05Ea2Poc5VM+PQ==
X-Google-Smtp-Source: APXvYqxhqYVjHUfuM592EPJrzi2sRweB6kMS6bjGdxSL+q179bAdsGIKoGC8KkTU2kVJNJaFpzNM9w==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr3831020wmd.80.1580987818575;
        Thu, 06 Feb 2020 03:16:58 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id c4sm3238687wml.7.2020.02.06.03.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:16:57 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf 2/3] bpf, sockhash: synchronize_rcu before free'ing map
Date:   Thu,  6 Feb 2020 12:16:51 +0100
Message-Id: <20200206111652.694507-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206111652.694507-1-jakub@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to have a synchronize_rcu before free'ing the sockhash because any
outstanding psock references will have a pointer to the map and when they
use it, this could trigger a use after free.

This is a sister fix for sockhash, following commit 2bb90e5cc90e ("bpf:
sockmap, synchronize_rcu before free'ing map") which addressed sockmap,
which comes from a manual audit.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index fd8b426dbdf3..f36e13e577a3 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -250,6 +250,7 @@ static void sock_map_free(struct bpf_map *map)
 	}
 	raw_spin_unlock_bh(&stab->lock);
 
+	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
 	bpf_map_area_free(stab->sks);
@@ -873,6 +874,9 @@ static void sock_hash_free(struct bpf_map *map)
 		raw_spin_unlock_bh(&bucket->lock);
 	}
 
+	/* wait for psock readers accessing its map link */
+	synchronize_rcu();
+
 	bpf_map_area_free(htab->buckets);
 	kfree(htab);
 }
-- 
2.24.1

