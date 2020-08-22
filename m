Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6869E24E86C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgHVPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 11:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbgHVPtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 11:49:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C03AC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 08:49:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id nv17so2123018pjb.3
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J01Y81Grz9xNRhDIKTOaegZytQv0+oxKdW1UIF55Nv0=;
        b=RwmKmlrU0V7eR9M4Q4089Vut+NFeNMr3vFlBAeWVhJm8eqXzvUIm4DWI/WuqmociX/
         Xch4QTscdTure0axZRiOziibbrIgUfXfWsxV/rSCryhuH2PAnPiFiY+GbpfOS4tTmSu+
         f5S87giHBW8GbqvVkIhSieydua5a05jGdLgi3y8roH0w2b3zpgYgJnGW54ooVTj66Cfy
         vCMO26b3fEz4SSAbEu8/6d9bE8dIwA/vkeemLjh3Z5o58jvYzLKXvzeXHQlCCnkwE9cT
         /lgvbojXJTwsjsz/nBZEspC4kLCW6/puRzXCPaCAvwjMjk0IraTkIf6H/m3oWfyY165B
         QefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J01Y81Grz9xNRhDIKTOaegZytQv0+oxKdW1UIF55Nv0=;
        b=ta/MNlvynjUGMzeDUJBp14ExCWNs9holkacFHIPf61twoJl2jE4ROxMFQ0uuDJBbvE
         UkW4zUueqALwQ7jE2ctZJoQEBvFd8MLoK5knmjxIU+iI50Ki2Eak4eT9S+RShop8POrg
         AYPVm30YkKKMBWv5siBf7PgiWqAQDZqYxJcWs5vMFpisOtXrybQdfGjMsW1UMzjRybpv
         Xs9AHtvuuLEJSyw8BqiZbjiqnuR8e7EgX2aciehnlODhC+csyOTsPbbwBVFtgnpomvTi
         tO/URJ9T+cQkOWW+JcDa0WpcMidgNXeMU3qcEGZBnj3Z6nWokQ10PmrabZOX8QRleB6K
         wpdg==
X-Gm-Message-State: AOAM531WWcIaRwR2o3gUgIK6VECdnQ8zgLg5lM2vFzLzg/roVrDn5BDN
        RoHdc0Dh5NCgnszBiFNTXjweAA==
X-Google-Smtp-Source: ABdhPJxNEviv1v2YMyZAIvrK4/VQaElwCbbT8kz0oJjxr3xh9VO/qKbEL8STkXY+1IKDlwVIT5fAXg==
X-Received: by 2002:a17:902:9b96:: with SMTP id y22mr6335939plp.86.1598111360041;
        Sat, 22 Aug 2020 08:49:20 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q66sm4737602pjq.17.2020.08.22.08.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 08:49:19 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
To:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <0bc6cc65-e764-6fe0-9b0a-431015835770@kernel.dk>
 <20200822044105.3097613-1-luke.w.hsiao@gmail.com>
 <20200822044105.3097613-2-luke.w.hsiao@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0bf83129-b405-b45d-61b2-75808b971946@kernel.dk>
Date:   Sat, 22 Aug 2020 09:49:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200822044105.3097613-2-luke.w.hsiao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 10:41 PM, Luke Hsiao wrote:
> From: Luke Hsiao <lukehsiao@google.com>
> 
> Currently, io_uring's recvmsg subscribes to both POLLERR and POLLIN. In
> the context of TCP tx zero-copy, this is inefficient since we are only
> reading the error queue and not using recvmsg to read POLLIN responses.
> 
> This patch was tested by using a simple sending program to call recvmsg
> using io_uring with MSG_ERRQUEUE set and verifying with printks that the
> POLLIN is correctly unset when the msg flags are MSG_ERRQUEUE.

Perfect, and ends up being much simpler too and straight forward.

-- 
Jens Axboe

