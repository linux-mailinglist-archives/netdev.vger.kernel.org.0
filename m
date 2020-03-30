Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8E1985CC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgC3UrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:47:01 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:44136 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgC3UrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:47:01 -0400
Received: by mail-lf1-f51.google.com with SMTP id j188so15422591lfj.11;
        Mon, 30 Mar 2020 13:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53l9wdyj5G04bO+3AZlnAFgrIS0/NVTKg4yzAGAMqaY=;
        b=V/47aF0xM3xZql7bm2QzWJlCETMnizFZIlsE2cyCXo9Y77UxXJ4roh64mrFsR0ESmi
         1eKNcelkCq4Qtp/JMHiz3ceiS92S8xyaoLe2go3hM66+7wkc/N+f7A37TnwjaOnXaTbi
         B8lk4o+d0YD5InsEoe4Z72wrR7rYTTzag2kgtFV3lUI21cw04X+OcPA7YEB7ZpBgEUqp
         1uC7B2xM9HkSAHhKWL801qNQYvr2QXpTE1XLVUZljeYJ3NickmEm+9MWzNczwMJLjg/N
         2/M2n2trFOOwDDKfQIzWkVByHFZ80dRBBmYGu/U3o8GRiYhzffPXPGM6uoW/JBpoq10M
         O5Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53l9wdyj5G04bO+3AZlnAFgrIS0/NVTKg4yzAGAMqaY=;
        b=TJrlvdx56/qKeEmQJs4bA3aqAX35uzg6ekL7/BI1dqLMvqu+7F8FWajeUWlL7fM81u
         /9FW3j5VcXCVL3Eu+3nRxMmDKYIymil6msELNIbBIxUPc0LgeiMrrI18Uuc0+O8+jMRn
         jFsiJCQshXfPbeRa6n8pXfuaaQbH8XCudsqQopIWeprNTYyWcGmfAPzFQsyJ2/py8tW3
         rYNpwQBSAjBMt/ZFdZx6HZFyf5ydEmdv4/lWBQXosc7uGV73RnxIbEVdq1O0t6K7TBUR
         35pA5Q6W+zLiJyAox0Rn5+OsB9MHk/iTvkvE+W6M3H8DPj3orVHl1Cu0jn7I+zmrSvuF
         l7Bg==
X-Gm-Message-State: AGi0Pua4oMGLn+265sinkSIF32Ds+u4wilPN/G4DidBo9ffst/SkWhpe
        pXNpW65BCGJHKcKbIB2Pc9yMqhOSSK/WjkDHXK0=
X-Google-Smtp-Source: APiQypJttCyKcL/u+sXRGZSpkqaIFrKDoyRw2ozESFpY3dAaa2CTkatOEWbv/Sl5XPjHLjkWT+w56QZA+hBM3cx8m/w=
X-Received: by 2002:a19:7e01:: with SMTP id z1mr9021976lfc.196.1585601218336;
 Mon, 30 Mar 2020 13:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200329225342.16317-1-joe@wand.net.nz>
In-Reply-To: <20200329225342.16317-1-joe@wand.net.nz>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Mar 2020 13:46:47 -0700
Message-ID: <CAADnVQJ5nq-pJcH2z-ZddDUU13-eFH_7M0SdGsbjHy5bCw7aOg@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 3:53 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> Introduce a new helper that allows assigning a previously-found socket
> to the skb as the packet is received towards the stack, to cause the
> stack to guide the packet towards that socket subject to local routing
> configuration. The intention is to support TProxy use cases more
> directly from eBPF programs attached at TC ingress, to simplify and
> streamline Linux stack configuration in scale environments with Cilium.

Applied.
Patches 4 and 5 had warnings:
progs/test_sk_assign.c:79:32: warning: ordered comparison between
pointer and integer ('void *' and '__u32' (aka 'unsigned int'))
        if ((void *)tuple + tuple_len > skb->data_end)
            ~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~

I fixed them up.
