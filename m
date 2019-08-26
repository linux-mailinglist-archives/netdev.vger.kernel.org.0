Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6909C900
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfHZGLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:11:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36646 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbfHZGLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:11:35 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so9481291plr.3;
        Sun, 25 Aug 2019 23:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SuPxf7vPZ6Wfti2MLSRAa3Lehd0GSwA37ANyIF77LOU=;
        b=Zb1nxp/GCbiYm9WzNsl/aGXiekKIksjhmNedAbh8EKojnV1zKHDI86tRwSHctswoJk
         V/eb4mp3MpoKDfcE18BK+SWI3R8iyCb2vGqgQnI9kcI+9zaY4gzLEa2L+6nULT+tim5L
         NMAS5AMKouF4X+JtwT7G54wq8Fy3FlmzVXIlmTWNhQXhBXfjPfe+iP5x7D+5kZHfk2Wu
         G8bvSGvNq04l7+xnZegOIz3tg7PKxtaFR74X1uXPx28DRQVAYz1SVkQXE/tV6+LwgV5f
         i2yR4+P4WAtxT9ZHS3t5hAxh9fhELLF4NOXW4HBgYTeJr5jkRnU8rzlc9RqVX/Qqkrbs
         s52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuPxf7vPZ6Wfti2MLSRAa3Lehd0GSwA37ANyIF77LOU=;
        b=UKaUG3Sc7yfI0KPu9OH3NlLJlAhIfEQz7g+38r4uApzOAFaaun+z05X8uTIS8qx1az
         2gGC198/ZtM6Wau7kYAd1cGkaAVVfl6KteUhY2YekNZ9xdnqRhvDleh7VsgQxuCK/sFt
         Bm0hI/DygPQxfXRFzyb1adQytfVOMaquNedEz9HHkazoOANtul5g6xuOdeA+qGSOQKq1
         DyZuU2I9We+JbRV7+23R2b5Mt6q7CGPGacl6zjcwIkBZxfJh+cvWlulmuOkqa3Eddb1F
         kfodxoClsyj4lXTU+MsMLsVqhDEinj5qBTbi4jbJNyjs87Aq89qpRz8haOiaW3jODoEB
         irFg==
X-Gm-Message-State: APjAAAU6m75jIj4INtgHkRiGWa0zuT4eifrrIqxPMJXM9ksYDS8mrcz1
        5rm3Jl2TIUDw3wAOvymf8Eo=
X-Google-Smtp-Source: APXvYqwADWytIZ3mlDQpNOTwjD99VoCrat4RKVOpxY9Z4zAkaF87iunzQvSn8W1Z0XUHRE0CgSwlJg==
X-Received: by 2002:a17:902:8f90:: with SMTP id z16mr5186468plo.138.1566799894900;
        Sun, 25 Aug 2019 23:11:34 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id d2sm9567452pjs.21.2019.08.25.23.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:11:34 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v2 4/4] xsk: lock the control mutex in sock_diag interface
Date:   Mon, 26 Aug 2019 08:10:53 +0200
Message-Id: <20190826061053.15996-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826061053.15996-1-bjorn.topel@gmail.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

When accessing the members of an XDP socket, the control mutex should
be held. This commit fixes that.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: a36b38aa2af6 ("xsk: add sock_diag interface for AF_XDP")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index d5e06c8e0cbf..c8f4f11edbbc 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -97,6 +97,7 @@ static int xsk_diag_fill(struct sock *sk, struct sk_buff *nlskb,
 	msg->xdiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, msg->xdiag_cookie);
 
+	mutex_lock(&xs->mutex);
 	if ((req->xdiag_show & XDP_SHOW_INFO) && xsk_diag_put_info(xs, nlskb))
 		goto out_nlmsg_trim;
 
@@ -117,10 +118,12 @@ static int xsk_diag_fill(struct sock *sk, struct sk_buff *nlskb,
 	    sock_diag_put_meminfo(sk, nlskb, XDP_DIAG_MEMINFO))
 		goto out_nlmsg_trim;
 
+	mutex_unlock(&xs->mutex);
 	nlmsg_end(nlskb, nlh);
 	return 0;
 
 out_nlmsg_trim:
+	mutex_unlock(&xs->mutex);
 	nlmsg_cancel(nlskb, nlh);
 	return -EMSGSIZE;
 }
-- 
2.20.1

