Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C1FE83A0
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfJ2I4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:56:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38605 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbfJ2I4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:56:32 -0400
Received: by mail-lf1-f65.google.com with SMTP id q28so9900032lfa.5
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0est3ShahLxcPmw4Tsar7U28jeB8H6MurigDJXjbStw=;
        b=od2P2y/7xCpqSD19BaWaLFMB+5Gsrg2etCnIdR1Nn2xujiCDMq7Fcz5unWkRCbnKBp
         HMxWukdHd+mVeCpVYqZkmTaDLx7a3+vWTcWVVzgpLL79yCq+MiGrcFv9Qs71Icf0Fz3r
         v06eTz2PV/dw9FDorCGG07Af0RxSBhDpTOOco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0est3ShahLxcPmw4Tsar7U28jeB8H6MurigDJXjbStw=;
        b=f9lZ38qjGbvlhH4bM4RdNgtCdAA2cmcePfdrv50US7G2+hDnAHMwPeXqrygfw1KiXO
         j7GE2q5AOQXykafLmsmERGxBc9zB86jea0rE+ywvOpMCztA1+GzKMToWflDtClCfPKfo
         wmi8mq3KZfry8oxhe+yUbRzm633OVr3zjMrIP/vyHxU62LpeYbAPiwOj34Wkq0bh1d2V
         jF5VH8qwVvNt2++XeiXehWvaV+b7ysShwEF3FhL/xALAYwuT5nI+yBULMNyU841KpeKE
         1PkG+82RxIWkZx0+hYW/ZsTNlUUnvibLH14Ige3PQhA4tLWFq/KfeO4c4qwOA03cZ3GV
         qlJg==
X-Gm-Message-State: APjAAAUcDKfY9s1it7YorZRYgvoy6dZita0qzXfxOTxpTLVYYfZDZxw7
        x8J98fiKbLMXkzwa2nHg+DbMuA==
X-Google-Smtp-Source: APXvYqzpE2JaFYk5lUazrtMmZ9MfYwsYj+VZDhqYHEYTt4fWG5wpFvuG2s3HMzUlZGKMRqvQHRd49g==
X-Received: by 2002:a19:98e:: with SMTP id 136mr1560765lfj.27.1572339390258;
        Tue, 29 Oct 2019 01:56:30 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h26sm2302857lfc.69.2019.10.29.01.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 01:56:29 -0700 (PDT)
References: <20191022113730.29303-1-jakub@cloudflare.com> <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com> <875zk9oxo1.fsf@cloudflare.com> <5db73ba5afec7_54d42af0819565b855@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin Lau <kafai@fb.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
In-reply-to: <5db73ba5afec7_54d42af0819565b855@john-XPS-13-9370.notmuch>
Date:   Tue, 29 Oct 2019 09:56:28 +0100
Message-ID: <8736fcorpf.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:04 PM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> I was planning to split work as follows:
>>
>> 1. SOCKMAP support for listening sockets (this series)
>> 2. programmable socket lookup for TCP (cut-down version of [4])
>> 3. SOCKMAP support for UDP (work not started)
>> 4. programmable socket lookup for UDP (rest of [4])
>>
>> I'm open to suggestions on how to organize it.
>
> Looks good to me. I've had UDP support on my todo list for awhile now
> but it hasn't got to the top yet so glad to see this.
>
> Also perhaps not necessary for your work but I have some patches on my
> stack I'll try to get out soon to get ktls + receive hooks working.

Thanks for the heads-up. If you have a dev branch somewhere, I'm curious
to see what's cooking. Otherwise I'll keep an eye out for your patches.
