Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61452FEDBA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfKPPq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfKPPqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:24 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A24CE2077B;
        Sat, 16 Nov 2019 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919184;
        bh=2Wlb3YZLDLsri+AOZgu2/8+1BzXQy5enQQEq+o4T+ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqoSDrdJ+xpHDojuI2ZxA8eoqYTJpyMwjJYDrnkv/rUCQ4qrthsYBnfKyh/mNdJ3e
         m3nprN5a7pHTZBtyq0Z37Ty/XSFgIaf1f3pIi6t2i1palCiNemEFIJY/ddDK9gG5I/
         mjD3KDyUrjRd1Vu9Yrn9LgYtkKux8u/PRw9hvIjM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 192/237] net: bpfilter: fix iptables failure if bpfilter_umh is disabled
Date:   Sat, 16 Nov 2019 10:40:27 -0500
Message-Id: <20191116154113.7417-192-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 97adaddaa6db7a8af81b9b11e30cbe3628cd6700 ]

When iptables command is executed, ip_{set/get}sockopt() try to upload
bpfilter.ko if bpfilter is enabled. if it couldn't find bpfilter.ko,
command is failed.
bpfilter.ko is generated if CONFIG_BPFILTER_UMH is enabled.
ip_{set/get}sockopt() only checks CONFIG_BPFILTER.
So that if CONFIG_BPFILTER is enabled and CONFIG_BPFILTER_UMH is disabled,
iptables command is always failed.

test config:
   CONFIG_BPFILTER=y
   # CONFIG_BPFILTER_UMH is not set

test command:
   %iptables -L
   iptables: No chain/target/match by that name.

Fixes: d2ba09c17a06 ("net: add skeleton of bpfilter kernel module")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_sockglue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b7a26120d5521..82f341e84faec 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1244,7 +1244,7 @@ int ip_setsockopt(struct sock *sk, int level,
 		return -ENOPROTOOPT;
 
 	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
-#ifdef CONFIG_BPFILTER
+#if IS_ENABLED(CONFIG_BPFILTER_UMH)
 	if (optname >= BPFILTER_IPT_SO_SET_REPLACE &&
 	    optname < BPFILTER_IPT_SET_MAX)
 		err = bpfilter_ip_set_sockopt(sk, optname, optval, optlen);
@@ -1557,7 +1557,7 @@ int ip_getsockopt(struct sock *sk, int level,
 	int err;
 
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen, 0);
-#ifdef CONFIG_BPFILTER
+#if IS_ENABLED(CONFIG_BPFILTER_UMH)
 	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
 	    optname < BPFILTER_IPT_GET_MAX)
 		err = bpfilter_ip_get_sockopt(sk, optname, optval, optlen);
@@ -1594,7 +1594,7 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen,
 		MSG_CMSG_COMPAT);
 
-#ifdef CONFIG_BPFILTER
+#if IS_ENABLED(CONFIG_BPFILTER_UMH)
 	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
 	    optname < BPFILTER_IPT_GET_MAX)
 		err = bpfilter_ip_get_sockopt(sk, optname, optval, optlen);
-- 
2.20.1

