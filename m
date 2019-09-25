Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E9EBE4AA
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 20:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443203AbfIYSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 14:35:06 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34879 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437947AbfIYSfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 14:35:06 -0400
Received: by mail-io1-f66.google.com with SMTP id q10so1457929iop.2;
        Wed, 25 Sep 2019 11:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v3DzaPxPuk/uVGB+4m0xoPcXgoLZaM/MWTm8Lgl62ag=;
        b=aJxL4fMpDIM7jgZ2K/qGuVvA5sWslCPjnVJc/5+EtvVKXOPJ01cveWWY2415BRxAQX
         lR2FKU3c2xmEF2jlzGUtvI5Polpbal+IrYiia1qGJ/x5Yd9NoTOK3Lhwyvi0dbcPX0vu
         O851qKOgLq44HPt0Uagm5j5OneFStMYFAUme6QCm55woKogXozd9GCoZC/vN/6Widryu
         6dDDDbRFDzs60kxVzO5AYcrF/x1/tcFqjSOi5PGYY8nyDCWxstTYhOVWJrpinwoVjsUl
         GkVICdtoM4FXLBQx0fYtZ8Ag4xaTZiOwqFppP3Ty4Mqzv+viY4VJXb5ZJu7KB6nuYOYQ
         S2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v3DzaPxPuk/uVGB+4m0xoPcXgoLZaM/MWTm8Lgl62ag=;
        b=H0akTTtCJjIPsJ+ORFUff3O/P/V8qSY1PKcT0Ws7+oBELxHqixTH3RZHBymIqF7d/v
         +yekjVUvOn3D4xY3Zo3gBx+gHHVwgYzbWUnjITrxTs08ErGLgbIuK3ZnR+LLKQxPKx+v
         z6XvI64AxHc9NKuSz9PGUtq6wsKw2SCgKlkYN89EqbxM1WLNt/YmBeUBlV8hsX0nxImj
         X6zsiV2BBf1++wFJG60koKhACIkmJw3z/g62L/VREo/ByTn0iHXH9zeT6UGqegYvMmbC
         Eh6wNnLV1WXtRgEox5FpQZ+VR2mRw8SSxKV5E3m96TjRww1aH4KEddGTinK2Yz0wsWh1
         /vVA==
X-Gm-Message-State: APjAAAUWiBZxShRHd6QlwlzwDS93G9ntrRFxsREK6dxNH5LU1Gi/HKPN
        LRf4QN802bTAdAXxNOMC4k8=
X-Google-Smtp-Source: APXvYqwQoB8gfyzeqzfIhdMNfNYKCtxpPHu38RGSqgT11KRqp/QGd/dafditqifhCVFBYt7sd1nJZw==
X-Received: by 2002:a6b:3705:: with SMTP id e5mr759624ioa.213.1569436505411;
        Wed, 25 Sep 2019 11:35:05 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id w68sm340159ili.59.2019.09.25.11.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 11:35:04 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Colin Ian King <colin.king@canonical.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: flow_offload: fix memory leak in nfp_abm_u32_knode_replace
Date:   Wed, 25 Sep 2019 13:34:46 -0500
Message-Id: <20190925183457.32695-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nfp_abm_u32_knode_replace if the allocation for match fails it should
go to the error handling instead of returning.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 23ebddfb9532..32eaab99d96c 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -174,7 +174,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	struct nfp_abm_u32_match *match = NULL, *iter;
 	unsigned int tos_off;
 	u8 mask, val;
-	int err;
+	int err, ret = -EOPNOTSUPP;
 
 	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
 		goto err_delete;
@@ -204,8 +204,11 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match)
-			return -ENOMEM;
+		if (!match) {
+			ret = -ENOMEM;
+			goto err_delete;
+		}
+
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -221,7 +224,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return -EOPNOTSUPP;
+	return ret;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.17.1

