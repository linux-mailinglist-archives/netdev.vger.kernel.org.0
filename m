Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0C97910
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfHUMRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:17:24 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40654 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfHUMRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 08:17:24 -0400
Received: by mail-lf1-f68.google.com with SMTP id b17so1621404lff.7
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 05:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+KcSv9I/AsPeVximJhFUVD9sZ1/koeFyLmZnjNgXSj8=;
        b=zLezPN9BDAmeEzUp7RC5RWtnZqxhiZV8LjE8EInGPMk+tkajmarjj8jTD7rEGZA/jf
         IpuLS8eF8vSzsHmC/zjPoPgngruahBPsteHGaUl+azsEHJRipqTtsXFHsr1zLWZRqJ26
         CRSJ5qB9vYUxzqmtz9JmgUw8FMpsz8baBUDbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+KcSv9I/AsPeVximJhFUVD9sZ1/koeFyLmZnjNgXSj8=;
        b=g7knjCM5W8I0NrBxl1jNyLgzZhTna4DZC4CQB2TDrE0KigXobYAmW+eSxyN3/0cOr0
         clXEQQudwiWc3aaSIgUr5gcPe7tH0bKxTnAsmbizSYMdFbsb3cQjJjiTp1mxDFp0P+O8
         NMXj6vWJ5DDUxTHHSNWtx8hxrv2GA9dkeJ0LqLdyvxGAjNaivW6AG8rXEHcu1UryLtlH
         gCSok76vy8iEpRPMcPnqi86IrDhloPiXnnCKfdvs0IEZgymHIU3TZfaOZpvdptJcw/Xs
         6FgosRgdckHmCBOgWivoaBrE1NuM6DYxfovFWZ9HgZLg+7IrljtgC4ZNzBgbYlbqhkyJ
         lmag==
X-Gm-Message-State: APjAAAUZ2UbGr7DKcf0iyJKX44kPLE70QLEAkGYWW0sg3xiSDCnkS46N
        HSvHXQijMVR6T7cDRir0/f4B6w==
X-Google-Smtp-Source: APXvYqzS1ABrw1F1qVHRZ4NJjgUoTwUbuL8XDJ5Kzcjj485s/P1hXeo51xGbJXx1hbo+0WdwMvL1rA==
X-Received: by 2002:a19:f11a:: with SMTP id p26mr18136589lfh.160.1566389841933;
        Wed, 21 Aug 2019 05:17:21 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id w13sm3374947lfe.8.2019.08.21.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 05:17:21 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf] flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH
Date:   Wed, 21 Aug 2019 14:17:20 +0200
Message-Id: <20190821121720.22009-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call to bpf_prog_put(), with help of call_rcu(), queues an RCU-callback to
free the program once a grace period has elapsed. The callback can run
together with new RCU readers that started after the last grace period.
New RCU readers can potentially see the "old" to-be-freed or already-freed
pointer to the program object before the RCU update-side NULLs it.

Reorder the operations so that the RCU update-side resets the protected
pointer before the end of the grace period after which the program will be
freed.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3e6fedb57bc1..2470b4b404e6 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -142,8 +142,8 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 		mutex_unlock(&flow_dissector_mutex);
 		return -ENOENT;
 	}
-	bpf_prog_put(attached);
 	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
+	bpf_prog_put(attached);
 	mutex_unlock(&flow_dissector_mutex);
 	return 0;
 }
-- 
2.20.1

