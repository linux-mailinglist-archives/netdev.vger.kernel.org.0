Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46EF3EAABB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhHLTR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhHLTRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:17:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93924C061756;
        Thu, 12 Aug 2021 12:17:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso12334261pjy.5;
        Thu, 12 Aug 2021 12:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Swd4Qb0LB2gTSkGGkD/oyA9lgEK689TaeHzpVlWAOxs=;
        b=R3GMMo6DOaRMP1S/Sg8zqd2DyQ7n28u+R11cM1SCrFSkKO9S35XvkiVGoNXWxuA018
         HACPnb/yyQleUMjJeyyMWFpOa9TSSYQAIFgkSBoYFU4fiIhyaSVapMs/YL8FH/3g6Y6p
         RcfxdsZUZAXYJxVUHU3o5+y0laSFE7L5kGer00ByYRhZTgcQ8mvyuJ9GMGtgsf9l25aF
         J7DxtDYSEXONUCijrmatj6rzA+YltW6Ag9gOJFYBBwaO5V8EOqr9TjxhLdW1AsF1QMSq
         cYyGgNJBIuXaCNdfEJW0JY1bjhBav0HrxbErGvYDHe7Q5TevYjIneaYcWIqD+ack2o7I
         gjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Swd4Qb0LB2gTSkGGkD/oyA9lgEK689TaeHzpVlWAOxs=;
        b=SGkfMSUtNXQ17w1uNz1MEMJyTG2lhiP4CY1TlKHXYq+v/OXT+rNbpwbmdHe0BIqDaR
         owuYfURrV5r//ESbmCTmL+PNKIxhqr7L82kmothrq98KDtG+xvExNyQrSdroDJVTfohM
         kvM3ZI97yz+YBvGP/pdmgAXWtkfpohFRS8NEiA10/vgazFfNYs6gWfa0hIkUnenREj9b
         jgxG3U+98iyL+xv8sU7BtVFz7Dqt+YVYvYCUqMi+yYeKG66Vex3wjPoNeRUORyxcCOME
         ceNp/W8V6g+/x5fcMA3RVGSg0s8aYlEVg+L1AmpzCDGYeiKd1c8qA/FO5jN106BZ42CJ
         ql9w==
X-Gm-Message-State: AOAM530M/rIzofN9sfdEvNNgPaJsX9WQljd6acQrj+dOIDTebUBhUoHa
        kCaGm+f0/Ne3cAc7BxzpIw0=
X-Google-Smtp-Source: ABdhPJw8G2L5h5WAqtC9ejHViYetlM+iE1PMgY21/PqVy2uSp7qAQRAiJYDBaJp4/CvGHFr7w1tfkA==
X-Received: by 2002:a17:90a:2fc2:: with SMTP id n2mr5503399pjm.112.1628795845101;
        Thu, 12 Aug 2021 12:17:25 -0700 (PDT)
Received: from [192.168.1.38] (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id c23sm4873686pgb.74.2021.08.12.12.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 12:17:24 -0700 (PDT)
Subject: Re: [PATCH] net: drop skbs in napi->rx_list when removing the napi
 context.
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        memxor@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com
References: <20210811235959.1099333-1-phind.uet@gmail.com>
 <CANn89iLQj4Xm-6Bcygtkd5QqDzmJBDALznL8mEJrF1Fh_W32iQ@mail.gmail.com>
From:   Phi Nguyen <phind.uet@gmail.com>
Message-ID: <663ac8c4-b0c3-5af6-c3c3-f371e0410a43@gmail.com>
Date:   Fri, 13 Aug 2021 03:17:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLQj4Xm-6Bcygtkd5QqDzmJBDALznL8mEJrF1Fh_W32iQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/2021 3:07 PM, Eric Dumazet wrote:
> Also I object to this fix.
> 
> If packets have been stored temporarily in GRO, they should be
> released at some point,
> normally at the end of a napi poll.
> 
> By released, I mean that these packets should reach the upper stack,
> instead of being dropped without
> any notification.
> 
> It seems a call to gro_normal_list() is missing somewhere.
> 
> Can you find where ?
> 
> Thanks !
> H Eric,

I think the location that should have a call to gro_normal_list() is 
__netif_napi_del(). Let say, if the driver call a function that lead to 
gro_normal_one(), and add a skb to the rx_list while the napi poll is 
not scheduled, and the driver remove the napi context before a napi poll 
could be triggered, then the added skb will be lost.

Actually, this was the first solution that I tried with syzbot (It 
passed the test too).
Best regards,
Phi
