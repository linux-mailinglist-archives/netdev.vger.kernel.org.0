Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0151E72F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 05:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEODix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 23:38:53 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:40802 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfEODiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 23:38:52 -0400
Received: by mail-vs1-f74.google.com with SMTP id l6so145515vsl.7
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 20:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=64dZO103FjaqqJ22MJxyfeFXub3dklogxlZJawwpYtw=;
        b=HM1wr/BKf8+hUTG+m9Jeld5VnMcx6ZjA0YuiKErnB9MOV8zYv2I8KxQyvF6WI+F13A
         HMeBgcaPhqw+psSVvduehQw7py0qH913PY9e4tCX3z/8roQqgKV4Urz1A0PHXyf5aczd
         I0Yk6+C0arvyJOxZsgWxFkMhzsi09HICz0N/elJVKtvG+CXGjTHBQjrFD2DU5AOuJ5lp
         tQSjDmrWGcCv7tFRWZgKak8WpIqnjJqgzPcut6qT9k61okWx3CmxKnZKTSEHMIgz01s3
         eMmRVyN87kifwOtTmGfuRuYr7e4gM2v2/lh39z1LGAbXyQcDxRTrvD/vjM54dKTwrI/l
         NVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=64dZO103FjaqqJ22MJxyfeFXub3dklogxlZJawwpYtw=;
        b=MSd2e4xNmIVC0nrwP4j4vo39zz0n/Hcq9xu9jUsHPJzNWQ5j6EIyYCzz0+Sh+FwoE9
         RoeRf04QVB83zrbVp+SGVNwezyBduRQ1nLa1fdvHIrQFpmoH/SQ0mUCocoauthof7F0Q
         QttgnyNchw6NdUk6Cb07QNCDtqtKs99spLc52mLZDmuQIHKqgihbfA9OHEEYIAGtRNsk
         8zRzAJO7bEaYZebqRJHBY0cdhqb71qiHJZrGrPd9qEFmzdfJrOaPRJwHw1zt5rcCS5bs
         YBwxJuUBJxgtFp2i0rewdci9s02ybRhzwB1k/iX2Ybm+WMbKrkPfb33c0f3DMN9zjxNz
         TYYA==
X-Gm-Message-State: APjAAAXkjnAswMT/Z1KghnRsFbJfnDvOe3okN6sgeOQO/M0/GvfNJmL+
        JIS6mv5Cnu6UPVNu7Ei48GC1dR+ZPpi3LTfgXsffEI4f2YJXD7Exf53cmLPcid3MLyCtiz2ah3t
        kYukpQ5lEuoyF7IPDChSfzZX3WNhAxkrSvUG35T8n6XwZvzaLBDRW+w==
X-Google-Smtp-Source: APXvYqw9SYTGatPCNNTFUoLzz5PUPxyum/adtbFp5CGLh/BKPFXiattJWaB4hVno3oasdRfEy34uctg=
X-Received: by 2002:a67:bc01:: with SMTP id t1mr15777058vsn.102.1557891531762;
 Tue, 14 May 2019 20:38:51 -0700 (PDT)
Date:   Tue, 14 May 2019 20:38:49 -0700
Message-Id: <20190515033849.62059-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf] libbpf: don't fail when feature probing fails
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise libbpf is unusable from unprivileged process with
kernel.kernel.unprivileged_bpf_disabled=1.
All I get is EPERM from the probes, even if I just want to
open an ELF object and look at what progs/maps it has.

Instead of dying on probes, let's just pr_debug the error and
try to continue.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7e3b79d7c25f..3562b6ef5fdc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1696,7 +1696,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 	for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
 		ret = probe_fn[i](obj);
 		if (ret < 0)
-			return ret;
+			pr_debug("Probe #%d failed with %d.\n", i, ret);
 	}
 
 	return 0;
-- 
2.21.0.1020.gf2820cf01a-goog

