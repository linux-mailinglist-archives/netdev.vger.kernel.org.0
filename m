Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE750321D11
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBVQda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhBVQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 11:32:48 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AFBC061794;
        Mon, 22 Feb 2021 08:31:29 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lEE7A-006xZ6-IT; Mon, 22 Feb 2021 17:31:16 +0100
Message-ID: <3823be537c3c138de90154835573113c6577188e.camel@sipsolutions.net>
Subject: Re: [PATCH net v1 3/3] [RFC] mac80211: ieee80211_store_ack_skb():
 make use of skb_clone_sk_optional()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 22 Feb 2021 17:30:59 +0100
In-Reply-To: <20210222151247.24534-4-o.rempel@pengutronix.de>
References: <20210222151247.24534-1-o.rempel@pengutronix.de>
         <20210222151247.24534-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-22 at 16:12 +0100, Oleksij Rempel wrote:
> This code is trying to clone the skb with optional skb->sk. But this
> will fail to clone the skb if socket was closed just after the skb was
> pushed into the networking stack.

Which IMHO is completely fine. If we then still clone the SKB we can't
do anything with it, since the point would be to ... send it back to the
socket, but it's gone.

Nothing to fix here, I'd think. If you wanted to get a copy back that
gives you the status of the SKB, it should not come as a huge surprise
that you have to keep the socket open for that :)

Having the ACK skb will just make us do more work by handing it back
to skb_complete_wifi_ack() at TX status time, which is supposed to put
it into the socket's error queue, but if the socket is closed ... no
point in that.

johannes


