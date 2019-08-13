Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1DF8B804
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfHMMHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:36 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43810 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfHMMHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:36 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so42205198pld.10;
        Tue, 13 Aug 2019 05:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSzte4qImKaVoIOJy2YiIp8UqcOexukam1D+S8iGRbI=;
        b=rYf7YTuEe3myzNuvgPRYRaD3BTFxVHi636jXYyYSL+FIOBGyc++9LqKRyYlNv5HYXO
         bpyRcnmoUwDnaguhu4KxthHB/37yhNjff2yr6HCKizcCJabePr/E5nCOwbDVQ5bjtZDy
         XYWwVI61BDv4tGHpVC3jqrt/b00nXEOZx4l8i+pJhQTRHsBawiWmkjZcYwoIqzRdV/Ru
         +SW5iXCi7gJGByM2Msd7aRrguBrtf5cm40q3WN13rofbVSI2WeYdi2kZ+0QFyp5AI1eF
         2eOrEXDaOkiNWZOfUWHnXT9tZl13NjWwBTMAmFCbmkQGAQydta+tRMcbrhOGQrrc+/zo
         j/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSzte4qImKaVoIOJy2YiIp8UqcOexukam1D+S8iGRbI=;
        b=Z5ryXkqXVQ2qawx5cJ+JpOr5evpfXTp1YeK59SXCZgBfGSK92I6C4lFZNNUUwto+hd
         q/8ol3GvoxdNoh93wDHxTtQurXQl7Jdsf+VqNDTeDaA+ZRyz/KG0kXine5qJ5lT+nvDv
         qKfQdkEzCg20w9D4lWzwtxf4mupO7g5RYGJTyAHZ5BrXVbf7i+4r5lfeJcVS/nx1Jl2J
         viORu08IE1WSzKNvnfBjWQfSZ3IYqIszUSf4oLEa2nHZK41DIXCPGJBBdg/Hfd3WKCOy
         UgCyM86k9mCkFxG0RIEMPuNpNI3orSxg3bzKmt608ExbhuCnmx82jJDYgACSnDhd3NH7
         qHlA==
X-Gm-Message-State: APjAAAXIBXNCSy3rqUlYXM3tSPMWT5xRMlg4oaQL8MZ8HOhznhg/vNb7
        bn6zgnLoNHrwCl36xfmsXHc=
X-Google-Smtp-Source: APXvYqzm5EK3vheawBCTLnN7UjuHkG0r+UyZoV4Iii0krs9KlN2izlDyBpjyXwQ/0fcCw1biZ7NuKQ==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr36519225plp.227.1565698055384;
        Tue, 13 Aug 2019 05:07:35 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:34 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 04/14] xdp_flow: Attach bpf prog to XDP in kernel after UMH loaded program
Date:   Tue, 13 Aug 2019 21:05:48 +0900
Message-Id: <20190813120558.6151-5-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As UMH runs under RTNL, it cannot attach XDP from userspace. Thus the
kernel, xdp_flow module, installs the XDP program.

NOTE: As an RFC, XDP-related logic is emulating dev_change_xdp_fd().
I'm thinking I should factor out the logic from dev_change_xdp_fd() and
export it instead.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/linux/netdevice.h        |  4 +++
 net/core/dev.c                   | 11 ++++---
 net/xdp_flow/xdp_flow_kern_mod.c | 63 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8829295..c99e022 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3678,6 +3678,10 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
+		    struct netlink_ext_ack *extack, u32 flags,
+		    struct bpf_prog *prog);
+int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2..a45d2e4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5145,7 +5145,7 @@ static void __netif_receive_skb_list(struct list_head *head)
 		memalloc_noreclaim_restore(noreclaim_flag);
 }
 
-static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
+int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
 	struct bpf_prog *new = xdp->prog;
