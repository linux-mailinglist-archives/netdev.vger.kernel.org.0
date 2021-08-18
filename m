Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4853EFC7B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbhHRGZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbhHRGY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9850DC0611C2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:18 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m26so1104842pff.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cNmalVG+pbxPr3mreA9zKEEd2H4tBC2vGc39RgbA9Tk=;
        b=T0mB0uwkd+Bwr8IQl/3YD/ORZ/h6GcZHHAfw4qTPS7nphYkQehERGSWj59cSMbAgzk
         KKR0vMG5a88SolHec9ej2zYoy9ZdaOnCLwqfmIhA/oS2OWR89diIyEBz4j3SQO5zhg8O
         FN6UWEuMg4e4CXhSW8Hsl565xQ91qeHwCgvM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cNmalVG+pbxPr3mreA9zKEEd2H4tBC2vGc39RgbA9Tk=;
        b=c+5STsN4GFwnAWU5tfZ7SaohmnkEwbPTKsSb/owAqnOGw/X+0MvIEk2SAwFlE3M6lM
         LS8NgzlHFFFfN3HgxrZ6kYLtJ9btM+9J1eXhpjghZSznT5vw09w3U0ymi+UZkndWH+db
         GAvEQVDwX9Itv6P3D/mmx/tuRpSwBin3opzNdJoKVaokCDU491Od+N1fkg62KIiA6gON
         rmC8yvwLZhjlKXfgvSMhAjX6vEye3YCkQuTEstLKHxxe9kPk6Pn8akLj4HsBfrYpHaea
         nbStIi28K80Bbr20drwhCFEMLY4c++yJTN5q9p0z++VTInJ5ItYP/z2z9h1psjxiPbs6
         D2qA==
X-Gm-Message-State: AOAM533Hc8T8uktmdTScjuko+jxIy8bl5VDpqJ/dROeabnXnp6RvbcbD
        o1DGuPyMWxqmQ+45O7d/oA287A==
X-Google-Smtp-Source: ABdhPJzoElJdRbLlcznm9p1v4fqVMxPQQbVFbTyyeunVo+q1c4LPSW+dleh3870/C7uQRKu+J9kAIA==
X-Received: by 2002:aa7:82cf:0:b029:3c4:4daa:fd68 with SMTP id f15-20020aa782cf0000b02903c44daafd68mr7700665pfn.66.1629267858224;
        Tue, 17 Aug 2021 23:24:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 64sm4749129pfy.114.2021.08.17.23.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 21/63] net/mlx5e: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:51 -0700
Message-Id: <20210818060533.3569517-22-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2287; h=from:subject; bh=H1NJrCbG/+gkFDDOH1HKv+jRsuxCwz9I+sItTuJPxig=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMie0CZ8QknrFWsSjQNv2Z5IJELFExqf7lN7Wwc 5aQQO+qJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIgAKCRCJcvTf3G3AJhJRD/ 96K2w+o05X7hhRITOYKyJKbH37CP3Ty7ALSuqaRioqi5222xg1OlnDlOmTcxm36KPLSYb9gNOPa98l 7az22zZD/h+540iMnPR/nKUQpztke9KGCWfI6q0E264noieiOeBk645rAPlBm4GwcsyT0YYPKqC1ZQ UTpt6I53LSvfaDvqvAqf+r8OlgAEKrvseNyt6qPuA13XUHguBBpovSDddi8OEqv/t5Q2wj7UEMmW9J IV+m0C3UpQKXOeOhTy23oZX7PjawKd6/ah6FLBqp6AKcedGBTDdkEtjHbu8o9trfR1W1JUsvMCcv9S 8dO2gsGyuF0n5SykLaKxqeSKyvE8fjXBmALhef7xIECWwU3oMeXXcDnEKC00an8WKoTI/p3sdBuwGx hjBgHLa6fYkRSNX07ZrUHUpURPOef9SB6ijFamo9WBDRCJqk7AaNFp4cIkmEoupJpZdmr/Cm7s7jzG oQUq+6Tbv7TkwMP3GX9S0UgzY5hbFKCx8+nqIQ8qQxp/nmFHZZ9/B1u/uzYcV0mZ0Z2HD8SsYnTNtT +36VQ5kEs/5D+CCjDnJyxpY0zbiwB11VKD/JrZ8xY1p1Y4YjDHvtOjkykedRvOU0ltxWDBDoGf26q8 mtK38NkfvvezjBrpRzYDrxRYSxWAIcOs6jVAkBvNvKCrsZueeLXchKsyUi4w==
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

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 include/linux/if_vlan.h                         | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c63d78eda606..39942a952736 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -207,7 +207,7 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
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

