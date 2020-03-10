Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5817EEEB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCJDCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:02:35 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:47042 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgCJDCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 23:02:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id d23so1820530ljg.13;
        Mon, 09 Mar 2020 20:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FMyz+6HzHs6glLgbt0Jv4MeqzMaEFKI1LE36Rw0dJGI=;
        b=foI0znYkmoi+qK4idW5rxtdg/ccI7me39I/hMgD/eikfI00wX8Vp8yYRCh3BGaxrNv
         cc7aAMras0N5hnVv6aEWObSf10ZEmY4UHtc7lkYi6j+zmRgWPp8mwdCjGDkr5BUoEKkp
         Bue4XzeSNHzD8rMglxABS8oVF2L7I9gLv5juXeOpg20vfStYFqGnZJ3E3Tn0cNYJGtp4
         m1uaWH+cXDjeCH9Sgt+mvuUksPj55Xmx+HkXB0tU2eqmk8+X1tJsU+By6jszoULhTJGA
         rrvPtI1wjwXxXgOzT6ydMbMhO0OV/WmoHh7mZEVPG4e+l/qKIfFhieWavIPWwWz08Png
         X4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FMyz+6HzHs6glLgbt0Jv4MeqzMaEFKI1LE36Rw0dJGI=;
        b=SqYHJQVIfK8I7Yd/cUI8c67VFQXvSEItO8+JZzfLqwjWghLvA/oSfJxJbgRwVHn90k
         MYbr+Sggb4XZdhd+p1k92sKw8eGuINxZ/7G2p0+0GlqJCVZ2JsmtCR5ZD9xVcfcbJrCp
         ISdJx4zcPBsH/1xZ/+Mjlip0S7WTZX3e/iDVU5AoyBHfCH2+nFNhHIzkurGhjW0IRVGs
         EASxVxyQVkA84sTYi3gNdLhAA2B546qFhRrg9SDDsjQe9Bnob6azcfwywKw0ybEOAIPG
         Am2XnNnDBmIittk5vfs2fnNoYWs6XHofzlXbfCiiMKXYti9vvRVPLktA9Dh6huDDcL3t
         nC1g==
X-Gm-Message-State: ANhLgQ0zAwDAxK09kz6B0b6+zZsSrRgaM2d3Omkc9EmNOoankVcY0ae4
        SjT3ofniGN8Hk3g0By+rExZ7GQ6uAwqEU4D/HvfqvA==
X-Google-Smtp-Source: ADFU+vvAaCpGnKFc+0m2LTzG3jNEwQYY909pJys96V+IUoU1xoCLm+cQSfN0V7mkCBi51aKt7Dt7rU74J88WPUtM0MQ=
X-Received: by 2002:a2e:5ce:: with SMTP id 197mr2753318ljf.234.1583809351150;
 Mon, 09 Mar 2020 20:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200309224017.1063297-1-andriin@fb.com>
In-Reply-To: <20200309224017.1063297-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 9 Mar 2020 20:02:19 -0700
Message-ID: <CAADnVQKQTsjJmYM1Gi-UAnQCS8PChXzwMiSuhY5Ev0HjyX=+Dg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roman Gushchin <guro@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 3:41 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> There is no compensating cgroup_bpf_put() for each ancestor cgroup in
> cgroup_bpf_inherit(). If compute_effective_progs returns error, those cgroups
> won't be freed ever. Fix it by putting them in cleanup code path.
>
> Fixes: e10360f815ca ("bpf: cgroup: prevent out-of-order release of cgroup bpf")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
