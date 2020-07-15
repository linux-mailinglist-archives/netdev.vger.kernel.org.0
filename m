Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A69A221607
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGOUVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgGOUVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 16:21:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B209320657;
        Wed, 15 Jul 2020 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594844504;
        bh=VQli7jtE5T/1SYWklpK2VCHwm8hJkAqOYFW8SlVpDJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yu9VK1c6Pq0Q4zp0DjbR6qa28sZfUiRyQIeX5Qlc7Q1aGH/Ly5XlPtofF7ct7+HgH
         U5eiDd7kibMnusLyA2PK+HltG5eZp8baVIOdimQiu2PTQ7irKwXIuG2J6oc8d+VCXY
         JQGTi+Re6xVngnPDUCw3tBLdsBt0tp8abdeupdoA=
Date:   Wed, 15 Jul 2020 13:21:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Ogness <john.ogness@linutronix.de>,
        Willem de Bruijn <willemb@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_packet: TPACKET_V3: replace busy-wait loop
Message-ID: <20200715132141.2c72ae75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200707152204.10314-1-john.ogness@linutronix.de>
References: <20200707152204.10314-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jul 2020 17:28:04 +0206 John Ogness wrote:
> A busy-wait loop is used to implement waiting for bits to be copied
> from the skb to the kernel buffer before retiring a block. This is
> a problem on PREEMPT_RT because the copying task could be preempted
> by the busy-waiting task and thus live lock in the busy-wait loop.
> 
> Replace the busy-wait logic with an rwlock_t. This provides lockdep
> coverage and makes the code RT ready.
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Is taking a lock and immediately releasing it better than a completion?
Seems like the lock is guaranteed to dirty a cache line, which would
otherwise be avoided here.

Willem, would you be able to take a look as well? Is this path
performance sensitive in real life?

> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 29bd405adbbd..dd1eec2dd6ef 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -593,6 +593,7 @@ static void init_prb_bdqc(struct packet_sock *po,
>  						req_u->req3.tp_block_size);
>  	p1->tov_in_jiffies = msecs_to_jiffies(p1->retire_blk_tov);
>  	p1->blk_sizeof_priv = req_u->req3.tp_sizeof_priv;
> +	rwlock_init(&p1->blk_fill_in_prog_lock);
>  
>  	p1->max_frame_len = p1->kblk_size - BLK_PLUS_PRIV(p1->blk_sizeof_priv);
>  	prb_init_ft_ops(p1, req_u);
> @@ -659,10 +660,9 @@ static void prb_retire_rx_blk_timer_expired(struct timer_list *t)
>  	 *
>  	 */
>  	if (BLOCK_NUM_PKTS(pbd)) {
> -		while (atomic_read(&pkc->blk_fill_in_prog)) {
> -			/* Waiting for skb_copy_bits to finish... */
> -			cpu_relax();
> -		}
> +		/* Waiting for skb_copy_bits to finish... */
> +		write_lock(&pkc->blk_fill_in_prog_lock);
> +		write_unlock(&pkc->blk_fill_in_prog_lock);
>  	}
>  
>  	if (pkc->last_kactive_blk_num == pkc->kactive_blk_num) {
> @@ -921,10 +921,9 @@ static void prb_retire_current_block(struct tpacket_kbdq_core *pkc,
>  		 * the timer-handler already handled this case.
>  		 */
>  		if (!(status & TP_STATUS_BLK_TMO)) {
> -			while (atomic_read(&pkc->blk_fill_in_prog)) {
> -				/* Waiting for skb_copy_bits to finish... */
> -				cpu_relax();
> -			}
> +			/* Waiting for skb_copy_bits to finish... */
> +			write_lock(&pkc->blk_fill_in_prog_lock);
> +			write_unlock(&pkc->blk_fill_in_prog_lock);
>  		}
>  		prb_close_block(pkc, pbd, po, status);
>  		return;
> @@ -944,7 +943,8 @@ static int prb_queue_frozen(struct tpacket_kbdq_core *pkc)
>  static void prb_clear_blk_fill_status(struct packet_ring_buffer *rb)
>  {
>  	struct tpacket_kbdq_core *pkc  = GET_PBDQC_FROM_RB(rb);
> -	atomic_dec(&pkc->blk_fill_in_prog);
> +
> +	read_unlock(&pkc->blk_fill_in_prog_lock);
>  }
>  
>  static void prb_fill_rxhash(struct tpacket_kbdq_core *pkc,
> @@ -998,7 +998,7 @@ static void prb_fill_curr_block(char *curr,
>  	pkc->nxt_offset += TOTAL_PKT_LEN_INCL_ALIGN(len);
>  	BLOCK_LEN(pbd) += TOTAL_PKT_LEN_INCL_ALIGN(len);
>  	BLOCK_NUM_PKTS(pbd) += 1;
> -	atomic_inc(&pkc->blk_fill_in_prog);
> +	read_lock(&pkc->blk_fill_in_prog_lock);
>  	prb_run_all_ft_ops(pkc, ppd);
>  }
>  
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 907f4cd2a718..fd41ecb7f605 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -39,7 +39,7 @@ struct tpacket_kbdq_core {
>  	char		*nxt_offset;
>  	struct sk_buff	*skb;
>  
> -	atomic_t	blk_fill_in_prog;
> +	rwlock_t	blk_fill_in_prog_lock;
>  
>  	/* Default is set to 8ms */
>  #define DEFAULT_PRB_RETIRE_TOV	(8)

