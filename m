Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215BE1975C2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgC3HdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:33:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:39122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgC3HdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:33:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB3BDAD3C;
        Mon, 30 Mar 2020 07:33:06 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CC634E0FC6; Mon, 30 Mar 2020 09:33:05 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] netlink: show netlink error even without extack
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Message-Id: <20200330073305.CC634E0FC6@unicorn.suse.cz>
Date:   Mon, 30 Mar 2020 09:33:05 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if the NLMSG_ERROR message has no extack (NLM_F_ACK_TLVS not set, i.e.
no error/warning message and bad attribute offset), we still want to
display the error code (unless suppressed) and, if pretty printing is
enabled, the embedded client message (if present).

Fixes: 50efb3cdd2bb ("netlink: netlink socket wrapper and helpers")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/nlsock.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index 22abb68b6646..2c760b770ec5 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -173,25 +173,25 @@ static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
 {
 	const struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(tb);
+	unsigned int err_offset = 0;
 	unsigned int tlv_offset;
 	struct nlmsgerr *nlerr;
 	bool silent;
 
-	if (len < NLMSG_HDRLEN + sizeof(*nlerr))
+	if ((len < NLMSG_HDRLEN + sizeof(*nlerr)) || (len < nlhdr->nlmsg_len))
 		return -EFAULT;
 	nlerr = mnl_nlmsg_get_payload(nlhdr);
-	silent = (!(nlhdr->nlmsg_flags & NLM_F_ACK_TLVS) ||
-		  suppress_nlerr >= 2 ||
-		  (suppress_nlerr && nlerr->error == -EOPNOTSUPP));
-	if (silent)
-		goto out;
+	silent = suppress_nlerr >= 2 ||
+		(suppress_nlerr && nlerr->error == -EOPNOTSUPP);
+	if (silent || !(nlhdr->nlmsg_flags & NLM_F_ACK_TLVS))
+		goto tlv_done;
 
 	tlv_offset = sizeof(*nlerr);
 	if (!(nlhdr->nlmsg_flags & NLM_F_CAPPED))
 		tlv_offset += MNL_ALIGN(mnl_nlmsg_get_payload_len(&nlerr->msg));
-
 	if (mnl_attr_parse(nlhdr, tlv_offset, attr_cb, &tb_info) < 0)
-		goto out;
+		goto tlv_done;
+
 	if (tb[NLMSGERR_ATTR_MSG]) {
 		const char *msg = mnl_attr_get_str(tb[NLMSGERR_ATTR_MSG]);
 
@@ -202,24 +202,21 @@ static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
 				mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]));
 		fputc('\n', stderr);
 	}
+	if (tb[NLMSGERR_ATTR_OFFS])
+		err_offset = mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]);
 
-	if (nlerr->error && pretty) {
-		unsigned int err_offset = 0;
-
-		if (tb[NLMSGERR_ATTR_OFFS])
-			err_offset = mnl_attr_get_u32(tb[NLMSGERR_ATTR_OFFS]);
+tlv_done:
+	if (nlerr->error && !silent) {
+		errno = -nlerr->error;
+		perror("netlink error");
+	}
+	if (pretty && !(nlhdr->nlmsg_flags & NLM_F_CAPPED) &&
+	    nlhdr->nlmsg_len >= NLMSG_HDRLEN + nlerr->msg.nlmsg_len) {
 		fprintf(stderr, "offending message%s:\n",
 			err_offset ? " and attribute" : "");
 		pretty_print_genlmsg(&nlerr->msg, ethnl_umsg_desc,
 				     ethnl_umsg_n_desc, err_offset);
 	}
-
-out:
-	if (nlerr->error) {
-		errno = -nlerr->error;
-		if (!silent)
-			perror("netlink error");
-	}
 	return nlerr->error;
 }
 
-- 
2.26.0

