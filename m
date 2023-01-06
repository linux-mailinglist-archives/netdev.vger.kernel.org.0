Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2565FED5
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbjAFKYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjAFKYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2146A0D6
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PziZJrBZEmAJ2mCxXBb9H2GVdzSAZnr8fRD1vWo64L8=;
        b=RxyjeyLZojTSm37QhhkPqcGT+A8tSghW3KOMqxVTaBI9W+iDXpmSb3tyh9XrCjNtCbQqBu
        MyGThob1zxBPQ8ottD9r9ugFwkDZMOSRzeXh7IkvlFpLNCC8gMxpbyzZc4TaDBMCcXrsR/
        +qK8hpK2+UlD2tC9kBHMn+7WzxTsmdw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-k44jRNtVMl-k4sI-WSFmwg-1; Fri, 06 Jan 2023 05:23:44 -0500
X-MC-Unique: k44jRNtVMl-k4sI-WSFmwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 430BD1871D9A;
        Fri,  6 Jan 2023 10:23:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50775C15BAD;
        Fri,  6 Jan 2023 10:23:42 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 2/9] selftests: hid: allow to compile hid_bpf with LLVM
Date:   Fri,  6 Jan 2023 11:23:25 +0100
Message-Id: <20230106102332.1019632-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang doesn't like to compile a source to the final binary directly:

clang-14: error: cannot specify -o when generating multiple output files

So split the final rule in 2, and ensure we compile all dependencies
before.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index f6fc5cfff770..83e8f87d643a 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -91,10 +91,6 @@ $(MAKE_DIRS):
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $@
 
-$(OUTPUT)/%.o: %.c
-	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
-
 # LLVM's ld.lld doesn't support all the architectures, so use it only on x86
 ifeq ($(SRCARCH),x86)
 LLD := lld
@@ -223,7 +219,11 @@ $(BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(OUTPUT)
 	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
 	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked1.o) name $(notdir $(<:.bpf.o=)) > $@
 
-$(OUTPUT)/%:%.c $(BPF_SKELS) $(KHDR_INCLUDES)/linux/hid.h
+$(OUTPUT)/%.o: %.c $(BPF_SKELS) $(KHDR_INCLUDES)/linux/hid.h
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+
+$(OUTPUT)/%: $(OUTPUT)/%.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
-- 
2.38.1

