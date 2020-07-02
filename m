Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAA212B2B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGBRZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgGBRZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:25:22 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79B9C08C5C1;
        Thu,  2 Jul 2020 10:25:22 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so4985336ilh.2;
        Thu, 02 Jul 2020 10:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=5a1L/cUU/PyyphLNAPTJUUU499uUA25oZAeEw3ikCBs=;
        b=h28wOu+rsB2L+YvdUIZkUdK6TnWcw0TcHqS3Sr2Mgc6FzScgrTa/MiueKDBf0rwwLz
         lxm8QqtRm+XhSNu4QKYCQBPCn4HorvlBlQ5ljtw8TcKA8QJ0iUaOmB9L1OTztjNQO9gx
         UpcGMN3i4YU6fK5G/jEkMNFO/X94aEj8XTz0XG7KRCfZ1J27A37tKuttcckFbU9hvgBK
         YCAezlKrvFLTnr9+17ibidczPbQtdeapfqa5cXXYv8uN57ZOsNYPOFz9ulN1xuXL23Cq
         kJ98Nwf1oH5kp3DiNJkP/Pcvd+Pk+WC9s2uhZpwyU5EoggXfZi9+ASrdp7jlhoPIU0Uq
         ECYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=5a1L/cUU/PyyphLNAPTJUUU499uUA25oZAeEw3ikCBs=;
        b=ALt7QD1HTPbyPHhhHBC1KIA/jD2uTVkusY3OJgmAf3YPMIg08s2STBRcGX8Yj5xWUO
         rrD8VsoXNrf6EVumaXj2GfKfmMHcxEf2G6i3/GWaAGAO6m1Edw9Tmizd/dfC05rI0fwB
         5HoqLXhN0gYZYMLHzonQvjS45pxXFCKcWZ+7LvqsHKQsjoIxb5g0RehF2Id5Lx6BV4Yt
         OV0eQC6hDYPhNtPy2j9SOZ/k8ViQ74cxHaDYPmsYZB6yLipxmDMN6goqMeoqgFuRyDdy
         md8s3qZ0yKv4vI7pOoums/uPzRMZjBV+gqN51pURqSkFOt7bnksdcok7xLXKTjHRxACs
         UE0g==
X-Gm-Message-State: AOAM530DM9N9/YhyPE4IuFwpPO+C5PD1Bxu+DCoA3YsQVQ0z9+SZi7zP
        zMEj4Cl8A58dYyp9b96P+Vg=
X-Google-Smtp-Source: ABdhPJzeSwv0FOtn5Vxz3chkswCucMf2bs3yG+egyYK48UchHv32z0UF9AilXbQCOtNUWP8CRiqQ2A==
X-Received: by 2002:a92:290d:: with SMTP id l13mr12563679ilg.62.1593710722005;
        Thu, 02 Jul 2020 10:25:22 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k3sm5129399ils.8.2020.07.02.10.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:25:21 -0700 (PDT)
Subject: [bpf-next PATCH] bpf: fix bpftool without skeleton code enabled
From:   John Fastabend <john.fastabend@gmail.com>
To:     andriin@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 02 Jul 2020 10:25:08 -0700
Message-ID: <159371070880.18158.837974429614447605.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix segfault from bpftool by adding emit_obj_refs_plain when skeleton
code is disabled.

Tested by deleting BUILD_BPF_SKELS in Makefile.

# ./bpftool prog show
Error: bpftool built without PID iterator support
3: cgroup_skb  tag 7be49e3934a125ba  gpl
        loaded_at 2020-07-01T08:01:29-0700  uid 0
Segmentation fault

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/bpf/bpftool/pids.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 2709be4de2b1..7d5416667c85 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -19,6 +19,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 	return -ENOTSUP;
 }
 void delete_obj_refs_table(struct obj_refs_table *table) {}
+void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
 
 #else /* BPFTOOL_WITHOUT_SKELETONS */
 

