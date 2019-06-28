Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209B55A39C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1SbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:31:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44289 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfF1SbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:31:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id p144so5631147qke.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=k91fOLW6Pcxl8aYkv1mYvPzXNHSOL0a5RbyO9aMi7Sc=;
        b=KW/E8RXWJpFbe5QDBVJHVFzf1rXl+y4/PZe5toNabnV/6huPRtlicaM5U6NqW78y8D
         0sats2qCBwvJUsJDp05ePLt4XIilZH7ciEO2WdZItnttzpzH7N3wyU361AbVfZ/E3PQ7
         yMTUBE/+KLHgBXIwNGMzXZy3Wr1UViqIhA+NoS+pE2DqQvBHTCp6t8Ja6GF7L/rboIwI
         LQKX6Vfq+VjzZLY0sW6ZUqwVSdTcTETyuV2oQQW3JuW6cf3wRzYfTYQo2JlcKNvlwnFN
         HkvafWXwDPPmkojpFtmubMpb2ys1qDknKeaIHMcPxGLymhKO1q+xMfy4AXHgdS+Cm5tn
         tKXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=k91fOLW6Pcxl8aYkv1mYvPzXNHSOL0a5RbyO9aMi7Sc=;
        b=SsYp2eEU7MXCfttvnSJtRZDM1oC5rBknh2RHKUHeZmH1iVBGE2qYpUdnKs6U+3toEn
         tt5/IA/R8suxgexD6YuAL52e9DQ9Boj8WHmwRutfhu1Rb0xV2usutqNbv2K6sno0QJj0
         Ke4moa1RInZ+UYSZ/+4Mz2aTtLTQXiv9uU8HMkIeiKhGFMTRhRsaDXi95DAd0AmQbIJ/
         nNxXxRt6gO06OY/XlCU5upohYbC2a0Sj/Bi0dmuF0T4taAsr61vMlN6xnwTeJCT7EN35
         /WYpNmPK590YgIUNNnKYJmxnrX41Z/ERONsh+5K7j2a2pqfHslT91S7ocTQy8KlBHm/t
         Wdhw==
X-Gm-Message-State: APjAAAWz6p0xEZA9+BFFLfebt3pjhHk4OClhkWkyW4GUjWRlnD2wutGc
        Dy6KqiYcMwj8KKzqpVF6WXQqqg==
X-Google-Smtp-Source: APXvYqyhihsmafY/s8iG/dIMbGnXa4xTtXCJEBmBsDeRa/uRhEZgJCK5gsAAVaNHmemlf2xgSJTSHg==
X-Received: by 2002:a37:7847:: with SMTP id t68mr9808682qkc.128.1561746666776;
        Fri, 28 Jun 2019 11:31:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g2sm1439378qkf.32.2019.06.28.11.31.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:31:06 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:31:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.io, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Message-ID: <20190628113100.597bfbe6@cakuba.netronome.com>
In-Reply-To: <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
        <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
        <20190627164402.31cbd466@cakuba.netronome.com>
        <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 07:12:07 -0700, John Fastabend wrote:
> Yeah seems possible although never seen in my testing. So I'll
> move the test_bit() inside the lock and do a ctx check to ensure
> still have the reference.
> 
>   CPU 0 (free)           CPU 1 (wq)
> 
>   lock(sk)
>                          lock(sk)
>   set_bit()
>   cancel_work()
>   release
>                          ctx = tls_get_ctx(sk)
>                          unlikely(!ctx) <- we may have free'd 
>                          test_bit()
>                          ...
>                          release()
> 
> or
> 
>   CPU 0 (free)           CPU 1 (wq)
> 
>                          lock(sk)
>   lock(sk)
>                          ctx = tls_get_ctx(sk)
>                          unlikely(!ctx)
>                          test_bit()
>                          ...
>                          release()
>   set_bit()
>   cancel_work()
>   release

Hmm... perhaps it's cleanest to stop the work from scheduling before we
proceed?

close():
	while (!test_and_set(SHED))
		flush();

	lock(sk);
	...

We just need to move init work, no?

FWIW I never tested his async crypto stuff, I wonder if there is a way
to convince normal CPU crypto to pretend to be async?
