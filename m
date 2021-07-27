Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199F53D75BA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhG0NSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbhG0NSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E58C061757;
        Tue, 27 Jul 2021 06:18:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id r2so15242582wrl.1;
        Tue, 27 Jul 2021 06:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7zIgbgW6/DPdT5XF0HKQ5fkIrROov4Vv/7AX2hWIEM=;
        b=P8XBgNESgl7FFmSGfdDEocZT4Mq1wcByAgJsoJA8zjJo5c7ghwrTAuuwNfJi75zKtz
         7uDZnZR2xSBY3AI+ClHENZSfx74m7/ZZTFtWFh//1eLhp6ZS2oxJvRTMmrl+G1h/WWSW
         IekinN6M8dMo4ctlrdcMJ4kSBfzuhNvdVra+7UPVwjNAB8YYTpCE+5gRTu3zOdfP6QWk
         nOHPnNlLEkdiOAZDfKTvYYcUURzIfgvSz+EqIPT5vXZpbusqFaLoAwHOurqPEF2gs05S
         nVneLH27D4XF6k2wK4hOImt+DV83FFzHNVHLGFUOpL0JgmgbsKgOxG4kV2Gdy/ZemWhI
         M1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7zIgbgW6/DPdT5XF0HKQ5fkIrROov4Vv/7AX2hWIEM=;
        b=DxDNWnX/A9Ws+aCx+f2SB38yN/edsZjpUFjF6+onjiDZ7BSn6WQVL5ye+wq9oMLxcu
         JC89HhkTWX7s/C/NEXQ+iktvH6QjcWIvk1j9pn7gLRu+kC1Wy8lpi2GT1PWPSWLgviaZ
         jH7Kwh6paezrUdqZwQ9FUCxn0wxFIjs1EvlmiyxNrvSptW5j+I0ciuxaV2FT8xib9bQA
         DXh73LHHC4moVcZVW2kcpwZB5yVc3I4nqL+AlnI3NbKvz6NllTrwYgQamV6Gov3lgwAS
         bIpZ3eKpNKEJlRMHesjUYMi0DP2C+5SpkwK0z+iB+k28GSJOinGYHQL/DhsAejGGFan6
         MfNg==
X-Gm-Message-State: AOAM533pBVVOZWGSfZgO02yWSFjWz7uzLgQGQtR3uf4MWbpnbMsUVl0D
        0Dui9NZCg0qPRDp3kPVyyx7UwiLviZJWP4HkKBSorg==
X-Google-Smtp-Source: ABdhPJwhL5f8EmPl2wVHs2C4iy4tIDNPbnDzKpg6XX4TDnm3eVeIMS+7szZLgg5gHnyEtBEM2vZlCA==
X-Received: by 2002:a5d:5541:: with SMTP id g1mr9978826wrw.29.1627391893788;
        Tue, 27 Jul 2021 06:18:13 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:13 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 04/17] selftests: xsk: set rlimit per thread
Date:   Tue, 27 Jul 2021 15:17:40 +0200
Message-Id: <20210727131753.10924-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Set rlimit per thread instead of on the main thread. The main thread
does not register any umem area so do not need this.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 4d8ee636fc24..2100ab4e58b7 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -252,6 +252,7 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 
 static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 {
+	const struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
@@ -263,6 +264,10 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 	struct xsk_umem_info *umem;
 	int ret;
 
+	ret = XSK_UMEM__DEFAULT_FRAME_SIZE;
+	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
+		exit_with_error(errno);
+
 	umem = calloc(1, sizeof(struct xsk_umem_info));
 	if (!umem)
 		exit_with_error(errno);
@@ -1088,13 +1093,9 @@ static void run_pkt_test(int mode, int type)
 
 int main(int argc, char **argv)
 {
-	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	bool failure = false;
 	int i, j;
 
-	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
-		exit_with_error(errno);
-
 	for (int i = 0; i < MAX_INTERFACES; i++) {
 		ifdict[i] = malloc(sizeof(struct ifobject));
 		if (!ifdict[i])
-- 
2.29.0

