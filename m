Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84A4A817B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfIDLtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:49:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42486 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729774AbfIDLtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 07:49:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so11107718pgb.9;
        Wed, 04 Sep 2019 04:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m2GWrCu6Yp2/AvmU7Djr4/KynHbwAR5ba11BQUHMvBU=;
        b=Ufq6mgXaQ5OjMGWeUrfmMi7aP7CdMIBgq5R1fXi+JbO0/qrKFAJX9NzhDe1TWBNTu2
         ZozDuFLys9sJjY8tZ4KXagnUVsB5Cs4Gc74zH3OAC7Tr82PJPxr6NXVou8L4OLeRdXYK
         zBv7PPxbXOhUff/Mcx4JCXr6LSWBeQS7nfjCYgp0cB0UiUvo3fgagHUXy4fqvFTW3nsf
         XuOmJ0tJIVFBpctRL/m2hZypJiavkJA7zOH4Un3m3d5pdCPCdvf7Scx2YMXS1YBiNEQ/
         xnN7j5dZsuG6tibM0PjePsd3FKfpHa2Bg+FwIK84caKyMrKzASt/qUjPcy78PdQeErX+
         JcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2GWrCu6Yp2/AvmU7Djr4/KynHbwAR5ba11BQUHMvBU=;
        b=NXIZMBjJTIVwcHXoEF2d5VjanNdEOxzguvojLdIxOL/XecdDjm/J9v1gRg8lNlAshq
         kt+F7E8Z4chdGrPtO0BvwRTvyODt5Rid6LL+CXqaC6XpV+xapxQ+8kqYgT+d5C0ooebE
         xTVvmCST9C6BBBze3vT2ckdUMbWsmpYsIfkjoWvUh1NgLtI+h4Adhs87/1UBJ4XRTBBB
         +g/M40Hs7f7JhqJSXmv3NQ7wwHEL7KCbke+Mr+Tkzy0iSjVQR+LlBxhXNYFUIdDkNICj
         5dyTmg/cmN1PnT2kWThg+UnwMj9Ij/7pXa7MqfB6vonLdgm3JNuPSs5vXsXelWNM8D9L
         mi8w==
X-Gm-Message-State: APjAAAUPuVt6CZ5H0xSXI9HTYdTzohigbO02KgatC3a+DjbQiyk9xHdN
        Qs+eZboR/mHD6ePsY4wjSng=
X-Google-Smtp-Source: APXvYqyZXXmKAsk9itmyadcRF21M7VVDXHGujlAHTvo1l9S6+ZtsLkMHjJk/iiU2jiUssO3og/C0wg==
X-Received: by 2002:aa7:8219:: with SMTP id k25mr46219337pfi.72.1567597784535;
        Wed, 04 Sep 2019 04:49:44 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b126sm48257008pfa.177.2019.09.04.04.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 04:49:44 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v3 4/4] xsk: lock the control mutex in sock_diag interface
Date:   Wed,  4 Sep 2019 13:49:13 +0200
Message-Id: <20190904114913.17217-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904114913.17217-1-bjorn.topel@gmail.com>
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
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
index 9986a759fe06..f59791ba43a0 100644
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

