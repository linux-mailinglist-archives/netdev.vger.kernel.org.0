Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29942B7378
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgKRBHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgKRBHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:07:14 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6CA2222A;
        Wed, 18 Nov 2020 01:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605661634;
        bh=ELzdQ3BiRJJhIv5t55zERgvB65GFZ/Wxxv2SXkR0cAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H9eeHcmBV83AGSfloU58zPd6tsr9xAEErqT6gbtsHPBkZnqEfJLKOeJLjexbmlT2I
         vLPIWQyRzk7VSkX4xBImm3QdWF1ZkWtHYJFym/h2ossN5vuRzaK86H0d/QtCm14PF6
         mxyj8w1CEfCNxkURJZStb+5+cAf7fVQCyoxM6u1s=
Date:   Tue, 17 Nov 2020 17:07:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Klink <flokli@flokli.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
Message-ID: <20201117170712.0e5a8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
References: <20201115224509.2020651-1-flokli@flokli.de>
        <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 17:55:54 -0700 David Ahern wrote:
> On 11/17/20 5:01 PM, Jakub Kicinski wrote:
> > On Sun, 15 Nov 2020 23:45:09 +0100 Florian Klink wrote:  
> >> Checking for ifdef CONFIG_x fails if CONFIG_x=m.
> >>
> >> Use IS_ENABLED instead, which is true for both built-ins and modules.
> >>
> >> Otherwise, a  
> >>> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1    
> >> fails with the message "Error: IPv6 support not enabled in kernel." if
> >> CONFIG_IPV6 is `m`.
> >>
> >> In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.
> >>
> >> Cc: Kim Phillips <kim.phillips@arm.com>
> >> Signed-off-by: Florian Klink <flokli@flokli.de>  
> > 
> > LGTM, this is the fixes tag right?
> > 
> > Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")  
> 
> yep.
> 
> > 
> > CCing David to give him a chance to ack.  
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Great, applied, thanks!

> I looked at this yesterday and got distracted diving into the generated
> file to see the difference:
> 
> #define CONFIG_IPV6 1
> 
> vs
> 
> #define CONFIG_IPV6_MODULE 1

Interesting.

drivers/net/ethernet/netronome/nfp/flower/action.c:#ifdef CONFIG_IPV6

Oops.
