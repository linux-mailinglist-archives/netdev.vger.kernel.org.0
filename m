Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9949A10496B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfKUDq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:46:59 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33004 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUDq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:46:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id A442E4AF3B;
        Thu, 21 Nov 2019 14:46:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1574308014; bh=qbL81
        Xrcqm0CRYG3X+f1EtMn0hCVCV8kQD3eAcx83Vs=; b=bST1a+qkj4U5caK+O8MuM
        by7VmyJ7a+r/IGoHoSWMPcv5pTkYCAbEQYcR5Yb52Jn6fs5swtvgjoF5lcxqAba5
        a4obQmpZpHEZ8BGf3e7AVtmcYYqQwJ1boFaoCkooQ1vKn/ZghfAQX0OXZsEeRcGg
        H31WoMrUAUKpnR1JBHCU68=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id R1ceVRV-HnbJ; Thu, 21 Nov 2019 14:46:54 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 77ADA4AF3D;
        Thu, 21 Nov 2019 14:46:54 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 01C764AF3B;
        Thu, 21 Nov 2019 14:46:52 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     dsahern@gmail.com, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [iproute2-next] tipc: add new commands to set TIPC AEAD key
Date:   Thu, 21 Nov 2019 10:46:46 +0700
Message-Id: <20191121034646.16737-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new commands are added as part of 'tipc node' command:

 $tipc node set key KEY [algname ALGNAME] [nodeid NODEID]
 $tipc node flush key

which enable user to set and remove AEAD keys in kernel TIPC (requires
the kernel option - 'TIPC_CRYPTO').

For the 'set key' command, the given 'nodeid' parameter decides the
mode to be applied to the key, particularly:

- If NODEID is empty, the key is a 'cluster' key which will be used for
all message encryption/decryption from/to the node (i.e. both TX & RX).
The same key will be set in the other nodes.

- If NODEID is own node, the key is used for message encryption (TX)
from the node. Whereas, if NODEID is a peer node, the key is for
message decryption (RX) from that peer node. This is the 'per-node-key'
mode that each nodes in the cluster has its specific (TX) key.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 include/uapi/linux/tipc.h         |  21 ++++++
 include/uapi/linux/tipc_netlink.h |   4 ++
 tipc/misc.c                       |  38 +++++++++++
 tipc/misc.h                       |   1 +
 tipc/node.c                       | 133 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 195 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tipc.h b/include/uapi/linux/tipc.h
index 0f6f28b2..bd34151f 100644
--- a/include/uapi/linux/tipc.h
+++ b/include/uapi/linux/tipc.h
@@ -233,6 +233,27 @@ struct tipc_sioc_nodeid_req {
 	char node_id[TIPC_NODEID_LEN];
 };
 
+/*
+ * TIPC Crypto, AEAD
+ */
+#define TIPC_AEAD_ALG_NAME		(32)
+
+struct tipc_aead_key {
+	char alg_name[TIPC_AEAD_ALG_NAME];
+	unsigned int keylen;	/* in bytes */
+	char key[];
+};
+
+#define TIPC_AEAD_KEYLEN_MIN		(16 + 4)
+#define TIPC_AEAD_KEYLEN_MAX		(32 + 4)
+#define TIPC_AEAD_KEY_SIZE_MAX		(sizeof(struct tipc_aead_key) + \
+							TIPC_AEAD_KEYLEN_MAX)
+
+static inline int tipc_aead_key_size(struct tipc_aead_key *key)
+{
+	return sizeof(*key) + key->keylen;
+}
+
 /* The macros and functions below are deprecated:
  */
 