@@ -5177,6 +5177,7 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(generic_xdp_install);
 
 static int netif_receive_skb_internal(struct sk_buff *skb)
 {
@@ -8001,10 +8002,11 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 	return xdp.prog_id;
 }
+EXPORT_SYMBOL_GPL(__dev_xdp_query);
 
-static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
-			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
+		    struct netlink_ext_ack *extack, u32 flags,
+		    struct bpf_prog *prog)
 {
 	struct netdev_bpf xdp;
 
@@ -8019,6 +8021,7 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 
 	return bpf_op(dev, &xdp);
 }
+EXPORT_SYMBOL_GPL(dev_xdp_install);
 
 static void dev_xdp_uninstall(struct net_device *dev)
 {
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index 823ab65..9cf527d 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -116,10 +116,26 @@ static int xdp_flow_setup_block_cb(enum tc_setup_type type, void *type_data,
 static int xdp_flow_setup_bind(struct net_device *dev,
 			       struct netlink_ext_ack *extack)
 {
+	enum bpf_prog_type attach_type = BPF_PROG_TYPE_XDP;
 	struct mbox_request *req;
+	bpf_op_t bpf_op, bpf_chk;
+	struct bpf_prog *prog;
 	u32 id = 0;
 	int err;
 
+	bpf_op = bpf_chk = dev->netdev_ops->ndo_bpf;
+	if (!bpf_op)
+		bpf_op = generic_xdp_install;
+	else
+		bpf_chk = generic_xdp_install;
+
+	/* TODO: These checks should be unified with net core */
+	if (__dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG))
+		return -EEXIST;
+
+	if (__dev_xdp_query(dev, bpf_op, XDP_QUERY_PROG))
+		return -EBUSY;
+
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
@@ -129,21 +145,56 @@ static int xdp_flow_setup_bind(struct net_device *dev,
 
 	/* Load bpf in UMH and get prog id */
 	err = transact_umh(req, &id);
+	if (err)
+		goto out;
+
+	prog = bpf_prog_get_by_id(id);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto err_umh;
+	}
+
+	if (!bpf_prog_get_ok(prog, &attach_type, false)) {
+		err = -EINVAL;
+		goto err_prog;
+	}
 
-	/* TODO: id will be used to attach bpf prog to XDP
-	 * As we have rtnl_lock, UMH cannot attach prog to XDP
-	 */
+	/* As we have rtnl_lock, install XDP in kernel */
+	err = dev_xdp_install(dev, bpf_op, extack, 0, prog);
+	if (err)
+		goto err_prog;
 
+	/* TODO: Should get prog once more and save it for later check */
+out:
 	kfree(req);
 
 	return err;
+err_prog:
+	bpf_prog_put(prog);
+err_umh:
+	req->cmd = XDP_FLOW_CMD_UNLOAD;
+	transact_umh(req, NULL);
+
+	goto out;
 }
 
 static int xdp_flow_setup_unbind(struct net_device *dev,
 				 struct netlink_ext_ack *extack)
 {
 	struct mbox_request *req;
-	int err;
+	int err, ret = 0;
+	bpf_op_t bpf_op;
+
+	bpf_op = dev->netdev_ops->ndo_bpf;
+	if (!bpf_op)
+		bpf_op = generic_xdp_install;
+
+	/* TODO: Should check if prog is not changed */
+	err = dev_xdp_install(dev, bpf_op, extack, 0, NULL);
+	if (err) {
+		pr_warn("Failed to uninstall XDP prog: %d\n", err);
+		ret = err;
+	}
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
@@ -153,10 +204,12 @@ static int xdp_flow_setup_unbind(struct net_device *dev,
 	req->ifindex = dev->ifindex;
 
 	err = transact_umh(req, NULL);
+	if (err)
+		ret = err;
 
 	kfree(req);
 
-	return err;
+	return ret;
 }
 
 static int xdp_flow_setup(struct net_device *dev, bool do_bind,
-- 
1.8.3.1

