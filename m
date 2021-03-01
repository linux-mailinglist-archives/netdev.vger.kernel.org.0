Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5BD327893
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhCAHtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232513AbhCAHtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 02:49:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614584956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2B9MJXlv2X61p2FUcZmOj69JIxo7YuUgXxlffNwGWpQ=;
        b=T/XipaE74ZzKT5WpggcI7gII/ThFRxJrKDtoUDhpbOUfR4qCi7pi+boDo6rjum82ESSGoG
        ZzqZvCwy7XS5zcEOUPRvyvU1+T8rPvS1ulloK9A3jwLq4BNg+eRjiQ/uwFPyncUKHs1A75
        ocGdljZHq7cFo05FQWNYbNNlE/PIN/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-GWYGZuuGMLiydwITnF-GSQ-1; Mon, 01 Mar 2021 02:49:12 -0500
X-MC-Unique: GWYGZuuGMLiydwITnF-GSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DC53801975;
        Mon,  1 Mar 2021 07:49:08 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F05C45C67A;
        Mon,  1 Mar 2021 07:48:48 +0000 (UTC)
Date:   Mon, 1 Mar 2021 08:48:47 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        freysteinn.alfredsson@kau.se, john.fastabend@gmail.com,
        jasowang@redhat.com, mst@redhat.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk,
        ilias.apalodimas@linaro.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com,
        ecree.xilinx@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <20210301084847.5117a404@carbon>
In-Reply-To: <YDwYzYVIDQABINyy@lore-laptop-rh>
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
        <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
        <YDwYzYVIDQABINyy@lore-laptop-rh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Feb 2021 23:27:25 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > >  	drops = bq->count - sent;
> > > -out:
> > > -	bq->count = 0;
> > > +	if (unlikely(drops > 0)) {
> > > +		/* If not all frames have been transmitted, it is our
> > > +		 * responsibility to free them
> > > +		 */
> > > +		for (i = sent; i < bq->count; i++)
> > > +			xdp_return_frame_rx_napi(bq->q[i]);
> > > +	}  
> > 
> > Wouldn't the logic above be the same even w/o the 'if' condition ?  
> 
> it is just an optimization to avoid the for loop instruction if sent = bq->count

True, and I like this optimization.
It will affect how the code layout is (and thereby I-cache usage).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

