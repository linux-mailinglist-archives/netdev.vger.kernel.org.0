Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4B62DCDD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiKQNeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240142AbiKQNeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:34:10 -0500
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B652AE0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=yDHmBSEgkzHUv2gownf19Jhq8mrsJwKM8BvJyC4LAfc=; b=sdexSol373aDIoZYVm50g1mAs6
        aJY8XhMvTMO8KSOIDwmNgKwGEgH0w6Ak5Yrw4oBG4u4obtfWg/zSvSWkdwFp3TS3bPb562j2dfIPd
        ce3mMQMB77TLFTiRA7cs8aWKL6OHsuHNUVcRp56PqevhmQmKpCG8aHIgoyuJPDTwDoVOVHAqz6loq
        i3ZmCkDXHl+in5r6BBH+OQdTRmfPYoesej0pIr3vFMGep63UbsJaKb0iBytCu+Iuv7MdrHkznzNDY
        Iad4mckZcOiKZ6CVj0CmaOc6uqOfrcHVJ+X/SxgbYT8sywsMWllL8N/rw7WoAvkj5L/iFBx7KTrg/
        /8G/V2uWL5sTT03Hi/EJ1u03MA9uB2eNEakeRt9O1JD753VAL54rfLGTer13062VoKu1NVUtpvGMU
        RBq+9SQjbQt3xHPt95/jfXrlbFBBdu6KT9Xe8ZTXdJYJ1StcbVf0sjD6vv2IAEWTX4iYUCdBHyMWL
        kYxGf/vkXj/ltDmU5BrJqqHtq92WCKgbff1j2wINVJazN5mi140ha9HuSD+8NqjrrKZWMU8fhFV3T
        rzDr42aBGYaofBUW9UP5edYZvHQFLmzp7qmPwYC1pmntXsjtUJmDKA6kFku2/ZSAzH05EJRnjv088
        3l8hlE7m1qy7+MuLpZ83zsfeSkvb0HQBOef56U0Js=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        GUO Zihua <guozihua@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Date:   Thu, 17 Nov 2022 14:33:28 +0100
Message-ID: <3918617.6eBe0Ihrjo@silver>
In-Reply-To: <20221117091159.31533-1-guozihua@huawei.com>
References: <20221117091159.31533-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, November 17, 2022 10:11:56 AM CET GUO Zihua wrote:
> This patchset fixes the write overflow issue in p9_read_work. As well as
> some follow up cleanups.
> 
> BUG: KASAN: slab-out-of-bounds in _copy_to_iter+0xd35/0x1190
> Write of size 4043 at addr ffff888008724eb1 by task kworker/1:1/24
> 
> CPU: 1 PID: 24 Comm: kworker/1:1 Not tainted 6.1.0-rc5-00002-g1adf73218daa-dirty #223
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
> Workqueue: events p9_read_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4c/0x64
>  print_report+0x178/0x4b0
>  kasan_report+0xae/0x130
>  kasan_check_range+0x179/0x1e0
>  memcpy+0x38/0x60
>  _copy_to_iter+0xd35/0x1190
>  copy_page_to_iter+0x1d5/0xb00
>  pipe_read+0x3a1/0xd90
>  __kernel_read+0x2a5/0x760
>  kernel_read+0x47/0x60
>  p9_read_work+0x463/0x780
>  process_one_work+0x91d/0x1300
>  worker_thread+0x8c/0x1210
>  kthread+0x280/0x330
>  ret_from_fork+0x22/0x30
>  </TASK>
> 
> GUO Zihua (3):
>   9p: Fix write overflow in p9_read_work
>   9p: Remove redundent checks for message size against msize.
>   9p: Use P9_HDRSZ for header size

For entire series:

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

I agree with Dominique that patch 1 and 2 should be merged.

>  net/9p/trans_fd.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> ---
> 
> v2:
>   Addition log for debugging similar issues, as well as cleanups according to
>   Dominique's comment.
> 




