Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5715CF4D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 01:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgBNA7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 19:59:34 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42792 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbgBNA7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 19:59:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so3968731pfz.9
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 16:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=varpYZ4e9HN4fOkt9AtUu2Zz+YP3IR3moNk2yDZcybk=;
        b=UgvQLtGAB7MtuSvb5VW5iX6JP4xMoRNI1OFPG2iOs+jBYmJ+WbXDLlC4AjJiw9wCv0
         F+sqYSnaOv8wS1gVLx325xQ4ryuIrHQ+2jyPELmBAqwHTgtsnX5rdCJVJ8/inT6Vi81l
         O+bZNZ2gn6fq/dtslTf7kEKAONzoRa30zdfjs9JMzix9yP0WsrRw6bk0ZiCqdtKTZ4qg
         USl12yzLNmB1Y9U4NqiQI6DtrC2ulOFYhSjsJWL8BGxtdxsO5vexuc0ug5C7GRfwq5bE
         sL+zf0Lx82VBMzHwEpo6sRl8R/fuE1E1IIYhgyjdmMhc1X4s4zhz9T6dJzcRJEl6ZoS/
         Q6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=varpYZ4e9HN4fOkt9AtUu2Zz+YP3IR3moNk2yDZcybk=;
        b=HylS8xXqVdtgEKuHSAvCQcHe0IIZqFqsNYpt91riPH3yzFDahOEuVl19z6Vhrl6cTj
         upnxQQdQEbMT8oaVf4m5N3DBM81HwCsAzkh6G9iEKx2zxFBrK1ifOYhMkd98oDM9CvZZ
         JTBfZLb8Sm2dJRbpXV8L9vnCz3NGEYvsbvyeTA2GQSng3rkDnLyY56aTc/T2fLFnYVZa
         L4+lXiOXXvTHZfxc3Il9d0/zTXh6+4SOekzfrrY3EyPo50sUN4fUw+04l1PB9SyUCnP8
         YA8Vk7ijPG5rjMHUODgGt6W7nRuEY6xMIQDeWRyICM6hbqPIZWgEO6PI5fvlDiuIf7IG
         FGsw==
X-Gm-Message-State: APjAAAWW78uALE/SE1wCplRCxRAs0HOmKrS3HE5c+tMB/d/RYg9yy8gn
        BDdd+ThqMuRaZ3dUT4GWuWYiHwGM
X-Google-Smtp-Source: APXvYqwyr+txoEK8I+6o4JJ357eA8FoNm7+oeZf4aoBqqZq7gyiUnYPml18ZWdiN7zEcdkSoova6Tg==
X-Received: by 2002:a62:8e0a:: with SMTP id k10mr636956pfe.49.1581641973348;
        Thu, 13 Feb 2020 16:59:33 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id e6sm4412759pfh.32.2020.02.13.16.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 16:59:32 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, soheil@google.com, edumazet@google.com
Subject: [PATCH mm, next-next] Add missing page_count() check to vm_insert_pages().
Date:   Thu, 13 Feb 2020 16:59:29 -0800
Message-Id: <20200214005929.104481-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Add missing page_count() check to vm_insert_pages(), specifically
inside insert_page_in_batch_locked(). This was accidentally forgotten
in the original patchset.

See: https://marc.info/?l=linux-mm&m=158156166403807&w=2

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy@google.com>

---
 mm/memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index f1d5f2264aef..3b4007a6ef7f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1463,8 +1463,11 @@ static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
 static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
-	const int err = validate_page_before_insert(page);
+	int err;
 
+	if (!page_count(page))
+		return -EINVAL;
+	err = validate_page_before_insert(page);
 	return err ? err : insert_page_into_pte_locked(
 		mm, pte_offset_map(pmd, addr), addr, page, prot);
 }
-- 
2.25.0.265.gbab2e86ba0-goog

