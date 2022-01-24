Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76F9498683
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbiAXRWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbiAXRWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:22:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F30C061744
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:22:44 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id l17so10003728plg.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrF7wrhR/r11uhM1Zd7BV21fovtaCNxXQvw8C85WbLY=;
        b=GLBFXmuYlThw8gVudTodEivYKQS9SKar/0ZJSgx9vZ2jV0i1C2mAs9UMhy+CDEzy5d
         IFZTJOCLmtmr4tACBXyGpVkTCutTOkPjFKFsiXQuW10B7yMTisNiToMK0lgAYfmQGU2o
         x5zzA/bx0jdyqosLimsGRim5t9m/10nNbO/oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MrF7wrhR/r11uhM1Zd7BV21fovtaCNxXQvw8C85WbLY=;
        b=y4yHOekwVVC9GnMk23Qki+aWqi+90CURctOADPvKmoMG9pw+lPBiF8iCcH8gTB+Kjx
         t7iAZa0IcDZzbxZVqwe9vXQvqtC8ZrlrGo4hAg58S6HKnEDluH0r9oBuM1rmD74kthsh
         uPhkrGDt3CpjJ4tlr7j83eS+vBF2OkXe6Fzr70GHpJ4dEHLQb2KfQrP6IvTyR/5CSBr1
         MDGiJ/6bZtqTP2G3JLQi+oIlLjBk6HVhMfeZkX4dKjHjb0x5RU+4KAfYrX4CQ3G/bRQ5
         CTPZz/2u8LpM7CUuzPyZzVBl4XJfXrYoJrrBVOxw2vi2p2GDULrqaXfvto6HukK4t74h
         7/yQ==
X-Gm-Message-State: AOAM531opbGZ8lZoRkCAL9BCPXECqPeF1Fdq7BXy+ysAhjLE6/ttcIg0
        KUdRNqBwdASecyd/0b6cxcncAw==
X-Google-Smtp-Source: ABdhPJzrcJk7jTA+I8Ws2u0wMgyvDme0Vzcmms3hN2SNCAdRMMOG6NzZq8hGBo8rxEKZTG9pux+DpQ==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr2879344pjb.147.1643044963893;
        Mon, 24 Jan 2022 09:22:43 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id om12sm8581896pjb.48.2022.01.24.09.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:22:43 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND] net/mlx5e: Use struct_group() for memcpy() region
Date:   Mon, 24 Jan 2022 09:22:41 -0800
Message-Id: <20220124172242.2410996-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2499; h=from:subject; bh=1Hy/h6xR6CfzT4qu6mjl1eEfD5rBqmasVCiGJ8yfoaE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh7uBhn8A0lQDkjRJO9V5Sl0KNR5PpwAX0g9yKG64U XkTagiOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYe7gYQAKCRCJcvTf3G3AJrh+D/ 9XD/78mqJDQUOAqNi51dHFcJMTBtQW/5SOOscaza/hl+yTU06iM1xjcDFcsLZb7jaJ4KYcV/EZAnXv l73wUOrNTN38IgVBXoE6OMtjQHaJwjcbzEhxfcnx3ncVKWRelfg1Wcz3UCHgAp621U13ng7iIXtQFg JKnUuwTjUH8vLpNlDdzLwHJqxN7wWA/+r3YU5GGTsWbTGlUZSs4+TPUzhcF48K1Wx5gsWUUBD9lFg5 5oWex5SYi2l7himxmjllot0E3lyw9ot26ak3oWLfRQqqOUet5u4UhWbA1ZBkD6gys1OziqKY2YDzdA L/GNU45qVkr8K5864876AiJ2cFYIFEMng2G2M8xkgH2Pcj0aECmYo+BXt/WC4R5aNKGUbre0I77CKl uCiIH3lTD5mLBNIxe58Lr9ekNwdedX+uNPiZo96/OH0SKqmfp30VohtJJFlB3gauX/slbX9ONDffMR jtuYoEIwR5ODB0gsr3Rku7j/b0nYxJs80sAziKrtJTrlb9tk7RSlanVomFiTGvHxQoI8E8uiRogOG7 7u6sCJqdnF9kLjGpEkjPyi47V741Xkyly/jqjpTJjHzxQHSFinFisqz41YE2HEoINtxxy8kF6n2Rpy +uF1HuWJz6ebx3q5MGvBrhW3cnyzxgaMa1O85G0cJqOg8sujaw7WJe0sV8wQ==
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
Since this results in no binary differences, I will carry this in my tree
unless someone else wants to pick it up. It's one of the last remaining
clean-ups needed for the next step in memcpy() hardening.
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

