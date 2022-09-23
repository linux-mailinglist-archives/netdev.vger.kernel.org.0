Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705FF5E7B1D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiIWMtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiIWMsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:48:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF813A391
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663937285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iLCWiprl1iMpIFfUKZxZYIzHpM6BS2MeK2b5upqGVIo=;
        b=Run3LHN4hFyXq8kVqylOZJ3RoPR7TO7HleGWq8RMzUsptir3s/YXlz5Er+GjZoso+PYjud
        Wr51Y9O98Tg3+nu04Zd2ZAZggweSOlnjsI1rznIghUHbUrrGoLytdvBMA9J3kcag/0GOp/
        0aewDYMR/SSfsHZbRwBE99+7t30M5iQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-n_58ErrqN-KHynNQCARBdA-1; Fri, 23 Sep 2022 08:48:02 -0400
X-MC-Unique: n_58ErrqN-KHynNQCARBdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9631E85A583;
        Fri, 23 Sep 2022 12:48:01 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CB0240C6E13;
        Fri, 23 Sep 2022 12:48:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2596F30721A6C;
        Fri, 23 Sep 2022 14:48:00 +0200 (CEST)
Subject: [PATCH net-next] xdp: Adjust xdp_frame layout to avoid using
 bitfields
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, ast@kernel.org,
        hawk@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        pabeni@redhat.com, bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Fri, 23 Sep 2022 14:48:00 +0200
Message-ID: <166393728005.2213882.4162674859542409548.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Practical experience (and advice from Alexei) tell us that bitfields in
structs lead to un-optimized assemply code. I've verified this change
does lead to better x86_64 assemply, both via objdump and playing with
code snippets in godbolt.org.

Using scripts/bloat-o-meter shows the code size is reduced with 24
bytes for xdp_convert_buff_to_frame() that gets inlined e.g. in
i40e_xmit_xdp_tx_ring() which were used for microbenchmarking.

Microbenchmarking results do show improvements, but very small and
varying between 0.5 to 2 nanosec improvement per packet.

The member @metasize is changed from u8 to u32. Future users of this
area could split this into two u16 fields. I've also benchmarked with
two u16 fields showing equal performance gains and code size reduction.

The moved member @frame_sz doesn't change sizeof struct due to existing
padding. Like xdp_buff member @frame_sz is placed next to @flags, which
allows compiler to optimize assignment of these.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 04c852c7a77f..55dbc68bfffc 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -164,13 +164,13 @@ struct xdp_frame {
 	void *data;
 	u16 len;
 	u16 headroom;
-	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 metasize; /* uses lower 8-bits */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
+	u32 frame_sz;
 	u32 flags; /* supported values defined in xdp_buff_flags */
 };
 


