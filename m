Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12492596A82
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiHQHlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiHQHlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:41:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244677567;
        Wed, 17 Aug 2022 00:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 40865CE1BA1;
        Wed, 17 Aug 2022 07:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA87DC433D6;
        Wed, 17 Aug 2022 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660722059;
        bh=19i/QpFcJoAmDkmhnpShDuEe4SsuaoJYMSeoihzNGpY=;
        h=From:To:Cc:Subject:Date:From;
        b=cmUf0X1FX0RBbSusGjIkQ+xwMZZr3xP5oeeyrZjKhitmQ6bIXmuFifbOK1wyq4mPo
         DiHWMVBJ1iOwnZXx1TuVQw6zhx3e62E/yg5dGIv3gh9m3VKpLSH2pubAaxKRb7TuNc
         evAhRBTenzJx+FMCwJ0sPdeGnIo5yPKGZbDcZ3qge6uNbKYXc6+3xXQ03SSrXIksY0
         6pGEOxIDdF6lbod1hXpgNkCvZwv4lipbbEXsltU4DCKiExDUUFTEvMJj7qjruXsPFG
         Z+kUupbtfcAZ6eyzaewwlpuQNFCkvTCeZ7J1yTlcmINr8AvEbIr79C2b1ugCP6uUq7
         hnFnLjerhlL5A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 bpf-next] xdp: report rx queue index in xdp_frame
Date:   Wed, 17 Aug 2022 09:40:50 +0200
Message-Id: <3923222d836b104232ee70eef34ce2aa454ef9db.1660721856.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_info
pointer. xdp_frame queue_index is currently used in cpumap code to convert
the xdp_frame into a xdp_buff and allow the ebpf program attached to the
map entry to differentiate traffic according to the receiving hw queue.
xdp_frame size is not increased adding queue_index since an alignment
padding in the structure is used to insert queue_index field.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on top of bpf-next
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
index b5ba34ddd4b6..48003450c98c 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -228,7 +228,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 
 		rxq.dev = xdpf->dev_rx;
 		rxq.mem = xdpf->mem;
-		/* TODO: report queue_index to xdp_rxq_info */
+		rxq.queue_index = xdpf->queue_index;
 
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 
-- 
2.37.2

