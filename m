Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B022646D64E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhLHPDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:03:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42476 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhLHPDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:03:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07EE2CE21CE
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 14:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8381C00446;
        Wed,  8 Dec 2021 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638975584;
        bh=DTvigAeoAMrBQzdQCnK9r2KMK+z/PIim7z2g4pPqf1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KmtoLI7YeAjpF9wUzyRuCV3kwDfj60zSUpOMwriuosBls99gV0aBXSmLdp8tcvtso
         P496KTJqx0AlHhbSzrN2wIM977BRg9T+E4NjVfmHvfGjV8I3cMRBE9a3NMogNFW5ph
         312IT7nBG94yYA0yZdJJ9xY9Uhg5Sv4FA95k2bXMaRSc8Ic4CRutWNjn/A52shv8QE
         /YHN9ey1DQWDe4rb1TngkpKZ0rMsrj9EYrhHiMmRxVuFoSApq/orpnNSa+LVMVpoV5
         Lnr9n+E+NYCLl6x4IlamthBExKXjgbfNWyjvZGrYuekmuvSFcl5wuNXFWN0aNRG7wW
         y4wKCVV/PpNeA==
Date:   Wed, 8 Dec 2021 06:59:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Message-ID: <20211208065943.61b6220b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
        <20211205042217.982127-2-eric.dumazet@gmail.com>
        <3d80c863-8f1d-5e94-44c8-cc1193cca06a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 15:09:17 +0100 Andrzej Hajda wrote:
> On 05.12.2021 05:21, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > It can be hard to track where references are taken and released.
> >
> > In networking, we have annoying issues at device or netns dismantles,
> > and we had various proposals to ease root causing them.
> >
> > This patch adds new infrastructure pairing refcount increases
> > and decreases. This will self document code, because programmers
> > will have to associate increments/decrements.
> >
> > This is controled by CONFIG_REF_TRACKER which can be selected
> > by users of this feature.
> >
> > This adds both cpu and memory costs, and thus should probably be
> > used with care.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> 
> Life is surprising, I was working on my own framework, solving the same 
> issue, with intention to publish it in few days :)
>
> My approach was little different:
> 
> 1. Instead of creating separate framework I have extended debug_objects.
> 
> 2. There were no additional fields in refcounted object and trackers - 
> infrastructure of debug_objects was reused - debug_objects tracked both 
> pointers of refcounted object and its users.
> 
> 
> Have you considered using debug_object? it seems to be good place to put 
> it there, I am not sure about performance differences.

Something along these lines?

https://lore.kernel.org/all/20211117174723.2305681-1-kuba@kernel.org/

;)

> One more thing about design - as I understand CONFIG_REF_TRACKER turns 
> on all trackers in whole kernel, have you considered possibility/helpers 
> to enable/disable tracking per class of objects?
