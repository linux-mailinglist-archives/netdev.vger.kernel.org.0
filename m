Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27CA3CF6A0
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhGTI2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234682AbhGTIZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 04:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9331861209;
        Tue, 20 Jul 2021 09:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626771964;
        bh=diGKLMeqjXqjUS3tPsz0KEw/bRr//coPwoJygHYsrZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TW/4RO5KkzCIyUjFqOcZISnEURPXVuwwYbgntfPDnBvIs8s/BYk46tfvhT9kK2vAq
         LkeGGPE4GpRRC8npg4cua3aI83XupA4HP75AqAaJscQmZsAfIb4o8vQX+lfBOV7n+5
         yS3P+vR6nsyyQs9CDsbEEymb/dK51hwxegFVef4Jkz6PSYM0j1jfArq+yHRHdKHllY
         n1dAezC+EAwfwjmpGiz2upc0nbP9Hut3Rx1fZTQe1UEu+bKLoLMILlR91NkyGzR5ij
         bWkKMT3pZq2JLT4cEpv9Dlm1NQQBXqKP+FzAKo2i+e2/CWTiZTSf0qTq5HM+W3tNUO
         rNZCVb12XSDgw==
Date:   Tue, 20 Jul 2021 11:05:56 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin He <Justin.He@arm.com>
Cc:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: Re: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Message-ID: <20210720110556.24cf7f8e@cakuba>
In-Reply-To: <AM6PR08MB4376CD003BF58F85E0121F39F7E29@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210715080822.14575-1-justin.he@arm.com>
        <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
        <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
        <CAJ2QiJJ8=jkbRVscnXM2m_n2RX2pNdJG4iA3tYiNGDYefb-hjA@mail.gmail.com>
        <AM6PR08MB4376CD003BF58F85E0121F39F7E29@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 02:02:26 +0000, Justin He wrote:
> > > For instance:
> > > _qed_mcp_cmd_and_union()
> > >   In while loop
> > >     spin_lock_bh()
> > >     qed_mcp_has_pending_cmd() (assume false), will break the loop  
> > 
> > I agree till here.
> >   
> > >   if (cnt >= max_retries) {
> > > ...
> > >     return -EAGAIN; <-- here returns -EAGAIN without invoking bh unlock
> > >   }
> > >  
> > 
> > Because of break, cnt has not been increased.
> >    - cnt is still less than max_retries.
> >   - if (cnt >= max_retries) will not be *true*, leading to spin_unlock_bh().
> > Hence pairing completed.  
> 
> Sorry, indeed. Let me check other possibilities.
> @David S. Miller Sorry for the inconvenience, could you please revert it
> in netdev tree?

Please submit a revert patch with the conclusions from the discussion
included in the commit message.
