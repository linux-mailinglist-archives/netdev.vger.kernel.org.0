Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6895128AB17
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 01:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgJKXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 19:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387799AbgJKXaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 19:30:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A606B207D3;
        Sun, 11 Oct 2020 23:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602459030;
        bh=Ff5geeY/vb97bfI4zCs5RCpvI6lIo23pIvbrLYF4c4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G9FsdsewQwMBFb7UQTbFtf+TDLhMBELsBHeNDlYUj+HcZ4CRs1+BtErsNHfBbfKBQ
         dXV8dssCMhtFoWncbY9A2xbf48IL9TQI+uWFRbVWiLK6ffVky0UQPxru74q3urBYuV
         np9ajpkHbkn90Bs8+CtHHKbVNscv7lnDZx3j1NJM=
Date:   Sun, 11 Oct 2020 16:30:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201011163028.5f436f39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f824950d4b24_1867f20894@john-XPS-13-9370.notmuch>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
        <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201010124402.606f2d37@carbon>
        <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f824950d4b24_1867f20894@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 16:52:48 -0700 John Fastabend wrote:
> Jakub Kicinski wrote:
> > FWIW I took a quick swing at testing it with the HW I have and it did
> > exactly what hardware should do. The TX unit entered an error state 
> > and then the driver detected that and reset it a few seconds later.  
> 
> Ths seems like the right thing to do in my opinion. If the
> stack gives the NIC garbage entering error state and reset
> sounds expected. Thanks for actually trying it by the way.
> 
> We might have come to different conclusions though from my side
> the conclusion is, good nothing horrible happened no MTU check needed.
> If the user spews garbage at the nic from the BPF program great it
> gets dropped and causes the driver/nic to punish you a bit by staying
> hung. Fix your BPF program.

Right probably difference of perspective. I understand that from
Cilium's POV you can probably feel pretty confident about the BPF
programs that are running. I bet Maciej is even more confident with
Android!

But in principle BPF was supposed to make the kernel end user
programmable. We have to ensure it's safe.

> > > > And all this for what? Saving 2 cycles on a branch that will almost
> > > > never be taken?    
> 
> 2 cycles here and 2 cycles there .... plus complexity to think about
> it. Eventually it all adds up. At the risk of entering bike shedding
> territory maybe.

Not sure it's a bike shedding territory but I doubt you want to be
making either the complexity or the performance argument to a fellow 
TLS maintainer.. cough cough.. ;)
