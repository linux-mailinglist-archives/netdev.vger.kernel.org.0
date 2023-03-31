Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707B36D166B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCaErq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCaErp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83AACA19
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FC53B82B97
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E179C433EF;
        Fri, 31 Mar 2023 04:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680238055;
        bh=M3Dibo7sbvz83ZW9VFxDAOWN89VD2UgQTXuj17HR/jk=;
        h=From:To:Cc:Subject:Date:From;
        b=cTNwdYKP4u+4za0K+kPU49NjYT3VjnqF3HQuRU6cUprBHbUPeVigDSHf13keGgt9j
         2txmJLgG2aXO3FnMURvdfU5CmSXUaVzhUubDqMs1Sy86IU1qDLF+J7vXtxb5BoVMIu
         Y82oM7hrW+GJuxfJmTB9L8Kwtkw17mx3e4CXgYNIAwbDWpWh/+T+sVkHWMCFwRyTtZ
         zL2X5AWkcpJg6tbmoQW3IEhmWTdSFT4aTeUwXR+oEaKdfo28Ek99hBv+v7tuJZbrXV
         dGeo6XlADWPb6FNsFksRa8Acq28eXg8cxgaQtv4qDBhmwWR57uvHuuUo+4pc57IIEq
         TtCa552vB/4Sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: minor reshuffle of napi_struct
Date:   Thu, 30 Mar 2023 21:47:31 -0700
Message-Id: <20230331044731.3017626-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_id is read by GRO and drivers to mark skbs, and it currently
sits at the end of the structure, in a mostly unused cache line.
Move it up into a hole, and separate the clearly control path
fields from the important ones.

Before:

struct napi_struct {
	struct list_head           poll_list;            /*     0    16 */
	long unsigned int          state;                /*    16     8 */
	int                        weight;               /*    24     4 */
	int                        defer_hard_irqs_count; /*    28     4 */
	long unsigned int          gro_bitmask;          /*    32     8 */
	int                        (*poll)(struct napi_struct *, int); /*    40     8 */
	int                        poll_owner;           /*    48     4 */

	/* XXX 4 bytes hole, try to pack */

	struct net_device *        dev;                  /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct gro_list            gro_hash[8];          /*    64   192 */
	/* --- cacheline 4 boundary (256 bytes) --- */
	struct sk_buff *           skb;                  /*   256     8 */
	struct list_head           rx_list;              /*   264    16 */
	int                        rx_count;             /*   280     4 */

	/* XXX 4 bytes hole, try to pack */

	struct hrtimer             timer;                /*   288    64 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 5 boundary (320 bytes) was 32 bytes ago --- */
	struct list_head           dev_list;             /*   352    16 */
	struct hlist_node          napi_hash_node;       /*   368    16 */
	/* --- cacheline 6 boundary (384 bytes) --- */
	unsigned int               napi_id;              /*   384     4 */

	/* XXX 4 bytes hole, try to pack */

	struct task_struct *       thread;               /*   392     8 */

	/* size: 400, cachelines: 7, members: 17 */
	/* sum members: 388, holes: 3, sum holes: 12 */
	/* paddings: 1, sum paddings: 4 */
	/* last cacheline: 16 bytes */
};

After:

struct napi_struct {
	struct list_head           poll_list;            /*     0    16 */
	long unsigned int          state;                /*    16     8 */
	int                        weight;               /*    24     4 */
	int                        defer_hard_irqs_count; /*    28     4 */
	long unsigned int          gro_bitmask;          /*    32     8 */
	int                        (*poll)(struct napi_struct *, int); /*    40     8 */
	int                        poll_owner;           /*    48     4 */

	/* XXX 4 bytes hole, try to pack */

	struct net_device *        dev;                  /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct gro_list            gro_hash[8];          /*    64   192 */
	/* --- cacheline 4 boundary (256 bytes) --- */
	struct sk_buff *           skb;                  /*   256     8 */
	struct list_head           rx_list;              /*   264    16 */
	int                        rx_count;             /*   280     4 */
	unsigned int               napi_id;              /*   284     4 */
	struct hrtimer             timer;                /*   288    64 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 5 boundary (320 bytes) was 32 bytes ago --- */
	struct task_struct *       thread;               /*   352     8 */
	struct list_head           dev_list;             /*   360    16 */
	struct hlist_node          napi_hash_node;       /*   376    16 */

	/* size: 392, cachelines: 7, members: 17 */
	/* sum members: 388, holes: 1, sum holes: 4 */
	/* paddings: 1, sum paddings: 4 */
	/* forced alignments: 1 */
	/* last cacheline: 8 bytes */
} __attribute__((__aligned__(8)));

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78f70e94b5d8..b3c11353078b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -370,11 +370,12 @@ struct napi_struct {
 	struct sk_buff		*skb;
 	struct list_head	rx_list; /* Pending GRO_NORMAL skbs */
 	int			rx_count; /* length of rx_list */
+	unsigned int		napi_id;
 	struct hrtimer		timer;
+	struct task_struct	*thread;
+	/* control-path-only fields follow */
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
-	unsigned int		napi_id;
-	struct task_struct	*thread;
 };
 
 enum {
-- 
2.39.2

