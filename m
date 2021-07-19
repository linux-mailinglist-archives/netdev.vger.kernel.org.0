Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7AD3CD26E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhGSKCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhGSKCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D2460200;
        Mon, 19 Jul 2021 10:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626691409;
        bh=6Syh+13LnQpXTcqNDP+g4OHlMwEdXxPY/taE+B+++8w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IheW4gdgRvGdwwdwMWNVcY9VeSTyBEPhjMk2MRteyMAQp991OplWwQl4gwXZKL9EH
         Pu8dMsalOkm/WmEv2eZ/iY89hktzEowJmqmyAGUwJA2fwW4CB46xpH1JQTYd9144Aa
         dtU99uYr2z38bi1cBVsVHo4MPoTlQw0Z1rLyv+dOJqObgmUJpt63LWC02M7yR7kxiK
         QPwmV8oRRdSq7NDWGdMy3axyWyD1VUJWeb40h4c72L6Ko4kAztMLH8vX2wl3eN4CnS
         /asVouCyxopI2rMLHpmcvXgFfaXuo0Zm6ABZWW5XzQAYSdBRkduwut+mrzN2ZR28cf
         sefUcN610ZfPg==
Date:   Mon, 19 Jul 2021 12:43:23 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net 8/9] bnxt_en: Move bnxt_ptp_init() to bnxt_open()
Message-ID: <20210719124323.085fa184@cakuba>
In-Reply-To: <1626636993-31926-9-git-send-email-michael.chan@broadcom.com>
References: <1626636993-31926-1-git-send-email-michael.chan@broadcom.com>
        <1626636993-31926-9-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Jul 2021 15:36:32 -0400, Michael Chan wrote:
> The device needs to be in ifup state for PTP to function, so move
> bnxt_ptp_init() to bnxt_open().  This means that the PHC will be
> registered during bnxt_open().

I think it's an anti-pattern to have the clock registered only when
the device is up. Right, Richard?

IIRC Intel parts did it in the past because they had the clock hooked
up to the MAC/PHY so the clock was not actually ticking. But seems like
a wrong trade off to unreg PTP for SW convenience. Or maybe I'm
biased against the live FW reset :) Let's see if Richard agrees.

> This also makes firmware reset work correctly.  PTP configurations
> may change after firmware upgrade or downgrade.  bnxt_open() will
> be called after firmware reset, so it will work properly.
> 
> bnxt_ptp_start() is now incorporated into bnxt_ptp_init().  We now
> also need to call bnxt_ptp_clear() in bnxt_close().
