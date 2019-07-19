Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4016EA3A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfGSRb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:27 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46257 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfGSRbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so31772214qtn.13
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NPZ25U0KNpg61Ku6URhVeBa08Dg0ip/p/6qGinSsNF4=;
        b=iRqO/zmZsiY742S7Al6C7CdTFTa6wwA8cDdH3FikXXc3+zn3klRynZTJWNHnuq4Rju
         vKAso6Bdp59OhmIFt7EvUIrRJ5lm+3ih+DBQ/MpwJg8cuaIG+bfEWYeMKjE5taBbk0w7
         iOlVFVERL2k9VqdifNlB57lsri6N5FcR7/FB2Ud+PLvjjWU5jKqWjdWpZY2AOxEv788c
         NFeJuL/xZrF2YtU7PenuEng0g+4xRtrUM7l4MzTb6DpBZqxKDBjczk8mCivDaitx2EzD
         hiHCUY7+7r+nwATFBp/jfaARJ6iaDUI4oqshJfBrG7MHVvknTyEpODrxVPzfBsl5hHj5
         J/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NPZ25U0KNpg61Ku6URhVeBa08Dg0ip/p/6qGinSsNF4=;
        b=JYXywjftIW1DZ1nc/Yzek7if9sKw0UUejCQiCoEsAnitn6k3bDrTWdVgLRSplAZ1N1
         WopEu2fKLSPWhSu8jeuLojgYfqeWxNVoYwG9v9MQvz0Qj8Li0j1fXfMngw8M0xxO8XtJ
         O2n2sWibDU392u6Gk83dqrbADzNHm3SG4EI63ZHxdAM+0WXzFrkTSF1u7Ft3oQ8C8IGH
         tON7ZR9Xmrdw8KaCVNESlM8/OXh9oiW+uS35tw7AgmnzlHi3J8CHGqxq5JB93AA8bTnC
         +Z3jHiQix86dEsvYSmuQ4/Vy8w1aIvHAXLq5r5jfCYdAU+5BRxhMWfXXfZRsqKsm6d0s
         UPaQ==
X-Gm-Message-State: APjAAAVaJvBrX+XdbvIyPZPG/A9JJc3KbfBX7zDUGqfx0kqABOUWC6Dc
        Rw5keWp4hAi/uKGo5HXs9kP4DQ==
X-Google-Smtp-Source: APXvYqxVGs3taP73E4A+4kWAiuZ1pib5I5zuO+JxNACtCa0arieTn2xxS/EIDRuqsmuuHbMYJpzeQA==
X-Received: by 2002:ac8:1a3c:: with SMTP id v57mr37686895qtj.339.1563557469320;
        Fri, 19 Jul 2019 10:31:09 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:08 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf v4 06/14] bpf: sockmap, sock_map_delete needs to use xchg
Date:   Fri, 19 Jul 2019 10:29:19 -0700
Message-Id: <20190719172927.18181-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

__sock_map_delete() may be called from a tcp event such as unhash or
close from the following trace,

  tcp_bpf_close()
    tcp_bpf_remove()
      sk_psock_unlink()
        sock_map_delete_from_link()
          __sock_map_delete()

In this case the sock lock is held but this only protects against
duplicate removals on the TCP side. If the map is free'd then we have
this trace,

  sock_map_free
    xchg()                  <- replaces map entry
    sock_map_unref()
      sk_psock_put()
        sock_map_del_link()

The __sock_map_delete() call however uses a read, test, null over the
map entry which can result in both paths trying to free the map
entry.

To fix use xchg in TCP paths as well so we avoid having two references
to the same map entry.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 52d4faeee18b..28702f2e9a4a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -276,16 +276,20 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 			     struct sock **psk)
 {
 	struct sock *sk;
+	int err = 0;
 
 	raw_spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
-		*psk = NULL;
+		sk = xchg(psk, NULL);
+
+	if (likely(sk))
+		sock_map_unref(sk, psk);
+	else
+		err = -EINVAL;
+
 	raw_spin_unlock_bh(&stab->lock);
-	if (unlikely(!sk))
-		return -EINVAL;
-	sock_map_unref(sk, psk);
-	return 0;
+	return err;
 }
 
 static void sock_map_delete_from_link(struct bpf_map *map, struct sock *sk,
-- 
2.21.0

