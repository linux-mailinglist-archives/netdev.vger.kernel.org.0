Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19013AD154
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 19:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbhFRRkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 13:40:00 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:19014 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbhFRRjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 13:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624037861;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=9aomEiUilCrKZnSJXiOR4M40si6/pKUn6h3sBF6FqaU=;
    b=XdNKocRM+4uYAvqKzZuR5+U3mCan1p+fjBcvd6ar+JkdZ9fxiGhHVdq0IJ+a1xEyMI
    DtrH5Gi40VzN6hArWFbEm6OS3WYHc+p2xXF69qKLDxvOo9lTtzhSEa0l8mVvfhGrtnBl
    rweTPYwpkCBYZhhX/ImT9mt2LYPOvLUwt8tfAlSkB5WA3U1DvDRZPa7U6erdVX3DPA1m
    mmdTOFyTMMG+Bj3y74clKNEFyiWDr3mWGhX3r6Qv3LusIil2PJjUM8T6ek9w4W0O51qe
    M3hEwBegPf22mnM2QM3OgD5TiN3mRO3zAvVx9ZZevWR1zLzl5k5f8bIBuaNbvoV9qWY2
    amFA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxO426OllE="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.3 DYNA|AUTH)
    with ESMTPSA id 000885x5IHbe6be
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 18 Jun 2021 19:37:40 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v3 3/3] net: wwan: Allow WWAN drivers to provide blocking tx and poll function
Date:   Fri, 18 Jun 2021 19:36:11 +0200
Message-Id: <20210618173611.134685-4-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618173611.134685-1-stephan@gerhold.net>
References: <20210618173611.134685-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, the WWAN core provides wwan_port_txon/off() to implement
blocking writes. The tx() port operation should not block, instead
wwan_port_txon/off() should be called when the TX queue is full or has
free space again.

However, in some cases it is not straightforward to make use of that
functionality. For example, the RPMSG API used by rpmsg_wwan_ctrl.c
does not provide any way to be notified when the TX queue has space
again. Instead, it only provides the following operations:

  - rpmsg_send(): blocking write (wait until there is space)
  - rpmsg_trysend(): non-blocking write (return error if no space)
  - rpmsg_poll(): set poll flags depending on TX queue state

Generally that's totally sufficient for implementing a char device,
but it does not fit well to the currently provided WWAN port ops.

Most of the time, using the non-blocking rpmsg_trysend() in the
WWAN tx() port operation works just fine. However, with high-frequent
writes to the char device it is possible to trigger a situation
where this causes issues. For example, consider the following
(somewhat unrealistic) example:

 # dd if=/dev/zero bs=1000 of=/dev/wwan0qmi0
 dd: error writing '/dev/wwan0qmi0': Resource temporarily unavailable
 1+0 records out

This fails immediately after writing the first record. It's likely
only a matter of time until this triggers issues for some real application
(e.g. ModemManager sending a lot of large QMI packets).

The rpmsg_char device does not have this problem, because it uses
rpmsg_trysend() and rpmsg_poll() to support non-blocking operations.
Make it possible to use the same in the RPMSG WWAN driver by adding
two new optional wwan_port_ops:

  - tx_blocking(): send data blocking if allowed
  - tx_poll(): set additional TX poll flags

This integrates nicely with the RPMSG API and does not require
any change in existing WWAN drivers.

With these changes, the dd example above blocks instead of exiting
with an error.

Cc: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Changes in v3:
  - Fix build error for cdc-wdm.c by introducing a new optional
    tx_blocking() op instead of having to add an unused parameter
    to all existing WWAN drivers
  - Add mutex_lock(&port->ops_lock) to wwan_port_fops_poll() because
    port->ops might get unset while we're calling port->ops->tx_poll()?
Changes in v2:
  - Fix EPOLLOUT being always set even if poll op is defined
  - Rename poll() op -> tx_poll() since it should be only used for TX
---
Notes from v1:

Note that rpmsg_poll() is an optional callback currently only implemented
by the qcom_smd RPMSG provider. However, it should be easy to implement
this for other RPMSG providers when needed.

Another potential solution suggested by Loic Poulain in [1] is to always
use the blocking rpmsg_send() from a workqueue/kthread and disable TX
until it is done. I think this could also work (perhaps a bit more
difficult to implement) but the main disadvantage is that I don't see
a way to return any kind of error to the client with this approach.
I assume we return immediately from the write() to the char device
after scheduling the rpmsg_send(), so we already reported success
when rpmsg_send() returns.

