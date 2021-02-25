Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE048325A27
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhBYXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhBYXZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 18:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4B264EDB;
        Thu, 25 Feb 2021 23:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614295517;
        bh=Mx/aPQg96M77ZPfvh1/f5+vDZSOzw4U3z0tVWpCNF0k=;
        h=Date:From:To:Cc:Subject:From;
        b=qacuj/p9BeS6bh4UKvgEiNL5GXejC6cnvATLpAA/TMhgg5dm7EInkZSK2fYI3NfUU
         h3Wl6UkMeUVkhDCiEmWPhn6zVjRSQqZe1nhntwDyx/1fBW7bFRayd6CMp+JxupT0kR
         FzMgM5kU6FoGiqoJ8EZm1UCdtPYZyl25X3Ms5XoJuOyh7YcEHPuafCZt3eE/WuoDGb
         e8oS+4kkhNL8n913QM0BgISrlFanrsVutOT4UfuAjiVLAAzT19ibPRD2z2w/mjuwz6
         bi28oCJXRuASxgjPJ5V2grjoANs5v8eIT6kUlB2Nax6WkRecn5yBvyc/Ov0eOQoL5b
         tZEH1KR3FZEKw==
Date:   Thu, 25 Feb 2021 15:25:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Spurious TCP retransmissions on ack vs kfree_skb reordering
Message-ID: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

We see large (4-8x) increase of what looks like TCP RTOs after rising 
the Tx coalescing above Rx coalescing timeout.

Quick tracing of the events seems to indicate that the data has already
been acked when we enter tcp:tcp_retransmit_skb:

sk_state:      1
icsk_ca_state: 4

bytes_in:      0
bytes_out:   742
bytes_acked: 742

Is this a known condition? Is the recommendation to filter such events
out in tracing infra?
