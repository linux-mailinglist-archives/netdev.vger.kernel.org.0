Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88D12AA64A
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgKGPdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:33:25 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:51964 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgKGPdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 10:33:23 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0A7FW8qd010493
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 7 Nov 2020 16:32:10 +0100
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
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next,v2,2/5] seg6: improve management of behavior attributes
Date:   Sat,  7 Nov 2020 16:31:36 +0100
Message-Id: <20201107153139.3552-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the attribute (i.e.: SEG6_LOCAL_SRH, SEG6_LOCAL_TABLE, etc),
the parse() callback performs some validity checks on the provided input
and updates the tunnel state (slwt) with the result of the parsing
operation. However, an attribute may also need to reserve some additional
resources (i.e.: memory or setting up an eBPF program) in the parse()
callback to complete the parsing operation.

The parse() callbacks are invoked by the parse_nla_action() for each
attribute belonging to a specific behavior. Given a behavior with N
attributes, if the parsing of the i-th attribute fails, the
parse_nla_action() returns immediately with an error. Nonetheless, the
resources acquired during the parsing of the i-1 attributes are not freed
by the parse_nla_action().

Attributes which acquire resources must release them *in an explicit way*
in both the seg6_local_{build/destroy}_state(). However, adding a new
attribute of this type requires changes to
seg6_local_{build/destroy}_state() to release the resources correctly.

The seg6local infrastructure still lacks a simple and structured way to
release the resources acquired in the parse() operations.

We introduced a new callback in the struct seg6_action_param named
destroy(). This callback releases any resource which may have been acquired
in the parse() counterpart. Each attribute may or may not implement the
destroy() callback depending on whether it needs to free some acquired
resources.

The destroy() callback comes with several of advantages:

 1) we can have many attributes as we want for a given behavior with no
    need to explicitly free the taken resources;

 2) As in case of the seg6_local_build_state(), the
    seg6_local_destroy_state() does not need to handle the release of
    resources directly. Indeed, it calls the destroy_attrs() function which
    is in charge of calling the destroy() callback for every set attribute.
    We do not need to patch seg6_local_{build/destroy}_state() anymore as
    we add new attributes;

 3) the code is more readable and better structured. Indeed, all the
    information needed to handle a given attribute are contained in only
    one place;

 4) it facilitates the integration with new features introduced in further
    patches.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 103 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index eba23279912d..63a82e2fdea9 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -710,6 +710,12 @@ static int cmp_nla_srh(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return memcmp(a->srh, b->srh, len);
 }
 
+static void destroy_attr_srh(struct seg6_local_lwt *slwt)
+{
+	kfree(slwt->srh);
+	slwt->srh = NULL;
+}
+
 static int parse_nla_table(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	slwt->table = nla_get_u32(attrs[SEG6_LOCAL_TABLE]);
@@ -901,16 +907,33 @@ static int cmp_nla_bpf(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
 	return strcmp(a->bpf.name, b->bpf.name);
 }
 
+static void destroy_attr_bpf(struct seg6_local_lwt *slwt)
+{
+	kfree(slwt->bpf.name);
+	if (slwt->bpf.prog)
+		bpf_prog_put(slwt->bpf.prog);
+
+	slwt->bpf.name = NULL;
+	slwt->bpf.prog = NULL;
+}
+
 struct seg6_action_param {
 	int (*parse)(struct nlattr **attrs, struct seg6_local_lwt *slwt);
 	int (*put)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
 	int (*cmp)(struct seg6_local_lwt *a, struct seg6_local_lwt *b);
+
+	/* optional destroy() callback useful for releasing resources which
+	 * have been previously acquired in the corresponding parse()
+	 * function.
+	 */
+	void (*destroy)(struct seg6_local_lwt *slwt);
 };
 
 static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_SRH]	= { .parse = parse_nla_srh,
 				    .put = put_nla_srh,
-				    .cmp = cmp_nla_srh },
+				    .cmp = cmp_nla_srh,
+				    .destroy = destroy_attr_srh },
 
 	[SEG6_LOCAL_TABLE]	= { .parse = parse_nla_table,
 				    .put = put_nla_table,
@@ -934,13 +957,68 @@ static struct seg6_action_param seg6_action_params[SEG6_LOCAL_MAX + 1] = {
 
 	[SEG6_LOCAL_BPF]	= { .parse = parse_nla_bpf,
 				    .put = put_nla_bpf,
-				    .cmp = cmp_nla_bpf },
+				    .cmp = cmp_nla_bpf,
+				    .destroy = destroy_attr_bpf },
 
 };
 
