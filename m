Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2306A3011FC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbhAWB1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbhAWB1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:27:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4E723B3E;
        Sat, 23 Jan 2021 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611365224;
        bh=2SU6WEhMDJ8r1hQaUdgvnOv5FxDz9Wshd4CNOOPSgZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uiZ7jLQKJ1gg92i5XZsQLyZqlQe7k570Ixm5CCNhIfyAEQHzqzIWOGfzXionmN+8c
         nsEZEHHAks9VpJdECB6TaYjKt4sS7kPYsPbFO0Yz+vrw+SQfpE/7GAsohPLpw1EW6I
         9ct83O13X+rKsulPzIWTxP7X99K7JHNPU3JFosuB5u4xL+ClrvINBjk+/RX2M3CpRc
         ILfF/A4pnrA+ZPfv/IOfNnd/5YZ/wcjWiz7Bmq+0639r0lsrYsVKbQp78lDqbLYYgU
         CNhpZcIvkuKY96OSvufcdg4yFz7WEiPGpVRbzEoPphKr5JU3p6u4QFvFZiweRM5fXD
         7t8FhIYBDBdig==
Date:   Fri, 22 Jan 2021 17:27:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes
 from DISORDER to OPEN
Message-ID: <20210122172703.39cfff6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com>
References: <1611311242-6675-1-git-send-email-yangpc@wangsu.com>
        <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 11:53:46 +0100 Eric Dumazet wrote:
> On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > change from DISORDER to OPEN. If the sender is app-limited, it can only
> > wait for the RTO timer to expire and retransmit.
> >
> > The reason for this is that the TLP timer is set before CA_STATE changes
> > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > until after tcp_fastretrans_alert() returns and remove the
> > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> >
> > This commit has two additional benefits:
> > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > avoid spurious RTO caused by RTO timer early expires.
> > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > timer is set.
> >
> > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
>
> This looks like a very nice patch, let me run packetdrill tests on it.
> 
> By any chance, have you cooked a packetdrill test showing the issue
> (failing on unpatched kernel) ?

Any guidance on backporting / fixes tag? (once the packetdrill
questions are satisfied)
