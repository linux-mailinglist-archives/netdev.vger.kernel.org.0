Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C067A2D97B9
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407760AbgLNLyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:54:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404511AbgLNLyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607946777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I46AtJGRfllTnbXs3tPtsbfpAVA6Q24/jlgqmeCMhmc=;
        b=Nyvyqc0cmk5e2CobWamB4mZe8OMCWqszSkVY+DYvOZWlmas19B9q9XnPnlP9YdiuHkx+en
        yx9WfQL40ym/Tp2BVPKWYx8BbdwIcs1m65zek+AWxCGYgpv7DoSXIn3h10T2yFtgsPOkim
        W5XbbR1pedD1zCUxTJYp1emNOfcCHJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-RKfSy3OmPcqm6Ek4MemKiA-1; Mon, 14 Dec 2020 06:52:54 -0500
X-MC-Unique: RKfSy3OmPcqm6Ek4MemKiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9165EEC1A0;
        Mon, 14 Dec 2020 11:52:51 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E5B71750D;
        Mon, 14 Dec 2020 11:52:44 +0000 (UTC)
Date:   Mon, 14 Dec 2020 12:52:42 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V7 4/8] bpf: add BPF-helper for MTU checking
Message-ID: <20201214125242.7cea3ecb@carbon>
In-Reply-To: <X8ktpX/BYfiL0l2l@google.com>
References: <160588903254.2817268.4861837335793475314.stgit@firesoul>
        <160588910708.2817268.17750536562819017509.stgit@firesoul>
        <X8ktpX/BYfiL0l2l@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 10:25:41 -0800
sdf@google.com wrote:

> > +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> > +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> > +{
> > +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +	struct net_device *dev = skb->dev;
> > +	int len;
> > +	int mtu;
> > +
> > +	if (flags & ~(BPF_MTU_CHK_SEGS))
> > +		return -EINVAL;
> > +
> > +	dev = __dev_via_ifindex(dev, ifindex);
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	mtu = READ_ONCE(dev->mtu);
> > +
> > +	/* TC len is L2, remove L2-header as dev MTU is L3 size */  
> 
> [..]
> > +	len = skb->len - ETH_HLEN;  
> Any reason not to do s/ETH_HLEN/dev->hard_header_len/ (or min_header_len?)
> thought this patch?

Will fix in V9.

There is a very small (performance) overhead, but mostly because
net_device struct layout have placed mtu and hard_header_len on
different cache-lines. (This is something that should be fixed
separately).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

