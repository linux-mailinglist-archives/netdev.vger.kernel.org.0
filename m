Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EC1521473
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiEJMBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241357AbiEJMBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:01:03 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37405621F;
        Tue, 10 May 2022 04:56:59 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q23so23467834wra.1;
        Tue, 10 May 2022 04:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2t86GsxxQCOXc7EgWNUk13OwUnuONO2I3QktFbXcLq0=;
        b=OR1TECOwfjNA8il0E0nPw9JPl4lfp1fvFM6BsvWoF7FsvICL0kRXbT3f5C2Zk6kSb3
         gro+weGUjXCkn8d5ZBxVzzW076qZCkavvEgT6lIh7m2R/BJSwZh+dBBEl4qqqTgbO/4t
         fIv7yEKPoyI73f/FJuyR5yD55O6tiVeyIW85icMJyN4Ey2wF2lrYJnM4k91tN7PFLWA6
         Np/iXc2IC98QZJoH2MS/gimRlzEf8iLgUj8VmL+2Lak7dVamAxBsO/QF5GNGdZ3MFl4S
         H+C6vmDhWD+dLPXEeWaIZgD0yDVWGuhTBy3Chftho2RjYBBIbCkQyu/vL3LPiM7wPmKy
         pNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2t86GsxxQCOXc7EgWNUk13OwUnuONO2I3QktFbXcLq0=;
        b=xdFIysQA67A1WHatWXty4PG0GvXtqWwR4lO50erL+C0NRqK93aCJXjzb+/E+9TIWnz
         qiARCCrpQ2jyLArhY6VgP7VfAb6bM3B+Hy+1SeIK+D0LYMJ82frBPNWbrAKmzyoke3bv
         Ylq8HF1uhhN7ubK1LuQRjUgMJNuboc5DyWBfu7fsjqzAjjallk85Oe3W8ZORFzAAnHGE
         WNFY75Z3lQvmy+8JF04amfcyxIOYfxqeGt7x35UyZQeoemwS9Xt/xbSHEiJ+yxll3Y3i
         p4Qb6Sh2jRAuM+DRXc/0+g5uitnZat8Ys1SfCDO4/e+SrdV7cZoRnaqE9MSN2Dt1VfYR
         HinQ==
X-Gm-Message-State: AOAM530VXFea3+X1raXEeV/zPN9xMKtm+Xw2/heOPEdQRmsjrl1T3fpt
        3POrNQXXHqCYhgj6eB2zOn9P0VWStvoagLOG
X-Google-Smtp-Source: ABdhPJyz03V4eUcGH6YmlQpPGrn6SkIuyyTIjhBFwZddke4jwEd1GAsUZnvTBTZLtpsWqgVqoKCyow==
X-Received: by 2002:adf:cd8f:0:b0:20c:d681:aec3 with SMTP id q15-20020adfcd8f000000b0020cd681aec3mr2248440wrj.166.1652183817643;
        Tue, 10 May 2022 04:56:57 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:57 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 6/9] selftests: xsk: cleanup veth pair at ctrl-c
Date:   Tue, 10 May 2022 13:56:01 +0200
Message-Id: <20220510115604.8717-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the veth pair when the tests are aborted by pressing
ctrl-c. Currently in this situation, the veth pair is left on the
system polluting the netdev space.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index d06215ee843d..567500299231 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -97,6 +97,13 @@ NS0=root
 NS1=af_xdp${VETH1_POSTFIX}
 MTU=1500
 
+trap ctrl_c INT
+
+function ctrl_c() {
+        cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	exit 1
+}
+
 setup_vethPairs() {
 	if [[ $verbose -eq 1 ]]; then
 	        echo "setting up ${VETH0}: namespace: ${NS0}"
-- 
2.34.1

