Return-Path: <netdev+bounces-9374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFD7728A09
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F2631C210A1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3554B34D7F;
	Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD434CDD
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2BFC4339C;
	Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258729;
	bh=UIF+37/PWhwBeICz/O++NhivvtVT/LP6wwoyc5uBeaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA/dOnYLw+pjXFE4l26PAmpb5OPOGwma3BTX83YoB2kVwAVoifIbwM+Bzl7bBWuox
	 R1JwupymwgnyPbxdpjr6MvR6Hx2xehiVccp2kiO9u8MJLZpWdIMK0gt90jerXQcq92
	 L/DlJX7C2QfQrGEa/akYRn1yYRcRriL1a+Tqpwh0vtFTvmNovvf6n1UxB00Cxlu9LS
	 iCzfzQ65tZIgAcIKLrRN554GbDzPj9uJ5ceJfxsUudNpdA5OJryJxTVHG6tEJtf/Qx
	 SI5Ba/bw7e8tNVZkzUn2e6wYHwG+DYwx9peOsElN81fzPg2kh82hKFq0b/dTokq5P9
	 Gcq5kkmzuMSXw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/12] tools: ynl-gen: stop generating common notification handlers
Date: Thu,  8 Jun 2023 14:11:55 -0700
Message-Id: <20230608211200.1247213-8-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Common notification handler was supposed to be a way for the user
to parse the notifications from a socket synchronously.
I don't think we'll end up using it, ynl_ntf_check() works for
all known use cases.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 73 --------------------------------------
 1 file changed, 73 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index ecd8beba7e0d..f88417947e60 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1810,70 +1810,6 @@ _C_KW = {
     ri.cw.nl()
 
 
-def print_ntf_parse_prototype(family, cw, suffix=';'):
-    cw.write_func_prot('struct ynl_ntf_base_type *', f"{family['name']}_ntf_parse",
-                       ['struct ynl_sock *ys'], suffix=suffix)
-
-
-def print_ntf_type_parse(family, cw, ku_mode):
-    print_ntf_parse_prototype(family, cw, suffix='')
-    cw.block_start()
-    cw.write_func_lvar(['struct genlmsghdr *genlh;',
-                        'struct nlmsghdr *nlh;',
-                        'struct ynl_parse_arg yarg = { .ys = ys, };',
-                        'struct ynl_ntf_base_type *rsp;',
-                        'int len, err;',
-                        'mnl_cb_t parse;'])
-    cw.p('len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);')
-    cw.p('if (len < (ssize_t)(sizeof(*nlh) + sizeof(*genlh)))')
-    cw.p('return NULL;')
-    cw.nl()
-    cw.p('nlh = (struct nlmsghdr *)ys->rx_buf;')
-    cw.p('genlh = mnl_nlmsg_get_payload(nlh);')
-    cw.nl()
-    cw.block_start(line='switch (genlh->cmd)')
-    for ntf_op in sorted(family.all_notify.keys()):
-        op = family.ops[ntf_op]
-        ri = RenderInfo(cw, family, ku_mode, op, ntf_op, "notify")
-        for ntf in op['notify']['cmds']:
-            cw.p(f"case {ntf.enum_name}:")
-        cw.p(f"rsp = calloc(1, sizeof({type_name(ri, 'notify')}));")
-        cw.p(f"parse = {op_prefix(ri, 'reply', deref=True)}_parse;")
-        cw.p(f"yarg.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
-        cw.p(f"rsp->free = (void *){op_prefix(ri, 'notify')}_free;")
-        cw.p('break;')
-    for op_name, op in family.ops.items():
-        if 'event' not in op:
-            continue
-        ri = RenderInfo(cw, family, ku_mode, op, op_name, "event")
-        cw.p(f"case {op.enum_name}:")
-        cw.p(f"rsp = calloc(1, sizeof({type_name(ri, 'event')}));")
-        cw.p(f"parse = {op_prefix(ri, 'reply', deref=True)}_parse;")
-        cw.p(f"yarg.rsp_policy = &{ri.struct['reply'].render_name}_nest;")
-        cw.p(f"rsp->free = (void *){op_prefix(ri, 'notify')}_free;")
-        cw.p('break;')
-    cw.p('default:')
-    cw.p('ynl_error_unknown_notification(ys, genlh->cmd);')
-    cw.p('return NULL;')
-    cw.block_end()
-    cw.nl()
-    cw.p('yarg.data = rsp->data;')
-    cw.nl()
-    cw.p(f"err = {cw.nlib.parse_cb_run('parse', '&yarg', True)};")
-    cw.p('if (err < 0)')
-    cw.p('goto err_free;')
-    cw.nl()
-    cw.p('rsp->family = nlh->nlmsg_type;')
-    cw.p('rsp->cmd = genlh->cmd;')
-    cw.p('return rsp;')
-    cw.nl()
-    cw.p('err_free:')
-    cw.p('free(rsp);')
-    cw.p('return NULL;')
-    cw.block_end()
-    cw.nl()
-
-
 def print_req_policy_fwd(cw, struct, ri=None, terminate=True):
     if terminate and ri and kernel_can_gen_family_struct(struct.family):
         return
@@ -2513,10 +2449,6 @@ _C_KW = {
                     print_rsp_type(ri)
                     cw.nl()
                     print_wrapped_type(ri)
-
-            if parsed.has_notifications():
-                cw.p('/* --------------- Common notification parsing --------------- */')
-                print_ntf_parse_prototype(parsed, cw)
             cw.nl()
         else:
             cw.p('/* Enums */')
@@ -2580,11 +2512,6 @@ _C_KW = {
 
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, "event")
                     print_ntf_type_free(ri)
-
-            if parsed.has_notifications():
-                cw.p('/* --------------- Common notification parsing --------------- */')
-                print_ntf_type_parse(parsed, cw, args.mode)
-
             cw.nl()
             render_user_family(parsed, cw, False)
 
-- 
2.40.1


