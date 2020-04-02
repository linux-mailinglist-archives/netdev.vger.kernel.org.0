Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B132C19BE5A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgDBJGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 05:06:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53610 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387723AbgDBJGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 05:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585818397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=65cLaBQBBxQNS4tib9PUIecsC4BcpagR0uIUdTj5N9c=;
        b=N5KoIne36YXUT9uW4cRYgza9cWPTR4Grwx3HX8V86nGXgHVYm2u8C+YJ7b+4PIYpp4tHC6
        19vOvYqBLJQ5CvsT2ZKbcJg6+g18j6kQTZDxXFTnl6/TegVyqLd2uzdHDdRDCZek/du3/b
        +ZDepoSXTdsky9RpYxBZME57qmo26F0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-xaPBBNPnMLaUxkTVbBxdmA-1; Thu, 02 Apr 2020 05:06:33 -0400
X-MC-Unique: xaPBBNPnMLaUxkTVbBxdmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAE4F1083E8A;
        Thu,  2 Apr 2020 09:06:29 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5033526DC3;
        Thu,  2 Apr 2020 09:06:21 +0000 (UTC)
Date:   Thu, 2 Apr 2020 11:06:19 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        jwi@linux.ibm.com, jianglidong3@jd.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
Message-ID: <20200402110619.48f31a63@carbon>
In-Reply-To: <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
        <20200331060641.79999-1-maowenan@huawei.com>
        <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
        <20200401181419.7acd2aa6@carbon>
        <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Apr 2020 09:47:03 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> On 2020/04/02 1:15, Jesper Dangaard Brouer wrote:
> ...
> > [PATCH RFC net-next] veth: adjust hard_start offset on redirect XDP frames
> > 
> > When native XDP redirect into a veth device, the frame arrives in the
> > xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> > which can run a new XDP bpf_prog on the packet. Doing so requires
> > converting xdp_frame to xdp_buff, but the tricky part is that
> > xdp_frame memory area is located in the top (data_hard_start) memory
> > area that xdp_buff will point into.
> > 
> > The current code tried to protect the xdp_frame area, by assigning
> > xdp_buff.data_hard_start past this memory. This results in 32 bytes
> > less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
> > 
> > This protect step is actually not needed, because BPF-helper
> > bpf_xdp_adjust_head() already reserve this area, and don't allow
> > BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> > directly at xdp_frame memory area.
> > 
> > Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>  
> 
> FYI: This mail address is deprecated.
> 
> > Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> > Reported-by: Mao Wenan <maowenan@huawei.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> FWIW,
> 
> Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Thanks.

I have updated your email and added your ack in my patchset.  I will
submit this officially once net-next opens up again[1], as part my
larger patchset for introducing XDP frame_sz.

[1] http://vger.kernel.org/~davem/net-next.html
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

