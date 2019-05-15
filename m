Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470711F72F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfEOPL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:11:26 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:35353 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfEOPLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 11:11:25 -0400
Received: by mail-oi1-f172.google.com with SMTP id a132so42020oib.2
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 08:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3NoCXueKsAI2+4kycfY7uvfN1L740AYv9J3U5pgxWIk=;
        b=jAh0kk+8gLrlvgEXShcnqr0rstKFhgGsiKwugYF4AhFNyeNZ1BtOd+1hZgjMOjMBPa
         v6stJYN2BQJRuBIhVTpg8EBHMFFHC8+v2BIf++si3j1+AN5CmgNwayXL2HLlO42QuPj/
         I1VKW6yq4v1fbYQ6jgYfD4lV9+rGjqq0k732s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3NoCXueKsAI2+4kycfY7uvfN1L740AYv9J3U5pgxWIk=;
        b=K8ZYWJ4vz+Ophsbz4WowXapdeGTTUAvee5y/iNbr6zbIvqF15JFBYXE410B7xQhlS5
         aiOXhgc5ey//Nffpu3oeO1gCrK89iJLmKhN/qEKsu6R9UOkxllOP2xEVLeu5bJahAPP/
         OrVB43W8JySMT/HY6vitxgcyySQ2KGPWI4h8jS2/l4gKh+y1izSpMxV/u8yHW3pXaCHa
         LszpYyIyumCyPSc50jAjg+cQFJPQbjmq1LzW178ng1EWejSgaVL5fUPFnpe0fv4Q5sVV
         4YzPJczkraeB074AlrVeP008KLRpMS5Cc5DAcTwHBiy2Bas5MZBV3kw3X33XHJspl6gu
         vnHQ==
X-Gm-Message-State: APjAAAX8sVvocf2NdDBBzhYJBdVYJRkMklM77oAhPDtF8niWO3tOv8rd
        3gOeLocml3mGZJxOwZ5BVgqeckasRWa1By3r5h1+sEA8ryRhxw==
X-Google-Smtp-Source: APXvYqyi9G1HMN9f5BdZcjC/P5ryJJTq1yAT0Q94r0BzaKZmCNpee9Vw6NcX/mPlzQhJRum44jp/6Z3kcAioHlki1hk=
X-Received: by 2002:aca:f0f:: with SMTP id 15mr73559oip.78.1557933084276; Wed,
 15 May 2019 08:11:24 -0700 (PDT)
MIME-Version: 1.0
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 15 May 2019 16:11:13 +0100
Message-ID: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
Subject: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
To:     Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org
Cc:     Joe Stringer <joe@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
that the sk_lookup_* helpers currently return inconsistent results if
SK_REUSEPORT programs are in play.

SK_REUSEPORT programs are a hook point in inet_lookup. They get access
to the full packet
that triggered the look up. To support this, inet_lookup gained a new
skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
program is skipped and instead the socket is selected by its hash.

The first problem is that not all callers to inet_lookup from BPF have
an skb, e.g. XDP. This means that a look up from XDP gives an
incorrect result. For now that is not a huge problem. However, once we
get sk_assign as proposed by Joe, we can end up circumventing
SK_REUSEPORT.

At the conference, someone suggested using a similar approach to the
work done on the flow dissector by Stanislav: create a dedicated
context sk_reuseport which can either take an skb or a plain pointer.
Patch up load_bytes to deal with both. Pass the context to
inet_lookup.

This is when we hit the second problem: using the skb or XDP context
directly is incorrect, because it assumes that the relevant protocol
headers are at the start of the buffer. In our use case, the correct
headers are at an offset since we're inspecting encapsulated packets.

The best solution I've come up with is to steal 17 bits from the flags
argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
the offset itself.

Thoughts?

1: http://vger.kernel.org/bpfconf2019.html#session-7
-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
