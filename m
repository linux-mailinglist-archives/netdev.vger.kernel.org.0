Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B93BFCE8
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 03:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfI0BwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 21:52:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39278 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfI0BwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 21:52:08 -0400
Received: by mail-io1-f66.google.com with SMTP id a1so12111762ioc.6;
        Thu, 26 Sep 2019 18:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0mnfnduo3WaAYfJZM37BmRq9LvcMXeRseStmPj2NNbk=;
        b=Bu5RJbp/JOxqBNp8gv1mEPkiY9VovTKQxyIMAkwpn3qpXV/ox1R26SEIrMzYFN3Cv2
         qi8ucXKCi/8rx0rPOqkh6Ui7h+mxMyVFcYt4AABYkhLUa2HK1kyOmRN1tFb+oSYtJKYL
         pQRP/oRDeQ51zYSQWP7LEJ6UxirZ71ABGVSTuBoPRGFSbNvketODQTSdfGPQNwhK192B
         JPyCH7JUWMJ51dDiKrXypOij1p610sKgrBHt0A4XqX4dZlCEU4SECQycSgJP1gIcJapY
         ksCrqlU+lQLt78sHQoucGblPR5ifQxnYHtNkXwNqFWEIf6H1/98Hr/FGJDyil8BjhYGd
         wkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0mnfnduo3WaAYfJZM37BmRq9LvcMXeRseStmPj2NNbk=;
        b=W7HmEK2RVpH6cN7zRqtmB45bltlOi6rOK8NHGiiYO25J3I6cBrTMqcJR6oaboUj8WC
         M9tcFoS4qv4KggOraQHuKyl75iFD8tCBLGHfodrfiisHWEM8p2iMUTm/iB/y9+p37gj5
         QT+20TUPmJ6skzLtoPzzLKKYOtfuep7JjuEpPjvJfoureuvm0b/HUAyRXVahhHKd8mK8
         zoTTvMeka3GuvEYt/JfY5DNjvcPL5GNduwnF1zZcnBUA+F9i6NJWio+htq0aHYORh+lq
         WSmjdPeUrGHEVbxvlv2FQlQMT69vKMxHQ31CEkrBiki1nFEWj4H9BbxXa+dgaetfCrgx
         UBaA==
X-Gm-Message-State: APjAAAVLajlmfwsrkTwpcOm9qj4WAtaCJUBPiRD0BynSr89Bl43l4Zj6
        uJaFBMyJXbxA2LvyrjTRmS8=
X-Google-Smtp-Source: APXvYqy+rN1/ux+U25EmNgyXW8/fMROok9x0/ruMeK/UJ3GaDhJcZM2OgPbd4JPaKcrBR2Y/FCu39g==
X-Received: by 2002:a92:6c01:: with SMTP id h1mr2192718ilc.107.1569549127293;
        Thu, 26 Sep 2019 18:52:07 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id c8sm612869ile.9.2019.09.26.18.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 18:52:06 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     jakub.kicinski@netronome.com
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        John Hurley <john.hurley@netronome.com>,
        Colin Ian King <colin.king@canonical.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] nfp: abm: fix memory leak in nfp_abm_u32_knode_replace
Date:   Thu, 26 Sep 2019 20:51:46 -0500
Message-Id: <20190927015157.20070-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190925215314.10cf291d@cakuba.netronome.com>
References: <20190925215314.10cf291d@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nfp_abm_u32_knode_replace if the allocation for match fails it should
go to the error handling instead of returning. Updated other gotos to
have correct errno returned, too.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
Changes in v2:
	- Reused err variable for erorr value returning.
Changes in v3:
	- Fix the err value in the first goto, and fix subject prefix.
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 23ebddfb9532..9f8a1f69c0c4 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -176,8 +176,10 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	u8 mask, val;
 	int err;
 
-	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
+	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
+		err = -EOPNOTSUPP;
 		goto err_delete;
+	}
 
 	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
 
@@ -198,14 +200,18 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 		if ((iter->val & cmask) == (val & cmask) &&
 		    iter->band != knode->res->classid) {
 			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
+			err = -EOPNOTSUPP;
 			goto err_delete;
 		}
 	}
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match)
-			return -ENOMEM;
+		if (!match) {
+			err = -ENOMEM;
+			goto err_delete;
+		}
+
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -221,7 +227,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.17.1

