Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E0B4F0A12
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350102AbiDCODE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiDCODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:03:01 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B738780
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=H6Ha5lBsHsPX5G1DlmiXevipMYnnDCJ8AOPGKB32xEs=; b=PwcqmEKPYBTFvPooBYy5jJ2GC7
        hB0pUirxhm9+IONk9jFyxnbNIezg39oE+2X2jLGLohwxnz2guXDYFhwVEunQuc5oYXte6L55Cq9Dw
        BqNNiaVbSG9A3JZQ/TN1CBx/esfFq7k+H8dD8c6Se5kNynMJRBa3YyRNNv0np5RYIasS4uIEymF21
        GjP/eFGppQ3qaarrCP7Uh2mxAzbgTSJ/Ci5eQqYi6hf5Qi+JWvcVFibifO5uyAQ25BNXgpf36pMoj
        gDe2xrTNxgFTMKaF2I5OE9sEXw97AvusMpR0sjgrLBuHB6TUD3mKgd6YLGSRxRx8z6UHCz2/ROi3c
        /q87wS8lUkvxFMLBz2Tw1B2mMa99UwHwap6gYoKycshkxi/SyTDFj5/02Xi2BYVsQhiHfe5hd3e6M
        lz6e2fm5XWrjfIgw/4Sy6qWkGfgKLZkEsxEyXOruCejY8MC7C8mFA0DWv91ziAZTwKi8Egs2tHONi
        rW2G4g/5qrsE7nut4gq/789RBLQrkxHNVcpdpvs/JC3Vc4QXRgmVAd9m7NiJ5c3VxzV5dmPm6DDXw
        3tUs/v8yNLquY0Gk/J8/XYFfsTvzrX9YUycAonZSKB7MunqnCbOqenS1dJOaDr68nKYu95hWkG0+w
        5z4XjIJqHY6rrS5yIs1e5ucEz6WKk7PSvrY5H8ijU=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v4 12/12] net/9p: allocate appropriate reduced message buffers
Date:   Sun, 03 Apr 2022 16:00:56 +0200
Message-ID: <2745077.ukKBhl4x9b@silver>
In-Reply-To: <YkmVI6pqTuMD8dVi@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com> <1953222.pKi1t3aLRd@silver>
 <YkmVI6pqTuMD8dVi@codewreck.org>
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

On Sonntag, 3. April 2022 14:37:55 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Sun, Apr 03, 2022 at 01:29:53PM +0200:
> > So maybe I should just exclude the 9p RDMA transport from this 9p message
> > size reduction change in v5 until somebody had a chance to test this
> > change with RDMA.
> 
> Yes, I'm pretty certain it won't work so we'll want to exclude it unless
> we can extend the RDMA protocol to address buffers.

OK, agreed. It only needs a minor adjustment to this patch 12 to exclude the
RDMA transport (+2 lines or so). So no big deal.

> > On the long-term I can imagine to add RDMA transport support on QEMU 9p
> > side.
> What would you expect it to be used for?

There are several potential use cases that would come to my mind, e.g:

- Separating storage hardware from host hardware. With virtio we are
  constrained to the same machine.

- Maybe also a candidate to achieve what the 9p 'synth' driver in QEMU tried 
  to achieve? That 'synth' driver is running in a separate process from the 
  QEMU process, with the goal to increase safety. However currently it is 
  more or less abondened as it is extremely slow, as 9p requests have to be
  dispatched like:

   guest -> QEMU (9p server) -> synth daemon -> QEMU (9p server) -> guest

  Maybe we could rid of those costly extra hops with RDMA, not sure though.

- Maybe also an alternative to virtio on the same machine: there are also some 
  shortcomings in virtio that are tedious to address (see e.g. current 
  struggle with pure formal negotiation issues just to relax the virtio spec 
  regarding its "Queue Size" requirements so that we could achieve higher 
  message sizes). I'm also not a big fan of virtio's assumption that guest 
  should guess in advance host's response size.

- Maybe as transport for macOS guest support in future? Upcoming QEMU 7.0 adds
  support for macOS 9p hosts, which revives the plan to add support for 9p
  to macOS guests as well. The question still is what transport to use for 
  macOS guests then.

However I currently don't know any details inside RDMA yet, and as you already
outlined, it probably has some shortcomings that would need to be revised with
protocol changes as well.

Best regards,
Christian Schoenebeck


