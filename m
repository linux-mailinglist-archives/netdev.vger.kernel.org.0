Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7135E456284
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhKRSkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbhKRSkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:40:51 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5340C061748
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:37:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so6887107pfc.12
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmolre7Okhy+2RfWXyND/uy2w4i4I9jFJ+ihj69aXDA=;
        b=H2VVy+98VZb3T/nxecceRPaS4zE5Oz+cewzsaZHfm9eEsv3XRjc+DZ9njtbvTiIV9v
         J3uSabI9Zn1CjpwWGCCmAjBS+t2u97WQlEQMjNpnEkhOLklQ8XH185Q78ublW5dzZJwg
         7NXk/C4Z7m2WT6IK7nQoYb89NQ/9+XXt5CJ1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hmolre7Okhy+2RfWXyND/uy2w4i4I9jFJ+ihj69aXDA=;
        b=qnDP9/Sc+mOhgBbiZRc8V1atpmTNCAftpf0um+SBF3b7OJSONMwTh2IkXK0ZJNUsc4
         jMWDFCbegC1QUFKqgx2YMGIceXP0ktNIk5LwGDNUnBqlOHy5jXy/5CWqh1PEc3hzcM7P
         rMI9UTzvfEQdKjAjDMcgjk0J+24O4DvvF8CCA7+gxHQWn+JFW75b+6qJ6ZVbYArltTGL
         M1IUgoQ8g/G5FkhrhEAQt54v+arJ8m/4pm4QzZC7vOdOm77/uriWS7bRfIdoMQSDy2t2
         TzBpmUybJN2Nt8+G8trwjwBb5dxVtmlUc8EujPPv2bUxig+hH7gRE44iSwem6/0ltUq/
         f8eA==
X-Gm-Message-State: AOAM531YFL6Mv2Ibp3QI5ZotJ91t4NfDPRe5Akca4LG0G50B76utqgjN
        uRHjjH2g5oVb/BwEbEm1F3agvg==
X-Google-Smtp-Source: ABdhPJyGMYhMNijolBn3fPZucIoXtbuuMs7SP0RN0sabR7T56FvS5htc77aeK768uABZmy/8W3JFMA==
X-Received: by 2002:a63:e214:: with SMTP id q20mr12662707pgh.442.1637260670241;
        Thu, 18 Nov 2021 10:37:50 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v10sm313376pfg.162.2021.11.18.10.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:37:49 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net/mlx5e: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:37:48 -0800
Message-Id: <20211118183748.1283069-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2065; h=from:subject; bh=5h1/OCbcMC9fSZGebngnGdh+E0sfjUIlmjyL7n2bbX0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp171Vyvp59PAA8HQAbsKsvjRM9PHtYPsKBL4acu CDa8lw+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZadewAKCRCJcvTf3G3AJjJyD/ 4nVg1irFelKvdZ02Th2MFSO4WzpimbnUZGifMbJ9L4pb52/n77LB3drjD6NSKlGtEaFlVyvNB/q0RH +t/6kzu/hCv25FLpy+J6YbtieBUc8Z7Kg7lW8weJX68+CWq+x3l0WyLhvkf9HlFZYWmrJBvC3AC6x5 dI0QXV4svrZEPVbYXsPfvAzX+4EDWdU9s7zA09cEH/a9lZdqyBvDoDQiTEEColX1wlqh13LZ3/n0Zq XOB4CCOqJCMlVnO9zINDvQYcH54PDqtqs4V9c9oZMVHbbyqELLtqCye3Ro0gFCi84RQ9pBtgBS+VDy mznZ3n6bPNcfnTfsA1Dihx8wWa6thbBI5S86q35YSkZxyiUnTU45jLBdYBhVE4I1oXDAVq/LpKYGv6 sgtYOkpjTGovnUhqboAgs8hfQQmAiZzzzKPq+86NsanzBWMWd3maqAMUNHYJPdJaqA6Uibnjke/1UI S5rQgcUS7i6Hbe3b2xk9hPo847RY/mh+MSUZHI4DPJAtgX0uxEfcLKoTZsGJFL+Qbe/MnmV8mTQ1RP 2oyRGggP9SLnZ1SNPIbbNbkpVYjgfgvMFseD5DfdK7/VdtmUkgFcwOc6uk6dy/cJF3dDOzAnHEhi1+ LbRyBwkAWgx7RJYydaCeTzzcKygH91nEK0WjuQja6ADP01c168owKfL4arnQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct vlan_ethhdr around members h_dest and
h_source, so they can be referenced together. This will allow memcpy()
and sizeof() to more easily reason about sizes, improve readability,
and avoid future warnings about writing beyond the end of h_dest.

"pahole" shows no size nor member offset changes to struct vlan_ethhdr.
"objdump -d" shows no object code changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 include/linux/if_vlan.h                         | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7fd33b356cc8..ee7ecb88adc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -208,7 +208,7 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	int cpy1_sz = 2 * ETH_ALEN;
 	int cpy2_sz = ihs - cpy1_sz;
 
-	memcpy(vhdr, skb->data, cpy1_sz);
+	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
 	vhdr->h_vlan_proto = skb->vlan_proto;
 	vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 41a518336673..45aad461aa34 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -46,8 +46,10 @@ struct vlan_hdr {
  *	@h_vlan_encapsulated_proto: packet type ID or len
  */
 struct vlan_ethhdr {
-	unsigned char	h_dest[ETH_ALEN];
-	unsigned char	h_source[ETH_ALEN];
+	struct_group(addrs,
+		unsigned char	h_dest[ETH_ALEN];
+		unsigned char	h_source[ETH_ALEN];
+	);
 	__be16		h_vlan_proto;
 	__be16		h_vlan_TCI;
 	__be16		h_vlan_encapsulated_proto;
-- 
2.30.2

