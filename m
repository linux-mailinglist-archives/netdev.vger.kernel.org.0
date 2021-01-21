Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3822FE554
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbhAUIq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbhAUIq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:46:29 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DCEC061757
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:45:49 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i7so922544pgc.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JwNVM6Vm2ZdYJE8goVZmFtD6mPgc8Vosgi0G6vc/CaM=;
        b=hdulwPh8aVGtzmzQrPezmfQfO7Irc8Mme57rknb1nu+tXRSdUMb3wK6LY42O5rc6XG
         c7Lyxy8e7mhhVkswGs8dVmBtzP6jFvPGEBplHkarikprJUsCJg0HKyT6HBdBsXJCgp2v
         65S0fVXdGdK4iiHsZJB0tSQ9t0RU11pUSdtox6I0HpHgJXkxNnS8sHJXcGXcCl0fpiKD
         ezdjnCsDhMLVEDfio92Ghy2cYS0k4rslQQpw5W3EQ4LBXKvup7qFqCK+6Vj+5QhK8/X/
         MLoHmcJKHk5/Mqythx4ZyRtVG+OxkjoSYi81SCMihelW41cPMbDBQ0J9G9TRs/mUvv4I
         y9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JwNVM6Vm2ZdYJE8goVZmFtD6mPgc8Vosgi0G6vc/CaM=;
        b=gWhBUAs2FDG+wyGZ5PtUU174lgPyAzIWlPCnDIEU8rxIiYvjqQdvLN/HKvPeXse5hW
         4/ke9RQVbNSTW3YCCdFB88sDomV13/prwrYDSIXICqEP5DR9i12YS0cQ1v4Bg+V/U6Ja
         i1y9XMgls9+TUsAxgzUdBo/5PFOMK63UEFrgYFTrptRyjoxvYvCj0bN3aI+aiLd9Ix2z
         SMzrXuiNnSL3jKi0R5079a1x0Ou402Uj2N6E4Pe+zw1bM0Nr0bbGdJ44zD+XrPZX5bSQ
         X5NIUzWszeSlylvYltgnd1N4Ux15BqzhXTwfy237aaKrb2pYjgFhbZcZ29MPfPCiyjaI
         CZXQ==
X-Gm-Message-State: AOAM533zSF33BAkCMTlMfaz9B2k6PNA8d500DNxBCywnf/QibUJbitZf
        8q0KWk8fApUGxld5RustseSkj5PYDaU=
X-Google-Smtp-Source: ABdhPJyCKRk7DdPd26qB3FyMwlq/zdRI7j4NrP9LgYMHSlwF+WA9t821aNcU+jgKhN/A5hhVtfcWDg==
X-Received: by 2002:a63:2fc5:: with SMTP id v188mr13208918pgv.243.1611218748810;
        Thu, 21 Jan 2021 00:45:48 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bk18sm5218966pjb.41.2021.01.21.00.45.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Jan 2021 00:45:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 0/3] net: add support for ip generic checksum offload for gre
Date:   Thu, 21 Jan 2021 16:45:35 +0800
Message-Id: <cover.1611218673.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETIF_F_IP(V6)_CSUM is only for TCP and UDP checksum offload, and
NETIF_F_HW_CSUM is not only for TCP and UDP's, but also for all
other kinds of 1's complement checksums offload, like GRE's. This
patchset is to support it for GRE.

To support GRE checksum offload, this patchset is to extend the
csum_not_inet/csum_type of sk_buff in Patch 1/3, and define new
type of CSUM_T_IP_GENERIC to get ip generic checksum processed
in skb_csum_hwoffload_help() in Patch 2/3, then implement it on
TX path and GSO path in Patch 3/3.

Xin Long (3):
  net: rename csum_not_inet to csum_type
  net: add CSUM_T_IP_GENERIC csum_type
  ip_gre: add csum offload support for gre header

 include/linux/skbuff.h | 22 +++++++++++++---------
 include/net/gre.h      | 20 ++++++++------------
 net/core/dev.c         | 19 ++++++++++++++-----
 net/ipv4/gre_offload.c | 16 ++++++++++++++--
 net/sched/act_csum.c   |  2 +-
 net/sctp/offload.c     |  2 +-
 net/sctp/output.c      |  3 ++-
 7 files changed, 53 insertions(+), 31 deletions(-)

-- 
2.1.0

