Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399E825910C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgIAOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:44:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59778 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728529AbgIAOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598971436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=N/3cZ45ws6CSpWNztTbFWfPu1DKoEaZi3oHeIW0RUdU=;
        b=BuvvR6iZ52L4Ds90KROnb2wq2mlRUq0vJihy/wkIEuzYLnAOf2p/St9XIbj8jVtRaBktRQ
        sLbCk6CUdlmoBLaG6Y0cwYxErw83OCTS7+TnKux/qOsPKVX3XYu0M6mlRoImot7Lvp/bL4
        JS0w+FRBYEnhu5s5stKKEZUR/wI3PP4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-SKfK184WOM6ED5LO_AYGdw-1; Tue, 01 Sep 2020 10:43:54 -0400
X-MC-Unique: SKfK184WOM6ED5LO_AYGdw-1
Received: by mail-wm1-f70.google.com with SMTP id b14so479040wmj.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 07:43:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/3cZ45ws6CSpWNztTbFWfPu1DKoEaZi3oHeIW0RUdU=;
        b=FAAxrU9SfCnbgmsTA7vNMJXgZvUY4lOLe2QzXuG3SpWdg5VC9zmM9JAnfVQ6RmuPJe
         Ixx6OtpV87ksL8FeJ9woj38ua6H5LJGSGn73VUJ2RX1wSy9SAld4fHuZqXL0jA/IlPVU
         q14xEyooc1ET00nydfJznk/SmFCo8tF+XbY6o5WAIAjqwPEQdvD+sORSHiFhKrr04J6m
         3PaycUjtbSP+D96MBcf5oekHfgpcjj21ourJMjCQJHhmkwMel4yfzHMYbWIf+5CYhfhu
         NAsIuM/eTnwjC4ZfJHRA6o0mVmz84G5S8MwncAd630pbMPW6hbv21hx1FfhjEdn/uCDJ
         Iovg==
X-Gm-Message-State: AOAM5330yJGnbaFe9Hon+bW7GcC0cAZ2kq+ntJfSfYoi+3nj+NdfKDUl
        aohh8Uc4yxZhNt8Gvv4mMvabbnJyrRYjNztmbpxrsKHa69RTgaf49yxys2x1csHpDftpDPOUnNU
        3N3hnAH57ZvKyRZv/
X-Received: by 2002:a5d:5090:: with SMTP id a16mr2445019wrt.247.1598971433243;
        Tue, 01 Sep 2020 07:43:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvQ7w1GqqPZe6MnWMkKZ54vl061T1Uj2BOT2lUqOpcqWj3ssZKIG7QE6NMTZ1Ts+v5nxrGtA==
X-Received: by 2002:a5d:5090:: with SMTP id a16mr2445001wrt.247.1598971432948;
        Tue, 01 Sep 2020 07:43:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z11sm2700981wru.88.2020.09.01.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:43:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A612C1804A2; Tue,  1 Sep 2020 16:43:51 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, jolsa@kernel.org
Subject: [PATCH bpf] tools/bpf: build: make sure resolve_btfids cleans up after itself
Date:   Tue,  1 Sep 2020 16:43:43 +0200
Message-Id: <20200901144343.179552-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new resolve_btfids tool did not clean up the feature detection folder
on 'make clean', and also was not called properly from the clean rule in
tools/make/ folder on its 'make clean'. This lead to stale objects being
left around, which could cause feature detection to fail on subsequent
builds.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/Makefile                | 4 ++--
 tools/bpf/resolve_btfids/Makefile | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 0a6d09a3e91f..39bb322707b4 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -38,7 +38,7 @@ FEATURE_TESTS = libbfd disassembler-four-args
 FEATURE_DISPLAY = libbfd disassembler-four-args
 
 check_feat := 1
-NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean
+NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean resolve_btfids_clean
 ifdef MAKECMDGOALS
 ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
   check_feat := 0
@@ -89,7 +89,7 @@ $(OUTPUT)bpf_exp.lex.c: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.yacc.o: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.lex.o: $(OUTPUT)bpf_exp.lex.c
 
-clean: bpftool_clean runqslower_clean
+clean: bpftool_clean runqslower_clean resolve_btfids_clean
 	$(call QUIET_CLEAN, bpf-progs)
 	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg \
 	       $(OUTPUT)bpf_asm $(OUTPUT)bpf_exp.yacc.* $(OUTPUT)bpf_exp.lex.*
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index a88cd4426398..fe8eb537688b 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -80,6 +80,7 @@ libbpf-clean:
 clean: libsubcmd-clean libbpf-clean fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
 	$(Q)$(RM) -f $(BINARY); \
+	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
 	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
 
 tags:
-- 
2.28.0

