Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4870E178D40
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgCDJTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:19:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726137AbgCDJTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:19:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583313551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FI5hMv/arl4qoCeh1Zs40mfxO3eHqAJDiq6mor5YF9w=;
        b=GQZ/SWkAia+CRexjYrbeS8enM+W/KZi7LPdzN2+I87nI2xiB9jTkUapurmJ64jWZdVr4wU
        0F8ctU4/Wcq9LvOmQJgsogHuIaSwInAMvj9J2lNfv8B+GZm/ZqVfSfYjpk0dz3rLe9ROFJ
        VwUw4C+aGR9kIkHNIAUmUSq0wFn+Wqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-g8imVRMWMAy_rwQX3efAQg-1; Wed, 04 Mar 2020 04:19:08 -0500
X-MC-Unique: g8imVRMWMAy_rwQX3efAQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 650CF1005514;
        Wed,  4 Mar 2020 09:19:06 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 985709CA3;
        Wed,  4 Mar 2020 09:18:56 +0000 (UTC)
Date:   Wed, 4 Mar 2020 10:18:53 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb
 linearization
Message-ID: <20200304101853.760034dc@carbon>
In-Reply-To: <CA+FuTSeL_psqzpB6hxSh6f1HnO_SrpED=71Y3HcyDweG2Y3sdg@mail.gmail.com>
References: <20200228105435.75298-1-lrizzo@google.com>
        <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com>
        <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net>
        <20200303125020.2baef01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+FuTSeL_psqzpB6hxSh6f1HnO_SrpED=71Y3HcyDweG2Y3sdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 16:10:14 -0500
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Tue, Mar 3, 2020 at 3:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 3 Mar 2020 20:46:55 +0100 Daniel Borkmann wrote:  
> > > Thus, when the data/data_end test fails in generic XDP, the user can
> > > call e.g. bpf_xdp_pull_data(xdp, 64) to make sure we pull in as much as
> > > is needed w/o full linearization and once done the data/data_end can be
> > > repeated to proceed. Native XDP will leave xdp->rxq->skb as NULL, but
> > > later we could perhaps reuse the same bpf_xdp_pull_data() helper for
> > > native with skb-less backing. Thoughts?  
> 
> Something akin to pskb_may_pull sounds like a great solution to me.
> 
> Another approach would be a new xdp_action XDP_NEED_LINEARIZED that
> causes the program to be restarted after linearization. But that is both
> more expensive and less elegant.
> 
> Instead of a sysctl or device option, is this an optimization that
> could be taken based on the program? Specifically, would XDP_FLAGS be
> a path to pass a SUPPORT_SG flag along with the program? I'm not
> entirely familiar with the XDP setup code, so this may be a totally
> off. But from a quick read it seems like generic_xdp_install could
> transfer such a flag to struct net_device.
> 
> > I'm curious why we consider a xdpgeneric-only addition. Is attaching
> > a cls_bpf program noticeably slower than xdpgeneric?  
> 
> This just should not be xdp*generic* only, but allow us to use any XDP
> with large MTU sizes and without having to disable GRO.

This is an important point: "should not be xdp*generic* only".

I really want to see this work for XDP-native *first*, and it seems
that with Daniel's idea, it can can also work for XDP-generic.  As Jakub
also hinted, it seems strange that people are trying to implement this
for XDP-generic, as I don't think there is any performance advantage
over cls_bpf.  We really want this to work from XDP-native.


> I'd still like a way to be able to drop or modify packets before GRO,
> or to signal that a type of packet should skip GRO.

That is a use-case, that we should remember to support.

Samih (cc'ed) is working on adding multi-frame support[1] to XDP-native.
Given the huge interest this thread shows, I think I will dedicate
some of my time to help him out on the actual coding.

For my idea to work[1], we first have storage space for the multi-buffer
references, and I propose we use the skb_shared_info area, that is
available anyhow for XDP_PASS that calls build_skb().  Thus, we first
need to standardize across all XDP drivers, how and where this memory
area is referenced/offset.


[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
[2] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#storage-space-for-multi-buffer-referencessegments
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

