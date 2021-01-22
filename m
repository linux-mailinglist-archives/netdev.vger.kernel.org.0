Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B4E3010C2
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbhAVXNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbhAVThq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECF0223B01;
        Fri, 22 Jan 2021 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344225;
        bh=v3Gx10vzekBNEUkpryaCWXDAuDR+azPfFBHOx1ikn2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNFZncZdssTZ191tnjFKryXDf0i4Tx2wRI08+Wn+n0BQE8QLzbNbIFU/3HAmpPiUB
         ZQTG+haDf6FpI3WqgzoFgWtWwqpKagqNl+q+FJuISBMPO9S9etx4QV+V1owbjI34N+
         cB69YyCAIWOi/alrSPvn08PgyDQNwoWqa+CN2bQutC1Katou8MPfBV/DjhSg9j9pBY
         +NIwB65mStLIr4RPSMdOny3bgncb4hBG/B9gofh1cOMC37JyotJlckLQlRQ4P8u8OQ
         u1f1sVfSelKJValeroZr12taRBLToUWadKnzgwBFLrXd0SB1+a+F0dMtzy0HWBYrl8
         vuKqmrgTZJcdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V10 01/14] devlink: Prepare code to fill multiple port function attributes
Date:   Fri, 22 Jan 2021 11:36:45 -0800
Message-Id: <20210122193658.282884-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122193658.282884-1-saeed@kernel.org>
References: <20210122193658.282884-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Prepare code to fill zero or more port function optional attributes.
Subsequent patch makes use of this to fill more port function
attributes.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 net/core/devlink.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..c39496311b71 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -712,6 +712,31 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int
+devlink_port_fn_hw_addr_fill(struct devlink *devlink, const struct devlink_ops *ops,
+			     struct devlink_port *port, struct sk_buff *msg,
+			     struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	u8 hw_addr[MAX_ADDR_LEN];
+	int hw_addr_len;
+	int err;
+
+	if (!ops->port_function_hw_addr_get)
+		return 0;
+
+	err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	err = nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_addr);
+	if (err)
+		return err;
+	*msg_updated = true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
 				   struct netlink_ext_ack *extack)
@@ -719,36 +744,17 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	struct devlink *devlink = port->devlink;
 	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
-	bool empty_nest = true;
-	int err = 0;
+	bool msg_updated = false;
+	int err;
 
 	function_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_PORT_FUNCTION);
 	if (!function_attr)
 		return -EMSGSIZE;
 
 	ops = devlink->ops;
-	if (ops->port_function_hw_addr_get) {
-		int hw_addr_len;
-		u8 hw_addr[MAX_ADDR_LEN];
-
-		err = ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_len, extack);
-		if (err == -EOPNOTSUPP) {
-			/* Port function attributes are optional for a port. If port doesn't
-			 * support function attribute, returning -EOPNOTSUPP is not an error.
-			 */
-			err = 0;
-			goto out;
-		} else if (err) {
-			goto out;
-		}
-		err = nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_addr);
-		if (err)
-			goto out;
-		empty_nest = false;
-	}
-
-out:
-	if (err || empty_nest)
+	err = devlink_port_fn_hw_addr_fill(devlink, ops, port, msg,
+					   extack, &msg_updated);
+	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
 		nla_nest_end(msg, function_attr);
@@ -986,7 +992,6 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 	const struct devlink_ops *ops;
 	const u8 *hw_addr;
 	int hw_addr_len;
-	int err;
 
 	hw_addr = nla_data(attr);
 	hw_addr_len = nla_len(attr);
@@ -1011,12 +1016,7 @@ devlink_port_function_hw_addr_set(struct devlink *devlink, struct devlink_port *
 		return -EOPNOTSUPP;
 	}
 
-	err = ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
-	if (err)
-		return err;
-
-	devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	return ops->port_function_hw_addr_set(devlink, port, hw_addr, hw_addr_len, extack);
 }
 
 static int
@@ -1037,6 +1037,8 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 	if (attr)
 		err = devlink_port_function_hw_addr_set(devlink, port, attr, extack);
 
+	if (!err)
+		devlink_port_notify(port, DEVLINK_CMD_PORT_NEW);
 	return err;
 }
 
-- 
2.26.2

