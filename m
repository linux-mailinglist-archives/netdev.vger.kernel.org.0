Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5042A0B72
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgJ3Qlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgJ3Qlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 12:41:55 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3662320724;
        Fri, 30 Oct 2020 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076113;
        bh=XPRi4KRoCq3wi6mduiAZGHlA7Fm6yb6JSrd2b64kkNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1/6BQUkvrO9d/ep9zEg3wSJ2D1QPdJB0XrPFMU04LnmddyGUHK+3x/pPA+BQfy0sd
         U4uIC7ypcxH8VCG283hAfDZFjLF7SE+kV8McjgkuOS337cbUEfJZ6HJylWmWbYjY/1
         NWwt/3k6lqo+Pmhd/uo4FdzAAzQTPrRRT1vFH4hs=
Date:   Fri, 30 Oct 2020 09:41:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        james.jurack@ametek.com
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201030094152.7a20644b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029081057.8506-1-claudiu.manoil@nxp.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201029081057.8506-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 10:10:56 +0200 Claudiu Manoil wrote:
> When PTP timestamping is enabled on Tx, the controller
> inserts the Tx timestamp at the beginning of the frame
> buffer, between SFD and the L2 frame header.  This means
> that the skb provided by the stack is required to have
> enough headroom otherwise a new skb needs to be created
> by the driver to accommodate the timestamp inserted by h/w.
> Up until now the driver was relying on skb_realloc_headroom()
> to create new skbs to accommodate PTP frames.  Turns out that
> this method is not reliable in this context at least, as
> skb_realloc_headroom() for PTP frames can cause random crashes,
> mostly in subsequent skb_*() calls, when multiple concurrent
> TCP streams are run at the same time with the PTP flow
> on the same device (as seen in James' report).  I also noticed
> that when the system is loaded by sending multiple TCP streams,
> the driver receives cloned skbs in large numbers.
> skb_cow_head() instead proves to be stable in this scenario,
> and not only handles cloned skbs too but it's also more efficient
> and widely used in other drivers.
> The commit introducing skb_realloc_headroom in the driver
> goes back to 2009, commit 93c1285c5d92
> ("gianfar: reallocate skb when headroom is not enough for fcb").
> For practical purposes I'm referencing a newer commit (from 2012)
> that brings the code to its current structure (and fixes the PTP
> case).
> 
> Fixes: 9c4886e5e63b ("gianfar: Fix invalid TX frames returned on error queue when time stamping")
> Reported-by: James Jurack <james.jurack@ametek.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied both, thank you!
