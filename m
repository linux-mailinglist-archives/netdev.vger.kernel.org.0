Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B11E832F4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfHFNke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:40:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33389 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbfHFNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:40:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so62908591qkc.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 06:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dNzsOgLAi4DpECpGRrewtthquhRyGxeGVQXq8haedDU=;
        b=nc3ULfAxivmoeOVWtx4pEkcKqWu7gMWhZ1T9c67WVWKwR/tqg4tjz06IHSiy7/T1mM
         1Q9OgN3SKGqoN0fTofviJhtk+Y8Fnu6Rb9wlYk2j8XzfT49iKaQgZskM/1nQuoKXVyrg
         x7tKm90nh5lvD0if38GgDipFfBZn9HvMJg3lzYCC5JZp61ytJWsdqe/KqqgbJCT1alsH
         YRrG5mFigDCgWFVNUPK0RWvRiPVQp4r15i+HE+vsy+0UofzeByMFI318I8OMNMaejIys
         JaRCTgreBgdiEAQrQGSv5kop0m94iD49e5Xbjmt0OHKcuev72yVdTxaI38Rng+Q3PBaC
         NvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dNzsOgLAi4DpECpGRrewtthquhRyGxeGVQXq8haedDU=;
        b=VO07nEvtbKbZ3k8rnb8mi3dM0EVyw6V7EeD/IjHf5AU3UWectYImVbRQKIfG0WO8kc
         giHg4XJ675CCPcnluxd8deA+9Bpi3QvKBBpCTGbTTir1EWs/gpo2RUSTRFxvTovsD+9Y
         jEeMjRq9UUoYhSXNEc0aQSgD5AAXNbWhxtw7U+Hh3P+kIiYd4TVHefSsycFFKFIrkoan
         8FITiEJMZNvT6DsZMViVdHItDxiFD5+jot9NwJGKYhCLDK5c296EqoUyhL3fRqTXTass
         +ILH10sUGOz7Hc//Eany1WR8YiCOT+zoFgk0+Yi3IDDZwgSjz1v2wWiJY92p0QrXl3k2
         oVeQ==
X-Gm-Message-State: APjAAAUfbhApC66Ij8gNNfBE1Tb9STb4f5TSbUX+wSVSJPKM1t8vwsAm
        YmK/t53fKBMHqmkVDsaT1f+KIQ==
X-Google-Smtp-Source: APXvYqxMfwBB47axCWNEJctHilcnayHipqGXZY261+EFRwNZ/6dzvsnkK6i+idF6ma2zmUwEOo/rBA==
X-Received: by 2002:a05:620a:31b:: with SMTP id s27mr3219001qkm.264.1565098832774;
        Tue, 06 Aug 2019 06:40:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id u18sm36087109qkj.98.2019.08.06.06.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Aug 2019 06:40:32 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1huzhW-0004zI-Ru; Tue, 06 Aug 2019 10:40:30 -0300
Date:   Tue, 6 Aug 2019 10:40:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190806134030.GD11627@ziepe.ca>
References: <20190801141512.GB23899@ziepe.ca>
 <42ead87b-1749-4c73-cbe4-29dbeb945041@redhat.com>
 <20190802124613.GA11245@ziepe.ca>
 <20190802100414-mutt-send-email-mst@kernel.org>
 <20190802172418.GB11245@ziepe.ca>
 <20190803172944-mutt-send-email-mst@kernel.org>
 <20190804001400.GA25543@ziepe.ca>
 <20190804040034-mutt-send-email-mst@kernel.org>
 <20190806115317.GA11627@ziepe.ca>
 <20190806093633-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806093633-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 09:36:58AM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 06, 2019 at 08:53:17AM -0300, Jason Gunthorpe wrote:
> > On Sun, Aug 04, 2019 at 04:07:17AM -0400, Michael S. Tsirkin wrote:
> > > > > > Also, why can't this just permanently GUP the pages? In fact, where
> > > > > > does it put_page them anyhow? Worrying that 7f466 adds a get_user page
> > > > > > but does not add a put_page??
> > > > 
> > > > You didn't answer this.. Why not just use GUP?
> > > > 
> > > > Jason
> > > 
> > > Sorry I misunderstood the question. Permanent GUP breaks lots of
> > > functionality we need such as THP and numa balancing.
> > 
> > Really? It doesn't look like that many pages are involved..
> > 
> > Jason
> 
> Yea. But they just might happen to be heavily accessed ones....

Maybe you can solve the numa balance problem some other way and use
normal GUP..

Jason 
