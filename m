Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1311A2EAB23
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbhAEMqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:46:18 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:50835 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbhAEMqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:46:15 -0500
Received: by mail-wm1-f41.google.com with SMTP id 190so2917398wmz.0;
        Tue, 05 Jan 2021 04:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EXnUtStgTNHCYfCXvY8ndQ5zpFOfaWr6HedodEhJISw=;
        b=CqvncFBI1odmUVtZcEfs1lg76avUWKDWIEcBFGSQp8XEzRVPy3QHSlN+ttUshaJUdQ
         JQJC6pUmHMJ7N+NdnC8dQ1rD7MJvZ5qI1FZtcWw+0h+toPTTpey5USLlr9NfN4H36tg6
         Pxu2qadEo2gDnaegOqJ8gaXUujRVgcL4aAXrBuiTfi6d9GAIPqhpXWO+vACDnUHC6+jf
         yc7+GUiRYDvroSbhmJDSJROjxV5x0Nvw6Zf+7DgPif/EeeBO1Ky1eVz/BIANNELrmzsf
         Z0MnYK8akqvZ40nsMk7J87uN2ebQs0NoBJlDMrHSwfhmpxpXAFtjRN2mbrDJS3JuZgsr
         FPtA==
X-Gm-Message-State: AOAM533VeeY3dqGGOj6Kege3kMeLqo9NCgP++uhjj8qvTghxV3Z+dD8L
        nh6rK+IE+XePP37YMzMHA9c=
X-Google-Smtp-Source: ABdhPJwMw1DpqRyFMq85jN4wJulA2jSz4eGH1rMxoFyEq7tcNaYhNhDPFypAZZK1oenHAbtuJO15nQ==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr3420391wmg.168.1609850732287;
        Tue, 05 Jan 2021 04:45:32 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id y63sm4145232wmd.21.2021.01.05.04.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:45:31 -0800 (PST)
Date:   Tue, 5 Jan 2021 12:45:30 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Andres Beltran <lkmlabelt@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Message-ID: <20210105124530.kwaa6vdpdpopp2tq@liuwe-devbox-debian-v2>
References: <20201208045311.10244-1-parri.andrea@gmail.com>
 <MW2PR2101MB10523546B825880C298E1C64D7DF9@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10523546B825880C298E1C64D7DF9@MW2PR2101MB1052.namprd21.prod.outlook.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 01:59:34PM +0000, Michael Kelley wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Monday, December 7, 2020 8:53 PM
> > 
> > From: Andres Beltran <lkmlabelt@gmail.com>
> > 
> > Pointers to ring-buffer packets sent by Hyper-V are used within the
> > guest VM. Hyper-V can send packets with erroneous values or modify
> > packet fields after they are processed by the guest. To defend
> > against these scenarios, return a copy of the incoming VMBus packet
> > after validating its length and offset fields in hv_pkt_iter_first().
> > In this way, the packet can no longer be modified by the host.
> > 
> > Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> > Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-scsi@vger.kernel.org
> > ---
> >  drivers/hv/channel.c              |  9 ++--
> >  drivers/hv/hv_fcopy.c             |  1 +
> >  drivers/hv/hv_kvp.c               |  1 +
> >  drivers/hv/hyperv_vmbus.h         |  2 +-
> >  drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
> >  drivers/net/hyperv/hyperv_net.h   |  3 ++
> >  drivers/net/hyperv/netvsc.c       |  2 +
> >  drivers/net/hyperv/rndis_filter.c |  2 +
> >  drivers/scsi/storvsc_drv.c        | 10 ++++
> >  include/linux/hyperv.h            | 48 +++++++++++++++---
> >  net/vmw_vsock/hyperv_transport.c  |  4 +-
> >  11 files changed, 139 insertions(+), 25 deletions(-)
> > 
> 
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>

Applied to hyperv-next.
