Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B169320BACA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgFZU5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:57:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32989 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZU5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:57:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id f18so2653267wrs.0;
        Fri, 26 Jun 2020 13:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UEtSMorzUsNwgUS6/uoC1DFelzsLLNjhA0ODxeYGQZk=;
        b=OZchDIXGo6iu9X5b8iFXhS8rb4s9itnPmLav8LKS6K+d359xFI1TaN+uCZ8xoQ3fc5
         Xrhullnd59DchWEDJBV2UUpS+Z/r6f4Dje7+caXHhr/XraN3SqIh6/8dzbDbkabaFqL7
         v4YsyR+4baHNYxzNYo0SFnVcJfuYntG187KBFcswGXBpbD3vI41kJOFDcI2fhhsZFnjz
         +gbnNdGpOkzNAtiPK8USyvXq3lVTFSNAuzWnHWRqjxoNz4FUXsLZnF21fLgItdn40nsm
         MzAHRjgbDrUulmhTdseHZ7xKB9cl9bLS6ktN+sX55yZW7Vxm7iVdb/7Hp5sIDjAJueOH
         mNHg==
X-Gm-Message-State: AOAM531yYjrp5KxpQQ3scPn7KFIlaXqBvaOhErjOe3QSx0VG8PIu61vH
        k8ISLaMvRIDTw1SJUtmeOK2sq8ZC
X-Google-Smtp-Source: ABdhPJyfz6ZN9k8zLdtD9oplahZZwvRGhaQJGtrwjWd/bB5xcjemjyZZRToSI9LENcMOmSKLfSNPJw==
X-Received: by 2002:a5d:42c8:: with SMTP id t8mr5326836wrr.23.1593205048041;
        Fri, 26 Jun 2020 13:57:28 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b184sm12903093wmc.20.2020.06.26.13.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 13:57:27 -0700 (PDT)
Date:   Fri, 26 Jun 2020 20:57:26 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Andres Beltran <lkmlabelt@gmail.com>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
Message-ID: <20200626205726.nx54ztdtmo3fxbxm@liuwe-devbox-debian-v2>
References: <20200625153723.8428-1-lkmlabelt@gmail.com>
 <20200626134227.ka4aghqjpktdupnu@liuwe-devbox-debian-v2>
 <20200626144817.GA1023610@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626144817.GA1023610@andrea>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 04:48:17PM +0200, Andrea Parri wrote:
> On Fri, Jun 26, 2020 at 01:42:27PM +0000, Wei Liu wrote:
> > On Thu, Jun 25, 2020 at 11:37:20AM -0400, Andres Beltran wrote:
> > > From: Andres Beltran (Microsoft) <lkmlabelt@gmail.com>
> > > 
> > > Currently, VMbus drivers use pointers into guest memory as request IDs
> > > for interactions with Hyper-V. To be more robust in the face of errors
> > > or malicious behavior from a compromised Hyper-V, avoid exposing
> > > guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> > > bad request ID that is then treated as the address of a guest data
> > > structure with no validation. Instead, encapsulate these memory
> > > addresses and provide small integers as request IDs.
> > > 
> > > The first patch creates the definitions for the data structure, provides
> > > helper methods to generate new IDs and retrieve data, and
> > > allocates/frees the memory needed for vmbus_requestor.
> > > 
> > > The second and third patches make use of vmbus_requestor to send request
> > > IDs to Hyper-V in storvsc and netvsc respectively.
> > > 
> > 
> > Per my understanding, this new data structure is per-channel, so it
> > won't introduce contention on the lock in multi-queue scenario. Have you
> > done any testing to confirm there is no severe performance regression?
> 
> I did run some performance tests using our dev pipeline (storage and
> network workloads).  I did not find regressions w.r.t. baseline.

Thanks, that's good to hear.

Wei.

> 
>   Andrea
