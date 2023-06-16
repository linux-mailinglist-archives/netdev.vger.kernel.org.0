Return-Path: <netdev+bounces-11350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE74732B1B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8540A281239
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8BDD525;
	Fri, 16 Jun 2023 09:09:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125C7F9F4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A41EC433C0;
	Fri, 16 Jun 2023 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686906544;
	bh=iPWPXNvnYRe2+h21DBS9ZfvzMiWbCC13nR/zPknLFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgxB3PPe7xDo5i1HoqL5Nkc8iI3Igjm7zkJRKSoXXGviq3rQZkC+DUKVcBcKTuX1l
	 Y+v+WN/zaUD1H7JdvtbQq9E9sWKNvEpbaa1U4ahwYGjKTJ9yoPn6R3kfuJvJ8v/Qdb
	 Y0E+he2nJLOvJusREIyfzy4yl7zqQ+mtsk8GtM6D8POPXd3rpY8A6sIqjDOLjw5be/
	 T78yns/TYvPxei64/CIZgxtYSi9tCKIaEWbKx74gpSHxR5zcmUjXtR42Rk82XBITfG
	 ZX0iAEUNCEUHkzWCgUwHqnKTmcL4OQveGOaiDzHXDQclQxW56DqQ/Eh6B2R3mjWJFR
	 rnmjGGAv+AWLw==
From: Arnd Bergmann <arnd@kernel.org>
To: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Alejandro Lucero <alejandro.lucero-palau@amd.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sfc: add CONFIG_INET dependency for TC offload
Date: Fri, 16 Jun 2023 11:08:19 +0200
Message-Id: <20230616090844.2677815-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616090844.2677815-1-arnd@kernel.org>
References: <20230616090844.2677815-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The driver now fails to link when CONFIG_INET is disabled, so
add an explicit Kconfig dependency:

ld.lld: error: undefined symbol: ip_route_output_flow
>>> referenced by tc_encap_actions.c
>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_flower_create_encap_md) in archive vmlinux.a

ld.lld: error: undefined symbol: ip_send_check
>>> referenced by tc_encap_actions.c
>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a
>>> referenced by tc_encap_actions.c
>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a

ld.lld: error: undefined symbol: arp_tbl
>>> referenced by tc_encap_actions.c
>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a
>>> referenced by tc_encap_actions.c
>>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a

Fixes: a1e82162af0b8 ("sfc: generate encap headers for TC offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/sfc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 4af36ba8906ba..3eb55dcfa8a61 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -50,6 +50,7 @@ config SFC_MCDI_MON
 config SFC_SRIOV
 	bool "Solarflare SFC9100-family SR-IOV support"
 	depends on SFC && PCI_IOV
+	depends on INET
 	default y
 	help
 	  This enables support for the Single Root I/O Virtualization
-- 
2.39.2


