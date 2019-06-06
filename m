Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802513805C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfFFWOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:14:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32900 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729055AbfFFWOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:14:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so115364qtf.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wnCP9LHM/9q0T5YeodyvkG+3NIqd4AJlc0R/psluHCw=;
        b=rkRXhFjoWZ55fC7yOH0kqTaTRrdB3k1BaYHKrXwOKlqO3Lj8E6y/3m1kxlPHJqvDuB
         HNe1HZo/hCsDKBHtjOvQROjpjNuFhCqgVO7E1LX8Q5+Geiicmg9mBwYI+ORkSAoVoy4I
         1ZkXqeaN2WWOdhlzsnngXpW4Ia72ASBbOYQfvxQ+rQFbMv+LQztxgzoK43w8G5eDI9fP
         tucUOZ4RXAh9xTMuR0M2NH9GcDV14lib62h28GA9yhBw2zzDbJEnjjaB+5ihjRKTMKUe
         cbO26PuTtbkDvEHYWS6DX3xlj4q6Ht1GFJ/IshA9ckkHTGXw9/wN9eD+chib8Npf95xN
         9FZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wnCP9LHM/9q0T5YeodyvkG+3NIqd4AJlc0R/psluHCw=;
        b=DGB0itXx93COMMJBgg1hmmTNatKCZ+7UBO/FgGrDixn2MelWgEubiKqr9e3eyhkPbV
         p7SqpDmx9NaNI59+y+8uFL1aXTwPcbC5PrPSGeQKXLV6RREoobBQuS+rDA47lwAqnCED
         ER+UKNzZPIr9d9qjjvFAKoo9Bmq+Dp89LmBNuvlEre+GMcNrhFq/IkJvGVNsUU/zY+jB
         o4MXp57JMPOSm6/cjZ2pi66trhfXwRq61X35h70tacLRI9+YXQhVQVhy2CD4S7UKR1RG
         WwHgZjMWwtE05UGeQ29zlUeFz4kP3mXOUJrIzwwAM1OwQ1qJ4GbQR4O3bP/2GBtbk5aC
         W61A==
X-Gm-Message-State: APjAAAVCyzPy8M339NIQasRNZxnaW8FLkSKiPJ9XYf4pYlP1N00N+Hdy
        FoeDCVOyW3CKQAM5cAB0BAO4Rg==
X-Google-Smtp-Source: APXvYqw1rzC6OTnpZ+39/hsG12pO3JpYun3yNbCTLHGF4Q6Fiw2lxqwEaCapVXUEIan7qToQI0uIKg==
X-Received: by 2002:ac8:2e84:: with SMTP id h4mr42663472qta.267.1559859238493;
        Thu, 06 Jun 2019 15:13:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s23sm187901qtj.56.2019.06.06.15.13.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 15:13:58 -0700 (PDT)
Date:   Thu, 6 Jun 2019 15:13:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matt Mullins <mmullins@fb.com>
Cc:     <hall@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
Message-ID: <20190606151346.6a9ed27e@cakuba.netronome.com>
In-Reply-To: <20190606185427.7558-1-mmullins@fb.com>
References: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
        <20190606185427.7558-1-mmullins@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 11:54:27 -0700, Matt Mullins wrote:
> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
> they do not increment bpf_prog_active while executing.
> 
> This enables three levels of nesting, to support
>   - a kprobe or raw tp or perf event,
>   - another one of the above that irq context happens to call, and
>   - another one in nmi context
> (at most one of which may be a kprobe or perf event).
> 
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")

No comment on the code, but you're definitely missing a sign-off.

> ---
> This is more lines of code, but possibly less intrusive than the
> per-array-element approach.
> 
> I don't necessarily like that I duplicated the nest_level logic in two
> places, but I don't see a way to unify them:
>   - kprobes' bpf_perf_event_output doesn't use bpf_raw_tp_regs, and does
>     use the perf_sample_data,
>   - raw tracepoints' bpf_get_stackid uses bpf_raw_tp_regs, but not
>     the perf_sample_data, and
>   - raw tracepoints' bpf_perf_event_output uses both...

