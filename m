Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4553303B6F
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392292AbhAZLVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:21:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392194AbhAZLVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 06:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7039022795;
        Tue, 26 Jan 2021 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611660038;
        bh=cxRRKLvkAzn2aBTFkAN9CJZ7uMjLsyIWHcwe3vNgWns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mboS0X9Ca6iVq9Fp7TWZryUk0WK0mCud4u2Gn2bvqyR8Tg60493cnPLHqJT/TsstQ
         HZyG+oSPHSEEjGphSBg+68LZYU3EAVpHn9G0VK3ysj0M5aTo0FwwohhObGsu9dziND
         Vh0cTQuEWEIoc1sgAGgYrvOXRqnBzT0RahtGfg1E=
Date:   Tue, 26 Jan 2021 12:20:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ilan.peer@intel.com,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] staging: rtl8723bs: fix wireless regulatory API misuse
Message-ID: <YA/7BL3eblv1glZr@kroah.com>
References: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126115409.d5fd6f8fe042.Ib5823a6feb2e2aa01ca1a565d2505367f38ad246@changeid>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:54:09AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This code ends up calling wiphy_apply_custom_regulatory(), for which
> we document that it should be called before wiphy_register(). This
> driver doesn't do that, but calls it from ndo_open() with the RTNL
> held, which caused deadlocks.
> 
> Since the driver just registers static regdomain data and then the
> notifier applies the channel changes if any, there's no reason for
> it to call this in ndo_open(), move it earlier to fix the deadlock.
> 
> Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
> Fixes: 51d62f2f2c50 ("cfg80211: Save the regulatory domain with a lock")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Greg, can you take this for 5.11 please? Or if you prefer, since the
> patch that exposed this and broke the driver went through my tree, I
> can take it as well.

Please feel free to take it through yours, as I don't think I'll have
any more staging patches for 5.11-final (or none have been sent to me
yet), so this might be the fastest way in:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
