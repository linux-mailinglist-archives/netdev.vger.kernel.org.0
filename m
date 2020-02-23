Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19CC1696A4
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBWHcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41264 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBWHb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so6660376wrw.8
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/imzZD4h2wg5T3TmojPrsDRQ7BGfPFIf0wSK6Ur8vo=;
        b=cO2cQI18pO304Jep7MnDwd7gn0EjyZqK0OzCAoUWM6xAnHwLSV+tp72n43DZNcGvkR
         qU7ks8TUMCjYjvBX5Iozodk6Gb2JYg+YlMeVxiGPdgfsqvJGX2Md+3F2vtztbMlu4rJW
         jZ1Ynt1BEK72nAZou/Fh3aNjHHxXbqVtW3SmU8Dz7Qjpoesv0VgvjqO8n2zdm0TZWew2
         FeR8b6uwnuLWqS0vcR2z3nTL+Cof0dpiqLSHkKQLX7/2CwPPl73RLllAW+B7ZEjPjiUG
         usk8vGQ5YFu6KV4dyM+7EaPZ1GjGesT/IwUZkTAIk896Fo5RS5yDh7ru+Ie5Z45O6swM
         Emgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v/imzZD4h2wg5T3TmojPrsDRQ7BGfPFIf0wSK6Ur8vo=;
        b=IiKE6utsUs1JxmFLCm11Oqlk4Yw1Wt3SJ+nPgIYI3LvzsruhjfoVYEg0MAdbGIyNSr
         FNwSyEmUxjhSWMib7Ornbnn23KbxPo7v5cEh9ZVWrQ4yEbC+tpXhk9b+nKzcVrnzQvm+
         pxi1Nox+AgvNoeEl76vjtt+9NhutKYuOFsli/o159sH+w8ovOrNMRRtBWtWSRCZxYiw4
         Q7Z2FSMj91Tc0ufcxa1PwMXIIVeR3Gdx8OOvjfGtQnvbI1Mxajc5/9F+5+RF89MSnA/j
         Uk2Eicm16KCRAzOnvSeM/siN1mHCNqLVyQEDQbaKdhS18CHCpxq6BEf4d6hvqqCVuMUn
         JTlA==
X-Gm-Message-State: APjAAAWhUIgbEI9bTDwacw3QjNrQmAEi49fAZUoPVOECen8pna760ujW
        4x0sfyzVZ7Q1vHhDO+awpUIRZtIbiO4=
X-Google-Smtp-Source: APXvYqxjI+nyUujduEYxIPv8M4KVmAG0X0073EyHH3j22DsPtxUYZeAx8v6+BPuX/pLcRiFXu9gfpg==
X-Received: by 2002:adf:efc4:: with SMTP id i4mr2161387wrp.225.1582443117091;
        Sat, 22 Feb 2020 23:31:57 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b10sm9246963wmj.48.2020.02.22.23.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:56 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 10/12] mlxsw: spectrum_acl: Make block arg const where appropriate
Date:   Sun, 23 Feb 2020 08:31:42 +0100
Message-Id: <20200223073144.28529-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

There are couple of places where block pointer as a function argument
can be const. So make those const.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  7 ++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bb02a0361bfd..9335f6a01b87 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -670,10 +670,11 @@ struct mlxsw_sp_acl_block {
 
 struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
 struct mlxsw_sp *mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block);
-unsigned int mlxsw_sp_acl_block_rule_count(struct mlxsw_sp_acl_block *block);
+unsigned int
+mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block);
 void mlxsw_sp_acl_block_disable_inc(struct mlxsw_sp_acl_block *block);
 void mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block);
-bool mlxsw_sp_acl_block_disabled(struct mlxsw_sp_acl_block *block);
+bool mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block);
 struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
 						     struct net *net);
 void mlxsw_sp_acl_block_destroy(struct mlxsw_sp_acl_block *block);
@@ -686,7 +687,7 @@ int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_acl_block *block,
 			      struct mlxsw_sp_port *mlxsw_sp_port,
 			      bool ingress);
-bool mlxsw_sp_acl_block_is_egress_bound(struct mlxsw_sp_acl_block *block);
+bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 9368b93dab38..7b460c08f779 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -99,7 +99,8 @@ struct mlxsw_sp *mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block)
 	return block->mlxsw_sp;
 }
 
-unsigned int mlxsw_sp_acl_block_rule_count(struct mlxsw_sp_acl_block *block)
+unsigned int
+mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block)
 {
 	return block ? block->rule_count : 0;
 }
@@ -116,12 +117,12 @@ void mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block)
 		block->disable_count--;
 }
 
-bool mlxsw_sp_acl_block_disabled(struct mlxsw_sp_acl_block *block)
+bool mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block)
 {
 	return block->disable_count;
 }
 
-bool mlxsw_sp_acl_block_is_egress_bound(struct mlxsw_sp_acl_block *block)
+bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block)
 {
 	struct mlxsw_sp_acl_block_binding *binding;
 
@@ -163,7 +164,8 @@ mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
 			    binding->mlxsw_sp_port, binding->ingress);
 }
 
-static bool mlxsw_sp_acl_ruleset_block_bound(struct mlxsw_sp_acl_block *block)
+static bool
+mlxsw_sp_acl_ruleset_block_bound(const struct mlxsw_sp_acl_block *block)
 {
 	return block->ruleset_zero;
 }
-- 
2.21.1

