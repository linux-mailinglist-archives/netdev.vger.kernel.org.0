Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9724249EA75
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 19:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiA0SnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 13:43:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37354 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiA0SnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 13:43:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC7761D8E;
        Thu, 27 Jan 2022 18:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7E7C340EB;
        Thu, 27 Jan 2022 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643308987;
        bh=KolYNhoa/8oFGX7SzNStWkDMLjKwIIjMuz0YIOOxROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a17oHIlXLpoIfDB08t6IGczkdK/BAbAJTvk0+tStA1grwcgW6C8VnHYR0uuP5eHg6
         wJREaNRKIkKiAkHc/pVhuiKiN/srsB1Qt1LfVDiUcUzUk64l/n4+YYFIS9dVpDsE7y
         qBF9O18Iez953srIiL8ZxhmwDHcubFAZXngZsJ9LzBKtACBEp7e7z67/ECUH7t97nd
         Cm+3FIeVig7BONnbzcrhKB80Lsom59tx0GrO/n4EBQv1dwhX0KaoA0gDQJr+n9aJtp
         2jjdhphJU/q7hovGkmG2BUHxmc+gGymH3yWd/NYy+B968rlaVOUL7dEPBo20agqAkn
         ob3qnTHZNXd1A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        idosch@nvidia.com, corbet@lwn.net, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] ethtool: add header/data split indication
Date:   Thu, 27 Jan 2022 10:42:59 -0800
Message-Id: <20220127184300.490747-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127184300.490747-1-kuba@kernel.org>
References: <20220127184300.490747-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For applications running on a mix of platforms it's useful
to have a clear indication whether host's NIC supports the
geometry requirements of TCP zero-copy. TCP zero-copy Rx
requires data to be neatly placed into memory pages.
Most NICs can't do that.

This patch is adding GET support only, since the NICs
I work with either always have the feature enabled or
enable it whenever MTU is set to jumbo. In other words
I don't need SET. But adding set should be trivial.
(The only note on SET is that we will likely want
the setting to be "sticky" and use 0 / `unknown`
to reset it back to driver default.)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  8 ++++++++
 include/linux/ethtool.h                      |  2 ++
 include/uapi/linux/ethtool_netlink.h         |  7 +++++++
 net/ethtool/rings.c                          | 15 ++++++++++-----
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 9d98e0511249..cae28af7a476 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -860,8 +860,16 @@ Gets ring sizes like ``ETHTOOL_GRINGPARAM`` ioctl request.
   ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
+  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
   ====================================  ======  ===========================
 
+``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
+page-flipping TCP zero-copy receive (``getsockopt(TCP_ZEROCOPY_RECEIVE)``).
+If enabled the device is configured to place frame headers and data into
+separate buffers. The device configuration must make it possible to receive
+full memory pages of data, for example because MTU is high enough or through
+HW-GRO.
+
 
 RINGS_SET
 =========
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 11efc45de66a..e0853f48b75e 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -70,9 +70,11 @@ enum {
 /**
  * struct kernel_ethtool_ringparam - RX/TX ring configuration
  * @rx_buf_len: Current length of buffers on the rx ring.
+ * @tcp_data_split: Scatter packet headers and data to separate buffers
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
+	u8	tcp_data_split;
 };
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index cca6e474a085..417d4280d7b5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -318,6 +318,12 @@ enum {
 
 /* RINGS */
 
+enum {
+	ETHTOOL_TCP_DATA_SPLIT_UNKNOWN = 0,
+	ETHTOOL_TCP_DATA_SPLIT_DISABLED,
+	ETHTOOL_TCP_DATA_SPLIT_ENABLED,
+};
+
 enum {
 	ETHTOOL_A_RINGS_UNSPEC,
 	ETHTOOL_A_RINGS_HEADER,				/* nest - _A_HEADER_* */
@@ -330,6 +336,7 @@ enum {
 	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
 	ETHTOOL_A_RINGS_TX,				/* u32 */
 	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
+	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index c1d5f5e0fdc9..18a5035d3bee 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -53,7 +53,8 @@ static int rings_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MINI */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO */
 	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX */
-	       nla_total_size(sizeof(u32));     /* _RINGS_RX_BUF_LEN */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_BUF_LEN */
+	       nla_total_size(sizeof(u8));	/* _RINGS_TCP_DATA_SPLIT */
 }
 
 static int rings_fill_reply(struct sk_buff *skb,
@@ -61,9 +62,11 @@ static int rings_fill_reply(struct sk_buff *skb,
 			    const struct ethnl_reply_data *reply_base)
 {
 	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
-	const struct kernel_ethtool_ringparam *kernel_ringparam = &data->kernel_ringparam;
+	const struct kernel_ethtool_ringparam *kr = &data->kernel_ringparam;
 	const struct ethtool_ringparam *ringparam = &data->ringparam;
 
+	WARN_ON(kr->tcp_data_split > ETHTOOL_TCP_DATA_SPLIT_ENABLED);
+
 	if ((ringparam->rx_max_pending &&
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MAX,
 			  ringparam->rx_max_pending) ||
@@ -84,9 +87,11 @@ static int rings_fill_reply(struct sk_buff *skb,
 			  ringparam->tx_max_pending) ||
 	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
 			  ringparam->tx_pending)))  ||
-	    (kernel_ringparam->rx_buf_len &&
-	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
-			  kernel_ringparam->rx_buf_len))))
+	    (kr->rx_buf_len &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN, kr->rx_buf_len))) ||
+	    (kr->tcp_data_split &&
+	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
+			 kr->tcp_data_split))))
 		return -EMSGSIZE;
 
 	return 0;
-- 
2.34.1

