Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96351A778D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437729AbgDNJoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:44:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729503AbgDNJoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586857449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LjxeJjQxERiNLFziVWG1YXicU4Gh17nrIcM7VgiXAaE=;
        b=OOunao9uARfUezEk27HaWuW9S6TX4EoKGHDT1HPwE3I6I2z0aAnk5yf17QXVJ1262XlJZu
        cGgDLe8i8m/BSXR/4NQ4TUBcUpF9uZq58KyNkDFzS7Cg1U+sGDE4OqBee88Jk6DItwwWwJ
        MQyvwxY4FQWB5da75K0o/+/zsDYUgmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-UaDNhSB_MPm3cK1g0MwMuw-1; Tue, 14 Apr 2020 05:44:06 -0400
X-MC-Unique: UaDNhSB_MPm3cK1g0MwMuw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4878017F3;
        Tue, 14 Apr 2020 09:44:04 +0000 (UTC)
Received: from carbon (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0D3B11A023;
        Tue, 14 Apr 2020 09:43:53 +0000 (UTC)
Date:   Tue, 14 Apr 2020 11:43:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        toke@redhat.com, borkmann@iogearbox.net,
        alexei.starovoitov@gmail.com, john.fastabend@gmail.com,
        alexander.duyck@gmail.com, jeffrey.t.kirsher@intel.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        ilias.apalodimas@linaro.org, lorenzo@kernel.org,
        saeedm@mellanox.com, brouer@redhat.com
Subject: Re: [PATCH RFC v2 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
Message-ID: <20200414114352.16e6a279@carbon>
In-Reply-To: <20200408.144914.956216445223066424.davem@davemloft.net>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634678679.707275.5039642404868230051.stgit@firesoul>
        <20200408.144914.956216445223066424.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Apr 2020 14:49:14 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Wed, 08 Apr 2020 13:53:06 +0200
> 
> > @@ -3445,6 +3445,11 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >  	if (unlikely(data_end < xdp->data + ETH_HLEN))
> >  		return -EINVAL;
> >  
> > +	/* Clear memory area on grow, can contain uninit kernel memory */
> > +	if (offset > 0) {
> > +		memset(xdp->data_end, 0, offset);
> > +	}  
> 
> Single statement basic blocks should elide curly braces.

Fixed

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

