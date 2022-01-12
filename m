Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF148C60A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354130AbiALO1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354153AbiALO1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:37 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C97C061748
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:27 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id t7so3113610qvj.0
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IsVb9B9OD9HxbWBjwrwutVLUxC8m+FYRJd9a2MlORE=;
        b=QoSNuZmz52Hkl9O7B34ixhlxJLgwZGYTaDPOTehc/2FzgdhwlvrLXJQjCni1p9ZnY6
         zAzbO9LRP7MU4XjNFfWrV2fGtPag8cKcVxiwHS8HVWra3o+11wSd3dSSZMtQpp8VkXZv
         4WPfJVfrdKLw3Fzf9K6op4/FJCecF1zpmSSh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IsVb9B9OD9HxbWBjwrwutVLUxC8m+FYRJd9a2MlORE=;
        b=7p2u/omA5w1fhsLfEh4V1TzZxtmgZ577eoIHgiz/pZ7658wVBKPqQXTdOq86H5nhVQ
         WfbZvCkZJ+U22glkj+4nVb79dK+DaIfYDJXuI2OAVWUsACzceexPpiVIW6mrRxl/efh+
         pW3nIUJmFVipf6nS695pFx0kO8ST5mLp0rPEVW2Bl+oLbavtxMBGp4gj6CIo6Zef09k1
         FJxXHp3a223yXhMEyV0XzJXPIWJJUJco/sIDB3gX7imeO9F8fhs59m1kFT7VvlgzUTJd
         DbqvPn6cmXMNbH+9u4YRPNxuh4fOnAFg3v1ItqpYmtXfqnuhBx7de34JrUA6pS34AoUc
         H2jw==
X-Gm-Message-State: AOAM532PQOs/gy122UmqDQrkI54EpjPGdNqWk8rQ7i0nNBQJdWPDIY9I
        +9j7E+sv+TgLAgIHUVYBDqDAggjcQcUgYSwuO7qP8E09p9IQ5pIfgR0Blo6Zx1gQOuJsKYmIQ63
        ImQHgd6RCifTYWLEA9rnDlqYFo4PmLOgrT/mzcFY0c1UuTd/MFb61drvz+zfFTCPZV5ZZ151t
X-Google-Smtp-Source: ABdhPJxgVxaxUN+fzXiEYHiS6XJQn0OP4HrG8KaLG5D5JMMfw7DyrySF8l++HZbE7WQkN6aLysuD6w==
X-Received: by 2002:a05:6214:1d27:: with SMTP id f7mr8326545qvd.107.1641997644047;
        Wed, 12 Jan 2022 06:27:24 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:23 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 4/8] bpftool: Implement btf_save_raw()
Date:   Wed, 12 Jan 2022 09:27:05 -0500
Message-Id: <20220112142709.102423-5-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Helper function to save a BTF object to a file.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cdeb1047d79d..5a74fb68dc84 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1096,6 +1096,36 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+static int btf_save_raw(const struct btf *btf, const char *path)
+{
+	const void *data;
+	FILE *f = NULL;
+	__u32 data_sz;
+	int err = 0;
+
+	data = btf__raw_data(btf, &data_sz);
+	if (!data) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	f = fopen(path, "wb");
+	if (!f) {
+		err = -errno;
+		goto out;
+	}
+
+	if (fwrite(data, 1, data_sz, f) != data_sz) {
+		err = -errno;
+		goto out;
+	}
+
+out:
+	if (f)
+		fclose(f);
+	return err;
+}
+
 /* Create BTF file for a set of BPF objects */
 static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
 {
-- 
2.25.1

