Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E414B5F03
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbiBOAY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:24:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiBOAYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:24:51 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC44140C1F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:24:43 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id b35so15914603qkp.6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 16:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GujBXUvXi+0yeSrz79gsYrhquGzZSm1r2EHDrdrY/wg=;
        b=BUKhOEiVIe/ExiWuFzr64XnbbqhpNlfHtsJYo5bS1aqXgxs7qrffvzdcMLurb0lrTG
         l4qFZmrBgLLfVsWnsE94OGQTvFKaCRGzrl4VPDVvnTExzL4Fr3p71FJtJntnmJJylEaX
         9xiNe86SzvqI2+Kar+EYyJrmL5u7QphK3NmU2AcYjuzLms5iRzbAJgV4u0TydyFi7eX2
         OBGuf1KHdxwN2whKZj5iWEC61LBgc8m5dzZlz50P34O0RauSnwSCQakMgHZ/a5tiqyB6
         0W2VpnBtXvdKwjVDiI33KKjkLyFtK2KHTL8BqWk15F9KRN4UlQnM4PjOaWLMz2ewJyYc
         aP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GujBXUvXi+0yeSrz79gsYrhquGzZSm1r2EHDrdrY/wg=;
        b=nYLGLtaVAoED25FiCS9nTnhWARYeXuGjn0jUxsM8BVObQPcp/FPytd7Jd3ml3eeR5X
         IgzRxsyGB3Q6cgmLry4yScm9xa4EPyPSJca/Cd7VwW1pw/kYHuMixLVAZf1h+/qP8bTS
         JwQ+u3nYgHPTR/3I3U+aYCww3a6PTVfHeenNCdZhFAoW93TqQ1nXJBVkO34TLuKUEM8w
         Q0zn4RzyXarC7SRePSaS0hp1idloteaN3BgKNOLKGWeGCsdm0Vx65yYPymX3pXD9ttKK
         s7hHmH43/b6gqaimiWrB9hqCqQk85F1/OUKL4BFUnw1Ljsii6n94vF+SgEwhIlRc9+9I
         YsLg==
X-Gm-Message-State: AOAM531le9zDSYzIMFjs4lqWQRaTGlb0pyjaPqG57WYQ6hWKeTX8pWjI
        qFtrobul9nIFy3IjNl9qUS4=
X-Google-Smtp-Source: ABdhPJySTir/8tL/gaw0CAwuUB0p5k2xnwGzY3Mr/vwpW5Pa0IyPHp33WaxQBEhMrhy1tYLKvPp3nA==
X-Received: by 2002:a05:620a:430e:: with SMTP id u14mr852167qko.561.1644884682272;
        Mon, 14 Feb 2022 16:24:42 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:1336:e323:f59d:db64])
        by smtp.gmail.com with ESMTPSA id p6sm6271517qkg.33.2022.02.14.16.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:24:41 -0800 (PST)
Date:   Mon, 14 Feb 2022 16:24:40 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ipmr,ip6mr: acquire RTNL before calling
 ip[6]mr_free_table() on failure path
Message-ID: <YgryyOR3PaTztFn8@pop-os.localdomain>
References: <20220208053451.2885398-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208053451.2885398-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 09:34:51PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ip[6]mr_free_table() can only be called under RTNL lock.
> 
> RTNL: assertion failed at net/core/dev.c (10367)
> WARNING: CPU: 1 PID: 5890 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> Modules linked in:
> CPU: 1 PID: 5890 Comm: syz-executor.2 Not tainted 5.16.0-syzkaller-11627-g422ee58dc0ef #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
> Code: 0f 85 9b ee ff ff e8 69 07 4b fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 6d b1 51 06 01 e8 8c 90 d8 01 <0f> 0b e9 70 ee ff ff e8 3e 07 4b fa 4c 89 e7 e8 86 2a 59 fa e9 ee
> RSP: 0018:ffffc900046ff6e0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888050f51d00 RSI: ffffffff815fa008 RDI: fffff520008dfece
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815f3d6e R11: 0000000000000000 R12: 00000000fffffff4
> R13: dffffc0000000000 R14: ffffc900046ff750 R15: ffff88807b7dc000
> FS:  00007f4ab736e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fee0b4f8990 CR3: 000000001e7d2000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
>  ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
>  ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
>  ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]

Isn't that new table still empty in this case? Which means
mroute_clean_tables() should not actually unregister any netdevice??

Should we just move that assertion after list empty check?


diff --git a/net/core/dev.c b/net/core/dev.c
index 909fb3815910..ff6e7d0074dd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10359,11 +10359,11 @@ void unregister_netdevice_many(struct list_head *head)
        LIST_HEAD(close_head);
 
        BUG_ON(dev_boot_phase);
-       ASSERT_RTNL();
 
        if (list_empty(head))
                return;
 
+       ASSERT_RTNL();
        list_for_each_entry_safe(dev, tmp, head, unreg_list) {
                /* Some devices call without registering
                 * for initialization unwind. Remove those

