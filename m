Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF7135E85
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 17:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgAIQny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 11:43:54 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39713 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgAIQny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 11:43:54 -0500
Received: by mail-lj1-f195.google.com with SMTP id l2so7953732lja.6;
        Thu, 09 Jan 2020 08:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LstMW2CeiYcPoqZkf4bg1xOXdmhfKRp00gDByJT6DSE=;
        b=kltnbXuntI/H/jDYjgovcp6nWBDQMzX3eS+ZtOdRWXZHypHJmK7SvjMAjrq0Zshk4z
         4QfdSdx/X28cHxEFSMGwFmz9CqFZlJOF7L3jFxQTs/wu3y3efGmBHC+R8Ecd2YKotN59
         y5sCmzGWO8rNlPfiOpq/TLswVJ57CcHyRcR1hxixohmyKOmSZpvSorYVh3fMSE5jSqn2
         NfwfS561T0wPWD3JMJz2kBp1P8LzBDeaYbQj5x0jkAEopP469ZoXhal47MOK12NtvYdL
         pXOO/JZNulPWw0ym+LN08w0zw4ONdkt6CW4EoD23WabPHFRzM8ktNYnF58mFcW0Z0uhc
         vwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LstMW2CeiYcPoqZkf4bg1xOXdmhfKRp00gDByJT6DSE=;
        b=gaLJeF7955HVI6E9iuDzx5J7oGWHAo7lulgZ6lLxS8OoY7jqktfj2+vDTWcxXy3mIx
         Pkz2sf9hiTwMw388lyUWDwBegcSZ0CQLGJrCqXB5GBjAHGmrzDz1Ll+PuOSMiZiG6wNL
         eU+SY2R88ffBSzDHFr+EB7L3Rlojsn6E38CxvOFGL2k3dOg2rkfQhlprMK8+LNXPv5ZH
         SBA0tkn3DroGBfUVJYXELieiKzAf4yCaq2OKPifEr0DLg4tb4rrE8/CHrMyeHxv/Mp5M
         vKVeNzYpKwRlDC0QHhVstrwW58VcYBGinVBEqVbPj0k69nUHtgJWSww+8Q2fqUrhiy67
         NxOQ==
X-Gm-Message-State: APjAAAXHCOkATmzLBNX7DD3XqpHXxiXq4E3kqQoAI1ZYsvPNtkmR1qPN
        Wro8kDywMAFasxb0do8meqt0lgYpvhItemws1h4=
X-Google-Smtp-Source: APXvYqwBiTR85br0hmaAJGwV0RxrMee7f0r77b5ZsIRyEDGgSErSKU8WL1jR1AcYkwFujc2mwtkGEZVb1RGcu+HEWM4=
X-Received: by 2002:a2e:9cd8:: with SMTP id g24mr7014355ljj.243.1578588231956;
 Thu, 09 Jan 2020 08:43:51 -0800 (PST)
MIME-Version: 1.0
References: <20200108192132.189221-1-sdf@google.com>
In-Reply-To: <20200108192132.189221-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jan 2020 08:43:40 -0800
Message-ID: <CAADnVQJX9b22SuzgPoMUjyaeUaJA2cvgybZ-KhYHEWKfi_FV7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: restore original comm in test_overhead
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 11:21 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> test_overhead changes task comm in order to estimate BPF trampoline
> overhead but never sets the comm back to the original one.
> We have the tests (like core_reloc.c) that have 'test_progs'
> as hard-coded expected comm, so let's try to preserve the
> original comm.
>
> Currently, everything works because the order of execution is:
> first core_recloc, then test_overhead; but let's make it a bit
> future-proof.
>
> Other related changes: use 'test_overhead' as new comm instead of
> 'test' to make it easy to debug and drop '\n' at the end.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
