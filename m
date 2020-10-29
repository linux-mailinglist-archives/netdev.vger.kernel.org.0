Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BF29ED83
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgJ2NtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:49:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbgJ2NtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603979344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0rlmArJvbVvJEBWOLEuSR50AsEijn3gNILSqB++8/M=;
        b=RetVhy3fTw7yPk/j8qeEc+FyD8Yn7v20IF5SyNOHAwDlj6KolmrursoI/eQnYEgqb3slWX
        VLZAyY1tzuLdCxJIt50I5nDI2WD6YL7DOXe2Ue9NBrdljR8l30t4CxLVe41LAlVmCzAm0G
        aRvv3z6tJdONKC9Qt0SIlRDmo76S6Uk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-fCtIipZoNvmxH8-hFQHRSw-1; Thu, 29 Oct 2020 09:40:49 -0400
X-MC-Unique: fCtIipZoNvmxH8-hFQHRSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53DEB10200D3;
        Thu, 29 Oct 2020 13:40:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9C31100238E;
        Thu, 29 Oct 2020 13:40:39 +0000 (UTC)
Date:   Thu, 29 Oct 2020 14:40:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net-next 2/4] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201029144038.74ecf3c2@carbon>
In-Reply-To: <20201029103148.GA15697@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
        <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
        <20201029111329.79b86c00@carbon>
        <20201029103148.GA15697@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 11:31:48 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Tue, 27 Oct 2020 20:04:08 +0100
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >   
> > > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > > +			     int count)
> > > +{
> > > +	struct page *page_ring[XDP_BULK_QUEUE_SIZE];  
> > 
> > Maybe we could reuse the 'data' array instead of creating a new array
> > (2 cache-lines long) for the array of pages?  
> 
> I agree, I will try to reuse the data array for that
> 
> >   
> > > +	int i, len = 0;
> > > +
> > > +	for (i = 0; i < count; i++) {
> > > +		struct page *page = virt_to_head_page(data[i]);
> > > +
> > > +		if (unlikely(page_ref_count(page) != 1 ||
> > > +			     !pool_page_reusable(pool, page))) {
> > > +			page_pool_release_page(pool, page);
> > > +			put_page(page);
> > > +			continue;
> > > +		}
> > > +
> > > +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > > +			page_pool_dma_sync_for_device(pool, page, -1);  
> > 
> > Here we sync the entire DMA area (-1), which have a *huge* cost for
> > mvneta (especially on EspressoBin HW).  For this xdp_frame->len is
> > unfortunately not enough.  We will need the *maximum* length touch by
> > (1) CPU and (2) remote device DMA engine.  DMA-TX completion knows the
> > length for (2).  The CPU length (1) is max of original xdp_buff size
> > and xdp_frame->len, because BPF-helpers could have shrinked the size.
> > (tricky part is that xdp_frame->len isn't correct in-case of header
> > adjustments, thus like mvneta_run_xdp we to calc dma_sync size, and
> > store this in xdp_frame, maybe via param to xdp_do_redirect). Well, not
> > sure if it is too much work to transfer this info, for this use-case.  
> 
> I was thinking about that but I guess point (1) is tricky since "cpu length"
> can be changed even in the middle by devmaps or cpumaps (not just in the driver
> rx napi loop). I guess we can try to address this point in a subsequent series.
> Agree?

I agree, that this change request goes beyond this series.  But it
becomes harder and harder to add later when this API is getting used in
more and more drivers.  Looking at 1/4 is can be extended later, as you
just pass down xdpf in API driver use (and then queue xdpf->data).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

