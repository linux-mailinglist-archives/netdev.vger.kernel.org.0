Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73649C0A3
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfHXWFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:05:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41187 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfHXWFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 18:05:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so7764202pls.8;
        Sat, 24 Aug 2019 15:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=+GV4BcDpMPwMrWAL+/wgxfMaDv3Pfp4zeDsXA2CoPpk=;
        b=QmblOeXqbhHNcdlu7I3jpi2b+kboYgkx8hD/dzNwI6jRefw1FfDG8rx0Owp+NZLbeC
         3F2nYSIqSlHHEtjglnjJyYF6i0ykMy08V8NDNJw2rWLRQ3Tb7gZcyxKP6wltqeQWGaxW
         7ZKst1tfwuAJkZGKCIpV9fKc31aa2VMO4JbskvaAstXGEbKAgMGOmaS+B0lr3KZRMzKB
         /Hk3g1l6XVdwaQsAdvXx+J2BZhVpWiBtuDVCqNaze/ktg9SBRh58V6sG/XXVbL6cXObp
         JJ8Q3SBR8PE3iev2romC5u0i1r2Eu/d40mvah2NKfVJ+ctiVYOD+xmSV3YKRzeDqQFOx
         6teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=+GV4BcDpMPwMrWAL+/wgxfMaDv3Pfp4zeDsXA2CoPpk=;
        b=S3F8sni4UlNK01EDZxQZOUrTBq70uO7chNAZu4tuuYjyDUeSJFdnz5JEDuzH9YiZiH
         qCse7FLnElTrPTkse75M6IZsFSKWUNNzrJ4Rb9sWlQW5denFolgvNQi/VG+Ju++BGeAW
         HL5l3dqlgRHN+P7SNMQwGNVvoWxOBPdTNWX9/nSJ87WVwyywuiDJKzBoQzwwwyYJ4psU
         13gXv5xx2ODa5X9/cRznEtM/30ij6T6ojJ16NKrIteuBLRQxdFKIA5qp2BrViusWXSW3
         NxyKMWGD2+3DAai30TtLUDHoOxLQoDvmLrvRNzA6BoDkGzn1mq0G0og1pLAxXlhPHrR9
         R3ww==
X-Gm-Message-State: APjAAAWxu+mjN9sXgSYiIVtu5GyCC48E2A6SgxrUuV3DhPqk+SDs6akd
        hC50EMg0OF/T6lGgufgeNac=
X-Google-Smtp-Source: APXvYqxcWGsIxD+Fi4K9kDV0mqK+B/MmijIeDAiHoAsy29YIUjcUqFTQR6sLmmyd4N/nnYmH+Gkf2Q==
X-Received: by 2002:a17:902:7442:: with SMTP id e2mr10510884plt.315.1566684322882;
        Sat, 24 Aug 2019 15:05:22 -0700 (PDT)
Received: from [172.26.127.117] ([2620:10d:c090:180::4714])
        by smtp.gmail.com with ESMTPSA id d3sm6997751pjz.31.2019.08.24.15.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Aug 2019 15:05:22 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Tim Froidcoeur" <tim.froidcoeur@tessares.net>
Cc:     matthieu.baerts@tessares.net, aprout@ll.mit.edu, cpaasch@apple.com,
        davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, jtl@netflix.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, sashal@kernel.org, stable@vger.kernel.org,
        ycheng@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Date:   Sat, 24 Aug 2019 15:05:20 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
In-Reply-To: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
 <20190824060351.3776-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Aug 2019, at 23:03, Tim Froidcoeur wrote:

> Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> triggers following stack trace:
>
> [25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
> [25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
> [25244.888167] Call Trace:
> [25244.889182]  <IRQ>
> [25244.890001]  tcp_fragment+0x9c/0x2cf
> [25244.891295]  tcp_write_xmit+0x68f/0x988
> [25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
> [25244.894347]  tcp_data_snd_check+0x2a/0xc8
> [25244.895775]  tcp_rcv_established+0x2a8/0x30d
> [25244.897282]  tcp_v4_do_rcv+0xb2/0x158
> [25244.898666]  tcp_v4_rcv+0x692/0x956
> [25244.899959]  ip_local_deliver_finish+0xeb/0x169
> [25244.901547]  __netif_receive_skb_core+0x51c/0x582
> [25244.903193]  ? inet_gro_receive+0x239/0x247
> [25244.904756]  netif_receive_skb_internal+0xab/0xc6
> [25244.906395]  napi_gro_receive+0x8a/0xc0
> [25244.907760]  receive_buf+0x9a1/0x9cd
> [25244.909160]  ? load_balance+0x17a/0x7b7
> [25244.910536]  ? vring_unmap_one+0x18/0x61
> [25244.911932]  ? detach_buf+0x60/0xfa
> [25244.913234]  virtnet_poll+0x128/0x1e1
> [25244.914607]  net_rx_action+0x12a/0x2b1
> [25244.915953]  __do_softirq+0x11c/0x26b
> [25244.917269]  ? handle_irq_event+0x44/0x56
> [25244.918695]  irq_exit+0x61/0xa0
> [25244.919947]  do_IRQ+0x9d/0xbb
> [25244.921065]  common_interrupt+0x85/0x85
> [25244.922479]  </IRQ>
>
> tcp_rtx_queue_tail() (called by tcp_fragment()) can call
> tcp_write_queue_prev() on the first packet in the queue, which will trigger
> the BUG in tcp_write_queue_prev(), because there is no previous packet.
>
> This happens when the retransmit queue is empty, for example in case of a
> zero window.
>
> Patch is needed for 4.4, 4.9 and 4.14 stable branches.
>
> Fixes: 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
> Change-Id: I839bde7167ae59e2f7d916c913507372445765c5
> Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Reviewed-by: Christoph Paasch <cpaasch@apple.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
