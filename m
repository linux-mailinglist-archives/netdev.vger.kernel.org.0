Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E64F2E03E3
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgLVBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVBek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 20:34:40 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFD8C061285
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:59 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id i18so2652084ooh.5
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 17:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=JGMGWTTpyrK1cqohodovuXbNY2qCmbUeOU9gJyxQ6rtFVyNxfsCUTG5eyNyq8Rpsd/
         q7XApaf+3OeDccJFrgYp9/5CzXzgNSAe9QDOYbi4i436ESERvHroAuiU41tR/c7PhW99
         NoAfCK6Onw/dcusZq2OEQfTRa13vITIF02XeMT6VhYvaz0XxoqpllUicV8Axo63abloH
         tiGzqe4Pfe92DAXwRB/AT2Hpn+B5rgZoVB6rb4xUkb2uApB+dhVJ6ID72ymSHOiJKP8U
         YmSH0V3tsKe4KcwX2DgRQ9cAHsx/V9lu4DxgPhUUp8jZxtbJmKkMXNtgZrlYCPVOXbF8
         sREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=C5YrLJk4+CoCE/1AosOeX7c4wftiJstXgY6es1z0mf5MraNeQtif/ujnvWOrMcexpP
         vV5IHeCMX6udgm/zYVfcGFSvRfbmKBBTQbGZHJquyvDz4nOzwhBv6alOSXO1j4VYXiL3
         ySsFchQFyvw/nJFoJDFdrsncicmZxd+Veqoi7cIp/gKTSZW8tq7y/tSNPo6nHWSKoa5S
         E8oXZzsUc7N273sllQwSOpNEQld+JV3nIxOncLW+qaFeIXdbvrppa1SmjaRjhaJmtijg
         QEH5v1ciHcwxoLm8QtbSao0uLZzYSmMFR8jpLtSPse/vnS/IvkcFA8xNnfHk84EnK94k
         bauw==
X-Gm-Message-State: AOAM5315vBWG9kWiebIps/RUDSTcNR7Q9BtNu5GppdjUMpibA5NcvThA
        GojQZ0iN/P0Rw6PUnSo27rdqfiMR+9wYAw==
X-Google-Smtp-Source: ABdhPJyzf4UiWbSlbNONJ6rZTR1glN5CrhwlmwI1C+CgiQvCWu2hcM9jkQc0dkQY4gfB6NudlW7U8A==
X-Received: by 2002:a05:6820:34b:: with SMTP id m11mr3060892ooe.74.1608600839142;
        Mon, 21 Dec 2020 17:33:59 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id z14sm4089607oot.5.2020.12.21.17.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 17:33:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v3 3/3] selftests/bpf: add timeout map check in map_ptr tests
Date:   Mon, 21 Dec 2020 17:33:44 -0800
Message-Id: <20201222013344.795259-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
References: <20201222013344.795259-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similar to regular hashmap test.

Acked-by: Andrey Ignatov <rdna@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index d8850bc6a9f1..424a9e76c93f 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -648,6 +648,25 @@ static inline int check_ringbuf(void)
 	return 1;
 }
 
+struct {
+	__uint(type, BPF_MAP_TYPE_TIMEOUT_HASH);
+	__uint(max_entries, MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, __u32);
+} m_timeout SEC(".maps");
+
+static inline int check_timeout_hash(void)
+{
+	struct bpf_htab *timeout_hash = (struct bpf_htab *)&m_timeout;
+	struct bpf_map *map = (struct bpf_map *)&m_timeout;
+
+	VERIFY(check_default(&timeout_hash->map, map));
+	VERIFY(timeout_hash->n_buckets == MAX_ENTRIES);
+	VERIFY(timeout_hash->elem_size == 64);
+
+	return 1;
+}
+
 SEC("cgroup_skb/egress")
 int cg_skb(void *ctx)
 {
@@ -679,6 +698,7 @@ int cg_skb(void *ctx)
 	VERIFY_TYPE(BPF_MAP_TYPE_SK_STORAGE, check_sk_storage);
 	VERIFY_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, check_devmap_hash);
 	VERIFY_TYPE(BPF_MAP_TYPE_RINGBUF, check_ringbuf);
+	VERIFY_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, check_timeout_hash);
 
 	return 1;
 }
-- 
2.25.1

