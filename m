Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C674E864B
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 08:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiC0Gii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 02:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiC0Gih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 02:38:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDC53CFD7;
        Sat, 26 Mar 2022 23:36:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso15928600pjb.0;
        Sat, 26 Mar 2022 23:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Vxquc0x82lOVnxgO9GG3bLoj2bnOAjB9KKaly9b71eI=;
        b=Zacfa65VYT45Ed3HvNxEa/zSfJxhASFzdSnFgNAFfl2zaCIHVw7FfZuC2I8CM2rP5z
         Dck4y+sMWcDcoTnqjgDrzLVR4cW35Pf/iJMzWQGSYO3VGkfZuvNPIYMPeS2Za6lqpk+W
         Ojd1GvY20KgJ7HbeKe7kbOEtbtl0QbntQQEOA9FuLHPbcdh5rkQBE6+06UqA6VA6fCsD
         sqRWpUgH6vTTfRggawqLnMsYit5TB6/bwci2nsO3ysp9uW+vEiN+odgd7H6upDiwF2yN
         ySwAachEwUY7o9c47dRqWyhBBJXtnpub3k2M3V7NLJpY7qd2Lq0Tzfn6gbe+Dv0uP/mZ
         SAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vxquc0x82lOVnxgO9GG3bLoj2bnOAjB9KKaly9b71eI=;
        b=50VQoLxc14+zrxqhUGSSwAqlzX9KqOG/KPaXWAKnqpaXnovulAGwl0M5GtWeWDlLtQ
         Na3n6OlZrSo+FwRdZ8a4OBsE8eeqh8lVcpwOIzHpoA/am1bbo0taQZ+TccNK/VTEQuaE
         NAo8M03eL8qcYXGyJ+5A9SeEAUe7fBIEWhZq2Kn1lznWVIpAmWDwInTUjqdUIkOf3wyC
         E78bKIMkS29gi+Nle97il2GhSSVkj7VOIgxAzDp2Ji26pfD1LYX9kBjleLLrjE3EsQBi
         j94b6PN9q38LOgVvPQ15LX7Ei6bUFXIoAmwQsQPX7dzjOWjeRwA5cVdiEkQrD13ZBnSO
         NtDw==
X-Gm-Message-State: AOAM533XOyAAeFHlZYfYE0ZIS/ufXv7jeDziYjYomYd2yjWI7eWW7KRg
        6ac1VoaFV+dlP81ghmcOG3X9/LzRIg0=
X-Google-Smtp-Source: ABdhPJyaSjWXyZ/ieaqh8L/e97HlAPr2TIJNMayS2xqJXyF8IYR/UDytE58G5d57fMqS8Xl9dMSxag==
X-Received: by 2002:a17:902:e949:b0:14d:8ab1:919 with SMTP id b9-20020a170902e94900b0014d8ab10919mr20127331pll.122.1648363019396;
        Sat, 26 Mar 2022 23:36:59 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id b7-20020a056a00114700b004f7be3231d6sm11408373pfm.7.2022.03.26.23.36.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Mar 2022 23:36:58 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        harshitha.ramamurthy@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] i40e: i40e_main: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 14:36:06 +0800
Message-Id: <20220327063606.7315-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug is here:
	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);

The list iterator 'ch' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, use a new variable 'iter' as the list iterator,
while use the origin variable 'ch' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 1d8d80b4e4ff6 ("i40e: Add macvlan support on i40e")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 27 +++++++++++----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 31b03fe78d3b..6224c98d275f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7536,41 +7536,42 @@ static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
 			    struct i40e_fwd_adapter *fwd)
 {
 	int ret = 0, num_tc = 1,  i, aq_err;
-	struct i40e_channel *ch, *ch_tmp;
+	struct i40e_channel *ch = NULL, *ch_tmp, *iter;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 
-	if (list_empty(&vsi->macvlan_list))
-		return -EINVAL;
-
 	/* Go through the list and find an available channel */
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
-		if (!i40e_is_channel_macvlan(ch)) {
-			ch->fwd = fwd;
+	list_for_each_entry_safe(iter, ch_tmp, &vsi->macvlan_list, list) {
+		if (!i40e_is_channel_macvlan(iter)) {
+			iter->fwd = fwd;
 			/* record configuration for macvlan interface in vdev */
 			for (i = 0; i < num_tc; i++)
 				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
 							     i,
-							     ch->num_queue_pairs,
-							     ch->base_queue);
-			for (i = 0; i < ch->num_queue_pairs; i++) {
+							     iter->num_queue_pairs,
+							     iter->base_queue);
+			for (i = 0; i < iter->num_queue_pairs; i++) {
 				struct i40e_ring *tx_ring, *rx_ring;
 				u16 pf_q;
 
-				pf_q = ch->base_queue + i;
+				pf_q = iter->base_queue + i;
 
 				/* Get to TX ring ptr */
 				tx_ring = vsi->tx_rings[pf_q];
-				tx_ring->ch = ch;
+				tx_ring->ch = iter;
 
 				/* Get the RX ring ptr */
 				rx_ring = vsi->rx_rings[pf_q];
-				rx_ring->ch = ch;
+				rx_ring->ch = iter;
 			}
+			ch = iter;
 			break;
 		}
 	}
 
+	if (!ch)
+		return -EINVAL;
+
 	/* Guarantee all rings are updated before we update the
 	 * MAC address filter.
 	 */
-- 
2.17.1

