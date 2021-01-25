Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F3A304ACC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbhAZE5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbhAYMKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:10:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44EBE22AAA;
        Mon, 25 Jan 2021 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611574561;
        bh=BZfbuSURKnkXQKRffrZynYjAYt2pvrMVX3otNME949I=;
        h=From:To:Cc:Subject:Date:From;
        b=kLyTrI57IOeN5+8ySHG6sqb5MlnMqkxgupnU6fzeabSJOK8Rvn/XxyG4Mi9x64/RX
         ZzUgUZYsPhDQ9hT4cdYOyT/2zNXass0nQcFjY4CwmiW9BcZXOX9rR+exbh2r5Y4YgR
         JemhqwaRmUpEUHb9SgluNCnr8RQsp0iOCY9I5WoVY1vG5XXVK9iuQtS0bweo8yvNnF
         S+fqjv04/QLDHL4w5pmpMWcu6ydDQD0Hw06l6hSQHTiAsh6S7vKDA1mgSECx2I0anh
         5KkxIkzc3Ma6PMp/XvcCph3yPDAvo+PtmxXvfCMTTh93oyP2a9i8VeP4z3kDw7wMGm
         42O1M3sPvTX9w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] ipa: add remoteproc dependency
Date:   Mon, 25 Jan 2021 12:35:50 +0100
Message-Id: <20210125113557.2388311-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Compile-testing without CONFIG_REMOTEPROC results in a build failure:

>>> referenced by ipa_main.c
>>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
ld.lld: error: undefined symbol: rproc_put
>>> referenced by ipa_main.c
>>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
>>> referenced by ipa_main.c
>>>               net/ipa/ipa_main.o:(ipa_remove) in archive drivers/built-in.a

Add a new dependency to avoid this.

Fixes: 38a4066f593c ("net: ipa: support COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ipa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index b68f1289b89e..aa1c0ae3cf01 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -3,6 +3,7 @@ config QCOM_IPA
 	depends on 64BIT && NET && QCOM_SMEM
 	depends on ARCH_QCOM || COMPILE_TEST
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
+	depends on REMOTEPROC
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_QMI_HELPERS
 	help
-- 
2.29.2

