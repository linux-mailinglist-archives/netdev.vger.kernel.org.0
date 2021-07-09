Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA33C29E4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGIT7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhGIT7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 15:59:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796B5613C9;
        Fri,  9 Jul 2021 19:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625860619;
        bh=MTQ7Cx2BfJ8IwwJfBQ3OwbL3ssKJunqiTdb3iG4Y/4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u4YaPzTFQNNzzsGOOapgTjfbmLXisYUEje812E01SmOlUMd45L0ryTl4R1gC9Kuci
         ZlFFTlqXCof6wT9XocOcYdyrU20zNurvw8JNmLisnwAS4pH92INgh0F/qCSjUpHDhI
         6A40Ha4y5E2noeUKdqJFZFmQthnX+N6KWRwIcCikv1ZDSiGk0Z2RX0r2BmAQ+CDeH1
         j+SkwbT9xIvSEIploX/pHG2bBx8el9bDFWGW4ewBKAGQIfOsplheCxX38dXIkHxXc5
         ctrQkUXvBVixrc6j2qaGKhyizqmxe7T/D7hSOyYRiBQ5Yp85FVqG1GOgNTQK57a4Ri
         UcrYoDJUv9QFg==
Date:   Fri, 9 Jul 2021 12:56:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
Message-ID: <20210709125658.6c44e4e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aa74017284590d724427e168eac220d108f287d1.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
        <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
        <878s2fvln4.fsf@toke.dk>
        <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
        <9c451d25fb36bc82e602bb93e384b262be743fbf.camel@redhat.com>
        <87lf6feckr.fsf@toke.dk>
        <aa74017284590d724427e168eac220d108f287d1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 09 Jul 2021 18:35:59 +0200 Paolo Abeni wrote:
> > +	if (netif_running(dev))
> > +		veth_open(dev);
> > +	return 0;
> > 
> > 
> > (also, shouldn't the result of veth_open() be returned? bit weird if you
> > don't get an error but the device stays down...)  
> 
> Agreed.

We've been fighting hard to make sure ethtool -L/-G/etc don't leave
devices half-broken. Maybe it's not as important for software devices,
but we should set a good example. We shouldn't take the device down
unless we are sure we'll be able to bring it up. So if veth_open()
"can't fail" it should be a WARN_ON(veth_open()), not return; and if 
it may fail due to memory allocations etc we should do a prepare/commit.
