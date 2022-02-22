Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65014C022A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiBVToo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiBVTon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:44:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FC61EC6B;
        Tue, 22 Feb 2022 11:44:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65A0F615E6;
        Tue, 22 Feb 2022 19:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20171C340E8;
        Tue, 22 Feb 2022 19:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645559056;
        bh=SPpdkh2a1kF1oArmOFSsOqOJPCYFWJF5eHHxh7h4YH0=;
        h=From:To:Cc:Subject:Date:From;
        b=Oo3X0atx0pgI0F5a9nnSURNe5SxJTsLmaPIRGZgYqTAZ6IS/hHyJFsUGxi+nSJMw2
         weIdA0AVCsKQSozKnZtuWBMtljjZw2S4DCTYxfwiDXdjAASvxcLBBr/5IJJW6CXLTt
         q0ML5eF+KAnuesXYdTlbw70AJIZrWszyuJnv9ghiMq4q7ahFbnUNo/BCjbq+z89PR9
         dVF/pOmN24DirWOygFA9Icd9zpCu68JFd5AS+hKQxuRqvNzmcah8Q0f43zjF1G4TRy
         rKpQt002vCStnyy5UVqQ5GidcY8ny7ojqWyCnRPwstNkEJCu8rOMg7AoQad5HYbfJq
         6gyJuB7h9EEkQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v3 bpf-next 0/3] introduce xdp frags support to veth driver
Date:   Tue, 22 Feb 2022 20:43:36 +0100
Message-Id: <cover.1645558706.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp frags support to veth driver in order to allow increasing the mtu
over the page boundary if the attached xdp program declares to support xdp
fragments. Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
This series has been tested running xdp_router_ipv4 sample available in the
kernel tree redirecting tcp traffic from veth pair into the mvneta driver.

Changes since v2:
- move rcu_access_pointer() check in veth_skb_is_eligible_for_gro

Changes since v1:
- always consider skb paged are non-writable
- fix tpt issue with sctp
- always use napi if we are running in xdp mode in veth_xmit

Lorenzo Bianconi (3):
  net: veth: account total xdp_frame len running ndo_xdp_xmit
  veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
  veth: allow jumbo frames in xdp mode

 drivers/net/veth.c | 212 +++++++++++++++++++++++++++++----------------
 include/net/xdp.h  |  14 +++
 net/core/xdp.c     |   1 +
 3 files changed, 151 insertions(+), 76 deletions(-)

-- 
2.35.1

