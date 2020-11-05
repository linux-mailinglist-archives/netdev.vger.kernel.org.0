Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE32D2A7B09
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgKEJxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:53:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726715AbgKEJxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604569985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v68pTldC72rGzl0v43axscm9I8YxwT4eCi9uwDHXezc=;
        b=YqfpxteirtXvxztPsjenhZr5G0ew8YPgne8XwtthaME9zNg3zekMFS4DCBhtqD5zroMPdk
        rFYbOjibaLyi57S3KCcShHr5mZR5cGRnMMDMGVjol9zs1H3Bi7qzBdwrmwkW2F+LldVQ95
        7I68hNJAYB8n6gTj9PJDhFi1eEwwyU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-VANGFFfwPJiGu4rGYch0BA-1; Thu, 05 Nov 2020 04:53:02 -0500
X-MC-Unique: VANGFFfwPJiGu4rGYch0BA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DC3310B9CAB;
        Thu,  5 Nov 2020 09:53:01 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93F54508E8;
        Thu,  5 Nov 2020 09:52:55 +0000 (UTC)
Date:   Thu, 5 Nov 2020 10:52:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     brouer@redhat.com, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ast@fb.com>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Anton Protopopov <aspsk2@gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] libbpf: split BTF support
Message-ID: <20201105105254.27c84b78@carbon>
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 20:33:50 -0800
Andrii Nakryiko <andrii@kernel.org> wrote:

> This patch set adds support for generating and deduplicating split BTF. This
> is an enhancement to the BTF, which allows to designate one BTF as the "base
> BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> kernel module BTF), which are building upon and extending base BTF with extra
> types and strings.
> 
> Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> with continuous and transparent numbering scheme. This allows all the existing
> users of BTF to work correctly and stay agnostic to the base/split BTFs
> composition.  The only difference is in how to instantiate split BTF: it
> requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> or btf__parse_xxx_split() "constructors" explicitly.
> 
> This split approach is necessary if we are to have a reasonably-sized kernel
> module BTFs. By deduping each kernel module's BTF individually, resulting
> module BTFs contain copies of a lot of kernel types that are already present
> in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
> kernel configuration with 700 modules built, non-split BTF approach results in
> 115MBs of BTFs across all modules. With split BTF deduplication approach,
> total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> around 4MBs). This seems reasonable and practical. As to why we'd need kernel
> module BTFs, that should be pretty obvious to anyone using BPF at this point,
> as it allows all the BTF-powered features to be used with kernel modules:
> tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.

I love to see this work going forward.

My/Our (+Saeed +Ahern) use-case is for NIC-driver kernel modules.  I
want drivers to define a BTF struct that describe a meta-data area that
can be consumed/used by XDP, also available during xdp_frame to SKB
transition, which happens in net-core. So, I hope BTF-IDs are also
"available" from core kernel code?

 
> This patch set is a pre-requisite to adding split BTF support to pahole, which
> is a prerequisite to integrating split BTF into the Linux kernel build setup
> to generate BTF for kernel modules. The latter will come as a follow-up patch
> series once this series makes it to the libbpf and pahole makes use of it.
> 
> Patch #4 introduces necessary basic support for split BTF into libbpf APIs.
> Patch #8 implements minimal changes to BTF dedup algorithm to allow
> deduplicating split BTFs. Patch #11 adds extra -B flag to bpftool to allow to
> specify the path to base BTF for cases when one wants to dump or inspect split
> BTF. All the rest are refactorings, clean ups, bug fixes and selftests.
> 
> v1->v2:
>   - addressed Song's feedback.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

