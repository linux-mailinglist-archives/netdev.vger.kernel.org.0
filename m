Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068E046BDF5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhLGOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhLGOoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:44:07 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F150BC061746;
        Tue,  7 Dec 2021 06:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=5WChx4umjJB+KsV4D80qywndcGXTe8bk6l5sBo3k6PE=;
        t=1638888037; x=1640097637; b=M6M7X55ZhWyvA50C25g31S/zqP1SzxZET3vDJv5hwdsaX3h
        9G+PL9A7fkwmlf1XkpGTAVYiBteZ5wvkomQG86yfjPcHCJX9Oq77XyEYy8rFdG9GoTlQLcAhACkTl
        KoD7w5F55TioZH8V2AI8VDEguecgn2RPTwuxr79Fd1lzrZtJJFgknjdm4nG16khLJkZwtfF9XL+3U
        EeSo2tkewleQjo+x6k5ok1oZ9025eLxzZgiYImd1bG4T/cNPOd8ZLrjT+BoGUQUf0EAKVFawEKhme
        lp9xCUB7aWSHJKr6iBQIZh2bRiNRHVxfuNoWrMfxNAhFnBMARnh+d47FEfP4xEmw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mubdr-008EHP-0X;
        Tue, 07 Dec 2021 15:40:27 +0100
Message-ID: <5ed6ad0f5d4fed1cb0a49ecfd7f6b35dbe0f0803.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: work around reverse dependency on MEI
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 07 Dec 2021 15:40:25 +0100
In-Reply-To: <CAK8P3a35HHPs2sMsfQ_SrX4DTKmzidFUOczu8khzwJJTAy++yw@mail.gmail.com>
References: <20211207125430.2423871-1-arnd@kernel.org>
         <SA1PR11MB58258D60F7C1334471E2F434F26E9@SA1PR11MB5825.namprd11.prod.outlook.com>
         <CAK8P3a35HHPs2sMsfQ_SrX4DTKmzidFUOczu8khzwJJTAy++yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 14:25 +0100, Arnd Bergmann wrote:

> > >  config IWLMEI
> > > -     tristate "Intel Management Engine communication over WLAN"
> > > -     depends on INTEL_MEI
> > > +     bool "Intel Management Engine communication over WLAN"
> > > +     depends on INTEL_MEI=y || INTEL_MEI=IWLMVM
> > > +     depends on IWLMVM=y || IWLWIFI=m
> > >       depends on PM
> > > -     depends on IWLMVM
> > >       help
> > >         Enables the iwlmei kernel module.
> > 
> > Johannes suggested to make IWLMVM depend on IWLMEI || !IWLMEI
> > That worked as well, I just had issues with this in our internal backport based tree.
> > I need to spend a bit more time on this, but I admit my total ignorance in Kconfig's dialect.
> 
> It's still not enough, the dependency is in iwlwifi, not in iwlmvm, so it
> would remain broken for IWLWIFI=y IWLMVM=m IWLMEI=m.
> 

I missed the pcie/trans.c dependency, and the others are (I think) in
mvm...

but then we can do

config IWLWIFI
	...
	depends on IWLMEI || !IWLMEI
	...

no? That way, we exclude IWLWIFI=y && IWLMEI=m, which I believe causes
the issue? And IWLMVM already depends on IWLWIFI (via the if clause), so
that 

johannes
