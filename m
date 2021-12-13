Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857B547377F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhLMWdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242566AbhLMWdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:33:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ACAC0617A1
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:37 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id iq11so12901156pjb.3
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4bkqPa5+Ktpxtos0MYkwoNtsvY+HIiLFlbmVBq0YkWw=;
        b=MBlykbBxOAieabEWRlcUkZ7ADNdkwpOll3kPEPaJbOR9r+t99gWbbKLFIGL6Nfg3EQ
         QNUne00smyhup8NaWJOE76H9nf4zLCERNghqsJEPCYIT0XJ5uYrqT2URRSIBWjZaJtVM
         heygDiET5C8ueggw3nysByIUql8bRYHKAioaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4bkqPa5+Ktpxtos0MYkwoNtsvY+HIiLFlbmVBq0YkWw=;
        b=eBo6y8KpTPuO16OAJ7G6LGiSt7uX/yfoN88xrkVk+2THsBKAe7shic9BMVZHYIYqzt
         B1LUUqq9inadvdr6B23zoCKc68WENPyRh3MnyuLDoxgP5p7H7ZPBDL59QkU6lEfsUL/g
         Sn/x9wMqGjGbJuxTk59aKOoQ9urhvfsxtZCG6TlixVTZNEkB0Q4EAHsY/Wum4KLdoCsT
         doo8BW1NIr3YJQMiSxamjIHnCUx/vOLnSE2YibpHFZZqSSNo4KziC0Y1qpTr1J5er7S/
         92Q/6l1OK9/sTjlRRRN4sof//UNKpV/3/b+kvsx5ggTs+yKxsIAehmNneGrRtYN2xvsD
         kxsQ==
X-Gm-Message-State: AOAM532hxZd2r2m8ldp8VnUQYq6kIcL+5yUM2qMeGxq1E7ta/DBzk/xO
        MhZdZobufTexyIUiDJGCeDGsXA==
X-Google-Smtp-Source: ABdhPJx1qqoV0XGU1WVOFExvUHODI2fWad6Iak6tx3i1lyRZxrGzfPwZ+cJNIeZNRONzKmfiWnOwDA==
X-Received: by 2002:a17:903:2341:b0:142:1b63:98f3 with SMTP id c1-20020a170903234100b001421b6398f3mr1713349plh.49.1639434816842;
        Mon, 13 Dec 2021 14:33:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e7sm14175293pfv.156.2021.12.13.14.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:33:36 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/17] net/mlx5e: Use struct_group() for memcpy() region
Date:   Mon, 13 Dec 2021 14:33:17 -0800
Message-Id: <20211213223331.135412-4-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211213223331.135412-1-keescook@chromium.org>
References: <20211213223331.135412-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2287; h=from:subject; bh=OaTySCpzbualzTuqfaDVo6TEbTw1SrH4/1grMMVMAOU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBht8o3n0yHs835iLP0P72OIiKJhRSEeeeGmdv+JOgE 9MITmIOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbfKNwAKCRCJcvTf3G3AJpaXD/ 9CNj5QslKehgQ8H2nPibxNCF8YU91qx7MKpMxDTDXfrqh36B+W5xXgXY5QGrDtq0SJQAG88pTFS+qT 9gfW91800wi6dElkC925OsUr2olg2LHNnlmqPGnqkelGEymlpNUu6CR2whTRH1NDV8dkb0u8YpyC5L eg7gszBN9zVCfq6zLvzb/JVD1NWwcMW0dQhscxPzf3sGbofM29HuMeZFBh6finNCIA9Zsbz3qc3pkp OxRsBW3oJmUNqY5NZhcMrZonnT0lyZ0/ByGzHYR02KeXYDTSnofZmz9keYy3M2q5uHoSP1cWV/tL5t kCwyI9Pwan8qWhfer0M1QlkUs/oTYw9Ngeu8Q49TmIOa7H/c+It8xdc/JZvPLAFppv2Asc0GELnuHT mFoXDntUx/i4phgnNtgujOg35gvY6Srq19WewjfbINMDYyA9E+d2bm/Sr4qoutnecerI7sPY8R5UOg zlDhia4TLkSLuP0UtktzlS6//YzG5YU2a9+5eDiuVxoJiUnk6Q+djirT8N6zR0xzLubU1tzMtnyV95 WLIlKMI14VJa2A3rJX1p+ayJhzB08l65LaA60C56dI4GdcmZuWIuLTsGblHx+yZy5FPvyV5o5ax1iQ YkaOC/B8NBg5NkIK9+CskK8jVJnQyfq2NRgRWsfqvFGe6zp5dJsTdjoL1Bhg==
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
index 8420fe504927..2be4dd7e90a9 100644
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

