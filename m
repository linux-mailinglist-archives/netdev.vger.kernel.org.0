Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C01F44BC6B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 08:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhKJHy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 02:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhKJHy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 02:54:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A591560F9B;
        Wed, 10 Nov 2021 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636530731;
        bh=fkm25A4U/u9I2kk7C+DQZScS5Hnz6TKJ029JuTf7mwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JM3sqKhoD/lj+ZixFQJ921ee0h4iqyPNE0CORhB9s4aGw8TMnFJcsJZhXjZxVhhMy
         6f/XgIj0iTxPT/1+yN7q8Ie8KWCR6m6KXXyGlf/WfaQL3vlu8i+OKu8F+dizcj75iD
         TES4/pCFa4QYYyEDwMNQ2tN/zgk5Fi3TRwbOlDuD8P7jws1R+nfEL+G6YxbSOMpyZV
         kkNSmd5ODx7KC2LrYQ0fVePqtAEf9+KYNke/8XqUm7I1BKRjjW2x0/eCHIXnyudDSb
         K/Y4ZWrQLJwekyW6eRzFocIWL25/oM4Ahzw71knWo9Xf38SkCYvKrN5lETIbWz7qni
         PYsbnYRSt/+NQ==
Date:   Wed, 10 Nov 2021 09:52:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYt6Jyyz+K9Pj3oL@unreal>
References: <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> > > > I once sketched out fixing this by removing the need to hold the
> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
> > > > over the devlink reload paths. It seemed like a reasonable step toward
> > > > finer grained locking.  
> > > 
> > > Seems to me the locking is just a symptom.  
> > 
> > My fear is this reload during net ns destruction is devlink uAPI now
> > and, yes it may be only a symptom, but the root cause may be unfixable
> > uAPI constraints.
> 
> If I'm reading this right it locks up 100% of the time, what is a uAPI
> for? DoS? ;)
> 
> Hence my questions about the actual use cases.

It is important to add that this problem existed even before auxiliary
bus conversion.

Thanks
