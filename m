Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5EF6134CA
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiJaLpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJaLoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32ACE0E2;
        Mon, 31 Oct 2022 04:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F51960FD3;
        Mon, 31 Oct 2022 11:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEEAC433D6;
        Mon, 31 Oct 2022 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216684;
        bh=gq8XQLGdZXzEXSUh75QeQ+qd9vC3nuRLj1ibJ386OHk=;
        h=From:To:Cc:Subject:Date:From;
        b=fj0jIFskNjP+Ue94bDPQGzFTPfAIKXXNfIGkMfM+zFIH5T+Lwj58p6krGSA8voSlo
         jQtgqElf+XtCMpHa0tBBSwuQSIKJLivYjEz3wNdi+TPt20+kB30Ypg5R7XmMu1q560
         lPcOWKggEWDaFWzQk1REFdgq7ZCVYUySa0y6oGiY1dIHsDHzCzKitH+uD87KWuMvsM
         nZfP8pKg7kn4/wSqmAGWVoKIHAU8HRoRMYxN01CcgKPzFFyaMWhkAgcpQJ9Fm1a+cj
         r1wKlBaLmmPKnvh6vRdw6nwPKp+vvfovNOoxfblbrAd2Vx5zQc+vyWlfFIorQ3eLNX
         vx5lUjWpuX7JQ==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     ecree.xilinx@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] sfc (gcc13): synchronize ef100_enqueue_skb()'s return type
Date:   Mon, 31 Oct 2022 12:44:40 +0100
Message-Id: <20221031114440.10461-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ef100_enqueue_skb() generates a valid warning with gcc-13:
  drivers/net/ethernet/sfc/ef100_tx.c:370:5: error: conflicting types for 'ef100_enqueue_skb' due to enum/integer mismatch; have 'int(struct efx_tx_queue *, struct sk_buff *)'
  drivers/net/ethernet/sfc/ef100_tx.h:25:13: note: previous declaration of 'ef100_enqueue_skb' with type 'netdev_tx_t(struct efx_tx_queue *, struct sk_buff *)'

I.e. the type of the ef100_enqueue_skb()'s return value in the declaration is
int, while the definition spells enum netdev_tx_t. Synchronize them to the
latter.

Cc: Martin Liska <mliska@suse.cz>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 102ddc7e206a..29ffaf35559d 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -367,7 +367,8 @@ void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
  * Returns 0 on success, error code otherwise. In case of an error this
  * function will free the SKB.
  */
-int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue,
+			      struct sk_buff *skb)
 {
 	return __ef100_enqueue_skb(tx_queue, skb, NULL);
 }
-- 
2.38.1

