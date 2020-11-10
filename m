Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050F12AD26F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgKJJZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:25:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7624 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgKJJZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:25:53 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVjC60GDbzLtH3;
        Tue, 10 Nov 2020 17:25:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Nov 2020
 17:25:45 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <rjw@rjwysocki.net>, <fugang.duan@nxp.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3 0/2] Fix usage counter leak by adding a general sync ops
Date:   Tue, 10 Nov 2020 17:29:31 +0800
Message-ID: <20201110092933.3342784-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many case, we need to check return value of pm_runtime_get_sync,
but it brings a trouble to the usage counter processing. Many callers
forget to decrease the usage counter when it failed, which could
resulted in reference leak. It has been discussed a lot[0][1]. So we
add a function to deal with the usage counter for better coding and
view. Then, we replace pm_runtime_resume_and_get with it in fec_main.c
to avoid it.

[0]https://lkml.org/lkml/2020/6/14/88
[1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139

Zhang Qilong (2):
  PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
  net: fec: Fix reference count leak in fec series ops

 drivers/net/ethernet/freescale/fec_main.c | 12 +++++-------
 include/linux/pm_runtime.h                | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.25.4

