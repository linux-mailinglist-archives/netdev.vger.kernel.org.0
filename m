Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B884F0901
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiDCLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 07:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiDCLb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 07:31:56 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BAD2F38F
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 04:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=AdOvAXTsIN9zhwjVlvwewFQq0Hm2uVNJaTJFxYUIOw8=; b=Cr93xOjuMMGKyzwFH69SA1+IiC
        skkoC+TmV+WOGRgw6lQ8whkai/u5HSYsQ2GnKUtozkZtvh4DrTByFu9h5f4bpaqRiJGHWUSP/8i2h
        NKnXVTjbiD+d1GEBIgoXNQHH02VI/7t9U9EpmlSExmjni3GPsiyWKTqDwyA7A5S4JQ28jO/+UPc2m
        Qc7+APn8sNE/Zjp2WZjGjVmuabSle53xp4/t7dMMtLAs/P7wKFppWmqbnECT5oN/l5wE7QRVXwEoH
        08sVPNp9axgt69tZIJuYF0pqC73C1B5kadQutqfkJpHIZTQ4RHzJpEna/5YfRN91GxT+9ckeRyxoM
        dP1MjufQQNyynmgKm3BUy4z4hz4wLCadRKyxjF+XVRvZfZyF4UQiGDeUYJrFZ1uRlrSDcMAqh7IpE
        TD3ANVoiDw2ethAOAE/AyTY9KEhjIb4aOcAFvh6gOggGbVUO9SCHQwwMXFtE53QEEy+Eh8YWNU8pm
        W1+kx6yory++qZLZO5OyMlfWTQPF+O0GO0+CtE0UePq9JNuydyx+jpR/8UF5tt22oJG3Sma+je5Jl
        DbtSoKnNISwhoGTap7q8yfwPaQfdF0dfpMGyd4lHg0Jr02oOFyvQE0K9fFQmCx/FC5kRIkPrTJCMv
        SLcWr2EP0qdigHR9v0J7qUhiAeyagaaUd2S1TXTeQ=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v4 12/12] net/9p: allocate appropriate reduced message buffers
Date:   Sun, 03 Apr 2022 13:29:53 +0200
Message-ID: <1953222.pKi1t3aLRd@silver>
In-Reply-To: <YkhYMFf63qnEhDd0@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <8c305df4646b65218978fc6474aa0f5f29b216a0.1640870037.git.linux_oss@crudebyte.com>
 <YkhYMFf63qnEhDd0@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 2. April 2022 16:05:36 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Thu, Dec 30, 2021 at 02:23:18PM +0100:
> > So far 'msize' was simply used for all 9p message types, which is far
> > too much and slowed down performance tremendously with large values
> > for user configurable 'msize' option.
> > 
> > Let's stop this waste by using the new p9_msg_buf_size() function for
> > allocating more appropriate, smaller buffers according to what is
> > actually sent over the wire.
> 
> By the way, thinking of protocols earlier made me realize this won't
> work on RDMA transport...
> 
> unlike virtio/tcp/xen, RDMA doesn't "mailbox" messages: there's a pool
> of posted buffers, and once a message has been received it looks for the
> header in the received message and associates it with the matching
> request, but there's no guarantee a small message will use a small
> buffer...
> 
> This is also going to need some thought, perhaps just copying small
> buffers and recycling the buffer if a large one was used? but there
> might be a window with no buffer available and I'm not sure what'd
> happen, and don't have any RDMA hardware available to test this right
> now so this will be fun.
> 
> 
> I'm not shooting this down (it's definitely interesting), but we might
> need to make it optional until someone with RDMA hardware can validate a
> solution.

So maybe I should just exclude the 9p RDMA transport from this 9p message size 
reduction change in v5 until somebody had a chance to test this change with 
RDMA.

Which makes me wonder, what is that exact hardware, hypervisor, OS that 
supports 9p & RDMA?

On the long-term I can imagine to add RDMA transport support on QEMU 9p side. 
There is already RDMA code in QEMU, however it is only used for migration by 
QEMU so far I think.

Best regards,
Christian Schoenebeck


