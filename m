Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58D16907CB
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBILwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBILvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:51:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B11110278
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:38:14 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z1so2495705plg.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 03:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcvF+YkgtZm0aVCeEZwRHJzUx+YienSWl4WnAZ6tpL4=;
        b=aVLa1xvxSpyqYA8JHs5ZdPdBawVQKMkk200X5k14p3UrGCbytAZ95yKGMFMx7/EwgH
         H72WgG4HRkgHTeOcBhQYiP+39624VivC9qSRLChkdeKYhM6F6K8NK/Ebps0r7uPWeIpu
         f7vRdkwheCU5uuayTD/LP+laOiUZQpv4jBpb1On9chIIHzbE4bY1l9QJOsl6vJfpTHf5
         OhbPd3RjZ5y75CivfeKL8XzTW+M8oEW4oeB34z7VkHPzTLkOqD7+SieSDbS2NNFcxsqX
         cLHGRzwyPaUZhyNYPa6YutyVyXX7v65ry9eyO9rPua9zrwUAE9hnB7/OuLGbnRyd00PI
         SSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcvF+YkgtZm0aVCeEZwRHJzUx+YienSWl4WnAZ6tpL4=;
        b=xIBezvf4OJV3ZiCqMe6AsWuvkvcIFMXZp2+LBeBg+E9sR2Q8ED5wMPVhtTXgeIc16q
         krnJHULWzt2wXnHnmAq1W8KTFUC9QAXvoo7/w7rDF0ZNrjwx1UeZFX77AHEUoU223QaK
         XFUPQBCn8ENArisAdvZa6HH1y/2zb9M7/5M+28dtKRhFDt1v4FUWtka8js0ar0eSWAoa
         6DzgaxCtiMo5vD/7S2kRmYQfUyc3LXH42cNvTtToC475vnKy9fS8fIZVFErK0hRamh5V
         Q5cLjcV4q5m3VLC16DqvZy1FJhh8pK+ypAPrJUsIO5r26JAjjXEGRTBYuQ4ddHD+UyE3
         qanw==
X-Gm-Message-State: AO0yUKVSIfSipT5buj1hz4iHroFHnmviWItyMKBr+fIh9NAiRnI4iV/O
        Yafc9KK3ygwvRtlBNsoDh9En6A==
X-Google-Smtp-Source: AK7set96mw49YqNosxQVt4jH4XSyLJ+Y0MnlVTqkTMX+jvoNohItBpITBND3euhCQswKn/G+VS92pw==
X-Received: by 2002:a05:6a20:12ce:b0:be:d368:5c63 with SMTP id v14-20020a056a2012ce00b000bed3685c63mr13247651pzg.38.1675942693634;
        Thu, 09 Feb 2023 03:38:13 -0800 (PST)
Received: from localhost.localdomain ([124.123.173.74])
        by smtp.gmail.com with ESMTPSA id f22-20020a633816000000b004c974bb9a4esm1122729pga.83.2023.02.09.03.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 03:38:13 -0800 (PST)
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
To:     edumazet@google.com
Cc:     alexanderduyck@fb.com, davem@davemloft.net, eric.dumazet@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        soheil@google.com, syzkaller@googlegroups.com,
        lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH net-next] net: enable usercopy for skb_small_head_cache
Date:   Thu,  9 Feb 2023 17:08:05 +0530
Message-Id: <20230209113805.48844-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208142508.3278406-1-edumazet@google.com>
References: <20230208142508.3278406-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> syzbot and other bots reported that we have to enable
> user copy to/from skb->head. [1]
> 
> We can prevent access to skb_shared_info, which is a nice
> improvement over standard kmem_cache.
> 
> Layout of these kmem_cache objects is:
> 
> < SKB_SMALL_HEAD_HEADROOM >< struct skb_shared_info >
>
> usercopy: Kernel memory overwrite attempt detected to SLUB object 'skbuff_small_head' (offset 32, size 20)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102 !
[...]

LKFT also reported this problem on today's Linux next-20230209.

Link: https://lore.kernel.org/linux-next/CA+G9fYs-i-c2KTSA7Ai4ES_ZESY1ZnM=Zuo8P1jN00oed6KHMA@mail.gmail.com
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> 
> Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for providing a quick fix.

--
Linaro LKFT
https://lkft.linaro.org

