Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BCF181B64
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgCKOe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:34:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59583 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729909AbgCKOeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:34:06 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Mar 2020 16:34:00 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02BEXxtX016507;
        Wed, 11 Mar 2020 16:34:00 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v3 11/15] flow_offload: Add flow_match_ct to get rule ct match
Date:   Wed, 11 Mar 2020 16:33:54 +0200
Message-Id: <1583937238-21511-12-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add relevant getter for ct info dissector.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index ceaa362..efd8d47 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -69,6 +69,10 @@ struct flow_match_enc_opts {
 	struct flow_dissector_key_enc_opts *key, *mask;
 };
 
+struct flow_match_ct {
+	struct flow_dissector_key_ct *key, *mask;
+};
+
 struct flow_rule;
 
 void flow_rule_match_meta(const struct flow_rule *rule,
@@ -111,6 +115,8 @@ void flow_rule_match_enc_keyid(const struct flow_rule *rule,
 			       struct flow_match_enc_keyid *out);
 void flow_rule_match_enc_opts(const struct flow_rule *rule,
 			      struct flow_match_enc_opts *out);
+void flow_rule_match_ct(const struct flow_rule *rule,
+			struct flow_match_ct *out);
 
 enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index d213482..7440e61 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -188,6 +188,13 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie)
 }
 EXPORT_SYMBOL(flow_action_cookie_destroy);
 
+void flow_rule_match_ct(const struct flow_rule *rule,
+			struct flow_match_ct *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CT, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ct);
+
 struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
-- 
1.8.3.1

