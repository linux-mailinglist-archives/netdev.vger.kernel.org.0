Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF24EAB37
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 12:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiC2KaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbiC2KaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 06:30:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA1792F5
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 03:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648549707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zmJQKkRz56fnzS0EeDC+7f1ewdiGvau6reWa8+hsBMg=;
        b=G4OBnnSKbY6n9htL7GZlMBWnvMbl49AewT2cIFzMugLTLxk7aq6Fu2TwEid1tThRFTKUH2
        vfhHPa+TtO3Hj4/RSAISwEyOkdA3JrKsWviNn0SQJm/eV9hU55lRXRLl8lw/6ugcyjSSIp
        rBI1NSmUeQSWMBoQ815mtScl8+6mS6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611--T5A9IpuMiKk7GarukZLEA-1; Tue, 29 Mar 2022 06:28:22 -0400
X-MC-Unique: -T5A9IpuMiKk7GarukZLEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8BBC802E5B;
        Tue, 29 Mar 2022 10:28:21 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F3C114582EE;
        Tue, 29 Mar 2022 10:27:53 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Subject: [PATCH net] ice: Fix logic of getting XSK pool associated with Tx queue
Date:   Tue, 29 Mar 2022 12:27:51 +0200
Message-Id: <20220329102752.1481125-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ice_tx_xsk_pool() used to get XSK buffer pool associated
with XDP Tx queue returns NULL when number of ordinary Tx queues
is not equal to num_possible_cpus().

The function computes XDP Tx queue ID as an expression
`ring->q_index - vsi->num_xdp_txq` but this is wrong because
XDP Tx queues are placed after ordinary ones so the correct
formula is `ring->q_index - vsi->alloc_txq`.

Prior commit 792b2086584f ("ice: fix vsi->txq_map sizing") number
of XDP Tx queues was equal to number of ordinary Tx queues so
the bug in mentioned function was hidden.

Reproducer:
host# ethtool -L ens7f0 combined 1
host# ./xdpsock -i ens7f0 -q 0 -t -N
samples/bpf/xdpsock_user.c:kick_tx:794: errno: 6/"No such device or address"

 sock0@ens7f0:0 txonly xdp-drv
                pps         pkts        0.00
rx              0           0
tx              0           0

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Fixes: 792b2086584f ("ice: fix vsi->txq_map sizing")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b0b27bfcd7a2..d4f1874df7d0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -710,7 +710,7 @@ static inline struct xsk_buff_pool *ice_tx_xsk_pool(struct ice_tx_ring *ring)
 	struct ice_vsi *vsi = ring->vsi;
 	u16 qid;
 
-	qid = ring->q_index - vsi->num_xdp_txq;
+	qid = ring->q_index - vsi->alloc_txq;
 
 	if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi->af_xdp_zc_qps))
 		return NULL;
-- 
2.34.1

