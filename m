Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6D4665E64
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjAKOvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjAKOvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:24 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9932B140BF
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:23 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:Message-Id
        :Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive:Autocrypt;
        bh=fF3VEI5kaOJ9mWEikDTZU9/wZDEucMWyQgCgG4HjJRM=; b=Z/V444Xw4XQrgyrBkTwMSoLMn0
        spsGAfrGxYchTbolhyGWVDKnIZcPbsxG2+Fw/SAdTcxZBa/Wu7gJepINP9Bw==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive:Autocrypt;
        bh=fF3VEI5kaOJ9mWEikDTZU9/wZDEucMWyQgCgG4HjJRM=; b=XEp3h0ni9ufoz1Z8dmX4GPwdpw
        eyM+yy7gRZ/7pbmdwgdi/nauWFT06mhn7T6zStq/ccY/FP1MoOsiEScQQuWLcdyerx4lmyQvVmwoo
        M5+htwWIMuvodoFLe3dy1UBk8CrQGEJ3TpyU9NHMSGL1qhI4RlDjDLzKaOE00H2d8uIcfJhE0N5ys
        qWpU8oCROvhJFYCXjIip1Xl9I6nDIxLFo6qPGPLtM1g1mV5DyNT5Y6NZjDpqwAbxD5yupNaOeUvM0
        CTo5on1rXC0GZxT9j8CszQ66PyTl3wREviR5LI7vm6j+Hc3GueFI5UKZxbm6LK+Q5AE3p+rH5B491
        aViFpcQQ==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jF7-04
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:20 +0000
Message-Id: <20230111143427.1127174-1-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Routers and switches provide for mitigation of buffer overrun
by marking IP packets as "Congestion Experienced" [RFC 3168].
Participating transport protocols can use these marks to throttle
their send rates.

This patchset extends coverage to the receiving NIC/driver
buffers.

We use an out-of-band mechanism, marking the sk_buff rather
than the packet, to avoid need for DPI.

Participating NIC drivers are modified to add the marks.
Participating transport protocols are modified to notice
marks and combine with IP-level protocol marks.

Stats counters are incremented in ipv4 and ipv6 input processing,
with results:

 $ nstat -sz *Congest*
 #kernel
 Ip6InCongestionPkts             0                  0.0
 IpExtInCongestionPkts           148454             0.0
 $ 


Both NIC drivers and transports can be incrementatlly upgraded
to take advantage of the feature.  Three example drivers are
modified in this patchset.


Jeremy Harris (7):
  net: NIC driver Rx ring ECN: skbuff and tcp support
  net: NIC driver Rx ring ECN: stats counter
  drivers: net: xgene: NIC driver Rx ring ECN
  drivers: net: bnx2x: NIC driver Rx ring ECN
  drivers: net: bnx2x: NIC driver Rx ring ECN
  drivers: net: bnx2: NIC driver Rx ring ECN
  drivers: net: bnx2: NIC driver Rx ring ECN

 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |  8 ++++++--
 drivers/net/ethernet/broadcom/bnx2.c             | 11 +++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  | 12 +++++++++---
 include/linux/skbuff.h                           |  2 ++
 include/uapi/linux/snmp.h                        |  1 +
 net/core/skbuff.c                                |  1 +
 net/ipv4/ip_input.c                              |  4 ++++
 net/ipv4/proc.c                                  |  1 +
 net/ipv4/tcp_input.c                             |  8 +++++++-
 net/ipv6/ip6_input.c                             |  5 +++++
 net/ipv6/proc.c                                  |  1 +
 11 files changed, 46 insertions(+), 8 deletions(-)


base-commit: 12c1604ae1a39bef87ac099f106594b4cb433b75
-- 
2.39.0

