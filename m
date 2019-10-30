Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988DEEA162
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfJ3QCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:02:17 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40749 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfJ3QCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 12:02:16 -0400
Received: by mail-ot1-f65.google.com with SMTP id d8so2567696otc.7;
        Wed, 30 Oct 2019 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Io+g/Mop1YTO7IEeBRV6yOSmnttfivb/SWZtZYVfkLU=;
        b=rrZwX3M614HUB1QzRH0h8zC9UfyKHcbaXzNo9WeFt6hAxhK/EIOLuHA5VowG5k/7M1
         9TNp2/F06fJplrOREF7SilqiobyoD5l+j1L7Frx/WnD2ET0Fes8HEI1KB2MKAYWT5P43
         wlEEJCfHRxmUsrhCl9T5toj1xlRnmq3vDKBKmVhL8s1M3RfoIaF4fnTpCV3HDyC862Mg
         f9/D7R/lVUIMRaPLp5Jb7gXAySTVkTrvAfVE08styByL1LJhCjqB0bSMakInQhXt68VU
         s4Gi4AtYJFDjNiYDKzLi3hhioJ3NhjDIpB2ACEjNCghsPHaOz49ml6/tE3T5QXGeoefJ
         GkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Io+g/Mop1YTO7IEeBRV6yOSmnttfivb/SWZtZYVfkLU=;
        b=C4g7cROdYodD2AHkjvx22thIOVaRvax6tAweFHRhP8LNmc5h35dn0XKVJugisus+h6
         l6ZvKYYnz5NVZ7ItAWb8oRaRcVPrsdOTv54apnu+4c/abAraTdwFEH79SWyHBy4cLQhd
         SXDOmUytz63s8QOl+fwbxsmdn9Kzs1UAELlCkLDZZK9NkuQLvxxY6/smNUnBS1mHDkkw
         +PvHedzrW+VVjb7Nv4bRDAQOgo5jMIaBHKjF1DgR12YLSDq1DeOcoj1zxJF+uUi0BizQ
         6JxWt3mUBhiKpsdWb1o77EFOcujgiFwAg/P7coM+lW3VARW5OXXdt1AmI2Thf/BIiXNf
         C/aA==
X-Gm-Message-State: APjAAAXRRyYSmZTOPhA2Ba31HGKHzoCmpyRmE9beKAqgxGRH/nJWLUKa
        H5Sck4prNc3Opb97rZgj3fY=
X-Google-Smtp-Source: APXvYqxqGe7NQskyZekS8CGgFbCef9gYqCVGPeORga0Wgh98IHDBt0IuR+og2dT9OOYAkVfpClfCzw==
X-Received: by 2002:a9d:509:: with SMTP id 9mr536124otw.70.1572451334923;
        Wed, 30 Oct 2019 09:02:14 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id j129sm108696oib.22.2019.10.30.09.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 09:02:14 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] mlxsw: Fix 64-bit division in mlxsw_sp_sb_prs_init
Date:   Wed, 30 Oct 2019 09:01:52 -0700
Message-Id: <20191030160152.11305-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building for 32-bit ARM, there is a link time error because of a
64-bit division:

ld.lld: error: undefined symbol: __aeabi_uldivmod
>>> referenced by spectrum_buffers.c
>>>               net/ethernet/mellanox/mlxsw/spectrum_buffers.o:(mlxsw_sp_buffers_init) in archive drivers/built-in.a
>>> did you mean: __aeabi_uidivmod
>>> defined in: arch/arm/lib/lib.a(lib1funcs.o

Avoid this by using div_u64, which is designed to avoid this problem.

Fixes: bc9f6e94bcb5 ("mlxsw: spectrum_buffers: Calculate the size of the main pool")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 33a978af80d6..968f0902e4fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -470,7 +470,7 @@ static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
 				size_t prs_len)
 {
 	/* Round down, unlike mlxsw_sp_bytes_cells(). */
-	u32 sb_cells = mlxsw_sp->sb->sb_size / mlxsw_sp->sb->cell_size;
+	u32 sb_cells = div_u64(mlxsw_sp->sb->sb_size, mlxsw_sp->sb->cell_size);
 	u32 rest_cells[2] = {sb_cells, sb_cells};
 	int i;
 	int err;
-- 
2.24.0.rc1

