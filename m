Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5B91498A1
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 04:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgAZD7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 22:59:34 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36582 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZD7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 22:59:34 -0500
Received: by mail-pj1-f67.google.com with SMTP id gv17so1670902pjb.1;
        Sat, 25 Jan 2020 19:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6ApWfuJ0D0g3QrelwnDPlSG8OOKZaWuA97rVS5nYc4w=;
        b=b5xE6ckT9q7fSwYL8kV8uFXEWZvFzT+xtwqoUiQ8iosIvkKb9R0wtLynHYpiRMTTZw
         7LvHDc8INM/jI3yS4RoqcEFizA1kwmxSxZU8a6wlzEQmilrFIB7lV/vqJ9yQHFGQwQuh
         CXvxdqic5v7eikaP2Te9y93lV4FMUDmqBAwcgC6fjScQlMi4+8s0k/h9ED2z01J/mBM8
         hJud0dEi5ff3b9DLOSIWzrjiTl6uz8GRcMqV0WChmfzrmrPoz+QBTd6c2avuhuQ8qiR4
         sYqTLsbgT6ss+9AQAO9KZi2QPPkxw2kJshrsjxNS7kCrVy7WuD4zhYsrhP3nJhNlVeEP
         SlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6ApWfuJ0D0g3QrelwnDPlSG8OOKZaWuA97rVS5nYc4w=;
        b=edrzuHGpl269YEeY3Qdr7h3PuQiX3sQd2OwCn61rGS2VB1CwaV1q+DUWKJhMLjwftf
         xPLbmkvOfbwvMx9XFPacF8lKCeATNj2GfagozSMEKtiSDnoKUmFPkpjfCjZnB1MnQsVv
         IiZBFfXVW+MBjCjzan2EtWWQ9ycCORPBZX0I9WLSNtjAvvWKMgKeJWwG+aSki/b3MmlP
         +Ed1eR/O3nPjgLdGD3DL8dCCaK6dpED1I+qDhCEWjuTu7MYZpgn+oTEoeOF8JIkTJDV8
         2vcZgE5iapJzEw8F7sCV6Uv1nIcaIpX1imGzNudHmPc1wTzZQx18RONe4WyDhS8A8JI8
         9EWg==
X-Gm-Message-State: APjAAAX9LO+SgrzNzHgdHL0UgH0OKb3P6JWC3qOS5qxO2d9KVmGE5zfn
        PIonejWeMfhDNaKtM8LoMe8VEDJh
X-Google-Smtp-Source: APXvYqwQvqQAxXTiDWY4asxbKBSqelPMmlT5UsNNQijJD9uQ1DtcN6V9TMS9RBEjgaRoB0Z57s1Yaw==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr12085789plv.194.1580011173480;
        Sat, 25 Jan 2020 19:59:33 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 64sm11078650pfd.48.2020.01.25.19.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 25 Jan 2020 19:59:33 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] bpf: xdp, virtio_net use access ptr macro for xdp enable check
Date:   Sat, 25 Jan 2020 19:58:52 -0800
Message-Id: <1580011133-17784-3-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
References: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_net currently relies on rcu critical section to access the xdp
program in its xdp_xmit handler. However, the pointer to the xdp program
is only used to do a NULL pointer comparison to determine if xdp is
enabled or not.

Use rcu_access_pointer() instead of rcu_dereference() to reflect this.
Then later when we drop rcu_read critical section virtio_net will not
need in special handling.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434..945eabc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -501,7 +501,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
 	 * indicate XDP resources have been successfully allocated.
 	 */
-	xdp_prog = rcu_dereference(rq->xdp_prog);
+	xdp_prog = rcu_access_pointer(rq->xdp_prog);
 	if (!xdp_prog)
 		return -ENXIO;
 
-- 
2.7.4

