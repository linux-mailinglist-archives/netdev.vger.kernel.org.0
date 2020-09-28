Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA02C27B166
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgI1QGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:06:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60886 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgI1QGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 12:06:44 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kMvfm-00018L-BI; Mon, 28 Sep 2020 16:06:42 +0000
To:     Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: net/mlx5: Refactor tc flow attributes structure
Message-ID: <763ea1c6-ed2b-3487-113f-fb48c1cf27dc@canonical.com>
Date:   Mon, 28 Sep 2020 17:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

static analysis with Coverity has found a null pointer dereference issue
with the following commit:

commit c620b772152b8274031083bdb2e11c963e596c5c
Author: Ariel Levkovich <lariel@mellanox.com>
Date:   Thu Apr 30 05:54:08 2020 +0300

    net/mlx5: Refactor tc flow attributes structure

The analysis is as follows:

1240        slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);

    1. Condition !slow_attr, taking true branch.
    2. var_compare_op: Comparing slow_attr to null implies that
slow_attr might be null.

1241        if (!slow_attr)
1242                mlx5_core_warn(flow->priv->mdev, "Unable to
unoffload slow path rule\n");
1243
1244        memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);

Dereference after null check (FORWARD_NULL)
    3. var_deref_op: Dereferencing null pointer slow_attr.

1245        slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
1246        slow_attr->esw_attr->split_count = 0;
1247        slow_attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
1248        mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
1249        flow_flag_clear(flow, SLOW);
1250        kfree(slow_attr);

there is a !slow_attr check but if it slow_attr is null the code then
dereferences it multiple times afterwards.

Colin
