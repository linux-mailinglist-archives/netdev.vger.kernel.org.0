Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CCE5FD82A
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 13:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJMLOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 07:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJMLOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 07:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF7411E45F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 04:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665659642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0LAjwgA0XZeBfWhzlIAshT4AZH7LDCaXnYz2n0mURM=;
        b=Dx/q4SeEtmMiqpJxZAe7nZsOfYqEjLlrh2FjtakbLib8kDinLgdUohHpZWdN4Ici3Fd5Py
        SYOOil47zD8YKMlB2KNiogTY1QPVw639VCZQkItvLzRaSAvQLW582/RUSFpyb4rzB6nIpR
        4kAlPJlbK/juFHKu7XiInX6bv2Ku+CY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-IKKLOVBqMU-hDQEz1tZhMA-1; Thu, 13 Oct 2022 07:14:01 -0400
X-MC-Unique: IKKLOVBqMU-hDQEz1tZhMA-1
Received: by mail-wm1-f72.google.com with SMTP id b7-20020a05600c4e0700b003bde2d860d1so980277wmq.8
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 04:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l0LAjwgA0XZeBfWhzlIAshT4AZH7LDCaXnYz2n0mURM=;
        b=cXpx4STbsXRjk7Bue8zGSY2QfvXbs0vopVDqcdv+QkBC055OHHl0XuAcyazOOXXklJ
         sdSJXHXiPopjWga/U6EM1sKdp2m4l/T4p4qQyRQUxW8D3h7k+Rk2FWs3irgBmhdqSpq+
         o3ytUp9nI/4Y4HT+66dcAzeTwZZMbt45bkjp7deVfRTSNi/gA7h0uI4mWNTFxZG1iqaw
         B8m4711VDbX78ad4XhSo4nrQqpiepgNG1aNvuTrpIMthKqzfJuotawEgz3t+UlFdOTMo
         e2sPeuDJ+jiBxAbEFryWl8qHlOAEmEqvMZp4X8weZ7NO8WUwuS/pC9vQSNgYs5rDzfDV
         g1cw==
X-Gm-Message-State: ACrzQf2JK5DM/dSy3zw6FHXx8Db+2ld5SqbMhCkf2geOALyX2iXjUyzP
        2rXazsl33YLtpxGztG78NxbngOVQquWFND3K+EfWRkQmeX8+EYzrptVZZXb/JOg4U87i/aCx04D
        kSt8r6iCh5l/EwH/o
X-Received: by 2002:a05:600c:314f:b0:3c6:d2b5:d2c6 with SMTP id h15-20020a05600c314f00b003c6d2b5d2c6mr5175756wmo.20.1665659640342;
        Thu, 13 Oct 2022 04:14:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5LtJIVDgHUNQK0c41ZialopZJJZinMpAw5lOSTzEC/Q9zajgSUY5xtUo1PKc7UR7+kKZkx1w==
X-Received: by 2002:a05:600c:314f:b0:3c6:d2b5:d2c6 with SMTP id h15-20020a05600c314f00b003c6d2b5d2c6mr5175746wmo.20.1665659640152;
        Thu, 13 Oct 2022 04:14:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id c15-20020adfa30f000000b00228d52b935asm1868760wrb.71.2022.10.13.04.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 04:13:59 -0700 (PDT)
Message-ID: <45b601aebda1225b38b62c95b2c12e0fce76ee80.camel@redhat.com>
Subject: Re: net/kcm: syz issue about general protection fault in skb_unlink
From:   Paolo Abeni <pabeni@redhat.com>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, edumazet@google.com,
        sgarzare@redhat.com, ast@kernel.org, nikolay@nvidia.com,
        mkl@pengutronix.de, cong.wang@bytedance.com
Date:   Thu, 13 Oct 2022 13:13:58 +0200
In-Reply-To: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
References: <fef5174d-2109-37e9-8c46-2626b3310c5e@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-13 at 18:51 +0800, shaozhengchao wrote:
> I found that the syz issue("general protection fault in skb_unlink")
> still happen in Linux -next branch.
> commit: 082fce125e57cff60687181c97f3a8ee620c38f5
> Link: 
> https://groups.google.com/g/syzkaller-bugs/c/ZfR2B5KaQrA/m/QfnGHCYSBwAJ
> Please ask:
> Is there any problem with this patch? Why is this patch not merged into
> the Linux -next branch or mainline?

I never submitted the patch formally. So much time has passed that I
don't recall exactly why. Possibly the patch fell outside my radar
after hitting a syzkaller infrastructure issue. 

Apart from that, the patch is quite invasinve, especially for a
subsystem with no selftest and that I don't know particularly well. 

As a possible option I can try to post it for net-next, when it will
re-open - assuming there is agreement on that.

Cheers,

Paolo


