Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9B63792E7
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhEJPkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:40:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233751AbhEJPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620661083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liHdOXjVPGt9jkrJHGVWyaUfEEjXSh27QiDlSi8Z9tI=;
        b=XtCTVLIeQ/UqLJUdiQTB5q1RLoWWmOQdxLcm6PnS8tOMaVjDqcwoyQaq2XvSPDagqRaBM7
        oSj3TBjE5tJW/Bsqj3N2NmfjP5TufYiRGbGiCMDtNxTtEwqpFAknuLEQSj+5bYZqG81eJ4
        wKxOXDfH4qvnY8hgfY9y3a8oj6SBBfE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-8n95COwGM2ypyz7vyuSDLw-1; Mon, 10 May 2021 11:38:01 -0400
X-MC-Unique: 8n95COwGM2ypyz7vyuSDLw-1
Received: by mail-wm1-f70.google.com with SMTP id n9-20020a1c40090000b02901401bf40f9dso7138163wma.0
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=liHdOXjVPGt9jkrJHGVWyaUfEEjXSh27QiDlSi8Z9tI=;
        b=cf4Oum+B4l6gQ5OsoZwD+GDnRwRLsK69IIA3qJPX0G0ts7SrHSj/4VvShwQC6D0z/5
         nhp0OsMWtqrgI1Cz0xQ1nJHnFTPK8fPhRyeAhjlm3r/Ya1DxFrVIWIjRprdaA0h59YZ1
         k9HOm78TkGXkozk2G8B9Euuf1MFH7hbK2Gqu6fhdmXt3VEFwYa7XLsBI4yTFmQiBi2QH
         UniXLqaDaQrZd2wbf5/Xd7xCBWanSG8nzaxUaz8pdUCTAEDi/YUk0YVlpN16+zVd4SrG
         qzJ6ZGFNtnw10xkKKq8VgbhWdkOPTQOgJXLOorvvH+b+FE4jaB8WgG7F+rmNXm4r1Two
         oM0Q==
X-Gm-Message-State: AOAM531MKJPyBmtjaLrR5mDHkbd/AjUswuM3qvSuvwgOJUhtKFi7Omlp
        FYsVAWRogBzfEyezupcUi15rWN/cyxZLnyiLsdkxOIC6jJYbcRFPoFHy3yKIPtYRGEOIilgTEOc
        OPJiFSmrcSyZZzg86
X-Received: by 2002:a5d:6885:: with SMTP id h5mr31632180wru.229.1620661079871;
        Mon, 10 May 2021 08:37:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8UWchjNf4VF4UVeW22O8ARS/wYIwksuFZQY3QrnPZnn4qbKS4OoOS/AhoHXZUqvvstpZ/5w==
X-Received: by 2002:a5d:6885:: with SMTP id h5mr31632146wru.229.1620661079643;
        Mon, 10 May 2021 08:37:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id y2sm13988094wmq.45.2021.05.10.08.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 08:37:59 -0700 (PDT)
Message-ID: <3e41198f79b4d63812e3862ca688507bf3f7d65d.camel@redhat.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 10 May 2021 17:37:58 +0200
In-Reply-To: <6f4db46541880179766a30cf6d5e47f44190b98d.camel@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
         <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
         <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
         <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
         <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
         <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
         <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
         <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
         <20210506141739.0ab66f99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <6f4db46541880179766a30cf6d5e47f44190b98d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-07 at 10:46 +0200, Paolo Abeni wrote:
> On Thu, 2021-05-06 at 14:17 -0700, Jakub Kicinski wrote:
> > On Thu, 06 May 2021 17:55:36 +0200 Paolo Abeni wrote:
> > > On Thu, 2021-05-06 at 10:32 -0400, Willem de Bruijn wrote:
> > > > On Thu, May 6, 2021 at 7:07 AM Paolo Abeni <pabeni@redhat.com> wrote:  
> > > > > If we want to be safe about future possible sock_wfree users, I think
> > > > > the approach here should be different: in skb_segment(), tail-  
> > > > > > destructor is expected to be NULL, while skb_segment_list(), all the  
> > > > > list skbs can be owned by the same socket. Possibly we could open-
> > > > > code skb_release_head_state(), omitting the skb orphaning part
> > > > > for sock_wfree() destructor.
> > > > > 
> > > > > Note that the this is not currently needed - sock_wfree destructor
> > > > > can't reach there.
> > > > > 
> > > > > Given all the above, I'm unsure if you are fine with (or at least do
> > > > > not oppose to) the code proposed in this patch?  
> > > > 
> > > > Yes. Thanks for clarifying, Paolo.  
> > > 
> > > Thank you for reviewing!
> > > 
> > > @David, @Jakub: I see this series is already archived as "change
> > > requested", should I repost?
> > 
> > Yes, please. Patch 2 adds two new sparse warnings. 
> > 
> > I think you need csum_unfold() to go from __sum16 to __wsum.
> 
> Yes, indeed. I'll send a v2 with such change, thanks!

It's taking [much] more than expected, as it turned out that thare are
still a number of case where the tx csum is uncorrect.

If the traffic comes from a veth we don't have a valid th->csum value
at GRO time, setting ip_summed to CHECKSUM_UNNECESSARY - as the current
code does - looks wrong.
@Steffen: I see in the original discussion about GRO_FRAGLIST
introduction that you wanted the GRO packets to be CHECKSUM_UNNECESSARY
to avoid csum modification in fwd path. I guess that choice was mostily
due performance reasons, to avoid touching the aggregated pkts header
at gso_segment_list time, but it looks like it's quite bug prone. If
so, I'm unsure the performance gain is worty. I propose to switch to
CHECKSUM_PARTIAL. Would you be ok with that?

Thanks,

Paolo

