Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24845AF258
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfIJUio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 16:38:44 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34581 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfIJUio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 16:38:44 -0400
Received: by mail-yb1-f194.google.com with SMTP id u68so6631860ybg.1
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 13:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vAfRQ5R/ff8mrp0d1mB+uOFw3g/C8+BEF4O5VcI23aw=;
        b=Ki3GjWe+nnutVRayxMHjXfQNos6icQSY5FHGX0Vgc9c2V637z3IBXX9fB67IR38ISt
         ae6RXwadN1dwFoVGNWCgz3R5Q4AiJVNl2nPWYyt3Q+CcVCN3jCSPZ7ROxZWg0Vy37Uts
         YwT2KNMahoPiWnQs4Oxj/HQVTy6yDCIYud7efFbkic5U7btETkS1X1ItgVp9ET1/jcsb
         vBHlGjAcCVRW6VYDI/ODSxRdHCXn32U6vfDHCJpidfU4FTnTNcYufWmLynJbkwzeh+GI
         d1apWS8v2ZV74kMsM+m0BLIXzoifbdD+0nYmH+EiD/pd/RDEgnBodu8FGzcixd8PMGcd
         sTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vAfRQ5R/ff8mrp0d1mB+uOFw3g/C8+BEF4O5VcI23aw=;
        b=dLb0RL51vnTTCqOvGXm7fTM2HgFi6z7qxjV5XSZCBPcww8Y4xAdrPhcdj/vfTmgQXi
         S+fmYlkWWsVgh0iWRJTPpTanwHIdeenvrCRiRkOnImXNcoaLVyvkwKQlLNSiiJ7vBqNI
         oKedPN3B2OEpn4eCP4T29+rA4PsIXYGMCPc+Zn2wolxbM4g30Sq34ybXG5ZDDWFXcynG
         61mSZ7NrEe4JtU9lwISykS8UHDAY9ESzyx+red57/cUw0EjiAgJ6clyPNNsv+7gjEmBH
         T6Yrz4tdpo3Ex6+ikwv3EAwYDAvJdxXJDSl4ueiEBRLP2lS+rt5b/V5ainphQqVQgrCN
         uOjQ==
X-Gm-Message-State: APjAAAVvbVTEa2+aOIkD3LW0nlaZyASME5ksLiTs61RBkpBvTnGdQkG4
        FKZucvDxV7PeQpZUTudN3ILELh6nisTV1mTLmWdWQw==
X-Google-Smtp-Source: APXvYqwxir7/w0k/aFoaSNGNjaEwIS1nm3pwLIkUoHX95VutKw8NfmB6NwEW6ZnMZK05u0mkuufedaDYzLm1pxupOOI=
X-Received: by 2002:a25:1f41:: with SMTP id f62mr21116872ybf.518.1568147922987;
 Tue, 10 Sep 2019 13:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190910201128.3967163-1-tph@fb.com>
In-Reply-To: <20190910201128.3967163-1-tph@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Sep 2019 22:38:31 +0200
Message-ID: <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Thomas Higdon <tph@fb.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 10:11 PM Thomas Higdon <tph@fb.com> wrote:
>
>
...
> Because an additional 32-bit member in struct tcp_info would cause
> a hole on 64-bit systems, we reserve a struct member '_reserved'.
...
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index b3564f85a762..990a5bae3ac1 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -270,6 +270,9 @@ struct tcp_info {
>         __u64   tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
>         __u32   tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
>         __u32   tcpi_reord_seen;     /* reordering events seen */
> +
> +       __u32   _reserved;           /* Reserved for future 32-bit member. */
> +       __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
>  };
>

Unfortunately we won't be able to use this hole, because the way the
TCP_INFO works,

The kernel will report the same size after the reserved field is
renamed to something else.

User space code is able to detect which fields are there or not based
on what the kernel
returns for the size of the structure.
