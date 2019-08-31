Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D54A446C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfHaMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 08:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfHaMUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 08:20:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFE3217D7;
        Sat, 31 Aug 2019 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567254037;
        bh=R7PKgZVs8LZzromlzQuOL+4NGSAf6K0NPvomYelKhWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JzwxQdwoqm28OGFuYSk9PzJy6XDBQl7LLNyw7VA+nqT+aEYytrvjkkm1IThIamprD
         H4gQ6SFcvObpzYhtyFkB1XWjajELA3D8bwr+mOmQOqElCajQUdsj7UmSuNTDBrvwJK
         REMMN4dDDQaPm94AIOakXwriHqHFmi9HvsNjabJ4=
Date:   Sat, 31 Aug 2019 08:20:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tim Froidcoeur <tim.froidcoeur@tessares.net>
Cc:     matthieu.baerts@tessares.net, aprout@ll.mit.edu, cpaasch@apple.com,
        davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, jonathan.lemon@gmail.com,
        jtl@netflix.com, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, stable@vger.kernel.org, ycheng@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Message-ID: <20190831122036.GY5281@sasha-vm>
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
 <20190824060351.3776-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 08:03:51AM +0200, Tim Froidcoeur wrote:
>Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
>triggers following stack trace:
>
>[25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
>[25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
>[25244.888167] Call Trace:
>[25244.889182]  <IRQ>
>[25244.890001]  tcp_fragment+0x9c/0x2cf
>[25244.891295]  tcp_write_xmit+0x68f/0x988
>[25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
>[25244.894347]  tcp_data_snd_check+0x2a/0xc8
>[25244.895775]  tcp_rcv_established+0x2a8/0x30d
>[25244.897282]  tcp_v4_do_rcv+0xb2/0x158
>[25244.898666]  tcp_v4_rcv+0x692/0x956
>[25244.899959]  ip_local_deliver_finish+0xeb/0x169
>[25244.901547]  __netif_receive_skb_core+0x51c/0x582
>[25244.903193]  ? inet_gro_receive+0x239/0x247
>[25244.904756]  netif_receive_skb_internal+0xab/0xc6
>[25244.906395]  napi_gro_receive+0x8a/0xc0
>[25244.907760]  receive_buf+0x9a1/0x9cd
>[25244.909160]  ? load_balance+0x17a/0x7b7
>[25244.910536]  ? vring_unmap_one+0x18/0x61
>[25244.911932]  ? detach_buf+0x60/0xfa
>[25244.913234]  virtnet_poll+0x128/0x1e1
>[25244.914607]  net_rx_action+0x12a/0x2b1
>[25244.915953]  __do_softirq+0x11c/0x26b
>[25244.917269]  ? handle_irq_event+0x44/0x56
>[25244.918695]  irq_exit+0x61/0xa0
>[25244.919947]  do_IRQ+0x9d/0xbb
>[25244.921065]  common_interrupt+0x85/0x85
>[25244.922479]  </IRQ>
>
>tcp_rtx_queue_tail() (called by tcp_fragment()) can call
>tcp_write_queue_prev() on the first packet in the queue, which will trigger
>the BUG in tcp_write_queue_prev(), because there is no previous packet.
>
>This happens when the retransmit queue is empty, for example in case of a
>zero window.
>
>Patch is needed for 4.4, 4.9 and 4.14 stable branches.

There needs to be a better explanation of why it's not needed
upstream...

--
Thanks,
Sasha
