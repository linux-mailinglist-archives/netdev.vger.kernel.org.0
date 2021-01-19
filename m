Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E622FAF4C
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbhASED7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbhASEDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:03:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECC920867;
        Tue, 19 Jan 2021 04:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611028943;
        bh=xx6k3yUK3ETlUzVTgZakpoq+cUzB70gWfPejY4ApzAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INI1rIcG/YgwrlXfSOa04rfIkxP4X8Fs8LpxjdkAFJPaTwZbo1YIkQCc4/DRQhMen
         BGxZMV8qErgpRJY1YgUNNWMDLX03CSVlgtrELFDtRlaeQzNv/MG76Ywy3eoKdaKUa0
         /EXmYcVvKKgauyLN9V0c5PsL3hipiwFBeZeTg19IIwTx0rhZYtfgRLscReEhxFZ5jJ
         NcKuTI56qKg7ESuDl0ZW/BTmjCLzbJYzgAwjcItrcvLvJSrS5h3Rs0EaNFSIy24heT
         S7o6mX/YHJaTSjUKLUbpYJo7xj8yD9Eoik3D1V9VR/hcUA7helBWsfASovBJiB+Q7s
         S/gXkuo6B7pGA==
Date:   Mon, 18 Jan 2021 20:02:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>
Subject: Re: [PATCH net v2] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210118200221.73033add@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115223058.GA39267@localhost.localdomain>
References: <20210115223058.GA39267@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 14:30:58 -0800 Enke Chen wrote:
> From: Enke Chen <enchen@paloaltonetworks.com>
> 
> The TCP session does not terminate with TCP_USER_TIMEOUT when data
> remain untransmitted due to zero window.
> 
> The number of unanswered zero-window probes (tcp_probes_out) is
> reset to zero with incoming acks irrespective of the window size,
> as described in tcp_probe_timer():
> 
>     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
>     as long as the receiver continues to respond probes. We support
>     this by default and reset icsk_probes_out with incoming ACKs.
> 
> This counter, however, is the wrong one to be used in calculating the
> duration that the window remains closed and data remain untransmitted.
> Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> actual issue.
> 
> In this patch a new timestamp is introduced for the socket in order to
> track the elapsed time for the zero-window probes that have not been
> answered with any non-zero window ack.
> 
> Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> Reported-by: William McCall <william.mccall@gmail.com>
> Co-developed-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> Reviewed-by: Yuchung Cheng <ycheng@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

I take it you got all these tags off-list? I don't see them on the v1
discussion.

Applied to net, thanks!
