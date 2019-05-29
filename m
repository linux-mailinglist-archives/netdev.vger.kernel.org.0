Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24CD12E001
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfE2OmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:42:15 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:33907 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfE2OmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:42:14 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 0336F2C0E0E;
        Wed, 29 May 2019 16:42:12 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hVzmN-0002UU-MY; Wed, 29 May 2019 16:42:11 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2] iplink: don't try to get ll addr len when creating an iface
Date:   Wed, 29 May 2019 16:42:10 +0200
Message-Id: <20190529144210.9501-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528122554.0f7dda5a@hermes.lan>
References: <20190528122554.0f7dda5a@hermes.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will obviously fail. This is a follow up of the commit
757837230a65 ("lib: suppress error msg when filling the cache").

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/iplink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 7952cb2be364..d275efa9d087 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -945,7 +945,8 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	else if (!strcmp(name, dev))
 		name = dev;
 
-	if (dev && addr_len) {
+	if (dev && addr_len &&
+	    !(req->n.nlmsg_flags & NLM_F_CREATE)) {
 		int halen = nl_get_ll_addr_len(dev);
 
 		if (halen >= 0 && halen != addr_len) {
-- 
2.21.0

