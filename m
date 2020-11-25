Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055CB2C473A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbgKYSHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbgKYSHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 13:07:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58016206B2;
        Wed, 25 Nov 2020 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606327631;
        bh=r5HixT2+c4Ojond4l5wVYf1ooWLzHu/b2hEgsU9tPKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Li22CJwCwHAqmnLd70YqBAPCPqyDzQBnykBQBKy7wylrvnTKTOw2jAWIWiQIoQCpa
         9h7BIpAro1zXkwKpkFeKeQ2KT1C0Iw3NPEyhUlqePMDzWLCKj2oTsQU80lrjCeam0g
         H90W0OVTx7DOuS9TITzRxdtHVuY+DLLdvzng/oic=
Date:   Wed, 25 Nov 2020 10:07:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Hardcoded multicast queue length in macvlan.c driver causes
 poor multicast receive performance
Message-ID: <20201125100710.7e766d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
        <20201125085848.4f330dea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4e3c9f30-d43c-54b1-2796-86f38d316ef3@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 18:12:34 +0100 Thomas Karlsson wrote:
> >> For this reason I would like to know if you would consider
> >> merging a patch using the module_param(...) variant instead?
> >>
> >> I would argue that this still makes the situation better
> >> and resolves the packet-loss issue, although not necessarily
> >> in an optimal way. However, The upside of being able to specify the
> >> parameter on a per macvlan interface level instead of globally is not
> >> that big in this situation. Normally you don't use that much
> >> multicast anyway so it's a parameter that only will be touched by
> >> a very small user base that can understand and handle the implications
> >> of such a global setting.  
> > 
> > How about implementing .changelink in macvlan? That way you could
> > modify the macvlan device independent of Docker? 
> > 
> > Make sure you only accept changes to the bc queue len if that's the
> > only one you act on.
> >   
> 
> Hmm, I see. You mean that docker can create the interface and then I can
> modify it afterwards? That might be a workaround but I just submitted
> a patch (like seconds before your message) with the module_param() option
> and this was very clean I think. both in how little code that needed to be
> changed and in how simple it is to set the option in the target environment.
> 
> This is my first time ever attemting a contribution to the kernel so
> I'm quite happy to keep it simple like that too :)

Module params are highly inflexible, we have a general policy not 
to accept them in the netdev world. There should even be a check 
in our patchwork which should fail here, but it appears that the patch 
did not apply in the first place:

https://patchwork.kernel.org/project/netdevbpf/patch/385b9b4c-25f5-b507-4e69-419883fa8043@paneda.se/

Make sure you're developing on top of this tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
