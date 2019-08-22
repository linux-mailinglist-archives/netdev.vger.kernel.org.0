Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2298EEE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733081AbfHVJOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:14:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41080 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733069AbfHVJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:14:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so3239691pgg.8;
        Thu, 22 Aug 2019 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s13uwYeUDJ3MfvTea2e4qSOfagA3SE+Ke9a29ZUGY9A=;
        b=iXKnRLAoRw0EjyAylvNv4mlSXERFG8wETZ3sJjFXttAOsveA0mT8C4nGw8c1QvdkGT
         VpMbfiMLPyLhZow6O6gXKPemiDB8Z1xA9x85n39jeJb67L9p97JYTNodLChEbE1OJayO
         pylsK2Ry/xsuDaIEqmWzVlAw1qxuN4xlCn6+4Oy8gPZQOZsMkYJbiMRjkg7jlgify7YO
         Gw4QwaXNrsabmvlfrVHALINrONMprSOk+duso1tEfG0pLC1Gn3MwXtRN8WN+coi+nCsy
         FVHa9sqSepQNzA/9T4ILIF5uToVsVrkcVUaMxjYH0Z7wB4O8IoYEIfG1c+mHxp0m1FN2
         dTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s13uwYeUDJ3MfvTea2e4qSOfagA3SE+Ke9a29ZUGY9A=;
        b=qpje+AUhRhfzE0SFoKgs5i2tEZLqpSYsPfX1ufHhIlL3ZHiJ29AcM/eNVHwtD3HaDV
         J12gTzvNs7WYpL9UoUfn3ariHSrBw/stdjYKcCvP8WkugmcgKCO1bZ0btvBUZ8FScNAo
         7ME384acnKLvEuXVe+stFLs4TW7+VxLwkZ4fNAxhGANGNCk7aw6sNRIZujUuuAw9eliX
         qVl4l9x9HJWLNCMyJX8RILXDHaEqiDkzgKsSbK3qfqh36Dxc2Sk4IdVFvEpPc8GxOBZ6
         MI6Vq1pby8oiSO/us4xcxUy38Q5d0GhKU8ItTKL2aV9elNiDPDUuUw5zowtWy1rLraho
         zkmg==
X-Gm-Message-State: APjAAAWUYeDh1LOJrrQ4zaxIalVQkVhLIyH3KXUm3leKMsxDOcv01yXJ
        quC9Y4qoZkiqS4L8TZwUT94=
X-Google-Smtp-Source: APXvYqwvBA214dNmsJekjaKTzlwv5ZLtusq+M2sghTis5Jk7tEgiEAQ7T8WTYgyTN5W3uWoC+zAXBQ==
X-Received: by 2002:a63:101b:: with SMTP id f27mr31670036pgl.291.1566465242527;
        Thu, 22 Aug 2019 02:14:02 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id w207sm28414754pff.93.2019.08.22.02.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:14:02 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next 4/4] xsk: lock the control mutex in sock_diag interface
Date:   Thu, 22 Aug 2019 11:13:06 +0200
Message-Id: <20190822091306.20581-5-bjorn.topel@gmail.com>
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

When accessing the members of an XDP socket, the control mutex should
be held. This commit fixes that.

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

