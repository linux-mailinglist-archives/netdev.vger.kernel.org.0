Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C35C0A4A
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 19:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfI0RYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 13:24:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34575 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfI0RYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 13:24:51 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so1981900pfa.1;
        Fri, 27 Sep 2019 10:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AYzUoBpWOqTNHjVGTCJwOtqfLa5PIE8RsnPT73yDBlw=;
        b=CaBu1P+Po6z15371YRSBimETL+pJ1eckaGXOYzqDZQYHiLZOWSSeHXMbwyrqp+lVBW
         SCZLsP5TFyXwr6KwkK/H5CmRBho22sL2e2Rg5vllqLnOJyzIzmzGNdcC0oF/7J0MTQEm
         jR0lY2Z/GPePvCdZFQuA7eiry+7CzMCshuANcopvSO028wCY/bibFruUE/tGmyGeEG6/
         Dp7ZZN17OJfihKQ6NzIvyqaCF0/aid7e66OkiGhwFKnVXFIZ1BMPcmxCewNbSbyz36yq
         G53qc2p4fnIvBJrlp6nXznThRTyA0g5FKjdqkpNbOw7x0/EQM1X4PQ3WOQcsjtPISxTp
         KC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AYzUoBpWOqTNHjVGTCJwOtqfLa5PIE8RsnPT73yDBlw=;
        b=DxVRbmIr9/Q82ihgBdNoHTKXBXqIqrV8oKH1i2mPjSk7xMnNcbCAh2tHlgu5bIZQiR
         Zny095YgWWIe/XbyTq4kTJM1hm4WDNy0ayCkAjjANJ4BFDoF8/nez5XcpSI0Uvxd7Gc3
         3IzxnOyKhEhbe6KQpa/wGc7cnXoo1KBYaarJbyGlog8/JxfF1zhrCQM+3YT5S1nUI0ap
         WrFVGtn8d7XnKMNSImiLyP0dgENcPDkfh7hrcs4Fhyegd31usUBbzb5UPR6t+E2DmXXd
         cY2Xbp3UIQ3iADRP0poNl1g8o4OBCjJb0hCx73zN02EqtGZe17rIogL5Tcj/m6KDFE2j
         uCFw==
X-Gm-Message-State: APjAAAWPkKggAF5Zuklgf6XXvHSK2D7KGQiVx1NX1WxSCo9ZwWdHqV2X
        4vU+4vwzkNLhILhBjKlTwzs=
X-Google-Smtp-Source: APXvYqzjS/LgONkfor0jCAI55Z9ZcdGZp0hTMAs+WUttK8SqZ72R8Ga9P9GvK5z3Lsan4Ffw+MYpXg==
X-Received: by 2002:a17:90a:e384:: with SMTP id b4mr11217071pjz.136.1569605091117;
        Fri, 27 Sep 2019 10:24:51 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e14sm5326009pjt.8.2019.09.27.10.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 10:24:50 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com
References: <20190927165221.2391541-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <04f683c6-ac49-05fb-6ec9-9f0d698657a2@gmail.com>
Date:   Fri, 27 Sep 2019 10:24:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927165221.2391541-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/19 9:52 AM, Martin KaFai Lau wrote:
> In reuseport_array_free(), the rcu_read_lock() cannot ensure sk is still
> valid.  It is because bpf_sk_reuseport_detach() can be called from
> __sk_destruct() which is invoked through call_rcu(..., __sk_destruct).

We could question why reuseport_detach_sock(sk) is called from __sk_destruct()
(after the rcu grace period) instead of sk_destruct() ?

> 
> This patch takes the reuseport_lock in reuseport_array_free() which
> is not the fast path.  The lock is taken inside the loop in case
> that the bpf map is big.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Fixes: 5dc4c4b7d4e8 ("bpf: Introduce BPF_MAP_TYPE_REUSEPORT_SOCKARRAY")

