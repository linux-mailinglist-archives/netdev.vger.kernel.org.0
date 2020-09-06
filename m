Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0868C25EECF
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgIFPo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbgIFPi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:38:59 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4545208C7;
        Sun,  6 Sep 2020 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406671;
        bh=jHH/wPFyXijfn4qbxAJDIqeZ9sIT7sZEqBqRbDpc3/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7ocihmc3g81cmtKJS+kiq0LeUGmxxi2tg8cDi3WE4S/H2StDcgEEdtAxrjzXU7qb
         4Ng3Fv/8UzKs5ZpmceXdtbS+fxaPBiXHH3/IjPm0EcMIjpbPnfemO2fvCWaC3rGNj8
         nsZykmblUWGpNFX/OS5CnB9uS+z5um9z5Zq8XEjQ=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-nfc@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 6/9] nfc: s3fwrn5: Constify s3fwrn5_fw_info when not modified
Date:   Sun,  6 Sep 2020 17:36:51 +0200
Message-Id: <20200906153654.2925-7-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200906153654.2925-1-krzk@kernel.org>
References: <20200906153654.2925-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two functions accept pointer to struct s3fwrn5_fw_info but do not
modify the contents.  Make them const so the code is a little bit safer.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/nfc/s3fwrn5/firmware.c | 4 ++--
 drivers/nfc/s3fwrn5/firmware.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 69857f080704..ec930ee2c847 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -348,7 +348,7 @@ static int s3fwrn5_fw_get_base_addr(
 }
 
 static inline bool
-s3fwrn5_fw_is_custom(struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
+s3fwrn5_fw_is_custom(const struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
 {
 	return !!bootinfo->hw_version[2];
 }
@@ -399,7 +399,7 @@ int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
 	return ret;
 }
 
-bool s3fwrn5_fw_check_version(struct s3fwrn5_fw_info *fw_info, u32 version)
+bool s3fwrn5_fw_check_version(const struct s3fwrn5_fw_info *fw_info, u32 version)
 {
 	struct s3fwrn5_fw_version *new = (void *) &fw_info->fw.version;
 	struct s3fwrn5_fw_version *old = (void *) &version;
diff --git a/drivers/nfc/s3fwrn5/firmware.h b/drivers/nfc/s3fwrn5/firmware.h
index cf1a83a5a525..3c83e6730d30 100644
--- a/drivers/nfc/s3fwrn5/firmware.h
+++ b/drivers/nfc/s3fwrn5/firmware.h
@@ -91,7 +91,7 @@ struct s3fwrn5_fw_info {
 
 void s3fwrn5_fw_init(struct s3fwrn5_fw_info *fw_info, const char *fw_name);
 int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info);
-bool s3fwrn5_fw_check_version(struct s3fwrn5_fw_info *fw_info, u32 version);
+bool s3fwrn5_fw_check_version(const struct s3fwrn5_fw_info *fw_info, u32 version);
 int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info);
 void s3fwrn5_fw_cleanup(struct s3fwrn5_fw_info *fw_info);
 
-- 
2.17.1

