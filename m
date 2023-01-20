Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0566675FFC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjATWMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjATWMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:12:37 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD6C211E
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:12:35 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id v6so3421275ilq.3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wbodpTKPKmmsf6sP0FY882Wjf4zzytHSiP84SDKBVQY=;
        b=cBx1flC4qcgu9rrDuKrrO1mDCaZBSPWObcfiVypcdCKvHYtSrTfEce40+s+2J4zyI+
         /gVtMyOF+lDW0t4v19/baQh3Pyc5u+wRFnQyhKRSMaQy3zxBme7NG1c5DDjp/LRecDSI
         rpavxneoCsLF96wzrzdzqfisrzGoJBzZXI09M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbodpTKPKmmsf6sP0FY882Wjf4zzytHSiP84SDKBVQY=;
        b=PNvN5MjyHxKikOKoQIl1TXnHmHn4iCwx7T36gQ3EhO2nkz1jeDX4OntrU+1rdwNCzb
         52UVurGX1hirFEmEwlSvuY+OXvzYnf/7qBb5xiCzs6BwJ927akKFojaK7RbwwzCLN08a
         KlTNCCWLCcuCwzgBGmD2G+Ej6lBNWVeF0HZPsSkZg9P15R6DzzPFmIuoI/dUweUNYDA6
         KPfEvHjdNYGlMzEYliqUAqlqppkEFVIbrdRkk8ARW7ehiknEpgc3YeCGXZA6D1UJgolb
         RORIFW3x9nrGckr4AVbpvmoHnTOS6Df/Ks/fDIepyQxneW0zv+OmYZ3ogKaBgNAkmSrU
         eWUA==
X-Gm-Message-State: AFqh2koXS72OoU80DHOcLUVlCDZ6kGK43VDmnS7XNxmKIx9h41N/i9IA
        GI241uJA4q+VvBZspvfgyiWPNA==
X-Google-Smtp-Source: AMrXdXsG6qJ68Trnd/19KnZDx2kv5FJ9ieIJaUYW/S7CKgPcoe0u5j0uZYANES+6SbM91sDCNgdrPw==
X-Received: by 2002:a05:6e02:6cc:b0:30c:4846:57c3 with SMTP id p12-20020a056e0206cc00b0030c484657c3mr12392861ils.4.1674252754641;
        Fri, 20 Jan 2023 14:12:34 -0800 (PST)
Received: from localhost ([136.37.131.79])
        by smtp.gmail.com with ESMTPSA id b7-20020a920b07000000b0030f04dcbc2fsm4679183ilf.66.2023.01.20.14.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 14:12:34 -0800 (PST)
From:   "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
X-Google-Original-From: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Date:   Fri, 20 Jan 2023 16:12:21 -0600
Subject: [PATCH 1/2] livepatch: add an interface for safely switching kthreads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230120-vhost-klp-switching-v1-1-7c2b65519c43@kernel.org>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
In-Reply-To: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
To:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.10.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2403; i=sforshee@kernel.org;
 h=from:subject:message-id; bh=r9mU45ndBE6+c+nVzo6X6SmMiX3LFRgk6Wk7Kz1IlfY=;
 b=owEBbQGS/pANAwAKAVMDma7l9DHJAcsmYgBjyxHM7TI1pPLXBaX/blEl/AF4BuJfI3qcZu1Ba0Pi
 7RCvBguJATMEAAEKAB0WIQSQnt+rKAvnETy4Hc9TA5mu5fQxyQUCY8sRzAAKCRBTA5mu5fQxyQajCA
 CQHOboQjqLYEklPYMzSh3LIcU+lmYlGq/PU5Tvw2uXXdt5OuZ4wKr1bfrXZpqEQQFOQ5GyQIs8TWme
 68r4FYf+XBDN8IA7Am+RvNbij9LDM0ErUGMkEMlMUK2XSI68SKL5/NbPtA12cLqwyqbrMtSU0V1lOS
 eSDjz6e/IF+cCI3MRJJbXNn7lxroUBmuaxIeYS1ctnsDnBTdo+Q9+7o2kgP03u4T/S2KgzhrTilX6j
 /2IzHtl3Yan7ZRmpHjyJHOjBbOK75ZYYBEdb8isQRJrPJDUfZru9Cy8XEYoGElACzFBHIrUhHU8zMH
 BcKdbg7Z6g/u8WS7oj3yqkyZRxDEBW
X-Developer-Key: i=sforshee@kernel.org; a=openpgp;
 fpr=2ABCA7498D83E1D32D51D3B5AB4800A62DB9F73A
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only existing solution for transitioning a busy kernel thread is to
call klp_update_patch_state() from a safe location. However, this does
not account for the fact that even the main function of the kthread
could potentially be patched, leaving the patch switched but still
running the old version of a patched function.

To address this, add klp_switch_current() for use by kthreads to safely
transition themselves. This is just a wrapper around
klp_try_switch_task(), which can already transition the current task
with stack checking.

Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
---
 include/linux/livepatch.h     |  2 ++
 kernel/livepatch/transition.c | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 293e29960c6e..00b5981684a4 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -199,6 +199,7 @@ void klp_module_going(struct module *mod);
 
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
+void klp_switch_current(void);
 
 static inline bool klp_patch_pending(struct task_struct *task)
 {
@@ -240,6 +241,7 @@ static inline int klp_module_coming(struct module *mod) { return 0; }
 static inline void klp_module_going(struct module *mod) {}
 static inline bool klp_patch_pending(struct task_struct *task) { return false; }
 static inline void klp_update_patch_state(struct task_struct *task) {}
+static inline void klp_switch_current(void) {}
 static inline void klp_copy_process(struct task_struct *child) {}
 
 static inline
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..ff328b912916 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -455,6 +455,17 @@ void klp_try_complete_transition(void)
 		klp_free_replaced_patches_async(patch);
 }
 
+/*
+ * Safely try to switch the current task to the target patch state. This can
+ * be used by kthreads to transition if no to-be-patched or to-be-unpatched
+ * functions are on the call stack.
+ */
+void klp_switch_current(void)
+{
+	klp_try_switch_task(current);
+}
+EXPORT_SYMBOL_GPL(klp_switch_current);
+
 /*
  * Start the transition to the specified target patch state so tasks can begin
  * switching to it.

-- 
b4 0.10.1
