Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087FA14E6E3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 02:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgAaBv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 20:51:27 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39665 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgAaBv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 20:51:26 -0500
Received: by mail-oi1-f193.google.com with SMTP id z2so5746173oih.6;
        Thu, 30 Jan 2020 17:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fl3y9i/hsTxIwnZSASPstfQUlkaJEnvewj9PCAZ8wpg=;
        b=AVjQIxK+cWHt1fRrYYSTlgDBe0w+hAAuz5j7Po22kbEioXSkYQ9WTbufUNmIDHoir3
         KQ5upmyQPcfxi+FZSAnNWRQBvknNdVDosAxuTJAXmABYXLPJ7LTydw7i/lJM98XdPzhs
         SgJlBd2sAiig+eSd6H+q0tVW/1axJckHjiVEOTHVqfeSXdM8J2oLNK5C/9wTRF/+xRTP
         1bTUsRl+nsJnPW1vSsIpAB/OyrX71fXUWP+uWZTEl0tpwfwg3uttcwrdCBw9uHzGtNay
         p8GgqEalyPrhNMfkPwqtTJQaAbimuehrdKbOF+e7ZPsE5poDyPg50Lw5ePiPUDrmsZZE
         +Lqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fl3y9i/hsTxIwnZSASPstfQUlkaJEnvewj9PCAZ8wpg=;
        b=gVUmaopafuY7m3zR8v2eVl4cO32DOMofKgOOv+FVxoxAvUWtPD+SlqAJy1eBlTKeLc
         pCGcz2Ca1E0jDUbj/6OwHLWoT0qV95v+nE3c01R3FsEocqAfx3w6SFNdmfoAVDAcrzp9
         l5T27VbPPcB5XadVkniV2cJNfa0CCFKpJZkqpXF5pEjtJQNPZ0ibB0iWMLSIHpdRUTtx
         DvxIuNxn6sLckbJM/mPmcFeaK84+UUlM+1PGtTU5w0L3jaxA2hTrTfir9ArLznspSIdb
         ioJPjBhrv1U3FnqRpHRjaSWKBAyJ8EabwPm4oVARcjDvthCGaXKn1HFw9Af9onbxzR1R
         kUtA==
X-Gm-Message-State: APjAAAVhQWlBNsdRrE96JgxsLno0ajlzrxrA/6+DqZqbx0nI9XRG2jzD
        w3XhTI6c0Zb6iXcIIyeFWmo=
X-Google-Smtp-Source: APXvYqxsQiPaQluUgLd84+fBfr/mdmnjHDre5AWqK75KvnbwfM1Qw3p/kJzL6jeMrI5UZ3+LC0Wn1w==
X-Received: by 2002:aca:fd4c:: with SMTP id b73mr5083041oii.33.1580435485997;
        Thu, 30 Jan 2020 17:51:25 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id p83sm2240185oia.51.2020.01.30.17.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 17:51:25 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] mlxsw: spectrum_qdisc: Fix 64-bit division error in mlxsw_sp_qdisc_tbf_rate_kbps
Date:   Thu, 30 Jan 2020 18:51:23 -0700
Message-Id: <20200131015123.55400-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130232641.51095-1-natechancellor@gmail.com>
References: <20200130232641.51095-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building arm32 allmodconfig:

ERROR: "__aeabi_uldivmod"
[drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!

rate_bytes_ps has type u64, we need to use a 64-bit division helper to
avoid a build error.

Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Fix incorrect math as pointed out by Randy Dunlap

 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 79a2801d59f6..02526c53d4f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -614,7 +614,7 @@ mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
 	/* TBF interface is in bytes/s, whereas Spectrum ASIC is configured in
 	 * Kbits/s.
 	 */
-	return p->rate.rate_bytes_ps / 1000 * 8;
+	return div_u64(p->rate.rate_bytes_ps, 1000) * 8;
 }
 
 static int
-- 
2.25.0

