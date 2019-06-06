Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC45738011
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfFFV5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFFV5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:57:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B11A53082E4B;
        Thu,  6 Jun 2019 21:57:18 +0000 (UTC)
Received: from dhcppc1.redhat.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A3F47E687;
        Thu,  6 Jun 2019 21:57:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 0/3] net/mlx5: use indirect call wrappers
Date:   Thu,  6 Jun 2019 23:56:47 +0200
Message-Id: <cover.1559857734.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 06 Jun 2019 21:57:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5_core driver uses several indirect calls in fast-path, some of them
are invoked on each ingress packet, even for the XDP-only traffic.

This series leverage the indirect call wrappers infrastructure the avoid
the expansive RETPOLINE overhead for 2 indirect calls in fast-path.

Each call is addressed on a different patch, plus we need to introduce a couple
of additional helpers to cope with the higher number of possible direct-call
alternatives.

v1 - v2:
 - update the direct call list and use a macro to define it,
   as per Saeed suggestion. An intermediated additional
   macro is needed to allow arg list expansion
 - patch 2/3 is unchanged, as the generated code looks better this way than
   with possible alternative (dropping BP hits)

Paolo Abeni (3):
  net/mlx5e: use indirect calls wrapper for skb allocation
  indirect call wrappers: add helpers for 3 and 4 ways switch
  net/mlx5e: use indirect calls wrapper for the rx packet handler

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 27 ++++++++++++++-----
 include/linux/indirect_call_wrapper.h         | 12 +++++++++
 3 files changed, 37 insertions(+), 6 deletions(-)

-- 
2.20.1

