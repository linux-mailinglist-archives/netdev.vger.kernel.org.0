Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE3556A569
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiGGObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGGObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:31:08 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4980F2E9D7
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 07:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=0q3pCVaNC6eZ01+RxXhdBNZtOsM0QfCCjik57QpvYi8=; b=aq7xLVp1nBc814w1LoFZQRxHY4
        RdHgJNrAyUYrUNyaZyDcbl4ssPoifrHNjXiwqSr+s49l3Hooqom+Wfk2o1j1fflKHCy4GRbbXLXI6
        u4wvwbhuavhpKfuKDVUy9iW1cvmT+V9DXOCHa6tMYvgbiBtDGhrka4qqnXnT+aUmOyQxgIMqLYyLI
        NAGmfoPF4IL+yTNokFPz6pQU3F1XL3M0hrEgIieT3Li3XIHUKSUfVPIkgg5vDZxKc7Kr0Kabb1ufW
        nL7QKYVl/VwRDdQJHwFVfCtFmAXvxoLeL0Wkafz0M1i1vSiMd9zobyTw7L8gCef4dBKEmxFYaUOQh
        JeiF0wceE/s6/wSMosjoQr4ETfvuhcpx3iWcOBVQDP77J98u9mMOMGDbDLxVMI1BpczTpeLwpgt0Z
        ssg5Ws5HKGQkazPoqdEjfsZJ77qAnno4p29PNZSvukB2EDFEaNotElt5uNgMO10yItI927SwZqESW
        ui6rwroCpXHaZKjkZZlK3QuRwVrv4FsRrLYmLpTJX0N1Pxm4sGEyi5SMB31vkoiTq8hCbECJ5yfID
        MdncDaMZElPfWrCeB/xfhmBxRopuFu0y7Tt2plv2uSv+PXhg2pmyXnWp+QL/QGGGR+cvbE/KV+8/t
        QmvBzI3GfeytwblPzbB9bqtdnCGPk7v/PyRS3ZAPs=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Greg Kurz <groug@kaod.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Thu, 07 Jul 2022 16:30:55 +0200
Message-ID: <7534209.h2h7kyIpJd@silver>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
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

On Donnerstag, 30. Dezember 2021 14:23:18 CEST Christian Schoenebeck wrote:
> This series aims to get get rid of the current 500k 'msize' limitation in
> the 9p virtio transport, which is currently a bottleneck for performance
> of 9p mounts.
[...]
> KNOWN LIMITATION:
> 
> With this series applied I can run
> 
>   QEMU host <-> 9P virtio <-> Linux guest
> 
> with up to slightly below 4 MB msize [4186112 = (1024-2) * 4096]. If I try
> to run it with exactly 4 MB (4194304) it currently hits a limitation on
> QEMU side:
> 
>   qemu-system-x86_64: virtio: too many write descriptors in indirect table
> 
> That's because QEMU currently has a hard coded limit of max. 1024 virtio
> descriptors per vring slot (i.e. per virtio message), see to do (1.) below.
> 
> 
> STILL TO DO:
> 
>   1. Negotiating virtio "Queue Indirect Size" (MANDATORY):
> 
>     The QEMU issue described above must be addressed by negotiating the
>     maximum length of virtio indirect descriptor tables on virtio device
>     initialization. This would not only avoid the QEMU error above, but
>     would also allow msize of >4MB in future. Before that change can be done
>     on Linux and QEMU sides though, it first requires a change to the virtio
>     specs. Work on that on the virtio specs is in progress:
> 
>     https://github.com/oasis-tcs/virtio-spec/issues/122
> 
>     This is not really an issue for testing this series. Just stick to max.
>     msize=4186112 as described above and you will be fine. However for the
>     final PR this should obviously be addressed in a clean way.

As there is no progress on virtio spec side in sight, I'm considering to 
handle this issue in upcoming v5 by simply assuming (hard coding) that 9p 
server supports exactly up to 1024 virtio descriptors (memory segments) per 
round trip message. That's maybe a bit unclean, but that's what other virtio 
drivers in the Linux kernel do for many years as well, so I am not expecting a 
negative issue in practice.

And I mean, when we talk about 9p + virtio, that actually implies QEMU being 
the 9p server, right? At least I am not aware of another 9p server 
implementation supporting virtio transport (nor any QEMU version that ever 
supported less than 1024 virtio descriptors). Maybe Microsoft WSL? Not sure.

Best regards,
Christian Schoenebeck


