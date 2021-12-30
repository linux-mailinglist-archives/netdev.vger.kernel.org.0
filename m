Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669F548186C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhL3CQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:16:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45508 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhL3CQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:16:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A82B615BA
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 02:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5CEC36AE1;
        Thu, 30 Dec 2021 02:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640830611;
        bh=DnR7qWCPgwNT1eE/DjmK9+rcd+NT0yNHUOgKUMQbZyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V0NUy8FolBoRw2TLmorciCs1S14QD2rMuyKwJJnlMyx0g/Jl1vn7ee3XP0R0AEjtP
         dX+yr32ToQKU5sesCwnOlnEP6SDhIwEk7qfUv/LRdcd0bVXWSq0zNKSnb8Wl8P0XCg
         gZcHuBRa+xTa1SD1SVmXv3nZRF/TIk2L0mNmwtFMVEZLSDZ3sXdKK8GdmiMVF/tELj
         MaNLPWRZmNBhlVZaGwUAiF3uGvLH/1k0pXgEJ91VG/4X545NAHeh3v0Itz3Ggy0xzz
         oKzvkIshNoUExNSqleTmyTkl0HfJUkyMGaxnxWjD6Ylm2VgNJqOZEZZpsQ7dKC7IDo
         GDEIaC1QII2MA==
Date:   Wed, 29 Dec 2021 18:16:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Muhammad Sammar <muhammads@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next  07/16] net/mlx5: DR, Add support for dumping
 steering info
Message-ID: <20211229181650.33978893@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229062502.24111-8-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
        <20211229062502.24111-8-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 22:24:53 -0800 Saeed Mahameed wrote:
> From: Muhammad Sammar <muhammads@nvidia.com>
> 
> Extend mlx5 debugfs support to present Software Steering resources:
> dr_domain including it's tables, matchers and rules.
> The interface is read-only. While dump is being presented, new steering
> rules cannot be inserted/deleted.

Looks possibly written against debugfs API as it was a few releases ago?
The return values have changed, see below.

> +static void
> +dr_dump_hex_print(char *dest, u32 dest_size, char *src, u32 src_size)
> +{
> +	int i;
> +
> +	if (dest_size < 2 * src_size)
> +		return;
> +
> +	for (i = 0; i < src_size; i++)
> +		snprintf(&dest[2 * i], BUF_SIZE, "%02x", (u8)src[i]);

bin2hex()

> +}

> +static int
> +dr_dump_rule_mem(struct seq_file *file, struct mlx5dr_ste *ste,
> +		 bool is_rx, const u64 rule_id, u8 format_ver)
> +{
> +	char hw_ste_dump[BUF_SIZE] = {};

seems a little wasteful to zero-init this entire buffer

> +	u32 mem_rec_type;
> +
> +	if (format_ver == MLX5_STEERING_FORMAT_CONNECTX_5) {
> +		mem_rec_type = is_rx ? DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V0 :
> +				       DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V0;
> +	} else {
> +		mem_rec_type = is_rx ? DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V1 :
> +				       DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V1;
> +	}
> +
> +	dr_dump_hex_print(hw_ste_dump, BUF_SIZE, (char *)ste->hw_ste,
> +			  DR_STE_SIZE_REDUCED);
> +
> +	seq_printf(file, "%d,0x%llx,0x%llx,%s\n", mem_rec_type,
> +		   dr_dump_icm_to_idx(mlx5dr_ste_get_icm_addr(ste)), rule_id,
> +		   hw_ste_dump);
> +
> +	return 0;
> +}

> +void mlx5dr_dbg_init_dump(struct mlx5dr_domain *dmn)
> +{
> +	struct mlx5_core_dev *dev = dmn->mdev;
> +	char file_name[128];
> +
> +	if (dmn->type != MLX5DR_DOMAIN_TYPE_FDB) {
> +		mlx5_core_warn(dev,
> +			       "Steering dump is not supported for NIC RX/TX domains\n");
> +		return;
> +	}
> +
> +	if (!dmn->dump_info.steering_debugfs) {
> +		dmn->dump_info.steering_debugfs = debugfs_create_dir("steering",
> +								     dev->priv.dbg_root);
> +		if (!dmn->dump_info.steering_debugfs)

debugfs functions no longer return NULL.

> +			return;
> +	}
> +
> +	if (!dmn->dump_info.fdb_debugfs) {
> +		dmn->dump_info.fdb_debugfs = debugfs_create_dir("fdb",
> +								dmn->dump_info.steering_debugfs);
> +		if (!dmn->dump_info.fdb_debugfs) {

ditto, in fact you're not supposed to check the return values of these
functions at all, they all check if parent is an error pointer an exit
cleanly, so since this is a debug feature just carry on without error
checking

> +			debugfs_remove_recursive(dmn->dump_info.steering_debugfs);
> +			dmn->dump_info.steering_debugfs = NULL;
> +			return;
> +		}
> +	}
> +
> +	sprintf(file_name, "dmn_%p", dmn);
> +	debugfs_create_file(file_name, 0444, dmn->dump_info.fdb_debugfs,
> +			    dmn, &dr_dump_fops);
> +
> +	INIT_LIST_HEAD(&dmn->dbg_tbl_list);
> +	mutex_init(&dmn->dump_info.dbg_mutex);
> +}

