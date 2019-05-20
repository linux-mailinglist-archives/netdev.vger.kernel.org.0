Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFFF24326
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfETVtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:49:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35590 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfETVtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 17:49:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so3255811wrv.2
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 14:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5T1hy/hqtkGt7VlP8D6U9UrQi3KpGadAce8jNWj5ow4=;
        b=SlMRn2jggKDBUaabQx+fJeBERJseXIA9QZL8q3hm7bowmIRJcKJSH5c2IBBkyTbMFi
         InrFv2bympEtFWARv+YAW7bQP0va0YzIVMeoeFRM3RCd8FXB72KD02m2AwmJSDmscmRf
         fe5dk/iyCwBFy+dKNhV7JDtXHNGOxx6f3qwY/c1osmtcao22uCGtdVYP7rzO5DqQZUbK
         ZP/NWxWOiOQjYvsTtQcg0SmICqbMVrsGDEQhRpq85WLRm+03vYsAUxWEHJhNBYzsQ+Kq
         kblU1Hclr02VbvHvpoVqqLvDSPlPboNVgRZGO1lOery4Za3JOzlL6oTs+xtCG8sOiOef
         +LGw==
X-Gm-Message-State: APjAAAX6KRbokuyxRE0CIlZW+xQdfm5CexoQMUtMt9F0+VH5iGSSHHll
        gGjMFo+7RQ4NTfg+KdELvgRQLw==
X-Google-Smtp-Source: APXvYqwwIQVkX6hg7GUI4p5OpVeKp2TfmVkU01Kf4BLyrzgxI4SENAgED1LTN3xlqtVZ4iOr6RWr6w==
X-Received: by 2002:a5d:4a44:: with SMTP id v4mr2492195wrs.84.1558388979591;
        Mon, 20 May 2019 14:49:39 -0700 (PDT)
Received: from raver.teknoraver.net (net-47-53-225-211.cust.vodafonedsl.it. [47.53.225.211])
        by smtp.gmail.com with ESMTPSA id 197sm1466394wma.36.2019.05.20.14.49.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 14:49:38 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] samples/bpf: suppress compiler warning
Date:   Mon, 20 May 2019 23:49:38 +0200
Message-Id: <20190520214938.16889-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 9 fails to calculate the size of local constant strings and produces a
false positive:

samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
samples/bpf/task_fd_query_user.c:242:67: warning: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 215 [-Wformat-truncation=]
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |                                                                   ^~
  243 |    event_type, event_alias);
      |                ~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:242:2: note: ‘snprintf’ output between 45 and 300 bytes into a destination of size 256
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  243 |    event_type, event_alias);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~

Workaround this by lowering the buffer size to a reasonable value.
Related GCC Bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83431

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index aff2b4ae914e..e39938058223 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -216,7 +216,7 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 {
 	const char *event_type = "uprobe";
 	struct perf_event_attr attr = {};
-	char buf[256], event_alias[256];
+	char buf[256], event_alias[sizeof("test_1234567890")];
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
 	int err, res, kfd, efd;
-- 
2.21.0

