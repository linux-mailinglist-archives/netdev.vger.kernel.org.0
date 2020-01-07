Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C167133048
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgAGUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:07:12 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57105 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:07:12 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MqatE-1jSMXl0GYq-00mYDO; Tue, 07 Jan 2020 21:07:01 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netronome: fix ipv6 link error
Date:   Tue,  7 Jan 2020 21:06:40 +0100
Message-Id: <20200107200659.3538375-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zpRrHEIWckVKUDf/jl0u4GVcvJzo+JZ8MOp8eKylXX9xW7MO3Qw
 wS+MR16KEZLCb6WcAsyuH6JVF1lQcMLflE03KPA9E/pqcYj6gza2shj6XwW4xAYWfuiKh8E
 rbbv5B1ezYEiDGJkfgyfhHrHb8f+LROjpan4CutlLbfg7Rrf7LPuImpwts4z7q3GONyaMU2
 eNzToGrSscn9vO8zEfQ3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9g6EkQsqSyQ=:qDwIYkbbnT0g7KIepwu4oo
 rimWMRqFxYWN7DMOtm/584CrW5w6dIaJS9bmUnzMiuQM3CiErne1IW2yD7BKTFV/h5BCXl3K2
 fItbdjAv/FRAfZu4evvPpima6k1iz4V8GcJdZCKRwhrGrJpkP70kSJmFL8JQpwLkhN7GSM1+A
 r0aNb4mc1p7JO7wmF+2dT2AxWnxUk4rsbLenQuWxSq0Djf0gL3Yxi/k9wDZqoaJu5C+NuMuKD
 UUHCOI9vbuh7G0wWOnEERRLp8sDv2GhG+qDcx/CulOqflofn5Bc87FkML0W44kRtAa3m5DOLa
 m0MxliT9NDx8YGxRayIndGDNQNSX1aOK9KSbaAya1WYT6SLccUP5vG/rsfP46si33ok7SzG3+
 +thd6zKSNGEVTwt1l+lfY7ngbiXDm5vd7sZTPmQlL5VQLHp5sFGqam4lU/YBg/gj2uG+c7JnA
 O247EKrT7GFHEkY9H1ZvWPKHtEctJm1JOqH3dzlXqiB69toZNtAbfMzuBiRTjGZ2NCZVTBezT
 CU91D7QSoWCW6ClAW7Npn6jReWVcZO6aTu+RmAZy7XB9jJUStuelWuAAYC1FzlCx4XNHtRwM8
 +UaFlhpwBWA7YbdtRSHKcU0sDxJiw42p7WW/bGLck2RUgG9nl9aRfhyJ4+7iWzDJqI0mOvuTg
 w57Wen472jIynWaXhZ2lNUD8NXJ5ErZqBjmhsIOJHJyqoGTvhtB3c22IIPrtKhhRFAwn0GXT2
 KDqSsMvvGC536XaaM25VFuDpjdu1uPLII9JNjBsiyXfH6QGlOGhGI44VwO4KmVAWVc1LlySTs
 jlVbT/WzZEFvGJ6n4NVXQ+dSZpozHIy73QndjyK4Y9Ay/O6vJxUbZdQIa6dYpKpMWN70UvUGM
 z3N8QtvBdrppn4ZMCp3A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver is built-in but ipv6 is a module, the flower
support produces a link error:

drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.o: In function `nfp_tunnel_keep_alive_v6':
tunnel_conf.c:(.text+0x2aa8): undefined reference to `nd_tbl'

Add a Kconfig dependency to avoid that configuration.

Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/netronome/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index bac5be4d4f43..dcb02ce28460 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -31,6 +31,7 @@ config NFP_APP_FLOWER
 	bool "NFP4000/NFP6000 TC Flower offload support"
 	depends on NFP
 	depends on NET_SWITCHDEV
+	depends on IPV6 != m || NFP =m
 	default y
 	---help---
 	  Enable driver support for TC Flower offload on NFP4000 and NFP6000.
-- 
2.20.0

