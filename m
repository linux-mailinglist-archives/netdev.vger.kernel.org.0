Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8264222E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfFLKSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfFLKSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 06:18:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7BED25D672;
        Wed, 12 Jun 2019 10:18:46 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73E2A39B9;
        Wed, 12 Jun 2019 10:18:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v3 0/2] net/mlx5: use indirect call wrappers
Date:   Wed, 12 Jun 2019 12:18:34 +0200
Message-Id: <cover.1560333783.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 12 Jun 2019 10:18:46 +0000 (UTC)
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

v2 -> v3:
 - do not add more INDIRECT_CALL_* macros
 - use only the direct calls always available regardless of
   the mlx5 build options in the last patch

v1 -> v2:
 - update the direct call list and use a macro to define it,
   as per Saeed suggestion. An intermediated additional
   macro is needed to allow arg list expansion
 - patch 2/3 is unchanged, as the generated code looks better this way than
   with possible alternative (dropping BP hits)

Paolo Abeni (2):
  net/mlx5e: use indirect calls wrapper for skb allocation
  net/mlx5e: use indirect calls wrapper for the rx packet handler

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

-- 
2.20.1

