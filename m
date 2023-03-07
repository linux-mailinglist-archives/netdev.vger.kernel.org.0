Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659D36AD307
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCFXva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFXv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A2E3B3E3;
        Mon,  6 Mar 2023 15:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE5BB80E98;
        Mon,  6 Mar 2023 23:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C78C433EF;
        Mon,  6 Mar 2023 23:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678146685;
        bh=jL7xXOOyjDrI1lWEUBmIuKIMDYmR+aYVz30Qx6CwOT0=;
        h=Date:From:To:Cc:Subject:From;
        b=TU1RuuekTGlXlz65IZhKSq04p671+b9C3B6TVcUVnowY4mlVDgUE2HJTkNrBj6AJ9
         sVOuwDE8Lx9oeU2Sd+WlOvfB6lAho86dFhJLVoLLa1n4TA3eLk/v4b37tj+2iimWIr
         bLvDMil1xwUhHsg+77M/MeOoWUAUwp4F+ucIn4ZU055VR/ay7ko9rpwIf4S0AUJaLu
         4kK3mN+V1NG+eG3UwU4EKt/tere4MUnd0ymUTzmwcTLtoVd0Q7gupKXSoUkYDBqy2C
         LXB316/9x7OldO2mkCFqs4n08ekxtUXmUGZRFQxqa3tF+RWZDQa5J5tb6jUbdFdLDk
         U7VjVDlQKCV7Q==
Date:   Mon, 6 Mar 2023 17:51:52 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net/mlx4_en: Replace fake flex-array with
 flexible-array member
Message-ID: <ZAZ8mNbphtPyZWM6@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Transform zero-length array into flexible-array member in struct
mlx4_en_rx_desc. 

Address the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
drivers/net/ethernet/mellanox/mlx4/en_rx.c:88:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:149:30: warning: array subscript 0 is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:127:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:128:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:129:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:117:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]
drivers/net/ethernet/mellanox/mlx4/en_rx.c:119:30: warning: array subscript i is outside array bounds of ‘struct mlx4_wqe_data_seg[0]’ [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/264
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 544e09b97483..034733b13b1a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -323,7 +323,7 @@ struct mlx4_en_tx_ring {
 
 struct mlx4_en_rx_desc {
 	/* actual number of entries depends on rx ring stride */
-	struct mlx4_wqe_data_seg data[0];
+	DECLARE_FLEX_ARRAY(struct mlx4_wqe_data_seg, data);
 };
 
 struct mlx4_en_rx_ring {
-- 
2.34.1

