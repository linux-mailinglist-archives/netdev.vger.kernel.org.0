Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782B2D090B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfJIIDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfJIIDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:03:47 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85D2C69095
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 08:03:47 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id h19so171497ljc.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 01:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e6PDWY+jCDc15XxVDO6PNOmfYxpRrFsL3Dg/nclfQ5Q=;
        b=KgdFR35ahxvHpdOEJS97NCeig5+nhgM+jtNAMK4gFUOhsy/c3HV05GkHQPKQdRmAMC
         8O0vnxQaE53kNfZcSrE+pTNmHbKZQyWbooMtF8k/R8iIcmLbdDQvK869yJkqTa+ft/Yr
         Jt9eJtebR/bj7ZYKl/MdZ8EzYbXsZgK3f6k9Z12jkxWP29kez4n4aXwCPgjtbUKmV0/r
         LIvQtQUleObKBKwJtNRzxXPS31AYu5QsdDzMGB5ozyM87TsrjDjtKLu6n6uzW5xbpVpo
         tERPTmvJyKxebZHuccdZzoU/p5GlGp9eBQS7G+LEAkw/tbnW8NaswZLV+IEH7LDln82z
         eLyA==
X-Gm-Message-State: APjAAAUaW3lmjgeIgDmENWoB7QfcJn36WIU7py5MeQlwA0eZQd4nkYCq
        HFl8W/7XQdC0BQ747/rJMVXQs3t0GKMX+GQwFl0VBFQzNHaNWEcO64ZY9QnIqK2OEzFseTg8pjW
        0oQFu3sohhnRRaTAT
X-Received: by 2002:a19:4849:: with SMTP id v70mr1266874lfa.40.1570608226086;
        Wed, 09 Oct 2019 01:03:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8KUkRcnDDp+F0kxjHINAA1UwC3GB9awdIdon0aDan85L+Ki3CJuQUEi/AcdLBoEiIYovPxA==
X-Received: by 2002:a19:4849:: with SMTP id v70mr1266855lfa.40.1570608225842;
        Wed, 09 Oct 2019 01:03:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id v7sm291317lfd.55.2019.10.09.01.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 01:03:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E105318063D; Wed,  9 Oct 2019 10:03:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF programs after each other
In-Reply-To: <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Oct 2019 10:03:43 +0200
Message-ID: <87o8yqjqg0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> Please implement proper indirect calls and jumps.

I am still not convinced this will actually solve our problem; but OK, I
can give it a shot.

However, I don't actually have a clear picture of what exactly is
missing to add this support. Could you please provide a pointer or two?

-Toke
