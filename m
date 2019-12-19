Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9710C12639D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLSNfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 08:35:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38920 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbfLSNfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 08:35:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576762549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfDUZ+YWQDHdZQWx+qVgipwYQ5hX7WkURvwSh6ixxPs=;
        b=FvMCEDW1VTNE3cl08+WvUFnXad1NhB184uegBV5s1yL4fSHZB0N2NgBnVumsO5nhiK1//p
        9GyBPIlkuXhhQKD/W5Vv6RNf7oIRLYaWFQy1LZruHpsL8jgbPPVCWAEDIdol9Q5rWAIrqU
        Ub4/InWvkS7v1NgFkK0slE1+E/H/HHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-6sRbYs7nPuGEk8tKp59MsA-1; Thu, 19 Dec 2019 08:35:45 -0500
X-MC-Unique: 6sRbYs7nPuGEk8tKp59MsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4148E104ED28;
        Thu, 19 Dec 2019 13:35:44 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DB1B5C1B0;
        Thu, 19 Dec 2019 13:35:36 +0000 (UTC)
Date:   Thu, 19 Dec 2019 14:35:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, brouer@redhat.com
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191219143535.6c7bc880@carbon>
In-Reply-To: <20191219120925.GD26945@dhcp22.suse.cz>
References: <20191218084437.6db92d32@carbon>
        <157665609556.170047.13435503155369210509.stgit@firesoul>
        <20191219120925.GD26945@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 13:09:25 +0100
Michal Hocko <mhocko@kernel.org> wrote:

> On Wed 18-12-19 09:01:35, Jesper Dangaard Brouer wrote:
> [...]
> > For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> > node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> > chunks per allocation and allocation fall-through to the real
> > page-allocator with the new nid derived from numa_mem_id(). We accept
> > that transitioning the alloc cache doesn't happen immediately.  

Oh, I just realized that the drivers usually refill several RX
packet-pages at once, this means that this is called N times, meaning
during a NUMA change this will result in N * 65 pages returned.


> Could you explain what is the expected semantic of NUMA_NO_NODE in this
> case? Does it imply always the preferred locality? See my other email[1] to
> this matter.

I do think we want NUMA_NO_NODE to mean preferred locality. My code
allow the page to come from a remote NUMA node, but once it is returned
via the ptr_ring, we return pages not belonging to the local NUMA node
(determined by the CPU processing RX packets from the drivers RX-ring).


> [1] http://lkml.kernel.org/r/20191219115338.GC26945@dhcp22.suse.cz

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

