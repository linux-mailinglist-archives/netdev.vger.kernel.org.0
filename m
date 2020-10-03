Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC683281FC8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 02:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJCAZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 20:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgJCAZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 20:25:47 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B084C0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 17:25:47 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w10so2293414qtt.23
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 17:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=yVletPTNljF8SywZqTeMTFvBb76pdRha2hXSioNcxfM=;
        b=qLGxXkoe3gdLeQ+1NsG4QoL8TjStvBD43kSzy4S/ne3hwCBK7GKN3nsbQ3cFRbyqt2
         wuzI1Zw1u1VN3NKAt6vVdR1F5/rmAaI/Me/cXLgTexTfSnMkD9tj4avutf9Q8Wc+lxoT
         umIiVm1A7t8GN1HvG3UEIvJDeUgc/5txIln35Fjzn3YJ/foGTFGeplpmFLmc+wjWhHtm
         utECWfBmGUqPeAsJOwbGJZ2OUVl/jaJkeGqRacHnbFV1hsba2J6JCBWQmI7v3p3WjRO1
         WDWqol2j/EEElHczOkSo9oaBgCaZ9zIchj8vLJ1OT6s9PWLaJleT5+1lLkjVBSpI3x7O
         S7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=yVletPTNljF8SywZqTeMTFvBb76pdRha2hXSioNcxfM=;
        b=JNr088LpAHqMXGDAcHa2gjvcLqx5FyptDTIQhfnbqrEYTBSD4P6PWGmGRra5mz3BF8
         +V0Mv0bOlJU54KfQvsPjUiXp5coIPpm4P4t04VVFKz5skvHtUEW5vfwm+AaMLa43R2rQ
         vlH6QzRGwX2HqmCdKWpOTsj49vfioM5OHzidsb3hVnadi8YSU2VMGJiF/wHHIPMw0vpY
         WLBJ18KJmyF0zLcrphf2LHeBAnHVglmPHr78jfpfNo4+f++Lz0ZlyqHdg8ON/gGS25Fe
         Cr37vLkCvmD/PWKQR3HA/JEQaJXWFqEU9iWxAWVQl3EgbGisMdjxqEvHQZHY9KFU8KKS
         kcBQ==
X-Gm-Message-State: AOAM533dsMspWq3w0PQPHqZsw7Ekd17DnffUaMFNfZNrPi2+LtfNY3Fy
        /twsPUpVc1Wj0Yu0RnFzdHt7KijWeCSTiQRGcHG2Q89M6LHtXcblodqjvhB/7i+jpbapAZ0UMdt
        LW4TErG5RdMFmPQDwxE+4fgsa0u9I3ceGmmUEaif44v2n8cQHHoPO8g==
X-Google-Smtp-Source: ABdhPJxkMYP9if/Ov+6VGoIUS0DQ+i+TYv9gOINFQUYKTcstYR3Cj823rRB2ZBZ4HdnuU32H5yov+wE=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:b6d7:: with SMTP id h23mr4651730qve.17.1601684746354;
 Fri, 02 Oct 2020 17:25:46 -0700 (PDT)
Date:   Fri,  2 Oct 2020 17:25:44 -0700
Message-Id: <20201003002544.3601440-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH bpf-next] bpf: deref map in BPF_PROG_BIND_MAP when it's
 already used
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are missing a deref for the case when we are doing BPF_PROG_BIND_MAP
on a map that's being already held by the program.
There is 'if (ret) bpf_map_put(map)' below which doesn't trigger
because we don't consider this an error.
Let's add missing bpf_map_put() for this specific condition.

Fixes: ef15314aa5de ("bpf: Add BPF_PROG_BIND_MAP syscall")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/syscall.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f1528c2a6927..1110ecd7d1f3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4323,8 +4323,10 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	used_maps_old = prog->aux->used_maps;
 
 	for (i = 0; i < prog->aux->used_map_cnt; i++)
-		if (used_maps_old[i] == map)
+		if (used_maps_old[i] == map) {
+			bpf_map_put(map);
 			goto out_unlock;
+		}
 
 	used_maps_new = kmalloc_array(prog->aux->used_map_cnt + 1,
 				      sizeof(used_maps_new[0]),
-- 
2.28.0.806.g8561365e88-goog

