Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44941492D51
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbiARSaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiARSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F89C06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4553761509
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66955C340E0;
        Tue, 18 Jan 2022 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642530618;
        bh=u1H7LX21xd6ldlov3ksOz8DYdnyNVCtMA6eA0Ra1pZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FXa+gwPTncUfK00wV1X/KOAIzZM9xaiyeblSXIFZpblZBbNz1AhpyLE7rUY3I0afF
         RfofMWQAAorbl6iopR5M+7StYnQephbY8MlqmRGEWuimuhj6FecfX5axYqsGFiOpmD
         Ub43eM++YHD1fRU7VXsL1aAhNlYZtaK3+iDf97zQglED3nfUypMqCF+tVLwZC+a3vA
         yTHI4AclMGzIlalD5ZcZO0fgRGl0X1MxEeNTgACoXysyKZ2q/b/veE7pSXKfV0y4V9
         eHHL8hqHYtYkFsnEcoFmMjo99C9Vo5t2e2hqn8MpQ85n46JtjOK8jQLsbA7UZR6/US
         uMhaJiVaKpZAQ==
Date:   Tue, 18 Jan 2022 10:30:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Port mirroring, v2 (RFC)
Message-ID: <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
        <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
        <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
        <YeLk3STfx2DO4+FO@lunn.ch>
        <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 11:37:05 -0600 Alex Elder wrote:
> I'm basically ready to go on this, either way (using a
> misc device, or--preferably--using a netdev).
> 
> I'm just trying to avoid getting that fully working,
> then learning when I submit patches that someone thinks
> it's the wrong way to go about it.
> 
> If a netdev is acceptable, my remaining issues are:
> - Whether/how to avoid having the device be treated
>    as if it needed support from the network stack
>    (i.e., as a "real" network interface, serving to
>    send and receive packets).
> - Similar, whether there are special configuration
>    options that should be used, given the device's
>    purpose.
> - What to call this functionality.  I'll avoid "mirror"
>    and will try to come up with something reasonable,
>    but suggestions are welcome.

I can't claim that my opinions on this sort of stuff are very stable
but I like Andrew's suggestion and I'd even say maybe just debugfs...

We try hard to prevent any abuse of netdevs for carrying what is not
real networking traffic and keep the semantics clear. netdevs are not
meant as an abstraction, they are more of an exception to the
"everything is a file" Unix rule.

Another thing that could possibly work is devlink traps and
DEVLINK_TRAP_ACTION_MIRROR, but again, not sure if we want to bend that
interface which has pretty nice and clear semantics to support a vendor
use case which is an aberration from our forwarding model in the
first place...

So I'd do something simple in debugfs and if anyone really cares about
the forwarding details put the real effort into modeling/controlling 
the forwarding with Linux. 
