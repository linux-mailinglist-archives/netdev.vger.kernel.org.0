Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3F295271
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504430AbgJUSui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:50:38 -0400
Received: from smtp.uniroma2.it ([160.80.6.22]:47182 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503511AbgJUSuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 14:50:37 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 09LIga9h005673
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Oct 2020 20:42:38 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 2/4] seg6: add callbacks for customizing the creation/destruction of a behavior
Date:   Wed, 21 Oct 2020 20:41:14 +0200
Message-Id: <20201021184116.2722-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201021184116.2722-1-andrea.mayer@uniroma2.it>
References: <20201021184116.2722-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce two callbacks used for customizing the creation/destruction of
a SRv6 behavior. Such callbacks are defined in the new struct
seg6_local_lwtunnel_ops and hereafter we provide a brief description of
them:

 - build_state(...): used for calling the custom constructor of the
   behavior during its initialization phase and after all the attributes
   have been successfully parsed;

 - destroy_state(...): used for calling the custom destructor of the
   behavior before it is completely destroyed.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index eba23279912d..f70687e1b8a9 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -33,11 +33,23 @@
 
 struct seg6_local_lwt;
 
+typedef int (*slwt_build_state_t)(struct seg6_local_lwt *slwt, const void *cfg,
+				  struct netlink_ext_ack *extack);
+typedef void (*slwt_destroy_state_t)(struct seg6_local_lwt *slwt);
+
+/* callbacks used for customizing the creation and destruction of a behavior */
+struct seg6_local_lwtunnel_ops {
+	slwt_build_state_t build_state;
+	slwt_destroy_state_t destroy_state;
+};
+
 struct seg6_action_desc {
 	int action;
 	unsigned long attrs;
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int static_headroom;
+
+	struct seg6_local_lwtunnel_ops slwt_ops;
 };
 
 struct bpf_lwt_prog {
@@ -938,6 +950,45 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 
 };
 
+/* call the custom constructor of the behavior during its initialization phase
+ * and after that all its attributes have been successfully parsed.
+ */
+static int
+seg6_local_lwtunnel_build_state(struct seg6_local_lwt *slwt, const void *cfg,
+				struct netlink_ext_ack *extack)
+{
+	slwt_build_state_t build_func;
+	struct seg6_action_desc *desc;
+	int err = 0;
+
+	desc = slwt->desc;
+	if (!desc)
+		return -EINVAL;
+
+	build_func = desc->slwt_ops.build_state;
+	if (build_func)
+		err = build_func(slwt, cfg, extack);
+
+	return err;
+}
+
+/* call the custom destructor of the behavior which is invoked before the
+ * tunnel is going to be destroyed.
+ */
+static void seg6_local_lwtunnel_destroy_state(struct seg6_local_lwt *slwt)
+{
+	slwt_destroy_state_t destroy_func;
+	struct seg6_action_desc *desc;
+
+	desc = slwt->desc;
+	if (!desc)
+		return;
+
+	destroy_func = desc->slwt_ops.destroy_state;
+	if (destroy_func)
+		destroy_func(slwt);
+}
+
 static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
@@ -1003,6 +1054,10 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		goto out_free;
 
+	err = seg6_local_lwtunnel_build_state(slwt, cfg, extack);
+	if (err < 0)
+		goto out_free;
+
 	newts->type = LWTUNNEL_ENCAP_SEG6_LOCAL;
 	newts->flags = LWTUNNEL_STATE_INPUT_REDIRECT;
 	newts->headroom = slwt->headroom;
@@ -1021,6 +1076,8 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 
+	seg6_local_lwtunnel_destroy_state(slwt);
+
 	kfree(slwt->srh);
 
 	if (slwt->desc->attrs & (1 << SEG6_LOCAL_BPF)) {
-- 
2.20.1

