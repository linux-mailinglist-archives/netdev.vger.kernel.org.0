Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2436F3940C6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhE1KR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236286AbhE1KR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:17:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622196981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MeyHq86FYDiQmED7OBAcxclfCXwOV7n7cri6A9SGbY=;
        b=X7BA7+z8QgdxdzcGc9AhmE6QzTJU/EN+quHxOYpPYwDucX8aTlNWrjQjGzmP+T+3IPtFw5
        9oIRDIJLy41acRa7crFdl6pAoIGuFLOywesapKU6HHM+gVRXam5hcL9haUndNHEmPrl4C0
        yPGSjI50jSQjzHEn+y2wgwBYrkluDU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-jVuwpz2AP6aXM8xrP8ldEQ-1; Fri, 28 May 2021 06:16:19 -0400
X-MC-Unique: jVuwpz2AP6aXM8xrP8ldEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72687801817;
        Fri, 28 May 2021 10:16:17 +0000 (UTC)
Received: from krava (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9709250450;
        Fri, 28 May 2021 10:16:12 +0000 (UTC)
Date:   Fri, 28 May 2021 12:16:11 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
Message-ID: <YLDC6zQUtoITdX4s@krava>
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:56:02AM +0200, Daniel Borkmann wrote:

SNIP

> 
> Ondrej / Paul / Jiri: at least for the BPF tracing case specifically (I haven't looked
> at the rest but it's also kind of independent), the attached fix should address both
> reported issues, please take a look & test.
> 
> Thanks a lot,
> Daniel

> From 5893ad528dc0a0a68933b8f2a81b18d3f539660d Mon Sep 17 00:00:00 2001
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, 28 May 2021 09:16:31 +0000
> Subject: [PATCH bpf] bpf, audit, lockdown: Fix bogus SELinux lockdown permission checks
> 
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> added an implementation of the locked_down LSM hook to SELinux, with the aim
> to restrict which domains are allowed to perform operations that would breach
> lockdown. This is indirectly also getting audit subsystem involved to report
> events. The latter is problematic, as reported by Ondrej and Serhei, since it
> can bring down the whole system via audit:
> 
>   i) The audit events that are triggered due to calls to security_locked_down()
>      can OOM kill a machine, see below details [0].
> 
>  ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
>      when presumingly trying to wake up kauditd [1].
> 
> Fix both at the same time by taking a completely different approach, that is,
> move the check into the program verification phase where we actually retrieve
> the func proto. This also reliably gets the task (current) that is trying to
> install the tracing program, e.g. bpftrace/bcc/perf/systemtap/etc, and it also
> fixes the OOM since we're moving this out of the BPF helpers which can be called
> millions of times per second.

nice idea.. I'll try to reproduce and test

jirka

