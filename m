Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE1287914
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbgJHP5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731892AbgJHP4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BC6C061755;
        Thu,  8 Oct 2020 08:56:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x16so4673628pgj.3;
        Thu, 08 Oct 2020 08:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aGZnGeKXb/4W754G+q1uGMo7EKzQsbVNPjZnlEWbXqo=;
        b=DB1EcoypNY9HQ9vP/ZQDs+JcVAFPQEoHii3uTKcw8IlqvtDGiqhefgm9CQbAvheovD
         C+kKKqj/Our4LtqWU/UoYdNYLBnBDcgQ2UqPxGkTUTRERYgs2C8FSWIkvTrMA7ROsu7f
         UsQY/trOlsAyg1QGifjbr387xACRwUsvDymzII8YqXoBU+JHti2zoeZr4Uj0BevfDEsj
         3qL8OVzsBfS7+GPz6SlvSEshaTVWmHpdDqS0zsD/c7JaYE54B4GQx9U+yJVgNmuWNwSN
         ZwRpv7z/yL8+xBD6eo0J63QcSF09aT8EXmSS8YsQYEDnyQ5ab8rJVnagkywdjhcWmN8z
         88/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aGZnGeKXb/4W754G+q1uGMo7EKzQsbVNPjZnlEWbXqo=;
        b=jgJCAVqPCcOMU7ta1X1csQc+Bd4gtGMdTuCfCJCcgrSDyjctc+u8o4E1gf41oEOjh8
         UsuvE7/dckVLJ1mBhIFfzHNq4KvHw2/V22PFQP52HmhnysChOkY/9MsAv8zCkgQoEEtC
         crPS3ctnciwF/BjbMFiF75cuuEwYyUifn9xUqZ+q/oeOxHNts3FrJ1HSSwxgy3Pz5GVS
         uk8AdFbGrc7uaUfQJxTFE0ZbmRtH5NaRFXO7D+ajwZsDwPhNzGnOcJSbq45fZEfc8vg0
         TmYN2hpVvhWyWQouuqOcEuvHtLd7ow7JPxB+fN0keR9Xc22suxrE/KMxTl/huhTiwQ1F
         l+RQ==
X-Gm-Message-State: AOAM532ebZnch5MGMh6HmziKtGdeM5uOEGk61ZIOFsDnIPdwD5xq9zvQ
        x45rjpeEs5kH3VXRbVDyomg=
X-Google-Smtp-Source: ABdhPJwEOpTER7zbhABAZgDD4dvOTJBB90S/ppnvdwrlVJH6yEFLM9shYc/xABwQb/+0kSu35vsqxg==
X-Received: by 2002:a63:3205:: with SMTP id y5mr4782541pgy.122.1602172611596;
        Thu, 08 Oct 2020 08:56:51 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:50 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 087/117] wil6210: set fops_link_stats_global.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:39 +0000
Message-Id: <20201008155209.18025-87-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 0c936b3c9633 ("wil6210: add support for link statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a2dce1ed9d0d..afbe30989ee4 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2065,6 +2065,7 @@ static const struct file_operations fops_link_stats_global = {
 	.read		= seq_read,
 	.write		= wil_link_stats_global_write,
 	.llseek		= seq_lseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t wil_read_file_led_cfg(struct file *file, char __user *user_buf,
-- 
2.17.1

