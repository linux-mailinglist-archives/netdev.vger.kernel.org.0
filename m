Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7581B2CBE18
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgLBNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgLBNTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:19:38 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00874C0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 05:18:57 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id g14so3864479wrm.13
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 05:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tff8j+Up327jAQc5Nizq6nqc39WGzowoaTdPJ9sKakk=;
        b=XceRwV4vN6HIATAx1RSUr50aY4ENruk3F1urHgKKDw+S1ivA7rLE6ssmrcUFZCRMH6
         w8+KaTrq7P1PWoOzUxAlpUib52DS3Eap1xZgJYyHOP+zQJeLVQvTXhpsMH30PT2Bq3lD
         PMwJQeyJH8BY39+9O8aLbicOVYFUMkSE0yIJHxMQR3Efj2Nj+EaWv+1sg0pePylI2bUD
         N7zKSclvZ3HeFd1LDQKKlSXPHpRSxmSMT1VNoCpLIcPAR1DYwfE6WBoajMH/NPuxJD9y
         ztbgm11xLESQ0e16yRz2jja8BXFa5sBrLQtRECKrPs+mq85lYwUyMv3oa/ufnixKBNdX
         JInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tff8j+Up327jAQc5Nizq6nqc39WGzowoaTdPJ9sKakk=;
        b=CTDXG1tJkvu6Eg8dBE6kGYlKFsPgfxzg5YROunrCtP+4wQRfkLfaMa2g01BrXGBnWl
         XVmw027yPku+jUk+Ap7MGkMAV1jvIzNmSlRU+Kms/HT1gcOqC53Zzq4dpfB4whGuLDrh
         rWid6LL1mFHNATn0ZLIdvOQXnLQzOgorrGlkYlRVjtmx/fXy7jPJsYb1KWcAarow/l4s
         e4gAHAKWWpGwnI8D7UyHSriZcbNB6KSc8rtXIAL1cTLJGlxjZDl1TfXaKaqFs+ajHCJU
         83MbY9+guCvJGme0SCtZPHN/oehM854tFKiN9WzZjwq9KPESZXgKw/luzUtlW9bbJzVv
         oWJg==
X-Gm-Message-State: AOAM533OsKQ/KDcoqE8/EZKwhTA+rfC25NzjF9JxqF/wNAhbp+X3G2YX
        wDZF4ogBL1iW1ZRXZ3W6PJM=
X-Google-Smtp-Source: ABdhPJzE6DDmMR2SaIZrz5A5Q0mH+o5GsjG3mvOrV6NoYeNUsvTUIhh9EElTfFON36bHgvQXL2tb0w==
X-Received: by 2002:adf:fec6:: with SMTP id q6mr3534705wrs.168.1606915136748;
        Wed, 02 Dec 2020 05:18:56 -0800 (PST)
Received: from [192.168.8.116] ([37.164.23.254])
        by smtp.gmail.com with ESMTPSA id k1sm1955341wrp.23.2020.12.02.05.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 05:18:55 -0800 (PST)
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
Date:   Wed, 2 Dec 2020 14:18:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/20 10:51 PM, Paolo Abeni wrote:
> We can enter the main mptcp_recvmsg() loop even when
> no subflows are connected. As note by Eric, that would
> result in a divide by zero oops on ack generation.
> 
> Address the issue by checking the subflow status before
> sending the ack.
> 
> Additionally protect mptcp_recvmsg() against invocation
> with weird socket states.
> 
> v1 -> v2:
>  - removed unneeded inline keyword - Jakub
> 
> Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 49 insertions(+), 18 deletions(-)
> 

Looking at mptcp recvmsg(), it seems that a read(fd, ..., 0) will
trigger an infinite loop if there is available data in receive queue ?

It seems the following is needed, commit ea4ca586b16f removed
a needed check to catch this condition.

Untested patch, I can submit it formally if you agree.

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 221f7cdd416bdb681968bf1b3ff2ed1b03cea3ce..57213ff60f784fae14c2a96f391ccdec6249c168 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1921,7 +1921,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
        len = min_t(size_t, len, INT_MAX);
        target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
-       for (;;) {
+       while (copied < len) {
                int bytes_read, old_space;
 
                bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied);
