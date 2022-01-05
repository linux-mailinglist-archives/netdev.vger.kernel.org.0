Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3FE485AED
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 22:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244561AbiAEVqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 16:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiAEVqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 16:46:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A05C061245;
        Wed,  5 Jan 2022 13:46:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c3so573987pls.5;
        Wed, 05 Jan 2022 13:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uba1HCQpuOmekSj3LRsy3ldVgNhkDNc6UoMf5GpuTa8=;
        b=pdB9s776K6ta/bdtaPkTbW1VTDTLPGN8Ml4BAb0EeVHUc+W0lt9sjTvSO8o51MZhiw
         opcTOpK/BZFYx+7U6PFUNIbK0lG8lNOxv7oTWpeCkKOJPNgNSf7Jy+AcSIFPCGVNbuVW
         jIxsaWob1BOK+8s+iYK6YTZg8dJJ8WC+un06aoQMdnGzUZBkarI2uuXYBEjhEnjzE6cz
         s+yeysANAORLCYtd8IRd5R9P5/k6/fg2QD28XmIEIgqF6hfLnvUfH70CMlFlkPPzH6cl
         zBL9SLgR9q4nZiVl+wLJQ76FsjsiGTfKlVMmZLAJU5V+oJMRmhDEltOdBtoUwDerazPr
         12Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uba1HCQpuOmekSj3LRsy3ldVgNhkDNc6UoMf5GpuTa8=;
        b=UfH4fbg3/6Tyl+GsZ5uY5ttBCFN9TUbi2z/q4255EJLdDcJLwreE2J2/OrYNqmzPOi
         GbQN9PhKuB+fleEcY0Po9lzMucqgh1F9kXxc9Fq3yjS5CVojiFIduoJhNNKV1Ux0Lk/r
         Zsd24qFf4G+X0Zi29o4RHirQFgpMFZXfojx+Z/vJCzoVYFJyEDB4XGFmaeLAWUdWduKb
         v+YWBPCPd5YkEFS0+cNz1Q+fRusotuXp4WciuJgwSfnZn1T7ZUC6KZzwUFjCUQlzAzPr
         meGsiByGrR61LthiQnu5mZSGA/WIjVicN8F7nuIZ6xp6UWd88bhm5EQ6mhR9PxrtcaSU
         VNHA==
X-Gm-Message-State: AOAM531tYvitld51oEq44fk8DRO+FTWE3H6Z2SVfSKbkTWpS/6RHIRB4
        9URQMLJt0BgJQbHBBBzZYyIhJ6oZzrTleVeg/Ew=
X-Google-Smtp-Source: ABdhPJz49ilVGGIAObcxbnqI1fIBNwxLd1Qks0fE9OPrG2VYLgJ1f8Wo9ZMph4oZKCvXybmmD7NXjF7Eg4GURFk71oE=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr55469992plm.78.1641419175125; Wed, 05
 Jan 2022 13:46:15 -0800 (PST)
MIME-Version: 1.0
References: <20220105210150.GH1559@oracle.com>
In-Reply-To: <20220105210150.GH1559@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 5 Jan 2022 13:46:04 -0800
Message-ID: <CAADnVQ+kSjvwX1dYzp1Jm5AVVtoGm2DXrBOVUAm-iDhPyYO1Zg@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix verifier support for validation of async callbacks
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 1:01 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> Commit bfc6bb74e4 ("bpf: Implement verifier support for validation of
> async callbacks.") added support for BPF_FUNC_timer_set_callback to

abbrev=12 is the standard nowadays.
Also don't break the commit subj into multiple lines.
I've added
Fixes: bfc6bb74e4f1 ("bpf: Implement verifier support for validation
of async callbacks.")
and pushed to bpf-next.
Thanks a lot!
