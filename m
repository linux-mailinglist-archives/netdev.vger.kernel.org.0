Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDF2D7B25
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388328AbgLKQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388382AbgLKQkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:40:41 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE30C061793;
        Fri, 11 Dec 2020 08:40:00 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 3so9171581wmg.4;
        Fri, 11 Dec 2020 08:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=11vbsMQ7mLuZm/TRWwxVBUaF2+2DPCNUSTFQEQ07Mfw=;
        b=RgzvpQ6QzXLPW6snhe8VmyU2qa7KDQiUzaWB/NQ/wXl8/uA75QVUICRZVglL3aYCQX
         ++4R/RA5n6n+F82k2IJ8K1SNAewF/deS/raR4RWYHufgPWqWJGSCJjQA/MRwPzE7dT1J
         fVVBOTZE7J8PNyQ66+QQOjhkOtXcB4BaeJunIE/vPHmzMXOtGQfNiJtDHPuedvOwUtyt
         6plXC98eR/BqaRVFSa7atYhKsm6nJlMT4NzJT8Dy2Sk+0TqFALAr9d3kc1VMHTCcxkDQ
         oK/og+DxxAqCJdMEV9ZwcO4VCVhcLEKKsL1hJHFvmD2lwSeoId9uXLhUVPIjLPI4t1ZQ
         Yyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=11vbsMQ7mLuZm/TRWwxVBUaF2+2DPCNUSTFQEQ07Mfw=;
        b=EK9xjn4D8gMMglvW++x6ENB0bQs36i8Bj8IMwkbcoiFeQaPH2c22UbyV+99N90nAJR
         tvhw8d4kin+t77HX/oYP8GDy7ePe12XmZ+d0gHbO0v6rNUuEqXaNYkEo8/aN7jW3T29K
         IKd73aXKHFWax0FUlyH2vVspTwCKTL7hOrXQqkZ5lZOsRYiNqJHRrjQedW3iVZuD4Oq8
         tspSCtGiz3/wj7n3Xt4fY/ihskmKK0RT4ZrT1JmulVS67muk08wc+iDO0jeHPYJIk6J4
         QfEWTc7oj7V5da/RS93JTUz0o3jbTAvgtbW1VAOUJ0BKB5h/MFFJnjlti5P0wod8GohI
         nfgA==
X-Gm-Message-State: AOAM533Dt+4Eaw1HYJb4FOqkZgoT29cXbUVDdYdau9fee3/vTBPlHKXW
        x6Xjoqaeg9rvZLSLDtjF6/4=
X-Google-Smtp-Source: ABdhPJwQ8K+Tyzvi6gCN3r/dzr8esKC9hmz/SpNVFINOctiCuawyesI++ulYLGhRZHDmLDgCAsTOIg==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr14835318wml.155.1607704799292;
        Fri, 11 Dec 2020 08:39:59 -0800 (PST)
Received: from localhost.localdomain ([77.137.145.246])
        by smtp.gmail.com with ESMTPSA id r20sm16061016wrg.66.2020.12.11.08.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:39:58 -0800 (PST)
From:   Yonatan Linik <yonatanlinik@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Yonatan Linik <yonatanlinik@gmail.com>
Subject: [PATCH 1/1] net: Fix use of proc_fs
Date:   Fri, 11 Dec 2020 18:37:49 +0200
Message-Id: <20201211163749.31956-2-yonatanlinik@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211163749.31956-1-yonatanlinik@gmail.com>
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_fs was used, in af_packet, without a surrounding #ifdef,
although there is no hard dependency on proc_fs.
That caused the initialization of the af_packet module to fail
when CONFIG_PROC_FS=n.

Specifically, proc_create_net() was used in af_packet.c,
and when it fails, packet_net_init() returns -ENOMEM.
It will always fail when the kernel is compiled without proc_fs,
because, proc_create_net() for example always returns NULL.

The calling order that starts in af_packet.c is as follows:
packet_init()
register_pernet_subsys()
register_pernet_operations()
__register_pernet_operations()
ops_init()
ops->init() (packet_net_ops.init=packet_net_init())
proc_create_net()

It worked in the past because register_pernet_subsys()'s return value
wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
packet_init.").
It always returned an error, but was not checked before, so everything
was working even when CONFIG_PROC_FS=n.

The fix here is simply to add the necessary #ifdef.

Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>
---
 net/packet/af_packet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2b33e977a905..031f2b593720 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4612,9 +4612,11 @@ static int __net_init packet_net_init(struct net *net)
 	mutex_init(&net->packet.sklist_lock);
 	INIT_HLIST_HEAD(&net->packet.sklist);
 
+#ifdef CONFIG_PROC_FS
 	if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
 			sizeof(struct seq_net_private)))
 		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
 
 	return 0;
 }
-- 
2.25.1

