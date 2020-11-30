Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF692C8C62
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgK3SOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgK3SOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 13:14:47 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A373B2074A;
        Mon, 30 Nov 2020 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606760047;
        bh=LwPwmMo2sc6YmxlJCpsgJreY1bSDtc2rPBk8tm200hQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+EUduenhPLSoxDZdFvjwL0gZNjZIvae7Nv/CZxOSX6d94Qfg/bbd4WtzOAxAylsV
         p58gUTYFQhJrzI5IOD1XIKQ4rHidG7NgSQtpaXpnYOSSPSkF37URtj1guKYz6sz1wc
         b4aTvR6Q6D4h88MwHCYKFDWQnBUoEG2TGikx8wu0=
Date:   Mon, 30 Nov 2020 10:14:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
        <20201129205817.hti2l4hm2fbp2iwy@skbuf>
        <20201129211230.4d704931@hermes.local>
        <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 11:41:10 +0100 Eric Dumazet wrote:
> > So dev_base_lock dates back to the Big Kernel Lock breakup back in Linux 2.4
> > (ie before my time). The time has come to get rid of it.
> >
> > The use is sysfs is because could be changed to RCU. There have been issues
> > in the past with sysfs causing lock inversions with the rtnl mutex, that
> > is why you will see some trylock code there.
> >
> > My guess is that dev_base_lock readers exist only because no one bothered to do
> > the RCU conversion.  
> 
> I think we did, a long time ago.
> 
> We took care of all ' fast paths' already.
> 
> Not sure what is needed, current situation does not bother me at all ;)

Perhaps Vladimir has a plan to post separately about it (in that case
sorry for jumping ahead) but the initial problem was procfs which is
(hopefully mostly irrelevant by now, and) taking the RCU lock only
therefore forcing drivers to have re-entrant, non-sleeping
.ndo_get_stats64 implementations.
