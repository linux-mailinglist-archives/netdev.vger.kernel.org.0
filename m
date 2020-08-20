Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C623924B04E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgHTHrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:47:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbgHTHrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 03:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597909640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afYAmefC1IpSW3rtllSNigzU5YzEXsMpfpWcsvn1W1o=;
        b=cgKJy8PTkQmUk9E8eOaj/dsnO98LUQpbxJ5kH5aFBRUNxi67X61Vx0c2b8TtdxnHyo6YDq
        PxwGc0SbPhTfgVMfrUzWDF72kflp79bFnBPr+VjeB5EO5jw7JtEBXGu2EE363mZofRCxd5
        pn/AAC2BAoWLqWhAOnNUfh/Eva4QbOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-bs6FjRRYMdOYKUqEOWOF-Q-1; Thu, 20 Aug 2020 03:47:16 -0400
X-MC-Unique: bs6FjRRYMdOYKUqEOWOF-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22A7E425D5;
        Thu, 20 Aug 2020 07:47:15 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 951897E30E;
        Thu, 20 Aug 2020 07:47:05 +0000 (UTC)
Date:   Thu, 20 Aug 2020 09:47:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, echaudro@redhat.com,
        sameehj@amazon.com, brouer@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Message-ID: <20200820094704.17840324@carbon>
In-Reply-To: <5f3da06d5de6c_1b0e2ab87245e5c01b@john-XPS-13-9370.notmuch>
References: <cover.1597842004.git.lorenzo@kernel.org>
        <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
        <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200819202223.GA179529@lore-desk>
        <20200819141428.24e5183a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f3da06d5de6c_1b0e2ab87245e5c01b@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 14:58:05 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Jakub Kicinski wrote:
> > On Wed, 19 Aug 2020 22:22:23 +0200 Lorenzo Bianconi wrote:  
> > > > On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote:    
> > > > > Enable the capability to receive jumbo frames even if the interface is
> > > > > running in XDP mode
> > > > > 
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>    
> > > > 
> > > > Hm, already? Is all the infra in place? Or does it not imply
> > > > multi-buffer.  
> > > 
> > > with this series mvneta supports xdp multi-buff on both rx and tx sides (XDP_TX
> > > and ndo_xpd_xmit()) so we can remove MTU limitation.  
> > 
> > Is there an API for programs to access the multi-buf frames?  
> 
> Hi Lorenzo,
> 
> This is not enough to support multi-buffer in my opinion. I have the
> same comment as Jakub. We need an API to pull in the multiple
> buffers otherwise we break the ability to parse the packets and that
> is a hard requirement to me. I don't want to lose visibility to get
> jumbo frames.
> 
> At minimum we need a bpf_xdp_pull_data() to adjust pointer. In the
> skmsg case we use this,
> 
>   bpf_msg_pull_data(u32 start, u32 end, u64 flags)
> 
> Where start is the offset into the packet and end is the last byte we
> want to adjust start/end pointers to. This way we can walk pages if
> we want and avoid having to linearize the data unless the user actual
> asks us for a block that crosses a page range. Smart users then never
> do a start/end that crosses a page boundary if possible. I think the
> same would apply here.
> 
> XDP by default gives you the first page start/end to use freely. If
> you need to parse deeper into the payload then you call bpf_msg_pull_data
> with the byte offsets needed.

I agree that we need a helper like this. (I also think Daniel have
proposed this before).  This would also be useful for Eric Dumazet /
Google's header-split use-case[1].  As I understood from his talk[1],
the NIC HW might not always split the packet correctly (due to HW
limits). This helper could solve part of this challenge.


[1] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

