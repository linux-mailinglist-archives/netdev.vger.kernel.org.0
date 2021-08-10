Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6083E5B09
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhHJNVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238234AbhHJNVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:21:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB200C0613D3;
        Tue, 10 Aug 2021 06:20:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t3so20923475plg.9;
        Tue, 10 Aug 2021 06:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SX74JVl12Ur/MSUH0EdL9xrO+WJ2AVt5+Tteuxj1iUE=;
        b=ZhPaZuwFIGrAHCxFjgMdx8S9KUmp6xSb6B0FbPA/mWapTqlnPJMTh6DehZh5D/JDQY
         2UCY8yhkpFC3QaZXwKOSyB36+p5WlZM8+3iIvBakUdOYDCR2P3XDPSuRA79NpbwLFwkR
         egAhSwRa8UnENnklifmNtWWec7Us8sFTihiJ6CW53D1tk8GVKn9uuiVUfN9oJOgokMFB
         DEKBgLD9W3ECSRaiVkBX1YsDweATsShalR1ws4wOfGh2UKqTx1a2UvxJ/N9K/LGVNTqA
         Mi72SnOhfwmqqAEIOcfPTGZfzhjTzsQP6dLXrgXHFDQolUrKgvfU1u1TIme93aXan1bV
         4C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SX74JVl12Ur/MSUH0EdL9xrO+WJ2AVt5+Tteuxj1iUE=;
        b=ImdnCEn9+jpOj0AffxB8jvLxR9q0JjuDOd/+zwFFvZ9asFUw65T7uamO2QD9U1yiCh
         t5kvcfoviSUZdxZQT3e+o5a2+IyksW7yScMsEAgZhqBYwGr460H8kLc4FTUaiwUWiHde
         3X2Si60j5aFO1j5b364HDb+jyqAEj+Ia32lK2Ucrsde7jEABH0AStcusiHSKLUCPBwVZ
         3ACjWNB9HfCka/4v55wMtb0BnurwVj6k7IBf9/pGcMQvDWknHB4JnYjuhfwUKoJQLYXg
         DMBdzh+2hRApi9hYDTDWr+bpzjWbjfiD5SqsrwVvWtBeZ+mJ3wAn/cwacjd4mzdxH0hg
         KYkg==
X-Gm-Message-State: AOAM532ltx9Y29rFnwKKPJVvLEqeslOqzN3oGRN2sxwfKrqsZO+SZWTP
        iQ8S1TH04F7E8klMTe8PEi0=
X-Google-Smtp-Source: ABdhPJx/6lEyuHm6rBEtovKxgRhP6PBxVM7h8vp0TYEaBFVR627ybgDFXrKOrR3RClXkvqTksDYjSw==
X-Received: by 2002:a17:902:dcd5:b029:12d:219f:6c04 with SMTP id t21-20020a170902dcd5b029012d219f6c04mr10190091pll.7.1628601649245;
        Tue, 10 Aug 2021 06:20:49 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.40])
        by smtp.gmail.com with ESMTPSA id c23sm24208897pfn.140.2021.08.10.06.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 06:20:48 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] net: 9p: Fix possible null-pointer dereference in p9_cm_event_handler()
Date:   Tue, 10 Aug 2021 06:20:07 -0700
Message-Id: <20210810132007.296008-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable rdma is checked when event->event is equal to 
RDMA_CM_EVENT_DISCONNECTED:
  if (rdma)

This indicates that it can be NULL. If so, a null-pointer dereference will 
occur when calling complete():
  complete(&rdma->cm_done);

To fix this possible null-pointer dereference, calling complete() only 
when rdma is not NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 net/9p/trans_rdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index af0a8a6cd3fd..fb3435dfd071 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -285,7 +285,8 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	default:
 		BUG();
 	}
-	complete(&rdma->cm_done);
+	if (rdma)
+		complete(&rdma->cm_done);
 	return 0;
 }
 
-- 
2.25.1

