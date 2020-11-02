Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A76D2A3324
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgKBSlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:41:15 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51979 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgKBSlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 13:41:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A4A95C0154;
        Mon,  2 Nov 2020 13:41:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 02 Nov 2020 13:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DXq6i4Cj38bbX8++T
        50AdXoHshKS41hrnRjCD8dQYaY=; b=QnXNzgtHOWCtjYb0CaShhFIiYXCHAT5Db
        c5bNosY7YdmVy31MzrS0O5tDmtyNjd4rcnQdoE89BqPfgWXZUusyLuxmmOhEF/qm
        FFolW0DvX9PMvKIPwXMOFZQEsW50epTSNyoZ8bNLq/zCTut9mEL75bhLVZXB2ZYx
        spHeUzs4jbNqD9mSLF0EyYmOynufVk6aW+U1aVg3pctJ4sDRLvJRuZEBa971wCLp
        Xpw659uJ38smIPl2jmdObm+VBgJNfJ54f6I7KlBNtQ8CUknNCdcEOzAzSbAmNsQK
        fJA4nJC0SxfZ1mh9EyokoSyhIcP/LFKy7wXyDiNlWbyiTk1QxtRPg==
X-ME-Sender: <xms:yFKgX6m1M1u4f0oyCqvQNtmMIUnxFfvwg0ElhOO2HmFU9qK9KoV6Lw>
    <xme:yFKgXx1L_JcYntkPfarzbdMh8fJq8rm9pjGla5LtFA7HN2BXGaEcPoT1LzP3LRkvF
    02nPhPX8OKKUQY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtuddgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheehrddukedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yFKgX4phBL59dpOZHOe3h89DpX1sDdcmNvsTv1Yt6vsbM8yQ-a9GlQ>
    <xmx:yFKgX-nvmrMbf9juBV-Bz_S02KuTzzY3ha7StPYklnIa_QRRQ9TZHg>
    <xmx:yFKgX41AkyFrdD3phvuHj27wYFbWESjlKhp-ojXF1UBCo4qAsUL90A>
    <xmx:yVKgX1-v_uDZlgZ8GK0rw8BKEB3Sx829nXdCs6CrA6DosCoIBx-wuA>
Received: from shredder.mtl.com (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17DBE3064682;
        Mon,  2 Nov 2020 13:41:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool] ethtool: Improve compatibility between netlink and ioctl interfaces
Date:   Mon,  2 Nov 2020 20:40:36 +0200
Message-Id: <20201102184036.866513-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

With the ioctl interface, when autoneg is enabled, but without
specifying speed, duplex or link modes, the advertised link modes are
set to the supported link modes by the ethtool user space utility.

This does not happen when using the netlink interface. Fix this
incompatibility problem by having ethtool query the supported link modes
from the kernel and advertise all of them when only "autoneg on" is
specified.

Before:

# ethtool -s eth0 advertise 0xC autoneg on
# ethtool -s eth0 autoneg on
# ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  100baseT/Half 100baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: internal
	MDI-X: off (auto)
	Supports Wake-on: umbg
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

After:

# ethtool -s eth0 advertise 0xC autoneg on
# ethtool -s eth0 autoneg on
# ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: internal
	MDI-X: on (auto)
	Supports Wake-on: umbg
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Michal / Jakub, let me know if you see a better way. Sending as RFC
since I want to run it through regression first.
---
 netlink/settings.c | 115 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index 41a2e5af1945..1f856b1b14d5 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -1110,6 +1110,113 @@ static const struct param_parser sset_params[] = {
 	{}
 };
 
+static bool sset_is_autoneg_only(const struct nl_context *nlctx)
+{
+	return nlctx->argc == 2 && !strcmp(nlctx->argp[0], "autoneg") &&
+	       !strcmp(nlctx->argp[1], "on");
+}
+
+static int linkmodes_reply_adver_all_cb(const struct nlmsghdr *nlhdr,
+					void *data)
+{
+	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	const struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(bitset_tb);
+	struct nl_context *nlctx = data;
+	struct nl_msg_buff *msgbuff;
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_socket *nlsk;
+	struct nlattr *nest;
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	if (!tb[ETHTOOL_A_LINKMODES_OURS])
+		return -EINVAL;
+
+	ret = mnl_attr_parse_nested(tb[ETHTOOL_A_LINKMODES_OURS], attr_cb,
+				    &bitset_tb_info);
+	if (ret < 0)
+		return ret;
+	if (!bitset_tb[ETHTOOL_A_BITSET_SIZE] ||
+	    !bitset_tb[ETHTOOL_A_BITSET_VALUE] ||
+	    !bitset_tb[ETHTOOL_A_BITSET_MASK])
+		return -EINVAL;
+
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		return ret;
+
+	nlsk = nlctx->ethnl2_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_LINKMODES_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return ret;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_LINKMODES_HEADER,
+			       nlctx->devname, 0))
+		return -EMSGSIZE;
+
+	if (ethnla_put_u8(msgbuff, ETHTOOL_A_LINKMODES_AUTONEG, AUTONEG_ENABLE))
+		return -EMSGSIZE;
+
+	/* Use the size and mask from the reply and set the value to the mask,
+	 * so that all supported link modes will be advertised.
+	 */
+	ret = -EMSGSIZE;
+	nest = ethnla_nest_start(msgbuff, ETHTOOL_A_LINKMODES_OURS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_SIZE,
+			   mnl_attr_get_u32(bitset_tb[ETHTOOL_A_BITSET_SIZE])))
+		goto err;
+
+	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_VALUE,
+		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
+		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
+		goto err;
+
+	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_MASK,
+		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
+		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
+		goto err;
+
+	ethnla_nest_end(msgbuff, nest);
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return ret;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret < 0)
+		return ret;
+
+	return MNL_CB_OK;
+
+err:
+	ethnla_nest_cancel(msgbuff, nest);
+	return ret;
+}
+
+static int sset_adver_all(struct nl_context *nlctx)
+{
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(nlctx->ctx, ETHTOOL_MSG_LINKMODES_GET, false) ||
+	    netlink_cmd_check(nlctx->ctx, ETHTOOL_MSG_LINKMODES_SET, false))
+		return -EOPNOTSUPP;
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_LINKMODES_GET,
+				      ETHTOOL_A_LINKMODES_HEADER,
+				      ETHTOOL_FLAG_COMPACT_BITSETS);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, linkmodes_reply_adver_all_cb);
+}
+
 int nl_sset(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
@@ -1120,6 +1227,14 @@ int nl_sset(struct cmd_context *ctx)
 	nlctx->argc = ctx->argc;
 	nlctx->devname = ctx->devname;
 
+	/* For compatibility reasons with ioctl-based ethtool, when "autoneg
+	 * on" is specified without "advertise", "speed" and "duplex", we need
+	 * to query the supported link modes from the kernel and advertise all
+	 * of them.
+	 */
+	if (sset_is_autoneg_only(nlctx))
+		return sset_adver_all(nlctx);
+
 	ret = nl_parser(nlctx, sset_params, NULL, PARSER_GROUP_MSG);
 	if (ret < 0)
 		return 1;
-- 
2.26.2

