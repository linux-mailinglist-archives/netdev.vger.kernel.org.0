Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D410375CB5
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhEFVSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhEFVSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 17:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDCE160698;
        Thu,  6 May 2021 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620335861;
        bh=gPEczB6jho/xcnrI6uaq2QZxIhvapAlQ6Rp6VGU4lHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sNde8qMPsrKhZXaIOwSAbSSYE2KDIqHOrPAoYBbD96nkKDPRrPD1LiqG0E6E8Qak8
         xbgf7D3n/ezdZtE54qqvWm2QiLzgShx7n9impYKjeFnxtl0i41ZHH6Hltj6dMB1L0/
         FJJcS6Y/LfjizbEjBaKrI0qiOm2xJ7BPReOSML0p3MciMih+FJrVBx+2l4Ml8fxL0b
         S0JZ6PDHum0b9pfCsW8o8f5qe9iRVEIaFbD0gLsUdo4CfhpBClQnP714SH43cjsw6a
         Kjsfi1/CldMQjMouK7+cv/v1//wgYOjrOQlvn8RZMmlpug0vKfsywKIjZb/lOOWDKH
         75mPapwMbA4Lg==
Date:   Thu, 6 May 2021 14:17:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
Message-ID: <20210506141739.0ab66f99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
        <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
        <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
        <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
        <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
        <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
        <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
        <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 May 2021 17:55:36 +0200 Paolo Abeni wrote:
> On Thu, 2021-05-06 at 10:32 -0400, Willem de Bruijn wrote:
> > On Thu, May 6, 2021 at 7:07 AM Paolo Abeni <pabeni@redhat.com> wrote:  
> > > If we want to be safe about future possible sock_wfree users, I think
> > > the approach here should be different: in skb_segment(), tail-  
> > > > destructor is expected to be NULL, while skb_segment_list(), all the  
> > > list skbs can be owned by the same socket. Possibly we could open-
> > > code skb_release_head_state(), omitting the skb orphaning part
> > > for sock_wfree() destructor.
> > > 
> > > Note that the this is not currently needed - sock_wfree destructor
> > > can't reach there.
> > > 
> > > Given all the above, I'm unsure if you are fine with (or at least do
> > > not oppose to) the code proposed in this patch?  
> > 
> > Yes. Thanks for clarifying, Paolo.  
> 
> Thank you for reviewing!
> 
> @David, @Jakub: I see this series is already archived as "change
> requested", should I repost?

Yes, please. Patch 2 adds two new sparse warnings. 

I think you need csum_unfold() to go from __sum16 to __wsum.
