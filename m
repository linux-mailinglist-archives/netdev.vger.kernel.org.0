Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D169C23AB7
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391982AbfETOoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:44:37 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:36425 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbfETOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:44:36 -0400
Received: by mail-wm1-f49.google.com with SMTP id j187so13341987wmj.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 07:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xfOw5HMDRWqg/x7nnTSUOiOxWj7QJghVt7j6cdNlbPk=;
        b=b9n7nXmL9txmLpxZLN1XtTW18gAZR8O0POEuoMAVXJTZOZlXrDkr/7oLqocBj3qhPM
         JyzuGcbJ17FzD9OD6pRZhfqsFsKe0wVZLgRonhbBFBQbwDS2cXYMzOX+3LvxbqyOAUf3
         pXxcAGshilULVcB/L28MS0D7FIXbQ9QF7ShLRfShdB1kpDxZrq7++p/sGvG7VfpwByzE
         /XWdhTdkeGthZ9LjnrrPVhPFOZgBRwC7TLF/E3B6oLPPmhliEypM7UYSenqKc85oVADu
         UeYkGm9AoMV42j29f7ZPy9tG4ZyBR03cI+7GKRVxewiVwmnshbcK2GcLfuAyCs4YsFOM
         aa0A==
X-Gm-Message-State: APjAAAW5oPK2maZNmKsxd38HGMAmozouYwwgiOrSjLisy9z/LViGyWeK
        Fl3WW+evi9bQ56IfHVU1/f2i9Q==
X-Google-Smtp-Source: APXvYqxP1++pNcn9KiuoaqESbjVVEGjt4Iwc5ShZU5i+8BmS6fNJvp5IirTBLVXXH6OoiA32kGCG4Q==
X-Received: by 2002:a1c:e386:: with SMTP id a128mr12603046wmh.69.1558363474466;
        Mon, 20 May 2019 07:44:34 -0700 (PDT)
Received: from steredhat (host151-251-static.12-87-b.business.telecomitalia.it. [87.12.251.151])
        by smtp.gmail.com with ESMTPSA id p8sm7803585wro.0.2019.05.20.07.44.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 07:44:33 -0700 (PDT)
Date:   Mon, 20 May 2019 16:44:31 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] vsock: proposal to support multiple transports at runtime
Message-ID: <20190520144431.lougg7kk4t5kjt64@steredhat>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <PU1P153MB01697642B92D138D5FA52193BF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB01697642B92D138D5FA52193BF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dexuan,

On Thu, May 16, 2019 at 09:48:11PM +0000, Dexuan Cui wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > Sent: Tuesday, May 14, 2019 1:16 AM
> > To: netdev@vger.kernel.org; Stefan Hajnoczi <stefanha@redhat.com>; Dexuan
> > 
> > Hi guys,
> > I'm currently interested on implement a multi-transport support for VSOCK in
> > order to handle nested VMs.
> 
> Hi Stefano,
> Thanks for reviving the discussion! :-)
> 

You're welcome :)

> I don't know a lot about the details of kvm/vmware sockets, but please let me
> share my understanding about them, and let me also share some details about
> hyper-v sockets, which I think should be the simplest:
> 
> 1) For hyper-v sockets, the "host" can only be Windows. We can do nothing on the
> Windows host, and I guess we need to do nothing there.

I agree that for the Windows host we shouldn't change anything.

> 
> 2) For hyper-v sockets, I think we only care about Linux guest, and the guest can
> only talk to the host; a guest can not talk to another guest running on the same host.

Also for KVM (virtio) a guest can talk only with the host.

> 
> 3) On a hyper-v host, if the guest is running kvm/vmware (i.e. nested virtualization),
> I think in the "KVM guest" the Linux hyper-v transport driver needs to load so that
> the guest can talk to the host (I'm not sure about "vmware guest" in this case); 
> the "KVM guest" also needs to load the kvm transport drivers so that it can talk
> to its child VMs (I'm not sure abut "vmware guest" in this case).

Okay, so since in the "KVM guest" we will have both hyper-v and kvm
transports, we should implement a way to decide what transport use in
the cases that I described in the first email.

> 
> 4) On kvm/vmware, if the guest is a Windows guest, I think we can do nothing in
> the guest;

Yes, the driver in Windows guest shouldn't change.

> if the guest is Linux guest, I think the kvm/vmware transport drivers
> should load; if the Linux guest is running kvm/vmware (nested virtualization), I
> think the proper "to child VMs" versions of the kvm/vmware transport drivers
> need to load.

Exactly, and for the KVM side is the vhost-vsock driver. So, as the
point 3, we should support at least two transports running in Linux at
the same time.

Thank you very much to share these information!

Cheers,
Stefano
