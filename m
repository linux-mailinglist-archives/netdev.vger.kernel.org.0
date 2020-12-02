Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32AF2CCA5F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgLBXOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387622AbgLBXOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:14:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7DDC0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 15:13:35 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c137so363952ybf.21
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 15:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ZFxjFlPOGRZwOnY0RO0nkySg3CsVohaI0ePFi9oHcrY=;
        b=szsqI7ZLY+xJ2u/4byOrY+YuFCqH/PIjA8qOolHBjTgjEKAkupUiyZ8j4v2OZ57gUj
         R7LJplZbv2B7JHFxpiwDx0v0VdhW4rH/iSq39aMrDaRDHpXy0DTPj44jJdKVANd6yukd
         /OGtLa41bdcBWFyg/xPnuo1j7w4Vyyr73QHcArGvSsAZ8v8nzVkdxYJbpx5lznzT8vN+
         TmgxT2gDwPjN+jGudK8e9TWM3jDVFegBoRjMLGP+4J2HlGRw7WVxjvakdRYBCI9Cd+8A
         EBjq8FSvk8ydGmd4qovuTb/PnKLaNHLQk5sJyeR9lqNpewApwUSq5CTS23WwLkUIz0y+
         UpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ZFxjFlPOGRZwOnY0RO0nkySg3CsVohaI0ePFi9oHcrY=;
        b=sYyKBwQyzosnSmf9nUfVZIkIR3tVNg1wdCw0HzRHUHZqdoqdeescaw++ahzeKhAEaB
         k2PU105CAfmFyDsMCleg4/xMLBkzK5QXCUxA2RLOeIHDkb6eJYKDQWAcTTpqC7R7F70C
         aszQRvGg9WQpE9i7z7q2bS3/nDHLFL2HpfT2dVfeIl+EaZDwM16ASExFd+Ot2espS3r5
         6WZoV1TeXwJUhimrurPDnZQW6o/MdUhKiOx79xiwnrF8R5FlAQqT9VfrLsYFM9FKBkyo
         yh/NvVBPvKgXRY6Rg4M9csG6Ny/l8frC+1VYzUJKbBQg7IWENcSnekkS4pRHwnqTZrrz
         /umw==
X-Gm-Message-State: AOAM531wCe38ai35JDImyQoOP6ATRymW3sKvX+6Be9/S69J19d/vfui8
        nYtzlVWFltjmu5mzQya6xyacxP7gGnmM+QS7n+4dDX90uSjwYpnGulcNttITdv9atbV6U/A3GR1
        Edl23FMGk5DK2ww70Gvix3RaMc9yXKhKmFOWafDcYNusExhGElH6xFA==
X-Google-Smtp-Source: ABdhPJwexRD95gDCy4awzIG4X7TlQfJTt9TcopPQLJvcCZF3h9HVFS3ezLar8PpCNCfEGO+xsJNaM44=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:c503:: with SMTP id v3mr655637ybe.15.1606950814299;
 Wed, 02 Dec 2020 15:13:34 -0800 (PST)
Date:   Wed,  2 Dec 2020 15:13:32 -0800
Message-Id: <20201202231332.3923644-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH bpf-next] libbpf: cap retries in sys_bpf_prog_load
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've seen a situation, where a process that's under pprof constantly
generates SIGPROF which prevents program loading indefinitely.
The right thing to do probably is to disable signals in the upper
layers while loading, but it still would be nice to get some error from
libbpf instead of an endless loop.

Let's add some small retry limit to the program loading:
try loading the program 5 (arbitrary) times and give up.

v2:
* 10 -> 5 retires (Andrii Nakryiko)

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index d27e34133973..4025266d0fb0 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -67,11 +67,12 @@ static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
 
 static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
 {
+	int retries = 5;
 	int fd;
 
 	do {
 		fd = sys_bpf(BPF_PROG_LOAD, attr, size);
-	} while (fd < 0 && errno == EAGAIN);
+	} while (fd < 0 && errno == EAGAIN && retries-- > 0);
 
 	return fd;
 }
-- 
2.29.2.576.ga3fc446d84-goog

