Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC3569ED8A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjBVDe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjBVDe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:34:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8862B3403B;
        Tue, 21 Feb 2023 19:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 442AEB811C2;
        Wed, 22 Feb 2023 03:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D2C4339B;
        Wed, 22 Feb 2023 03:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677036835;
        bh=KBzd04yF98MqM4KYPr3zWjD4jMUQbKAwM4nb1sqLd9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aBRiJkavkTRHcoLyh/OO0vvqhcTD7Y7IHmFekryAc8S5ZvI6eH3xKguifk/TgPPMh
         PWrysafPF37VOi4qWXzNdzwHiDFTW2dCfbWZnrcof6qI4Cw0tpzyfagUvgpl6BzCWg
         vquBZan92zSJxCkkkuKo7+gpL14RsLq0IwIlkUfl4AchdCerPiQlw5cK8fZoODYiy+
         OK42YfIVrCdkqLHjw3G4X4jLoH0knKGsSRT2aGTAIcHV298hU+9G6o97xot1UVNpj2
         o0UL8OrplZJJ6/fLoD5BC3/YWORRfToYqFtBz5tT7/78ILmR4s9G9k8tEOK8KxuIcP
         aVel8fWZ2yvSA==
Date:   Tue, 21 Feb 2023 19:33:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, ast@kernel.org
Subject: Re: [PULL] Networking for v6.3
Message-ID: <20230221193354.166505bb@kernel.org>
In-Reply-To: <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
References: <20230221233808.1565509-1-kuba@kernel.org>
        <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 18:46:26 -0800 Linus Torvalds wrote:
> On Tue, Feb 21, 2023 at 3:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.3  
> 
> Ok, so this is a bit nitpicky, but commit c7ef8221ca7d ("ice: use GNSS
> subsystem instead of TTY") ends up doing odd things to kernel configs.
> 
> My local configuration suddenly grew this:
> 
>     CONFIG_ICE_GNSS=y
> 
> which is pretty much nonsensical.
> 
> The reason? It's defined as
> 
>     config ICE_GNSS
>             def_bool GNSS = y || GNSS = ICE
> 
> and so it gets set even when both GNSS and ICE are both disabled,
> because 'n' = 'n'.
> 
> Does it end up *mattering*? No. It's only used in the ICE driver, but
> it really looks all kinds of odd, and it makes the resulting .config
> files illogical.
> 
> Maybe I'm the only one who looks at those things. I do it because I
> think they are sometimes easier to just edit directly, but also
> because for me it's a quick way to see if somebody has sneaked in new
> config options that are on by default when they shouldn't be.

Oh, we only check oldconfig so the hidden options don't pop up.
Let me make a note...

> I'd really prefer to not have the resulting config files polluted with
> nonsensical config options.
> 
> I suspect it would be as simple as adding a
> 
>         depends on ICE != n
> 
> to that thing, but I didn't get around to testing that. I thought it
> would be better to notify the guilty parties.
> 
> Anyway, this has obviously not held up me pulling the networking
> changes, and you should just see this as (yet another) sign of "yeah,
> Linus cares about those config files to a somewhat unhealthy degree".

Thanks! We'll take care of it shortly.
