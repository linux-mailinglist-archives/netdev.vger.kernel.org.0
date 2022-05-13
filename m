Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEAA5262F5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380659AbiEMNXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 09:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346448AbiEMNXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 09:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1AE566CB9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652448214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iisd9q2NnwATRjWoBLNVvckMIlB3CVM0go/7xFp8Gmk=;
        b=F4GXvgV2vr+Z+5nWeZDxLpy11h+cP5DfDgRF1z4mXmfUfzM6TUU+IMDR4UitnEX3nYOASv
        OZiCS+5KR1YHDQ7x2/SOXaVTv2huZtoWphF8zHMFf0uYBpqZNLJnDdoieiqtRGVs8fLnX0
        hSNugYs8Ni7cIOJVvRytuBkfeEatdZM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-vnFfHLB8Me-yyF2KRBZkIA-1; Fri, 13 May 2022 09:23:33 -0400
X-MC-Unique: vnFfHLB8Me-yyF2KRBZkIA-1
Received: by mail-qt1-f197.google.com with SMTP id b20-20020ac85bd4000000b002f3bb93df03so6267749qtb.16
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iisd9q2NnwATRjWoBLNVvckMIlB3CVM0go/7xFp8Gmk=;
        b=7HhGIdUACPS3JxB/+VFG0xvmujstzAYYmYH5HC6m458ge7tuQy4ujWnRTNdxdmP6q6
         x+amJeND3JnUkeVhxltL2cd0HGc3mw4FrzgnkYsIyJFWTEnTvnDP8fE3bB1Bvq6/UmqF
         W7CRYY1xQxPQwlwAvNkPH+CUDPL0T22V7MOdkyOy1KFY0PK+q3CxProRL9xZJuanMLI9
         Kx/ul2YMX2x+D9clw0d/UQS7YEHeaVdN4ENcgCXT61U6koVKsy6wOkSjgsvN2b6p74Ug
         /51PZjf6cgy6R5EtrxtMoa1N6NIhhcL66ox1kIOh/0y3L6xrCxMe8zqphNNfaDpVwtKv
         8KhA==
X-Gm-Message-State: AOAM531pNbbClDkiVwSZdjwvsA9aB8UTdHHqWbUNPddb8a/LvrQMfo3C
        OkNwh9V+toQH6rLn1OOyzxp30yuUw8oHo/ChbwHrKQMXEz94E9y55r8eYjsvZMvXYpcpzn+Xxp2
        +x2MlxH/mEIvheNWF
X-Received: by 2002:a05:622a:494:b0:2f3:c0b0:599c with SMTP id p20-20020a05622a049400b002f3c0b0599cmr4529298qtx.95.1652448213277;
        Fri, 13 May 2022 06:23:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGiO9n+5iPCv+NJsLCllyAa9EHW1ILwmpHsC5hfvksbz5U9ndISSgoRwBbHeIuZvddpgtoug==
X-Received: by 2002:a05:622a:494:b0:2f3:c0b0:599c with SMTP id p20-20020a05622a049400b002f3c0b0599cmr4529278qtx.95.1652448213068;
        Fri, 13 May 2022 06:23:33 -0700 (PDT)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a167300b0069fc13ce250sm1333029qko.129.2022.05.13.06.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 06:23:32 -0700 (PDT)
Message-ID: <4e8f5bc4-4322-a0b3-35d9-bfd6c42696a2@redhat.com>
Date:   Fri, 13 May 2022 09:23:30 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220513103350.384771-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/22 06:33, Hangbin Liu wrote:
> When removing the rcu_read_lock in bond_ethtool_get_ts_info(), I didn't
> notice it could be called via setsockopt, which doesn't hold rcu lock,
> as syzbot pointed:
> 
>    stack backtrace:
>    CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>    Call Trace:
>     <TASK>
>     __dump_stack lib/dump_stack.c:88 [inline]
>     dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>     bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
>     bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
>     __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
>     ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
>     sock_timestamping_bind_phc net/core/sock.c:869 [inline]
>     sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
>     sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
>     __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
>     __do_sys_setsockopt net/socket.c:2238 [inline]
>     __se_sys_setsockopt net/socket.c:2235 [inline]
>     __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>    RIP: 0033:0x7f8902c8eb39
> 
> Fix it by adding rcu_read_lock during the whole slave dev get_ts_info period.
> 
> Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
> Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>

