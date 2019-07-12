Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C941367694
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfGLWge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:36:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:36:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9137F14E0384F;
        Fri, 12 Jul 2019 15:36:33 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:36:32 -0700 (PDT)
Message-Id: <20190712.153632.1007215196498198399.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     vishal@chelsio.com, rahul.lakkireddy@chelsio.com,
        ganeshgr@chelsio.com, alexios.zavras@intel.com, arjun@chelsio.com,
        surendra@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] [net-next] cxgb4: reduce kernel stack usage in
 cudbg_collect_mem_region()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190712090700.317887-1-arnd@arndb.de>
References: <20190712090700.317887-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:36:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 12 Jul 2019 11:06:33 +0200

> The cudbg_collect_mem_region() and cudbg_read_fw_mem() both use several
> hundred kilobytes of kernel stack space. One gets inlined into the other,
> which causes the stack usage to be combined beyond the warning limit
> when building with clang:
> 
> drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:1057:12: error: stack frame size of 1244 bytes in function 'cudbg_collect_mem_region' [-Werror,-Wframe-larger-than=]
> 
> Restructuring cudbg_collect_mem_region() lets clang do the same
> optimization that gcc does and reuse the stack slots as it can
> see that the large variables are never used together.
> 
> A better fix might be to avoid using cudbg_meminfo on the stack
> altogether, but that requires a larger rewrite.
> 
> Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
