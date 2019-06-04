Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E77334646
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 14:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfFDMKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 08:10:31 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44643 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfFDMKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 08:10:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so10237829pgp.11;
        Tue, 04 Jun 2019 05:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EwJYsf92ydp+RtKiuVnWST5ck78zmLqyjDy58wjkNzk=;
        b=ALgMXYShkAFuscaf0G46Fe8IyL9l9sUJz35RiyTWOUtl+VQsGb3VE5G+kAFvWHJ989
         PzhD5ZvYnLcVx7VNy5G7ZxMWsPJ/EA4GdjGBTj1eyxgm7wi0fDim3GgYKIWP/UAlIHcK
         by1KonlJQhDWsjNTw4RJeeVd5uhcc9sFoTQe7jao13cWC/Lt2s6+rj4QdFK+EsLmCjsh
         Q9+fhsv77zWy4VweL+38l6VUado93b+f40sn8S2SE7dd8s1QPImSyoLhsooGIbYugyVS
         NNWrMuWwmz/yqigNzN2eRjfMiBv82P35nWrrgwBObfCb4jilxaFSQvDH0Pq3pLG/mElZ
         1hDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EwJYsf92ydp+RtKiuVnWST5ck78zmLqyjDy58wjkNzk=;
        b=fEvvYOCdPKfih0B/zLavoAx9/khF/4apjKuFyimkfam3BTSFJF4vgAIx9JklsOdeP5
         TJ0LxnNbhwhmmX1rrvnd+rfAwGA4+15opld29ChdLrQCikHgniapZHplDRz3RU+r55VC
         T5YUcP9ZD4r0oHMMxmdAjqNuh/vxc2PoecV9MCPgOtGvDCK+z09k2/j0hv9fENa+e5F7
         LXDsmdxoCcub0PoL9E0SnsSEJ6OvvrZJwhKkYkCGSg78iwNCd3dGjVMpELpiuTbid7rJ
         Ym+iq7olOUFHcfHWNM2YV/arYPZAJjWN+Z0lBhk+yeYpN51UDvN4GWG/CpDFjfXdR9j4
         JuJA==
X-Gm-Message-State: APjAAAUOGZHtEtpRMshMYS0L5Et3/29BxeSo3jUYxBuWzBO6xQ7ierYl
        I8pKliTYgtRbLb133dM494BIuIdSf1asFQ==
X-Google-Smtp-Source: APXvYqw5pE1KuL3N0NnrEDYlsEeAPn8xPJJRq+laPDZyZTkLXt4pZDqinvcFRcOBNQeq0UQqQktwtQ==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr35305514pgm.40.1559650229927;
        Tue, 04 Jun 2019 05:10:29 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id s1sm14168708pgp.94.2019.06.04.05.10.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 04 Jun 2019 05:10:28 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] rose: af_rose: avoid overflows in rose_setsockopt()
Date:   Tue,  4 Jun 2019 20:11:30 +0800
Message-Id: <1559650290-17054-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check setsockopt arguments to avoid overflows and return -EINVAL for
too large arguments.

See commit 32288eb4d940 ("netrom: avoid overflows in nr_setsockopt()")
for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/rose/af_rose.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index e274bc6..af831ee9 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -372,15 +372,15 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct rose_sock *rose = rose_sk(sk);
-	int opt;
+	unsigned long opt;
 
 	if (level != SOL_ROSE)
 		return -ENOPROTOOPT;
 
-	if (optlen < sizeof(int))
+	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (get_user(opt, (int __user *)optval))
+	if (get_user(opt, (unsigned int __user *)optval))
 		return -EFAULT;
 
 	switch (optname) {
@@ -389,31 +389,31 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 
 	case ROSE_T1:
-		if (opt < 1)
+		if (opt < 1 || opt > ULONG_MAX / HZ)
 			return -EINVAL;
 		rose->t1 = opt * HZ;
 		return 0;
 
 	case ROSE_T2:
-		if (opt < 1)
+		if (opt < 1 || opt > ULONG_MAX / HZ)
 			return -EINVAL;
 		rose->t2 = opt * HZ;
 		return 0;
 
 	case ROSE_T3:
-		if (opt < 1)
+		if (opt < 1 || opt > ULONG_MAX / HZ)
 			return -EINVAL;
 		rose->t3 = opt * HZ;
 		return 0;
 
 	case ROSE_HOLDBACK:
-		if (opt < 1)
+		if (opt < 1 || opt > ULONG_MAX / HZ)
 			return -EINVAL;
 		rose->hb = opt * HZ;
 		return 0;
 
 	case ROSE_IDLE:
-		if (opt < 0)
+		if (opt < 0 || opt > ULONG_MAX / HZ)
 			return -EINVAL;
 		rose->idle = opt * 60 * HZ;
 		return 0;
-- 
2.7.4

