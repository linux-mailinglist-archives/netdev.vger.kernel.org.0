Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D546920670F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgFWWPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387609AbgFWWPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:15:22 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A09C061573;
        Tue, 23 Jun 2020 15:15:21 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id k18so60647qke.4;
        Tue, 23 Jun 2020 15:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M0RS5OcZcuROFMyvn07ZfcbETlVYuhE75d+3h8JpDMc=;
        b=W22A8KLx2QfHRp3GKHKQ+G2pStiPspUM5Xfj5EYkvlrA4Uo9Xa55Peex6F+SDFcn3f
         NvYI2DnlwtegC1O3Zp/pmD9dRtT+bIYQp/6ZO0Cz6jPThfP0Fn+H1VpV2+33NcYYO0js
         Kx3iEK4qYdRjQyDiJMlICc/NrfeSHzUcyr0w2+rDIGdOoZGFgHbZZbXM+PhhCV85ymVg
         piiwD+a/c4ORonod+Ns4HKwLHPbQ3yvd5tTcibU9KEQWFIEXiBgDfVaPl0GURHKziK1s
         oqGCjzEW94mpFOcrQ3d+sE4OkNLwe9OReKn0FsJz4+CY1Rg34dzH5DXXIYV81CmjXrhu
         BMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M0RS5OcZcuROFMyvn07ZfcbETlVYuhE75d+3h8JpDMc=;
        b=auTDGIS5+/ETst2hV0G3++z8V/z9LCqF76LZy+JeLNJjAQyP638hmLShgVgMLoGijc
         yEcZHthmOH1V5Rv6fNsCobdJQQL+iYVLY9uE6FvVmfBSrIxOXNb3r2v73HWAEvtTe36/
         BcfHVMsKpb9yPjgGxU+1gBagMUNKVvau1UVOMRxxU1ZzAaEurm7/jls15tmRqiD8DhJL
         phCtV3hYnlmuBPI827HzGE6vjDemA2jPWjeqW3/MhenlaZrDiPcCk5xeRdZvnq9G9cFc
         rlmvj6dYJdwGyU7X3ulTO3xjK645b9dy8j5lQf74nyExxWD1azUAejTLdwMNb2QsWSu0
         3IEg==
X-Gm-Message-State: AOAM531LuFLUsYicjKrQgzmUMbVOk8XsgoFxjJzt39o2gOm2uUfMXvS2
        sFHGwo3llm1oYnNW2/sCI6zZj7cDideHF/kQJt4=
X-Google-Smtp-Source: ABdhPJwRRtNXqMoh+4OdLl4RUmA4tGYZ/lxYtG4I5HgwTaddYKD6l5w/1K7giOExqXB9WFTfiM7qdoO1LNzvun4oLH0=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr23321289qkl.437.1592950521026;
 Tue, 23 Jun 2020 15:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200623213600.16643-1-quentin@isovalent.com>
In-Reply-To: <20200623213600.16643-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 15:15:09 -0700
Message-ID: <CAEf4BzbUdiTgZ5pqYCPRP_XTmbTXNPV1FKwLX414vkJL6=6oXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] tools: bpftool: fix variable shadowing in emit_obj_refs_json()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 2:39 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Building bpftool yields the following complaint:
>
>     pids.c: In function 'emit_obj_refs_json':
>     pids.c:175:80: warning: declaration of 'json_wtr' shadows a global declaration [-Wshadow]
>       175 | void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_wtr)
>           |                                                                 ~~~~~~~~~~~~~~~^~~~~~~~
>     In file included from pids.c:11:
>     main.h:141:23: note: shadowed declaration is here
>       141 | extern json_writer_t *json_wtr;
>           |                       ^~~~~~~~
>
> Let's rename the variable.
>
> v2:
> - Rename the variable instead of calling the global json_wtr directly.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

Thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
