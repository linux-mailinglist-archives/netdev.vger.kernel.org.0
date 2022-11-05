Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1909061A74B
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 04:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKEDcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 23:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiKEDcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 23:32:21 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADAF3F066
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 20:32:17 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13be3ef361dso7464125fac.12
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 20:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d4+BKZsVBq8bd37OinE8qYinDnCTidi21Q348dbcKy4=;
        b=KJf7VFwcT+YVVBNAPenxOJu/4YS/diN/7i9W/htsQ/5tp1JZP3DozwpEAf8H3vKkji
         X+4MpscL3xOWpcvrnW84WYjaxxH4M1dlVxGqFNTDB7/8j0psbwj3ED++gWDrVt0kb/vI
         0/vXovGK8MTifQ9ZNiVd8X3v8hAUMfcG3U2FIpiaStJ/mE8jY7akxk4VP7YlX2dBHkkr
         3GH7lVz0SGjhCZF0D3xHRcQ91/dv/46JcqJceZfscVYsw6ttR97xpDyeXmOyNmdI6jA9
         1E0C3IDedFc8hB5ZvCbf9vptfLD2WU8ByXqP3CWwV/IiJN+KuQRxF2mXN+/y+YJWy82S
         fKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d4+BKZsVBq8bd37OinE8qYinDnCTidi21Q348dbcKy4=;
        b=NMLafSYCKI60LRDHhf5R5+jEXLh+EhjH8aCHs1C/e8kvIZc66+OEsG0w+ycjpogOsx
         XKANXYxK5jcE4bz9DuzguajFeUhYpxiHRKCIJ9PLwTcjmMDY8QPMDnEiqD2gW3Bpn/Z9
         n5G7rZdLtUrCFwhKDqMdBXM0xTesLtQaCyJGsb9zArBnhgGoUdWzo3+0JdhkgkAEKUbJ
         NX5wapgALvpPIER7cOiJ4kIHDshAwDYwaq21BCm2Ows+d9tw33R9U0b17jZV3RaG9p1z
         dhzPSbwqxJAeEpz8c/IOx6hwjQe5f+qXMA8Bl1KJZsiR+KXlCNLvUYm/OzbU0KY2nmPZ
         6O/Q==
X-Gm-Message-State: ACrzQf3+3b+NfMcbukOYspb98KODi3Uh/6uQ3R1pcC8v8xSIH5/aDJTL
        2JjI6hgPJLgXrphACkR8HSd8RAaBCl5PAp7zkncn
X-Google-Smtp-Source: AMsMyM4lIjXVS0Uqtg79Zx/856WEPiWU5BfMOAtTf7/NpVC/VL/OBl4Sj6nXaf7IwvrV4SYRLGK5mwnutHnyZ0ovh/M=
X-Received: by 2002:a05:6870:f299:b0:13b:ad21:934d with SMTP id
 u25-20020a056870f29900b0013bad21934dmr23417023oap.172.1667619137195; Fri, 04
 Nov 2022 20:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <166543910984.474337.2779830480340611497.stgit@olly> <c8ce1c62-84ac-f39e-6c4e-5108b55c3515@canonical.com>
In-Reply-To: <c8ce1c62-84ac-f39e-6c4e-5108b55c3515@canonical.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 4 Nov 2022 23:32:05 -0400
Message-ID: <CAHC9VhSfc4sta0t9B-N1fV9CYO2tQUo8-cA3np-tz2AeXUSi1g@mail.gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
To:     John Johansen <john.johansen@canonical.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 5:59 AM John Johansen
<john.johansen@canonical.com> wrote:
> On 10/10/22 14:58, Paul Moore wrote:
> > Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > sockptr_t argument") made it possible to call sk_getsockopt()
> > with both user and kernel address space buffers through the use of
> > the sockptr_t type.  Unfortunately at the time of conversion the
> > security_socket_getpeersec_stream() LSM hook was written to only
> > accept userspace buffers, and in a desire to avoid having to change
> > the LSM hook the commit author simply passed the sockptr_t's
> > userspace buffer pointer.  Since the only sk_getsockopt() callers
> > at the time of conversion which used kernel sockptr_t buffers did
> > not allow SO_PEERSEC, and hence the
> > security_socket_getpeersec_stream() hook, this was acceptable but
> > also very fragile as future changes presented the possibility of
> > silently passing kernel space pointers to the LSM hook.
> >
> > There are several ways to protect against this, including careful
> > code review of future commits, but since relying on code review to
> > catch bugs is a recipe for disaster and the upstream eBPF maintainer
> > is "strongly against defensive programming", this patch updates the
> > LSM hook, and all of the implementations to support sockptr_t and
> > safely handle both user and kernel space buffers.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> looks good to me

Thanks.  I just merged this into lsm/next.

> Acked-by: John Johansen <john.johansen@canonical.com>

-- 
paul-moore.com
