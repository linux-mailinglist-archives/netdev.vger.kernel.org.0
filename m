Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EAE50F5BD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbiDZIwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346830AbiDZIuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9358F17036C;
        Tue, 26 Apr 2022 01:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38DA60EC4;
        Tue, 26 Apr 2022 08:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE4C385A0;
        Tue, 26 Apr 2022 08:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962343;
        bh=0up0+3ng2gkf9fVKVYD32dBPHhE8G+CBylS47GayzIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWI0JbGVGsEv4oPzWvXV906D9sanRp/IGzO2cnUhssFQpGWpPkxORT/Kk6az57i/K
         /4LC2iS/uLw9cDQs7rdtDZji9xaIhuOxMG0/3mfsXmQ2bLtiyBvofE0iUnM1kTjmyq
         uuu6JRrj7ammpi4K0VJLg17XuZ6YvMIZr6oSNDVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/124] brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 26 Apr 2022 10:21:05 +0200
Message-Id: <20220426081749.121241727@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

[ Upstream commit 6fb3a5868b2117611f41e421e10e6a8c2a13039a ]

Fix:

  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c: In function ‘brcmf_sdio_drivestrengthinit’:
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3798:2: error: case label does not reduce to an integer constant
    case SDIOD_DRVSTR_KEY(BRCM_CC_43143_CHIP_ID, 17):
    ^~~~
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:3809:2: error: case label does not reduce to an integer constant
    case SDIOD_DRVSTR_KEY(BRCM_CC_43362_CHIP_ID, 13):
    ^~~~

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: netdev@vger.kernel.org
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/Ykx0iRlvtBnKqtbG@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5d156e591b35..f7961b22e051 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -557,7 +557,7 @@ enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_SUB,
 };
 
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((unsigned int)(chip) << 16) | (pmu))
 
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
-- 
2.35.1



