Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74F852FEAA
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 19:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbiEURxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 13:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiEURxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 13:53:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4D430563;
        Sat, 21 May 2022 10:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D9460DBB;
        Sat, 21 May 2022 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8679FC385A5;
        Sat, 21 May 2022 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653155628;
        bh=WwJ0Klea9YYR9cQCsY3YH4X/9vxjCNFz617ym6nPn7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a2l1DZCpMf1fDVGl985fu8cUJQQDoXxmHCUp0DrHih2z5/orxMc861fqX1FknFuO0
         mmfb6trXNOmbpWTHD9Hia9J/WqE0miORv5ec7lMEi+8oWgCcM4BAbc97uSYGoupPgB
         wn9Hg8eyi8/HqnJ58u4hhQb5W7rQQ8rRtb1DEeAiuwI1VvF868RJHNQUXjjVf1w3ye
         unwD0Cn2LwomzDRwQYbIf0ofnIRkzZPyc6zK3U2saBSJCnpQNx+NngCDWQ2pGF8/XE
         N82WpQwj42VOOXAsdmNfD8dY5MDnoG/VUD2WlzmkoAdbU8qguSAW6ZQ9k8ppKvrCxV
         aOrPNMAIx/aEg==
Date:   Sat, 21 May 2022 10:53:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, toke@toke.dk,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next 2/8] wifi: ath9k: silence array-bounds warning
 on GCC 12
Message-ID: <20220521105347.39cac555@kernel.org>
In-Reply-To: <87h75j1iej.fsf@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-3-kuba@kernel.org>
        <87h75j1iej.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 May 2022 09:58:28 +0300 Kalle Valo wrote:
> > +# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
> > +ifndef KBUILD_EXTRA_WARN
> > +CFLAGS_mac.o += -Wno-array-bounds
> > +endif  
> 
> There are now four wireless drivers which need this hack. Wouldn't it be
> easier to add -Wno-array-bounds for GCC 12 globally instead of adding
> the same hack to multiple drivers?

I mean.. it's definitely a hack, I'm surprised more people aren't
complaining. Kees was against disabling it everywhere, AFAIU:

https://lore.kernel.org/all/202204201117.F44DCF9@keescook/

WiFi is a bit unfortunate but we only have 3 cases in the rest of
networking so it's not _terribly_ common.

IDK, I'd love to not see all the warnings every time someone touches
netdevice.h :( I made a note to remove the workaround once GCC 12 gets
its act together, that's the best I could come up with.
