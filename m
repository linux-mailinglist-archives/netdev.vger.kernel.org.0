Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F75B39905
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbfFGWin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbfFGWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:19 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A5AD2089E;
        Fri,  7 Jun 2019 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947099;
        bh=wh63PGozm3piZl4WOI2F2hGTXJdzE6fSQuzQ+CdKI5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMYaOsVcjDcwlvl8kh/47nOR+8pGt0O3pFRqgK5DNCgjEr3tHWTfmvWZ3mIdjuCvV
         xgx21xf81pxiSIc6gTP471+MAYWNlxVoRidm3VMFLwZCdAHtHBQdRwiN847PQ53Ztn
         dF2pRZryx5XEtAERcSclbV4OtFNYX3C/WzDhRPkI=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 02/10] lwtunnel: Pass encap and encap_type attributes to lwt_parse_encap
Date:   Fri,  7 Jun 2019 15:38:08 -0700
Message-Id: <20190607223816.27512-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

lwt_parse_encap currently assumes the encap attribute is RTA_ENCAP
and the type is RTA_ENCAP_TYPE. Change lwt_parse_encap to take these
as input arguments for reuse by nexthop code which has the attributes
as NHA_ENCAP and NHA_ENCAP_TYPE.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ip_common.h        | 3 ++-
 ip/iproute.c          | 6 ++++--
 ip/iproute_lwtunnel.c | 7 ++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index b4aa34a70c92..df279e4f7b9a 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -134,7 +134,8 @@ int bond_parse_xstats(struct link_util *lu, int argc, char **argv);
 int bond_print_xstats(struct nlmsghdr *n, void *arg);
 
 /* iproute_lwtunnel.c */
-int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp);
+int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
+		    int encap_attr, int encap_type_attr);
 void lwt_print_encap(FILE *fp, struct rtattr *encap_type, struct rtattr *encap);
 
 /* iplink_xdp.c */
diff --git a/ip/iproute.c b/ip/iproute.c
index 2b3dcc5dbd53..440b1fc8b413 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -997,7 +997,8 @@ static int parse_one_nh(struct nlmsghdr *n, struct rtmsg *r,
 		} else if (strcmp(*argv, "encap") == 0) {
 			int old_len = rta->rta_len;
 
-			if (lwt_parse_encap(rta, len, &argc, &argv))
+			if (lwt_parse_encap(rta, len, &argc, &argv,
+					    RTA_ENCAP, RTA_ENCAP_TYPE))
 				return -1;
 			rtnh->rtnh_len += rta->rta_len - old_len;
 		} else if (strcmp(*argv, "as") == 0) {
@@ -1416,7 +1417,8 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 			rta->rta_type = RTA_ENCAP;
 			rta->rta_len = RTA_LENGTH(0);
 
-			lwt_parse_encap(rta, sizeof(buf), &argc, &argv);
+			lwt_parse_encap(rta, sizeof(buf), &argc, &argv,
+					RTA_ENCAP, RTA_ENCAP_TYPE);
 
 			if (rta->rta_len > RTA_LENGTH(0))
 				addraw_l(&req.n, 1024
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 03217b8f08f8..60f34a32a6e5 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -1111,7 +1111,8 @@ static int parse_encap_bpf(struct rtattr *rta, size_t len, int *argcp,
 	return 0;
 }
 
-int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp)
+int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
+		    int encap_attr, int encap_type_attr)
 {
 	struct rtattr *nest;
 	int argc = *argcp;
@@ -1131,7 +1132,7 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp)
 		exit(-1);
 	}
 
-	nest = rta_nest(rta, len, RTA_ENCAP);
+	nest = rta_nest(rta, len, encap_attr);
 	switch (type) {
 	case LWTUNNEL_ENCAP_MPLS:
 		ret = parse_encap_mpls(rta, len, &argc, &argv);
@@ -1164,7 +1165,7 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp)
 
 	rta_nest_end(rta, nest);
 
-	ret = rta_addattr16(rta, len, RTA_ENCAP_TYPE, type);
+	ret = rta_addattr16(rta, len, encap_type_attr, type);
 
 	*argcp = argc;
 	*argvp = argv;
-- 
2.11.0

