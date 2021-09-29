Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBD441D058
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347832AbhI3AB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347786AbhI3ABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EF2C06176F;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g184so4400344pgc.6;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wEg45pp1uP0HN1mYN2cnN+mk80Dor9HzCEIMByiQ72M=;
        b=lh9ej8MGqBAw+653mDsdR8WyzWvRfLfd+aHMSRYJosRPHjKx4rlGQif/oeGRnRv44G
         5FW7uL6eJBHGJiMYsyyyO9spxFg1IBZ2grBtqLyW04Mbdk1J5qFFBHG+szFNvPSHC7Ux
         KcsJWJTCLe2lipDseKTx/lbPlhmsSmk+ObGkIvPGAMmqCKg/6VZlAJxLyRjgrdVP3EkR
         DcLzMyj7jG9PDmB445rnxjoMfbvHuaqRaYcq5rVPPftz4QdewJlHMMFPluG9P7cotsHt
         Ed5JpNb8U+W7KSGjMED5q07SoVipvxOmk0JwFiu7JjZR3w24Mvgg/5L8eYqaqfBXoV30
         Zutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEg45pp1uP0HN1mYN2cnN+mk80Dor9HzCEIMByiQ72M=;
        b=QzVSEcQdwQ2PqndIZ7s1a+e1+Uno3v9uToGMDqA6fRLa2r254pZ41yuZ1ch0BhDY8G
         VdFAqL5j/FZrsp7CjMMETahj04iBgoFwHW09uxSO8MumCHzg7muFlyuJ8OoJxjzwG5/4
         pzuQWGrrMAWo76kRHOiYMfpeQX2yoMlDlQZHRajGO0EdjFK7EhliQtAUibYXshjYlX1Y
         jaHALhBWiaY/GwS9Mgw+DaoY45p5qSkrFcBQsPj5lGUuotHHvEtC9K/lsbuzghEjTx6H
         O3Ws1YWr18NjMixXf/tN0FYI0ccVBqnF6qbV7fTRg3VW6bdYXtaXUBW28YZCy/MolZa3
         ecdA==
X-Gm-Message-State: AOAM531oADDQmeKPxV7hBw43rH/6EGE/0nkKWWe79zHYrWyNFH/bBvj8
        QX18817wCK4U+HfnrSdaew==
X-Google-Smtp-Source: ABdhPJzSE8bZ9KcUn1srND1DhJeuRxArKa/pVTk2Va/Pzz0pA1VlXXt+QsTPffJMmVrLKNnj0uNKpQ==
X-Received: by 2002:a63:724b:: with SMTP id c11mr2276493pgn.9.1632959977318;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 09/13] bpf: Add infinite loop check on map tracers
Date:   Wed, 29 Sep 2021 23:59:06 +0000
Message-Id: <20210929235910.1765396-10-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Prevent programs from being attached to a map if that attachment could
cause an infinite loop. A simple example: a program updates the same
map that it's tracing. A map update would cause the program to run,
which would cause another update. A more complex example: an update to
map M0 triggers tracer P0. P0 updates map M1. M1 is being traced by
tracer T1. T1 updates M0.

We prevent this situation by enforcing that all programs "reachable"
from a given map do not include the proposed tracer.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/map_trace.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index d7c52e197482..80ceda8b1e62 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -148,6 +148,48 @@ static const struct bpf_link_ops bpf_map_trace_link_ops = {
 	.update_prog = bpf_map_trace_link_replace,
 };
 
+/* Determine whether attaching "prog" to "map" would create an infinite loop.
+ * If "prog" updates "map", then running "prog" again on a map update would
+ * loop.
+ */
+static int bpf_map_trace_would_loop(struct bpf_prog *prog,
+				    struct bpf_map *map)
+{
+	struct bpf_map_trace_prog *item;
+	struct bpf_prog_aux *aux;
+	struct bpf_map *aux_map;
+	int i, j, err = 0;
+
+	aux = prog->aux;
+	if (!aux)
+		return 0;
+	mutex_lock(&aux->used_maps_mutex);
+	for (i = 0; i < aux->used_map_cnt && !err; i++) {
+		aux_map = aux->used_maps[i];
+		if (aux_map == map) {
+			err = -EINVAL;
+			break;
+		}
+		for (j = 0; j < MAX_BPF_MAP_TRACE_TYPE && !err; j++) {
+			if (!aux_map->trace_progs)
+				continue;
+			rcu_read_lock();
+			list_for_each_entry_rcu(item,
+						&aux_map->trace_progs->progs[i].list,
+						list) {
+				err = bpf_map_trace_would_loop(
+						item->prog, map);
+				if (err)
+					break;
+			}
+			rcu_read_unlock();
+		}
+	}
+	mutex_unlock(&prog->aux->used_maps_mutex);
+	return err;
+}
+
+
 int bpf_map_attach_trace(struct bpf_prog *prog,
 			 struct bpf_map *map,
 			 struct bpf_map_trace_link_info *linfo)
@@ -180,6 +222,10 @@ int bpf_map_attach_trace(struct bpf_prog *prog,
 		goto put_map;
 	}
 
+	err = bpf_map_trace_would_loop(prog, map);
+	if (err)
+		goto put_map;
+
 	trace_prog = kmalloc(sizeof(*trace_prog), GFP_KERNEL);
 	if (!trace_prog) {
 		err = -ENOMEM;
-- 
2.33.0.685.g46640cef36-goog

