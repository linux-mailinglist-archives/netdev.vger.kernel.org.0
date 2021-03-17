Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A00933F856
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhCQSrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhCQSrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:47:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF6964F04;
        Wed, 17 Mar 2021 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616006822;
        bh=kTKKadJol3g+5hcymRsUO5tuOsB1qq0XcTxzdfmjjnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KWMBQkKHrc/rTYQZIT4lSGcEgUE/TihaneLbTvLOi1lzOGNkchUDaQK7GwaYCCUYd
         j1WAm1m3YW+sW2VS3fGv8kNw7p4NSp8YEptlICMnnAsBNW1C82Oon2Ee7G4AdpF5i7
         5eSV5VrAr1opg/EkSYFefQlI5NMfARS4FFisIG9bDM3Iu8cZkhqQBfBQyhY6XkNQDI
         G8PX5RWU8YZVWAKtdLpV69I1uzROra/a+BpRk5gQdcFY2H0A5qSpedtkhPzCt/bjhJ
         Erw+f9qtU5TacLvX5uPt08Qmc1mpLgAeVxDVe4Lbl/+Fo3rRDSM7RKZqwYETxdaafS
         t9qzkD2dy5zJw==
Date:   Wed, 17 Mar 2021 11:47:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>,
        jerinj@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH 4/9] octeontx2-af: Remove TOS field from MKEX TX
Message-ID: <20210317114701.4c0a1263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZuq272aJR8Jh5rS7y-b28t6eHhthPB_6aUoZExv0dCsorQ@mail.gmail.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
        <1615886833-71688-5-git-send-email-hkelam@marvell.com>
        <20210316100616.333704ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZuq272aJR8Jh5rS7y-b28t6eHhthPB_6aUoZExv0dCsorQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 12:07:12 +0530 sundeep subbaraya wrote:
> On Tue, Mar 16, 2021 at 10:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 16 Mar 2021 14:57:08 +0530 Hariprasad Kelam wrote:  
> > > From: Subbaraya Sundeep <sbhatta@marvell.com>
> > >
> > > TOS overlaps with DMAC field in mcam search key and hence installing
> > > rules for TX side are failing. Hence remove TOS field from TX profile.  
> >
> > Could you clarify what "installing rules is failing" means?
> > Return error or does not behave correctly?  
> 
> Returns error. The MKEX profile can be in a way where higher layer packet fields
> can overwrite lower layer packet fields in output MCAM Key. The commit
> 42006910 ("octeontx2-af: cleanup KPU config data") introduced TX TOS field and
> it overwrites DMAC. AF driver return error when TX rule is installed
> with DMAC as
> match criteria since DMAC gets overwritten and cannot be supported. Layers from
> lower to higher in our case:
> LA - Ethernet
> LB - VLAN
> LC - IP
> LD - TCP/UDP
> and so on.
> 
> We make sure there are no overlaps between layers but TOS got added by mistake.
> We will elaborate the commit description and send the next version.

Thank you! The longer explanation makes the error clear.
