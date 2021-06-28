Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A043B668F
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 18:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhF1QUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 12:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhF1QUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 12:20:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C46C061574;
        Mon, 28 Jun 2021 09:18:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso362000pjp.2;
        Mon, 28 Jun 2021 09:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=//f/I/KD5xRd11o6Hb+6q4JyvdMxw/dD/4E2XDupayw=;
        b=Z8moeK0GXjeB66FKcPwH3GhxOtubjszNU47sbPsRl37VdUbtv7ezQC/QfRLgOiGrEn
         MrCMkFtK7eyrOt7e+L67uwl1BPzLQTz2Oj+vUFNNJdYIAGbGNZ/EHvc/shVu3PxwA0ZP
         0mgfs2y6ZdP1g89tQMg+Xo2l0E6Wq/MLLv8q5wULSBl+PfPM/xUH8mGcX0xOGSkOXGY2
         3guSSrsNtb/64oybj793dL9H7UDJ3mN98X40KZbaco128EpiSLmqhLIe2VNrPrcEhR8A
         DmwKLP0E6ddAckakbxvwJpHhu1EqgY9DutiasUuga5a0ne2xj6NxT8FbUoGbzbZcva84
         77+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=//f/I/KD5xRd11o6Hb+6q4JyvdMxw/dD/4E2XDupayw=;
        b=PQ8zqbjYWFe41/3GBplY2HsFR63hLvhDfMc9/bw5BAewsh7FauJKgGgQ8SRBWCrfl7
         ijIq9iTvPQvPYQVPJpKqxJ5FQdnz9r4LxHFmdCM18aOOm7j0KzD2Fe0AXaaK4SgGes9G
         56+xAEmrEbckwRUokMmgeS/rcllP1e3GR3IXZ49ddAPD24WxQOH1woSbGTM6M+6d4NBZ
         er8pVUbvTEMRWONUf3n82cx99VrinU7cluRAnbPvyo4rcBYPlbARZWNJXwc/LyE6oqE1
         8vL+gb2nGpKXnbGk3+6a4P3Y8wNouSyjguF/EPmW2UOx/8k7KxQqBxO3CiwzAcmomAR9
         OXGA==
X-Gm-Message-State: AOAM5323DwJBDjGITjbZShltq6cQ8OQKiDbtOsar+tjhOKENMAoCRY5w
        F29UCrOTfsZdbXXGx7H/wPo=
X-Google-Smtp-Source: ABdhPJwFubJeZBk8HM0tH0MnapCVqseK4cwUuK494LXwUm+m9HpCj4dMkcB/VPJF8q7Lj3ManFCS7g==
X-Received: by 2002:a17:90b:3a91:: with SMTP id om17mr29493006pjb.50.1624897098072;
        Mon, 28 Jun 2021 09:18:18 -0700 (PDT)
Received: from [192.168.93.106] (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id l7sm14875506pgb.19.2021.06.28.09.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 09:18:17 -0700 (PDT)
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in
 tcp_init_transfer.
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
References: <20210628144908.881499-1-phind.uet@gmail.com>
 <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
From:   Phi Nguyen <phind.uet@gmail.com>
Message-ID: <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com>
Date:   Tue, 29 Jun 2021 00:18:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/2021 10:52 PM, Eric Dumazet wrote:

> Unfortunately this patch might break things.
> 
> We keep changing this CC switching, with eBPF being mixed in the equation.
> 
> I would suggest you find a Fixes: tag first, so that we can continue
> the discussion.
> 
> Thank you.

Thank for your feedback. I will resubmit it with a Fixes tag.

Regard.
