Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF9B48DE03
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 20:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiAMTIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 14:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiAMTIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 14:08:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2900C061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 11:08:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4199B82332
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 19:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A80FC36AE9;
        Thu, 13 Jan 2022 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642100882;
        bh=G2vhAZEiF2bm6cRQZfYIHIOpGWBQqQ6yh7Z42SVZ7xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HVs5jjAycSgeHYu5RIMVUCi9y669bVo2DSbj2e8qUD3Y8/E0ONhQCMMxDaqxMfbRC
         ZlpoAuSxCqo+NgLbn8TN3DvYqRq76MdLLclSY/j3P1KqJ+Q959LBRHv4nDHXnCU89z
         mYNZLEdt45gUrz9pfd6/46X5VotlhcA6d11Dkz7MYsPAGU5Qw/9vwbM72yB+mDJPkm
         MLRuc4aA5ybTrgANFY943YJ6NAuKl8GwjIt7OZXLQcH+fd0IkSBwp1eWkizQOvfm0X
         kezmXbe+GT+ZRANn+xr+wKdSoStvf3cviKatFZxixpnjUxwLQS4zjWkZkC8Z5h7upy
         DoHbFx97SXe6g==
Date:   Thu, 13 Jan 2022 11:08:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Vimalkumar <j.vimal@gmail.com>, maximmi@nvidia.com
Subject: Re: [PATCH net-next v2] net_sched: restore "mpu xxx" handling
Message-ID: <20220113110801.7c1a6347@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <00960549-3a4a-abe3-0a28-ab866a7dbe97@bracey.fi>
References: <20220112170210.1014351-1-kevin@bracey.fi>
        <CANn89iJiAGD11qe9edmzsf0Sf9Wb7nc6o6zscO=4KOwkRv1gRQ@mail.gmail.com>
        <00960549-3a4a-abe3-0a28-ab866a7dbe97@bracey.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 19:31:54 +0200 Kevin Bracey wrote:
> On 12/01/2022 19:08, Eric Dumazet wrote:
> > On Wed, Jan 12, 2022 at 9:02 AM Kevin Bracey <kevin@bracey.fi> wrote:  
> >> commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
> >> "overhead X", "linklayer atm" and "mpu X" attributes.  

Applied, thanks!

> > Thanks for the nice changelog.
> >
> > I do have a question related to HTB offload.
> >
> > Is this mpu attribute considered there ?  
> 
> I had not considered that. None of these 3 adjustment parameters are 
> passed to its setup - tc_htb_qopt_offload merely contains u64 rate and ceil.
> 
> Dealing with that looks like it might be a bit fiddly. htb_change_class 
> would need reordering. It appears the software case permits parameter 
> changing and it is ordered on that basis, but the offload locks in 
> parameters on creation.
> 
> But in principle, tc_htb_qopt_offload could contain a pair of 
> psched_ratecfg rather than a pair of u64s, and then offload would have 
> all the adjustment information.

CC Maxim, offload should at least be rejected if user request
unsupported params.
