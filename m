Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432DBAB8E6
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392808AbfIFNHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:07:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbfIFNHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:07:18 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1E31152F5CAD;
        Fri,  6 Sep 2019 06:07:16 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:07:15 +0200 (CEST)
Message-Id: <20190906.150715.1583606913988184408.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCHv3 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567674942-5132-2-git-send-email-yanjun.zhu@oracle.com>
References: <1567674942-5132-1-git-send-email-yanjun.zhu@oracle.com>
        <1567674942-5132-2-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:07:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Thu,  5 Sep 2019 05:15:42 -0400

> When testing with a background iperf pushing 1Gbit/sec traffic and running
> both ifconfig and netstat to collect statistics, some deadlocks occurred.
> 
> Ifconfig and netstat will call nv_get_stats64 to get software xmit/recv
> statistics. In the commit f5d827aece36 ("forcedeth: implement
> ndo_get_stats64() API"), the normal tx/rx variables is to collect tx/rx
> statistics. The fix is to replace normal tx/rx variables with per
> cpu 64-bit variable to collect xmit/recv statistics. The per cpu variable
> will avoid deadlocks and provide fast efficient statistics updates.
> 
> In nv_probe, the per cpu variable is initialized. In nv_remove, this
> per cpu variable is freed.
> 
> In xmit/recv process, this per cpu variable will be updated.
> 
> In nv_get_stats64, this per cpu variable on each cpu is added up. Then
> the driver can get xmit/recv packets statistics.
> 
> A test runs for several days with this commit, the deadlocks disappear
> and the performance is better.
> 
> Tested:
 ...
> Fixes: f5d827aece36 ("forcedeth: implement ndo_get_stats64() API")
> CC: Joe Jin <joe.jin@oracle.com>
> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
> Reported-and-tested-by: Nan san <nan.1986san@gmail.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied.
