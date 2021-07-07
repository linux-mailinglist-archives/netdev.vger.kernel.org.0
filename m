Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BAC3BEEBC
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 20:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhGGSdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 14:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhGGSdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 14:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A1F61CC9;
        Wed,  7 Jul 2021 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625682628;
        bh=62OAYWNXAbynt6/4SPxeG8BN6GzYZxK2I7fzbAxIGT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BpFwCSyJH4MG8ueZP92yJf3e9Zkd8xElLO5qPmSIhiTeo508Xni6I1dgMXG9PlmPH
         152GzC6kxvHITCmHg0apTxX7Mmitk0nF0TGDc6d+HwW6j+0fG1f6VexT6vixwTLobI
         6uKnYAipAu/3z+zDuTJGy8urB9H8S1MBLZULjeOqBxmxkV0lBu2WfFi0HHxZA9u17h
         LqzESxSGcd2i/UezjMp6RaN3jAlMAJ6iHRa1Xng/fVbHM6fNWSpUUbsqhHaaV08CXH
         3KW/M++tOqw7FDRU0e4ZF+dOp0JFBQY9PZ2eZeDRferVEnQ69+J8rmBleQ4TdAnXI7
         fvdUp3NZAXx2w==
Date:   Wed, 7 Jul 2021 11:30:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
Message-ID: <20210707113027.4077e544@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
References: <cover.1625665132.git.vvs@virtuozzo.com>
        <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
        <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
        <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 19:41:44 +0200 Eric Dumazet wrote:
> On 7/7/21 6:42 PM, Jakub Kicinski wrote:
> > On Wed, 7 Jul 2021 08:45:13 -0600 David Ahern wrote:  
> >> why not use hh_len here?  
> > 
> > Is there a reason for the new skb? Why not pskb_expand_head()?  
> 
> 
> pskb_expand_head() might crash, if skb is shared.
> 
> We possibly can add a helper, factorizing all this,
> and eventually use pskb_expand_head() if safe.

Is there a strategically placed skb_share_check() somewhere further
down? Otherwise there seems to be a lot of questionable skb_cow*()
calls, also __skb_linearize() and skb_pad() are risky, no?
Or is it that shared skbs are uncommon and syzbot doesn't hit them?
