Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB8737960B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhEJRfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 13:35:02 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39787 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhEJReb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 13:34:31 -0400
Received: by mail-wr1-f42.google.com with SMTP id v12so17452340wrq.6;
        Mon, 10 May 2021 10:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w1KqPRqS0Ebww9jDIiDAbo5gG5VohCVezhH4mMVAKQM=;
        b=bsVBKyPk3dIZ8/oc9N2XyXy4aAXbjHwXUc7sDUpJkgrX0EQMgXJWH9iHFr58Q5KsM7
         BbVF7c6Yg3YPwwSG9F99Y+DCS/D0lnGBSWfhKCZseVY82Bx6TYnrpbPvF6Mi9IE/ISPT
         XEkV8bAhYsWVwQ+F+7Kniw1QuYVtsQZdFnI8AX1r7jTDEkr8ojxiYoZdNpVJCd8Q7Jys
         cH7AfE260T8ASgwFwnV2acWWsF8WCobvLuM8R8LznA1yQZI8TNcPrlAfONiAHDVkc39+
         jduYtFjgKmCzxZN3bUB4psna/OKXrSYB+gjJ6sMoZqrWufBvV1rXCRDIt2ZEXvN3HXJ2
         O/GQ==
X-Gm-Message-State: AOAM5337mAb3ZV+pjVjCLRSqxYhde9rW4lIaMRmrQXN78A2WGjv79uRL
        OVwodDuZ6AWBHSTJUgamcgk=
X-Google-Smtp-Source: ABdhPJxjOTS/YFYHT/exsvupIAadWnjQ2TNhkEFfxycgGbRynQgC8XG2phy8k5xymUbtB68ut3Xt/g==
X-Received: by 2002:adf:fd0d:: with SMTP id e13mr32338189wrr.56.1620668003107;
        Mon, 10 May 2021 10:33:23 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e38sm178888wmp.21.2021.05.10.10.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 10:33:22 -0700 (PDT)
Date:   Mon, 10 May 2021 17:33:21 +0000
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
Message-ID: <20210510173321.lfw4nha7wrzfgkkd@liuwe-devbox-debian-v2>
References: <20210415105926.3688-1-parri.andrea@gmail.com>
 <MWHPR21MB15936B2FBD1C1FE91C654F3DD74D9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210506174516.aiuuhu7oediqozv4@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506174516.aiuuhu7oediqozv4@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 05:45:16PM +0000, Wei Liu wrote:
> On Thu, Apr 15, 2021 at 01:22:32PM +0000, Michael Kelley wrote:
> > From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, April 15, 2021 3:59 AM
> > > 
> > > Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> > > all issues with allocating enough entries in the VMbus requestor.
> > > 
> > > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > > ---
> > > Changes since RFC:
> > >   - pass sentinel values for {init,reset}_request in vmbus_sendpacket()
> > >   - remove/inline the storvsc_request_addr() callback
> > >   - make storvsc_next_request_id() 'static'
> > >   - add code to handle the case of an unsolicited message from Hyper-V
> > >   - other minor/style changes
> > > 
> > > [1] https://lore.kernel.org/linux-hyperv/20210408161315.341888-1-parri.andrea@gmail.com/
> > > 
> > >  drivers/hv/channel.c              | 14 ++---
> > >  drivers/hv/ring_buffer.c          | 13 +++--
> > >  drivers/net/hyperv/netvsc.c       |  8 ++-
> > >  drivers/net/hyperv/rndis_filter.c |  2 +
> > >  drivers/scsi/storvsc_drv.c        | 94 +++++++++++++++++++++----------
> > >  include/linux/hyperv.h            | 13 ++++-
> > >  6 files changed, 95 insertions(+), 49 deletions(-)
> > 
> > LGTM
> > 
> > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> 
> Although this patch is tagged with SCSI, I think it would be better if
> this goes through the hyperv tree. Let me know if there is any
> objection.

Andrea, please rebase this patch on top of hyperv-next. It does not
apply as-is.

Wei.
