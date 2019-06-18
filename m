Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4397049C1E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 10:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfFRIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 04:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFRIhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 04:37:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCFB93082231;
        Tue, 18 Jun 2019 08:37:15 +0000 (UTC)
Received: from carbon (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 391621001E60;
        Tue, 18 Jun 2019 08:37:07 +0000 (UTC)
Date:   Tue, 18 Jun 2019 10:37:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net-next v1 09/11] xdp: force mem allocator removal and
 periodic warning
Message-ID: <20190618103706.01fa6fa4@carbon>
In-Reply-To: <20190615085915.GA3771@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
        <156045052757.29115.17148153291969774246.stgit@firesoul>
        <20190615085915.GA3771@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 18 Jun 2019 08:37:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Jun 2019 11:59:16 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> >@@ -388,10 +411,12 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
> > 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
> > 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > 		page = virt_to_head_page(data);
> >-		if (xa) {
> >+		if (likely(xa)) {
> > 			napi_direct &= !xdp_return_frame_no_direct();
> > 			page_pool_put_page(xa->page_pool, page, napi_direct);
>
> Interesting if it's synced with device "unregistration".
> I mean page dma unmap is bind to device that doesn't exist anymore but pages
> from pool of the device are in flight, so pool is not destroyed but what about
> device?. smth like device unreq todo list. Just to be sure, is it synched?

I looked through the code, and you are right.  We are actually missing
to hold a reference count on struct device (for which we use dev->dma_ops).
It looks like we can simply do a get_device() and put_device(). Thus,
fairly simple to fix.

I'll add this fix as a separate patch, as it is a separate issue/bug
that also needs correction... Thanks for catching this!

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
