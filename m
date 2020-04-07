Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C420E1A0C9C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgDGLMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 07:12:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:33745 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgDGLMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 07:12:32 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.19]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1Mf0uq-1ipUfT29Qw-00gaww; Tue, 07 Apr 2020 13:12:17 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
Subject: [PATCH] l2tp: Allow management of tunnels and session in user namespace
Date:   Tue,  7 Apr 2020 13:11:48 +0200
Message-Id: <20200407111148.28406-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Pi37i8/ZdO+l0xxB5bzHLm+H+wGE7HoJuRKjq8JSx09hbOj6Pds
 G48n5yxM6TOy2a7jXsHyGRcCruJS2FzVGze+sDL4cZWqvX8MxHS3hh8S8NMBK1AclcspcCN
 EGFEK8lnVWlH1cxyP7dsOZXARB2Zzbk0cjxNGz3iVqRMUr/2DBTexmZ4aebVIXatbnli2XO
 VDBETXTw4C2uXTMv6HJlA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:F/ObvcO9eu0=:X6ayZIriyZp4dGhhYAbzma
 u+wqBeK7M75MJorOWb/sm0bHYZ1NP23sjXIETeCasZovLFQsymiagf1kP/SXIy1QTRJzUqChb
 STdIOPF9rkTTVjzJ0TJEQ1zgoYK2+qGsDoDcAFujiGva8Gq5WuTABIYT9j+DDOPhFRJCfFzYr
 HXIuQEj+QyXx45MN8hRwcyJA3r3SGE45zsurUakdVeHL8gg+YrfB26gBALDMwJMhuQMvYkySn
 xesb0gAvREL16uME7aHWSFRB72zk7rUrCgXrXfeUvpotCY/IznbqR173SPulvziyN7Ix6J7PP
 41Edr2bWMo3cqDkyQQKCELDlkZzfBBxvnPnN+gphqHB35qlM3Ti8YDmG3o4aCvzWs00tziWtj
 rcc7LK9l7JHOHfQQRcmOYSSFWO77pokxZQVwqhFdTiJv0cQm6KbnDBZYaUGj4pBJHG2ZUsWAs
 wNv08/BrK+q5IDEvuywrnJzD4nJO7K+JNy/meTo+30pQQEJygWWCAc3RGtrZofOqRyNGkShwi
 mnG8nZzYF612muOPjj5qge54NUGFClY2/OC7KUo8Yh8KB6BHdJc6OX6FD8+WtHWnsoQaQuW5k
 UeWEHKDGUrBHKXrsCKl1kZgXEN6uPlG3PZbYYbWh8qdabfV1ey+6nLS7mncgK1kA7YjsGye92
 SQL9O4to4sEuzsrvZ6sd4QO1LDzej3nuxJvlkjVv6Bxk3UjOvU3p//YP+ZLZh4QtkXL8kifo+
 PMJ1RnQRG6Pg7rY1jJP4TLW80cvmrXkUbxQzKXu2uEhFcMXANoBhlVTM0ITHWfWvWz4iXt7ZU
 KDduv6ScO9Hu/GCe4J+HB90n8rGJxYgvF+kMB/01Bwf35esgqkBJStU7JK8n828Rgb+XaTdOf
 Udq40vO1GvJufMvGfBng==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creation and management of L2TPv3 tunnels and session through netlink
requires CAP_NET_ADMIN. However, a process with CAP_NET_ADMIN in a
non-initial user namespace gets an EPERM due to the use of the
genetlink GENL_ADMIN_PERM flag. Thus, management of L2TP VPNs inside
an unprivileged container won't work.

We replaced the GENL_ADMIN_PERM by the GENL_UNS_ADMIN_PERM flag
similar to other network modules which also had this problem, e.g.,
openvswitch (commit 4a92602aa1cd "openvswitch: allow management from
inside user namespaces") and nl80211 (commit 5617c6cd6f844 "nl80211:
Allow privileged operations from user namespaces").

I tested this in the container runtime trustm3 (trustm3.github.io)
and was able to create l2tp tunnels and sessions in unpriviliged
(user namespaced) containers using a private network namespace.
For other runtimes such as docker or lxc this should work, too.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 net/l2tp/l2tp_netlink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index f5a9bdc4980c..ebb381c3f1b9 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -920,51 +920,51 @@ static const struct genl_ops l2tp_nl_ops[] = {
 		.cmd = L2TP_CMD_TUNNEL_CREATE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_create,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_DELETE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_delete,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_MODIFY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_modify,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_get,
 		.dumpit = l2tp_nl_cmd_tunnel_dump,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_CREATE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_create,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_DELETE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_delete,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_MODIFY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_modify,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_get,
 		.dumpit = l2tp_nl_cmd_session_dump,
-		.flags = GENL_ADMIN_PERM,
+		.flags = GENL_UNS_ADMIN_PERM,
 	},
 };
 
-- 
2.20.1

