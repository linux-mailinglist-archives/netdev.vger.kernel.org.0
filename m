Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4392CC686
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbgLBTXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgLBTXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:23:39 -0500
Date:   Wed, 2 Dec 2020 11:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606936978;
        bh=eE4wkwdnCkkKc5Q/e8KLbvCiySlz0HmT79nBF/ov03o=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=BE7f4breaEQLDOj/BX8e54YZqVid5/salXCQ7rDaI7Z7pOtFRpSoqaFsyjCGlPCGA
         UzcVvA62XzrngV6IFdKaJ4+Ik/mUjV64OTKyb//4NuEbaXk5MqBQIeICGkeh4RHP6b
         5tD9UjpqnAQZUXcsKbObo9S8qVpuDX8KQ3J2Qdr9Nms0fsx/wUSfOEdQISWbuPzuDo
         xlxgMroU5qD+uBaRLyH4IYxE7fe3ev//F97ekgpQAxdvUn7CJqIt458t16TipBbuvJ
         5Z7zxbZvGc97MzHkkAfSKzU5gbnA7YYTGPcIGfWCDkE3rijH0f5q1cBpaLpNW35vf4
         VWVbN5L0aGaAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
Message-ID: <20201202112256.59a97b9c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAKfmpSeGEpjVxw5J=tNBYc2bZEY-z7DbQeb2TcekbqkiBe7O6g@mail.gmail.com>
References: <20201123031716.6179-1-jarod@redhat.com>
        <20201202173053.13800-1-jarod@redhat.com>
        <20201202095320.7768b5b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAKfmpSeGEpjVxw5J=tNBYc2bZEY-z7DbQeb2TcekbqkiBe7O6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 14:03:53 -0500 Jarod Wilson wrote:
> On Wed, Dec 2, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed,  2 Dec 2020 12:30:53 -0500 Jarod Wilson wrote:  
> > > +     if (bond->dev->reg_state != NETREG_REGISTERED)
> > > +             goto noreg;
> > > +
> > >       if (newval->value == BOND_MODE_ACTIVEBACKUP)
> > >               bond->dev->wanted_features |= BOND_XFRM_FEATURES;
> > >       else
> > >               bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
> > > -     netdev_change_features(bond->dev);
> > > +     netdev_update_features(bond->dev);
> > > +noreg:  
> >
> > Why the goto?  
> 
> Seemed cleaner to prevent an extra level of indentation of the code
> following the goto and before the label, but I'm not that attached to
> it if it's not wanted for coding style reasons.

Yes, please don't use gotos where a normal if statement is sufficient.
If you must avoid the indentation move the code to a helper.

Also - this patch did not apply to net, please make sure you're
developing on the correct base.
