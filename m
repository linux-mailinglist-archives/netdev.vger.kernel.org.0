Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8134F13C7F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfEEBKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:10:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfEEBKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:10:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A231CA1F5;
        Sun,  5 May 2019 01:10:32 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B03C60C18;
        Sun,  5 May 2019 01:10:23 +0000 (UTC)
Date:   Sun, 5 May 2019 09:10:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH V4 0/3] scsi: core: avoid big pre-allocation for sg list
Message-ID: <20190505011017.GD655@ming.t460p>
References: <20190428073932.9898-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428073932.9898-1-ming.lei@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Sun, 05 May 2019 01:10:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 03:39:29PM +0800, Ming Lei wrote:
> Hi,
> 
> Since supporting to blk-mq, big pre-allocation for sg list is introduced,
> this way is very unfriendly wrt. memory consumption.
> 
> There were Red Hat internal reports that some scsi_debug based tests
> can't be run any more because of too big pre-allocation.
> 
> Also lpfc users commplained that 1GB+ ram is pre-allocatd for single
> HBA.
> 
> sg_alloc_table_chained() is improved to support variant size of 1st
> pre-allocated SGL in the 1st patch as suggested by Christoph.
> 
> The other two patches try to address this issue by allocating sg list runtime,
> meantime pre-allocating one or two inline sg entries for small IO. This
> ways follows NVMe's approach wrt. sg list allocation.
> 
> V4:
> 	- add parameter to sg_alloc_table_chained()/sg_free_table_chained()
> 	directly, and update current callers
> 
> V3:
> 	- improve sg_alloc_table_chained() to accept variant size of
> 	the 1st pre-allocated SGL
> 	- applies the improved sg API to address the big pre-allocation
> 	issue
> 
> V2:
> 	- move inline sg table initializetion into one helper
> 	- introduce new helper for getting inline sg
> 	- comment log fix
> 
> 
> Ming Lei (3):
>   lib/sg_pool.c: improve APIs for allocating sg pool
>   scsi: core: avoid to pre-allocate big chunk for protection meta data
>   scsi: core: avoid to pre-allocate big chunk for sg list
> 
>  drivers/nvme/host/fc.c            |  7 ++++---
>  drivers/nvme/host/rdma.c          |  7 ++++---
>  drivers/nvme/target/loop.c        |  4 ++--
>  drivers/scsi/scsi_lib.c           | 31 ++++++++++++++++++++++---------
>  include/linux/scatterlist.h       | 11 +++++++----
>  lib/scatterlist.c                 | 36 +++++++++++++++++++++++-------------
>  lib/sg_pool.c                     | 37 +++++++++++++++++++++++++++----------
>  net/sunrpc/xprtrdma/svc_rdma_rw.c |  5 +++--
>  8 files changed, 92 insertions(+), 46 deletions(-)
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-nvme@lists.infradead.org

Hi Martin,

Could you consider to merge this patchset to 5.2 if you are fine?


Thanks,
Ming
