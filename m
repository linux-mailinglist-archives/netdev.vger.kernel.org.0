Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801DC62ECFE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiKRE7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRE7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:59:45 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98AB5BD4E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:59:43 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 56391C009; Fri, 18 Nov 2022 05:59:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668747587; bh=mrSdzggaaZx2brnDeP/8mVVD2/b0o1Wo6WFGVV2aSBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4vwrRbyxNxs7al+rvR2pCNFE2QjgKz8o5ClmwRBKaPHgYPKIgNumOhQUNq2zN8B1j
         QetTn82TMvlzkoEasu+s3I6ixbXvPIVzEqEcuRGxRGTNIJOX52DjlIoneNlkC0R6M0
         RJABsOpKd5OZIqXNDxbGuhye81lBJFaLtEw7r9uqv2CCZjAkpbmlXXdtZxJkzvJope
         STdeInKMY7n8TG6Pd/+75bX8i7RbfrKgF3Gdm31mXEl4Jw5pDJJa+SMig6tyeV82q8
         XdNaO/sEFi9x5mGSmpmjkqcfqW7QIc01YJfFd31/VfKdj8fNHfrQp6+Voh1tGIvm66
         Cv/iaWyBVHUGA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 31D27C009;
        Fri, 18 Nov 2022 05:59:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668747586; bh=mrSdzggaaZx2brnDeP/8mVVD2/b0o1Wo6WFGVV2aSBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mv8rYpslCUJMxH7Q5Hjq6m1SCpUQowZkAN05QZBfJXkQ6a0U+YBVr3oYkYb8lqwV+
         CTwYFt9Rp1rQj4JO9Be5t4lshMubLQ7/oRLvRupJCFUMuT73j7IpzXPubjmhrPze6y
         v8Q8OlJAdmMoNbPMedSh5gD2SA2FwHw9cwrdptjf1MQ30m8EeSyxpAVogq7mIjtRkd
         MJWBa4LwC/W7pHrQqahOLOefy3GKarlfTHv/NpsAeKfZ8hKVdZJ2/Qf5auWaHZBdzX
         s1Dn2YozXSwv/F1MTVXWhy4xUKu+CWgd2xDnHNZLpbNeR7usihSEZClumGfmyCTQMs
         sbrK1n90LiSNg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id aa888285;
        Fri, 18 Nov 2022 04:59:33 +0000 (UTC)
Date:   Fri, 18 Nov 2022 13:59:18 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net,
        GUO Zihua <guozihua@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Message-ID: <Y3cRJsRFCZaKrzhe@codewreck.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
 <3918617.6eBe0Ihrjo@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3918617.6eBe0Ihrjo@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Nov 17, 2022 at 02:33:28PM +0100:
> > GUO Zihua (3):
> >   9p: Fix write overflow in p9_read_work
> >   9p: Remove redundent checks for message size against msize.
> >   9p: Use P9_HDRSZ for header size
> 
> For entire series:
> 
> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> 
> I agree with Dominique that patch 1 and 2 should be merged.

Thank you both!

I've just pushed the patches to my next branch:
https://github.com/martinetd/linux/commits/9p-next

... with a twist, as the original patch fails on any normal workload:
---
/ # ls /mnt
9pnet: -- p9_read_work (19): requested packet size too big: 9 for tag 0 with capacity 11
---
(so much for having two pairs of eyes :-D
By the way we -really- need to replace P9_DEBUG_ERROR by pr_error or
something, these should be displayed without having to specify
debug=1...)


capacity is only set in a handful of places (alloc time, hardcoded 7 in
trans_fd, after receiving packet) so I've added logs and our alloc
really passed '11' for alloc_rsize (logging tsize/rsize)

9pnet: (00000087) >>> TWALK fids 1,2 nwname 0d wname[0] (null)
9pnet: -- p9_tag_alloc (87): allocating capacity to 17/11 for tag 0
9pnet: -- p9_read_work (19): requested packet size too big: 9 for tag 0 with capacity 11

... So this is RWALK, right:
size[4] Rwalk tag[2] nwqid[2] nwqid*(wqid[13])
4 ..... 5.... 7..... 9....... packet end at 9 as 0 nwqid.
We have capacity 11 to allow rlerror_size which is bigger; everything is
good.

Long story short, the size header includes the header size, when I
misread https://9fans.github.io/plan9port/man/man9/version.html to
say it didn't (it just says it doesn't include the enveloping transport
protocol, it starts from size alright and I just misread that)
Thanksfully the code caught it.

So I've just removed the - offset part and things appear to work again.

Guo Zihua, can you check this still fixes your syz repro, or was that
substraction needed? If it's still needed we have an off by 1 somewhere
to look for.

-- 
Dominique
