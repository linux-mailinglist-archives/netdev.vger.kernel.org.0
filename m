Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E78C3C0F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbfJAQs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:48:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388291AbfJAQsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:48:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D1518AC6F5;
        Tue,  1 Oct 2019 16:48:23 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F20A91001B11;
        Tue,  1 Oct 2019 16:48:15 +0000 (UTC)
Date:   Tue, 1 Oct 2019 18:48:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     brouer@redhat.com, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ast@fb.com>, <daniel@iogearbox.net>, <toke@redhat.com>,
        <kpsingh@chromium.org>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem}
 w/ sized opts
Message-ID: <20191001184813.23d004d2@carbon>
In-Reply-To: <20190930164239.3697916-1-andriin@fb.com>
References: <20190930164239.3697916-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 01 Oct 2019 16:48:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 09:42:39 -0700
Andrii Nakryiko <andriin@fb.com> wrote:

> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 2e83a34f8c79..1cf2cf8d80f3 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -47,6 +47,12 @@ do {				\
>  #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
>  #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
>  
> +#define OPTS_VALID(opts) (!(opts) || (opts)->sz >= sizeof((opts)->sz))

Do be aware that C sizeof() will include the padding the compiler does.
Thus, when extending a struct (e.g. in a newer version) the size
(sizeof) might not actually increase (if compiler padding room exist).

> +#define OPTS_HAS(opts, field) \
> +	((opts) && opts->sz >= offsetofend(typeof(*(opts)), field))
> +#define OPTS_GET(opts, field, fallback_value) \
> +	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)

I do think, that these two "accessor" defines address the padding issue
I described above.

p.s. I appreciate that you are working on this, and generally like the idea.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
