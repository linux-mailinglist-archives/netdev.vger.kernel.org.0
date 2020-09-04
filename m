Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3002025DA78
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgIDNw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:52:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47099 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730584AbgIDNwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599227535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYq/ngNtxyj1dA7QpICDFe09d9alOPPDrbtnlBjMrSY=;
        b=Gsvw/BF2otF7jNOrK3nZqxVvf3PWvdkOnlRskVm1tTCWn2hLi+5vi9SQxLFvcHvSKtRQF0
        Cid4REz4F6IlCV1/iOBDXXOYy6SxkqF2bX+3lhM1cYMufp7JXU4Oyq6D/TMdqCQ5YKx7KX
        9a0nEDh1nqqAtcjFGWf1Hl7ABs332UU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-T6kWIjYaNR6eFjQq0PN0IA-1; Fri, 04 Sep 2020 09:52:13 -0400
X-MC-Unique: T6kWIjYaNR6eFjQq0PN0IA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED2A21DE15;
        Fri,  4 Sep 2020 13:52:11 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D02A7E410;
        Fri,  4 Sep 2020 13:52:01 +0000 (UTC)
Date:   Fri, 4 Sep 2020 15:52:00 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200904155200.75f8d65a@carbon>
In-Reply-To: <20200904075031.GC2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
        <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
        <20200904011358.kbdxf4awugi3qwjl@ast-mbp.dhcp.thefacebook.com>
        <20200904075031.GC2884@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 09:50:31 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > On Thu, Sep 03, 2020 at 10:58:50PM +0200, Lorenzo Bianconi wrote:  
> > > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > > +	   int, offset)
> > > +{
> > > +	void *data_hard_end, *data_end;
> > > +	struct skb_shared_info *sinfo;
> > > +	int frag_offset, frag_len;
> > > +	u8 *addr;
> > > +
> > > +	if (!xdp->mb)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	sinfo = xdp_get_shared_info_from_buff(xdp);
> > > +
> > > +	frag_len = skb_frag_size(&sinfo->frags[0]);
> > > +	if (offset > frag_len)
> > > +		return -EINVAL;
> > > +
> > > +	frag_offset = skb_frag_off(&sinfo->frags[0]);
> > > +	data_end = xdp->data_end + offset;
> > > +
> > > +	if (offset < 0 && (-offset > frag_offset ||
> > > +			   data_end < xdp->data + ETH_HLEN))
> > > +		return -EINVAL;
> > > +
> > > +	data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> > > +	if (data_end > data_hard_end)
> > > +		return -EINVAL;
> > > +
> > > +	addr = page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
> > > +	if (offset > 0) {
> > > +		memcpy(xdp->data_end, addr, offset);
> > > +	} else {
> > > +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> > > +		memset(xdp->data_end + offset, 0, -offset);
> > > +	}
> > > +
> > > +	skb_frag_size_sub(&sinfo->frags[0], offset);
> > > +	skb_frag_off_add(&sinfo->frags[0], offset);
> > > +	xdp->data_end = data_end;
> > > +
> > > +	return 0;
> > > +}  
> > 
> > wait a sec. Are you saying that multi buffer XDP actually should be skb based?
> > If that's what mvneta driver is doing that's fine, but that is not a
> > reasonable requirement to put on all other drivers.  
> 
> I did not got what you mean here. The xdp multi-buffer layout uses
> the skb_shared_info at the end of the first buffer to link subsequent
> frames [0] and we rely on skb_frag* utilities to set/read offset and
> length of subsequent buffers.

Yes, for now the same layout as "skb_shared_info" is "reuse", but I
think we should think of this as "xdp_shared_info" instead, as how it
is used for XDP is going to divert from SKBs.  We already discussed (in
conf call) that we could store the total len of "frags" here, to
simplify the other helper.

Using the skb_frag_* helper functions are misleading, and will make it
more difficult to divert from how SKB handle frags.  What about
introducing xdp_frag_* wrappers? (what do others think?)


> 
> [0] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/add-xdp-on-driver.html
>     - XDP multi-buffers section (slide 40)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

