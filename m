Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A32DEFB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfE2N5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:57:16 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42253 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfE2N5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 09:57:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so2141742lfh.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 06:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LbTz9QfJWMgyv4fipzRBw0f6ydNdnq7zYT3VxBkO7bw=;
        b=A61BstyQNVO1ZGVKSMW4cm3LSDOtBJ3QV6vh97I6VMXA9Nlpki5UrBPzWzOK+yH8zM
         5c3UfDzgddlWziH9ItQqY7OQumZZ0YB3twSnR7+b46vNqjUzbbOIhr/EQRpGB+vmiRAd
         iK9CAfYVQYT0q7ZJ1wxbCNE927wohaKCwjmsNCaDCjTJ5zI7sYpGk9LSD7SYLC9/yxnr
         HfV3omXmvv3Pe29YE3PK2sV2c/nRBx14dyPrOjYHIsmIHf2doVnenKZN21Dulsmiyj5r
         1it0p6qPzXt2Ip3GmF8AhkVYvowW1iH59VwcKV2V7S1r5cmlrhN9v4ykBPix/GwBIiIF
         5/xQ==
X-Gm-Message-State: APjAAAWqGTB9a2v9J7bo4RIvhwMkZEtoC1yJawQxpp3PQWwYC/1CXe1B
        ikZGV7fTwk0NnbdauZqAAHE3QZ6Sn8aYAerXyGzQxJ3K7vA=
X-Google-Smtp-Source: APXvYqwxIUsHkLRgSJSLy8LjELq/d72ul/11f5DuEiFmWUrLMbiojVDYC1h6xg985fY5/zaanPScjCxocfbQUwPS8yM=
X-Received: by 2002:ac2:429a:: with SMTP id m26mr3191323lfh.152.1559138229226;
 Wed, 29 May 2019 06:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235844.19360-1-mcroce@redhat.com>
In-Reply-To: <20190528235844.19360-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 29 May 2019 15:56:33 +0200
Message-ID: <CAGnkfhxP0+WAaj4Kip+vuCphp7WnHUGJJMaEtj2xjUrnY253Zg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: avoid indirect calls in L4 checksum calculation
To:     netdev <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 1:58 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> Commit 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up
> indirect calls of builtin") introduces some macros to avoid doing
> indirect calls.
>
> Use these helpers to remove two indirect calls in the L4 checksum
> calculation for devices which don't have hardware support for it.
>
> As a test I generate packets with pktgen out to a dummy interface
> with HW checksumming disabled, to have the checksum calculated in
> every sent packet.
> The packet rate measured with an i7-6700K CPU and a single pktgen
> thread raised from 6143 to 6608 Kpps, an increase by 7.5%
>
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

I found a build error with CONFIG_LIBCRC32C=m:

ld: net/core/skbuff.o: in function `sctp_csum_update':
skbuff.c:(.text+0x2640): undefined reference to `crc32c'
ld: net/core/skbuff.o: in function `__skb_checksum':
(.text+0x2aba): undefined reference to `crc32c'
ld: (.text+0x2cf9): undefined reference to `crc32c'

I have two possible solutions for this:
- use INDIRECT_CALL_1 and leave the SCTP callback called by an indirect pointer
- use IS_BUILTIN(CONFIG_LIBCRC32C) around the sctp_csum_combine usage

I'm more toward the first one, which will also avoid the
net/sctp/checksum.h inclusion.

-- 
Matteo Croce
per aspera ad upstream
