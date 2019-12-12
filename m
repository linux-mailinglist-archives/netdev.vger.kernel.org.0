Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03111CABF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfLLKaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:30:09 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37930 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfLLKaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:30:08 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so1294223lfm.5
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 02:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=U2g3Tx5xnJ3ahG+w/a081Oszkkyiux0oCAA5dO7KUNs=;
        b=ipGd1mbjflOGctzu98UqeCn8A3rubCUKwo1nqkFtejIVuIqm2GFh7AGXlds/cuCilf
         IsOSn02Ka/b68WKRDub/4gJ2yWxw7u5HCJm+VOh9EYGI7AWNKO9TloUnSW4hv08imxaN
         9oIUYTAzY98OtDxdm/Ao9V4bv12MNbQJKl3yQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=U2g3Tx5xnJ3ahG+w/a081Oszkkyiux0oCAA5dO7KUNs=;
        b=NrN6zQ6+v1QqYuImfcqUOWW5bGqttt5Nat6c0luUx2KM/h788k2CIttPOIcTmrvC/X
         I0qlyxuKHNvvwDTKNn3zUGI45JKHr0ljir1judcssWW+O/eZFJu/vA6WXrj20crkqr6G
         A3t0J1cq7Q+FBLvGT+u608GgGPfcknIKVCAogxKvftEV6E5OkoX5g+8gtqRdM1M1EPbS
         Ycprr+GNCtvgxGWpyROZVvKKFrrPGJS7SYGvCQAje6ZX0GJsnC3HalcgpcGb/DVhJoat
         XAKTRkQM/tFNMBETjmxo9eV5B9TdBEc1AveVvGDU+sRw26y2OQJ3yBwncdWikb/6jX/0
         P+3A==
X-Gm-Message-State: APjAAAUjFmnsZLe6THX+sv7phTFgPJPXhnTBXkV0DQ/lEalWtQJoZgn2
        sEAdwDHAsT8yFYsDz+KN46y9DA==
X-Google-Smtp-Source: APXvYqwQLpBqpme64En3iQM4+rxb4gw4aotUDiwJrj6viKPTKwFwHcX0reYR7bpYvJTlSoqYNw8ycA==
X-Received: by 2002:a19:2d0d:: with SMTP id k13mr5108311lfj.12.1576146606804;
        Thu, 12 Dec 2019 02:30:06 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id r20sm2681371lfi.91.2019.12.12.02.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 02:30:06 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-8-jakub@cloudflare.com> <20191125222958.aaplyw7ebtqs6yyl@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
In-reply-to: <20191125222958.aaplyw7ebtqs6yyl@kafai-mbp>
Date:   Thu, 12 Dec 2019 11:30:05 +0100
Message-ID: <87r219g7ki.fsf@cloudflare.com>
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

This turned out to be more work than I expected, so I've split it out
into a separate series:

https://lore.kernel.org/bpf/20191212102259.418536-1-jakub@cloudflare.com/T/#t

Thanks,
Jakub
