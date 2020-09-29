Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89227BA7A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgI2Bs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2Bsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:48:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC93C061755;
        Mon, 28 Sep 2020 18:48:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 884EC127C6C13;
        Mon, 28 Sep 2020 18:32:07 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:48:54 -0700 (PDT)
Message-Id: <20200928.184854.1552208756306515059.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH][next] net/sched: cls_u32: Replace one-element array
 with flexible-array member
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928153052.GA17317@embeddedor>
References: <20200928153052.GA17317@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:32:07 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Mon, 28 Sep 2020 10:30:52 -0500

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct tc_u_hnode and use the struct_size() helper to calculate the
> size for the allocations. Commit 5778d39d070b ("net_sched: fix struct
> tc_u_hnode layout in u32") makes it clear that the code is expected to
> dynamically allocate divisor + 1 entries for ->ht[] in tc_uhnode. Also,
> based on other observations, as the piece of code below:
> 
> 1232                 for (h = 0; h <= ht->divisor; h++) {
> 1233                         for (n = rtnl_dereference(ht->ht[h]);
> 1234                              n;
> 1235                              n = rtnl_dereference(n->next)) {
> 1236                                 if (tc_skip_hw(n->flags))
> 1237                                         continue;
> 1238
> 1239                                 err = u32_reoffload_knode(tp, n, add, cb,
> 1240                                                           cb_priv, extack);
> 1241                                 if (err)
> 1242                                         return err;
> 1243                         }
> 1244                 }
> 
> we can assume that, in general, the code is actually expecting to allocate
> that extra space for the one-element array in tc_uhnode, everytime it
> allocates memory for instances of tc_uhnode or tc_u_common structures.
> That's the reason for passing '1' as the last argument for struct_size()
> in the allocation for _root_ht_ and _tp_c_, and 'divisor + 1' in the
> allocation code for _ht_.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/5f7062af.z3T9tn9yIPv6h5Ny%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
