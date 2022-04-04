Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5144F4F1533
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347701AbiDDMuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347355AbiDDMt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:49:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4763C73A;
        Mon,  4 Apr 2022 05:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tmaE3bk3w7jHXRbre4aq94KKPhz4+yMA0dlZbfzC3so=; b=m4hXgbCngnMiIc9qDyq1NKCNeR
        1/pITLzBAP6ZWb6sQteBI21QuKTYKrQWXPbfkWJZ07ozns2AxCQf7coy+W1y01RllfjDjgOG2NbWK
        DlKyGr92bsQiT8ip6B3zNJSG0cOAFPGy0rO4P5acGKsHEUBN0lJ4LJCQfbjYHQGwQ/MU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbM7i-00E5hI-2o; Mon, 04 Apr 2022 14:47:58 +0200
Date:   Mon, 4 Apr 2022 14:47:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2] ipv6: fix locking issues with loops over
 idev->addr_list
Message-ID: <Ykro/s5+kd+po26e@lunn.ch>
References: <20220403231523.45843-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403231523.45843-1-dossche.niels@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 01:15:24AM +0200, Niels Dossche wrote:
> idev->addr_list needs to be protected by idev->lock. However, it is not
> always possible to do so while iterating and performing actions on
> inet6_ifaddr instances. For example, multiple functions (like
> addrconf_{join,leave}_anycast) eventually call down to other functions
> that acquire the idev->lock. The current code temporarily unlocked the
> idev->lock during the loops, which can cause race conditions. Moving the
> locks up is also not an appropriate solution as the ordering of lock
> acquisition will be inconsistent with for example mc_lock.

Hi Niels

What sort of issues could the race result in?

I've been chasing a netdev reference leak, when using the GNS3
simulator. Shutting down the system can result in one interface having
a netdev reference count of 5, and it never gets destroyed. Using the
tracker code Eric recently added, i found one of the leaks is idev,
its reference count does not go to 0, and hence the reference it holds
on the netdev is never released.

I will test this patch out, see if it helps, but i'm just wondering if
you think the issue i'm seeing is theoretically possible because of
this race? If it is, we might want this applied to stable, not just
net-next.

Thanks
	Andrew
