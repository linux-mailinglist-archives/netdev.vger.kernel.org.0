Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48ACDEE4B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfJUNs0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Oct 2019 09:48:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47009 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfJUNsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 09:48:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so8460517pfg.13;
        Mon, 21 Oct 2019 06:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Lm0hZL1wyztt3hWk0T5URQ4B1o3nLfonDMHZ9hkUMc=;
        b=emgfxJCWOqZb8kZhrjRTxQXZFdplMN5gKA+OJGcLLss0yLMcHi68zK6RxYoC37E+S3
         ON5i7tpgn2U/dzeqWfXVX9scx4RV/GoXTa1LPnqfnQivzZVXo6QDBUIxc2AbK6kIgzr0
         UfczoX/cijShGfh8sS0lG+NgQ1LcHW+RR3I3mdjq1ILrq3oTLI0NE9bK+ryySVQPuIRj
         wGj5lNU2DFJVvsu727r8TUBkqhz/M6qbzJvPG3Iiucp3VrjSQgeVbP4ejlAcgDuMh/Wm
         w8i6cSvL+01SpmhLGnlwIyvmTnjZraHEYSa7DwlF+glx1/ggPrfiyF+fJrTh/rcsYrU9
         0Hwg==
X-Gm-Message-State: APjAAAWnuIXv8hMaRAB0M92/4QdIiu50HwhPGG2Kyx8Nj+rjxxaj+j1M
        41FQdBa9ijbcbL+L6N48RVg=
X-Google-Smtp-Source: APXvYqzL9dlx2FQCFLlR12fRlfcYHt97NCWtrpGNTj/S31/M83EEevzMhJ/jTywCZFuANFY8EXWVNA==
X-Received: by 2002:a63:1262:: with SMTP id 34mr25905665pgs.269.1571665704647;
        Mon, 21 Oct 2019 06:48:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:ce:e1dd:ac50:4a18:2864? ([2601:647:4000:ce:e1dd:ac50:4a18:2864])
        by smtp.gmail.com with ESMTPSA id p88sm15211395pjp.22.2019.10.21.06.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 06:48:23 -0700 (PDT)
Subject: Re: [RFC PATCH 1/2] block: add support for redirecting IO completion
 through eBPF
To:     Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     linux-block@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>, hare@suse.com,
        osandov@fb.com, ming.lei@redhat.com, damien.lemoal@wdc.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20191014122833.64908-1-houtao1@huawei.com>
 <20191014122833.64908-2-houtao1@huawei.com>
 <CAADnVQ+UJK41VL-epYGxrRzqL_UsC+X=J8EXEn2i8P+TPGA_jg@mail.gmail.com>
 <84032c64-8e5e-6ad1-63ea-57adee7a2875@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <737d9d3f-e72c-ac31-6b2a-997202a302bd@acm.org>
Date:   Mon, 21 Oct 2019 06:48:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <84032c64-8e5e-6ad1-63ea-57adee7a2875@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 6:42 AM, Hou Tao wrote:
> Your suggestion is much simpler, so there will be no need for adding a new
> program type, and all things need to be done are adding a raw tracepoint,
> moving bpf_ccpu into struct request, and letting a BPF program to modify it.

blk-mq already supports processing completions on the CPU that submitted
a request so it's not clear to me why any changes in the block layer are
being proposed for redirecting I/O completions?

Thanks,

Bart.

