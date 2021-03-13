Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BA8339B3A
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhCMCWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:22:38 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:39042 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbhCMCWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 21:22:20 -0500
Received: by mail-pf1-f169.google.com with SMTP id 18so3084179pfo.6;
        Fri, 12 Mar 2021 18:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bL9MisVqCy9+mMTkkT9Ym/rs2nuRRYH0hpQS2/1i2Qc=;
        b=YAdYbG6fff0/jGTaEsRmaJxkFUQWpdEk9BoNC2qDSFyxVxYBYbbdIAkXfpKnqHTgG7
         Ut8yRQiLkeqEJdWIE+D9/es4MO4I94Hro2bR+Ry3uK/Y5r605ALCnLYmCYw8IUN5Z6N0
         8FHpCRd6szDB8VMY2pq+3xnlISt9lMM7lcJBdH40X7NPMVHsjp/K5agTAS17iK62D4SG
         qe+jJYPRFLiugO2bTY//C080wuKDyiLHEbGeZ0VOlcyApuu3shfoknndB9HJjd8Qj2z/
         si21JfrXebVy+zfpwXzHzcuSAwK+WKZ27ar/HeD20VOqp9XWZccdVREYQKDRj3tLh1sF
         UJ1w==
X-Gm-Message-State: AOAM532ZC/dezKIjU3S/Gz1Dip8YfNcgXa/ySf0FAVhLBeaum4BfqyIr
        Ol/8Q77McjLhfGHAQdtFFaBXqZLRWGJokA==
X-Google-Smtp-Source: ABdhPJwruavXBRGzE5NvtQgB4Hv0B9VsKuEoRnRdCIedurSM1Fd25BdadH3+DAG1TuTAR7pVOSTpvg==
X-Received: by 2002:a65:4243:: with SMTP id d3mr14766300pgq.180.1615602140435;
        Fri, 12 Mar 2021 18:22:20 -0800 (PST)
Received: from sultan-box.localdomain (static-198-54-131-119.cust.tzulo.com. [198.54.131.119])
        by smtp.gmail.com with ESMTPSA id m5sm6768990pfd.96.2021.03.12.18.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 18:22:20 -0800 (PST)
Date:   Fri, 12 Mar 2021 18:22:17 -0800
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Use the correct fd when attaching to perf events
Message-ID: <YEwh2S3n8Ufgyovr@sultan-box.localdomain>
References: <20210312214316.132993-1-sultan@kerneltoast.com>
 <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 05:31:14PM -0800, Andrii Nakryiko wrote:
> On Fri, Mar 12, 2021 at 1:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> >
> > From: Sultan Alsawaf <sultan@kerneltoast.com>
> >
> > We should be using the program fd here, not the perf event fd.
> 
> Why? Can you elaborate on what issue you ran into with the current code?

bpf_link__pin() would fail with -EINVAL when using tracepoints, kprobes, or
uprobes. The failure would happen inside the kernel, in bpf_link_get_from_fd()
right here:
	if (f.file->f_op != &bpf_link_fops) {
		fdput(f);
		return ERR_PTR(-EINVAL);
	}

Since bpf wasn't looking for the perf event fd, I swapped it for the program fd
and bpf_link__pin() worked.

Sultan
