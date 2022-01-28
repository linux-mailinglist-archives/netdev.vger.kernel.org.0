Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6A4A03BC
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351729AbiA1Wdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351711AbiA1Wdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:37 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B0DC06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:37 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id e20so7206752qvu.7
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3syY77hha9Bbw40vEq8V9D9lekN0Rz7UjL/7rtB8AY=;
        b=lqqdL2FwfmUENMe5AZoc/qF13pU0r6WZW0sXTEjRFuJKZzkI15x/T3SEZw9Md+bi3d
         OWwTWtmPz2G5mtPW2gQxG3frAcDbJN5UdZfPHn87AUpdLE5o+e2b8qdH/462j10mLCZ6
         1yEPo6CisQRfbHxzxVGaVaQLd4LyPR52kFrh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3syY77hha9Bbw40vEq8V9D9lekN0Rz7UjL/7rtB8AY=;
        b=JiMRiU4rUci4zx9wYo/3RDuv/5ncYAXIW2goAT2OffgX7+Zo7uQnlRm4tLaWRiDDJG
         FZONDlkn2Yqw9iyUVszwMdD3nWk0SOEPIg8hOER7Xqyo7CcGVwUy71PeDMjo8kKXEhy4
         P+QpI1VID/s+DP1QZcFZC4XDLYaBoCKzmYNoNTOhTj21SfCCtiH94p3mODQbf2f9BqlP
         ciT0nhFZq0UzC3+iiorH1g9DTQAjyJXIgf+p6Yues1ZLojvxhehqwfUS88xuwM+6QDEE
         hFXS7zNM+vaFBezYYBF7Qx58gr+qb9EtG1KHKwre53A36NESSPVBmdiE+jfl7MEWeqbq
         ikCw==
X-Gm-Message-State: AOAM533cTjNTLB4A8gD+tbz7YxQU3NKoNigRUIx4w77yJ1EizwnVTLTt
        SOQQYrgoAym7DbtpVn0wZei2L466Ry2dE/zsNwMm+Cl+/kmpTcoLwpbP3ktuWiOxjmBCctkktU1
        VDpyHoiHxJmhbEGU2EBky9a6xQz3tjaE3csVCEuQfGApLyXlnseeu5JP/f1RZs24IGzcBXA==
X-Google-Smtp-Source: ABdhPJyI25MCaN7aVOxWm+JYxtvyFSN2GdYNxVdqO1+Ldl69N/4N2BGXZYE0nh5ne0IAUEp2gxQIGg==
X-Received: by 2002:a05:6214:e6c:: with SMTP id jz12mr9307330qvb.47.1643409214177;
        Fri, 28 Jan 2022 14:33:34 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:33 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 3/9] bpftool: Implement btf_save_raw()
Date:   Fri, 28 Jan 2022 17:33:06 -0500
Message-Id: <20220128223312.1253169-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
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
 tools/bpf/bpftool/gen.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 7db31b0f265f..64371f466fa6 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1096,6 +1096,28 @@ static int do_help(int argc, char **argv)
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
+	if (!data)
+		return -ENOMEM;
+
+	f = fopen(path, "wb");
+	if (!f)
+		return -errno;
+
+	if (fwrite(data, 1, data_sz, f) != data_sz)
+		err = -errno;
+
+	fclose(f);
+	return err;
+}
+
 /* Create BTF file for a set of BPF objects */
 static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
 {
-- 
2.25.1

