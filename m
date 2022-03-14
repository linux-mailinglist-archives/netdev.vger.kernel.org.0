Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402214D7FE6
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiCNKdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbiCNKdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C55943AD4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647253952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6/TfSYqkkls5Ak0b7X6zyG5RKMJ+ZqYiNKkufaHrs0=;
        b=c9WVAHQco+V/soQyuWrfPBD3JO4hbIEN7tiyUGKK6a+M01jpeqx7/EinoBT96FQWq4mQrZ
        mRQkwf7uycuJeTbUPUZy0HTsA5gLZtp53FS3FvN5ZSfneQn2/kgyxVTKoUvThIjI83FVdC
        gC/h/QsYUIb0PodRTfdb8SfLHS65uHg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-Z1LACBJwNhyTNigFP10SBw-1; Mon, 14 Mar 2022 06:32:31 -0400
X-MC-Unique: Z1LACBJwNhyTNigFP10SBw-1
Received: by mail-wm1-f69.google.com with SMTP id f24-20020a1c6a18000000b00388874b17a8so6869167wmc.3
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b6/TfSYqkkls5Ak0b7X6zyG5RKMJ+ZqYiNKkufaHrs0=;
        b=H2kfpSt/LFGWpSi0UlJaMykzU2Z5tY9Opsqb6vNFaRnPi2jzRZi8j2fsRzjUa9OwQK
         /vEx9aEqBesF3ly+rBpWv0j0BJoEDhljBCV7cRQOeBHWA4t0BpWWBbJTYX3FmxqsgjlT
         WIovXVen5tRAFMPeMsGTkQiMSTcQNomVumt5vBib9YrBhoJzOoZ895tjtOcDTMsuU6Ao
         kuUia/MqGK5QvCeO/vsW4QnFR3eCwxasxbyYnfB8Z9FAOuzFoaUOIuA3wT1ynD1mmaK1
         qDu7jl9h36R22IwPUy0vMTUAhgXIruIHkVPKNT706d3TpPbpGknBheyOm2dHmwY4G+d8
         1Dhw==
X-Gm-Message-State: AOAM531l7A4uqLi8ZdCEBmKXMfGe+a6h5+jetZMXUkvbk2HYPOnGZIWv
        7Zt1Z2rFbwl90GtXE8afJIJyQuogtIEjGOuKbpB/l9n0PmaQ80Yi/2KsxvSG0VXumDKnhezXXz8
        JkGpvLYwmrzFI79Y3
X-Received: by 2002:a5d:6c6f:0:b0:203:7796:2d4 with SMTP id r15-20020a5d6c6f000000b00203779602d4mr16665701wrz.393.1647253949608;
        Mon, 14 Mar 2022 03:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMvcN/lkU2I+fbao9oc/aMjldnALvYq2fM/lv82Ihj0ipSdxVnUwKw1TqRSDpDCpkx/CGgzA==
X-Received: by 2002:a5d:6c6f:0:b0:203:7796:2d4 with SMTP id r15-20020a5d6c6f000000b00203779602d4mr16665674wrz.393.1647253949341;
        Mon, 14 Mar 2022 03:32:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id r5-20020a5d4945000000b001f06372fa9fsm20825035wrs.54.2022.03.14.03.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 03:32:28 -0700 (PDT)
Message-ID: <fb659a9e1a6150cc0041d634dfce65ecf46d8660.camel@redhat.com>
Subject: Re: [PATCH net-next] net: disable preemption in
 dev_core_stats_XXX_inc() helpers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Date:   Mon, 14 Mar 2022 11:32:27 +0100
In-Reply-To: <20220312214505.3294762-1-eric.dumazet@gmail.com>
References: <20220312214505.3294762-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-03-12 at 13:45 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot was kind enough to remind us that dev->{tx_dropped|rx_dropped}
> could be increased in process context.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor413/3593
> caller is netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
> CPU: 1 PID: 3593 Comm: syz-executor413 Not tainted 5.17.0-rc7-syzkaller-02426-g97aeb877de7f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  check_preemption_disabled+0x16b/0x170 lib/smp_processor_id.c:49
>  netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
>  dev_core_stats include/linux/netdevice.h:3855 [inline]
>  dev_core_stats_rx_dropped_inc include/linux/netdevice.h:3866 [inline]
>  tun_get_user+0x3455/0x3ab0 drivers/net/tun.c:1800
>  tun_chr_write_iter+0xe1/0x200 drivers/net/tun.c:2015
>  call_write_iter include/linux/fs.h:2074 [inline]
>  new_sync_write+0x431/0x660 fs/read_write.c:503
>  vfs_write+0x7cd/0xae0 fs/read_write.c:590
>  ksys_write+0x12d/0x250 fs/read_write.c:643
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f2cf4f887e3
> Code: 5d 41 5c 41 5d 41 5e e9 9b fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> RSP: 002b:00007ffd50dd5fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007ffd50dd6000 RCX: 00007f2cf4f887e3
> RDX: 000000000000002a RSI: 0000000000000000 RDI: 00000000000000c8
> RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd50dd5ff0 R14: 00007ffd50dd5fe8 R15: 00007ffd50dd5fe4
>  </TASK>
> 
> Fixes: 625788b58445 ("net: add per-cpu storage and net->core_stats")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: jeffreyji <jeffreyji@google.com>
> Cc: Brian Vazquez <brianvv@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/netdevice.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 0d994710b3352395b8c6d6fd53affb2fe0cea39f..8cbe96ce0a2cd9e4f02168835d460d1c91901430 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3858,10 +3858,14 @@ static inline struct net_device_core_stats *dev_core_stats(struct net_device *de
>  #define DEV_CORE_STATS_INC(FIELD)						\
>  static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
>  {										\
> -	struct net_device_core_stats *p = dev_core_stats(dev);			\
> +	struct net_device_core_stats *p;					\
> +										\
> +	preempt_disable();							\
> +	p = dev_core_stats(dev);						\
>  										\
>  	if (p)									\
>  		local_inc(&p->FIELD);						\
> +	preempt_enable();							\
>  }
>  DEV_CORE_STATS_INC(rx_dropped)
>  DEV_CORE_STATS_INC(tx_dropped)

LGTM, thanks Eric!

Acked-by: Paolo Abeni <pabeni@redhat.com>

