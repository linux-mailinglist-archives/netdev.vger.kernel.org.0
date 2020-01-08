Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A6C134EFA
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgAHVfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:35:20 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45465 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:35:19 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so3893806iln.12;
        Wed, 08 Jan 2020 13:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pGjnNwKmSOomeeUgLDOsf11LLdbS6lxP9M2BwdBU5ao=;
        b=bes7gIYsXruKZ2rdAWH0qwjhRAyDrcGA6mL1lHQ8MfALaHY4neWpXMi6nrbsBzgyiH
         O6imQ/iaIUgXpBB1/bfoDWqahFmXwxa8LQWTwexVG4AmM3+PDpkRdoen3pWZQBzkYNXo
         AeXelXr6amubUMTvG8GtIj41rh2tYh/cuyWhxiCvK8WmG9rvfrL/dsbflibc1tgGEpzc
         wMMDJNXXuAnt4gDE+AHgABPS2ZVoKhQoB9I5Z4w9cJLBVhKCRTF/5zir2kslOi4SOPvy
         Q+1HOA0Nbmjdhue9yeEXbDyZnBUutfZyza3fx0ZG5bnFUsII+3YfqohpAX7wS+b6fZR7
         gsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pGjnNwKmSOomeeUgLDOsf11LLdbS6lxP9M2BwdBU5ao=;
        b=hS9N1lxD7oiwg/QX+Yp01E8gXiCc0K0Jz6fiG9HThc7AAJ8EVQM5quzZDVPGdUIwxn
         +zNvy3qcQxEO2/8tn6AWhSrLmgGGmlNqgB4EWs22hq0qh8TEjcE6+3FjEUQpF+5Y+ivb
         6Uzw+VtCksAZ++QCfJl/cyRr5BKHiRhwACfCiWsuyXtqT/PasSOBIoGp878NpZ94TExb
         WKONMqU422VKDDgbB3ZnWfa+Qlr4xhtSiVdiGpX2JnLzZ8Ma4KVRDPaupsB/H+p0mjIL
         NM6VuEjsPhQbExHIpYfk4obD+SM8+VBegT0JFK2w1DJKN8lkoKterQKSFhOIfiZC5bRC
         dcPQ==
X-Gm-Message-State: APjAAAUfASq+l9qRLNl7MZ8c60vYI7Xw0EOvrgSyenzrdZki2+uRYIK5
        +Ru2I7ULb65G7PlKmuwFJmw=
X-Google-Smtp-Source: APXvYqy5RdtK3f/7PixAgAsO2qdBz451nUje8NDx9ycz7aWmMXM+cKbotfQUAJg/r7DWNOABOjq1xg==
X-Received: by 2002:a92:cb11:: with SMTP id s17mr6059966ilo.114.1578519319116;
        Wed, 08 Jan 2020 13:35:19 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l83sm1330187ild.34.2020.01.08.13.35.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 13:35:18 -0800 (PST)
Subject: [bpf PATCH 2/2] bpf: xdp,
 remove no longer required rcu_read_{un}lock()
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 13:35:06 -0800
Message-ID: <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
In-Reply-To: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we depend on rcu_call() and synchronize_rcu() to also wait
for preempt_disabled region to complete the rcu read critical section
in __dev_map_flush() is no longer relevant.

These originally ensured the map reference was safe while a map was
also being free'd. But flush by new rules can only be called from
preempt-disabled NAPI context. The synchronize_rcu from the map free
path and the rcu_call from the delete path will ensure the reference
here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
pair to avoid any confusion around how this is being protected.

If the rcu_read_lock was required it would mean errors in the above
logic and the original patch would also be wrong.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/devmap.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f0bf525..0129d4a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -378,10 +378,8 @@ void __dev_map_flush(void)
 	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq, *tmp;
 
-	rcu_read_lock();
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
 		bq_xmit_all(bq, XDP_XMIT_FLUSH);
-	rcu_read_unlock();
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or

