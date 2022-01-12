Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098AB48C806
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355065AbiALQPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:15:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58168 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355035AbiALQPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:15:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26DA3B81FA7
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 16:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE50C36AEA;
        Wed, 12 Jan 2022 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642004121;
        bh=77o9oTDUd4zlpp4KiuWh2J0uXZ+QmjCSMZOfaorAbbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WsRl9Fp7BTCHTDscnnupPouzA0FuHarWqaNa3fWfZB/NQ7m09Gw5yDFPA4NQB6yqU
         +VTgXNvd1OvK+5Hn1syMCd75NVQkbWTgcQOCKodU7wZQU8A44wpYKgyC2oVIfB07DI
         BIEtn8+zTX26Q4kQlfhHnG3GnHR7OC38NeeRy332DoBKg77UgEzr3p/HvLi6Z2ox6n
         /hfMHIhkfRHEpHjevhALuVM+gzXv/7Mlpk6d2dXUMtVMf60uzjZb1Ad2MZoHxzJOT2
         3/rbxye7Z6oR3az5LzZu5ENJcp1FI4mWMr9nJWOfpa2cQ9yaGXbQx6gf9m6WcV/jjh
         c0ppuqE2SuY5A==
Date:   Wed, 12 Jan 2022 08:15:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
Subject: Re: [PATCH net-next] net_sched: restore "mpu xxx" handling
Message-ID: <20220112081520.23e99283@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <a59fc45e-f9c8-91fe-09a2-e47605c4c0c7@bracey.fi>
References: <20220107202249.3812322-1-kevin@bracey.fi>
        <20220111210613.55467734@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <03cc89aa-1837-dacc-29d7-fcf6a5e45284@bracey.fi>
        <a59fc45e-f9c8-91fe-09a2-e47605c4c0c7@bracey.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 09:02:59 +0200 Kevin Bracey wrote:
> On 12/01/2022 08:36, Kevin Bracey wrote:
> >
> > Indeed, There has never been any kernel handling of tc_ratespec::mpu - 
> > the kernel merely stored the value.
> >
> > The overhead had been similarly passed to the kernel but not 
> > originally acted on. Linklayer had to be added to tc_ratespec.   
> 
> Ah, I need to correct myself there. The overhead was originally acted on 
> in qdisc_l2t. htb_l2t forgot to incorporate it.
> 
> So:
> 
>   * overhead - always passed via tc_ratespec, handled by kernel. HTB
>     temporarily ignored it.
>   * linklayer - not originally passed via tc_ratespec, but incorporated
>     in table. HTB temporarily lost functionality when it stopped using
>     table. Later passed via ratespec, or inferred from table analysis
>     for old iproute2.
>   * mpu - always passed via tc_ratespec, but ignored by kernel.
>     Incorporated in table. HTB lost functionality when it stopped using
>     table.
> 
> ("always" meaning "since iproute2 first had the parameter").
> 
> So this is a tad different from the other two - those were making the 
> kernel act on something it previously acted on. This makes it act on 
> something it's always been given, but never acted on. But it restores 
> iproute2+kernel system functionality with no userspace change.

I see, thanks for the explanation! I think it's worth adding this
analysis to the commit message, please repost.
