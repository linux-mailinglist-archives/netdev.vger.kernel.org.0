Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2648222C19F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 11:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgGXJGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 05:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgGXJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 05:06:40 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA99C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 02:06:40 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so7608409wrl.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 02:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GxnENee526BbPSGY0XIg65zijlPPPf1JtIkirCUkaeM=;
        b=jZYU8ziUDsm6BLSBzqtCVam8YZrRh70sG8YF1AnDFCuQORNHbvnOSD8Gj5IkMI3KWu
         9rM1IfyqlbJ5Ae3dztZpC0SmHcn2vPrRIhJ3IzrBMt7qMAiZ+HPdKDqY/AP4odMKbV2o
         rnnqLmlGY7p3jsSaw8JtS9Wy6IYB3E7I3bkqCEOr0Owxrwa2SKg3GFzWjjsK3GCy7kdu
         QMZSRjseaHK3idSPGrSZLP7qI8/11vlMW2CH+CoA9Hu3XplpyZHIegqJ8Es0uEIV2NXO
         L+3xUDG8SnxmpIC44G/ujkacS8evrpLHo9Bkuo4eLxJzJPp0/5ac/65e9IqBrZi6HUC/
         LaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GxnENee526BbPSGY0XIg65zijlPPPf1JtIkirCUkaeM=;
        b=n3ukox5jNISE2aTVOuqhmrAMna/MvK81dC0Hq78yVbVkm72afB1PwHdZ2k3By6YlSo
         e4J+OrSdKMH24b8iutkt6GWgo47fJ3NIjK3+ELGzgbSQT4A4e2R+hXSgF/W6dIM+mfsY
         0LXU1JC4pQidwfvjSkFCXvPGCHcrwCFMlJxEFpP2XpLS7t9lh02plVNj1OeMX+JzAvvW
         3Mq/AQOmjdbiwQLTyetgmJRoMjG3Nr9pmWoGVrSjSMeWLoK6vQItXyGFlNBplE3Xi6MX
         d/xzgn8ttVGXc2sxuaQVCMA8JrMZADaHuNADHn5OGY+V+PmDQF2IV+MMy7rRNOkB2Nv7
         gFhQ==
X-Gm-Message-State: AOAM531x2UKsenx9tfRk0miJpY/XknmM6gfeRV3JCQbVHA0VxbkVTe6v
        jki6xizx4Wz1lY+HaI+klKNakQ==
X-Google-Smtp-Source: ABdhPJykogI7r1ZL819tuTUD/yZ5fQo9cg9lTQkKWDytZ/lmue7R90FEXnSRtTQ2d50zVZ9zSlPF8w==
X-Received: by 2002:adf:f248:: with SMTP id b8mr8132157wrp.247.1595581598896;
        Fri, 24 Jul 2020 02:06:38 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.75])
        by smtp.gmail.com with ESMTPSA id t11sm527915wrs.66.2020.07.24.02.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 02:06:38 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Paul Chaignon <paul@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] tools: bpftool: skip type probe if name is not found
Date:   Fri, 24 Jul 2020 10:06:17 +0100
Message-Id: <20200724090618.16378-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200724090618.16378-1-quentin@isovalent.com>
References: <20200724090618.16378-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For probing program and map types, bpftool loops on type values and uses
the relevant type name in prog_type_name[] or map_type_name[]. To ensure
the name exists, we exit from the loop if we go over the size of the
array.

However, this is not enough in the case where the arrays have "holes" in
them, program or map types for which they have no name, but not at the
end of the list. This is currently the case for BPF_PROG_TYPE_LSM, not
known to bpftool and which name is a null string. When probing for
features, bpftool attempts to strlen() that name and segfaults.

Let's fix it by skipping probes for "unknown" program and map types,
with an informational message giving the numeral value in that case.

Fixes: 93a3545d812a ("tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type")
Reported-by: Paul Chaignon <paul@cilium.io>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/feature.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 1cd75807673e..a43a6f10b564 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -504,6 +504,10 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 
 	supported_types[prog_type] |= res;
 
+	if (!prog_type_name[prog_type]) {
+		p_info("program type name not found (type %d)", prog_type);
+		return;
+	}
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
 	if (strlen(prog_type_name[prog_type]) > maxlen) {
 		p_info("program type name too long");
@@ -533,6 +537,10 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
 	 * check required for unprivileged users
 	 */
 
+	if (!map_type_name[map_type]) {
+		p_info("map type name not found (type %d)", map_type);
+		return;
+	}
 	maxlen = sizeof(plain_desc) - strlen(plain_comment) - 1;
 	if (strlen(map_type_name[map_type]) > maxlen) {
 		p_info("map type name too long");
-- 
2.20.1

