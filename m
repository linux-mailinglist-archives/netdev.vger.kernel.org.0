Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB5EAD55
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfJaKWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:22:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727338AbfJaKWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572517358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2k3svT9De3L0lWfpdoQdAnva/hB6fqGWLxfhXOerFXU=;
        b=HQRmrPHilJCK7AfovC/QgKJYaKnJMerniIm4zzTDxrHN6OpaagY1DfL7KZ+6+aQAekBmmM
        qIrMphjBS0vRI7ea5HljL9Kjj/SqdLqTcQ331BuLO9YaqjygSb8ct9RA3VBEIigaLuE45m
        TAg8H3zicRdVFLhAZfTkmVVc3EQQdko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-5VX4BvhyN1SeqyjhNAg0ow-1; Thu, 31 Oct 2019 06:22:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78E791800D56;
        Thu, 31 Oct 2019 10:22:32 +0000 (UTC)
Received: from krava (unknown [10.40.205.171])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7CAFC5E24A;
        Thu, 31 Oct 2019 10:22:30 +0000 (UTC)
Date:   Thu, 31 Oct 2019 11:22:29 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix bpf jit kallsym access
Message-ID: <20191031102229.GA2794@krava>
References: <20191030233019.1187404-1-ast@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191030233019.1187404-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 5VX4BvhyN1SeqyjhNAg0ow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 04:30:19PM -0700, Alexei Starovoitov wrote:
> Jiri reported crash when JIT is on, but net.core.bpf_jit_kallsyms is off.
> bpf_prog_kallsyms_find() was skipping addr->bpf_prog resolution
> logic in oops and stack traces. That's incorrect.
> It should only skip addr->name resolution for 'cat /proc/kallsyms'.
> That's what bpf_jit_kallsyms and bpf_jit_harden protect.
>=20
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Fixes: 3dec541b2e63 ("bpf: Add support for BTF pointers to x86 JIT")

it fixes the crash for me, thanks for quick fix

jirka

> ---
>  kernel/bpf/core.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 673f5d40a93e..8d3fbc86ca5e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -668,9 +668,6 @@ static struct bpf_prog *bpf_prog_kallsyms_find(unsign=
ed long addr)
>  {
>  =09struct latch_tree_node *n;
> =20
> -=09if (!bpf_jit_kallsyms_enabled())
> -=09=09return NULL;
> -
>  =09n =3D latch_tree_find((void *)addr, &bpf_tree, &bpf_tree_ops);
>  =09return n ?
>  =09       container_of(n, struct bpf_prog_aux, ksym_tnode)->prog :
> --=20
> 2.17.1
>=20

