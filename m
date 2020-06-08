Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCAF1F1BD7
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgFHPR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 11:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgFHPRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 11:17:25 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8BB206A4;
        Mon,  8 Jun 2020 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591629445;
        bh=O9Cx6oAcWpTiM3/PaujOVv9ekTdqH3B/m1S7+G6GbAo=;
        h=From:To:Cc:Subject:Date:From;
        b=MV7PZqF5GuS8TqmURVREuMUYMqXzp7jzdypfNkvZfTEkaamqhdYUK/8ekQJbfNGRp
         ZgLCHu6lnuylbYIojSi/QzVMnYwaKu82OsFt6o6SMCnLWAQN95TcUEYFBj9krcWm8Z
         qjYKDDHwT6y2x7qHcZ62G6hmEZAdpxWQAaU+D6z8=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf] bpf: Reset data_meta before running programs attached to devmap entry
Date:   Mon,  8 Jun 2020 09:17:23 -0600
Message-Id: <20200608151723.9539-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new context that does not handle metadata at the moment, so
mark data_meta invalid.

Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 kernel/bpf/devmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 854b09beb16b..bfdff2faf5cb 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -479,6 +479,7 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
 	struct xdp_txq_info txq = { .dev = dev };
 	u32 act;
 
+	xdp_set_data_meta_invalid(xdp);
 	xdp->txq = &txq;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-- 
2.17.1

