Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8366510A04F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfKZOch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:32:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44713 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbfKZOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:32:37 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so13229365lfa.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 06:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=pQvSJ/V/b6U4GcI3ILMxAFDCLr21ECkN15nERg7+uEA=;
        b=cvFDEBMXHl0scmQJdI578WTIitkXsKUgx6c/hCLXsYJVjhh8HBIQs0XujvKaobSCRb
         4sd1gwDYtv+PURSPlNR5UuE7WnnhYJOcfF64i6BcDR7Hu6G+GU4hejHpAk+SUMo3pa2x
         keMNVpkyYlPiBT4zCHLjQxPN76zGTDKTcme40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=pQvSJ/V/b6U4GcI3ILMxAFDCLr21ECkN15nERg7+uEA=;
        b=iWgOTtQ/xCu5f4Upl+x7FtIdeDM/xvU/HNOFWPmHcdORvLYrjf8iQmB2KyzMdrKf7H
         eJr5kFZjJQwFer0yIxMPDi2j1Ik5Ncp0LH56+S1H98YM2OfoLrMjVG7uicMKK2eMMOfi
         7l1j4LVpA6vkCZJmd+Nlpn1xiFJcg2QAmiCP5scbhkgZejviShULxe3yr4kdPURzjxe/
         vfDA9+7YdUNwsgqZ8lYs6u/og53UjBlXaeA5w0pGsJU6HtKY5BNLUFWS16cUXeRZ45LI
         pVttOWRFevyvvTQK8zH7NVJnSNFuuOLHR+m0miEUbWgWY5XSDQ+BpifjSxGq+0xAHH/k
         S3OQ==
X-Gm-Message-State: APjAAAWiApM5dhqmeqWuhSB+a9Tj1Dj1V82p5P3T+cOyu58jBJ25uLpp
        0wbkeXTJG/GGYyy2Wf4qY2ftpA==
X-Google-Smtp-Source: APXvYqwN5qBJzkc1AmqDYNHCOO3HvUwedfZbKqblKDTGusTRzi3U5P6FEi0KwnLQxAXfzuTwAFbhIA==
X-Received: by 2002:ac2:4436:: with SMTP id w22mr13554205lfl.185.1574778753467;
        Tue, 26 Nov 2019 06:32:33 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id e27sm5394444lfb.79.2019.11.26.06.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 06:32:32 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-8-jakub@cloudflare.com> <20191125222958.aaplyw7ebtqs6yyl@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
In-reply-to: <20191125222958.aaplyw7ebtqs6yyl@kafai-mbp>
Date:   Tue, 26 Nov 2019 15:32:32 +0100
Message-ID: <87h82qoghr.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 11:30 PM CET, Martin Lau wrote:
> On Sat, Nov 23, 2019 at 12:07:50PM +0100, Jakub Sitnicki wrote:
>> Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
>> can be selected at run-time. Also allow choosing which L4 protocols get
>> tested.
> If new cmdline args are added to select different subtests,
> I would prefer to move it to the test_progs framework and reuse the subtests
> support in test_progs commit 3a516a0a3a7b ("selftests/bpf: add sub-tests support for test_progs").
> Its default is to run all instead of having a separate bash script to
> do that.

Great idea. Let me convert these tests and the newly added ones to
test_progs framework.

-Jakub
