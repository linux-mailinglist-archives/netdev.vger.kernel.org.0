Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CAB169F5B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgBXHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39424 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgBXHgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so277015wrn.6
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D/vezMMSkQJsA1qL8pdv/4qz24vhqd+AJCIDaGOEKP8=;
        b=QwefrVpx+zwd5lIxWP4gMVE71Q07f6I1GcemsRXeIrlEo9XNLyZ7wLEt0E57NOoaLf
         VHEu6XVZAmBoaJKfspSsjyxMbTcMOOc/oED4K/rz3dPVtLH99osTbr8ECiBCc1ulpe9N
         sjIXE1+DzoNJisghs78dOeipUa174t3RMsllNL7pWX+NtWNkoGJGeGsGUEhb85Cctw65
         F3Pfq1dDdZXygcPhCKE13TJcvP7Kh6XDcepIvBDOFNYHWKkJP3+pRlqVPnBWcT/N3zEf
         soTlYAY1veLvHOEsb6yWdWYTiFgNGAMtw6WSCXOkYQndEbR9JG36DJacugqaNab09FQ6
         8KIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/vezMMSkQJsA1qL8pdv/4qz24vhqd+AJCIDaGOEKP8=;
        b=jdfvGcmrPdD/AR1xD/NXlHz/h4gMoTB+gw5WJydBm40T0vJ/AJ60ymC0QG3IlAuGgL
         9bnJTQc3neBex29eBvF5whRA7G0rG+yvxK0Ck/wHubR4rSwqznakZ5Bfa8Tt+SNTNMgj
         39dGFiKmVrAvyFrnRc3RATjU1hC1BdAIVyjuDbj0F4WDpWdkCPg0dBeo7q7UECN5MFlC
         dIxwoHLLwwDXZKfMpLDUt2l8TObsaKM7154ECtKqFTdNFC3NDrWcTXel4vDiB4a41RyQ
         FcHlq/HkOeyg4XHPK8zetgf/cJm8bPWVAUyYMg/iawJLv66khlFkcNfaqMz8EakemZxg
         8AZg==
X-Gm-Message-State: APjAAAUmJDfJH//TLbNuUxoJDmgDlP9AEncgq+CQJ/l6NcFgjESDkRes
        QRt7EiP83ePx0oKGtg+ogQ6AVub2f6o=
X-Google-Smtp-Source: APXvYqxULVY4xkvuEya7NVgJZfqAaxSmmLFm7YMw8Jr0XGYM5kculpirqmIOUBVpfxV7wejJVMIRpA==
X-Received: by 2002:adf:dfc7:: with SMTP id q7mr11715603wrn.45.1582529770808;
        Sun, 23 Feb 2020 23:36:10 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id w7sm16142443wmi.9.2020.02.23.23.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:10 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 09/16] mlxsw: acl_flex_actions: Trap all ACL dropped packets to DISCARD_*_ACL traps
Date:   Mon, 24 Feb 2020 08:35:51 +0100
Message-Id: <20200224073558.26500-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce a new set of traps:
DISCARD_INGRESS_ACL and DISCARD_EGRESS_ACL
Set the trap_action from NOP to TRAP which causes the packets dropped
by the TRAP action to be trapped under new trap IDs, depending on the
ingress/egress binding point.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/trap.h                  | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index b0e587583528..424ef26e6cca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -820,8 +820,10 @@ int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress)
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
-	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_NOP,
-			    MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD, 0);
+	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_TRAP,
+			    MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD,
+			    ingress ? MLXSW_TRAP_ID_DISCARD_INGRESS_ACL :
+				      MLXSW_TRAP_ID_DISCARD_EGRESS_ACL);
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_drop);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 12e1fa998d42..eaa521b7561b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -102,6 +102,8 @@ enum {
 	MLXSW_TRAP_ID_ACL1 = 0x1C1,
 	/* Multicast trap used for routes with trap-and-forward action */
 	MLXSW_TRAP_ID_ACL2 = 0x1C2,
+	MLXSW_TRAP_ID_DISCARD_INGRESS_ACL = 0x1C3,
+	MLXSW_TRAP_ID_DISCARD_EGRESS_ACL = 0x1C4,
 
 	MLXSW_TRAP_ID_MAX = 0x1FF
 };
-- 
2.21.1

