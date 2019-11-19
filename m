Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAAA102262
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfKSK4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:56:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34722 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfKSK4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:56:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id e6so23302661wrw.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 02:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=B3cvFN0sV7vP1/4W3mkjIAztsEiOA8058seTVeqat30=;
        b=oiiDJnMqz/YYfH3eiMD1VlCX4h8Iwu+l8wk1MGiL12I8I/AB+SNye3vxEXWHtmpdAB
         HjwuH2uPg2JNvhEDwIRrNc0NZM36xSQsujRJa1DeC72Egca6mTnhgKtMg4Pm/rQFaZG5
         092hqkIVElBokk+oxA3uKlifFtmrVZDIFseUAhSVHBvUYUbjeAaWWuGPjYSvFlOeBL8q
         05BiD0kSoO8WlvCsUbA0U8O+2FzRu3EFElYEj6pMSdSFOQ2UXg/dnZXk/CgXBGtDYk6L
         s+AVt566+UvamOFKoYxpsZQYdvlGQ1j+3/JLisJGoklXbhY9wHN82u3GcMmmNKD5IVYk
         3e1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B3cvFN0sV7vP1/4W3mkjIAztsEiOA8058seTVeqat30=;
        b=F8KRTjNjsYcVqXfOFK98UtcbarlSirWjVcApuCM12u87KhH5neO6H5g7QlvuVPKfmw
         1v5tO3IFqPb6c0Gc694DzlCJHa1RxdJ/BAbtfHgx9i9sibbKO2T2H4ovFBpZ/xeyRIGC
         OFiLUsUHbPWIcNEPcJ2BVuFMEqbRX63wa3J2eJ0m/nmC68+vNxYlwrWmYkKnakbOnBuR
         bHH5Dj89xl/NNhTmR4LvJkFVCqkX5VFas/x8o4XAhf3FTqrFkxwp/jnbXi5OBvxZB6yw
         1PicaA1zT023GYA3USIMNk03dml6QDJ/jcQJu2vaqR5H7SFwpr5p8HJm9bp/Y4fHDbnU
         WVJQ==
X-Gm-Message-State: APjAAAUPxrWJuGvEyC3TQJ6dFs6oDEkH+2Z7wV874ZtNARbywNcP/Z5L
        WgFfF/4Fn80V0ncNnZPsl2elxw==
X-Google-Smtp-Source: APXvYqxorn4an1kHyY3fcuCNkfqdOqwRG82ntdv09csfGXY1ckFBneZAIWevm9urjffF8erk4aoJgw==
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr35281585wru.23.1574160997872;
        Tue, 19 Nov 2019 02:56:37 -0800 (PST)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id u4sm26531835wrq.22.2019.11.19.02.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 02:56:37 -0800 (PST)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH bpf-next] tools: bpf: fix build for 'make -s tools/bpf O=<dir>'
Date:   Tue, 19 Nov 2019 10:56:26 +0000
Message-Id: <20191119105626.21453-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building selftests with 'make TARGETS=bpf kselftest' was fixed in commit
55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine
srctree"). However, by updating $(srctree) in tools/bpf/Makefile for
in-tree builds only, we leave out the case where we pass an output
directory to build BPF tools, but $(srctree) is not set. This
typically happens for:

    $ make -s tools/bpf O=/tmp/foo
    Makefile:40: /tools/build/Makefile.feature: No such file or directory

Fix it by updating $(srctree) in the Makefile not only for out-of-tree
builds, but also if $(srctree) is empty.

Detected with test_bpftool_build.sh.

Fixes: 55d554f5d140 ("tools: bpf: Use !building_out_of_srctree to determine srctree")
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 5d1995fd369c..5535650800ab 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -16,7 +16,13 @@ CFLAGS += -D__EXPORTED_HEADERS__ -I$(srctree)/include/uapi -I$(srctree)/include
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
-- 
2.17.1

