Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7756243E39F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJ1O2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhJ1O2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:28:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC29161106;
        Thu, 28 Oct 2021 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635431169;
        bh=IjX5DgVJlY2eHbjw/92CSwAjtLsC3JayE6Mo7emJTp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rj8Iv0LMQ2FdtTWMSqf10Fhw6opkwkeCedMxuFneCasfDlINGISB5lbRjZrwvxv7s
         NfXJyq96BqnMZI2F0O6ob+HMmRIPJ8rbTiVzlB7JKY+qh8pt5E9aKYe0zT5G6EoW8E
         QV2pgSQnd62V2AYZF6ELB1oYbARzwIwbs0OaXLZ6wGSqmtXfGXfPcR5xBg/1KgtBKO
         wF3y/OwmQkBxvvFUPkPDXXQApKcDN7fBMkX2EJ/wR2tvFX7n8ac4mAj3YJwjgzuT8G
         7cYDaC33zJEhip20z9RZcR3lingCW5Ga2B66xcvni/477JEToPMOXzp757GWsJpxlN
         HYpZn+I57DE0w==
Date:   Thu, 28 Oct 2021 07:26:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?SsO2cm4=?= Engel <joern@purestorage.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Caleb Sander <csander@purestorage.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 1/4] i40e: avoid spin loop in
 i40e_asq_send_command()
Message-ID: <20211028072607.4db76c84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXqOL0PqhujmH+sd@cork>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
        <20211025175508.1461435-2-anthony.l.nguyen@intel.com>
        <20211027090103.33e06b78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXqOL0PqhujmH+sd@cork>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 04:49:03 -0700 J=C3=B6rn Engel wrote:
> On Wed, Oct 27, 2021 at 09:01:03AM -0700, Jakub Kicinski wrote:
> > On Mon, 25 Oct 2021 10:55:05 -0700 Tony Nguyen wrote: =20
> > > +			cond_resched();
> > >  			udelay(50); =20
> >=20
> > Why not switch to usleep_range() if we can sleep here? =20
>=20
> Looking at usleep_range() vs. udelay(), I wonder if there is still a
> hidden reason to prefer udelay().  Basically, if you typically want
> short delays like the 50=C2=B5s above, going to sleep will often result in
> much longer delays, 1ms or higher.

Right, if you call sleep you always yield so another process can kick
in and consume its scheduler slice before it lets you back in.

How much does the FW typically take to respond? If we really care about
latency 50us already sounds like a pretty coarse granularity.

Also if cond_resched() fired doing the delay is probably a waste of
time:

	if (!cond_resched())
		usleep/udelay

> I can easily see situations where multiple calls to udelay(50) are
> fine while multiple calls to usleep_range() will cause timeouts.

The status of the command is re-checked after the loop, sleeping too
long should not cause timeouts here.

> Is that a known problem and do we have good heuristics when to prefer
> one over the other?

I'm not aware of any.
