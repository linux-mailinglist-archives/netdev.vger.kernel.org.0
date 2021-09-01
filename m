Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67463FE335
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 21:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbhIATmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 15:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343910AbhIATma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 15:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E7906109E;
        Wed,  1 Sep 2021 19:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630525292;
        bh=GOR5BBiV8PZB+4LKBqSj32exAyJJIY6VfspC9K7sPWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hVX3A1Y1hANirLREwN29hmiEgyrzPkkO3UsaV4jx3ItVqvl6F06H6J8JBcdQbk1OR
         q2i9OfCP8EmX2l06VjiDOQFhSteg9kcN52RVeIGu2gLxyodDIoZKerUh5+mr5ckW3M
         iILFQcHvYggQZCsFylST1C6zH2cDi36iF41q1Afs88SOODKwjVQl3TxlPmqUJwhCvL
         /t0zEhCKbIjrDHiu1QBXsAjWmvLb/uI5xzu5GN5SiiByhF4PqsDVCc3RjGbVP/nL2A
         5vX2ZkOeYquyX2yUdgdBSs+5v48mVCn3XRgaMKKGyTyJQSMfCU+0ySSXJ4oeaBuy3+
         9fv0GX2DakwKw==
Date:   Wed, 1 Sep 2021 12:41:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [GIT PULL] Networking for v5.15
Message-ID: <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
References: <20210831203727.3852294-1-kuba@kernel.org>
        <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 12:00:57 -0700 Linus Torvalds wrote:
> On Tue, Aug 31, 2021 at 1:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > No conflicts at the time of writing. There were conflicts with
> > char-misc but I believe Greg dropped the commits in question.  
> 
> Hmm. I already merged this earlier, but didn't notice a new warning on
> my desktop:

>   RTNL: assertion failed at net/wireless/core.c (61)
>   WARNING: CPU: 60 PID: 1720 at net/wireless/core.c:61
> wiphy_idx_to_wiphy+0xbf/0xd0 [cfg80211]
>   Call Trace:
>    nl80211_common_reg_change_event+0xf9/0x1e0 [cfg80211]
>    reg_process_self_managed_hint+0x23d/0x280 [cfg80211]
>    regulatory_set_wiphy_regd_sync+0x3a/0x90 [cfg80211]
>    iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
>    iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
>    iwl_opmode_register+0xd0/0x130 [iwlwifi]
>    init_module+0x23/0x1000 [iwlmvm]
> 
> They all seem to have that same issue, and it looks like the fix would
> be to get the RTN lock in iwl_mvm_init_mcc(), but I didn't really look
> into it very much.
> 
> This is on my desktop, and I actually don't _use_ the wireless on this
> machine. I assume it still works despite the warnings, but they should
> get fixed.
> 
> I *don't* see these warnings on my laptop where I actually use
> wireless, but that one uses ath10k_pci, so it seems this is purely a
> iwlwifi issue.
> 
> I can't be the only one that sees this. Hmm?

Mm. Looking thru the recent commits there is a suspicious rtnl_unlock()
in commit eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage").

CC Miri, Johannes
