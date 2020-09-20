Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D5227127D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 07:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgITFCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 01:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITFCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 01:02:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F1DC061755;
        Sat, 19 Sep 2020 22:02:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u9so5182889plk.4;
        Sat, 19 Sep 2020 22:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zf+F5l4BOBKHcTchW4Xrun/P792neDZIw8SXQYChyx8=;
        b=pwu62dsujY21zRrqVdCN4xjg1zMPVfJ6bpTeI2jGKrUyaJP9XUf/V73AqJmZHpxXn8
         mbVW/xNIY4LRtJ9sizRS9aQhvukpMAIz4DGeK1aRK2mWyyxaPDGUMalxL351AIQTzOD7
         Nwz+gUgt7h1JJgxOymrrzJLypTz13T0bBJ47O3F/FNNoYweray4pnTqbMy8J2xlbzl0S
         +bDbh1YNIMdGv4dcffnhn/KDboLQ0pk7F0E7eJ8T8eAtRWlKbkC9cT5wb/WfBFC3lbR4
         WRpR/PQiDU5XjrCBed1T4iRYBeFBAuvYjOy+jAxxHqOgZ2BJ1bL6jO8zXj4eXyyVnbcW
         0ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zf+F5l4BOBKHcTchW4Xrun/P792neDZIw8SXQYChyx8=;
        b=HB0IYxxNObpOx96mR/IU9KuvWmLPWJY+w6oEG7eTKMwDCT5ahKHYdMc5b+UqiPNnzJ
         uLr1mgLyD5E/SIWSb/geYtWwVpJVt8b02J7Co8pCWsog214Dob2Fchuf/OCnn7AowWdt
         uTc9IIwYEHb9Tm/bQWYbwBsJYX8BAp7GMfD9x4WFV3oARcYCUxC1EA3eR9k5OyXR/5mr
         LreD2tDHhiGE924zNGXh3pA1rCKx00uNhkLXZBcBwNA+WvO9e/h5I+g8C5IoiM7frnP7
         ihq2H3zMfBSNqTuStQfKGSWIEbG2n79OUNQXZAwavdzPAIDLQOkJM5fnM0tA3Kb3tdDs
         TW3g==
X-Gm-Message-State: AOAM530hXzYuCUe8yqWtjPvPtd9/yLslYZF6lrPILdPLgN2Kxs8UsOuX
        jt16DXIEUEEfZBbIhG7ugoU=
X-Google-Smtp-Source: ABdhPJyKvHtlZDtNBQWDrwzNX2viJkG/PDEGBhae2HyhmHWRadjwR2S9VQW+lzDLIQmvA2yAVwdPRw==
X-Received: by 2002:a17:90a:fb52:: with SMTP id iq18mr19562285pjb.207.1600578134799;
        Sat, 19 Sep 2020 22:02:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:d88d:3b4f:9cac:cf18])
        by smtp.gmail.com with ESMTPSA id w19sm8432556pfq.60.2020.09.19.22.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 22:02:14 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH bpf v1 3/3] libbpf: fix native endian assumption when parsing BTF
Date:   Sat, 19 Sep 2020 22:01:35 -0700
Message-Id: <90f81508ecc57bc0da318e0fe0f45cfe49b17ea7.1600417359.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code in btf__parse_raw() fails to detect raw BTF of non-native endianness
and assumes it must be ELF data, which then fails to parse as ELF and
yields a misleading error message:

  root:/# bpftool btf dump file /sys/kernel/btf/vmlinux
  libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux

For example, this could occur after cross-compiling a BTF-enabled kernel
for a target with non-native endianness, which is currently unsupported.

Check for correct endianness and emit a clearer error message:

  root:/# bpftool btf dump file /sys/kernel/btf/vmlinux
  libbpf: non-native BTF endianness is not supported

Fixes: 94a1fedd63ed ("libbpf: Add btf__parse_raw() and generic btf__parse() APIs")

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 tools/lib/bpf/btf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7dfca7016aaa..6bdbc389b493 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -659,6 +659,12 @@ struct btf *btf__parse_raw(const char *path)
 		err = -EIO;
 		goto err_out;
 	}
+	if (magic == __bswap_16(BTF_MAGIC)) {
+		/* non-native endian raw BTF */
+		pr_warn("non-native BTF endianness is not supported\n");
+		err = -LIBBPF_ERRNO__ENDIAN;
+		goto err_out;
+	}
 	if (magic != BTF_MAGIC) {
 		/* definitely not a raw BTF */
 		err = -EPROTO;
-- 
2.25.1

