Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15281453953
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhKPSVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 13:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239393AbhKPSVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 13:21:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7616139F;
        Tue, 16 Nov 2021 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637086730;
        bh=95XzXX0ytFfrQCZH4RRlvS2TYSmMBrwhtkneueu/VHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KAPs4g846YU87w8MH8I/Ry/+9L6gYF4N33vFOU0IrXIR6jaaCXk8iWFiatnuwEgiu
         7zYt04DFIVhd6e2FF+nylUT/9xfmYftb1gjJRlW1+2s8fv0K1udEAYnTTo0QwaD4ZE
         6xrOyDsqyCDk1B17EKlG96HQpnLNEr2XNpeXTiQ9E8Bo2y2HyDbvgiWxRyMslFvipg
         E0SYbcVcvn+W4C/vmW6otUZJgQbUzP+CZuG4HJa0DWpGb9mr77krytHPgtrkY/p+CK
         tlg8ookEni7CXFz9j4viZcV+3W/+o1mRcMGYDSy83K195dmiLi6TJygEEBcZ7szEef
         pc7XzWYaVBiAQ==
Date:   Tue, 16 Nov 2021 10:18:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
Message-ID: <20211116101849.07930a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
        <20211115190249.3936899-18-eric.dumazet@gmail.com>
        <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
        <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
        <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 08:46:37 -0800 Eric Dumazet wrote:
> On my testing host,
> 
> 4K MTU : processing ~2,600.000 packets per second in GRO and other parts
> use about 60% of the core in BH.
> (Some of this cost comes from a clang issue, and the csum_partial() one
> I was working on last week)
> NIC RX interrupts are firing about 25,000 times per second in this setup.
> 
> 1500 MTU : processing ~ 5,800,000 packets per second uses one core in
> BH (and also one core in recvmsg()),
> We stay in NAPI mode (no IRQ rearming)
> (That was with a TCP_STREAM run sustaining 70Gbit)
> 
> BH numbers also depend on IRQ coalescing parameters.

Very interesting, curious to see what not doing the copy under socket
lock will do to the 1.5k case. 

Thanks a lot for sharing the detailed info!
