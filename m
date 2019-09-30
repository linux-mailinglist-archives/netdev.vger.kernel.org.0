Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3ACC284F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfI3VKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:10:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33286 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfI3VKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 17:10:07 -0400
Received: from zn.tnic (p200300EC2F058B00329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:8b00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BE3CA1EC0586;
        Mon, 30 Sep 2019 20:40:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569868833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gjuUURFhig2Mz245AWDhCbYKl1S5jT5FaViGxJ9r5BM=;
        b=BGeaWwcS2WkEs3PpXGJ+M/oYTYqveWi8TBVzB9Z9QCa9AOXoz0DxVEE+kx/LUm/1PByTBJ
        Wmgbz0Ek39oXPN97PJD0tNRCehX34b7ht6qypukdtM6ZMS4hjU7D2ceIlaPt3cd0n0KJYF
        dFdKLlWw1DdAA4JHroy+YjbPf1GTFyk=
Date:   Mon, 30 Sep 2019 20:40:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930184031.GJ29694@zn.tnic>
References: <20190930141316.GG29694@zn.tnic>
 <20190930154535.GC22120@unicorn.suse.cz>
 <20190930162910.GI29694@zn.tnic>
 <20190930095516.0f55513a@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190930095516.0f55513a@hermes.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 09:55:16AM -0700, Stephen Hemminger wrote:
> Could also us div_u64_rem here?

Yah, the below seems to work and the resulting asm looks sensible to me
but someone should definitely double-check me as I don't know this code
at all.

Thx.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 913f1e5aaaf2..b4302658e5f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -137,7 +137,7 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
 
 	icm_mr->icm_start_addr = icm_mr->dm.addr;
 
-	align_diff = icm_mr->icm_start_addr % align_base;
+	div_u64_rem(icm_mr->icm_start_addr, align_base, &align_diff);
 	if (align_diff)
 		icm_mr->used_length = align_base - align_diff;
 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