diff --git a/include/uapi/linux/tipc_netlink.h b/include/uapi/linux/tipc_netlink.h
index efb958fd..6c2194ab 100644
--- a/include/uapi/linux/tipc_netlink.h
+++ b/include/uapi/linux/tipc_netlink.h
@@ -63,6 +63,8 @@ enum {
 	TIPC_NL_PEER_REMOVE,
 	TIPC_NL_BEARER_ADD,
 	TIPC_NL_UDP_GET_REMOTEIP,
+	TIPC_NL_KEY_SET,
+	TIPC_NL_KEY_FLUSH,
 
 	__TIPC_NL_CMD_MAX,
 	TIPC_NL_CMD_MAX = __TIPC_NL_CMD_MAX - 1
@@ -160,6 +162,8 @@ enum {
 	TIPC_NLA_NODE_UNSPEC,
 	TIPC_NLA_NODE_ADDR,		/* u32 */
 	TIPC_NLA_NODE_UP,		/* flag */
+	TIPC_NLA_NODE_ID,		/* data */
+	TIPC_NLA_NODE_KEY,		/* data */
 
 	__TIPC_NLA_NODE_MAX,
 	TIPC_NLA_NODE_MAX = __TIPC_NLA_NODE_MAX - 1
diff --git a/tipc/misc.c b/tipc/misc.c
index e4b1cd0c..1daf3072 100644
--- a/tipc/misc.c
+++ b/tipc/misc.c
@@ -98,6 +98,44 @@ int str2nodeid(char *str, uint8_t *id)
 	return 0;
 }
 
+int str2key(char *str, struct tipc_aead_key *key)
+{
+	int len = strlen(str);
+	int ishex = 0;
+	int i;
+
+	/* Check if the input is a hex string (i.e. 0x...) */
+	if (len > 2 && strncmp(str, "0x", 2) == 0) {
+	    ishex = is_hex(str + 2, len - 2 - 1);
+	    if (ishex) {
+		len -= 2;
+		str += 2;
+	    }
+	}
+
+	/* Obtain key: */
+	if (!ishex) {
+		key->keylen = len;
+		memcpy(key->key, str, len);
+	} else {
+		/* Convert hex string to key */
+		key->keylen = (len + 1) / 2;
+		for (i = 0; i < key->keylen; i++) {
+			if (i == 0 && len % 2 != 0) {
+				if (sscanf(str, "%1hhx", &key->key[0]) != 1)
+					return -1;
+				str += 1;
+				continue;
+			}
+			if (sscanf(str, "%2hhx", &key->key[i]) != 1)
+				return -1;
+			str += 2;
+		}
+	}
+
+	return 0;
+}
+
 void nodeid2str(uint8_t *id, char *str)
 {
 	int i;
diff --git a/tipc/misc.h b/tipc/misc.h
index ff2f31f1..59309f68 100644
--- a/tipc/misc.h
+++ b/tipc/misc.h
@@ -18,5 +18,6 @@ uint32_t str2addr(char *str);
 int str2nodeid(char *str, uint8_t *id);
 void nodeid2str(uint8_t *id, char *str);
 void hash2nodestr(uint32_t hash, char *str);
+int str2key(char *str, struct tipc_aead_key *key);
 
 #endif
diff --git a/tipc/node.c b/tipc/node.c
index 2fec6753..6c796bfb 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -157,6 +157,111 @@ static int cmd_node_set_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 	return msg_doit(nlh, NULL, NULL);
 }
 
+static void cmd_node_set_key_help(struct cmdl *cmdl)
+{
+	fprintf(stderr,
+		"Usage: %s node set key KEY [algname ALGNAME] [nodeid NODEID]\n\n"
+		"PROPERTIES\n"
+		" KEY                   - Symmetric KEY & SALT as a normal or hex string\n"
+		"                         that consists of two parts:\n"
+		"                         [KEY: 16, 24 or 32 octets][SALT: 4 octets]\n\n"
+		" algname ALGNAME       - Default: \"gcm(aes)\"\n\n"
+		" nodeid NODEID         - Own or peer node identity to which the key will\n"
+		"                         be attached. If not present, the key is a cluster\n"
+		"                         key!\n\n"
+		"EXAMPLES\n"
+		"  %s node set key this_is_a_key16_salt algname \"gcm(aes)\" nodeid node1\n"
+		"  %s node set key 0x746869735F69735F615F6B657931365F73616C74 nodeid node2\n\n",
+		cmdl->argv[0], cmdl->argv[0], cmdl->argv[0]);
+}
+
+static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
+			    struct cmdl *cmdl, void *data)
+{
+	struct {
+		struct tipc_aead_key key;
+		char mem[TIPC_AEAD_KEYLEN_MAX + 1];
+	} input = {};
+	struct opt opts[] = {
+		{ "algname",	OPT_KEYVAL,	NULL },
+		{ "nodeid",	OPT_KEYVAL,	NULL },
+		{ NULL }
+	};
+	struct nlattr *nest;
+	struct opt *opt_algname, *opt_nodeid;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	uint8_t id[TIPC_NODEID_LEN] = {0,};
+	int keysize;
+	char *str;
+
+	if (help_flag) {
+		(cmd->help)(cmdl);
+		return -EINVAL;
+	}
+
+	if (cmdl->optind >= cmdl->argc) {
+		fprintf(stderr, "error, missing key\n");
+		return -EINVAL;
+	}
+
+	/* Get user key */
+	str = shift_cmdl(cmdl);
+	if (str2key(str, &input.key)) {
+		fprintf(stderr, "error, invalid key input\n");
+		return -EINVAL;
+	}
+
+	if (parse_opts(opts, cmdl) < 0)
+		return -EINVAL;
+
+	/* Get algorithm name, default: "gcm(aes)" */
+	opt_algname = get_opt(opts, "algname");
+	if (!opt_algname)
+		strcpy(input.key.alg_name, "gcm(aes)");
+	else
+		strcpy(input.key.alg_name, opt_algname->val);
+
+	/* Get node identity */
+	opt_nodeid = get_opt(opts, "nodeid");
+	if (opt_nodeid && str2nodeid(opt_nodeid->val, id)) {
+		fprintf(stderr, "error, invalid node identity\n");
+		return -EINVAL;
+	}
+
+	/* Init & do the command */
+	nlh = msg_init(buf, TIPC_NL_KEY_SET);
+	if (!nlh) {
+		fprintf(stderr, "error, message initialisation failed\n");
+		return -1;
+	}
+	nest = mnl_attr_nest_start(nlh, TIPC_NLA_NODE);
+	keysize = tipc_aead_key_size(&input.key);
+	mnl_attr_put(nlh, TIPC_NLA_NODE_KEY, keysize, &input.key);
+	if (opt_nodeid)
+		mnl_attr_put(nlh, TIPC_NLA_NODE_ID, TIPC_NODEID_LEN, id);
+	mnl_attr_nest_end(nlh, nest);
+	return msg_doit(nlh, NULL, NULL);
+}
+
+static int cmd_node_flush_key(struct nlmsghdr *nlh, const struct cmd *cmd,
+			      struct cmdl *cmdl, void *data)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+
+	if (help_flag) {
+		(cmd->help)(cmdl);
+		return -EINVAL;
+	}
+
+	/* Init & do the command */
+	nlh = msg_init(buf, TIPC_NL_KEY_FLUSH);
+	if (!nlh) {
+		fprintf(stderr, "error, message initialisation failed\n");
+		return -1;
+	}
+	return msg_doit(nlh, NULL, NULL);
+}
+
 static int nodeid_get_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *info[TIPC_NLA_MAX + 1] = {};
