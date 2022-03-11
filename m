Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6D4D589E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345906AbiCKDDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345908AbiCKDDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:03:34 -0500
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F295121AF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:02:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 3C9BB440179
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:02:29 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967749; bh=t7WJRPIus0dQzi8s/xkccP/qagUo8vwUmNLGEBagdNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVz/qPC4RA5hBu6pNftnA1v2BJHh7Kn7EU8MZotGbfa6NypPZ5ZLu8mOFbcR5Cbex
         xUqNiKJ8KJl9cF+VAw2s9XBL89ecv6/7YrW+v1N5RqHCWs/LW9xsQ/V25MiNtm9l11
         Cj3lS6CcwbrA9wlX/6QAnhImAOOSHXHxa84lPhng=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 1398731814
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 11:02:29 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967749; bh=t7WJRPIus0dQzi8s/xkccP/qagUo8vwUmNLGEBagdNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVz/qPC4RA5hBu6pNftnA1v2BJHh7Kn7EU8MZotGbfa6NypPZ5ZLu8mOFbcR5Cbex
         xUqNiKJ8KJl9cF+VAw2s9XBL89ecv6/7YrW+v1N5RqHCWs/LW9xsQ/V25MiNtm9l11
         Cj3lS6CcwbrA9wlX/6QAnhImAOOSHXHxa84lPhng=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 8196E15415A8;
        Fri, 11 Mar 2022 11:02:25 +0800 (CST)
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     sunmingbao@tom.com, tyler.sun@dell.com, ping.gan@dell.com,
        yanxiu.cai@dell.com, libin.zhang@dell.com, ao.sun@dell.com
Subject: [PATCH 3/3] nvmet-tcp: support specifying the congestion-control
Date:   Fri, 11 Mar 2022 11:01:13 +0800
Message-Id: <20220311030113.73384-4-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220311030113.73384-1-sunmingbao@tom.com>
References: <20220311030113.73384-1-sunmingbao@tom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingbao Sun <tyler.sun@dell.com>

congestion-control could have a noticeable impaction on the
performance of TCP-based communications. This is of course true
to NVMe_over_TCP.

Different congestion-controls (e.g., cubic, dctcp) are suitable for
different scenarios. Proper adoption of congestion control would benefit
the performance. On the contrary, the performance could be destroyed.

Though we can specify the congestion-control of NVMe_over_TCP via
writing '/proc/sys/net/ipv4/tcp_congestion_control', but this also
changes the congestion-control of all the future TCP sockets that
have not been explicitly assigned the congestion-control, thus bringing
potential impaction on their performance.

So it makes sense to make NVMe_over_TCP support specifying the
congestion-control. And this commit addresses the target side.

Implementation approach:
the following new file entry was created for user to specify the
congestion-control of each nvmet port.
'/sys/kernel/config/nvmet/ports/X/tcp_congestion'
Then later in nvmet_tcp_add_port, the specified congestion-control
would be applied to the listening socket of the nvmet port.

Signed-off-by: Mingbao Sun <tyler.sun@dell.com>
---
 drivers/nvme/target/configfs.c | 37 ++++++++++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h    |  1 +
 drivers/nvme/target/tcp.c      | 11 ++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 091a0ca16361..644e89bb0ee9 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -222,6 +222,41 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 
 CONFIGFS_ATTR(nvmet_, addr_trsvcid);
 
+static ssize_t nvmet_tcp_congestion_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+
+	return snprintf(page, PAGE_SIZE, "%s\n",
+			port->tcp_congestion ? port->tcp_congestion : "");
+}
+
+static ssize_t nvmet_tcp_congestion_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	int len;
+	char *buf;
+
+	len = strcspn(page, "\n");
+	if (!len)
+		return -EINVAL;
+
+	if (nvmet_is_port_enabled(port, __func__))
+		return -EACCES;
+
+	buf = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	kfree(port->tcp_congestion);
+	port->tcp_congestion = buf;
+
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_, tcp_congestion);
+
 static ssize_t nvmet_param_inline_data_size_show(struct config_item *item,
 		char *page)
 {
@@ -1597,6 +1632,7 @@ static void nvmet_port_release(struct config_item *item)
 	list_del(&port->global_entry);
 
 	kfree(port->ana_state);
+	kfree(port->tcp_congestion);
 	kfree(port);
 }
 
@@ -1605,6 +1641,7 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_treq,
 	&nvmet_attr_addr_traddr,
 	&nvmet_attr_addr_trsvcid,
+	&nvmet_attr_tcp_congestion,
 	&nvmet_attr_addr_trtype,
 	&nvmet_attr_param_inline_data_size,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 69637bf8f8e1..76a57c4c3456 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -145,6 +145,7 @@ struct nvmet_port {
 	struct config_group		ana_groups_group;
 	struct nvmet_ana_group		ana_default_group;
 	enum nvme_ana_state		*ana_state;
+	const char			*tcp_congestion;
 	void				*priv;
 	bool				enabled;
 	int				inline_data_size;
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 83ca577f72be..489c46e396b9 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1741,6 +1741,17 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 	if (so_priority > 0)
 		sock_set_priority(port->sock->sk, so_priority);
 
+	if (nport->tcp_congestion) {
+		ret = tcp_set_congestion_control(port->sock->sk,
+						 nport->tcp_congestion,
+						 true, true);
+		if (ret) {
+			pr_err("failed to set port socket's congestion to %s: %d\n",
+			       nport->tcp_congestion, ret);
+			goto err_sock;
+		}
+	}
+
 	ret = kernel_bind(port->sock, (struct sockaddr *)&port->addr,
 			sizeof(port->addr));
 	if (ret) {
-- 
2.26.2

