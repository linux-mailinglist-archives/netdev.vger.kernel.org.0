Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C8011EE95
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLMXfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:35:17 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37241 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMXfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:35:16 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so489239lfc.4;
        Fri, 13 Dec 2019 15:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63IWEeuSsZHeUVAZEAxoUgEaODyj0dbfa078QCT9/og=;
        b=d/paQDTQYVyzAYJ2AkL2jt0q++QRNDylOOpjcP8tDw+PxKPKgppkg6YcQPcaCATtj2
         VqvfGt1mHMtkYuiY+tAI8lfFr4Svieh8WbV6dw8uf7B0yrvbFM6Mr2USA3v6LhCajInM
         LK19H4C9IPzhTSYk22rrImlZICbymonFIuYS+6MwWb4WTQC4slvQNCCbHv/AUQvD7kJG
         igIZtKDKFoLxkKmz4bIvH9cDZ9tUTnY4QCtjk6hLFM18UfyC4cogC3MREO9OComY+w/g
         Xq7d++B+bPCXmjEqtSyhJnXdZvKi9GvoHnPMmRldCHrPQ+a6896ZkGmKp6dWEwVzUzzr
         zAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63IWEeuSsZHeUVAZEAxoUgEaODyj0dbfa078QCT9/og=;
        b=EGlKKMm6zDmsr9OqIJvyyXcNWtQCY+j0BNoh7DFdw2oOQ6zphbcRO9dDie8IFcunkN
         Y9fNOWLVnkehJH4R9Qo8WsLOPZQZlg7oDoCU777jPNXMRGV2sjD5IbWwLB1/GjyBIwB6
         jrFW1Jp4AC4Sa02taWlVzmit+FYAOAVU04jPLU4QwlBhuTipGFekzxQx/YJRQSa5Q8Wr
         h4wtSHFA/3gOn9LHNtwqyw3jj/xuPKokBMkOJ9bLh7sNV5nUWY20k59ELJq6UDRhKCaR
         n3ipOdoBRM8CqldPBAuQ8ygncVcEeNS0rZiCTqGBXICIMFHJD4I/lBOwoNl+3+PEyVpw
         CuJA==
X-Gm-Message-State: APjAAAUGSEf50a6SpqN614ggHqUoMHJUuMCFq/0RQ0SZGnwHbtKXlqxf
        Y4TS3p1in5Hb5pP48Z1px5gvOj09BipHSMICVvA=
X-Google-Smtp-Source: APXvYqzocSuJNeeMMXcVOzLrSi58tRGuQ/QqPMvfblIXKdQk3fpuFTo05KadDELFI/MQEcsWm3wC4Y/0ux8pQXi5oEo=
X-Received: by 2002:a19:48c5:: with SMTP id v188mr10410708lfa.100.1576280114245;
 Fri, 13 Dec 2019 15:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20191213223028.161282-1-sdf@google.com>
In-Reply-To: <20191213223028.161282-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 15:34:59 -0800
Message-ID: <CAADnVQJMc6LVUGG-sgQ_i7VDhy7tcnS-SyuXmkwkpuEYT-thqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: expose __sk_buff wire_len/gso_segs
 to BPF_PROG_TEST_RUN
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 2:30 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
> gso_segs is capped by GSO_MAX_SEGS.
>
> v2:
> * set wire_len to skb->len when passed wire_len is 0 (Alexei Starovoitov)
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Now works. Applied.
