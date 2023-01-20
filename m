Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C071675AFC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjATRRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjATRRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:17:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7156AC1333;
        Fri, 20 Jan 2023 09:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0786D62007;
        Fri, 20 Jan 2023 17:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FBEC433D2;
        Fri, 20 Jan 2023 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674235050;
        bh=PfYzcL0XK5JhoGv80VxXF7DlN2HDONwLvwe8btuT22A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExZmrCuRZ4+/jLkxpFns448nBXBLp7DSlLBw1tosruA6J0h9KBhAB2WOkA5dy/JAJ
         uTs0JlZpnPRwARvBJVJOlEUmwU11BlpRjIhMrIN0CfYEKaJ5Owb2pgUNPBUb8ZleEy
         o6e178Pvoqjc6JAKEPnQbFFHqfLUjDkk3XriFAHzA/x3OTi01eC3tcKS2cLAFVd05R
         ap5vgnXZkmO4zjW5V4lCHi0egT8bMbUKmZsoCTI9VIZVxV0G+U5MZ9LI8w/oiRJoYT
         h/j1iIWUHr+ywwlXnL4RUgTmskqf6IGYVpbNdraExktYcRPDb4UZzsV55rumYklhuX
         JXE44kbEbgTDw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: [PATCH bpf-next 4/7] libbpf: add the capability to specify netlink proto in libbpf_netlink_send_recv
Date:   Fri, 20 Jan 2023 18:16:53 +0100
Message-Id: <dd429eee8932e74439c161a589356db102454dbe.1674234430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674234430.git.lorenzo@kernel.org>
References: <cover.1674234430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch in order to introduce netlink_generic
protocol support to libbpf.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/netlink.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 35104580870c..d2468a04a6c3 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -41,7 +41,7 @@ struct xdp_id_md {
 	struct xdp_link_info info;
 };
 
-static int libbpf_netlink_open(__u32 *nl_pid)
+static int libbpf_netlink_open(__u32 *nl_pid, int proto)
 {
 	struct sockaddr_nl sa;
 	socklen_t addrlen;
@@ -51,7 +51,7 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	memset(&sa, 0, sizeof(sa));
 	sa.nl_family = AF_NETLINK;
 
-	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
+	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, proto);
 	if (sock < 0)
 		return -errno;
 
@@ -212,14 +212,14 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 }
 
 static int libbpf_netlink_send_recv(struct libbpf_nla_req *req,
-				    __dump_nlmsg_t parse_msg,
+				    int proto, __dump_nlmsg_t parse_msg,
 				    libbpf_dump_nlmsg_t parse_attr,
 				    void *cookie)
 {
 	__u32 nl_pid = 0;
 	int sock, ret;
 
-	sock = libbpf_netlink_open(&nl_pid);
+	sock = libbpf_netlink_open(&nl_pid, proto);
 	if (sock < 0)
 		return sock;
 
@@ -271,7 +271,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	}
 	nlattr_end_nested(&req, nla);
 
-	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NETLINK_ROUTE, NULL, NULL, NULL);
 }
 
 int bpf_xdp_attach(int ifindex, int prog_fd, __u32 flags, const struct bpf_xdp_attach_opts *opts)
@@ -382,7 +382,7 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = xdp_flags;
 
-	err = libbpf_netlink_send_recv(&req, __dump_link_nlmsg,
+	err = libbpf_netlink_send_recv(&req, NETLINK_ROUTE, __dump_link_nlmsg,
 				       get_xdp_info, &xdp_id);
 	if (err)
 		return libbpf_err(err);
@@ -493,7 +493,7 @@ static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
 	if (ret < 0)
 		return ret;
 
-	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NETLINK_ROUTE, NULL, NULL, NULL);
 }
 
 static int tc_qdisc_create_excl(struct bpf_tc_hook *hook)
@@ -673,7 +673,8 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 
 	info.opts = opts;
 
-	ret = libbpf_netlink_send_recv(&req, get_tc_info, NULL, &info);
+	ret = libbpf_netlink_send_recv(&req, NETLINK_ROUTE, get_tc_info, NULL,
+				       &info);
 	if (ret < 0)
 		return libbpf_err(ret);
 	if (!info.processed)
@@ -739,7 +740,7 @@ static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
 			return ret;
 	}
 
-	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NETLINK_ROUTE, NULL, NULL, NULL);
 }
 
 int bpf_tc_detach(const struct bpf_tc_hook *hook,
@@ -804,7 +805,8 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 
 	info.opts = opts;
 
-	ret = libbpf_netlink_send_recv(&req, get_tc_info, NULL, &info);
+	ret = libbpf_netlink_send_recv(&req, NETLINK_ROUTE, get_tc_info, NULL,
+				       &info);
 	if (ret < 0)
 		return libbpf_err(ret);
 	if (!info.processed)
-- 
2.39.0

