Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD9D79C65
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfG2WWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:22:18 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:63639 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbfG2WWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:22:18 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 18:22:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3015; q=dns/txt; s=iport;
  t=1564438938; x=1565648538;
  h=from:to:cc:subject:date:message-id;
  bh=DrO2yKnFyi8F+66k61q6HgiBESDEHiaC3GUOr1F7f5k=;
  b=E//483uplBqW6fDkI7s5IQcU10++KMwi4ymYcEgyPwggbwfz7nuIzG5D
   cupF19aqelh3AEMfszT67Sfc1fuWRjroRBAVFlIpus1Ez2NOXtiTU4KBk
   06UPOAnrntG8XAJnzb9sSAv7m1LcrnFUZbCV7gOheDwB+khlnDW4U28Qo
   4=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CfAQCWbz9d/4ENJK1mGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBZ4IXgT4BMiqhKJEaCQEBAQwBAS8BAYRAgm4jOBMBAwEBBAEBAgE?=
 =?us-ascii?q?GbYUqhXhSgT4BEoMigXcUrgAziHqBSBSBIIcJglCCBxeBQD+BEYNQiicEqnc?=
 =?us-ascii?q?JghyUCAwbmA0BjTuXVgIECwIVgWchgVhwFYMnkQY/AzCOZAEB?=
X-IronPort-AV: E=Sophos;i="5.64,324,1559520000"; 
   d="scan'208";a="302124420"
Received: from alln-core-9.cisco.com ([173.36.13.129])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 29 Jul 2019 22:15:09 +0000
Received: from sjc-ads-7132.cisco.com (sjc-ads-7132.cisco.com [10.30.217.207])
        (authenticated bits=0)
        by alln-core-9.cisco.com (8.15.2/8.15.2) with ESMTPSA id x6TMF85J006800
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 29 Jul 2019 22:15:09 GMT
From:   Taras Kondratiuk <takondra@cisco.com>
To:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        stable@vger.kernel.org
Subject: [PATCH] tipc: compat: allow tipc commands without arguments
Date:   Mon, 29 Jul 2019 22:15:07 +0000
Message-Id: <20190729221507.48893-1-takondra@cisco.com>
X-Mailer: git-send-email 2.18.1
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Authenticated-User: takondra@cisco.com
X-Outbound-SMTP-Client: 10.30.217.207, sjc-ads-7132.cisco.com
X-Outbound-Node: alln-core-9.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
broke older tipc tools that use compat interface (e.g. tipc-config from
tipcutils package):

% tipc-config -p
operation not supported

The commit started to reject TIPC netlink compat messages that do not
have attributes. It is too restrictive because some of such messages are
valid (they don't need any arguments):

% grep 'tx none' include/uapi/linux/tipc_config.h
#define  TIPC_CMD_NOOP              0x0000    /* tx none, rx none */
#define  TIPC_CMD_GET_MEDIA_NAMES   0x0002    /* tx none, rx media_name(s) */
#define  TIPC_CMD_GET_BEARER_NAMES  0x0003    /* tx none, rx bearer_name(s) */
#define  TIPC_CMD_SHOW_PORTS        0x0006    /* tx none, rx ultra_string */
#define  TIPC_CMD_GET_REMOTE_MNG    0x4003    /* tx none, rx unsigned */
#define  TIPC_CMD_GET_MAX_PORTS     0x4004    /* tx none, rx unsigned */
#define  TIPC_CMD_GET_NETID         0x400B    /* tx none, rx unsigned */
#define  TIPC_CMD_NOT_NET_ADMIN     0xC001    /* tx none, rx none */

This patch relaxes the original fix and rejects messages without
arguments only if such arguments are expected by a command (reg_type is
non zero).

Fixes: 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
Cc: stable@vger.kernel.org
Signed-off-by: Taras Kondratiuk <takondra@cisco.com>
---
The patch is based on v5.3-rc2.

 net/tipc/netlink_compat.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index d86030ef1232..e135d4e11231 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -55,6 +55,7 @@ struct tipc_nl_compat_msg {
 	int rep_type;
 	int rep_size;
 	int req_type;
+	int req_size;
 	struct net *net;
 	struct sk_buff *rep;
 	struct tlv_desc *req;
@@ -257,7 +258,8 @@ static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	int err;
 	struct sk_buff *arg;
 
-	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
+	if (msg->req_type && (!msg->req_size ||
+			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
 		return -EINVAL;
 
 	msg->rep = tipc_tlv_alloc(msg->rep_size);
@@ -354,7 +356,8 @@ static int tipc_nl_compat_doit(struct tipc_nl_compat_cmd_doit *cmd,
 {
 	int err;
 
-	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
+	if (msg->req_type && (!msg->req_size ||
+			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
 		return -EINVAL;
 
 	err = __tipc_nl_compat_doit(cmd, msg);
@@ -1278,8 +1281,8 @@ static int tipc_nl_compat_recv(struct sk_buff *skb, struct genl_info *info)
 		goto send;
 	}
 
-	len = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
-	if (!len || !TLV_OK(msg.req, len)) {
+	msg.req_size = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
+	if (msg.req_size && !TLV_OK(msg.req, msg.req_size)) {
 		msg.rep = tipc_get_err_tlv(TIPC_CFG_NOT_SUPPORTED);
 		err = -EOPNOTSUPP;
 		goto send;
-- 
2.19.1