+/* call the destroy() callback (if available) for each set attribute in
+ * @parsed_attrs, starting from attribute index @start up to @end excluded.
+ */
+static void __destroy_attrs(unsigned long parsed_attrs, int start, int end,
+			    struct seg6_local_lwt *slwt)
+{
+	struct seg6_action_param *param;
+	int i;
+
+	/* Every seg6local attribute is identified by an ID which is encoded as
+	 * a flag (i.e: 1 << ID) in the @parsed_attrs bitmask; such bitmask
+	 * keeps track of the attributes parsed so far.
+
+	 * We scan the @parsed_attrs bitmask, starting from the attribute
+	 * identified by @start up to the attribute identified by @end
+	 * excluded. For each set attribute, we retrieve the corresponding
+	 * destroy() callback.
+	 * If the callback is not available, then we skip to the next
+	 * attribute; otherwise, we call the destroy() callback.
+	 */
+	for (i = start; i < end; ++i) {
+		if (!(parsed_attrs & (1 << i)))
+			continue;
+
+		param = &seg6_action_params[i];
+
+		if (param->destroy)
+			param->destroy(slwt);
+	}
+}
+
+/* release all the resources that may have been acquired during parsing
+ * operations.
+ */
+static void destroy_attrs(struct seg6_local_lwt *slwt)
+{
+	struct seg6_action_desc *desc;
+	unsigned long attrs;
+
+	desc = slwt->desc;
+	if (!desc) {
+		WARN_ONCE(1,
+			  "seg6local: seg6_action_desc* for action %d is NULL",
+			  slwt->action);
+		return;
+	}
+
+	/* get the attributes for the current behavior instance */
+	attrs = desc->attrs;
+
+	__destroy_attrs(attrs, 0, SEG6_LOCAL_MAX + 1, slwt);
+}
+
 static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 {
 	struct seg6_action_param *param;
+	unsigned long parsed_attrs = 0;
 	struct seg6_action_desc *desc;
 	int i, err;
 
@@ -963,11 +1041,22 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 
 			err = param->parse(attrs, slwt);
 			if (err < 0)
-				return err;
+				goto parse_err;
+
+			/* current attribute has been parsed correctly */
+			parsed_attrs |= (1 << i);
 		}
 	}
 
 	return 0;
+
+parse_err:
+	/* release any resource that may have been acquired during the i-1
+	 * parse() operations.
+	 */
+	__destroy_attrs(parsed_attrs, 0, i, slwt);
+
+	return err;
 }
 
 static int seg6_local_build_state(struct net *net, struct nlattr *nla,
@@ -1012,7 +1101,6 @@ static int seg6_local_build_state(struct net *net, struct nlattr *nla,
 	return 0;
 
 out_free:
-	kfree(slwt->srh);
 	kfree(newts);
 	return err;
 }
@@ -1021,12 +1109,7 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
 {
 	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(lwt);
 
-	kfree(slwt->srh);
-
-	if (slwt->desc->attrs & (1 << SEG6_LOCAL_BPF)) {
-		kfree(slwt->bpf.name);
-		bpf_prog_put(slwt->bpf.prog);
-	}
+	destroy_attrs(slwt);
 
 	return;
 }
-- 
2.20.1

