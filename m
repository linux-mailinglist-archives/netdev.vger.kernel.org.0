Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333C1382A74
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhEQLB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbhEQLB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:01:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB482C061573;
        Mon, 17 May 2021 04:00:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FkGPL2v7fz9sRK;
        Mon, 17 May 2021 21:00:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1621249208;
        bh=2Y30Sqquhl/9Xg91SIhYLicrc/NfN9wZV7c3dBixuaM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VI5JgnrgZ4xyeV2fG6OMRkRLi9t+nx0yM9RE5QaorROoFyOWMK4Ia15ckRi54qvrV
         M+w6tLOpjdtpqYyR1YjTNAeSnVWRR5RIXgDzrQsPQt1nWa9Y9ev6r0llmCCwpRp9u5
         tukI4W67KVjdGfCTlUB5kG8MvJKR3kFs+hSRt4D/EmpGx3efFAQOpCyG2JyaKPFkMy
         t9NVJ2TggtS98H21zmNkHIxEfdtrweokHsKipNrE4CwK0s04IJEEuV0a8YFGlXvec8
         FIQmJTzYp/lViFdUAP3QE4RTv9nQWCfzHBBAdqoMSj7x75+zdb+N43yN/oAtcQOUQd
         lnqc/+sEjPGQA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
In-Reply-To: <20210517092006.803332-1-omosnace@redhat.com>
References: <20210517092006.803332-1-omosnace@redhat.com>
Date:   Mon, 17 May 2021 21:00:04 +1000
Message-ID: <87o8d9k4ln.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ondrej Mosnacek <omosnace@redhat.com> writes:
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> lockdown") added an implementation of the locked_down LSM hook to
> SELinux, with the aim to restrict which domains are allowed to perform
> operations that would breach lockdown.
>
> However, in several places the security_locked_down() hook is called in
> situations where the current task isn't doing any action that would
> directly breach lockdown, leading to SELinux checks that are basically
> bogus.
>
> Since in most of these situations converting the callers such that
> security_locked_down() is called in a context where the current task
> would be meaningful for SELinux is impossible or very non-trivial (and
> could lead to TOCTOU issues for the classic Lockdown LSM
> implementation), fix this by modifying the hook to accept a struct cred
> pointer as argument, where NULL will be interpreted as a request for a
> "global", task-independent lockdown decision only. Then modify SELinux
> to ignore calls with cred == NULL.
>
> Since most callers will just want to pass current_cred() as the cred
> parameter, rename the hook to security_cred_locked_down() and provide
> the original security_locked_down() function as a simple wrapper around
> the new hook.
>
> The callers migrated to the new hook, passing NULL as cred:
> 1. arch/powerpc/xmon/xmon.c
>      Here the hook seems to be called from non-task context and is only
>      used for redacting some sensitive values from output sent to
>      userspace.

It's hard to follow but it actually disables interactive use of xmon
entirely if lockdown is in confidentiality mode, and disables
modifications of the kernel in integrity mode.

But that's not really that important, the patch looks fine.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
