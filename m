Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0610D109
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 06:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfK2F1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 00:27:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40690 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2F1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 00:27:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id a137so22733376qkc.7
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 21:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GCzcGX+TrqCBvIo9wrovNA59sfGohi1AmZ+4gaNZKs=;
        b=C/cHHHltT12mgLgVQqYx8VkCVH/xczjfwhIC99oRYhzyDE/Vs6QkA/jSc97s653/m5
         0LFUFWpwUtuyoUWjgvMHmoJxZX7oI1cKv4N3sIDJ4v2czl/QiJkmiP49HkosqdvYDjUX
         yseWzP/1G3CX8c1ewcKCW5iAzh17MC35obqBsG9expKNhm2w26MxYXnau+xZBZ996y72
         npJSlnqBQ3E9jSQJfv31vng4Cxd/8yYOisF8kowO4ZQj0ZNgH8ug8yqDaZY/7rG87Vsc
         VHWrqMqsxZ5YPGORO9d+Ffz203WWI3YuzKonQUCabkplOpjGvH+AGV20oLOCNaSd9BkI
         Eizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GCzcGX+TrqCBvIo9wrovNA59sfGohi1AmZ+4gaNZKs=;
        b=jtW5efTGjLOvhstDrtx1oqnYV8asAhmQfotNcvjw2H7X/IQKc67zjUyA0kPjHJT2mE
         VxsJZAFHsTZF5IDiShe+YFBZoeu/sfS6OaKkNLidgQ1T9zWI9ywflgp/IjqTtCdQNzYi
         mZIF6waH1AWAOD0lgaFxHRD57COZSTFtOCV0TXWpBxSTctvEUBmqAkMdh+qNSxNhy0yq
         kp3F9lbUWriT/0eyrT6ZjUdvcmkqJ5oZDqpXHpWApUkON/vt/DlDR3qcBgI5uxdm+iaa
         ZGtttPAPKpCLlsn3nRTdVW2L+HQNN7G5XkgRAPB4juaeC99m8D37DaOXyIRdC2sei9aZ
         +RTQ==
X-Gm-Message-State: APjAAAVmPocyiKIaOi2lN82MJRN4AqhuhIWX5aRwwol9UQHW0SIZfkq9
        +uc2E7RlRheiEz+IUfCQ02Mz1MVb6HtI96n0VQA=
X-Google-Smtp-Source: APXvYqzmAigkUfCXQL5ivjBPn8VBlo/0qHejRsE8rcGP2XU1cdf1vKRM+aSD2wGhEOCX0YSvkDz9w6yg+BaZ9niIaEs=
X-Received: by 2002:a37:a685:: with SMTP id p127mr14757109qke.449.1575005242789;
 Thu, 28 Nov 2019 21:27:22 -0800 (PST)
MIME-Version: 1.0
References: <20191128170837.2236713b@carbon>
In-Reply-To: <20191128170837.2236713b@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Nov 2019 21:27:12 -0800
Message-ID: <CAEf4BzY3jp=cw9N23dBJnEsMXys6ZtjW5LVHquq4kF9avaPKcg@mail.gmail.com>
Subject: Re: Better ways to validate map via BTF?
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 8:08 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Hi Andrii,


Hey, Jesper! Sorry for late reply, I'm on vacation for few days, so my
availability is irregular at best :)

>
> Is there are better way to validate that a userspace BPF-program uses
> the correct map via BTF?
>
> Below and in attached patch, I'm using bpf_obj_get_info_by_fd() to get
> some map-info, and check info.value_size and info.max_entries match
> what I expect.  What I really want, is to check that "map-value" have
> same struct layout as:
>
>  struct config {
>         __u32 action;
>         int ifindex;
>         __u32 options;
>  };

Well, there is no existing magical way to do this, but it is doable by
comparing BTFs of two maps. It's not too hard to compare all the
members of a struct, their names, sizes, types, etc (and do that
recursively, if necessary), but it's a bunch of code requiring due
diligence. Libbpf doesn't provide that in a ready-to-use form (it does
implement equivalence checks between two type graphs for dedup, but
it's quite coupled with and specific to BTF deduplication algorithm).
Keep in mind, when Toke implemented map pinning support in libbpf, we
decided to not check BTF for now, and just check key/value size,
flags, type, max_elements, etc.

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
> static void check_config_map_fd_info(int map_fd) {
>         struct bpf_map_info info = { 0 };
>         __u32 info_len = sizeof(info);
>         __u32 exp_value_size = sizeof(struct config);
>         __u32 exp_entries = 1;
>         int err;
>
>         /* BPF-info via bpf-syscall */
>         err = bpf_obj_get_info_by_fd(map_fd, &info, &info_len);
>         if (err) {
>                 fprintf(stderr, "ERR: %s() can't get info - %s\n",
>                         __func__,  strerror(errno));
>                 exit(EXIT_FAIL_BPF);
>         }
>
>         if (exp_value_size != info.value_size) {
>                 fprintf(stderr, "ERR: %s() "
>                         "Map value size(%d) mismatch expected size(%d)\n",
>                         __func__, info.value_size, exp_value_size);
>                 exit(EXIT_FAIL_BPF);
>         }
>
>         if (exp_entries != info.max_entries) {
>                 fprintf(stderr, "ERR: %s() "
>                         "Map max_entries(%d) mismatch expected entries(%d)\n",
>                         __func__, info.max_entries, exp_entries);
>                 exit(EXIT_FAIL_BPF);
>         }
> }
>
>
> struct config {
>         __u32 action;
>         int ifindex;
>         __u32 options;
> };
>
