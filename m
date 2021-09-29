Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC041C86C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345310AbhI2Pbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345324AbhI2Pbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:39 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC0BC061768
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x7so9944687edd.6
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e/qdt6GablJU0aPRCNH1n0DMgmQ27KxA9ufJVcdULMM=;
        b=a+/6vlJnjJqHl24+ccRSgF169VZmQ5c7oynx47AOxZXCpK65qpZ5+OodvGwpgj2TVW
         3jRQPoRcz6OTW3td7vmnvPDK91lh/pq2wC3HgM28EvIJRRAQprUw62x7YQr7voSBfB1p
         x16VqJdIRPZLMTRPRmprIU3w4xspToFFMMBYmtemlw+xA4SGMbvMnKSPKV0opuPnVR7N
         Lg7JzosFm5as9JigVO22PN/uJjJG0xW19RO+yb6x60OfsDpeM1G/zK6r0F29ftYQsoRh
         WMay1X62qYQHnfkKYBVq4EKUwHhIP9yWhCbGkrSlGs2qD7PPyu4TksDZyLGv2GjcU3tG
         aO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e/qdt6GablJU0aPRCNH1n0DMgmQ27KxA9ufJVcdULMM=;
        b=ZNj3yyUYrDsi99k+/Sirl9iQJxuIkAuURNUoDotHGH5uh6smi2d+aRHZdDFrVb3NcX
         h0U/cZRQftd/sxHq77xZ7feTTLm3Bc4B58EhRPJ0n4EU58qFq+X7xnEbfzS3pOo0Raqq
         zjKsGrt2/EELRWcPfPVDegIV8JlNNFziDfs7KriyqbCa+nohIm/idjgipEsxx0TbYj8D
         5ENIyN2ZEzYT2iZGHzVp7I/7PfmY088x+rnA/imHgVuBL1NZlRdOqTgtyo8WVZ9n4Z+6
         mVezhXtZcNSpfIYid6gJPiCK48Tw2ipGH5HlI5BL41r1f1l6MRCqaUGfmWzc0g9mgXLE
         jn1A==
X-Gm-Message-State: AOAM530My+ZT9n6d5Ap52UkD1XSzTOPFX5VDeezDVP5+jyDA/T1z/uH2
        hdRqrM6pYg/hTLngvxzlWgISygF90bo13Zia
X-Google-Smtp-Source: ABdhPJykH7z4Ri1n0bTqSrPG2811HKmOZ3P7liIcPcsyvk00IV5wxbSswCbzrIuOcFCh4PvRc5B5zw==
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr339573ejs.31.1632929339168;
        Wed, 29 Sep 2021 08:28:59 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:58 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 06/11] ip: nexthop: pull ipnh_get_id rtnl talk into a helper
Date:   Wed, 29 Sep 2021 18:28:43 +0300
Message-Id: <20210929152848.1710552-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Pull ipnh_get_id's rtnl talk portion into a separate helper which will
be reused later to retrieve nexthops for caching.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index e334b852aa55..0a08230fc278 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -431,6 +431,25 @@ out_err:
 	return err;
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
@@ -820,21 +839,9 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
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

