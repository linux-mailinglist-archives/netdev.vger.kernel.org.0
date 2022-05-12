Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EE95246C8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350838AbiELHVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350931AbiELHVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:21:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F12A61AD90
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652340062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7bOQidy2XKacFQoEFC88TIIvZuaoizz8bbPSOsrMVU=;
        b=efNDyvHsuWYCRwkqcw5i1p+edZkOtDnQ6xndvyRLBM+PDIhtTMaR/8mXvY653J2xqLXebs
        RtdBASBXBcD1knWLF/maDjYZfyko+OaxYtl6cRm8IvmIsK/4RWNydVykZsjxJRwgNU4LVR
        1gKDQF2jzoECNalHHH/g7m8LZKBfMbc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-R9FHAYJDMAyzgcpiYj_S2g-1; Thu, 12 May 2022 03:21:01 -0400
X-MC-Unique: R9FHAYJDMAyzgcpiYj_S2g-1
Received: by mail-wm1-f69.google.com with SMTP id p24-20020a1c5458000000b003945d2ffc6eso1288435wmi.5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=v7bOQidy2XKacFQoEFC88TIIvZuaoizz8bbPSOsrMVU=;
        b=3CVrWqb90sdnql/WkVGk18XY0PqOmjT5B2K1OvUwVGM1VXq8YdZb/W6fGcb6g9VnGB
         lmtcLjfpJMWQ1hMRPwBO5tvAYyVdhTMkSiVPv9eOuTvawrbmrH5sCKPN7zJxpQUqX9C/
         YuTguJEhddjYOg3hTg5V7ek4/0pkaUAtpNawYmIwhweTR7GRXeH/XwRCDKZVQ1ZcbIBj
         KsFeTDoZO/uBwzTGu37wrTYJ+bSvbIWFlCSnCQvtFX/u0wJLCFVQusc40Sv7of6UhtVc
         Gbf4fJCmQPmBwu/FC9z4bxb5258iL/TMHodSnJvGB6TIOfQPu6yfLD9Rc/2jh10lwaC2
         QKyQ==
X-Gm-Message-State: AOAM531LjKH9HvUHJv6O3RNQ/1pnXKqqXV9adcPwGpe93HYtaWwcgztQ
        ozGfcysMialn/xlkY5hVPIyKfb5uTTrP5PH+TUmV6qt/borWMgcKZFsSHTHF3JtkxaEIImf3Ic3
        zpC1AEdqXvKV2R2/p
X-Received: by 2002:a05:600c:4ba1:b0:394:9ae3:ee98 with SMTP id e33-20020a05600c4ba100b003949ae3ee98mr8594965wmp.160.1652340060399;
        Thu, 12 May 2022 00:21:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkID2x3/1z0/wYtZX175tGSUkmgETVETXT7EhcZbVjxfbCqFPAOMIbsG17vOktA4lTMY16mg==
X-Received: by 2002:a05:600c:4ba1:b0:394:9ae3:ee98 with SMTP id e33-20020a05600c4ba100b003949ae3ee98mr8594952wmp.160.1652340060137;
        Thu, 12 May 2022 00:21:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4bd0000000b0020c5253d8d8sm4000061wrt.36.2022.05.12.00.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:20:59 -0700 (PDT)
Message-ID: <87124d7a213f14eec98bbeb80836c20ea1a33352.camel@redhat.com>
Subject: Re: [PATCH v2] drivers: net: vmxnet3: fix possible use-after-free
 bugs in vmxnet3_rq_alloc_rx_buf()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zixuan Fu <r33s3n6@gmail.com>, doshir@vmware.com,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Date:   Thu, 12 May 2022 09:20:58 +0200
In-Reply-To: <20220510131716.929387-1-r33s3n6@gmail.com>
References: <20220510131716.929387-1-r33s3n6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-05-10 at 21:17 +0800, Zixuan Fu wrote:
> In vmxnet3_rq_alloc_rx_buf(), when dma_map_single() fails, rbi->skb is
> freed immediately. Similarly, in another branch, when dma_map_page() fails,
> rbi->page is also freed. In the two cases, vmxnet3_rq_alloc_rx_buf()
> returns an error to its callers vmxnet3_rq_init() -> vmxnet3_rq_init_all()
> -> vmxnet3_activate_dev(). Then vmxnet3_activate_dev() calls
> vmxnet3_rq_cleanup_all() in error handling code, and rbi->skb or rbi->page
> are freed again in vmxnet3_rq_cleanup_all(), causing use-after-free bugs.
> 
> To fix these possible bugs, rbi->skb and rbi->page should be cleared after
> they are freed.
> 
> The error log in our fault-injection testing is shown as follows:
> 
> [   14.319016] BUG: KASAN: use-after-free in consume_skb+0x2f/0x150
> ...
> [   14.321586] Call Trace:
> ...
> [   14.325357]  consume_skb+0x2f/0x150
> [   14.325671]  vmxnet3_rq_cleanup_all+0x33a/0x4e0 [vmxnet3]
> [   14.326150]  vmxnet3_activate_dev+0xb9d/0x2ca0 [vmxnet3]
> [   14.326616]  vmxnet3_open+0x387/0x470 [vmxnet3]
> ...
> [   14.361675] Allocated by task 351:
> ...
> [   14.362688]  __netdev_alloc_skb+0x1b3/0x6f0
> [   14.362960]  vmxnet3_rq_alloc_rx_buf+0x1b0/0x8d0 [vmxnet3]
> [   14.363317]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
> [   14.363661]  vmxnet3_open+0x387/0x470 [vmxnet3]
> ...
> [   14.367309] 
> [   14.367412] Freed by task 351:
> ...
> [   14.368932]  __dev_kfree_skb_any+0xd2/0xe0
> [   14.369193]  vmxnet3_rq_alloc_rx_buf+0x71e/0x8d0 [vmxnet3]
> [   14.369544]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
> [   14.369883]  vmxnet3_open+0x387/0x470 [vmxnet3]
> [   14.370174]  __dev_open+0x28a/0x420
> [   14.370399]  __dev_change_flags+0x192/0x590
> [   14.370667]  dev_change_flags+0x7a/0x180
> [   14.370919]  do_setlink+0xb28/0x3570
> [   14.371150]  rtnl_newlink+0x1160/0x1740
> [   14.371399]  rtnetlink_rcv_msg+0x5bf/0xa50
> [   14.371661]  netlink_rcv_skb+0x1cd/0x3e0
> [   14.371913]  netlink_unicast+0x5dc/0x840
> [   14.372169]  netlink_sendmsg+0x856/0xc40
> [   14.372420]  ____sys_sendmsg+0x8a7/0x8d0
> [   14.372673]  __sys_sendmsg+0x1c2/0x270
> [   14.372914]  do_syscall_64+0x41/0x90
> [   14.373145]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> ...
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>

This looks like targeting the 'net' tree. You should specify that in
the patch subj. More importantly you should provide a 'Fixes' tag
pointing to commit introducing the issue.

Please provide a new version addressing the above.

Thanks,

Paolo

