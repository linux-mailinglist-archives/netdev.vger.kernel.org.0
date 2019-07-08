Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4C62920
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403785AbfGHTO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:14:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40886 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731582AbfGHTOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:14:55 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so29575592iom.7;
        Mon, 08 Jul 2019 12:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tuW20oRn6IJ0xhfycOnDw/Ym3bbk01yn3xu2K8ZvEKA=;
        b=YyuIAZE6F7vdehmPor1V1IKvHWhRBkr3jio+Nt6WPbSbmYBXB1mK5RqPxywmyRrkOg
         w19/AQhLLMJolZvfgRBA30GXUNjJVA9sIs9Fj8mQx0kp28OVs6dWCGPWbo20ya5xv/kH
         7wwcSh2nUxLW328QECKtorSWNIsvAxP0FUkLIvZv5GBC6tKeSXENEcyNT1A8XXTOfbHL
         1C/k1EG2E8QeFIYC1hX1B39ofvtFdEWtw7a6LwQOUj1x8seSiS5f55uIOki2u5zrwMjt
         3qSPf7JwVTJs/Ey1uUxAJFIu04GWsuSFOfOMqYi0asYLvMeQULySNklVRR+8worQk4oC
         Xn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tuW20oRn6IJ0xhfycOnDw/Ym3bbk01yn3xu2K8ZvEKA=;
        b=U6YsG5OL3KDsZaVPY7m2AZDh7sVezlIdXGB8BADD/geqCOWrDN6M+rDl13R4u6PgeE
         X6JU0sJ/QBDAtyPh6TWdswvxrbTA2FNW1RnXbS03ud/oJkg092w2sCjS3pIRFXKehxyA
         L1EGuWov0+/UVnSzEyctjcKRO+nLiTNwhpXWM8St41/YML/L3Wcp4N2FwPO3HE//uFte
         VoyLxZM7U4wcxQB/JNDvbFbE/yPOfDKwGK4c/3XjjaHo8COJqVprkXcwgBFXRwoPWPwE
         Me4E70T1m4yQ4v+ZjS/xy6BQs9WYSNqaP5Z3Iawhctk69Wj/3c1qGzQ2BjyIMcjUtJ/p
         bXWQ==
X-Gm-Message-State: APjAAAWDzuk0ABPjrqYQUzEoScktSRHVL/3s1jVYW1RppE/FOJ/FfT8E
        BSkBdd51bzDG/mL5vbWKT0g=
X-Google-Smtp-Source: APXvYqyzaAqv4RbFPI+87Dq2DfsHMDKN5tetE4s+OJXg00ui1KBSjMiA3Ncj31rgWhlCc0gOAu8DPw==
X-Received: by 2002:a6b:6310:: with SMTP id p16mr20888179iog.118.1562613295102;
        Mon, 08 Jul 2019 12:14:55 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o7sm15117478ioo.81.2019.07.08.12.14.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 12:14:54 -0700 (PDT)
Subject: [bpf PATCH v2 4/6] bpf: sockmap, synchronize_rcu before free'ing map
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 08 Jul 2019 19:14:42 +0000
Message-ID: <156261328226.31108.15349135352631297716.stgit@ubuntu3-kvm1>
In-Reply-To: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to have a synchronize_rcu before free'ing the sockmap because
any outstanding psock references will have a pointer to the map and
when they use this could trigger a use after free.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 28702f2e9a4a..56bcabe7c2f2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -247,6 +247,8 @@ static void sock_map_free(struct bpf_map *map)
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
 
+	synchronize_rcu();
+
 	bpf_map_area_free(stab->sks);
 	kfree(stab);
 }

