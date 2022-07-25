Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5A57FDF3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiGYK4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiGYK4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129A818E23;
        Mon, 25 Jul 2022 03:56:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C4AB80E4D;
        Mon, 25 Jul 2022 10:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A3BC341C8;
        Mon, 25 Jul 2022 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658746587;
        bh=K5DIL+xxLusnURdb8tLNll8g6Jaq2ufLifV4EGhaUsc=;
        h=From:To:Cc:Subject:Date:From;
        b=LxTJBLhCS7zGFrYRDQlycCmQdzrLsPN19al44cnaHbCqSVB68atvts4abdZY2kQv8
         duxFIo39G8LzpwmUDRplt97Hyzjh9B8lwU/IGxnE8BzuqGnuTZhnkWyUYctCSWhwsh
         x5FW91n4rHqV3NKrXw6O3dNTZBK9P03hnrj1JpcBeTBGYCZ3AxvFEJbXCNWCiemVNG
         cLyYiYS9hynp1A97v04az7SkI/6eHzTMbpoH9Z5bXx1va6TOooQUrudi3TPEF37zxc
         rE1CtUyidzKQoJbr1KQZXbDpIRhqgSaLVG2lA4YHYbKukX7+//wmsQz9VJK8vuMVE9
         udhbpwJ7UqiIA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] xdp: report rx queue index in xdp_frame
Date:   Mon, 25 Jul 2022 12:56:19 +0200
Message-Id: <181f994e13c816116fa69a1e92c2f69e6330f749.1658746417.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_info
pointer. xdp_frame queue_index is currently used in cpumap code to covert
the xdp_frame into a xdp_buff.
xdp_frame size is not increased adding queue_index since an alignment padding
in the structure is used to insert queue_index field.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h   | 2 ++
 kernel/bpf/cpumap.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 04c852c7a77f..3567866b0af5 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -172,6 +172,7 @@ struct xdp_frame {
 	struct xdp_mem_info mem;
 	struct net_device *dev_rx; /* used by cpumap */
 	u32 flags; /* supported values defined in xdp_buff_flags */
+	u32 queue_index;
 };
 
 static __always_inline bool xdp_frame_has_frags(struct xdp_frame *frame)
@@ -301,6 +302,7 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 
 	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
 	xdp_frame->mem = xdp->rxq->mem;
+	xdp_frame->queue_index = xdp->rxq->queue_index;
 
 	return xdp_frame;
 }
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index f4860ac756cd..09a792d088b3 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -228,7 +228,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 
 		rxq.dev = xdpf->dev_rx;
 		rxq.mem = xdpf->mem;
-		/* TODO: report queue_index to xdp_rxq_info */
+		rxq.queue_index = xdpf->queue_index;
 
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 
-- 
2.37.1

