Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616B1D19D3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfJIUln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:41:43 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38732 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbfJIUln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:41:43 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so3880048ljj.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2DEOdiE8/KIZvnfCC36ibwWDO7fSHTP8+q9sblSZNeo=;
        b=wpG/4/be0Dkrcg2e3d2Y6P+Upb+QU97CDfnDDCAn0RZufZUtdAx4AGsbcIMxg82aDO
         hw0WOfvamsi/rNt1zNO5fb14dk0jx3eyiTZFvuTkb0d9KpIqNcCWRxb46uHn5Qil4BlD
         q6vA7R/HM5QpM2awInIHF3ZgnYuF8dILcbK676IpP36a7RSZLIpipstVdglbWxnYbUD/
         /JNFNNkTlXTtk9xHGsIqLXwztiHgyArDwz2jGOpFIVC8hw+R8sN7gXdyvC8M9qowpQ6A
         9Z2k0uxxen5TorR1/0SCZlZ2ku4Exm6NIObX4s/A/Zaq3jcK8MtfnX3qBOM/6QSXGZ4O
         nmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2DEOdiE8/KIZvnfCC36ibwWDO7fSHTP8+q9sblSZNeo=;
        b=gFtyWk0MDpE2WswMPF65h1hXe5fmY9E0D1c4fRzaRviCfe0wWo9vrcqDLtedW5gu1O
         4906SzGWo1r7jAZpI1y0NmBHLL6eymf06ze5xDgZk7uSXwZqluqVLKy93e9cjOPg7VXS
         Ip6bHCNxC3clsr9YtgBtqP/ePeWd4JWCxshnDkJbR1QpM1Zayu8BVNT84qzpGkUH2tlW
         wS1+DzSnHxoD7Ian9FZkhIFJyalmFBWLu2UzRtTQUb6ysQMPn5i8cAN2h2JFdq85zLqU
         mx4NGA4fYoWOHQ9qPI03WZq4BiWWLcLdJj/8d+QaUuQ9CEYbpa65NrURC9AxJKufav0Q
         PiOg==
X-Gm-Message-State: APjAAAU49q9RNLpCC0qYHZC+oVOgyUt6UhzHmtWrNDpgcJJf7xuLUOUN
        q3CgzuyaJkmwp/oGOtU8FS5j4A==
X-Google-Smtp-Source: APXvYqzfdNQcKNb+0Fk97HCYp3ZKM7+7iwvsPqRRRdUaq4tl3T6RNrhhjpFD0xted4NWuEGDG8qFOA==
X-Received: by 2002:a2e:286:: with SMTP id y6mr3679786lje.184.1570653701016;
        Wed, 09 Oct 2019 13:41:41 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id h3sm730871ljf.12.2019.10.09.13.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 13:41:40 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 bpf-next 01/15] samples/bpf: fix HDR_PROBE "echo"
Date:   Wed,  9 Oct 2019 23:41:20 +0300
Message-Id: <20191009204134.26960-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

echo should be replaced with echo -e to handle '\n' correctly, but
instead, replace it with printf as some systems can't handle echo -e.

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

