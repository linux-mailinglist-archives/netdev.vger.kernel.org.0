Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0FD27B811
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgI1XZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgI1XZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:25:48 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6038B2076A;
        Mon, 28 Sep 2020 23:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601335547;
        bh=iCS/ts0ASN16IaSHlp9cyi3HjNkN+HRIvd/XP8pvAIQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yT/rXRN14s6cXs7QXCmvczxg7To5+F3E9YvR7u89N7F1/ThSmeh4i26FMi1KP68ZD
         8VCD0LpcJjhQ+tssv6gLf8Ho4MKRBzben9Xk9aBeUE7ZOrUqRkr6S0ODP36CkKsIF7
         J/mc5fHDWC6/dsDx74ywdc64bITrVDIOElcyZ01o=
Message-ID: <64f6a3eaaac505c341f996df0b0877ee9af56c00.camel@kernel.org>
Subject: Re: net/mlx5: Refactor tc flow attributes structure
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin Ian King <colin.king@canonical.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Mon, 28 Sep 2020 16:25:46 -0700
In-Reply-To: <763ea1c6-ed2b-3487-113f-fb48c1cf27dc@canonical.com>
References: <763ea1c6-ed2b-3487-113f-fb48c1cf27dc@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-28 at 17:06 +0100, Colin Ian King wrote:
> Hi,
> 
> static analysis with Coverity has found a null pointer dereference
> issue
> with the following commit:
> 
> commit c620b772152b8274031083bdb2e11c963e596c5c
> Author: Ariel Levkovich <lariel@mellanox.com>
> Date:   Thu Apr 30 05:54:08 2020 +0300
> 
>     net/mlx5: Refactor tc flow attributes structure
> 
> The analysis is as follows:
> 
> 1240        slow_attr =
> mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
> 
>     1. Condition !slow_attr, taking true branch.
>     2. var_compare_op: Comparing slow_attr to null implies that
> slow_attr might be null.
> 
> 1241        if (!slow_attr)
> 1242                mlx5_core_warn(flow->priv->mdev, "Unable to
> unoffload slow path rule\n");
> 1243
> 1244        memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
> 
> Dereference after null check (FORWARD_NULL)
>     3. var_deref_op: Dereferencing null pointer slow_attr.
> 
> 1245        slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> 1246        slow_attr->esw_attr->split_count = 0;
> 1247        slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
> 1248        mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
> 1249        flow_flag_clear(flow, SLOW);
> 1250        kfree(slow_attr);
> 
> there is a !slow_attr check but if it slow_attr is null the code then
> dereferences it multiple times afterwards.
> 
> Colin

Thanks Colin for the Report,

Ariel is handling this internally and we will be posting the patch
soon.



