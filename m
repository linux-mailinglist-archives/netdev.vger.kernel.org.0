Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936943ADB00
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhFSRCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 13:02:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35076 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhFSRCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 13:02:44 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624122031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0WuIzDMWF99bBZuLNCq2ygkfH35IcPVOSY6Jg7e+OI=;
        b=zWzKICElodmiWYNyww0vsbIf5K1JIwRn9+v/TR+PlrsUkchd2PKtD5ng6LpeFgbgsTCKw4
        GBwmGVSPosDKlhUUBZWSNx6e7wz2eqzwKRj1CuthEf+l1vTDYf3U+Y7Xu9kTG+70DBDmlK
        Bk6Dco+InfRE+z5QGnIXhU31JJXAS+rcpcEninckSnnpG0svX6TEdlrLdqMEQTZMVfly3x
        9TxzUOm6mtr/EJi67HqlweKY04sNhwUhk8rFZHANb9cX23E1VUNpFGkNaiwqoMfPsIyG8B
        kcgTJwMUfiPDmBVazSTYhENptpnSjrZ1yRGnj0brteKWvQfemy8H9dbCFDc8/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624122031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0WuIzDMWF99bBZuLNCq2ygkfH35IcPVOSY6Jg7e+OI=;
        b=yGz+IcnIfKBafxps3sdFRFstTzITkh1lKwhIXMPHyEs4gwR741lmdzOnbFnqgotz0a8XG7
        K3OHwMhzVPurVVAg==
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-serial@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v3] lockdown,selinux: fix wrong subject in some SELinux lockdown checks
In-Reply-To: <20210616085118.1141101-1-omosnace@redhat.com>
References: <20210616085118.1141101-1-omosnace@redhat.com>
Date:   Sat, 19 Jun 2021 19:00:30 +0200
Message-ID: <8735tdiyc1.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16 2021 at 10:51, Ondrej Mosnacek wrote:
> diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
> index bda73cb7a044..c43a13241ae8 100644
> --- a/arch/x86/mm/testmmiotrace.c
> +++ b/arch/x86/mm/testmmiotrace.c
> @@ -116,7 +116,7 @@ static void do_test_bulk_ioremapping(void)
>  static int __init init(void)
>  {
>  	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
> -	int ret = security_locked_down(LOCKDOWN_MMIOTRACE);
> +	int ret = security_locked_down(current_cred(), LOCKDOWN_MMIOTRACE);

I have no real objection to those patches, but it strikes me odd that
out of the 62 changed places 58 have 'current_cred()' and 4 have NULL as
argument.

I can't see why this would ever end up with anything else than
current_cred() or NULL and NULL being the 'special' case. So why not
having security_locked_down_no_cred() and make current_cred() implicit
for security_locked_down() which avoids most of the churn and just makes
the special cases special. I might be missing something though.

Thanks,

        tglx
