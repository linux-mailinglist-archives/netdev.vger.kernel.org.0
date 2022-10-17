Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5EE6015E5
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiJQSDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJQSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:03:37 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825A863FFB;
        Mon, 17 Oct 2022 11:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=FU3Btm3EGBwXY4LS7OhQ2d8cTy/b/4HQKovRbcKBjos=; b=YSx/KHgYLgMvLP92fQqt+LbqTm
        oqJ27ciBM3x8dNSImEPv5MwHeucHHzZZe7/+jmm0N1XwRvo1WGd7UadkAKUl2GHLHWACgps45uxkB
        NcOse+D8Zoz0Fuz+EfvKX+cno4JILAqGZ62QebfEkIyf+O5spjYCCaYGX9aqCd1p/znDN2Blfd1Tv
        SoRK94PsA31EzF6d9pWdnkePt8rAXi7OQVF6uEBNlD4OBdVdknSqHOosA/R1jD/LcRcBIIKtkPGc8
        0mOstPbsyC1TNSEtWqyrsHVa4lZP1GZbop3aBW0o6o4cZpOpQnurDKjgDM5NZXSv6U937D6GC8L8O
        7nal5D+PuliyNChsjus11wi+Yh/EZxqDHaZD3JDQXBNC9UL/Bc/lTPUsWyEePPg5Qvw+WZRVHy9Nb
        z2VHF+nib+ZYXZWujt4jjDReaPrrC3TF0LyzoumgcZbx0eTzqEBtW0pNzWiZHJ8Z6/6cQQz2iAyMt
        W1DczxcPrWz3HvPRGmdVHTu8CAGW5+GA1hXQ/MPtNebBXjMtMv76t2S9oXwShlb4bUci313YjKafz
        e/YrkqHNXaxXSRjnnJKVEBElnIY88BXfLuP03KZIdlQHrmmNZoUUXyazvJbMw1nHU4SEbXvvn1awb
        62as9NgYYlckuc68u4ruBqlGIua/uN9yjO3Ywj17I=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Greg Kurz <groug@kaod.org>,
        Stefano Stabellini <stefano.stabellini@xilinx.com>
Subject: Re: [PATCH v6 11/11] net/9p: allocate appropriate reduced message buffers
Date:   Mon, 17 Oct 2022 20:03:28 +0200
Message-ID: <4858768.YlS1rbApJJ@silver>
In-Reply-To: <Y02Kz2xuntFrKXhV@nvidia.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <3f51590535dc96ed0a165b8218c57639cfa5c36c.1657920926.git.linux_oss@crudebyte.com>
 <Y02Kz2xuntFrKXhV@nvidia.com>
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

On Monday, October 17, 2022 7:03:11 PM CEST Jason Gunthorpe wrote:
> On Fri, Jul 15, 2022 at 11:33:56PM +0200, Christian Schoenebeck wrote:
> > So far 'msize' was simply used for all 9p message types, which is far
> > too much and slowed down performance tremendously with large values
> > for user configurable 'msize' option.
> > 
> > Let's stop this waste by using the new p9_msg_buf_size() function for
> > allocating more appropriate, smaller buffers according to what is
> > actually sent over the wire.
> > 
> > Only exception: RDMA transport is currently excluded from this message
> > size optimization - for its response buffers that is - as RDMA transport
> > would not cope with it, due to its response buffers being pulled from a
> > shared pool. [1]
> > 
> > Link: https://lore.kernel.org/all/Ys3jjg52EIyITPua@codewreck.org/ [1]
> > Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> > ---
> > 
> >  net/9p/client.c | 42 +++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> It took me a while to sort out, but for any others - this patch is
> incompatible with qemu 5.0. It starts working again after this qemu
> patch:
> 
> commit cf45183b718f02b1369e18c795dc51bc1821245d
> Author: Stefano Stabellini <stefano.stabellini@xilinx.com>
> Date:   Thu May 21 12:26:25 2020 -0700
> 
>     Revert "9p: init_in_iov_from_pdu can truncate the size"
> 
>     This reverts commit 16724a173049ac29c7b5ade741da93a0f46edff7.
>     It causes https://bugs.launchpad.net/bugs/1877688.
> 
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
>     Reviewed-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
>     Message-Id: <20200521192627.15259-1-sstabellini@kernel.org>
>     Signed-off-by: Greg Kurz <groug@kaod.org>
> 
> It causes something like this:
> 
> # modprobe ib_cm
> qemu-system-x86_64: VirtFS reply type 117 needs 17 bytes, buffer has 17,
> less than minimum

9p server in QEMU 5.0 was broken by mentioned, reverted QEMU patch, and it was 
already fixed in stable release 5.0.1.

It is not that recent kernel patch is breaking behaviour, but it triggers that 
(short-lived) QEMU bug more reliably, as 9p client is now using smaller 
messages more often. But even without this kernel patch, you would still get a 
QEMU hang with short I/O. So it is not a good idea to continue using that 
particular, old QEMU version, please update at least to QEMU 5.0.1.

Best regards,
Christian Schoenebeck


