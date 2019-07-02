Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3985C6EF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGBCGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:06:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBCGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:06:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76C5E14DE97B1;
        Mon,  1 Jul 2019 19:06:46 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:06:46 -0700 (PDT)
Message-Id: <20190701.190646.1170893438836185073.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     roopa@cumulusnetworks.com, petrm@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3] vxlan: do not destroy fdb if
 register_netdevice() is failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628050725.9445-1-ap420073@gmail.com>
References: <20190628050725.9445-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:06:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 28 Jun 2019 14:07:25 +0900

> __vxlan_dev_create() destroys FDB using specific pointer which indicates
> a fdb when error occurs.
> But that pointer should not be used when register_netdevice() fails because
> register_netdevice() internally destroys fdb when error occurs.
> 
> This patch makes vxlan_fdb_create() to do not link fdb entry to vxlan dev
> internally.
> Instead, a new function vxlan_fdb_insert() is added to link fdb to vxlan
> dev.
> 
> vxlan_fdb_insert() is called after calling register_netdevice().
> This routine can avoid situation that ->ndo_uninit() destroys fdb entry
> in error path of register_netdevice().
> Hence, error path of __vxlan_dev_create() routine can have an opportunity
> to destroy default fdb entry by hand.
> 
> Test command
>     ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
> 	    dev enp0s9 dstport 4789
> 
> Splat looks like:
 ...
> Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
> Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
