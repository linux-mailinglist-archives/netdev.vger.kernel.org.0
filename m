Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8CC124C4A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfLRPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:55:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39423 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfLRPzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 10:55:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so1495466pga.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 07:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=EsR9rpJgIYzhp8Peg3l/K9EGuv2xs5p6r3LJlvQU+/g=;
        b=Z+fey01UrudhUCIAtm/lXiBozAClYrdbmL9WmYvI2KnkW5TPC/5UOgGOw9shlhVAoi
         IO9WO9G5RLD6hddCQswWNddybLBlgEkcLn+OgxphCLdlOu3eCJD5X3ESB2+FvRG92qH0
         zat6WYXE+saTlcE06ZKDSxLqP9LHJGt5xB+MkKHYBJGaRa4CLoWbAamW5lkz0XFmZLQS
         TbyhqxvfsVSLEvPPO/FeOhcuSQh+gsNtgpLQuf0s2gn8lH65IxYdoGJxF/51pFNuq33x
         w8nJTWFSwFCKmWwHQBGmWmSZAmco0HLsaaU8T/8l3ZkD5+fZUiR7IxVkuIZKfW8XUuTR
         b70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=EsR9rpJgIYzhp8Peg3l/K9EGuv2xs5p6r3LJlvQU+/g=;
        b=QRkByAeizIA+Bb2VwnQjqkVPxnDCHGIB68vAHvT4cnVyNRD99a1JqMnbEgrnBAwGmn
         VjSK/sug1TsGXqj7604gRJkxhMXo9KrVNfvJpxKnFqAprpJWagQeGy/aJuFADtSEvOUb
         E7HxGesti6kmnwGAqVP8KQbj0gScB+VuoOUcvNG2AlvYjnOcpg4gSrfraKp3VY8Xtn24
         l0ico81Tk6jzGsLMc+0St5IVt0LM5Svg0tvi5EJ18KsfrD/xurBURkVU77eT2iTiA9Pz
         0SF3KdVDO2V1avQeb3/g59rx2Hq2NBNP+vaXSArBpwLusZLKpFIcG13ZYyM/oxYFsjt5
         K6MQ==
X-Gm-Message-State: APjAAAVA9QY88MVN2N0DZUGriSf2WDVFZHb4K2Cm/xCfsxtlxneRmE4o
        Edd07/Kgc8M24W26Q8XKe0U=
X-Google-Smtp-Source: APXvYqxq79nn9HVBkd3IQkxdxqDCI3GW9jugYKFGAcJuAYQLoITF9kG6Pa1XYFpXjDBhzv7OhzCPLA==
X-Received: by 2002:a63:234f:: with SMTP id u15mr3797035pgm.88.1576684501926;
        Wed, 18 Dec 2019 07:55:01 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:ae2b:206e:59f8:9154:dc19])
        by smtp.gmail.com with ESMTPSA id 13sm3714550pfi.78.2019.12.18.07.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 07:55:01 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 48B3CC0F85; Wed, 18 Dec 2019 12:54:58 -0300 (-03)
Date:   Wed, 18 Dec 2019 12:54:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Guy Twig <guyt@mellanox.com>
Subject: refcount issue with net/mlx5: DR, Expose steering table functionality
Message-ID: <20191218155458.GB193062@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

(using a reply to the original patch as base for this email)

On Tue, Sep 03, 2019 at 08:04:44PM +0000, Saeed Mahameed wrote:
...
> +static int dr_table_init_nic(struct mlx5dr_domain *dmn,
> +			     struct mlx5dr_table_rx_tx *nic_tbl)
> +{
> +	struct mlx5dr_domain_rx_tx *nic_dmn = nic_tbl->nic_dmn;
> +	struct mlx5dr_htbl_connect_info info;
> +	int ret;
> +
> +	nic_tbl->default_icm_addr = nic_dmn->default_icm_addr;
> +
> +	nic_tbl->s_anchor = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
> +						  DR_CHUNK_SIZE_1,
> +						  MLX5DR_STE_LU_TYPE_DONT_CARE,
> +						  0);

[A]

