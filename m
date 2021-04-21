Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBEF366F4B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244045AbhDUPhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236008AbhDUPhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7377761445;
        Wed, 21 Apr 2021 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619019396;
        bh=DchP6si55bOITC9gDQnuj+MkCmvYjr7U1+H5aK0Wk3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=huMPOFMyNQf445amT9WaIJmBTpF5q8Mo3M3HYZaM9X7vS40LkWA/fm01S5OINOTR+
         bM0KI2vNalM7qGw9v8m6YGtmgJvGWtYLgzeFZ90rp3zGfcJ1wmUkAJsj6OWLCnscPK
         3y4n+BRPRQxBC4YR3KLTXa/3o0asRUPl2ImWn48K67Y7MpI5erNc3MkGi7V1rFUCT/
         tYxQg6+a5avpiYL0JunWX4JoFdgbFOdLUVsgvcPoPOmDIdLeKa0WV+ftPfmjAi1IGR
         xcdsmEj+n+dLDtsRyEO1ANTPXw6iA9BEe1g64/nl9Ac0x8/JCTIcoVG2OB0PE+XKFt
         n+vcMpc0bW9Ww==
Date:   Wed, 21 Apr 2021 18:36:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <YIBGgOBVkt+dRuFr@unreal>
References: <20210407000913.2207831-1-pakki001@umn.edu>
 <YH6aMsbqruMZiWFe@unreal>
 <YH6azwtJXIyebCnc@unreal>
 <CAJKOXPcyJ43m-n=ACGGgRZkWd8KDD5pNkBSY1mSOebH9BvHROA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKOXPcyJ43m-n=ACGGgRZkWd8KDD5pNkBSY1mSOebH9BvHROA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:19:03PM +0200, Krzysztof Kozlowski wrote:
> On Tue, 20 Apr 2021 at 11:13, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Apr 20, 2021 at 12:09:06PM +0300, Leon Romanovsky wrote:
> > > On Tue, Apr 06, 2021 at 07:09:12PM -0500, Aditya Pakki wrote:
> > > > In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> > > > is freed and later under spinlock, causing potential use-after-free.
> > > > Set the free pointer to NULL to avoid undefined behavior.
> > > >
> > > > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> > > > ---
> > > >  net/rds/message.c | 1 +
> > > >  net/rds/send.c    | 2 +-
> > > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > >
> > > Dave, Jakub
> > >
> > > Please revert this patch, given responses from Eric and Al together
> > > with this response from Greg here https://lore.kernel.org/lkml/YH5/i7OvsjSmqADv@kroah.com
> >
> > https://lore.kernel.org/lkml/YH5%2Fi7OvsjSmqADv@kroah.com/
> >
> > >
> > > BTW, I looked on the rds code too and agree with Eric, this patch
> > > is a total garbage.
> 
> When reverting, consider giving credits to Kees/Coverity as he pointed
> out after testing linux-next that this is bogus:
> https://lore.kernel.org/linux-next/202104081640.1A09A99900@keescook/

The revert is already done for almost all @umn.edu patches.
https://lore.kernel.org/lkml/20210421130105.1226686-1-gregkh@linuxfoundation.org/

Thanks

> 
> 
> Best regards,
> Krzysztof
