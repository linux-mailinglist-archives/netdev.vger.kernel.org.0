Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23649D35C7
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJKA2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:28:24 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40308 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKA2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:28:24 -0400
Received: by mail-lj1-f195.google.com with SMTP id 7so8024661ljw.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rC9SMV92VCkp1Gr2RjsUAyri6h3CbwRZLjtMRm5Ly2A=;
        b=n7n7nGtk8cu5ldPiMWOVomq4IEoWhI8D15Ro7zik+00sQm//xyM9I+QPGkMobvspt8
         b8cREF9EORqoA5SWIjR3MntFr/B5gcO7egbGxamOkAZsyMLW4wsvjJ71ustx90ZW7Zox
         a26jCnVWe4t7ZpxHs374/UViRLdmkrOhijdiHEaWbSc3bSI0mR+ncJHp35MXgsx7pfO4
         ZnIc3WwmA8pNB5cdja5tXOTrUIhlLhz4H3SNnNzvfbDOUIliSpXiriwzPFCNIAgENdY+
         U9oQzLwdKI3K9JqLDHwYPTKvh7MSy3zHuNPKEd/9yOT21UMav04Ui0pWdf2di+uvaxi+
         7yuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rC9SMV92VCkp1Gr2RjsUAyri6h3CbwRZLjtMRm5Ly2A=;
        b=krXtvibiJUB/YRZdXV6JfsIYUpjv0jo1BHI/Oh3Vkozv+8MbXtgy+1JM/FsKKhYxJ7
         tqmC8arR5Cyvx3aXGd27YhS4M/OU2BuERM7S8LYoK//cmlTC6UcaB6/m1nd8E+QxUJA3
         7/lrTn5ZnJyckomU8uAZNfC+rV2F06TRtg5rjCj7vJOswOYi1Qlx7UNnbCcjhTuSJJqB
         eDj0WlKym7ouVKXDQgJUhCQHj8g4GH2Zdlz9FrAvi0kjYPsr/yVhYsCBJQUNZpdqoqGC
         ZoimmgK9TitBOF6mh7kI8egBv9LB99HebqPqtENy8x4TTS8GsoQD9MvbfXEKwAc5toSP
         AAZw==
X-Gm-Message-State: APjAAAUoqggMOFBdCUgJuA40vI4TJLWvlQhc7rclBNA1zZ+B3SORArji
        c1pY01rAO+unhSgsW02ybJmYUg==
X-Google-Smtp-Source: APXvYqyytP5TpAENwnvNWDOqQ8OY/86C14vttyD28WEXvjMyhSkJB+nvEVHm4UN+556Q0dYym2Ei3g==
X-Received: by 2002:a2e:9a43:: with SMTP id k3mr7415360ljj.70.1570753702298;
        Thu, 10 Oct 2019 17:28:22 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id 126sm2367010lfh.45.2019.10.10.17.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:28:21 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 bpf-next 01/15] samples/bpf: fix HDR_PROBE "echo"
Date:   Fri, 11 Oct 2019 03:27:54 +0300
Message-Id: <20191011002808.28206-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

echo should be replaced with echo -e to handle '\n' correctly, but
instead, replace it with printf as some systems can't handle echo -e.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a11d7270583d..4f61725b1d86 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -201,7 +201,7 @@ endif
 
 # Don't evaluate probes and warnings if we need to run make recursively
 ifneq ($(src),)
-HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
+HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
 	$(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
 	echo okay)
 
-- 
2.17.1

