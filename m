Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335686A7167
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCAQkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCAQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:40:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8DD42BC7
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 08:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677688786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NSJcgD+Y6L1I9dbPpK5kubARotLSu9co9Llr60nk3dc=;
        b=FDSQtRuw9hhzOY3gZczy/ErgmZDOvPX2ObasC/LTt66xdGhG05tC8YZDaovS8w/Z6NtdXo
        Fcn4Rm3lO4v+y+7gRdq/s5wOxOo61MlqtuBG0QfdVoPYpsHwtIUQIpzQzH6SvgWoVKYG6Y
        jKvGdrvUVB0aTkvjXAg70+fOwtgIA/M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-1WATKNBrML-xTlQu89nePQ-1; Wed, 01 Mar 2023 11:39:43 -0500
X-MC-Unique: 1WATKNBrML-xTlQu89nePQ-1
Received: by mail-pj1-f70.google.com with SMTP id o17-20020a17090ab89100b0023752c22f38so4740254pjr.4
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 08:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677688782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NSJcgD+Y6L1I9dbPpK5kubARotLSu9co9Llr60nk3dc=;
        b=LYo+TmoiLr/6lqNuA2Qt8hQqCPNgDQ5jhUml71nRf/iwJFwvUBVi69P8Evb8/KwT0X
         Dt/iC+L1LLCyGSbT8tdkWgaqwTsTmtsBmPm/HD4aLBiDUOTU4RR+JmsqsxYRgXFcBp2X
         fwkWzjWUJlzCLfh3m4t8P8wp6s7FNiZLw+KTabe9upLFQB4eYxwPgFaC2BbwzK3f12oO
         4DKEUQ/16H07UQBCeIjRfAwsr8SaRJZHzOwng2CXT03XZXiep0v7vdxxPefR4k3SxTU5
         UPmlLu1qGCdMFyYCXakb2ueiZ7R8cFISSWE0cf6EqyYTKgdhg9JPEeFovoy2eBRKMd01
         kJAg==
X-Gm-Message-State: AO0yUKXFqIIXMV/+KUPWcLGtxKh8OB55TejcZDrRQVQwoP+6svh/Ikfq
        zUDetFkdM0nNOSnMTHTG/AWdnUK6BuQlQinz9LLcBNcMqUi0NQG90rEF1gxk98avquuAFf9gluQ
        HYySC4cNBFsewG3ol
X-Received: by 2002:a17:902:f54e:b0:19a:98c9:8cea with SMTP id h14-20020a170902f54e00b0019a98c98ceamr8243569plf.39.1677688782459;
        Wed, 01 Mar 2023 08:39:42 -0800 (PST)
X-Google-Smtp-Source: AK7set+qO4JpSY8sVTIOnTnJXuzwrWx71YibPF0ctGLZforUa7b2hGsadOAQOW8IGnCxDARvr/Jtpg==
X-Received: by 2002:a17:902:f54e:b0:19a:98c9:8cea with SMTP id h14-20020a170902f54e00b0019a98c98ceamr8243541plf.39.1677688782148;
        Wed, 01 Mar 2023 08:39:42 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id x25-20020a63b219000000b00502ecc282e2sm7603216pge.5.2023.03.01.08.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 08:39:41 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>,
        "sjur . brandeland @ stericsson . com" 
        <sjur.brandeland@stericsson.com>,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Subject: [PATCH net v2] net: caif: Fix use-after-free in cfusbl_device_notify()
Date:   Thu,  2 Mar 2023 01:39:13 +0900
Message-Id: <20230301163913.391304-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported use-after-free in cfusbl_device_notify() [1].  This
causes a stack trace like below:

BUG: KASAN: use-after-free in cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
Read of size 8 at addr ffff88807ac4e6f0 by task kworker/u4:6/1214

CPU: 0 PID: 1214 Comm: kworker/u4:6 Not tainted 5.19.0-rc3-syzkaller-00146-g92f20ff72066 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10227 [inline]
 netdev_run_todo+0xbc0/0x10f0 net/core/dev.c:10341
 default_device_exit_batch+0x44e/0x590 net/core/dev.c:11334
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

When unregistering a net device, unregister_netdevice_many_notify()
sets the device's reg_state to NETREG_UNREGISTERING, calls notifiers
with NETDEV_UNREGISTER, and adds the device to the todo list.

Later on, devices in the todo list are processed by netdev_run_todo().
netdev_run_todo() waits devices' reference count become 1 while
rebdoadcasting NETDEV_UNREGISTER notification.

When cfusbl_device_notify() is called with NETDEV_UNREGISTER multiple
times, the parent device might be freed.  This could cause UAF.
Processing NETDEV_UNREGISTER multiple times also causes inbalance of
reference count for the module.

This patch fixes the issue by accepting only first NETDEV_UNREGISTER
notification.

Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")
CC: sjur.brandeland@stericsson.com <sjur.brandeland@stericsson.com>
Link: https://syzkaller.appspot.com/bug?id=c3bfd8e2450adab3bffe4d80821fbbced600407f [1]
Reported-by: syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/caif/caif_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index ebc202ffdd8d..bf61ea4b8132 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -134,6 +134,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct usb_device *usbdev;
 	int res;
 
+	if (what == NETDEV_UNREGISTER && dev->reg_state >= NETREG_UNREGISTERED)
+		return 0;
+
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
 	      strcmp(dev->dev.parent->driver->name, "cdc_ncm") == 0))
-- 
2.39.0

