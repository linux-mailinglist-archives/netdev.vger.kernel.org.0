Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD8DD0CD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506080AbfJRVDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:03:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45517 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbfJRVDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 17:03:16 -0400
Received: by mail-qk1-f193.google.com with SMTP id z67so6588731qkb.12
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 14:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWZAkLkuf567hI/C/lD9CQJLxDFYVtiH/xOhZ8ZASPo=;
        b=Lh4fr/kFYeFHdXUvVhQGUu5VU9RUS4sAA4hBMjZqkPnPqpnP2sYhjw3iQbiZcF0tCp
         wtYUuSuTcQWci9pJz+6mrUKlQ7pQocKN23xYElkCikPo1p8lbtnVe6tWv6OinNL6kWYN
         a7JTU3NDUVMZk+o97PmnmRqsgKKMemnIR0F3/ouh10F8YfRt1gdutfgPGegwU9dVmP+t
         8ToK4MiFekzR37cs5PVBUokMCpedJjxLUeOujFqNG6a4V/uY5L6VXWlp9M7HBQWthAw5
         d4pLwnDD/Bxy4SIQXpBuSMzs45pHNaRZv+hhYV9JYJYC/UsAS8Njz8x0ynaQCpC0p51p
         P8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWZAkLkuf567hI/C/lD9CQJLxDFYVtiH/xOhZ8ZASPo=;
        b=ukyTwKGSY3T1P0VZMZoI6IVSjh6eBcqsQzb7+Z5UfPF4cI05w3a8wnwDuJ5JFt2b13
         qnIH4N3WNAk72+BsiN3g50tnreRnCNRbOAU3W3JXkRygRRcFHLiFeToSmrbE8ELlZ8ts
         GnEXiRGfv93Go/MDlWRhD16ykMfK3OD9fsYllxctM2RaGCoUJWQoHIYB/rkLfhz2VlsQ
         S3dl0TuObVn/XtP7Xa3cUfbIqiD607OJULLBKlKB+EAgR7LCagVtesYsc7qMKPTmi/SM
         cnnXcoXlLyeWjnm+ZR35tBk9DCw5WF4FaYjYo0n6uNlyLeSa/ZoivGodlrmZ97pTivOr
         h/fg==
X-Gm-Message-State: APjAAAV/fxebBlrMVGl++yf40REj1a0zwaHAS/m6ZCTE0QbX1hph6y0c
        KWW/Ynj7/N818H2dT4GAF6c9snN+
X-Google-Smtp-Source: APXvYqyY13xrNRlpYHLQ7oYkBA6O1z7zQh9b1LklRKZGeMGpXS1zpsAy9GI/T1dypV77+bcHC7N5VQ==
X-Received: by 2002:a37:5257:: with SMTP id g84mr10959168qkb.247.1571432595412;
        Fri, 18 Oct 2019 14:03:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s16sm2952678qkg.40.2019.10.18.14.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 14:03:14 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] net: dsa: fix switch tree list
Date:   Fri, 18 Oct 2019 17:02:46 -0400
Message-Id: <20191018210246.3018693-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there are multiple switch trees on the device, only the last one
will be listed, because the arguments of list_add_tail are swapped.

Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 73002022c9d8..716d265ba8ca 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -46,7 +46,7 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 	dst->index = index;
 
 	INIT_LIST_HEAD(&dst->list);
-	list_add_tail(&dsa_tree_list, &dst->list);
+	list_add_tail(&dst->list, &dsa_tree_list);
 
 	kref_init(&dst->refcount);
 
-- 
2.23.0

