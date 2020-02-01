Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB014F95F
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 19:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgBASXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 13:23:47 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34046 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgBASXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 13:23:47 -0500
Received: by mail-pf1-f194.google.com with SMTP id i6so5228638pfc.1;
        Sat, 01 Feb 2020 10:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qCWaOrucqY/z8PmzK0tr/glHoH3x+ZN37USjThoLq7I=;
        b=gLqNwwBi9ne5nckttyZwPAoFhNRM9mkeSjpX3f/B88l6mcXbtUG/2HA/MZyR+ewzNR
         rw4DdPMt2WTjPHBFaCvdaEqQB50ThD3n/HhXsbT4R2RYnWRQk4kfQ8gClMOaPd0UpZm9
         JQNn1CmMXM2+bezEAeUEA8A49vNJ5MSNriWbNfQwxQdwDjpqiT5auuWm2sxJKIfKN+EW
         cr13ClUbJ2jFG3EWnX1ua9nhDgV/u0Xd8X9nJD9W0j1ym9ykyEQfPnfPwURfXKgV7fKC
         4z2APwzbsAZlBY59U/tO/bWNHDVpxRUvY13vxaAxQc01KQF/EHN6sVv3qshJQB4wy0XY
         8Zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qCWaOrucqY/z8PmzK0tr/glHoH3x+ZN37USjThoLq7I=;
        b=RwLUStKnei/emfWlCe4yiotJ31/Q6JLv6rz8XVQeZx0qJBtQTQOyEsJgd22L3/F2R4
         cJKWGQrF6ULM0c1Nzi8MHnUPk41nVVkF8RtMyrRpXA2XQl907WBuv+NkVYmI5PBLB000
         72+fYcX9vz7Rr9exz0Y7sLyIzBTCHRwrw15rAa6zP4ZrAW8vUG0WyIL+YVGpHUt+XPVB
         skMIFPbOmLgivGXuGvNRgSDSK+r3E4k85PdDNb2QU/hgDAzv9xeEnsbv0q+9v2KrI/J9
         a7Iq6oAY8ld1yiv49fb3APgjV1oYbS1KGk5Dh+GmL3QpqALZNbiYcKsdzz57F11sWAZU
         G+AA==
X-Gm-Message-State: APjAAAXIDKktCfVVhrdNq0K6QL0BcsHP2Os5zZz4OSD8iGs0Dwzzuk5F
        3A3UUPEas9EGbvoKzBGTroI=
X-Google-Smtp-Source: APXvYqzK5zSL+5OwGBZv9NjmzpScomoMMIaasa4bJ0xYTTR1f5tZZv4rua2nQ9ASK5oq0njevorocQ==
X-Received: by 2002:a63:f80a:: with SMTP id n10mr16880130pgh.76.1580581426358;
        Sat, 01 Feb 2020 10:23:46 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id ep2sm14445368pjb.31.2020.02.01.10.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 10:23:45 -0800 (PST)
Subject: Re: [PATCH v2.1 1/2] tcp: Reduce SYN resend delay if a suspicous ACK
 is received
To:     sj38.park@gmail.com
Cc:     David.Laight@aculab.com, aams@amazon.com, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, shuah@kernel.org, sjpark@amazon.de
References: <20200201143608.6742-1-sj38.park@gmail.com>
 <20200201145353.2607-1-sj38.park@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <735f9641-eb21-05f3-5fa4-2189ec84d5da@gmail.com>
Date:   Sat, 1 Feb 2020 10:23:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200201145353.2607-1-sj38.park@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/20 6:53 AM, sj38.park@gmail.com wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> When closing a connection, the two acks that required to change closing
> socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
> reverse order.  This is possible in RSS disabled environments such as a
> connection inside a host.
> 
> For example, expected state transitions and required packets for the
> disconnection will be similar to below flow.
> 
> 	 00 (Process A)				(Process B)
> 	 01 ESTABLISHED				ESTABLISHED
> 	 02 close()
> 	 03 FIN_WAIT_1
> 	 04 		---FIN-->
> 	 05 					CLOSE_WAIT
> 	 06 		<--ACK---
> 	 07 FIN_WAIT_2
> 	 08 		<--FIN/ACK---
> 	 09 TIME_WAIT
> 	 10 		---ACK-->
> 	 11 					LAST_ACK
> 	 12 CLOSED				CLOSED
> 
> In some cases such as LINGER option applied socket, the FIN and FIN/ACK
> will be substituted to RST and RST/ACK, but there is no difference in
> the main logic.
> 
> The acks in lines 6 and 8 are the acks.  If the line 8 packet is
> processed before the line 6 packet, it will be just ignored as it is not
> a expected packet, and the later process of the line 6 packet will
> change the status of Process A to FIN_WAIT_2, but as it has already
> handled line 8 packet, it will not go to TIME_WAIT and thus will not
> send the line 10 packet to Process B.  Thus, Process B will left in
> CLOSE_WAIT status, as below.
> 
> 	 00 (Process A)				(Process B)
> 	 01 ESTABLISHED				ESTABLISHED
> 	 02 close()
> 	 03 FIN_WAIT_1
> 	 04 		---FIN-->
> 	 05 					CLOSE_WAIT
> 	 06 				(<--ACK---)
> 	 07	  			(<--FIN/ACK---)
> 	 08 				(fired in right order)
> 	 09 		<--FIN/ACK---
> 	 10 		<--ACK---
> 	 11 		(processed in reverse order)
> 	 12 FIN_WAIT_2
> 
> Later, if the Process B sends SYN to Process A for reconnection using
> the same port, Process A will responds with an ACK for the last flow,
> which has no increased sequence number.  Thus, Process A will send RST,
> wait for TIMEOUT_INIT (one second in default), and then try
> reconnection.  If reconnections are frequent, the one second latency
> spikes can be a big problem.  Below is a tcpdump results of the problem:
> 
>     14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
>     14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
>     14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
>     /* ONE SECOND DELAY */
>     15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
> 
> This commit mitigates the problem by reducing the delay for the next SYN
> if the suspicous ACK is received while in SYN_SENT state.
> 
> Following commit will add a selftest, which can be also helpful for
> understanding of this issue.
> 
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  net/ipv4/tcp_input.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 2a976f57f7e7..baa4fee117f9 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
>  		 *        the segment and return)"
>  		 */
>  		if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> -		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> +		    after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> +			/* Previous FIN/ACK or RST/ACK might be ignored. */
> +			if (icsk->icsk_retransmits == 0)
> +				inet_csk_reset_xmit_timer(sk,
> +						ICSK_TIME_RETRANS,
> +						TCP_TIMEOUT_MIN, TCP_RTO_MAX);
>  			goto reset_and_undo;
> +		}
>  
>  		if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
>  		    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> 

Please add my

Signed-off-by: Eric Dumazet <edumazet@google.com>

Please resend the whole patch series as requested by netdev maintainers.


vi +134 Documentation/networking/netdev-FAQ.rst

Q: I made changes to only a few patches in a patch series should I resend only those changed?
---------------------------------------------------------------------------------------------
A: No, please resend the entire patch series and make sure you do number your
patches such that it is clear this is the latest and greatest set of patches
that can be applied.



