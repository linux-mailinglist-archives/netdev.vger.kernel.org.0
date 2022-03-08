Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C54D1CBF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbiCHQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348096AbiCHQH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F505047B;
        Tue,  8 Mar 2022 08:06:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7053B81AEC;
        Tue,  8 Mar 2022 16:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680C4C340EB;
        Tue,  8 Mar 2022 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646755587;
        bh=iWt8F3PP3Y0EBEvmC0EddrSPdSJcpg+HzIjWpvsvdHA=;
        h=From:To:Cc:Subject:Date:From;
        b=elVt3W0Y4rY3cZk4sohym2G3wqmuFgwSNQzZGPkYBq+Q/ES8S53CQtHLMImJhDchw
         NpWS+objbRP3E0o8MnHxfJkH/V6IzIxisSF6KqPrEkS8tBoAfeXEulPUGcnmyUERys
         POBWAuZeTZ9FLHVwT6E9z2miCHC8P3+nyXPv3VceT+b5dlo/teF1ScGpB9ZsyPgcpC
         Mmju2GUPKd5YstBJHALqVBrlQEoRb+zeipXUhhc4cwDwLw+tlzepRIESC+9dnKvON1
         0ujFNI9SbtpfrG47yMk4QR2m9+xODhpWBGBtgwVUqbGzgZPDqUHRQmgFv8SRmrWhcI
         Sqqc/dbBCET5A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v4 bpf-next 0/3] introduce xdp frags support to veth driver
Date:   Tue,  8 Mar 2022 17:05:57 +0100
Message-Id: <cover.1646755129.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changes since v3:
- introduce a check on max_mtu for xdp mode in veth_xdp_set()
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

 drivers/net/veth.c | 206 ++++++++++++++++++++++++++++++---------------
 include/net/xdp.h  |  14 +++
 net/core/xdp.c     |   1 +
 3 files changed, 152 insertions(+), 69 deletions(-)

-- 
2.35.1

