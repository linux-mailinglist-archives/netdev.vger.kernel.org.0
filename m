Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEDD2872BF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbgJHKq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729571AbgJHKqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 06:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602153983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1s2AOQ8c8V+Fh7lGuyVZZ09B+PUmg+jBpS2SsvH9XY=;
        b=ENsk83Aiq30lkS4hTdzAUrLLMY5nqX9wgX7v0QKHrUT98UKzvtFVTGM5MuNeoYHYMsB9WP
        XBNAqUvb5PFaxubMS00/vMBnjKtr2P/LZlwDRwvKvKg6XD4KyHTincmGwWtQjEHqKbl/Eb
        oLM0lrUSz6UeC5oyQbwslBPShjxYJVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-qWcHv-RvPXCue3sAczM7NQ-1; Thu, 08 Oct 2020 06:46:19 -0400
X-MC-Unique: qWcHv-RvPXCue3sAczM7NQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 883851054F8A;
        Thu,  8 Oct 2020 10:46:16 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23FE15C1DC;
        Thu,  8 Oct 2020 10:46:05 +0000 (UTC)
Date:   Thu, 8 Oct 2020 12:46:04 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <sameehj@amazon.com>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <lorenzo.bianconi@redhat.com>, <echaudro@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH v4 bpf-next 09/13] bpf: introduce multibuff support to
 bpf_prog_test_run_xdp()
Message-ID: <20201008124604.05db39e8@carbon>
In-Reply-To: <pj41zl362puop5.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <cover.1601648734.git.lorenzo@kernel.org>
        <d6ed575afaf89fc35e233af5ccd063da944b4a3a.1601648734.git.lorenzo@kernel.org>
        <pj41zl362puop5.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 11:06:14 +0300
Shay Agroskin <shayagr@amazon.com> wrote:

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> 
> > Introduce the capability to allocate a xdp multi-buff in
> > bpf_prog_test_run_xdp routine. This is a preliminary patch to 
> > introduce
> > the selftests for new xdp multi-buff ebpf helpers
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/bpf/test_run.c | 51  ++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 43 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index bd291f5f539c..ec7286cd051b 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -617,44 +617,79 @@ int bpf_prog_test_run_xdp(struct bpf_prog 
> > *prog, const union bpf_attr *kattr,
> >  {
> >  	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct 
> >  skb_shared_info));
> >  	u32 headroom = XDP_PACKET_HEADROOM;
> > -	u32 size = kattr->test.data_size_in;
> >  	u32 repeat = kattr->test.repeat;
> >  	struct netdev_rx_queue *rxqueue;
> > +	struct skb_shared_info *sinfo;
> >  	struct xdp_buff xdp = {};
> > +	u32 max_data_sz, size;
> >  	u32 retval, duration;
> > -	u32 max_data_sz;
> > +	int i, ret, data_len;
> >  	void *data;
> > -	int ret;
> >  
> >  	if (kattr->test.ctx_in || kattr->test.ctx_out)
> >  		return -EINVAL;
> >  
> > -	/* XDP have extra tailroom as (most) drivers use full page 
> > */
> >  	max_data_sz = 4096 - headroom - tailroom;  
> 
> For the sake of consistency, can this 4096 be changed to PAGE_SIZE 
> ?

The size 4096 is explicitly use, because the selftest xdp_adjust_tail
expect this, else it will fail on ARCHs with 64K PAGE_SIZE.  It also
seems excessive to create 64K packets for testing XDP.

See: tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c

> Same as in
>      data_len = min_t(int, kattr->test.data_size_in - size, 
>      PAGE_SIZE);
> 
> expression below



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

