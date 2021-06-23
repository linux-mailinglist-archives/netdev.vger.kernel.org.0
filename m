Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941743B148F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 09:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFWH3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 03:29:00 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21399 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWH27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 03:28:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1624433195; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QjXi9Z744O4gVA2dBuKeemIS9umnEE/rKC2RPbp7t4usshO8nBKY1MIkT0TofK6/dbOrb++xRQghvWiW8iSH7aCOH3Eg2lqcrExGNb4nyMig1WqapEBsNLJvsjnRlGqzGrCJEl4mwDN0Bo+fWyrDgxQ7uD98bi03MhHP6cXZ7EA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1624433195; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gw/vXIkX0vz1a4zhZIygnhHXrFnG7MN5D4ERSVv0ZRU=; 
        b=WwDF92utG6F7WAr3LPCAEBjZhqyz26gi7Ada3JSZZKAUlbhC0YAjArTD22v50mhWSd5FhAwXRFgcqjIzuF7gOK90e9z7Hqvjf4jgVdT6qDKHpZ8ZusiQQznCxcSto2cP2+moio8U0cEVgTUYcD/ReZH5wHMkcytzKjKx++FZ/qs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1624433195;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=gw/vXIkX0vz1a4zhZIygnhHXrFnG7MN5D4ERSVv0ZRU=;
        b=Uy1yxaRMSrOj/+oFOcmxgL+3E/juQW3WfPGsLOGznVB7saneg0wrPedyFgwtx/Yc
        b9cNz0SmxgitgcpBPIbeERZxNy9aIsbO8xVpkhQLOZPyUuFtC5vqJaVp0Mi3PKoGsPG
        nEg1Fj9a98x3pNMpgrMxGAFrxroEjub1Efa7WWuU=
Received: from anirudhrb.com (49.207.62.88 [49.207.62.88]) by mx.zohomail.com
        with SMTPS id 1624433190736196.19138414928034; Wed, 23 Jun 2021 00:26:30 -0700 (PDT)
Date:   Wed, 23 Jun 2021 12:56:20 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@anirudhrb.com
Subject: Re: [PATCH] mac80211_hwsim: correctly handle zero length frames
Message-ID: <YNLiHJuD3GuDgbKR@anirudhrb.com>
References: <20210610161916.9307-1-mail@anirudhrb.com>
 <a3589e399e179b389e90df36acb67ae1ec7dea97.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3589e399e179b389e90df36acb67ae1ec7dea97.camel@sipsolutions.net>
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 11:36:16AM +0200, Johannes Berg wrote:
> On Thu, 2021-06-10 at 21:49 +0530, Anirudh Rayabharam wrote:
> > syzbot, using KMSAN, has reported an uninit-value access in
> > hwsim_cloned_frame_received_nl(). This is happening because frame_data_len
> > is 0. The code doesn't detect this case and blindly tries to read the
> > frame's header.
> > 
> > Fix this by bailing out in case frame_data_len is 0.
> 
> This really seems quite pointless - you should bail out if the frame is
> too short for what we need to do, not just when it's 0.

That makes sense. Do you happen to know what the min length of a valid
frame is? There doesn't seem to be constant defined for that already.

	- Anirudh

> 
> johannes
> 
