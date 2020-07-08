Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDA218598
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgGHLJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgGHLJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:09:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299F3C08E6DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:09:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b15so41326643edy.7
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=pwJ+163DLcAdrUkuO7uNQfa5R14+O4pcL2P40wKUjXI=;
        b=ZPfVNYWe+VIRbQTl3HrCxUuqKbEtLJohp3EyBvp4TxYN056YMEbOwvtevmmv1rQFNm
         J6ngoukgD4DnCLO++aHXN65fpnmrpzWvY7jzJtUOy6uJSmov16cBunHy9WQ596UseN7i
         q5QIX9ZBTxrV5xB3gNu+0m+DhT9p9oywg/Tuk9vDQ0V8cOp7eDorbE81NTnnUpXq9bhM
         TOLjSDLBNF7SnYhzWbWYHtTU7VZcUViRKke4BiNvF6/yIHlZZ+sWUebO0so4RCjbOGMe
         /mM6cXxwq5yNd1NqOMITIByOt0bo2acVcnSU0Oot2ZQOqN4uLgns7ZqeNsMuTIXLfpyX
         yuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pwJ+163DLcAdrUkuO7uNQfa5R14+O4pcL2P40wKUjXI=;
        b=llLdMOvrDV80YIjINqr9WwWBFSy4L7xR32S114shSKQLeuNuxerJ3UK9+xIvcANhLg
         WExgDSUR8JpPN7Wu0pCuAuayBagOVZbxwX2NhnpRmcq7DlmUm2eKhx+ndLpHjqIPFgcF
         1gbMb9vzE6kD2WGC7M56bNBG2H6ic5Zfna2nhZVruYXdlhKGYRKL/zzLZ5yDap7ieFHS
         qKsYhjFkIzoKIGYw+211OYWJPCCV2dp2PCbA6+XIHHYMIoXScd8sbcenrb4N/bya0uCY
         6g9QsLt9vRy4AfUT1IMj3LaNBZbuv0Ju5H4uQGAfeAHtmpLSg/t+xeDksqOCfgM3KZhs
         wb9g==
X-Gm-Message-State: AOAM533z2C2ECV4uqAi85d/meq6J1QrxwsjTboing7Ij2yKdvPpzllMg
        ysbCPuWnu7cm2I3QvCbs7yubPA==
X-Google-Smtp-Source: ABdhPJwGmvYh3KbddyvJfAENc994A07ybdAbwkLP8FaVTMPgKXch8HOKw0vZFCN9pT5onCAdiPacwQ==
X-Received: by 2002:a50:d0dc:: with SMTP id g28mr64190079edf.169.1594206565885;
        Wed, 08 Jul 2020 04:09:25 -0700 (PDT)
Received: from tardismint.netronome.com (102-65-182-147.dsl.web.africa. [102.65.182.147])
        by smtp.googlemail.com with ESMTPSA id se16sm1814128ejb.93.2020.07.08.04.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:09:25 -0700 (PDT)
From:   louis.peens@netronome.com
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, oss-drivers@netronome.com,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH bpf-next] bpf: Fix another bpftool segfault without skeleton code enabled
Date:   Wed,  8 Jul 2020 13:08:27 +0200
Message-Id: <20200708110827.7673-1-louis.peens@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

emit_obj_refs_json needs to added the same as with emit_obj_refs_plain
to prevent segfaults, similar to Commit "8ae4121bd89e bpf: Fix bpftool
without skeleton code enabled"). See the error below:

    # ./bpftool -p prog
    {
        "error": "bpftool built without PID iterator support"
    },[{
            "id": 2,
            "type": "cgroup_skb",
            "tag": "7be49e3934a125ba",
            "gpl_compatible": true,
            "loaded_at": 1594052789,
            "uid": 0,
            "bytes_xlated": 296,
            "jited": true,
            "bytes_jited": 203,
            "bytes_memlock": 4096,
            "map_ids": [2,3
    Segmentation fault (core dumped)

The same happens for ./bpftool -p map, as well as ./bpftool -j prog/map.

Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
Signed-off-by: Louis Peens <louis.peens@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/bpf/bpftool/pids.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 7d5416667c85..c0d23ce4a6f4 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -20,6 +20,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 }
 void delete_obj_refs_table(struct obj_refs_table *table) {}
 void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
+void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_writer) {}
 
 #else /* BPFTOOL_WITHOUT_SKELETONS */
 
-- 
2.17.1

