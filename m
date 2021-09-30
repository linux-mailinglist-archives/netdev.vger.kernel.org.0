Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04DC41D8F8
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350578AbhI3Ll1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350546AbhI3LlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:19 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73F3C061770
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s17so20661361edd.8
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GUl3vBWCG+v9Gc/Z+HIfOOWjGV7nOvafJfxxKjlTWA=;
        b=Gfkz6ee/6XkEgg2ig3bdsAWBeNcIjUwwTOI8iP7l8x1c4AhsKycwbBNmGtFf7TamJO
         vApvCJQf9j154A5llvraU948tZhu26miQBvidMv9jMaVCcQQiB1CU/l8z9EnZI0WdStO
         L1P7XrMdXWvl65a3UCfcNEsff2g5wkK8r8eIVV7lbR/ywbcnZ1TjjK34yXQJ9cFM8FYs
         KQVxwzZN6VtytA4CZYVY34OIjpCW9MGQ335Qn1fuKvu7Bm6T3JMDOUmbX+UziA4PFBA/
         Gu1R4fOghdJyqVJGqHuNGnsFNpnlfCV9euted1//0gCPV+Bup4uDDU2iFd2JvCojog+4
         LDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GUl3vBWCG+v9Gc/Z+HIfOOWjGV7nOvafJfxxKjlTWA=;
        b=kN3nMPKLbLQJTlU5gYL/GtKbA3C7A/eRzwIdVjNvFEbR/V8zu5SmeEUq+75rlPEfvf
         Ne0v5wRRRoGvFhfUIEfG5TDGnWGR1WY6Fin56iOdNSI1zPjjGzgcMztVMku3C7SvF5XF
         2cDlOpTvCvJjMdgj/7aZoNKhp4fTik8kAm/4wgmx5eX9S40fcFquAveqXE0+rz03GgVs
         cPDH8qS9NFxwdt2R738SYVStVrpIj1bw6xNorehSRwkmP+E8nHlDLcsUctd5LIWxKk76
         kSoWq4ve6xD4sjW3qDZINPQohOyrnKLKmGaRPpKR5xV6EdVdOwa/mBVUE+GagZJUzE/4
         6tNw==
X-Gm-Message-State: AOAM531CITBuDfAOb7XzAqAaOfY2hNDJcket+AS92h9VfOJrqYADxBYw
        w/BbK0T8zAvw2lWBL/G/KOHzmdZQHbJy8hsH
X-Google-Smtp-Source: ABdhPJxq7Dn/gzmOk0GjmzxanVdl58zr9WLDyfFDWjNuthXhV9zgEYkF2w1zX+vIfp4GZZH0MYqACw==
X-Received: by 2002:a17:906:7811:: with SMTP id u17mr6034720ejm.562.1633001971183;
        Thu, 30 Sep 2021 04:39:31 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:30 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 08/12] ip: nexthop: factor out ipnh_get_id rtnl talk into a helper
Date:   Thu, 30 Sep 2021 14:38:40 +0300
Message-Id: <20210930113844.1829373-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out ipnh_get_id's rtnl talk portion into a separate helper which
will be reused later to retrieve nexthops for caching.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index a589febca605..454c7416e30f 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -485,6 +485,25 @@ static void __print_nexthop_entry(FILE *fp, const char *jsobj,
 	close_json_object();
 }
 
+static int  __ipnh_get_id(struct rtnl_handle *rthp, __u32 nh_id,
+			  struct nlmsghdr **answer)
+{
+	struct {
+		struct nlmsghdr n;
+		struct nhmsg	nhm;
+		char		buf[1024];
+	} req = {
+		.n.nlmsg_len	= NLMSG_LENGTH(sizeof(struct nhmsg)),
+		.n.nlmsg_flags	= NLM_F_REQUEST,
+		.n.nlmsg_type	= RTM_GETNEXTHOP,
+		.nhm.nh_family	= preferred_family,
+	};
+
+	addattr32(&req.n, sizeof(req), NHA_ID, nh_id);
+
+	return rtnl_talk(rthp, &req.n, answer);
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
@@ -827,21 +846,9 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
 static int ipnh_get_id(__u32 id)
 {
-	struct {
-		struct nlmsghdr	n;
-		struct nhmsg	nhm;
-		char		buf[1024];
-	} req = {
-		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct nhmsg)),
-		.n.nlmsg_flags = NLM_F_REQUEST,
-		.n.nlmsg_type  = RTM_GETNEXTHOP,
-		.nhm.nh_family = preferred_family,
-	};
 	struct nlmsghdr *answer;
 
-	addattr32(&req.n, sizeof(req), NHA_ID, id);
-
-	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+	if (__ipnh_get_id(&rth, id, &answer) < 0)
 		return -2;
 
 	new_json_obj(json);
-- 
2.31.1

