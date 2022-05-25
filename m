Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5FA533A2A
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240685AbiEYJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiEYJo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AB2DFBC;
        Wed, 25 May 2022 02:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0CB061939;
        Wed, 25 May 2022 09:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4329C385B8;
        Wed, 25 May 2022 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653471892;
        bh=KG14qChgKVofiN/Si1BwcR0SdLiFvEg3NyIULz1j+Nc=;
        h=From:To:Cc:Subject:Date:From;
        b=M8BsAbVG3vH68QSiQllpUlhw9/qKjSqoSDoSihFCpIIYnn4IVVkl5jxxLumdescUL
         suG378nYqMW97g2LC0Uo/TTx+Zo3jE8M8EsJRWxYxR82Cg283TDcgBSsrv98dzUADV
         9akXm7x2i6tEZULdzt6/MkK7JyXBSu4blO0zcc2NlLUbiG5Kerl5zh4rcaq/LphLpd
         RYJXe8iBbwO5CbyheptOpcAUaAJcOb2FxioaUPxY8Th0EwIaQpKM4/NuJgPbGZm/Ne
         z/PJeh5Zm+Md2NdjzNZwKBuT4KbQSNp2gfoXjXMDuzGrpuOjk0Y9XTbfz2dtJTfZd3
         LXSdUCuzKU1GQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] sample: bpf: xdp_router_ipv4: allow the kernel to send arp requests
Date:   Wed, 25 May 2022 11:44:27 +0200
Message-Id: <60bde5496d108089080504f58199bcf1143ea938.1653471558.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forward the packet to the kernel if the gw router mac address is missing
in to trigger ARP discovery.

Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_router_ipv4.bpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/samples/bpf/xdp_router_ipv4.bpf.c b/samples/bpf/xdp_router_ipv4.bpf.c
index 248119ca7938..0643330d1d2e 100644
--- a/samples/bpf/xdp_router_ipv4.bpf.c
+++ b/samples/bpf/xdp_router_ipv4.bpf.c
@@ -150,6 +150,15 @@ int xdp_router_ipv4_prog(struct xdp_md *ctx)
 
 				dest_mac = bpf_map_lookup_elem(&arp_table,
 							       &prefix_value->gw);
+				if (!dest_mac) {
+					/* Forward the packet to the kernel in
+					 * order to trigger ARP discovery for
+					 * the default gw.
+					 */
+					if (rec)
+						NO_TEAR_INC(rec->xdp_pass);
+					return XDP_PASS;
+				}
 			}
 		}
 
-- 
2.35.3

