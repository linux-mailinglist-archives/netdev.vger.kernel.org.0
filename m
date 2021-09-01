Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30113FE360
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhIATul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 15:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhIATul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 15:50:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04508C061575;
        Wed,  1 Sep 2021 12:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+g9z+ixAqKBu8NtXPBf3J1tXQUMoPBULRDmQiFJbsfs=;
        t=1630525784; x=1631735384; b=ELPx7IV/2ptH/CfJAPc+XdTuay0msgFtbO3z8oT8SX+m1yu
        t+Seq/eToWQGNI7B4mV5urS8fkvPJ95cvCuCgyZKNyspOEHh2U2tJO1bLPTBzelrVlIK9+WEAnaml
        NMayu4E/gegTpE+Zp7PTvqD0hM4IYzcDV+vIW+rCc9sLnAmG4ypNSzQC39lOlSJCNK0GA2lQ8k2ys
        aTHUzHXkokw5jB/6FlqKjcssde3YtIjjmuySEhwh5G2hDJ6DItniUoF9+TEYAqQcE64b6/+FSyPmU
        nhNXA2WNEYRZJ8oLl5jEpmmkG9xA8bFlTbfiP42VeWBTNijB/BDdRK2udLTHVLlw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mLWEn-001J7E-P3; Wed, 01 Sep 2021 21:49:33 +0200
Message-ID: <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
Subject: Re: [GIT PULL] Networking for v5.15
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
Date:   Wed, 01 Sep 2021 21:49:32 +0200
In-Reply-To: <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210831203727.3852294-1-kuba@kernel.org>
         <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
         <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-01 at 12:41 -0700, Jakub Kicinski wrote:
> 
> > 
> > They all seem to have that same issue, and it looks like the fix would
> > be to get the RTN lock in iwl_mvm_init_mcc(), but I didn't really look
> > into it very much.
> > 
> > This is on my desktop, and I actually don't _use_ the wireless on this
> > machine. I assume it still works despite the warnings, but they should
> > get fixed.
> > 
> > I *don't* see these warnings on my laptop where I actually use
> > wireless, but that one uses ath10k_pci, so it seems this is purely a
> > iwlwifi issue.
> > 
> > I can't be the only one that sees this. Hmm?
> 
> Mm. Looking thru the recent commits there is a suspicious rtnl_unlock()
> in commit eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage").

Huh! That's not the version of the commit I remember - it had an
rtnl_lock() in there too (just before the mutex_lock)?! Looks like that
should really be there, not sure how/where it got lost along the way.

That unbalanced rtnl_unlock() makes no sense anyway. Wonder why it
doesn't cause more assertions/problems at that point, clearly it's
unbalanced. Pretty sure it's missing the rtnl_lock() earlier in the
function for some reason.

Luca and I will look at it tomorrow, getting late here, sorry. 

johannes

