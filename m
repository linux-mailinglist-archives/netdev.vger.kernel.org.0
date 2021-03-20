Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32699343039
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCTW6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhCTW5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:57:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4683EC061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:57:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g1so4649943plg.7
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O66th9jq5EAf7z7EOe17UtEcZtIhva9jOuThNp0T+80=;
        b=BNeiqVO6IisukiKm/LeCM4dzOHGpYZ7yhFx5mptFO+GPsZB5rsMXwepBIzAaBNkV6W
         2xfPFdJzsPVevADN06+cDjGoYEvppokTpiInYZCb2/G8Xa/7hNfj3XJzD1a2FFNPE+9P
         I4gv7gyNyXyLYGynNu8Y4tIcC9q8UEBvJrnywjiGI6676GRwu8HcD10nkUuF5YM0yAAW
         EcFHT7IhW3GUvptr2l+rRJwHpJxv9Ia8t1/q4d8bd3Lg1dHna6Sxlqgu6mmUr6zxribJ
         FGQuyzdFFp/PgKeDxUc45jZEOB1v8ysKZLHNcITX9qTVj0wXUbfnXkSwD90EahGuUuIH
         M4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O66th9jq5EAf7z7EOe17UtEcZtIhva9jOuThNp0T+80=;
        b=nB8sZYYakPvyKBCZozm0AvAzltLcXBLG7AHnsqYtXmiFyi/IwhML466xU9VXI3KiJL
         uCSr/9+4dir0vYC60CZqZnNY5NS18DYXeo31l0A1LRAvB0LcXIMxDoAk5Om7E2TlYnuM
         AD5gmQtAqpi+BYqUr0+zvT0rB2fxAaf8awlpPzYsmi9dX4HE832GDkB0NYXDvQ5dNSnz
         aukQEJk75gfA7Zljo9ZN0hocCq+df8/LGaCXdLyZO8duO8YEU8ddWbKSQdqUXGl6fjQI
         979iafCzjANfiA5ihPWWCNZcw1S7dDTSsLG6oo5imJ3F6ZNWE1xi3FHMv0+eeOdX7JqZ
         9WsQ==
X-Gm-Message-State: AOAM531l9T4OngDp4NorRXloteISE8PAtuHzhSeHlrxMx0z4pvqQalwg
        6UraFRiOdFTU0FaU6Q6Vo5ukF701Yd1D9A==
X-Google-Smtp-Source: ABdhPJyIfaD8BJx9PMzRgtcESjyjV0ou5KlbMF1A3h7SO71ex7ukvSThKgAprtnqVslM7bK2VWKzWg==
X-Received: by 2002:a17:90b:3587:: with SMTP id mm7mr5375533pjb.21.1616281063581;
        Sat, 20 Mar 2021 15:57:43 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j20sm13339994pji.3.2021.03.20.15.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 15:57:43 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] io_uring: call req_set_fail_links() on short
 send[msg]()/recv[msg]() with MSG_WAITALL
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
 <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38a987b9-d962-7531-6164-6dde9b4d133b@kernel.dk>
Date:   Sat, 20 Mar 2021 16:57:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/21 1:33 PM, Stefan Metzmacher wrote:
> Without that it's not safe to use them in a linked combination with
> others.
> 
> Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
> should be possible.
> 
> We already handle short reads and writes for the following opcodes:
> 
> - IORING_OP_READV
> - IORING_OP_READ_FIXED
> - IORING_OP_READ
> - IORING_OP_WRITEV
> - IORING_OP_WRITE_FIXED
> - IORING_OP_WRITE
> - IORING_OP_SPLICE
> - IORING_OP_TEE
> 
> Now we have it for these as well:
> 
> - IORING_OP_SENDMSG
> - IORING_OP_SEND
> - IORING_OP_RECVMSG
> - IORING_OP_RECV
> 
> For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
> flags in order to call req_set_fail_links().
> 
> There might be applications arround depending on the behavior
> that even short send[msg]()/recv[msg]() retuns continue an
> IOSQE_IO_LINK chain.
> 
> It's very unlikely that such applications pass in MSG_WAITALL,
> which is only defined in 'man 2 recvmsg', but not in 'man 2 sendmsg'.
> 
> It's expected that the low level sock_sendmsg() call just ignores
> MSG_WAITALL, as MSG_ZEROCOPY is also ignored without explicitly set
> SO_ZEROCOPY.
> 
> We also expect the caller to know about the implicit truncation to
> MAX_RW_COUNT, which we don't detect.

Thanks, I do think this is much better and I feel comfortable getting
htis applied for 5.12 (and stable).

-- 
Jens Axboe

