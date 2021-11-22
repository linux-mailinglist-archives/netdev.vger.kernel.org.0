Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EB4458B33
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 10:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238743AbhKVJUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 04:20:03 -0500
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:33716 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229906AbhKVJUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 04:20:03 -0500
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 6649C101F57E3;
        Mon, 22 Nov 2021 09:16:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 277BDE000377;
        Mon, 22 Nov 2021 09:16:43 +0000 (UTC)
Message-ID: <8e739443edb76961dfe949f82f52db9be9210adc.camel@perches.com>
Subject: Re: [PATCH net-next] neighbor: Remove redundant if statement
From:   Joe Perches <joe@perches.com>
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 22 Nov 2021 01:16:53 -0800
In-Reply-To: <20211122084909.18093-1-yajun.deng@linux.dev>
References: <20211122084909.18093-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5u3dos19bc6fu7yy91sc6osj8xgtxj1k
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 277BDE000377
X-Spam-Status: No, score=-0.61
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19frJoCgBWDCW7X0Sjr/8MnIj7vwb0W/24=
X-HE-Tag: 1637572603-758670
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-22 at 16:49 +0800, Yajun Deng wrote:
> The if statement already exists in the __neigh_event_send() function,
> remove redundant if statement.
[]
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
[]
> @@ -452,9 +452,7 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  	
>  	if (READ_ONCE(neigh->used) != now)
>  		WRITE_ONCE(neigh->used, now);
> -	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
> -		return __neigh_event_send(neigh, skb);
> -	return 0;
> +	return __neigh_event_send(neigh, skb);
>  }

Perhaps this is an optimization to avoid the lock/unlock in __neigh_event_send?
If so a comment could be useful.

And also perhaps this code would be clearer with the test reversed:

	if (neigh->nud_state & (NUD_CONNECTED | NUD_DELAY | NUD_PROBE))
		return 0;

	return __neigh_event_send(neigh, skb);


