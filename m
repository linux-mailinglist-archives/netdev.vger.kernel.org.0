Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1957235413
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 20:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgHASuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 14:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHASuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 14:50:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F407C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 11:50:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 638141284FF4D;
        Sat,  1 Aug 2020 11:33:23 -0700 (PDT)
Date:   Sat, 01 Aug 2020 11:50:07 -0700 (PDT)
Message-Id: <20200801.115007.230257676134216058.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, roopa@cumulusnetworks.com
Subject: Re: [PATCH net] vxlan: fix memleak of fdb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200801070750.7993-1-ap420073@gmail.com>
References: <20200801070750.7993-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 11:33:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat,  1 Aug 2020 07:07:50 +0000

> When vxlan interface is deleted, all fdbs are deleted by vxlan_flush().
> vxlan_flush() flushes fdbs but it doesn't delete fdb, which contains
> all-zeros-mac because it is deleted by vxlan_uninit().
> But vxlan_uninit() deletes only the fdb, which contains both all-zeros-mac
> and default vni.
> So, the fdb, which contains both all-zeros-mac and non-default vni
> will not be deleted.
> 
> Test commands:
>     ip link add vxlan0 type vxlan dstport 4789 external
>     ip link set vxlan0 up
>     bridge fdb add to 00:00:00:00:00:00 dst 172.0.0.1 dev vxlan0 via lo \
> 	    src_vni 10000 self permanent
>     ip link del vxlan0
> 
> kmemleak reports as follows:
 ...
> Fixes: 3ad7a4b141eb ("vxlan: support fdb and learning in COLLECT_METADATA mode")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
