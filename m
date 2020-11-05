Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE242A82ED
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbgKEQCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:02:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgKEQCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604592130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7n7s4CcoYzzsxrI8cFoyqhkSkqzPJ3hlumXdPdudtBo=;
        b=iSv1eKCQKplQMYaWHMJtdj8Nd3oDCM46JEAmI+PL8pzxjFtlc0k8xh4Y1QZNA90chMF/i+
        6uuR8chXikz+FCz/OyYUrUgbd7g+9mbrdGPnUWAlzXPOBhJ/MTg7aJuYn4uvVCyr0U6vAs
        +eowsjNkX55SD5F4TqoN4yOrGOaTDVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-H73a57wPO3e0W5f99H6hxw-1; Thu, 05 Nov 2020 11:02:07 -0500
X-MC-Unique: H73a57wPO3e0W5f99H6hxw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4324E10866AD;
        Thu,  5 Nov 2020 16:02:06 +0000 (UTC)
Received: from localhost (unknown [10.40.192.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E2195B4CA;
        Thu,  5 Nov 2020 16:02:04 +0000 (UTC)
Date:   Thu, 5 Nov 2020 17:02:02 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201105170202.5bb47fef@redhat.com>
In-Reply-To: <20200423195850.1259827-1-andriin@fb.com>
References: <20200423195850.1259827-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 12:58:50 -0700, Andrii Nakryiko wrote:
> To make BPF verifier verbose log more releavant and easier to use to debug
> verification failures, "pop" parts of log that were successfully verified.
> This has effect of leaving only verifier logs that correspond to code branches
> that lead to verification failure, which in practice should result in much
> shorter and more relevant verifier log dumps. This behavior is made the
> default behavior and can be overriden to do exhaustive logging by specifying
> BPF_LOG_LEVEL2 log level.

This patch broke the test_offload.py selftest:

[...]
Test TC offloads work...
FAIL: Missing or incorrect message from netdevsim in verifier log
[...]

The selftest expects to receive "[netdevsim] Hello from netdevsim!" in
the log (coming from nsim_bpf_verify_insn) but that part of the log is
cleared by bpf_vlog_reset added by this patch.

How can this be fixed? The log level 1 comes from the "verbose" keyword
passed to tc, I don't think it should be increased to 2.

On a related note, the selftest had to start failing after this commit.
It's a bit surprising it did not get caught, is there a bug somewhere
in the test matrix?

Thanks,

 Jiri

