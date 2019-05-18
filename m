Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7B220EE
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 02:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfERAqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 20:46:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50724 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbfERAqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 20:46:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so8415003wme.0
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 17:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4J/wt/1bRO1VqR+N0Z8RIgw8kt+l268hnuB5sJUEyrg=;
        b=h2JSAiTmyWhuRAhJ6houcZfwXQipcPXDJaTDTxtqE/F+PF+Kw15zJCj1WjcNtdDZ4W
         O5RFv1c2PNXCA1cDZaiBE4uv0SEilZa+jsWMtYaWZK8tWydqueTko92ljn5yVMvTGK+Y
         9xU9uJC6yZSerib7bgNtX8BXaOUZ0/y54R+mXmYJ/UNlolOEQnWiQyYW+n+/weiKym+8
         kSpHpPxEYFyfP7EFubJDQwzBJI9m8lNWdl05n8ise2RxMEQeLHLiora/3bYEjOROHUvv
         whGsX3DVJ7LrSpc58yl4cFJ7xyKOOMr3fdUeBg31HZcJWIDofvUxM+V7jdvMz8KrJws9
         1bew==
X-Gm-Message-State: APjAAAW+aJnXFSxMIgZDVWj43iuU6DOz8u6ZmwgmjH4kV4lUSWSLcC5j
        tvd1jR853HMkv+vzZPwywMzJyw==
X-Google-Smtp-Source: APXvYqzF+1psvAoQ+dDw6U4q+Nc7IUoQS/9RUXg8csMpLyunTejTk8ztforCi8fMevmiVwXj3qTkpA==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr4094317wmg.18.1558140403006;
        Fri, 17 May 2019 17:46:43 -0700 (PDT)
Received: from raver.teknoraver.net (net-47-53-225-211.cust.vodafonedsl.it. [47.53.225.211])
        by smtp.gmail.com with ESMTPSA id f2sm11037959wme.12.2019.05.17.17.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 17:46:42 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 1/5] samples/bpf: fix test_lru_dist build
Date:   Sat, 18 May 2019 02:46:35 +0200
Message-Id: <20190518004639.20648-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following error by removing a duplicate struct definition:

samples/bpf/test_lru_dist.c:39:8: error: redefinition of ‘struct list_head’
   39 | struct list_head {
      |        ^~~~~~~~~
In file included from samples/bpf/test_lru_dist.c:9:
./tools/include/linux/types.h:69:8: note: originally defined here
   69 | struct list_head {
      |        ^~~~~~~~~
make[2]: *** [scripts/Makefile.host:92: samples/bpf/test_lru_dist] Error 1
make[1]: *** [Makefile:1763: samples/bpf/] Error 2

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/test_lru_dist.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index eec3e2509ce8..f532b894654b 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -36,10 +36,6 @@ static int nr_cpus;
 static unsigned long long *dist_keys;
 static unsigned int dist_key_counts;
 
-struct list_head {
-	struct list_head *next, *prev;
-};
-
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	list->next = list;
-- 
2.21.0

