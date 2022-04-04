Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F5A4F16C8
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 16:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357321AbiDDOLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 10:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347898AbiDDOLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 10:11:53 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A998B6554
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 07:09:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d3so3887163wrb.7
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 07:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+L4j2Ipc+V3iILB7WtDi5E2e6P6IDB9Wp6ej4jzxLhk=;
        b=BFrDmLNNXRqnyP7scR/0/jh2ogo7GyAa08bEUWBwPK+L3RY3Ijh3QzKw76gKv2wMSz
         xbMy3gSQuB1haJ5xTKGnjyP4ee2x3b4C069/Vht1Uj5qxPTHPtTzPDkzG3011qACwVI8
         DKzVNUNTXpP9DKsnNismbhy5FqrO//5V2IfalK/k4kPT0XColUGXOeofI6NFGnwoM9g4
         7WdBA75HtEL1zkuBIs5l/cq4u4IxsznYfdamhXTknz/37F4JuW1eOGNHJd3IYBY3ePvS
         tpWbm01wn0t29uP5/iVjHt5pb49zTwi9GsjpcyuaSnzG3w2iate5l6jL42mSz+73hFK9
         lnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+L4j2Ipc+V3iILB7WtDi5E2e6P6IDB9Wp6ej4jzxLhk=;
        b=3w23LmJ1rLMogxhpuVAD7LptLMXiAfIznc2Zvlc0PJJbI1cWpZhXlf7iJljedi523e
         RRQSsX1JS+lIrebIPS2GrbWCoeRpubfzq9lziFEKL8ZkZHhnsDbtP0b7YyyQw2beoSDq
         47z7SeSH674qMVzFAJiegugMcCtHDxdxtJYuX6QDr1/Vfo8OCXWQlH5QPvKganVqriMH
         93pl4XBMWKlRoiRrQLSf42vo7SKAynB6DDP0n5F4zL4UWcQEUYpQYoUi+vyiud7q8Q20
         OYxhRFwDW7p4/2I/Bf/5QiUZSNJlgixrr7mfBl+55uXhLMAxExOpxB+KQSaeBC1STVT9
         1YHA==
X-Gm-Message-State: AOAM531AeHWHKmT10XxNkhdhdx7bp1vpk0vre5yu/o/tJ2a5qVl+lt97
        O9Rl0m6u0BFsi72K258Jawn8dg==
X-Google-Smtp-Source: ABdhPJyxwbpMWcgn1YVUBDQDyap/J52DrWBADjjlkmSQ5pTkFoc1V2UHP7UARJ92VtfcOC+lJ9Dnlw==
X-Received: by 2002:a5d:44ca:0:b0:206:893:6b5c with SMTP id z10-20020a5d44ca000000b0020608936b5cmr7723859wrr.145.1649081396249;
        Mon, 04 Apr 2022 07:09:56 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id n20-20020a05600c4f9400b0038cbd13e06esm17833818wmq.2.2022.04.04.07.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 07:09:55 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Milan Landaverde <milan@mdaverde.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync
Date:   Mon,  4 Apr 2022 15:09:44 +0100
Message-Id: <20220404140944.64744-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The script for checking that various lists of types in bpftool remain in
sync with the UAPI BPF header uses a regex to parse enum bpf_prog_type.
If this enum contains a set of values different from the list of program
types in bpftool, it complains.

This script should have reported the addition, some time ago, of the new
BPF_PROG_TYPE_SYSCALL, which was not reported to bpftool's program types
list. It failed to do so, because it failed to parse that new type from
the enum. This is because the new value, in the BPF header, has an
explicative comment on the same line, and the regex does not support
that.

Let's update the script to support parsing enum values when they have
comments on the same line.

Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Milan Landaverde <milan@mdaverde.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index 6bf21e47882a..c0e7acd698ed 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -180,7 +180,7 @@ class FileExtractor(object):
         @enum_name: name of the enum to parse
         """
         start_marker = re.compile(f'enum {enum_name} {{\n')
-        pattern = re.compile('^\s*(BPF_\w+),?$')
+        pattern = re.compile('^\s*(BPF_\w+),?(\s+/\*.*\*/)?$')
         end_marker = re.compile('^};')
         parser = BlockParser(self.reader)
         parser.search_block(start_marker)
-- 
2.32.0

