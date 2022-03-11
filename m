Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC664D5E1D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345056AbiCKJQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiCKJQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:16:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6801BB730;
        Fri, 11 Mar 2022 01:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70748B82AF0;
        Fri, 11 Mar 2022 09:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DD0C340E9;
        Fri, 11 Mar 2022 09:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646990098;
        bh=iYOKZ9FqqdGSqqLb/n6MiRIpTwISEckTPrIoC7abGgQ=;
        h=From:To:Cc:Subject:Date:From;
        b=GJbbK7cY7yjqpECO1VHHkfKRVkCULVG9VbeEm0sw1w6/Xf5cReM5pXPgZlpnz3dhx
         3cb7RKR+SwC+TQ7yAMr1Twhh946Vdpk+UPickfZj+dahpCgo6y/RkemLqGGX6Mp09q
         0nFkp1ixeHRflZkHH6un4NKOlVhj8W0gBotesb6dD/bfeit1l/hQ+YVuO72cNCMGOG
         jh8Ak1A496OC4UQT842JxQOZI9+BocM8PfB/uuechO4LN/8mtRbXUDRRFei42Hfu5+
         wawoBidfbJnPq7oGtQuJ6v7yow2wO6UQnHS15qZeLBA3JUMVAiMaRP+DF4bjFa3+gB
         3t/Yh4EM1LrHg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v5 bpf-next 0/3] introduce xdp frags support to veth driver
Date:   Fri, 11 Mar 2022 10:14:17 +0100
Message-Id: <cover.1646989407.git.lorenzo@kernel.org>
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
fragments.
This series has been tested running xdp_router_ipv4 sample available in the
kernel tree redirecting tcp traffic from veth pair into the mvneta driver.

Changes since v4:
- remove TSO support for the moment
- rename veth_convert_skb_from_xdp_buff to veth_convert_skb_to_xdp_buff

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

 drivers/net/veth.c | 192 +++++++++++++++++++++++++++++++--------------
 include/net/xdp.h  |  14 ++++
 net/core/xdp.c     |   1 +
 3 files changed, 146 insertions(+), 61 deletions(-)

-- 
2.35.1

