Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC47C56542A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiGDLy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiGDLyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:54:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242B11145F;
        Mon,  4 Jul 2022 04:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABFF5B80EEA;
        Mon,  4 Jul 2022 11:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B662C3411E;
        Mon,  4 Jul 2022 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656935660;
        bh=LZhuxXQHHTHH1XTd+hqiGgZz03CY+NjvR39Ax2weP4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cnjx4aquSnHdpULUsLfF18eAM0zuBLhbuqcsfGGKsMazRDQ9+zdyICQDV0MsC2sgN
         8+XfAIKbDzwBZLz5GOBZD0yeQdUMOYgctzEU04vrOoRl7soWpqlmxXdJQWNXwd6+xC
         6jWKmq445Sny0SGTBzzUqfexFgt38IzUAp6W/Ahs=
Date:   Mon, 4 Jul 2022 13:54:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Soumya Negi <soumya.negi97@gmail.com>,
        syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in
 detach_capi_ctr
Message-ID: <YsLU6XL1HBnQR79P@kroah.com>
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
 <20220704112619.GZ16517@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704112619.GZ16517@kadam>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 02:26:19PM +0300, Dan Carpenter wrote:
> 
> On Fri, Jul 01, 2022 at 06:08:29AM -0700, Soumya Negi wrote:
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > 3f8a27f9e27bd78604c0709224cec0ec85a8b106
> > 
> > -- 
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ%40mail.gmail.com.
> 
> > From 3aa5aaffef64a5574cbdb3f5c985bc25b612140c Mon Sep 17 00:00:00 2001
> > From: Soumya Negi <soumya.negi97@gmail.com>
> > Date: Fri, 1 Jul 2022 04:52:17 -0700
> > Subject: [PATCH] isdn: capi: Add check for controller count in
> >  detach_capi_ctr()
> > 
> > Fixes Syzbot bug:
> > https://syzkaller.appspot.com/bug?id=14f4820fbd379105a71fdee357b0759b90587a4e
> > 
> > This patch checks whether any ISDN devices are registered before unregistering
> > a CAPI controller(device). Without the check, the controller struct capi_str
> > results in out-of-bounds access bugs to other CAPI data strucures in
> > detach_capri_ctr() as seen in the bug report.
> > 
> 
> This bug was already fixed by commit 1f3e2e97c003 ("isdn: cpai: check
> ctr->cnr to avoid array index out of bound").
> 
> It just needs to be backported.  Unfortunately there was no Fixes tag so
> it wasn't picked up.  Also I'm not sure how backports work in netdev.

That commit has already been backported quite a while ago and is in the
following releases:
	4.4.290 4.9.288 4.14.253 4.19.214 5.4.156 5.10.76 5.14.15 5.15


thanks,

greg k-h
