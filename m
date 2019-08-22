Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583CC98EEB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbfHVJN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:13:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:47101 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbfHVJN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:13:58 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so3083382plz.13;
        Thu, 22 Aug 2019 02:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGbD6Vh1mloKQbpoh3OOnJ9gcUMT0+HhT1PxglNKnQ4=;
        b=oD4EOZExG+ViTUs34Nz4fr9HAR3KqkVaabDSDUJ+MjRtyaTNIqhlKPXiZqV32kJ98J
         VJ+37FYjgo8yx/7Jsy18DMOmrObmLe9+VxOJvL6o0bd1c78mPcFdU1QGRSxpAbqROkzy
         rY5D5A0kjyEzljg+sSS+3l2jZa/W5YzwxDymfimyuK3ZP7aiS3bKNGDRb/0KK6DcM4eT
         bUQit+sstfJPFT0wWo3lVxLsn0YFTmRxnBlaO7Ckv9MaKpYT6tRRfw9Xvzzp1D3ee/xj
         HJvjtPnCc4YFURtyazf23ZTP0GDEABjw7gzwb7Zw8E/YZ9mveaTT3A2v6WM89rcxjTpT
         9L/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGbD6Vh1mloKQbpoh3OOnJ9gcUMT0+HhT1PxglNKnQ4=;
        b=gUfjR65e+wxtSs99AvYfjXq93e8tQ3QbM25hAHRmj4dZ3Lj67MFcW4bmGrBDdeQ7i9
         ELlK0x5Nuo52D0IUkNCZ1of9IFaLfuQedrylvcLRH4ABr37GYG6NgejNI+Nm+wc/c35d
         bG3Rj7tBS2WE4DskjJNXIPzj25EyoXkVVlkpNgVP33Ia3hJ8qwR2jrZO4qfwOLQ4fsGG
         l3rZ5z/CNKZc7vWDOmHl+Ce0YcMEqMPSlZH8lcQok27bV8adiU0RYSnXNsh68g87YSAN
         pqZmn4JFQr1ynOl9tX+P64MYHI6iWzpCVrI3fm9+rqq8qP551tjZfzqBgPqfR5DIwaEC
         I6aw==
X-Gm-Message-State: APjAAAXgMdXbqRtGXvLb9kDtnxgvu1E5bOwU0+tjq98akGX8yAJA1dzf
        06ebBZqgvZO6mQm7UdNT5GoSPtbkPkMWlg==
X-Google-Smtp-Source: APXvYqxiz0DJV27uKMnA2sX0w4wTc/ukPA0yKjGYFfOFDrd+Y0G2ViWlcaqxS9Fi7Y9f5bk419YRXQ==
X-Received: by 2002:a17:902:f01:: with SMTP id 1mr37197450ply.337.1566465237693;
        Thu, 22 Aug 2019 02:13:57 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id w207sm28414754pff.93.2019.08.22.02.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:13:57 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next 3/4] xsk: avoid store-tearing when assigning umem
Date:   Thu, 22 Aug 2019 11:13:05 +0200
Message-Id: <20190822091306.20581-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822091306.20581-1-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The umem member of struct xdp_sock is read outside of the control
mutex, in the mmap implementation, and needs a WRITE_ONCE to avoid
potentional store-tearing.

Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 31236e61069b..6dde1857ed52 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -718,7 +718,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
-		xs->umem = umem;
+		WRITE_ONCE(xs->umem, umem);
 		mutex_unlock(&xs->mutex);
 		return 0;
 	}
-- 
2.20.1

