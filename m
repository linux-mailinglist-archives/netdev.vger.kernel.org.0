Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF856273F5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 01:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiKNAzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 19:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKNAzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 19:55:17 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB80C75C;
        Sun, 13 Nov 2022 16:55:17 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id q186so10051097oia.9;
        Sun, 13 Nov 2022 16:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1eWmdrMuwMapU7AuwfWIBLQ5gu2VO9LXeJ1JQHUSa5M=;
        b=jHt37U4d8jNXsCEZDBNP9ic4j08D10mDXoZ6fXku34Z0l/o6Q8Zccryus5a1jbpq/7
         GQNEtEszyPRetKWerIMjfbcub5WrwHl/UljDLgXyjqrV/H+CCE2SaNfAD/+5TU5Fp+oo
         PB4ae29rRoL5oPx8vGJkSFCkG3Y7P/VetJi4gTAlvb+N6GmnQ9CYu5F11npG39s47bWH
         +DtncEopKarLmD1iUFPpVBnmAsPV39o2tJLuR1G5KkHhKWp3rcs6K1IZSTjo5s4co3V5
         AN6R3lCUFRVPpgih8Ne16BLIXCXyZJefIL8PhI/QIAHNXFWBZNkqt1kmaEx22z9d5PiX
         0FyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eWmdrMuwMapU7AuwfWIBLQ5gu2VO9LXeJ1JQHUSa5M=;
        b=tu0hoxLLZYUJbNutW/mAdQp82ul5CD75HvvxMxakR+jzQXy1e5n9YINdIhT0JszNAc
         xZMDaJcA9hEFhUXrBoNw36RmhLrIkILztrm7TTa3YNoQsOuPfcVahjP0WdAKnLfeTExA
         8ZNrM4+LZI3WRvpMQXcfcQpHObGUN9myU5dCTdk1sRWtHD+QMwMomWPZzYCJoDKrACAS
         7OUF2YS/Nk6Y5+RiqWzKypWWDtjsrjEjm+Ewx0XoH47cvmhmz/e1RbvwGC/tYwuAZHvj
         OAuAvMs6f1ikxoeKcXISz3WktFvvfzs6mmlT83TaHz4ssbTSDpqKqHX1UOsBRwv7Brgr
         Z3ag==
X-Gm-Message-State: ANoB5pnWrVvbeB72csE+YhxDurooAt9LBLJ7b8Bg5z/CsXMhom+zGd0g
        CM3XuWK/Ulg2rEtuhvxw/kI=
X-Google-Smtp-Source: AA0mqf4XNtLs/BAQMqK1H3kOnFuI5JppZu63jhYMwoT44oHPE/KFyzWr1o2CCKkzP9I/SNnpkIGcmQ==
X-Received: by 2002:aca:f089:0:b0:35a:e78c:8515 with SMTP id o131-20020acaf089000000b0035ae78c8515mr1562205oih.130.1668387316451;
        Sun, 13 Nov 2022 16:55:16 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:6343:42bb:5d9b:dded])
        by smtp.gmail.com with ESMTPSA id q5-20020a056870328500b0012763819bcasm4262716oac.50.2022.11.13.16.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 16:55:15 -0800 (PST)
Date:   Sun, 13 Nov 2022 16:55:15 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cong.wang@bytedance.com, f.fainelli@gmail.com,
        tom@herbertland.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] kcm: Fix kernel NULL pointer dereference in
 requeue_rx_msgs
Message-ID: <Y3GR89nyWvTwHulH@pop-os.localdomain>
References: <20221112120423.56132-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112120423.56132-1-wanghai38@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 08:04:23PM +0800, Wang Hai wrote:
> In kcm_rcv_strparser(), the skb is queued to the kcm that is currently
> being reserved, and if the queue is full, unreserve_rx_kcm() will be
> called. At this point, if KCM_RECV_DISABLE is set, then unreserve_rx_kcm()
> will requeue received messages for the current kcm socket to other kcm
> sockets. The kcm sock lock is not held during this time, and as long as
> someone calls kcm_recvmsg, it will concurrently unlink the same skb, which
> ill result in a null pointer reference.
> 
> cpu0 			cpu1		        cpu2
> kcm_rcv_strparser
>  reserve_rx_kcm
>                         kcm_setsockopt
>                          kcm_recv_disable
>                           kcm->rx_disabled = 1;
>   kcm_queue_rcv_skb
>   unreserve_rx_kcm
>    requeue_rx_msgs                              kcm_recvmsg
>     __skb_dequeue
>      __skb_unlink(skb)				  skb_unlink(skb)
>                                                   //double unlink skb
> 

We will hold skb queue lock after my patch, so this will not happen after
applying my patch below?
https://lore.kernel.org/netdev/20221114005119.597905-1-xiyou.wangcong@gmail.com/

Thanks.
