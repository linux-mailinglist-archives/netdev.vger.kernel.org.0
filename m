Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21302B6F09
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbfIRVpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:45:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36497 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388135AbfIRVpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:45:33 -0400
Received: by mail-qk1-f194.google.com with SMTP id y189so1118086qkc.3
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 14:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=03qNJHzYFNeuevjse5i/TkC3WcBhQZRVBc5koawgiHM=;
        b=XJAABUjzWqsx7khBxIOgCeR4mTj00QhilgtdOayzOPwacAmEFt9JKtDqMNEPwcfy3L
         ub/9kk8G9QUNDjhB863b+odJ0jpmQ9mm6eUO4kww1+8XPUrep4EzIedyr0lJTfXuPZqe
         bmYzxUz97XTiE4Py6Ae/6iNgOcNct7To2dR1rNRVurX3oVoaLmXV5ToiNOkAwF8Ke/Z3
         /RKZDAuyXfcJB9YtTFxzdADsCeYXqBcV4zrb1yAuTCk6z8RB1CkMAAtdbT6pPb9rBk1e
         zQ2cDpXkjPXUYaL92HxHIEe0GiABZDVTtySCwFKU5FbiiADyCuQLL4IzcdkHGJQIrdOs
         8pEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=03qNJHzYFNeuevjse5i/TkC3WcBhQZRVBc5koawgiHM=;
        b=H7SuFJN9nWUf3HB+kLhCr9pCvyXoH2o7q1GK/isWYABZQtLzYsFy9/mhrWVPgFYKeL
         p8rOJDeXAFenSLDPKZqNB1b0HnR+bBQFfWDCmkDa7db5nJizqEh5DjV+t7a6r+r+9cAk
         MnCbCSrH5HxtGxyj/RGf+9dsmXF95A/l19LcWqa4bq3tTIk/az7zqttp6oucsENNWe7z
         /buQzCUctdaSODekrCnywQQKR7Jy58xT8Qgfq47S3WRcFyFJ+wlMUQBx9wMQCtVMH+5c
         lnINNUhdVkd3zYP1BT2/+iPF3wAjh3nFFEu7noGaXNsNyi9+kiDa0AfQUDKuD/2cTNFT
         mfhQ==
X-Gm-Message-State: APjAAAUjhHe5lM0oYJJsJ/80LqyyrHA3AV7XmJyGcMoz8x5fcYwrS82G
        tPSBFuzIhYLCovQA+VAiBJCfWw==
X-Google-Smtp-Source: APXvYqy2WvtVRyJfzrytM+f9ii42+StRsZyteSq4Ak9KEvYMoWQT/yiLbXyTz5pT6yWwXU+ET2yqvg==
X-Received: by 2002:a37:4f55:: with SMTP id d82mr6470766qkb.333.1568843132149;
        Wed, 18 Sep 2019 14:45:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w73sm3613331qkb.111.2019.09.18.14.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 14:45:32 -0700 (PDT)
Date:   Wed, 18 Sep 2019 14:45:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, aviadye@mellanox.com,
        borisp@mellanox.com, Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharakonda <mallesh537@gmail.com>
Subject: Re: [PATCH V2 net 1/1] net/tls(TLS_SW): Fix list_del double free
 caused by a race condition in tls_tx_records
Message-ID: <20190918144528.57a5cb50@cakuba.netronome.com>
In-Reply-To: <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
References: <CAOrEdsmiz-ssFUpcT_43JfASLYRbt60R7Ta0KxuhrMN35cP0Sw@mail.gmail.com>
        <1568754836-25124-1-git-send-email-poojatrivedi@gmail.com>
        <20190918142549.69bfa285@cakuba.netronome.com>
        <CAOrEds=DqexwYUOfWQ7_yOxre8ojUTqF3wjxY0SC10CbY8KD0w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 17:37:44 -0400, Pooja Trivedi wrote:
> Hi Jakub,
> 
> I have explained one potential way for the race to happen in my
> original message to the netdev mailing list here:
> https://marc.info/?l=linux-netdev&m=156805120229554&w=2
> 
> Here is the part out of there that's relevant to your question:
> 
> -----------------------------------------
> 
> One potential way for race condition to appear:
> 
> When under tcp memory pressure, Thread 1 takes the following code path:
> do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
> tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
> do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event

Ugh, so do_tcp_sendpages() can also release the lock :/

Since the problem occurs in tls_sw_do_sendpage() and
tls_sw_do_sendmsg() as well, should we perhaps fix it at that level?
