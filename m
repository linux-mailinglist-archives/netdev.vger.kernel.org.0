Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B137EE7E
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403907AbfHBIMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:12:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37681 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403812AbfHBIMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:12:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so35625317pfa.4;
        Fri, 02 Aug 2019 01:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PvAIzNVAxrFzutsn3TU1Sf4vCwWMl7u5+DCrpRBR274=;
        b=jW72/RVmpu4iNXHVnsFNetVA+cxBplkBsGEg6S5r+2kKQ4h/SPV9dz4LmOb9L5DyKh
         tBKEcAbDZgy0V2F9mqLG8X1t0p1dakrE/d4Z1qKeNZLi3z3pOeUCBfvS7h9O8eUIIkwM
         UXh97G2nSlUGWSsZ+MdwT74rA+86JDsNync7PD99uBVfAt15VGkn9m7oEW/zxbyqPuB9
         TnWKTKdGpBjKvwjZodfpA1XjSZyf+m9vaMS2r3r88hcgXXBLZcExEds1I4+YpAJFjX0m
         vwQpsUYJzAkRPvletwcoGEYCppIrl3gC3QdlQ6zN2MBEdhuUoOse8Vc9hcEnOx/qf+HC
         J0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PvAIzNVAxrFzutsn3TU1Sf4vCwWMl7u5+DCrpRBR274=;
        b=ABVPV5h7xADDWDDE2crTaNt9QaSltKxunzWXx/ryuvmCGOsw9P3jDDv4qXLq08p0kg
         pUpCrvPH1VG9NdrSESO7ZpqcixmxXyvaa40L9g+w7sRJ9jJgsuewOYOFGxd106dEDHL4
         0Q5edUEBDdzDvPk7W4rF9Gwj2r8m2QLmC1qdbSB0CLei0fy9xRk4+5U2J8HvBEeZx76U
         E2FkPNouk6UW2edIhhgy7OOVp95BUgS2Lvu0QuW06hPSgNOruxgqR8qW6OSgqkKAWnm4
         siN3bzCyaHKkEFIDltNMTn6Zvdp3wv4F0qZNB5OPkjPpNKz1IMzf1x/Uywxe6x5V4cNR
         k4kg==
X-Gm-Message-State: APjAAAUVkHX12Pb302ikAlwiE+ol+89bM3aEMisvJkxjoEf7JG767r18
        d6lyfYRMXM3mCkYCpZGzeJM8sHeWyx44Xg==
X-Google-Smtp-Source: APXvYqwJ6KFEZy9WNRIAoPK6RYYDyfkDiS8W/vszk25Kr8sVSabb9FSfVrIlbBRhezB0dPRdGEhNJg==
X-Received: by 2002:a17:90a:3401:: with SMTP id o1mr3114301pjb.7.1564733540730;
        Fri, 02 Aug 2019 01:12:20 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id e5sm4054338pgt.91.2019.08.02.01.12.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:12:20 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 2/2] xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
Date:   Fri,  2 Aug 2019 10:11:54 +0200
Message-Id: <20190802081154.30962-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802081154.30962-1-bjorn.topel@gmail.com>
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flags when updating
an entry. This patch addresses that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 780639309f6b..8864dfe1d9ef 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -226,8 +226,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EINVAL;
 	if (unlikely(i >= m->map.max_entries))
 		return -E2BIG;
-	if (unlikely(map_flags == BPF_NOEXIST))
-		return -EEXIST;
 
 	sock = sockfd_lookup(fd, &err);
 	if (!sock)
@@ -253,14 +251,29 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 	}
 
 	spin_lock_bh(&m->lock);
+	entry = &m->xsk_map[i];
+	old_xs = READ_ONCE(*entry);
+	if (old_xs && map_flags == BPF_NOEXIST) {
+		err = -EEXIST;
+		goto out;
+	} else if (!old_xs && map_flags == BPF_EXIST) {
+		err = -ENOENT;
+		goto out;
+	}
 	xsk_map_sock_add(xs, node);
-	old_xs = xchg(entry, xs);
+	WRITE_ONCE(*entry, xs);
 	if (old_xs)
 		xsk_map_sock_delete(old_xs, entry);
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

