Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 731EC183247
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgCLOEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:04:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33032 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbgCLOEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:04:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so7660206wrd.0
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 07:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPD9Ct/DI8VhQtjf8WRPLV9rqXLEqSZ2Q3m0QZc0Ugc=;
        b=Siy0OOHjEwDyjcA65zZN+WBDMRo3B1rf1vRjl+AI8NEm02aVpAWRLtdQuKHmf84uLk
         5cWt+Nt1G5ry1n0WUbP0F22dm8OzLM2yVfneN3jtcWruk6XFd+68SQMF3yx/KWAU7Q+2
         4swpW0fWiB4wrqTb3pYOnicxEMo09eyL3v1GifczSlxfGFT11UZaswmXQlcz6fFPdhgk
         4DBrTzwNpsEadO6YlVhFgZAJ0jXIcuHQ6xEp09FkY0oaz+5rBI5ORis7Qn6SSslz6ZlC
         1FlwYil7S4TE0calyHPkNj2jZX2Wv52n3JR/UTFCVCAOOPn9JiLQ1ONHFTR7bdOanDtN
         NwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPD9Ct/DI8VhQtjf8WRPLV9rqXLEqSZ2Q3m0QZc0Ugc=;
        b=qDzlWNYuLlqnZ49edZlgQ0Va3t+JFaepqadaNmKvAL7Cjei4wde6AeFG+G+P55HOxu
         SMhH1qiaIJCCjlqbmJisGJAxL3P+ObTl6IrJjqW9PHfmswaucazUxC1SK9Bb1rv5i3CV
         MBqcK0UMjPWB2v7gDm5+OV584uIBVLaxCd5jzrvydaZfAp2tGwhD6kY+kjvIboEbmAYn
         pMCLdNrpxLPG5YfrQQrVBxrGrRqw7SHnGpURn8XA7g5a7pAQR97Xsk9oYIh/mbrdk5Y1
         xt2V8J1YtDxg5Kd1fMB4UsBOim+8FjYUA2/lOLEaTmk1bvsuIHd6SPK1SQA7NrLyRE17
         nkog==
X-Gm-Message-State: ANhLgQ20vuxhiTDa5ZM3OQDDpNm1IDIKeqEXX8MkpvkZ11zjNtdbG8jh
        OF9Kb7/11VwBKg5fNC6IfyTAGQ==
X-Google-Smtp-Source: ADFU+vtAv+PXD+35s6APV+bYvs2KIEeI7QOBw3Py+0RRh2/Z4f/d8AemLG05sAQpPwFrDMxIZg1LjQ==
X-Received: by 2002:a5d:4584:: with SMTP id p4mr11006878wrq.318.1584021849690;
        Thu, 12 Mar 2020 07:04:09 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id d18sm12509405wrq.22.2020.03.12.07.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 07:04:09 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Michal Rostecki <mrostecki@opensuse.org>
Subject: [PATCH bpf] libbpf: add null pointer check in bpf_object__init_user_btf_maps()
Date:   Thu, 12 Mar 2020 14:03:57 +0000
Message-Id: <20200312140357.20174-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling bpftool with clang 7, after the addition of its recent
"bpftool prog profile" feature, Michal reported a segfault. This
occurred while the build process was attempting to generate the
skeleton needed for the profiling program, with the following command:

    ./_bpftool gen skeleton skeleton/profiler.bpf.o > profiler.skel.h

Tracing the error showed that bpf_object__init_user_btf_maps() does no
verification on obj->btf before passing it to btf__get_nr_types(), where
btf is dereferenced. Libbpf considers BTF information should be here
because of the presence of a ".maps" section in the object file (hence
the check on "obj->efile.btf_maps_shndx < 0" fails and we do not exit
from the function early), but it was unable to load BTF info as there is
no .BTF section.

Add a null pointer check and error out if the pointer is null. The final
bpftool executable still fails to build, but at least we have a proper
error and no more segfault.

Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
Cc: Andrii Nakryiko <andriin@fb.com>
Reported-by: Michal Rostecki <mrostecki@opensuse.org>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 223be01dc466..19c0c40e8a80 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2140,6 +2140,10 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		return -EINVAL;
 	}
 
+	if (!obj->btf) {
+		pr_warn("failed to retrieve BTF for map");
+		return -EINVAL;
+	}
 	nr_types = btf__get_nr_types(obj->btf);
 	for (i = 1; i <= nr_types; i++) {
 		t = btf__type_by_id(obj->btf, i);
-- 
2.20.1