@@ -270,13 +375,34 @@ static int cmd_node_set_netid(struct nlmsghdr *nlh, const struct cmd *cmd,
 	return msg_doit(nlh, NULL, NULL);
 }
 
+static void cmd_node_flush_help(struct cmdl *cmdl)
+{
+	fprintf(stderr,
+		"Usage: %s node flush PROPERTY\n\n"
+		"PROPERTIES\n"
+		" key                   - Flush all symmetric-keys\n",
+		cmdl->argv[0]);
+}
+
+static int cmd_node_flush(struct nlmsghdr *nlh, const struct cmd *cmd,
+			  struct cmdl *cmdl, void *data)
+{
+	const struct cmd cmds[] = {
+		{ "key",        cmd_node_flush_key,     NULL },
+		{ NULL }
+	};
+
+	return run_cmd(nlh, cmd, cmds, cmdl, NULL);
+}
+
 static void cmd_node_set_help(struct cmdl *cmdl)
 {
 	fprintf(stderr,
 		"Usage: %s node set PROPERTY\n\n"
 		"PROPERTIES\n"
 		" identity NODEID       - Set node identity\n"
-		" clusterid CLUSTERID   - Set local cluster id\n",
+		" clusterid CLUSTERID   - Set local cluster id\n"
+		" key PROPERTY          - Set symmetric-key\n",
 		cmdl->argv[0]);
 }
 
@@ -288,6 +414,7 @@ static int cmd_node_set(struct nlmsghdr *nlh, const struct cmd *cmd,
 		{ "identity",	cmd_node_set_nodeid,	NULL },
 		{ "netid",	cmd_node_set_netid,	NULL },
 		{ "clusterid",	cmd_node_set_netid,	NULL },
+		{ "key",	cmd_node_set_key,	cmd_node_set_key_help },
 		{ NULL }
 	};
 
@@ -325,7 +452,8 @@ void cmd_node_help(struct cmdl *cmdl)
 		"COMMANDS\n"
 		" list                  - List remote nodes\n"
 		" get                   - Get local node parameters\n"
-		" set                   - Set local node parameters\n",
+		" set                   - Set local node parameters\n"
+		" flush                 - Flush local node parameters\n",
 		cmdl->argv[0]);
 }
 
@@ -336,6 +464,7 @@ int cmd_node(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
 		{ "list",	cmd_node_list,	NULL },
 		{ "get",	cmd_node_get,	cmd_node_get_help },
 		{ "set",	cmd_node_set,	cmd_node_set_help },
+		{ "flush",	cmd_node_flush, cmd_node_flush_help},
 		{ NULL }
 	};
 
-- 
2.13.7

