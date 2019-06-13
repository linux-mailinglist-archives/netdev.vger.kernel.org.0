Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1643B56
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfFMP2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:28:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38896 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfFMLc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:32:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so20373831wrs.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AF1205N89OZNViaP6acWXh6mHKPDql5m0Yi3tu1T8h8=;
        b=TbGt75o/WSp1OSUJTHNYCciigYJKAYY6solbnb+OPu7egwRHpZFyTp57t0BC1acpgS
         TAPKFVoWfjLIyWlG5lM6ccnEx04BY1qZTdskF0iD/gBFok1EC4Jb4k98qIWfHxkzKXFg
         UCMZerFSt04ZfSvT63r76NMFvJdbfCUTVST3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AF1205N89OZNViaP6acWXh6mHKPDql5m0Yi3tu1T8h8=;
        b=SNpiOC3NVtu34/9RuPUnBGjkdPY7a3527OmSBfy46cyRsxWc8E7QuNES1so/1XxjkN
         IO4jF/94iAn9qejkBICux5kovGCIEVBM3p4KGsC5Dj2UKHsQC6xXlIbj/wguqMSRKhrz
         igLWxHW045JeyCQ2AmW1se/UuKwA26dS5NAA9m/2w19K3cI5n2ke7hf0UA03V9X7DLY6
         1ZbLk6P32z6kDKBWeb3OGP+z+Y/CJ+fkznBS1i5U/uNOP6en667PPG+20hzjbP9MpEao
         ZZWYZWwwj00w8lNmQfVt5t4YYAcB/6hnsCWY73TxZwdo593ZzVe08Mx2oK0vRWly8Jyy
         tb2g==
X-Gm-Message-State: APjAAAVFg/xHcxS7UMJYOj7hSIsF5eviwW2VrZUuKG9H32NEf9OgiCK3
        O7KPtLokHve8uOIA/2z77q9efw==
X-Google-Smtp-Source: APXvYqyrdLnXSnjStU6hbkGo3KfeeAceiBKHAZw2YLa7AT/MAbzkQIg0WRzmMIvQXvl4kd3Mo2rHUA==
X-Received: by 2002:a05:6000:128f:: with SMTP id f15mr5748511wrx.196.1560425577814;
        Thu, 13 Jun 2019 04:32:57 -0700 (PDT)
Received: from localhost.localdomain ([147.12.216.9])
        by smtp.gmail.com with ESMTPSA id f2sm2646740wmc.34.2019.06.13.04.32.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:32:57 -0700 (PDT)
From:   Arthur Fabre <afabre@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Arthur Fabre <afabre@cloudflare.com>
Subject: [PATCH] bpf: selftests: Fix warning in flow_dissector
Date:   Thu, 13 Jun 2019 12:27:09 +0100
Message-Id: <20190613112709.7215-1-afabre@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building the userspace part of the flow_dissector resulted in:

prog_tests/flow_dissector.c: In function ‘tx_tap’:
prog_tests/flow_dissector.c:176:9: warning: implicit declaration
of function ‘writev’; did you mean ‘write’? [-Wimplicit-function-declaration]
  return writev(fd, iov, ARRAY_SIZE(iov));
         ^~~~~~
         write

Include <sys/uio.h> to fix this.

Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index fbd1d88a6095..c938283ac232 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -3,6 +3,7 @@
 #include <error.h>
 #include <linux/if.h>
 #include <linux/if_tun.h>
+#include <sys/uio.h>
 
 #define CHECK_FLOW_KEYS(desc, got, expected)				\
 	CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,		\
-- 
2.20.1

