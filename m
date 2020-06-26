Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3439020B2B2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgFZNmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:42:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35921 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZNmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 09:42:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id k6so9574802wrn.3;
        Fri, 26 Jun 2020 06:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WPQDOd5p2KRBs00b1Ze0uo40/AP826N8zKgr9FyI50s=;
        b=jfBhGs+imk+4tN4veCyowN8biUmvN9sPXenb+TAKj6hEOTLB2DLlSvqb8oLXWoPhoG
         xm1V+2rhlmM5pZ8DAEIBd2iYccQOcFyHSIttv3rdybF1Fb7P3pRzKzu3ag7/XIJw+wF7
         6+UKWyMGSAsDotXbfkH80hWeaAjuqx6F68/9QCoqrP8xfmKdugw3TmwAPGxf8HahgzJb
         ym250W38rMCIVCp4BUqYUqKT3Ehe7NH6j5DY0VE0EsC24Ll44yHo7GAdvlQEyToS0id0
         RjKLQD810GeVWz0nLknKOYAj9vqy6zcXmU8w8NxBZc/ZrV5sZ9tYahTEBUf+FoS9zmp7
         K39g==
X-Gm-Message-State: AOAM531+REODMcAL1DbD+YIF/djar817iExt7qmFtYVhU1rUZFvqDbK4
        q8WgVntNYfaGtn9Pa9rlSt8=
X-Google-Smtp-Source: ABdhPJwlh3Oehnp2mDP9/xLAv48E5VyaqWVKYOUqmHHQzdu4xdua4j/ycX1XUnOEA8R9IEfPyNt32g==
X-Received: by 2002:a5d:5483:: with SMTP id h3mr3996023wrv.10.1593178949427;
        Fri, 26 Jun 2020 06:42:29 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u10sm17197124wml.29.2020.06.26.06.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 06:42:29 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:42:27 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Andres Beltran <lkmlabelt@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        parri.andrea@gmail.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
Message-ID: <20200626134227.ka4aghqjpktdupnu@liuwe-devbox-debian-v2>
References: <20200625153723.8428-1-lkmlabelt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625153723.8428-1-lkmlabelt@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 11:37:20AM -0400, Andres Beltran wrote:
> From: Andres Beltran (Microsoft) <lkmlabelt@gmail.com>
> 
> Currently, VMbus drivers use pointers into guest memory as request IDs
> for interactions with Hyper-V. To be more robust in the face of errors
> or malicious behavior from a compromised Hyper-V, avoid exposing
> guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> bad request ID that is then treated as the address of a guest data
> structure with no validation. Instead, encapsulate these memory
> addresses and provide small integers as request IDs.
> 
> The first patch creates the definitions for the data structure, provides
> helper methods to generate new IDs and retrieve data, and
> allocates/frees the memory needed for vmbus_requestor.
> 
> The second and third patches make use of vmbus_requestor to send request
> IDs to Hyper-V in storvsc and netvsc respectively.
> 

Per my understanding, this new data structure is per-channel, so it
won't introduce contention on the lock in multi-queue scenario. Have you
done any testing to confirm there is no severe performance regression?

Wei.

> Thanks.
> Andres Beltran
> 
> Cc: linux-scsi@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> Andres Beltran (3):
>   Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus
>     hardening
>   scsi: storvsc: Use vmbus_requestor to generate transaction ids for
>     VMBus hardening
>   hv_netvsc: Use vmbus_requestor to generate transaction ids for VMBus
>     hardening
> 
>  drivers/hv/channel.c              | 150 ++++++++++++++++++++++++++++++
>  drivers/net/hyperv/hyperv_net.h   |  10 ++
>  drivers/net/hyperv/netvsc.c       |  56 +++++++++--
>  drivers/net/hyperv/rndis_filter.c |   1 +
>  drivers/scsi/storvsc_drv.c        |  62 ++++++++++--
>  include/linux/hyperv.h            |  22 +++++
>  6 files changed, 283 insertions(+), 18 deletions(-)
> 
> -- 
> 2.25.1
> 
