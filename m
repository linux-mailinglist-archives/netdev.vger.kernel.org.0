Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6A21CBC3
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGLWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgGLWQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:16:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59F2C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w2so5120438pgg.10
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w8efYOhXcP+dTHFuze3QX9/aKYJrv9G6peHhed5cV4M=;
        b=r/nJ5VHFYf8C2J5gV7xqUM8hPF/r26ANxgnT73ChzP+2zVm2yQHlaN0s5vDNfp1zNr
         jJUKN5XZekrQpji5Zb9kMSMIc9w40FVD2yeo21xf4QlBOMGyrrHL7ZwnW/WgCNRS4MDx
         tvN0/jBSkqvCe8vPOQaI3U3pynBnionT+GRlygOIZYrJK3kaNJJVoIKcY6SwEcqnCiVf
         gUwaI5jzCkcLNLR8n+0XLaiSk4hUuV/Wt7AmVHeVuigN5WzZfHRaQEVUsIjbI7pz29z6
         Da+NUkPZZsmx0BQXQbrtQIiNw0kTUnnHfelSW0CK45c0R6iZWTbFsgXUdHeK+7V88ry4
         Vm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w8efYOhXcP+dTHFuze3QX9/aKYJrv9G6peHhed5cV4M=;
        b=ZsHCsaF8Lh7g9RhF7uC+DvJUWANAJKHH6PZh4FlxWRW5n3Hp7l9EBIWQXX//fAMw2L
         xAbgKDZp+JTU5PRv2uzDXeGdvnselLToob45+eKPbriVwrCg7Y41SHk2kWTNqlqHgQmJ
         FL9z7labXzTeH4C9OIvrPxs5WU0rLyD03zO1HJwKhKK0OhEGWw3DwcdkHgMsI36HbM9L
         5eNQkJilw69oIyHZUL9Lvc5gLjaExYa93t8dRrWJhUotT+aJglnr7irUFSw3tSa2Y4qa
         mtNBuJMmUAXG9oVANjak+lPTbfM/wlmrdJDiBFFuHxOo/w/1pToXsZHWIBw0SU7lvI/m
         yxcg==
X-Gm-Message-State: AOAM5321+ou06JHqS5VO/qPE+ZSRW6ieHJ4REjQO/1jPV6u2FznWgRm/
        2K302MUrV/HQO1KmrNqsy0gm1Opj
X-Google-Smtp-Source: ABdhPJw3kqCzmbQig3Z7VMGWl+2SNBIPAmn0EeDWEjwU2iU9+MUAUyMjaVB/QPmbg8lmsHJ7Lpp+aA==
X-Received: by 2002:a63:e50a:: with SMTP id r10mr65573562pgh.285.1594592194736;
        Sun, 12 Jul 2020 15:16:34 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y198sm12470228pfg.116.2020.07.12.15.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 15:16:33 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, mkubecek@suse.cz, kuba@kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 1/3] net: Introduce netdev_ops_equal
Date:   Sun, 12 Jul 2020 15:16:23 -0700
Message-Id: <20200712221625.287763-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200712221625.287763-1-f.fainelli@gmail.com>
References: <20200712221625.287763-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA plays some tricks with overloading of a network device's netdev_ops
in order to inject statistics, register dumps or various other
operations. Because the pointer to the netdev_ops is not the same as the
one the network driver registers, checks like theses:

dev->netdev_ops == &foo_ops

will no longer work. In order to allow such tests to continue, introduce
a ndo_equal() function pointer which can be specified by whomever
assignes the net_device::netdev_ops, and in introduce a convenience
function: netdev_ops_equal() which either calls that NDO, or defaults to
a simple pointer comparison.

A subsequent patch will do a tree wide conversion to the helper.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/netdevice.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac2cd3f49aba..012033817a35 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1280,6 +1280,9 @@ struct netdev_net_notifier {
  * int (*ndo_tunnel_ctl)(struct net_device *dev, struct ip_tunnel_parm *p,
  *			 int cmd);
  *	Add, change, delete or get information on an IPv4 tunnel.
+ * bool (*ndo_equal)(struct net_device *dev, const struct net_device_ops *ops)
+ *	Returns if the current network device operations are equal to another
+ *	set.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1487,6 +1490,8 @@ struct net_device_ops {
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
+	bool			(*ndo_equal)(struct net_device *dev,
+					     const struct net_device_ops *ops);
 };
 
 /**
@@ -2145,6 +2150,27 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+/**
+ * netdev_ops_equal - Convenience function for testing equality of a
+ * &struct net_device_ops against another.
+ * @dev: &struct net_device instance
+ * @ops: &struct net_device_ops to test against
+ */
+static inline bool netdev_ops_equal(struct net_device *dev,
+				    const struct net_device_ops *ops)
+{
+	if (!dev->netdev_ops->ndo_equal)
+		return dev->netdev_ops == ops;
+
+	return dev->netdev_ops->ndo_equal(dev, ops);
+}
+
+static inline bool __netdev_ops_equal(const struct net_device *dev,
+				      const struct net_device_ops *ops)
+{
+	return netdev_ops_equal((struct net_device *)dev, ops);
+}
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
-- 
2.25.1

