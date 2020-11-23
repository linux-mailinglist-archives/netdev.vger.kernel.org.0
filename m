Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE72C1314
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgKWSay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:30:54 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41906 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbgKWSax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:30:53 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ANITqgi016939
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Nov 2020 19:29:55 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 4/8] seg6: add callbacks for customizing the creation/destruction of a behavior
Date:   Mon, 23 Nov 2020 19:28:52 +0100
Message-Id: <20201123182857.4640-5-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
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
   have been parsed successfully;

 - destroy_state(...): used for calling the custom destructor of the
   behavior before it is completely destroyed.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 3b5657c622a0..da5bf4167a52 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -33,6 +33,13 @@
 
 struct seg6_local_lwt;
 
+/* callbacks used for customizing the creation and destruction of a behavior */
+struct seg6_local_lwtunnel_ops {
+	int (*build_state)(struct seg6_local_lwt *slwt, const void *cfg,
+			   struct netlink_ext_ack *extack);
+	void (*destroy_state)(struct seg6_local_lwt *slwt);
+};
+
 struct seg6_action_desc {
 	int action;
 	unsigned long attrs;
@@ -53,6 +60,8 @@ struct seg6_action_desc {
 
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int static_headroom;
+
+	struct seg6_local_lwtunnel_ops slwt_ops;
 };
 
 struct bpf_lwt_prog {
@@ -1055,6 +1064,38 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 	return err;
 }
 
+/* call the custom constructor of the behavior during its initialization phase
+ * and after that all its attributes have been parsed successfully.
+ */
+static int
+seg6_local_lwtunnel_build_state(struct seg6_local_lwt *slwt, const void *cfg,
+				struct netlink_ext_ack *extack)
+{
+	struct seg6_action_desc *desc = slwt->desc;
+	struct seg6_local_lwtunnel_ops *ops;
+
+	ops = &desc->slwt_ops;
+	if (!ops->build_state)
+		return 0;
+
+	return ops->build_state(slwt, cfg, extack);
+}
+
+/* call the custom destructor of the behavior which is invoked before the
+ * tunnel is going to be destroyed.
+ */
+static void seg6_local_lwtunnel_destroy_state(struct seg6_local_lwt *slwt)
+{
+	struct seg6_action_desc *desc = slwt->desc;
+	struct seg6_local_lwtunnel_ops *ops;
+
+	ops = &desc->slwt_ops;
+	if (!ops->destroy_state)
+		return;
+
+	ops->destroy_state(slwt);
+}
+
 static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
@@ -1154,6 +1195,10 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		goto out_free;
 
+	err = seg6_local_lwtunnel_build_state(slwt, cfg, extack);
+	if (err < 0)
+		goto out_destroy_attrs;
+
 	newts->type = LWTUNNEL_ENCAP_SEG6_LOCAL;
 	newts->flags = LWTUNNEL_STATE_INPUT_REDIRECT;
 	newts->headroom = slwt->headroom;
@@ -1162,6 +1207,8 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
 
 	return 0;
 
+out_destroy_attrs:
+	destroy_attrs(slwt);
 out_free:
 	kfree(newts);
 	return err;
@@ -1171,6 +1218,8 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 
+	seg6_local_lwtunnel_destroy_state(slwt);
+
 	destroy_attrs(slwt);
 
 	return;
-- 
2.20.1

