Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A474141
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfGXWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:10:50 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45353 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfGXWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:10:50 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so42492973eda.12;
        Wed, 24 Jul 2019 15:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RdHLaPegSWHpbCVD6Rb2sUvoKp/0sATC5ZWZNY1uFtg=;
        b=DaR/6NiTz8md+LTAHwNPUt1cGO+IaqVXSKJNWV9ZPQMfygzbyowsoWyUfBJTAZtO/m
         NG5V0jRZl8lfdsosaQekKaeUmXehJWdZhIhnd70JdFRCmVNIzLLv5QcBHG+p59wRnTUw
         gu6YkqaakRRTNDj0FbEeuTbCnqE6/sINfivOGjo+J9dgtSRSW2NafD0Nb78IH+mCRu+N
         hRBRaP/5MGlYTcM2YCWUK1R4lcFVZFdTw87Mohv20aY45HoTXMxSQBMco5ybb0JorRyE
         VxRoy1LPc7s3ZUhxj9dFlM5izoaFlFgRRY1Ey8WOAqNf0oZ+sHgZS0xC0zbiW4SfdpSH
         wIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RdHLaPegSWHpbCVD6Rb2sUvoKp/0sATC5ZWZNY1uFtg=;
        b=NqoLEeY6y6y7Rkihwr+PFCLK+/NSRWDx+ME6MKOk1WofvoeApsKsmGnTPt66KclNTy
         oRizeMeJesyX6HtEtZB15hyU9jw+dnMO5bRccNsH/zBYAVhhaAPbuzKrhEhp1drxo7fK
         LQGBCQT9qnf6lF6TxQ8mBfyoLpLMZoM08e0svyL+pAiOPdyGppJqq9YyWsTi4gljLkUx
         G/+Me1ezO7yrKPmtcN/pYTtOJZVlqK4QehNSsH9vH26eYyyCtodelan2Jg3lV0hGI3Vy
         QfMrgbH+VzPBQEstneG4yvg6zhqYUqgWCAlGwHrBrjTxL311UMFZZCPqgpzH9pprJPwz
         hdDw==
X-Gm-Message-State: APjAAAXyK5Z5nYxvXMAbddDpQh6BLXuB9frLn9SGEkGbnSOL8s3iIYYx
        np7CYCh627aAWr64rdTwWpHywpCsxYNMeskj7vs=
X-Google-Smtp-Source: APXvYqxFOpn1FwlfhvKqBMW2LLCZyoHTrjsfVPhSEDEWas3OPnSZsLulRg+H6D/76E9/iqCQNXrtWNUj0uMphyogSkA=
X-Received: by 2002:a17:906:1108:: with SMTP id h8mr62365385eja.229.1564006248646;
 Wed, 24 Jul 2019 15:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com>
In-Reply-To: <20190724170018.96659-1-sdf@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 18:10:12 -0400
Message-ID: <CAF=yD-+YO-7k_kkCdr1VYYm-JApHvEhS5KVEkMkZ=EHJU4Kdmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/7] bpf/flow_dissector: support input flags
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:11 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> C flow dissector supports input flags that tell it to customize parsing
> by either stopping early or trying to parse as deep as possible.
> BPF flow dissector always parses as deep as possible which is sub-optimal.
> Pass input flags to the BPF flow dissector as well so it can make the same
> decisions.
>
> Series outline:
> * remove unused FLOW_DISSECTOR_F_STOP_AT_L3 flag
> * export FLOW_DISSECTOR_F_XXX flags as uapi and pass them to BPF
>   flow dissector
> * add documentation for the export flags
> * support input flags in BPF_PROG_TEST_RUN via ctx_{in,out}
> * sync uapi to tools
> * support FLOW_DISSECTOR_F_PARSE_1ST_FRAG in selftest
> * support FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL in kernel and selftest
> * support FLOW_DISSECTOR_F_STOP_AT_ENCAP in selftest
>
> Pros:
> * makes BPF flow dissector faster by avoiding burning extra cycles
> * existing BPF progs continue to work by ignoring the flags and always
>   parsing as deep as possible
>
> Cons:
> * new UAPI which we need to support (OTOH, if we need to deprecate some
>   flags, we can just stop setting them upon calling BPF programs)
>
> Some numbers (with .repeat = 4000000 in test_flow_dissector):
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>
> The improvement is around 10%, but it's in a tight cache-hot
> BPF_PROG_TEST_RUN loop.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>

This looks great to me. Thanks, Stan!

Acked-by: Willem de Bruijn <willemb@google.com>
