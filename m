Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87D51836F5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgCLRLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:11:10 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45036 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLRLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:11:09 -0400
Received: by mail-lj1-f196.google.com with SMTP id a10so7282936ljp.11
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSb08jUO1PscpcMIat6OsbfjKhx8HZRSxYG1uKCNpGA=;
        b=VTyQbz7CogS4i8LRp25C8xqU565gko6MZ2QJ7gLXVpCP10Xnzxykmw5YbXRr+38anQ
         aFjiaVOR0WSuJOIRaOAY9lvTB04fMzk/lMFyA3kbChDm2u/F8/uAZ9r+HSkXcxJCawT2
         nploHEqS4PbGR1v59WOe9CmjCcTbCG4Yhp524=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oSb08jUO1PscpcMIat6OsbfjKhx8HZRSxYG1uKCNpGA=;
        b=luvT8evv2s+2/svX3BBrSL14BU5SzhMAnRFBqGIzF9a68oiM/bbti1ZkwWUbBbOQJ5
         blO4KjrRXP99DAqBtI6MeohUkbvGkKq3MrYyx9gW7RtUrEkYw5xOKW1cER1Rzlf4v+kQ
         CYTEARpvBTff0nAn00ieGWzr4Nk6FmpBj9+JCniYLROpol+Q/NuTPy+xs+7x+qg6huWQ
         VQMScW77nipgnYpjvNmX7XNs07fa2blpbJ5d6C8ljPCUnbA1TmODpm+zW1Ciyy7eYNez
         p+Aq7PFueHr6zkxJaTuLWZXXOePkH/LglVvzBLMf7Pi6/9XJvUDUiBLgph1kGjZ6l/kc
         ljrA==
X-Gm-Message-State: ANhLgQ1zujoJDELjtYFb6bbcmbaAO39J3Qvvh3dHcQMswytL9AhuPg+d
        6dcD5+ZMJOcQux1GWtyhS8MEUQ==
X-Google-Smtp-Source: ADFU+vu8LRkR2Bzu5HvGDFDcq1brASp+4hF+OWsdHkIwSscgK15ylMbBtXNufmGlzjEfHVnaOn85uw==
X-Received: by 2002:a2e:a318:: with SMTP id l24mr5665871lje.41.1584033067205;
        Thu, 12 Mar 2020 10:11:07 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a2sm25863908ljn.50.2020.03.12.10.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 10:11:06 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix spurious failures in accept due to EAGAIN
Date:   Thu, 12 Mar 2020 18:11:05 +0100
Message-Id: <20200312171105.533690-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko reports that sockmap_listen test suite is frequently
failing due to accept() calls erroring out with EAGAIN:

  ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
  connect_accept_thread:FAIL:733

This is because we are needlessly putting the listening TCP sockets in
non-blocking mode.

Fix it by using the default blocking mode in all tests in this suite.

Fixes: 44d28be2b8d4 ("selftests/bpf: Tests for sockmap/sockhash holding listening sockets")
Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 52aa468bdccd..90271ec90388 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -754,7 +754,7 @@ static void test_syn_recv_insert_delete(int family, int sotype, int mapfd)
 	int err, s;
 	u64 value;
 
-	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -896,7 +896,7 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
@@ -1028,7 +1028,7 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	s = socket_loopback(family, sotype | SOCK_NONBLOCK);
+	s = socket_loopback(family, sotype);
 	if (s < 0)
 		return;
 
-- 
2.24.1

