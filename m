Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9820D3759A0
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhEFRqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:46:20 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:34412 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbhEFRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 13:46:19 -0400
Received: by mail-wr1-f53.google.com with SMTP id t18so6514764wry.1;
        Thu, 06 May 2021 10:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LVy7GCswbFabLf4JlDLKnVxcaUnjw14rGjjZ1j3zHAo=;
        b=eoEU1TtgsGRA+OTXkSGI0VJKRDsVlCIxApqKVobLY9kvH9nedczAqqqkRJyna6+Cb2
         UozvVwt4aI6Eyb8QVctp/SkMhE9fHLA1oZ6r58elUUbQz6SFQAC92J2YuNoYodf2tIV/
         0QISfLcr7j0loBIYijhxY0dgFHxQmAaTqhqBkyXUJHSmR1aXzQvMHNb2GDp66aFGMihr
         a5OSpf4W9zOAWeWrQzZBKOZor6Dzf36L9e6zMGqqAAdLJz6h4RvRqiVg7lHZrrTfCgGh
         995bEogUKLidtOE0intcwmT+UxC5VPadN2ZY33WHGiP+UkRSqv9+LRbyQJaCfgAwkcAb
         46vw==
X-Gm-Message-State: AOAM530lwLGGOWoMkN6V9bjIvErbvPSlxiYyl5AXxcJvrYU2Z/qp/lL5
        g+yZxsZ7AhveztlHiDaJmps=
X-Google-Smtp-Source: ABdhPJzn6FXxTFWTbBzEYlXzlsqzI7YwFlP3sBU8PRA0QWhMvcHB//Wx9GAJqAeqCq1zwbNqPysisQ==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr6973906wrp.408.1620323118875;
        Thu, 06 May 2021 10:45:18 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n20sm1190865wmk.12.2021.05.06.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 10:45:18 -0700 (PDT)
Date:   Thu, 6 May 2021 17:45:16 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag() to
 generate requestIDs
Message-ID: <20210506174516.aiuuhu7oediqozv4@liuwe-devbox-debian-v2>
References: <20210415105926.3688-1-parri.andrea@gmail.com>
 <MWHPR21MB15936B2FBD1C1FE91C654F3DD74D9@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB15936B2FBD1C1FE91C654F3DD74D9@MWHPR21MB1593.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 01:22:32PM +0000, Michael Kelley wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, April 15, 2021 3:59 AM
> > 
> > Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> > all issues with allocating enough entries in the VMbus requestor.
> > 
> > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > ---
> > Changes since RFC:
> >   - pass sentinel values for {init,reset}_request in vmbus_sendpacket()
> >   - remove/inline the storvsc_request_addr() callback
> >   - make storvsc_next_request_id() 'static'
> >   - add code to handle the case of an unsolicited message from Hyper-V
> >   - other minor/style changes
> > 
> > [1] https://lore.kernel.org/linux-hyperv/20210408161315.341888-1-parri.andrea@gmail.com/
> > 
> >  drivers/hv/channel.c              | 14 ++---
> >  drivers/hv/ring_buffer.c          | 13 +++--
> >  drivers/net/hyperv/netvsc.c       |  8 ++-
> >  drivers/net/hyperv/rndis_filter.c |  2 +
> >  drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
> >  include/linux/hyperv.h            | 13 ++++-
> >  6 files changed, 95 insertions(+), 49 deletions(-)
> 
> LGTM
> 
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>

Although this patch is tagged with SCSI, I think it would be better if
this goes through the hyperv tree. Let me know if there is any
objection.

Wei.
