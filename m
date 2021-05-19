Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4AD389822
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhESUnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhESUnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 16:43:00 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D737FC06175F;
        Wed, 19 May 2021 13:41:39 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g4so1681429qtb.12;
        Wed, 19 May 2021 13:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSwdcBYDgX5Py2pqUGi1oxPAvAmc7JVf4dX8rUfJ8wc=;
        b=ldmiIuH2li4E4fXcxxJkXsKUmJ+qGAs03w+efQ0aR1ui/+LfKQLDBjTzSyaENrKEvk
         zRgdg3xwEDTcFc2RJbKMA9PZyl1SyodSGlrvVjxSBvkkt3z/dkFfzSpa7n95PyZzWChv
         2eDHJZ8aR2m3PXc8uV8u1ERpNViw6Kr2we2K877hIjLxlrAHqOGb1dcDjl/WnP+1rkIK
         PB3Fc+urwrtpORcTEAwszPB46dkERdwZpDfaqcz/+YajfZZy4NSplBUBL6kyyZ7TLS5o
         SJcb+7UTL3kaMM6EsVlqMbQTh2UDCTS1Mif1GpU1v+PUsinZiDlms10N3Jxsn6obY7So
         0/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSwdcBYDgX5Py2pqUGi1oxPAvAmc7JVf4dX8rUfJ8wc=;
        b=bbKJeMQye3IgC8LOClwYngj48LlWscnjooSEr20qQ5lVmjmb1kgTrT0kQCuU+SDu5n
         nvSYSgIPbyvh6eZ5o5L5E6sUPuMLNroAOnsA7GW8eRb+WdKPGI6qd4VqUHmXSNrLH++c
         Xv2hEJTkNRpvZaKl5Z900kr3k4MeQvTTq9dy2WDSUVZljWO5iJDvdNad7PAkEPujoWAb
         jnrNnelB+UIWPvsauP4XIEH1aYhbpq8XHs7xkvtjuoacVTmCB3wT5YvCfrs6vVa3V5EE
         vp42kveXz/rHLkM08DDAbLpA4QVB1nbLgUU3pgiB5E29CGIyrnSkewRdJVyb0zNAPdtk
         SdVg==
X-Gm-Message-State: AOAM530Xe3WitzWfXpSpWBZwJamv/6tOzIwAlzWsryJbSaV7+Tvb+wNu
        9Dyxg3etN7mdxI1FjIxTgj/G1Nr59Vzm0w==
X-Google-Smtp-Source: ABdhPJxDgYB9wvg3XmPD0WP/zVlXn46RmyZb/jfRy6+S1Wnx+zxxYUxhgvXY5/WmAj7EFjZ9CKt5Mg==
X-Received: by 2002:ac8:7146:: with SMTP id h6mr1525265qtp.17.1621456898739;
        Wed, 19 May 2021 13:41:38 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a15a:608b:20ec:867f])
        by smtp.gmail.com with ESMTPSA id h3sm601905qkk.82.2021.05.19.13.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 13:41:38 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
Date:   Wed, 19 May 2021 13:41:32 -0700
Message-Id: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We use non-blocking sockets for testing sockmap redirections,
and got some random EAGAIN errors from UDP tests.

There is no guarantee the packet would be immediately available
to receive as soon as it is sent out, even on the local host.
For UDP, this is especially true because it does not lock the
sock during BH (unlike the TCP path). This is probably why we
only saw this error in UDP cases.

No matter how hard we try to make the queue empty check accurate,
it is always possible for recvmsg() to beat ->sk_data_ready().
Therefore, we should just retry in case of EAGAIN.

Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..b1ed182c4720 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
+again:
 	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0)
+	if (n < 0) {
+		if (errno == EAGAIN)
+			goto again;
 		FAIL_ERRNO("%s: read", log_prefix);
+	}
 	if (n == 0)
 		FAIL("%s: incomplete read", log_prefix);
 
-- 
2.25.1

