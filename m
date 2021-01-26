Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E35304717
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 19:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbhAZROw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:14:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389994AbhAZJPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611652421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZQNMLxZXL4V+OpSXDYs3PfwSfoYKXj1zeTe+gx9+fVk=;
        b=iWljQ9OXM9/cGP5O5HDQkf2WOj6pK9gYQTeYYx1GURxnHQzmJghu2cHAzarvxdYKHyzaDO
        1QVOnLWKduffzbm9VfJPcxU+xVfSwmk9WRwCuwnGax9BnpJwNjprXvzVpqIzRCR7/7A9ws
        yCqAod8Cm+4kZ7WxBpLVCdAimVg33s4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-Gz-I5AYiO9-Nc9EqgAIqwA-1; Tue, 26 Jan 2021 04:13:36 -0500
X-MC-Unique: Gz-I5AYiO9-Nc9EqgAIqwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE03A10054FF;
        Tue, 26 Jan 2021 09:13:34 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 391621F0;
        Tue, 26 Jan 2021 09:13:27 +0000 (UTC)
Date:   Tue, 26 Jan 2021 10:13:25 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V12 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210126101325.75097ddb@carbon>
In-Reply-To: <3c542e42-2033-aca6-ba0e-4854c24980c2@iogearbox.net>
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
        <161098887018.108067.13643446976934084937.stgit@firesoul>
        <6772a12b-2a60-bb3b-93df-1d6d6c7c7fd7@iogearbox.net>
        <20210125094148.2b3bb128@carbon>
        <3c542e42-2033-aca6-ba0e-4854c24980c2@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 23:27:22 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> >>> +	/* At this point, skb->len exceed MTU, but as it include length of all
> >>> +	 * segments, it can still be below MTU.  The SKB can possibly get
> >>> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> >>> +	 * must choose if segs are to be MTU checked.
> >>> +	 */
> >>> +	if (skb_is_gso(skb)) {
> >>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> >>> +
> >>> +		if (flags & BPF_MTU_CHK_SEGS &&
> >>> +		    !skb_gso_validate_network_len(skb, mtu))
> >>> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;  
> >>
> >> I think that looks okay overall now. One thing that will easily slip through
> >> is that in the helper description you mentioned 'Check cannot use len_diff.'
> >> for BPF_MTU_CHK_SEGS flag. So right now for non-zero len_diff the user
> >> will still get BPF_MTU_CHK_RET_SUCCESS if the current length check via
> >> skb_gso_validate_network_len(skb, mtu) passes. If it cannot be checked,
> >> maybe enforce len_diff == 0 for gso skbs on BPF_MTU_CHK_SEGS?  
> > 
> > Ok. Do you want/think this can be enforced by the verifier or are you
> > simply requesting that the helper will return -EINVAL (or another errno)?  
> 
> Simple -EINVAL should be fine in this case. Generally, we can detect this from
> verifier side but I don't think the extra complexity is worth it especially given
> this is dependent on BPF_MTU_CHK_SEGS and otherwise can be non-zero.

Luckily this was also my choice in V13 that I've already send out.

https://lore.kernel.org/netdev/161159457239.321749.9067604476261493815.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

