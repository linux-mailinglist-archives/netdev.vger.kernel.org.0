Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3D1E128D
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgEYQW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731228AbgEYQW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 12:22:26 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42492C061A0E;
        Mon, 25 May 2020 09:22:26 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jdFrd-0005Gl-0Q; Mon, 25 May 2020 18:22:09 +0200
Date:   Mon, 25 May 2020 18:22:07 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        lkp@intel.com, kbuild-all@lists.01.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200525162206.GB375786@debian-buster-darwi.lab.linutronix.de>
References: <20200519214547.352050-2-a.darwish@linutronix.de>
 <20200520143706.GB30374@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520143706.GB30374@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 05:37:07PM +0300, Dan Carpenter wrote:
...
>
> smatch warnings:
> net/core/dev.c:953 netdev_get_name() warn: inconsistent returns 'devnet_rename_sem'.
>
...
>
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  935  int netdev_get_name(struct net *net, char *name, int ifindex)
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  936  {
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  937  	struct net_device *dev;
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  938
> 2354e271ada778b Ahmed S. Darwish 2020-05-19  939  	down_read(&devnet_rename_sem);
>                                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> 2354e271ada778b Ahmed S. Darwish 2020-05-19  940
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  941  	rcu_read_lock();
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  942  	dev = dev_get_by_index_rcu(net, ifindex);
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  943  	if (!dev) {
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  944  		rcu_read_unlock();
> 5dbe7c178d3f0a4 Nicolas Schichan 2013-06-26  945  		return -ENODEV;
>                                                               ^^^^^^^^^^^^^^

Oh, shouldn't have missed that. Will fix in v2.

Thanks,
