Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C42233F5B9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhCQQja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232109AbhCQQi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615999138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BFXuz+V1IZqHA0Ul5BuH98TEHuJmu/wAVpUaxScltU=;
        b=X/Qg6VXvhTSD8ffac5Wryen1G6lA07h7rheDEifOBRBEMw93kSNIo//14ZWVZ5xz5AHHi8
        stvxz+34pY9CgA1DLmK3RWoAbatraokpzHFOh8QPXUjEiKk8v7Ewlk9IS+fjcjmTlZl3Zh
        Uwo1zXSookzOYnQbnX/tI8LcQCwjZr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-b_c398UsOq2LX9gP5uCXUQ-1; Wed, 17 Mar 2021 12:38:54 -0400
X-MC-Unique: b_c398UsOq2LX9gP5uCXUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49D94190A7A2;
        Wed, 17 Mar 2021 16:38:52 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D160B19C45;
        Wed, 17 Mar 2021 16:38:45 +0000 (UTC)
Date:   Wed, 17 Mar 2021 17:38:44 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 0/7 v4] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210317173844.6b10f879@carbon>
In-Reply-To: <20210317163055.800210-1-alobakin@pm.me>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
        <20210317163055.800210-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 16:31:07 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> From: Mel Gorman <mgorman@techsingularity.net>
> Date: Fri, 12 Mar 2021 15:43:24 +0000
> 
> Hi there,
> 
> > This series is based on top of Matthew Wilcox's series "Rationalise
> > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > test and are not using Andrew's tree as a baseline, I suggest using the
> > following git tree
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v4r2  
> 
> I gave this series a go on my setup, it showed a bump of 10 Mbps on
> UDP forwarding, but dropped TCP forwarding by almost 50 Mbps.
> 
> (4 core 1.2GHz MIPS32 R2, page size of 16 Kb, Page Pool order-0
> allocations with MTU of 1508 bytes, linear frames via build_skb(),
> GRO + TSO/USO)

What NIC driver is this?

> I didn't have time to drill into the code, so for now can't provide
> any additional details. You can request anything you need though and
> I'll try to find a window to collect it.
> 
> > Note to Chuck and Jesper -- as this is a cross-subsystem series, you may
> > want to send the sunrpc and page_pool pre-requisites (patches 4 and 6)
> > directly to the subsystem maintainers. While sunrpc is low-risk, I'm
> > vaguely aware that there are other prototype series on netdev that affect
> > page_pool. The conflict should be obvious in linux-next.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

