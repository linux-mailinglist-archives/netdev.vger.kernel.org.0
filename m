Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D62521300E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGBX06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgGBX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:26:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51422C08C5DD
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:26:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c1so5898677pja.5
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Be8/RXHNUg3guKcAU0wzFOahH212pJR/5S0VSq/hiLk=;
        b=AZNXg5cAGqKc/O1ef4Kc/yy3qUbP8UuKWLzdKUZA44cFM8OkYapLq3J29luk4nI4ms
         xZlrbLj6B/RkKmXJeAwDSYoGxQU0jiD1te9ioq8uMs2I3waXWUfWcElsMjAEAshyT9y5
         dvNbYPegQb9XnQnvHreZbZu6+7+uuOFy6Gv8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Be8/RXHNUg3guKcAU0wzFOahH212pJR/5S0VSq/hiLk=;
        b=R2NjNjCiUnkeipUlT5bDdYggV0/kXsvsF33/A3MIlU/AbX39fH92nHl7obvutGmd3s
         /QuRETeXIkKXBNk0XiLTtcqUAXbl2ZsUv7om11e6zV4KTrHULBWHG2ZRpr4DsliWAFZO
         HrZAU86UEWTi4Rz9LJweHlOD9ElbSehWMLfHzRQnWln7PEgEzA/AfJt+5NDyQcT9dXD9
         7WUEWvfGMxMdZetURMO4S6Thg3B/a+vt7D/2zXD+QCz8TQI77Obn7QJVLE2NwgcYiLCl
         kKNnoE9ONzfgSRRNP+k6hndnapne4yWtDzK0v8PTKIB3JuDToov2NQSfZvpbjmQNwAug
         Ls2A==
X-Gm-Message-State: AOAM530Qc6aPbwp3mFehyNZcsiysJtrkFFpZ1cHF5vWAvrCsLzW07McT
        JeDm8HCV0m7ZmndvZu7FGvKDOA==
X-Google-Smtp-Source: ABdhPJxTnpQERPtJv7OGqHQCc+gfp34thsR2FhSVKFIpGMpGOmREcUT37nlgZdRzgpRwqbSxEkGurg==
X-Received: by 2002:a17:902:8a82:: with SMTP id p2mr27275418plo.316.1593732403984;
        Thu, 02 Jul 2020 16:26:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 2sm9791094pfa.110.2020.07.02.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] module: Do not expose section addresses to non-CAP_SYSLOG
Date:   Thu,  2 Jul 2020 16:26:36 -0700
Message-Id: <20200702232638.2946421-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702232638.2946421-1-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The printing of section addresses in /sys/module/*/sections/* was not
using the correct credentials to evaluate visibility.

Before:

 # cat /sys/module/*/sections/.*text
 0xffffffffc0458000
 ...
 # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
 0xffffffffc0458000
 ...

After:

 # cat /sys/module/*/sections/*.text
 0xffffffffc0458000
 ...
 # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
 0x0000000000000000
 ...

Additionally replaces the existing (safe) /proc/modules check with
file->f_cred for consistency.

Cc: stable@vger.kernel.org
Reported-by: Dominik Czarnota <dominik.czarnota@trailofbits.com>
Fixes: be71eda5383f ("module: Fix display of wrong module .text address")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/module.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9e2954519259..e6c7571092cb 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1530,8 +1530,8 @@ static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
 	if (pos != 0)
 		return -EINVAL;
 
-	return sprintf(buf, "0x%px\n", kptr_restrict < 2 ?
-		       (void *)sattr->address : NULL);
+	return sprintf(buf, "0x%px\n",
+		       kallsyms_show_value(file->f_cred) ? (void *)sattr->address : NULL);
 }
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
@@ -4380,7 +4380,7 @@ static int modules_open(struct inode *inode, struct file *file)
 
 	if (!err) {
 		struct seq_file *m = file->private_data;
-		m->private = kallsyms_show_value(current_cred()) ? NULL : (void *)8ul;
+		m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
 	}
 
 	return err;
-- 
2.25.1

