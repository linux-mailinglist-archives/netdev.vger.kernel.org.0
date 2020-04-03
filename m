Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F819D191
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbgDCH7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 03:59:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389015AbgDCH7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 03:59:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585900745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mniN1sVbAvx++omfkPGQNGeast1vWCfMpGJZoMvG5sg=;
        b=cOjU317MV7u0YvNwWzGWs0WlENlf3gClsGJomRHx9i6UBGkm7y39mKSjzB6aicjrzgffPX
        SXMy0OowBaxA42ND5/KIP6xX00hCf6H542gNrpJA4+u2r6yeOl/8Dh4cU3yl+mUAAI5PUa
        iok5T83UDn08BOBmSsikF4HycnLFJ6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-q4cbpdrYOIeVl-OSojS6fA-1; Fri, 03 Apr 2020 03:59:01 -0400
X-MC-Unique: q4cbpdrYOIeVl-OSojS6fA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2ED85800D5C;
        Fri,  3 Apr 2020 07:58:59 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C5A85C1D6;
        Fri,  3 Apr 2020 07:58:49 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:58:47 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, jwi@linux.ibm.com,
        jianglidong3@jd.com, Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
Message-ID: <20200403095847.21e1e5ea@carbon>
In-Reply-To: <CAADnVQKEyv_bRhEfu1Jp=DSggj_O2xjJyd_QZ7a4LJY+dUO2rg@mail.gmail.com>
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
        <20200331060641.79999-1-maowenan@huawei.com>
        <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
        <20200401181419.7acd2aa6@carbon>
        <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
        <20200402110619.48f31a63@carbon>
        <CAADnVQKEyv_bRhEfu1Jp=DSggj_O2xjJyd_QZ7a4LJY+dUO2rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Apr 2020 08:40:23 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Apr 2, 2020 at 2:06 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > On Thu, 2 Apr 2020 09:47:03 +0900
> > Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> >  
> > > On 2020/04/02 1:15, Jesper Dangaard Brouer wrote:
> > > ...  
> > > > [PATCH RFC net-next] veth: adjust hard_start offset on redirect XDP frames
> > > >
> > > > When native XDP redirect into a veth device, the frame arrives in the
> > > > xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> > > > which can run a new XDP bpf_prog on the packet. Doing so requires
> > > > converting xdp_frame to xdp_buff, but the tricky part is that
> > > > xdp_frame memory area is located in the top (data_hard_start) memory
> > > > area that xdp_buff will point into.
> > > >
> > > > The current code tried to protect the xdp_frame area, by assigning
> > > > xdp_buff.data_hard_start past this memory. This results in 32 bytes
> > > > less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
> > > >
> > > > This protect step is actually not needed, because BPF-helper
> > > > bpf_xdp_adjust_head() already reserve this area, and don't allow
> > > > BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> > > > directly at xdp_frame memory area.
> > > >
> > > > Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>  
> > >
> > > FYI: This mail address is deprecated.
> > >  
> > > > Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> > > > Reported-by: Mao Wenan <maowenan@huawei.com>
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> > >
> > > FWIW,
> > >
> > > Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>  
> >
> > Thanks.
> >
> > I have updated your email and added your ack in my patchset.  I will
> > submit this officially once net-next opens up again[1], as part my
> > larger patchset for introducing XDP frame_sz.  
> 
> It looks like bug fix to me.
> The way I read it that behavior of bpf_xdp_adjust_head() is a bit
> buggy with veth netdev,
> so why wait ?

I want to wait to ease your life as maintainer. This is part of a
larger patchset (for XDP frame_sz) and the next patch touch same code
path and thus depend on these code adjustments.  If we apply them in
bpf vs bpf-next then you/we will have to handle merge conflicts.  The
severity of the "fix" is really low, it only means 32 bytes less
headroom (which I doubt anyone is using).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

