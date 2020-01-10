Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D26413778C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgAJTxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:53:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36806 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgAJTxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:53:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id n59so1431478pjb.1;
        Fri, 10 Jan 2020 11:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sEJksmrBgGZNoHCNFeup523vZhgBdAA84EI1IPgOXYQ=;
        b=PNLRj4QRNGJt6Azwx9IChtxWFE3n9+kZ/I1l5kqZhYMqp3KisvwyXaj2IEQnJE7YqP
         ehEd4GrAnbLtxMv8AHOGev8METE9X8gkAZ2jrhJ+9TC6OJLGlg9xfv1DoBL0aBd30bYs
         3VTzfxrF8gSKCElEV190BumL5xUVlW3cdqVtIyQopnZ6VQiASPThOWUfbIWB5MTHzks0
         5YO6VZ1oTDHXanMNHXMUKB1Adi+zvdw4TSakAS+fo5kv4ApbzGjsJ2HNZyQQWe3n2MGo
         V9k3sCHQa0YZDFJh7VXsRpyNVAeebKxRE3PMTXv4cHYnFwq5ucbfW95yIrQrcGgh91cx
         Nygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sEJksmrBgGZNoHCNFeup523vZhgBdAA84EI1IPgOXYQ=;
        b=ppMeEZFh4AFQiFY93w7g/NeVbUn+1UIg1jhJrN8uVwUZ/DCnuVZYXC4gOiA05/9ecP
         kAQvm7L+/XK8QUccBQY7EFvNmJlRW1nrJ6aJEiCygi0dhomjSbw8SdqDUzSos8n8TmiM
         U+P5ERjMRebT9dpBmt6RVLu4uu7SEZ9NiGn+IYDa6iYjJ69Wio1AGHWSSIiIx1thpLIg
         h538IgMLPkmMqoT9N0JDZ9iNvUdTzCzRyY02qUSlmZMFj9nfuXg10r2NZpc7AHBqfIM5
         0T2idLKbxAYx41upw0IvBTc0Iov/MEXcEwzXiAEERJMVfW/Z39bqbUQrAXUqxDnIBCE5
         TdIg==
X-Gm-Message-State: APjAAAVnioHTtTRq0z2/t79Ki3QmAULTa2HBBOC2+V8CbJEiTT/f1maW
        XDxT/1ODgwIH1GlkVK9EN3IzayKLoQM=
X-Google-Smtp-Source: APXvYqwZyySLPHfKw2xXpBvt2yVqsojY5kY1UGjHRmsoyjBmx1NIcMFjxT0jVIK/ILGGlzu9EO7oFA==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr214072plj.197.1578686025830;
        Fri, 10 Jan 2020 11:53:45 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id m128sm3897878pfm.183.2020.01.10.11.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:53:45 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [Patch net] netfilter: fix a use-after-free in mtype_destroy()
Date:   Fri, 10 Jan 2020 11:53:08 -0800
Message-Id: <20200110195308.30651-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

map->members is freed by ip_set_free() right before using it in
mtype_ext_cleanup() again. So we just have to move it down.

Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
Fixes: 40cd63bf33b2 ("netfilter: ipset: Support extensions which need a per data destroy function")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 1abd6f0dc227..077a2cb65fcb 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -60,9 +60,9 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
 
-	ip_set_free(map->members);
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
+	ip_set_free(map->members);
 	ip_set_free(map);
 
 	set->data = NULL;
-- 
2.21.1

