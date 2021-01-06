Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A972EC51E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbhAFUeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbhAFUeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 15:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2145B23132;
        Wed,  6 Jan 2021 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609965236;
        bh=t9s/8JSXkjA6VDlHWiC8cI+MTijHphuGKV0Y1q58r8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=twwkx+RsUl1TdjzRPH8eWD5laVgDbWXwmWrX+QRJa1Q5AKABRKGhPBGoCiI1EbzoF
         sQ3CEC0mI5jnmnoWOa0ynQw218LPjzy3qsrchT3xRnKoaYf/IJebTMxG3g/2LGZK0F
         tk/v7lh8AK+M2WyZYTUHb9mkYuCCxl5ptt3G93Xv+KuotQ8RNpMGOxuSVSVyMYvu77
         oOem6DFHUoEBzb/u9XPTaX4WWg5EMFdd8UXpB5qaXnuzxtqQEo/CRMTziDP2PMXQzJ
         vlHCPzgc2oeTzOoHZQpR80+WRc5JYit0UxUc7b4L2fzVXzUUF1K3RLm+07CtXAQTpU
         XWJZw/e46W9Uw==
Date:   Wed, 6 Jan 2021 12:33:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, gnault@redhat.com, jchapman@katalix.com
Subject: Re: [PATCH] ppp: fix refcount underflow on channel unbridge
Message-ID: <20210106123353.1ac8d367@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105211743.8404-1-tparkin@katalix.com>
References: <20210105211743.8404-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 21:17:43 +0000 Tom Parkin wrote:
> When setting up a channel bridge, ppp_bridge_channels sets the
> pch->bridge field before taking the associated reference on the bridge
> file instance.
> 
> This opens up a refcount underflow bug if ppp_bridge_channels called
> via. iotcl runs concurrently with ppp_unbridge_channels executing via.
> file release.
> 
> The bug is triggered by ppp_bridge_channels taking the error path
> through the 'err_unset' label.  In this scenario, pch->bridge is set,
> but the reference on the bridged channel will not be taken because
> the function errors out.  If ppp_unbridge_channels observes pch->bridge
> before it is unset by the error path, it will erroneously drop the
> reference on the bridged channel and cause a refcount underflow.
> 
> To avoid this, ensure that ppp_bridge_channels holds a reference on
> each channel in advance of setting the bridge pointers.

Please prefix the subject with [PATCH net v3] for v3, add a fixes tag,
and make sure to include you sign-off.
