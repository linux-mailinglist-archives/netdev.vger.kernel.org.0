Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121FB5FF1BF
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiJNPw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJNPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:52:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC65D1C6BE4;
        Fri, 14 Oct 2022 08:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85821B82367;
        Fri, 14 Oct 2022 15:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E3BC433C1;
        Fri, 14 Oct 2022 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665762741;
        bh=KB5yV/ErkZcjUTijfeVO4kmN9+d0J7rzX42NU+CHSZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hxizLyBqwBpsL+YmB2RwdnEZTjpyezWCDbKR7q1KII+P8VEY9GFyFVLvV++i2CF+q
         Oa5C36dTpZBS7h88v1RfNl1iWDGwnd+LOmBn+Lv/ZDhnW8+/B+p/+sK23MNerq72kn
         UhVXXzkJVLk9+bvkF2W6jf8K0vKUP4fzSMohPgi3jHs7POU1+xdaMKuBliqmejsk/g
         6JADOjOW9/4mtTLfy6gYtAR/BI/XImxUzyiJBTLhIg63feU5IhvROUn61T+y/yahuY
         y39pJhVt+iIVjfCkAJIUPhe8YNQ6jDhxQ7AmVay7V7GexMTx9CCHqZy1UVU6c8fxV+
         16FViRMPq8F5Q==
Date:   Fri, 14 Oct 2022 08:52:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Ren <guoren@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <20221014085219.635d25cd@kernel.org>
In-Reply-To: <CAJF2gTQyMHNHLizeU-gvUdA5hRLUWxvHXuVVqSoPg3M_WxPPdw@mail.gmail.com>
References: <20221014030459.3272206-1-guoren@kernel.org>
        <20221014030459.3272206-2-guoren@kernel.org>
        <20221013203544.110a143c@kernel.org>
        <CAJF2gTQyMHNHLizeU-gvUdA5hRLUWxvHXuVVqSoPg3M_WxPPdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 14:38:56 +0800 Guo Ren wrote:
> > This does not look equivalent, have you tested it?
> >
> > nr_ids is unsigned, doesn't it mean we'll never enter the loop?  
> 
> Yes, you are right. Any unsigned int would break the result.
> (gdb) p (int)-1 < (int)2
> $1 = 1
> (gdb) p (int)-1 < (unsigned int)2
> $2 = 0
> (gdb) p (unsigned int)-1 < (int)2
> $4 = 0
> 
> So it should be:
>  -     for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
>  -          j < nr_ids;) {
>  +     for (j = -1; j < (int)nr_ids;
>  +          j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {
> 
> Right? Of cause, nr_ids couldn't be 0xffffffff (-1).

No. You can't enter the loop with -1 as the iterator either. 
Let's move on.
