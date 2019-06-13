Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBEF44779
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfFMQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:59:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:54789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbfFMALc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 20:11:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 17:11:32 -0700
X-ExtLoop1: 1
Received: from ellie.jf.intel.com (HELO ellie) ([10.54.70.22])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2019 17:11:31 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 8/8] net/packet: introduce packet_rcv_try_clear_pressure() helper
In-Reply-To: <20190612165233.109749-9-edumazet@google.com>
References: <20190612165233.109749-1-edumazet@google.com> <20190612165233.109749-9-edumazet@google.com>
Date:   Wed, 12 Jun 2019 17:11:31 -0700
Message-ID: <87imtafioc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Eric Dumazet <edumazet@google.com> writes:

> There are two places where we want to clear the pressure
> if possible, add a helper to make it more obvious.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/packet/af_packet.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index d409e2fdaa7ee8ddf261354f91b682e403f40e9e..8c27e198268ab5148daa8e90aa2f53546623b9ed 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1271,6 +1271,13 @@ static int packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
>  	return ret;
>  }
>  
> +static void packet_rcv_try_clear_pressure(struct packet_sock *po)
> +{
> +	if (READ_ONCE(po->pressure) &&
> +	    __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
> +		WRITE_ONCE(po->pressure,  0);

Just a couple of (microscopical?) nitpicks, double space here and on the
commit message of patch 1/8.

Series look good.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
--
Vinicius