> +	if (!nic_tbl->s_anchor)
> +		return -ENOMEM;
> +
> +	info.type = CONNECT_MISS;
> +	info.miss_icm_addr = nic_dmn->default_icm_addr;
> +	ret = mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
> +						nic_tbl->s_anchor,
> +						&info, true);
> +	if (ret)
> +		goto free_s_anchor;
> +
> +	mlx5dr_htbl_get(nic_tbl->s_anchor);

We have an issue here. mlx5dr_ste_htbl_alloc() above in [A] will:
        refcount_set(&htbl->refcount, 0);
and then, if no error happens, here it gets incremented. But:

static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
{
        refcount_inc(&htbl->refcount);

 * Will WARN if the refcount is 0, as this represents a possible use-after-free
 * condition.
 */
static inline void refcount_inc(refcount_t *r)
{
        refcount_add(1, r);

and that's exactly what happens here (commit 2187f215ebaac73ddbd814696d7c7fa34f0c3de0):
[  163.379526] mlx5_core 0000:82:00.0: E-Switch: Disable: mode(LEGACY), nvfs(4), active vports(5)
[  166.862171] ------------[ cut here ]------------
[  166.867331] refcount_t: addition on 0; use-after-free.
[  166.873094] WARNING: CPU: 49 PID: 5414 at lib/refcount.c:25 refcount_warn_saturate+0x6d/0xf0
[  166.882511] Kernel panic - not syncing: panic_on_warn set ...
[  166.888923] CPU: 49 PID: 5414 Comm: devlink Kdump: loaded Not tainted 5.5.0-rc2+ #2
...
[  166.955337] RIP: 0010:refcount_warn_saturate+0x6d/0xf0
...
[  167.027666]  ? refcount_warn_saturate+0x6d/0xf0
[  167.032772]  dr_table_init_nic+0xd1/0xe0 [mlx5_core]
[  167.038339]  mlx5dr_table_create+0x12e/0x260 [mlx5_core]
[  167.044290]  mlx5_cmd_dr_create_flow_table+0x31/0xd0 [mlx5_core]
[  167.051013]  __mlx5_create_flow_table+0x222/0x680 [mlx5_core]
[  167.057450]  esw_create_offloads_fdb_tables+0x169/0x4c0 [mlx5_core]
[  167.064468]  esw_offloads_enable+0x16c/0x510 [mlx5_core]
[  167.070417]  ? mlx5_add_device+0x9d/0xe0 [mlx5_core]
[  167.075982]  mlx5_eswitch_enable+0xf9/0x4f0 [mlx5_core]
[  167.081838]  mlx5_devlink_eswitch_mode_set+0x11b/0x1b0 [mlx5_core]
[  167.088738]  devlink_nl_cmd_eswitch_set_doit+0x44/0xc0
[  167.094466]  genl_rcv_msg+0x1f9/0x440
[  167.098545]  ? genl_family_rcv_msg_attrs_parse+0x110/0x110
[  167.104666]  netlink_rcv_skb+0x49/0x110
[  167.108945]  genl_rcv+0x24/0x40
[  167.112449]  netlink_unicast+0x1a5/0x280
[  167.116825]  netlink_sendmsg+0x23d/0x470
[  167.121202]  sock_sendmsg+0x5b/0x60
[  167.125093]  __sys_sendto+0xee/0x160

One quick fix is to just initialize it as 1.  I was sketching a patch
but gave up as mlx5dr_ste_htbl_alloc() also does:
                refcount_set(&ste->refcount, 0);

and it is used like:
bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
{
        return !refcount_read(&ste->refcount);

So the same easy fix doesn't work here and:

static inline void mlx5dr_ste_put(struct mlx5dr_ste *ste,
                                  struct mlx5dr_matcher *matcher,
                                  struct mlx5dr_matcher_rx_tx *nic_matcher)
{
        if (refcount_dec_and_test(&ste->refcount))
                mlx5dr_ste_free(ste, matcher, nic_matcher);

On which, AFAICT, removes it from the HW but not free the STE entry
itself. So I think that the usage of refcount_dec_and_test() would be
broken here if we just offset the refcount by 1.

Thoughts?

> +
> +	return 0;
> +
> +free_s_anchor:
> +	mlx5dr_ste_htbl_free(nic_tbl->s_anchor);
> +	return ret;
> +}
> +
