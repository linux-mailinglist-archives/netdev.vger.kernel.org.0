Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFF86B7BE2
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCMP0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjCMP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:26:10 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E538738AD;
        Mon, 13 Mar 2023 08:26:09 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r15so23045231edq.11;
        Mon, 13 Mar 2023 08:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678721168;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XWmAvvzIaj+fG7Rg9Q86D9Tl4E6XEpeVkapJAMD/lz0=;
        b=kIybAxQr6SVwobe6za/ts9gldrmpmK6gTeWeFtTsxkOMMszZqOL72aCF2O6Admf8yZ
         vFJdTOOKRfHUf2N6ZZMxmZ034sopD6a4COcUOgezxwKw8Ptegt2puglonlux7yFm1e4o
         f9rQYbRD96xoKDLxq7mF8O0tTmCT6wg0iPzbsmCOOVgD5gfSv3WV5+zpFqvAkm8noNii
         v1ZzJmGTi8lxTvN/6bP/tJTUTsEiiXQ5rsBmoHhGyT34IHKIkxAriL0ol1IcW9/GGRL1
         aEMacMAVSWmf+9KoOioqt93RKDTFU/wI45PURRygxdre08zBj8XoGrl7ZdWdnF1ySGKz
         h1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678721168;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWmAvvzIaj+fG7Rg9Q86D9Tl4E6XEpeVkapJAMD/lz0=;
        b=EjchwO02682Zps44yHD5FvwQjr7jphSrs2h7yStmu1EM3g8jBl8gEgUV0HdwfraW/A
         ySgDrpbbdNXXzd8b8QzPUszpDwlojnlMjl1e5KH9l5dcgoegLKH061qK6v74WE6tlDpk
         6yg86ZhGs0Hl30rmj4Brq840hDNNIWsFJQ0nezdHxgyOdlyfI0XWLrpctBxUVWNQK6J1
         zcGOTmKmsAuNg/Zu0ArfVLoga3H3tMaEi3ptAQqjVyohSwNmvJgEMU6DGVIa1igfJA0K
         LApqjyLn0BS8RJqdNs3ZELLsG8PvUXKD90RO+PVPEDllokQptnvu/FdxvzpfTeHonFXC
         us6A==
X-Gm-Message-State: AO0yUKXKuqy0VLU/J423DF0r78dbWGOA/h9I/ZtseMjJ/+5YKM716ge7
        5G4nBor6z2GM8XSRyOar/Yc=
X-Google-Smtp-Source: AK7set8nBFc1Bk6vR83U4pL957AeBmWH2Nnx9upezQHhqS7XP80DKU5DbM2Gj/4SKqT8WDCbRxRbsw==
X-Received: by 2002:a05:6402:10c9:b0:4f9:9be3:a538 with SMTP id p9-20020a05640210c900b004f99be3a538mr9253162edu.13.1678721168019;
        Mon, 13 Mar 2023 08:26:08 -0700 (PDT)
Received: from [127.0.1.1] (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id t7-20020a50ab47000000b004cbe45d2db5sm3368542edc.37.2023.03.13.08.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 08:26:07 -0700 (PDT)
From:   Jakob Koschel <jkl820.git@gmail.com>
Date:   Mon, 13 Mar 2023 16:26:02 +0100
Subject: [PATCH net-next] net/mlx5e: avoid usage of list iterator after
 loop
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230301-net-mlx5e-avoid-iter-after-loop-v1-1-064c0e9b1505@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIlAD2QC/x2NwQrDIBBEfyXsuQtqsKX9ldLDRjfNQqJBJQgh/
 17tZeAxw5sTMifhDK/hhMSHZImhgb4N4BYKX0bxjcEoM6pRaQxccFurZaQjikcpnJDmnmuMO3r
 njLbmYel5h2aZKDNOiYJbumej3Ka92BPPUv/Xb+jWwLXA57p+CIuhmJQAAAA=
To:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1678721167; l=2620;
 i=jkl820.git@gmail.com; s=20230112; h=from:subject:message-id;
 bh=7hx1Ap6Bz46HbdFy4hhYs3nMeaJ1NFd5S1bbeyxsAMw=;
 b=hqm47LUPgcsiFLe9goJGNc79z3a1g8ZFflgWjwg4Mb3eA7loThVFGNX9QzMd9NY3e9V9anSxYoLC
 Jv+YKZh5AJAxehD3nR9CnyYmPpX2iuGQane0ru44H2DoXPArvMFc
X-Developer-Key: i=jkl820.git@gmail.com; a=ed25519;
 pk=rcRpP90oZXet9udPj+2yOibfz31aYv8tpf0+ZYOQhyA=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If potentially no valid element is found, 'priv_rx' would contain an
invalid pointer past the iterator loop. To ensure 'priv_rx' is always
valid, we only set it if the correct element was found. That allows
adding a WARN_ON() in case the code works incorrectly, exposing
currently undetectable potential bugs.

Additionally, Linus proposed to avoid any use of the list iterator
variable after the loop, in the attempt to move the list iterator
variable declaration into the macro to avoid any potential misuse after
the loop [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 4be770443b0c..8aad500e622d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -718,7 +718,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 
 bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 {
-	struct mlx5e_ktls_offload_context_rx *priv_rx, *tmp;
+	struct mlx5e_ktls_offload_context_rx *priv_rx = NULL, *iter, *tmp;
 	struct mlx5e_ktls_resync_resp *ktls_resync;
 	struct mlx5_wqe_ctrl_seg *db_cseg;
 	struct mlx5e_icosq *sq;
@@ -735,10 +735,12 @@ bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 	i = 0;
 
 	spin_lock(&ktls_resync->lock);
-	list_for_each_entry_safe(priv_rx, tmp, &ktls_resync->list, list) {
-		list_move(&priv_rx->list, &local_list);
-		if (++i == budget)
+	list_for_each_entry_safe(iter, tmp, &ktls_resync->list, list) {
+		list_move(&iter->list, &local_list);
+		if (++i == budget) {
+			priv_rx = iter;
 			break;
+		}
 	}
 	if (list_empty(&ktls_resync->list))
 		clear_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
@@ -765,6 +767,7 @@ bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
 		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, db_cseg);
 	spin_unlock(&c->async_icosq_lock);
 
+	WARN_ON(!priv_rx);
 	priv_rx->rq_stats->tls_resync_res_ok += j;
 
 	if (!list_empty(&local_list)) {

---
base-commit: c0927a7a5391f7d8e593e5e50ead7505a23cadf9
change-id: 20230301-net-mlx5e-avoid-iter-after-loop-dcc215275a96

Best regards,
-- 
Jakob Koschel <jkl820.git@gmail.com>

