Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1612CC06
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 04:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfL3DDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 22:03:48 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32800 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726894AbfL3DDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 22:03:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 1FF284A369;
        Mon, 30 Dec 2019 14:03:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1577675023; bh=ZY58+
        dHzQq2+o/IYWIU3lTJQn6+7YsNoOT7JCX/TkZ4=; b=GnBwQyhXOuBHkD/VWul/k
        DeXKnueVUQlLB+z1jgxUxmtALR4BmjaSEsJrHSIfGl9BSZhJWNuSCKYIiOZmxGv0
        GwaUETjlC3uzprac2JbZuPhEHKXwhn95IfWqBWsdz43wO8xZwVaelDeXE6WO5ory
        SdgnvzdYBqPJ7NQq/CU8Q4=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id alL9OuIdfhGP; Mon, 30 Dec 2019 14:03:43 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id A71854AFB6;
        Mon, 30 Dec 2019 14:03:42 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 0E6214A369;
        Mon, 30 Dec 2019 14:03:40 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     dsahern@gmail.com, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [iproute2] tipc: fix clang warning in tipc/node.c
Date:   Mon, 30 Dec 2019 10:03:33 +0700
Message-Id: <20191230030333.17845-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building tipc with clang, the following warning is found:

tipc
    CC       bearer.o
    CC       cmdl.o
    CC       link.o
    CC       media.o
    CC       misc.o
    CC       msg.o
    CC       nametable.o
    CC       node.o
node.c:182:24: warning: field 'key' with variable sized type 'struct tipc_aead_key' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
                struct tipc_aead_key key;

This commit fixes it by putting the memory area allocated for the user
input key along with the variable-sized 'key' structure in the 'union'
form instead.

Fixes: 24bee3bf9752 ("tipc: add new commands to set TIPC AEAD key")
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 tipc/node.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tipc/node.c b/tipc/node.c
index 6c796bfb..ffdaeaea 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -179,8 +179,10 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 			    struct cmdl *cmdl, void *data)
 {
 	struct {
-		struct tipc_aead_key key;
-		char mem[TIPC_AEAD_KEYLEN_MAX + 1];
+		union {
+			struct tipc_aead_key key;
+			char mem[TIPC_AEAD_KEY_SIZE_MAX];
+		};
 	} input = {};
 	struct opt opts[] = {
 		{ "algname",	OPT_KEYVAL,	NULL },
-- 
2.13.7

