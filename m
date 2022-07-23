Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D37F57F092
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiGWRRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 13:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGWRRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 13:17:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDE1EC72;
        Sat, 23 Jul 2022 10:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4ABF60EA4;
        Sat, 23 Jul 2022 17:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72240C341C0;
        Sat, 23 Jul 2022 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658596654;
        bh=g+frFEGYvuqJLWR0I9sf72sXVoJVX3BDPDsaXFB6A1U=;
        h=From:To:Cc:Subject:Date:From;
        b=CvyZxylXzhcMbiMfuUSnZI/ye2Uokji1XQNHOmGyRSa//aaqIDKroZchMKtbfCzrn
         NrDpuPVMH/4aqSHrbM1r1AeYCeMkue+FZeCoMjp/aH35t1nYxqd6OPBA8Hu0HxhZvs
         QtLctomuNwZifoLDrYw1wKfcO9SHM0cM9ONwNLQUpWvpiT1EnhoMOWJwBFECn1NQgi
         QNMl/SYpkaj3K/ch5A+ZWqxN5JOuEX3dpe6UniJ+tVCccMyZ4ZbY8MR++TmKW5llms
         3GrqtzyFq2yZRPWicBFSAt5fv2Lna9BxGsfURUgDoQ/WJeclkSvC8700UqyEFfP71P
         WjrubvtlIahIg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] bpf: devmap: compute proper xdp_frame len redirecting frames
Date:   Sat, 23 Jul 2022 19:17:10 +0200
Message-Id: <894d99c01139e921bdb6868158ff8e67f661c072.1658596075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if it is currently forbidden to XDP_REDIRECT a multi-frag xdp_frame
into a devmap, compute proper xdp_frame length in __xdp_enqueue and
is_valid_dst routines running xdp_get_frame_len().

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 1400561efb15..a0e02b009487 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -477,7 +477,7 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	if (!dev->netdev_ops->ndo_xdp_xmit)
 		return -EOPNOTSUPP;
 
-	err = xdp_ok_fwd_dev(dev, xdpf->len);
+	err = xdp_ok_fwd_dev(dev, xdp_get_frame_len(xdpf));
 	if (unlikely(err))
 		return err;
 
@@ -536,7 +536,7 @@ static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf)
 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
 		return false;
 
-	if (xdp_ok_fwd_dev(obj->dev, xdpf->len))
+	if (xdp_ok_fwd_dev(obj->dev, xdp_get_frame_len(xdpf)))
 		return false;
 
 	return true;
-- 
2.36.1

