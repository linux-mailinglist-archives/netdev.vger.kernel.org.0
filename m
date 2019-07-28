Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8862077EAC
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 10:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfG1IqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 04:46:13 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59956 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG1IqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 04:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564303571; x=1595839571;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=fmh+KrgUGyJc3QHLpkwIoIxwupdb23F7VTtQ2lozaCQ=;
  b=TAdSlfU7R/iowSyr8BkBRm+XgsUMDaGICx7nZYi2qIfeT24fXtUlEJHQ
   GP31FFr2lkzh3qo4eR6p3Vt187O9u9qH7rdNpMh3JfNls+jU159jMSr3i
   hurk4V7ptWHT4JpGjpPCpM4OPAFlfDPs+5X3OadA/7rHM9czsOpFWKz4S
   0=;
X-IronPort-AV: E=Sophos;i="5.64,317,1559520000"; 
   d="scan'208";a="814310415"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Jul 2019 08:46:07 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 138C8A1EC7;
        Sun, 28 Jul 2019 08:46:07 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 28 Jul 2019 08:46:06 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.8) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 28 Jul 2019 08:46:02 +0000
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Michal Kalderon <mkalderon@marvell.com>
CC:     Kamal Heib <kamalheib1@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190725195236.GF7467@ziepe.ca>
 <MN2PR18MB3182BFFEA83044C0163F9DCBA1C00@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190726132316.GA8695@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <1e54c4de-7349-3154-1b98-39774c83899f@amazon.com>
Date:   Sun, 28 Jul 2019 11:45:56 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726132316.GA8695@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.8]
X-ClientProxiedBy: EX13D02UWB004.ant.amazon.com (10.43.161.11) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2019 16:23, Jason Gunthorpe wrote:
> On Fri, Jul 26, 2019 at 08:42:07AM +0000, Michal Kalderon wrote:
> 
>>>> But we don't free entires from the xa_array ( only when ucontext is
>>>> destroyed) so how will There be an empty element after we wrap ?
>>>
>>> Oh!
>>>
>>> That should be fixed up too, in the general case if a user is
>>> creating/destroying driver objects in loop we don't want memory usage to
>>> be unbounded.
>>>
>>> The rdma_user_mmap stuff has VMA ops that can refcount the xa entry and
>>> now that this is core code it is easy enough to harmonize the two things and
>>> track the xa side from the struct rdma_umap_priv
>>>
>>> The question is, does EFA or qedr have a use model for this that allows a
>>> userspace verb to create/destroy in a loop? ie do we need to fix this right
>>> now?
> 
>> The mapping occurs for every qp and cq creation. So yes.
>>
>> So do you mean add a ref-cnt to the xarray entry and from umap
>> decrease the refcnt and free?
> 
> Yes, free the entry (release the HW resource) and release the xa_array
> ID.

This is a bit tricky for EFA.
The UAR BAR resources (LLQ for example) aren't cleaned up until the UAR is
deallocated, so many of the entries won't really be freed when the refcount
reaches zero (i.e the HW considers these entries as refcounted as long as the
UAR exists). The best we can do is free the DMA buffers for appropriate entries.
