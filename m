Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5106C264E1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfEVNiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 09:38:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46584 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbfEVNiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 09:38:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id y11so1335652pfm.13;
        Wed, 22 May 2019 06:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lqLhChu2AsifnciOctMcQL0LYazbPIk0otwAyvD0vQ4=;
        b=KN7cK4oU3JUBe5aAgjz0Vr4WbCT7H/MVYSlBFhBevsSITO3IlyItwak5wrlHfz8437
         6kShjBjFKuQWOWMBtB5dmsEKxKIGN6ZVK31/11EpYXw8kBxNMSjsk7rD62/4qzG+rRGa
         CZL2wM/4JrcdHhFKP4eEUJvWIMAE/6P19xqYlxOm9RE7AV+UCa8HAH2G4z+DblRwR2+1
         wa54tN86b4sKoiqwxIVbyaaHYqCv0Mz3N388SjR7pD9gEMrRUiTMke7y/9uVTqgBpTIO
         9ypFNa08fPCvxCeN31LoPJkE76rW+wIt0ucLqmYIEns/JjWEEd2GHepBI4p4eREEpnTh
         9Wkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lqLhChu2AsifnciOctMcQL0LYazbPIk0otwAyvD0vQ4=;
        b=LK8unc/WCVhPWjMOqRY1ziJG7WkM2PaLvVZyGE49/fRdZKMh4BYxkb4X+v9g3xLo0r
         yposbJDfpGnHslUjcYuJXIUlw/bDUm7c/PnygouWlRC5xaP/Jgc2oJ//cjnUpZRMJvdi
         sUNR5eo9WDO/S7fN7ENUBCI2w0LmDh8ymiAPmu1U04PXRbWkn8b4qsyxttH/A89xBQRS
         aPPjD73iT/HXDRBKv/TGU8fgefdmt/tvIidmQzKyBJeyxl7gTo9ELLZQ4eZzexryo3WU
         pGfEVSwzpRTbPPIl1BfGDRPuwqyhTI3i2M+XnKRwz0Cbjy0vvPmOsNPPiVyQfaZI5bfg
         EWBg==
X-Gm-Message-State: APjAAAUj93yC8y4p2B6zili1v/DrfqZZswiqhFbFkelhXcZPCghPIOa5
        P/k7lLPFpIz/vE5/VSCN7iE=
X-Google-Smtp-Source: APXvYqz5qu66R/TJIzScwirrAp+FjNoSaSqIXH0L04bbxaboXwmr8a3v0dfjyOR66MmPHARoxNmG2g==
X-Received: by 2002:aa7:8e55:: with SMTP id d21mr95218713pfr.62.1558532297557;
        Wed, 22 May 2019 06:38:17 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id o6sm53908997pfa.88.2019.05.22.06.38.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 06:38:16 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
Date:   Wed, 22 May 2019 15:37:42 +0200
Message-Id: <20190522133742.7654-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522133742.7654-1-bjorn.topel@gmail.com>
References: <20190522133742.7654-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flags when updating
an entry. This patch addressed that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 318f6a07fa31..7f4f75ff466b 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -223,8 +223,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EINVAL;
 	if (unlikely(i >= m->map.max_entries))
 		return -E2BIG;
-	if (unlikely(map_flags == BPF_NOEXIST))
-		return -EEXIST;
 
 	sock = sockfd_lookup(fd, &err);
 	if (!sock)
@@ -250,15 +248,29 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 	spin_lock_bh(&m->lock);
 	entry = &m->xsk_map[i];
+	old_xs = *entry;
+	if (old_xs && map_flags == BPF_NOEXIST) {
+		err = -EEXIST;
+		goto out;
+	} else if (!old_xs && map_flags == BPF_EXIST) {
+		err = -ENOENT;
+		goto out;
+	}
 	xsk_map_node_init(node, m, entry);
 	xsk_map_add_node(xs, node);
-	old_xs = xchg(entry, xs);
+	*entry = xs;
 	if (old_xs)
 		xsk_map_del_node(old_xs, entry);
 	spin_unlock_bh(&m->lock);
 
 	sockfd_put(sock);
 	return 0;
+
+out:
+	spin_unlock_bh(&m->lock);
+	sockfd_put(sock);
+	xsk_map_node_free(node);
+	return err;
 }
 
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
-- 
2.20.1

