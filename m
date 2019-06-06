Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628523689B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFFAIx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jun 2019 20:08:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:08:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D204B13AEF259;
        Wed,  5 Jun 2019 17:08:52 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:08:52 -0700 (PDT)
Message-Id: <20190605.170852.389314570750893823.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [PATCH 1/1] net: rds: fix memory leak when unload rds_rdma
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
References: <1559566099-30289-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:08:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Mon,  3 Jun 2019 08:48:19 -0400

> When KASAN is enabled, after several rds connections are
> created, then "rmmod rds_rdma" is run. The following will
> appear.
 ...
> This is rds connection memory leak. The root cause is:
> When "rmmod rds_rdma" is run, rds_ib_remove_one will call
> rds_ib_dev_shutdown to drop the rds connections.
> rds_ib_dev_shutdown will call rds_conn_drop to drop rds
> connections as below.
> "
> rds_conn_path_drop(&conn->c_path[0], false);
> "
> In the above, destroy is set to false.
 ...
> In the above function, destroy is set to false. rds_destroy_pending
> is called. This does not move rds connections to ib_nodev_conns.
> So destroy is set to true to move rds connections to ib_nodev_conns.
> In rds_ib_unregister_client, flush_workqueue is called to make rds_wq
> finsh shutdown rds connections. The function rds_ib_destroy_nodev_conns
> is called to shutdown rds connections finally.
> Then rds_ib_recv_exit is called to destroy slab.
 ...
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