At the end all that matters to me is that it works properly, so I'm
open for any other suggestions. :)

[1]: https://lore.kernel.org/linux-arm-msm/CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com/
---
 drivers/net/wwan/rpmsg_wwan_ctrl.c | 23 +++++++++++++++++++++++
 drivers/net/wwan/wwan_core.c       | 16 ++++++++++++----
 include/linux/wwan.h               | 13 +++++++++++--
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
index de226cdb69fd..31c24420ab2e 100644
--- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
+++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
@@ -67,10 +67,33 @@ static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 	return 0;
 }
 
+static int rpmsg_wwan_ctrl_tx_blocking(struct wwan_port *port, struct sk_buff *skb)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+	int ret;
+
+	ret = rpmsg_send(rpwwan->ept, skb->data, skb->len);
+	if (ret)
+		return ret;
+
+	consume_skb(skb);
+	return 0;
+}
+
+static __poll_t rpmsg_wwan_ctrl_tx_poll(struct wwan_port *port,
+					struct file *filp, poll_table *wait)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+
+	return rpmsg_poll(rpwwan->ept, filp, wait);
+}
+
 static const struct wwan_port_ops rpmsg_wwan_pops = {
 	.start = rpmsg_wwan_ctrl_start,
 	.stop = rpmsg_wwan_ctrl_stop,
 	.tx = rpmsg_wwan_ctrl_tx,
+	.tx_blocking = rpmsg_wwan_ctrl_tx_blocking,
+	.tx_poll = rpmsg_wwan_ctrl_tx_poll,
 };
 
 static struct device *rpmsg_wwan_find_parent(struct device *dev)
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 7e728042fc41..165afec1dbd1 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -500,7 +500,8 @@ static void wwan_port_op_stop(struct wwan_port *port)
 	mutex_unlock(&port->ops_lock);
 }
 
-static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
+static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb,
+			   bool nonblock)
 {
 	int ret;
 
@@ -510,7 +511,10 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
 		goto out_unlock;
 	}
 
-	ret = port->ops->tx(port, skb);
+	if (nonblock || !port->ops->tx_blocking)
+		ret = port->ops->tx(port, skb);
+	else
+		ret = port->ops->tx_blocking(port, skb);
 
 out_unlock:
 	mutex_unlock(&port->ops_lock);
@@ -637,7 +641,7 @@ static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 	}
 
-	ret = wwan_port_op_tx(port, skb);
+	ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
 	if (ret) {
 		kfree_skb(skb);
 		return ret;
@@ -653,12 +657,16 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 
 	poll_wait(filp, &port->waitqueue, wait);
 
-	if (!is_write_blocked(port))
+	mutex_lock(&port->ops_lock);
+	if (port->ops && port->ops->tx_poll)
+		mask |= port->ops->tx_poll(port, filp, wait);
+	else if (!is_write_blocked(port))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	if (!is_read_blocked(port))
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (!port->ops)
 		mask |= EPOLLHUP | EPOLLERR;
+	mutex_unlock(&port->ops_lock);
 
 	return mask;
 }
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 430a3a0817de..34222230360c 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -6,6 +6,7 @@
 
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/poll.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 
@@ -40,15 +41,23 @@ struct wwan_port;
 /** struct wwan_port_ops - The WWAN port operations
  * @start: The routine for starting the WWAN port device.
  * @stop: The routine for stopping the WWAN port device.
- * @tx: The routine that sends WWAN port protocol data to the device.
+ * @tx: Non-blocking routine that sends WWAN port protocol data to the device.
+ * @tx_blocking: Optional blocking routine that sends WWAN port protocol data
+ *               to the device.
+ * @tx_poll: Optional routine that sets additional TX poll flags.
  *
  * The wwan_port_ops structure contains a list of low-level operations
- * that control a WWAN port device. All functions are mandatory.
+ * that control a WWAN port device. All functions are mandatory unless specified.
  */
 struct wwan_port_ops {
 	int (*start)(struct wwan_port *port);
 	void (*stop)(struct wwan_port *port);
 	int (*tx)(struct wwan_port *port, struct sk_buff *skb);
+
+	/* Optional operations */
+	int (*tx_blocking)(struct wwan_port *port, struct sk_buff *skb);
+	__poll_t (*tx_poll)(struct wwan_port *port, struct file *filp,
+			    poll_table *wait);
 };
 
 /**
-- 
2.32.0

