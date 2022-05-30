Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7A537F9F
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiE3N6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbiE3N4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D4D972AC;
        Mon, 30 May 2022 06:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE5EB80DAD;
        Mon, 30 May 2022 13:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0A1C385B8;
        Mon, 30 May 2022 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917918;
        bh=6t5NeJu6yyqi32lyvzzECvUispiw6aNCFOACj0b6dmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCT/ysQrzg+vPV9TNDk6hv8C05K9J/jv+OIpd4BGQB0fhU7hhELmMHVYwRL1PtJ1a
         xXqJvdIR9QJNn3IaMeW5Z4lksmlgSz6nltTTXPnjpJ0HxeSbkWI4/kP2TMGvr51Gic
         k3knXptE/mij1dJ8Pci282AOLKYKYm0T5FdsQkbs2yC8gJ93u3Uuq9OcQrTm9hErMY
         eMw3U3vG0tz182fPa8xd/csBR7FAleW1ImRbRvZOR6L/nuTXRNF4CQABdNamG9z/Ri
         nIwm6+68V2wNk/RToB0WbY8TvoEuaBjQzjvZcMiwiCAurU/FscyvB04rflVKnnQJRQ
         r2EEm04ZInVRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 005/109] selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync
Date:   Mon, 30 May 2022 09:36:41 -0400
Message-Id: <20220530133825.1933431-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

[ Upstream commit 4eeebce6ac4ad80ee8243bb847c98e0e55848d47 ]

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

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220404140944.64744-1-quentin@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index be54b7335a76..5717db4e0862 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -172,7 +172,7 @@ class FileExtractor(object):
         @enum_name: name of the enum to parse
         """
         start_marker = re.compile(f'enum {enum_name} {{\n')
-        pattern = re.compile('^\s*(BPF_\w+),?$')
+        pattern = re.compile('^\s*(BPF_\w+),?(\s+/\*.*\*/)?$')
         end_marker = re.compile('^};')
         parser = BlockParser(self.reader)
         parser.search_block(start_marker)
-- 
2.35.1

