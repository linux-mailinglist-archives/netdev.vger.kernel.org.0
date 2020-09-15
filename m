Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1F326B1AB
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgIOWeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbgIOQQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:16:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C6120708;
        Tue, 15 Sep 2020 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600185047;
        bh=lCA/GyD+jMAe3LS5aaH7D+Yrp0Lg6oBxca1iCbrC+VE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WxrAaWGL1ohTKvcPBZ+8eA12pBm7Pu9MGkA3YhugPyYiesO6wlFB6XHNYtbZMhqnR
         easA64mz0PzFTaXwHWY0/5tqhUFQ8dKcSQ5jrkZsUAly5Xp3Z+dBfU5ojFffXBksJE
         aAVW8k3dZ3KCX5069NSlgUhmfZ66Rsx2w65dUOZ0=
Date:   Tue, 15 Sep 2020 08:50:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
        <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
        <7e44037cedb946d4a72055dd0898ab1d@intel.com>
        <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 18:14:22 -0700 Shannon Nelson wrote:
> So now we're beginning to dance around timeout boundaries - how can we=20
> define the beginning and end of a timeout boundary, and how do they=20
> relate to the component and label?=C2=A0 Currently, if either the compone=
nt=20
> or status_msg changes, the devlink user program does a newline to start=20
> a new status line.=C2=A0 The done and total values are used from each not=
ify=20
> message to create a % value displayed, but are not dependent on any=20
> previous done or total values, so the total doesn't need to be the same=20
> value from status message to status message, even if the component and=20
> label remain the same, devlink will just print whatever % gets=20
> calculated that time.

I think systemd removes the timeout marking when it moves on to the
next job, and so should devlink when it moves on to the next
component/status_msg.

> I'm thinking that the behavior of the timeout value should remain=20
> separate from the component and status_msg values, such that once given,=
=20
> then the userland countdown continues on that timeout.=C2=A0 Each subsequ=
ent=20
> notify, regardless of component or label changes, should continue=20
> reporting that same timeout value for as long as it applies to the=20
> action.=C2=A0 If a new timeout value is reported, the countdown starts ov=
er.=C2=A0=20

What if no timeout exists for the next action? Driver reports 0 to
"clear"?

> This continues until either the countdown finishes or the driver reports=
=20
> the flash as completed.=C2=A0 I think this allows is the flexibility for=
=20
> multiple steps that Jake alludes to above.=C2=A0 Does this make sense?

I disagree. This doesn't match reality/driver behavior and will lead to
timeouts counting to some random value, that's to say the drivers
timeout instant will not match when user space reaches timeout.

The timeout should be per notification, because drivers send a
notification per command, and commands have timeout.

The timeout is only needed if there is no progress to report, i.e.
driver is waiting for something to happen.

> What should the userland program do when the timeout expires?=C2=A0 Start=
=20
> counting backwards?=C2=A0 Stop waiting?=C2=A0 Do we care to define this a=
t the moment?

[component] bla bla X% (timeout reached)
