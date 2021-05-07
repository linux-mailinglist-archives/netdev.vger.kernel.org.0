Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFEC37624C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhEGIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230302AbhEGIrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620377179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBuxIXMqSKOwG50UQo9aUSZFO0iiHPUiKfSrxaBFK3w=;
        b=Mu3ZV4CIB6tQut/MIew3pU2Cp82ojDR+3MXEx9amHT+iTmOUjBeHycA4X0MSfeXXz8aUOe
        kkXNoHtSe8Ej9ImbNy8zm31NNn7mMB78407JxVXlzq0lzxCm/2eeV9itjSobK1g34s6vVD
        RWJ3t3cmMeluYj8ybhSELa/6JFZbKqU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-CjvHD537OwOSJcu-aPNOBw-1; Fri, 07 May 2021 04:46:17 -0400
X-MC-Unique: CjvHD537OwOSJcu-aPNOBw-1
Received: by mail-wr1-f69.google.com with SMTP id j33-20020adf91240000b029010e4009d2ffso833457wrj.0
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 01:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yBuxIXMqSKOwG50UQo9aUSZFO0iiHPUiKfSrxaBFK3w=;
        b=OD6cQT/e+/hh8G5UnZPZTHi2bno2ZWDZUdJLog9bEOhoYNVKHJ4YcjbDeumruY18Yj
         wBLyefbyP0FP0AVIvmddG1WgrHatzVaKZMNRordvPUHZ5EwprT0vcXNXd/j3hMiPbDKD
         NlQfy03W5JPx3xVhi7PROZhv8twZIOP91J6D4V+DixJAmiBGY97oSnC5ze6SpDK73a0b
         VQxqFhnURur0a6Wf25ihn/Jcfml8U15+++G10uLhGxO11RqW3+MNloiN+4wLCkG6QtA0
         FHuwuMOi0MU4LNydcFVO6lgjf+5c6UnVIvsjm4rZxmYUjzhGiKDAEcJpqMF96qRT1stD
         5weA==
X-Gm-Message-State: AOAM53291hQzK8BnFKy3bAWSIlORJokEUWShdaF8kBik3yOWhqLLttpv
        CVs1KX0YwCYwh8zK8emw181S1NMSXtcHswglaJP2L5iT2dSoAUe02/6PGisNt1CF56LWf0qRuaE
        zXJVlthvjA+CPbPXj
X-Received: by 2002:a1c:1b49:: with SMTP id b70mr8774449wmb.147.1620377176718;
        Fri, 07 May 2021 01:46:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTP7DYxl6RmN8As64SjDI4mtTMYAwfIJuF3XfhWBvlY8XiPDtF6sz+nmLZmJFbkg6xY/H95w==
X-Received: by 2002:a1c:1b49:: with SMTP id b70mr8774431wmb.147.1620377176503;
        Fri, 07 May 2021 01:46:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id i3sm5331103wmq.28.2021.05.07.01.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:46:16 -0700 (PDT)
Message-ID: <6f4db46541880179766a30cf6d5e47f44190b98d.camel@redhat.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Date:   Fri, 07 May 2021 10:46:15 +0200
In-Reply-To: <20210506141739.0ab66f99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1620223174.git.pabeni@redhat.com>
         <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
         <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
         <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
         <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
         <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
         <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
         <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
         <20210506141739.0ab66f99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-06 at 14:17 -0700, Jakub Kicinski wrote:
> On Thu, 06 May 2021 17:55:36 +0200 Paolo Abeni wrote:
> > On Thu, 2021-05-06 at 10:32 -0400, Willem de Bruijn wrote:
> > > On Thu, May 6, 2021 at 7:07 AM Paolo Abeni <pabeni@redhat.com> wrote:  
> > > > If we want to be safe about future possible sock_wfree users, I think
> > > > the approach here should be different: in skb_segment(), tail-  
> > > > > destructor is expected to be NULL, while skb_segment_list(), all the  
> > > > list skbs can be owned by the same socket. Possibly we could open-
> > > > code skb_release_head_state(), omitting the skb orphaning part
> > > > for sock_wfree() destructor.
> > > > 
> > > > Note that the this is not currently needed - sock_wfree destructor
> > > > can't reach there.
> > > > 
> > > > Given all the above, I'm unsure if you are fine with (or at least do
> > > > not oppose to) the code proposed in this patch?  
> > > 
> > > Yes. Thanks for clarifying, Paolo.  
> > 
> > Thank you for reviewing!
> > 
> > @David, @Jakub: I see this series is already archived as "change
> > requested", should I repost?
> 
> Yes, please. Patch 2 adds two new sparse warnings. 
> 
> I think you need csum_unfold() to go from __sum16 to __wsum.

Yes, indeed. I'll send a v2 with such change, thanks!

Paolo
> 

