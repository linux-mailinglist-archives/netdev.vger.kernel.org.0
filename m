Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE825EB17
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 23:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgIEVtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 17:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 17:49:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2DAC061244;
        Sat,  5 Sep 2020 14:49:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v15so6145007pgh.6;
        Sat, 05 Sep 2020 14:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h9kxAFny5FJw8YnE6dK8aDApZjgYQA9YlON014R67oU=;
        b=D1L1wvm0MIJsymgAugs62yQbiC53LsvCzN6jysg32pb23GBUx2uy8pZ7O1TUJzXjgy
         Qi99s6ctCegyX6FO+viYaUf6OcGUYbn/yGgBu/PKBQwGEL/pAha+ePQquRyArTveBMkL
         DKWmhraBOOAloF1JAyxK3IB/mlqpKZqi+nGgK59SqyJh1IMfmKavvnhmyeYsKICtCyzz
         83kFPygDZYjMbKk9wOoys/A/qbuoK6+alUbNBeqxA3NH8Dpe65pihhk06T4upOKUwRVG
         cYrOY7cGj75ATgjybjox721jDRhg9+9jK1cvzTuLr3rLxwt/U2sf2dPEpRP9RKzett/A
         rrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h9kxAFny5FJw8YnE6dK8aDApZjgYQA9YlON014R67oU=;
        b=GN9M843jUr1V/4wwd7EHEtD26B9bL3NU5U6AMNzfug7hzzrD2r8CGd+LTDoeZHMu/d
         gX80HD3bWmd3wChAChLokv3p516xZap7MlwBu5AX7MqPlOkznbTm6aELzHB7C212qhUc
         DqyBOVWSLDOoCZ8nHo2XhqGi9wbqYN2hGQg+ie8wDTQvVh2kw0GQEl4PK/MuRRMBHzA+
         gOox/q1b2z61YoeL3lfzdWPbWaeUdevE1DA9tQrlGt8Zx5udV5HlpZs0BRNPCvAlBVce
         3yE+dJQlIjl3I8Omz3uOX/6c0GHl+KkcuL9BB4yeUCymKStFePuxWY1bs7dwG6xzPrMJ
         n2tQ==
X-Gm-Message-State: AOAM532H2FEb8gSvO5WWgFoyQxelyOk8QAOAqqkZL9XGRP7R9/WEeisU
        8glfYd8s6S9IdLC5yECF0/z8/ROtdhndOg==
X-Google-Smtp-Source: ABdhPJzPDXsjtTUp6flqeq21tWPefZfr1H/UbsW1i1xDxOQaZLnILrOJ/4AwYQ8S/5i/dMFc1knthA==
X-Received: by 2002:a63:af01:: with SMTP id w1mr12015829pge.23.1599342536963;
        Sat, 05 Sep 2020 14:48:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:79f7:a90d:5997:d01])
        by smtp.gmail.com with ESMTPSA id s129sm10611842pfb.39.2020.09.05.14.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:56 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
Subject: [PATCH bpf v1] tools/libbpf: avoid counting local symbols in ABI check
Date:   Sat,  5 Sep 2020 14:48:31 -0700
Message-Id: <20200905214831.1565465-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Encountered the following failure building libbpf from kernel 5.8.5 sources
with GCC 8.4.0 and binutils 2.34: (long paths shortened)

  Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
  match with num of versioned symbols in libbpf.so (236). Please make sure
  all LIBBPF_API symbols are versioned in libbpf.map.
  --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
  +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
  @@ -1,3 +1,5 @@
  +_fini
  +_init
   bpf_btf_get_fd_by_id
   bpf_btf_get_next_id
   bpf_create_map
  make[4]: *** [Makefile:210: check_abi] Error 1

Investigation shows _fini and _init are actually local symbols counted
amongst global ones:

  $ readelf --dyn-syms --wide libbpf.so|head -10

  Symbol table '.dynsym' contains 343 entries:
     Num:    Value  Size Type    Bind   Vis      Ndx Name
       0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
       1: 00004098     0 SECTION LOCAL  DEFAULT   11
       2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
       3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
       4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
       5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
       6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1

A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
same with the libbpf.so DSO for consistent comparison.

Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 tools/lib/bpf/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index b78484e7a608..9ae8f4ef0aac 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
+			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
 CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
@@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
 		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \
-- 
2.25.1

