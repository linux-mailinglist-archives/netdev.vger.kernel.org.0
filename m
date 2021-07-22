Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832AB3D2FC8
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhGVVig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:38:36 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:39742 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhGVVif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:38:35 -0400
Received: by mail-pl1-f171.google.com with SMTP id e5so996870pla.6;
        Thu, 22 Jul 2021 15:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWYwLLr1F+wEohZcNxTrxT9x/1X4krqlfhkjTKwn5LU=;
        b=Zw5P5x4B2pcmiuvW4R7oJVCjTwx72gcEgkCCMUOy5gKQ80kuskDFmKGvfeUGP/6Ufx
         P+odj9q3IHgbF16n45gtEGoLT7M6u0EibME0h7ty7yyUL533IY3mkojcsNjNyvM/suKQ
         VIr3AxPM0YMMMNLDZR4R76d30xvukAiArdGkS3p1HO5ZcOMYQ4MMvHtAUx2oLhfx6P4k
         b2Nl/XnTW/jlgmryoZ1NctDWkRNTuAXy/ehpZzc3BSX04PxFzIJ0pfAxyR8b/oaUuU6l
         /wr8GC5wvRQqcH06ZdoDCIIPvIvSiG3hH61mKzVpbwNudIlmerO0eVLrLOFN4m6FmeUY
         xkoQ==
X-Gm-Message-State: AOAM530Sv1GhZQIjLRz8FKGpKUZkRUA856e6HXyucw/tLsX9gRK8p47t
        F3FiVPZEKXiNdP2oC2ORq3A=
X-Google-Smtp-Source: ABdhPJyUsy0ro4YtJRuFm4vTMWqvS3mmCKFzmHMvFVjaECINrpaZu6M8QdvGu3PqOECaJ4mkPhFXWg==
X-Received: by 2002:a63:449:: with SMTP id 70mr2067429pge.174.1626992349448;
        Thu, 22 Jul 2021 15:19:09 -0700 (PDT)
Received: from localhost ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id q31sm8997884pjh.13.2021.07.22.15.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 15:19:08 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/module: add documentation for try_module_get()
Date:   Thu, 22 Jul 2021 15:19:05 -0700
Message-Id: <20210722221905.1718213-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is quite a bit of tribal knowledge around proper use of
try_module_get() and that it must be used only in a context which
can ensure the module won't be gone during the operation. Document
this little bit of tribal knowledge.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 kernel/module.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index ed13917ea5f3..0d609647a54d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1066,6 +1066,28 @@ void __module_get(struct module *module)
 }
 EXPORT_SYMBOL(__module_get);
 
+/**
+ * try_module_get - yields to module removal and bumps reference count otherwise
+ * @module: the module we should check for
+ *
+ * This can be used to check if userspace has requested to remove a module,
+ * and if so let the caller give up. Otherwise it takes a reference count to
+ * ensure a request from userspace to remove the module cannot happen.
+ *
+ * Care must be taken to ensure the module cannot be removed during
+ * try_module_get(). This can be done by having another entity other than the
+ * module itself increment the module reference count, or through some other
+ * means which gaurantees the module could not be removed during an operation.
+ * An example of this later case is using this call in a sysfs file which the
+ * module created. The sysfs store / read file operation is ensured to exist
+ * and still be present by kernfs's active reference. If a sysfs file operation
+ * is being run, the module which created it must still exist as the module is
+ * in charge of removal of the sysfs file.
+ *
+ * The real value to try_module_get() is the module_is_live() check which
+ * ensures this the caller of try_module_get() can yields to userspace module
+ * removal requests and fail whatever it was about to process.
+ */
 bool try_module_get(struct module *module)
 {
 	bool ret = true;
-- 
2.30.2

