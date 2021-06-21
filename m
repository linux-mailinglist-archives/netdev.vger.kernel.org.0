Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25A03AE500
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhFUIh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:37:59 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:57814 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFUIh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:37:59 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BAFED80004E;
        Mon, 21 Jun 2021 10:35:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 10:35:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 21 Jun
 2021 10:35:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 249D031803E8; Mon, 21 Jun 2021 10:35:39 +0200 (CEST)
Date:   Mon, 21 Jun 2021 10:35:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
CC:     <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        <selinux@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <x86@kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-cxl@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v3] lockdown,selinux: fix wrong subject in some SELinux
 lockdown checks
Message-ID: <20210621083539.GY40979@gauss3.secunet.de>
References: <20210616085118.1141101-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210616085118.1141101-1-omosnace@redhat.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:51:18AM +0200, Ondrej Mosnacek wrote:
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
> To fix this, add an explicit struct cred pointer argument to
> security_lockdown() and define NULL as a special value to pass instead
> of current_cred() in such situations. LSMs that take the subject
> credentials into account can then fall back to some default or ignore
> such calls altogether. In the SELinux lockdown hook implementation, use
> SECINITSID_KERNEL in case the cred argument is NULL.
> 
> Most of the callers are updated to pass current_cred() as the cred
> pointer, thus maintaining the same behavior. The following callers are
> modified to pass NULL as the cred pointer instead:
> 1. arch/powerpc/xmon/xmon.c
>      Seems to be some interactive debugging facility. It appears that
>      the lockdown hook is called from interrupt context here, so it
>      should be more appropriate to request a global lockdown decision.
> 2. fs/tracefs/inode.c:tracefs_create_file()
>      Here the call is used to prevent creating new tracefs entries when
>      the kernel is locked down. Assumes that locking down is one-way -
>      i.e. if the hook returns non-zero once, it will never return zero
>      again, thus no point in creating these files. Also, the hook is
>      often called by a module's init function when it is loaded by
>      userspace, where it doesn't make much sense to do a check against
>      the current task's creds, since the task itself doesn't actually
>      use the tracing functionality (i.e. doesn't breach lockdown), just
>      indirectly makes some new tracepoints available to whoever is
>      authorized to use them.
> 3. net/xfrm/xfrm_user.c:copy_to_user_*()
>      Here a cryptographic secret is redacted based on the value returned
>      from the hook. There are two possible actions that may lead here:
>      a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the
>         task context is relevant, since the dumped data is sent back to
>         the current task.
>      b) When adding/deleting/updating an SA via XFRM_MSG_xxxSA, the
>         dumped SA is broadcasted to tasks subscribed to XFRM events -
>         here the current task context is not relevant as it doesn't
>         represent the tasks that could potentially see the secret.
>      It doesn't seem worth it to try to keep using the current task's
>      context in the a) case, since the eventual data leak can be
>      circumvented anyway via b), plus there is no way for the task to
>      indicate that it doesn't care about the actual key value, so the
>      check could generate a lot of "false alert" denials with SELinux.
>      Thus, let's pass NULL instead of current_cred() here faute de
>      mieux.
> 
> Improvements-suggested-by: Casey Schaufler <casey@schaufler-ca.com>
> Improvements-suggested-by: Paul Moore <paul@paul-moore.com>
> Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

For the xfrm part:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

