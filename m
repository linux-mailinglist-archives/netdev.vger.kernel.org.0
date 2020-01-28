Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0E14B123
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 09:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgA1Ixv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 03:53:51 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:39983 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgA1Ixu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 03:53:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id C3A4ACC00F3;
        Tue, 28 Jan 2020 09:53:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1580201626; x=1582016027; bh=aEm/fnpwIz
        WLBFMzwB9RT2bfWnCXazD/1uWSPnX+jGU=; b=m/K75uwD9E6PxpckwbYoABDtqk
        llryMXTa73E+TcBIeB5ABpidFTO6asepGDrlldSOfDx4JgEnIYlZm5aIoMaeSjDj
        13lG1epV8GOvRQ3cWHiFYO2PjH3mx5ItQqjRtk5XsSVsqiEQTj3cq1gjgUHxtlP+
        WNmga9TFXsshmBeDQ=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 28 Jan 2020 09:53:46 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 68DDACC00F2;
        Tue, 28 Jan 2020 09:53:45 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 4211F21A72; Tue, 28 Jan 2020 09:53:45 +0100 (CET)
Date:   Tue, 28 Jan 2020 09:53:45 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Hillf Danton <hdanton@sina.com>
cc:     syzbot <syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com>,
        x86@kernel.org, tony.luck@intel.com, peterz@infradead.org,
        netdev@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        coreteam@netfilter.org, bp@alien8.de,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, davem@davemloft.net
Subject: Re: [netfilter-core] INFO: rcu detected stall in hash_ip4_gc
In-Reply-To: <20200128022601.15116-1-hdanton@sina.com>
Message-ID: <alpine.DEB.2.20.2001280948480.5190@blackhole.kfki.hu>
References: <20200127042315.10456-1-hdanton@sina.com> <20200128022601.15116-1-hdanton@sina.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020, Hillf Danton wrote:

> 
> On Mon, 27 Jan 2020 23:14:03 +0100 (CET) Kadlecsik Jozsef wrote:
> > 
> > Thanks for the patch, but it does not fix completely the issue: the same 
> > error message can pop up in ip_set_uadd(), because it calls the gc 
> > function as well when the set is full but there can be timed out entries. 
> 
> Why is trylock-based gc going to make hassle again?

Because mtype_expire() which scans the whole set to find and evict 
expired entries is called not only from the gc function but from add as 
well (to reclaim space since last gc) and list too (to get the number of 
elements). One locks out the another and that reported in the error 
message.

> > I'm going to work on a solution with covers that case too.

Region-locking seems to be the best way to go.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
