Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380403E959B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHKQMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 12:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHKQMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 12:12:23 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1194EC061765;
        Wed, 11 Aug 2021 09:11:59 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso4825361wmq.3;
        Wed, 11 Aug 2021 09:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MPha9OXmqtN1vnQ4nGyj7vziUXy5Fz1Un6xPWG/5xZg=;
        b=V8PsfhB+l+7C9qMv82uJWMQaXtRVpahlowl+XF2x+TBlW8aQ52CKjJTh1YTlseo2eP
         v8C60TWLc/LYhHmQI8n/+unYTKEJUD8C1eDAAkQnUxblc1KJMr3V4A8zYhKtqW0iOB/5
         km61REWqRtW9kSLmwSfEVMO8NaVHgNYcHRQVuM3CTUyEprY6vCcgpcY7eO9d3eE+2oTT
         wU6KzrxwVqUFmga/p87zY0TcafdQNJSA6ZdHROlMiuWtftfRGkAlJXGitFb1Nf+3EXUe
         eVww3yZBU/mhLFzckDWpOTMF6oJbF+pNKejbPQYV/oIngz96yZRFZSm3LM266S6Ljwy4
         plLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MPha9OXmqtN1vnQ4nGyj7vziUXy5Fz1Un6xPWG/5xZg=;
        b=IH3zg7KUDA83Fk2a/CqdwflVJGdo2FMxHkR4ipELRCr1bwb4dfPPGMLggKT4UU8C8o
         CNO8wmKcX7+jmEWcGkXRowqImjJdeLEvYtdjMsIAzkJFbo4G3jdGFBpOwFCOQUS+NVjx
         iPCmO3jIymTuYZl+y6Nrx3NdjUcfQJvNgZxksN7I1CLOwwjkNddbdVpUg8KQ0a1RxNYi
         fvSse4c2if+WRI5Xm/9hB9cuYAI5tNRjg0v5y7voLtgdFmuzkTu32R5DAvAYy7O627Cx
         RWIam9o07SnRnM4V8bkhU8SIU/Dd8WT19xVxa/c5vP+jKC2aVIDVvMQAmQil0o5JNhe3
         gHkw==
X-Gm-Message-State: AOAM530y7FOooatSuok5MBQEmz0Yj+wuNVYVwFx6AY3DJRn+hyiSnRVB
        fbga92f8yfH+qrbIaQlW5yxjXSX//wo=
X-Google-Smtp-Source: ABdhPJxFqOdo6jahNaXOT3zt0F0F41DBu5XuyUzk6p92SetxMgBZ2wfS+hrEODyJ0jzFNnNMHDN2xA==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr3017785wmf.26.1628698317391;
        Wed, 11 Aug 2021 09:11:57 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.41.250])
        by smtp.gmail.com with ESMTPSA id y6sm7572690wrh.8.2021.08.11.09.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 09:11:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] net: return early for possible invalid uaddr
To:     Wen Yang <wenyang@linux.alibaba.com>, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210811152431.66426-1-wenyang@linux.alibaba.com>
 <20210811152431.66426-2-wenyang@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <247c8272-0e26-87ab-d492-140047d4abc4@gmail.com>
Date:   Wed, 11 Aug 2021 18:11:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811152431.66426-2-wenyang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 5:24 PM, Wen Yang wrote:
> The inet_dgram_connect() first calls inet_autobind() to select an
> ephemeral port, then checks uaddr in udp_pre_connect() or
> __ip4_datagram_connect(), but the port is not released until the socket
> is closed. This could cause performance issues or even exhaust ephemeral
> ports if a malicious user makes a large number of UDP connections with
> invalid uaddr and/or addr_len.
> 
>  

This is a big patch.

Can the malicious user still use a large number of UDP sockets,
with valid uaddr/add_len and consequently exhaust ephemeral ports ?

If yes, it does not seem your patch is helping.

If no, have you tried instead to undo the autobind, if the connect fails ?
