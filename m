Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A881A2A39CB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgKCBS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbgKCBSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:18:54 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28AE0222B9;
        Tue,  3 Nov 2020 01:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366334;
        bh=2wozxo6UzNQ3C09kqq3AQqSe6IwbvNBu7RrW9/B+PFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=baKsnJ3AdEXD7jJhTRcybbenWtXUO9nKN57+K4RaRKoTeEoV6jgzmp5nhZ5SFCC3q
         FtNvV+vPtZ6PiJWIXRHI5GHY3YZQRemtSUWNruiSikFQ5l+Y5CuXpckKs4NQVlq1JI
         wYtWHtVfW678udsJep0+3RJ4brZL0tp4dC+1Ra/w=
Date:   Mon, 2 Nov 2020 17:18:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com, nanditad@google.com,
        Matt Mathis <mattmathis@google.com>
Subject: Re: [PATCH net-next] tcp: avoid slow start during fast recovery on
 new losses
Message-ID: <20201102171853.4fe550bb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031013412.1973112-1-ycheng@google.com>
References: <20201031013412.1973112-1-ycheng@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 18:34:12 -0700 Yuchung Cheng wrote:
> During TCP fast recovery, the congestion control in charge is by
> default the Proportional Rate Reduction (PRR) unless the congestion
> control module specified otherwise (e.g. BBR).
> 
> Previously when tcp_packets_in_flight() is below snd_ssthresh PRR
> would slow start upon receiving an ACK that
>    1) cumulatively acknowledges retransmitted data
>    and
>    2) does not detect further lost retransmission
> 
> Such conditions indicate the repair is in good steady progress
> after the first round trip of recovery. Otherwise PRR adopts the
> packet conservation principle to send only the amount that was
> newly delivered (indicated by this ACK).
> 
> This patch generalizes the previous design principle to include
> also the newly sent data beside retransmission: as long as
> the delivery is making good progress, both retransmission and
> new data should be accounted to make PRR more cautious in slow
> starting.
> 
> Suggested-by: Matt Mathis <mattmathis@google.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
