Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7560028A427
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgJJWyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731365AbgJJTMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:12:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF0E224BD;
        Sat, 10 Oct 2020 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602353614;
        bh=hmmzZ+rTKgQ/TS7GiKPawSEKTuTvPyRTuBvFwPp3iO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUyGPnaeXRG4pbJWLk2+Jq8MuwyfgWJci5cDAcYWVxMxKCIC7PcTqPXWZP3YuSD8O
         dzyjZy7OygfGQuKqngltikiF9jSt1Ne2gfzhntPcrq5eW7UvTVQZkhDruYpSCvw2IT
         BCsLw4KqR56AvtDoNjFk4ILambbGxPr2Jcxw6+ZE=
Date:   Sat, 10 Oct 2020 11:13:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Subject: Re: [PATCH net 0/2] mptcp: some fallback fixes
Message-ID: <20201010111332.3ac29a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1602262630.git.pabeni@redhat.com>
References: <cover.1602262630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 18:59:59 +0200 Paolo Abeni wrote:
> pktdrill pointed-out we currently don't handle properly some
> fallback scenario for MP_JOIN subflows
> 
> The first patch addresses such issue.
> 
> Patch 2/2 fixes a related pre-existing issue that is more
> evident after 1/2: we could keep using for MPTCP signaling
> closed subflows.

Applied, thanks Paolo.

You already have a few of those in the code, but:

+	if (... &&
+	    schedule_work(&mptcp_sk(sk)->work))
+		sock_hold(sk);

isn't this a fairly questionable construct?

You take a reference for the async work to release _after_ you
scheduled the async work? 
