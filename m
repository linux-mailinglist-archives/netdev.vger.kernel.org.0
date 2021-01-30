Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42830938C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhA3JkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhA3Jiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:38:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1049C64E08;
        Sat, 30 Jan 2021 06:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611987532;
        bh=PTM14fyQlmSONY48Q+6aEkz7OoTm/p0gWxZKzFhbARA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LhICLphgd4S541Si8aViiwvBakUo36Vl5acJHjNaH3ZOfGmV80SwnpJM1fymLJT1Z
         inozrYAtzgN0j6NZzrbHSid9k+1FNRxFKsuqURCBrrOLNcZf7HcCM1g8WByqjebeRT
         2T9WcK466GBLf8EpSH+zGY9m6eXnAtuTVp0kB8PkXvVprxZNEKpExIeIhcAewRJ/jX
         Cp6zbQl2FLMVp67hyqAKHMBjUN/mmkxBMPy59+UTFB9RDUJD7OeQ6JZbcXdDOFtCPC
         pQKT0kfRgQytme2hkqkdpUjZTj2tB4FV4+74lmgJdDzv4va5WWCcFaiRjbs8dmQG7K
         wKDqoChpbEhLg==
Date:   Fri, 29 Jan 2021 22:18:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 4/4] i40e: Revert "i40e: don't report link up for a
 VF who hasn't enabled queues"
Message-ID: <20210129221851.20f6df9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-+XoonTb5yYzDqLGmVyGcT0Jo6=5KoN4okKAkQL5dJ2YA@mail.gmail.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
        <20210128213851.2499012-5-anthony.l.nguyen@intel.com>
        <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
        <e27cb35b-a413-ccdd-fa42-d65e7162747f@intel.com>
        <CAF=yD-+XoonTb5yYzDqLGmVyGcT0Jo6=5KoN4okKAkQL5dJ2YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 21:00:02 -0500 Willem de Bruijn wrote:
> On Fri, Jan 29, 2021 at 7:09 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> > Yea this might re-introduce the issue described in that commit. However
> > I believe the bug in question was due to very old versions of VF
> > drivers, (including an ancient version of FreeBSD if I recall).
> >
> > Perhaps there is some better mechanism for handling this, but I think
> > reverting this is ok given that it causes problems in certain situations
> > where the link status wasn't reported properly.
> >
> > Maybe there is a solution for both cases? but I would worry less about
> > an issue with the incredibly old VFs because we know that the issue is
> > fixed in newer VF code and the real problem is that the VF driver is
> > incorrectly assuming link up means it is ready to send.
> >
> > Thus, I am comfortable with this revert: It simplifies the state for
> > both the PF and VF.
> >
> > I would be open to alternatives as long as the issue described here is
> > also fixed.
> >
> > Caveat: I was not involved in the decision to revert this and wasn't
> > aware of it until now, so I almost certainly have out of date information.  
> 
> That's reasonable. The original patch is over three years old.
> 
> If it is considered safe to revert now, I would just articulate that
> point in the commit.

Agreed. I'd call out that the original fix was a work around for
clearly buggy client drivers, and they had enough time to be fixed.
