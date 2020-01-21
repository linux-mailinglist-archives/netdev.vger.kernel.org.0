Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E68144474
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 19:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgAUSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 13:41:09 -0500
Received: from mail-il1-f182.google.com ([209.85.166.182]:39260 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbgAUSlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 13:41:09 -0500
Received: by mail-il1-f182.google.com with SMTP id x5so3159888ila.6;
        Tue, 21 Jan 2020 10:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4hImh0lN6L2AhaZTettiazMByg/BI831oI8Z7iuAMe4=;
        b=jObKSn7eLAdwHDZDA/qjW0rk1f+0iPq4m0FrKQCAe0Ro9sfTTKyKT5Q5HeQ8jmuVNd
         FIzYcf7iL9kanjymydPTwHawqKVVEGEGT+xHA9QgHek+6UeUnMy19hp+KptP0emfkree
         4yIEDktNHI304oMNUkOZ0HwmZt1wAuCNM2dCaSgVtjeiCB9P+BGyov/AeU/d0J/POAwP
         a3JtEFApzstt+01rMmAqdFJ9Y740nd5lt67upUeopt64PE4igSj9FEuUmeTbr518y9lz
         i/0OEAcCK2rWZjuKhzqcA8A6xYjwD7+MmX9OH0qPSiYYjar3mizDum3wIJ2lC9aqM43D
         xROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4hImh0lN6L2AhaZTettiazMByg/BI831oI8Z7iuAMe4=;
        b=uhg67JSr8nLzeC7GRvs0pTqvFmjGxLESRMo0vLXYc2wg0zZshx6Z9R+RvOJ7rLnfSZ
         VyJyb3nbvzhuEXNrf3xVp0gObs1yvgSjJBCuQowW9s3oROdXi59a0BS++3bm2zZ+1Bt0
         OfZfs6ahKUuQanfw44jETxjnlJTW9ApXfgwvjTwjYy6hpUDONCdHjXinkFvzZUh6Ghuv
         mccp3ZVo65pzG1c+NOjiVvrPSe7QhW5CHt2HohdzE1NweaWCrGMBfH5Kigj3JHfPXI84
         xt9dTo92Gdeve8+1VFEw17s24iTm/hOUpex4SWu58RavxmxfjD/E4adkALLKGWfqwmtG
         aGsw==
X-Gm-Message-State: APjAAAU2k2vRGR5Q6AUct9Gj2JY9Ovh3mKer/a97u5xgbdNxqda+ZgIW
        2xHxA7vIsY0z/4sYE10p608=
X-Google-Smtp-Source: APXvYqxwsc9yHPq0z2tcKjpuzl3oNwEnmDk8DnCBpdhrea+MphQcD/qTiOFyz4TamgNzlhVR8okVJg==
X-Received: by 2002:a05:6e02:78a:: with SMTP id q10mr4336597ils.253.1579632068778;
        Tue, 21 Jan 2020 10:41:08 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x13sm9716915ioj.80.2020.01.21.10.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 10:41:08 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:41:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5e2745bccbf37_74b42ad14ee465c044@john-XPS-13-9370.notmuch>
In-Reply-To: <20200121005348.2769920-4-ast@kernel.org>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-4-ast@kernel.org>
Subject: RE: [PATCH v2 bpf-next 3/3] selftests/bpf: Add tests for program
 extensions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> Add program extension tests that build on top of fexit_bpf2bpf tests.
> Replace three global functions in previously loaded test_pkt_access.c program
> with three new implementations:
> int get_skb_len(struct __sk_buff *skb);
> int get_constant(long val);
> int get_skb_ifindex(int val, struct __sk_buff *skb, int var);
> New function return the same results as original only if arguments match.
> 
> new_get_skb_ifindex() demonstrates that 'skb' argument doesn't have to be first
> and only argument of BPF program. All normal skb based accesses are available.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 20 ++++++-
>  .../selftests/bpf/progs/fexit_bpf2bpf.c       | 57 +++++++++++++++++++
>  .../selftests/bpf/progs/test_pkt_access.c     |  8 ++-
>  3 files changed, 83 insertions(+), 2 deletions(-)

Acked-by: John Fastabend <john.fastabend@gmail.com>
