Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9F11EAFA
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 20:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfLMTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 14:09:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34820 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbfLMTJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 14:09:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so651512wro.2;
        Fri, 13 Dec 2019 11:09:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wnHPEN0qEL7mzzCuYa2+H6nkwXesBwappb5FabDrXIk=;
        b=R37z4FSKTLEZH0ufOhU3dF7U75xhcdw8zQ8MuJUehrLFnw4I+JvTuK5IFxKQeueV1M
         eWqJEzFxi6PFIc5aK7qbz4t2eVYlyr/UnD1q0L4PzUPr620SpXWijnao5sd3Wdvz00di
         8NAwHdtd/7dIL97BTSwkUmGBGPQwlp3ff3t930bOcVMctZmib+W2Bu0zOGPhtl4Ca9AX
         mNRlRlLNwQj83tUFmQti4JUybFVQqoIERIHpDfNJxldbjKj4dMbsi6j8hEkq1+TdXwX9
         nmxv9SAfS/6YKE5WL1HxQMTbiRuymQz3fM53sA3qNCtziaiYMphCFgyGGEllOhhc3z1r
         8pTg==
X-Gm-Message-State: APjAAAUZi4H+sXtMKgrpnzMbHv8XCUZNymQu9Dzjxcxfy9zoP9CERv8D
        5r/kDC9SFGOqVE8EnOe68JO/4X+LLg33gw==
X-Google-Smtp-Source: APXvYqzUAmj9lI50tcqrBlaMqfrEB61GnEnXTje5Ee+IyXVSxHqwh1yt1LWpzc13YuIDrJHE0/viUA==
X-Received: by 2002:adf:f508:: with SMTP id q8mr14536534wro.334.1576264193645;
        Fri, 13 Dec 2019 11:09:53 -0800 (PST)
Received: from Omicron ([185.64.192.240])
        by smtp.gmail.com with ESMTPSA id g9sm11199389wro.67.2019.12.13.11.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 11:09:53 -0800 (PST)
Date:   Fri, 13 Dec 2019 20:09:52 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 0/3] bpftool: match programs and maps by names
Message-ID: <cover.1576263640.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working with frequently modified BPF programs, both the ID and the
tag may change.  bpftool currently doesn't provide a "stable" way to match
such programs.  This patchset allows bpftool to match programs and maps by
name.

When given a tag that matches several programs, bpftool currently only
considers the first match.  The first patch changes that behavior to
either process all matching programs (for the show and dump commands) or
error out.  The second patch implements program lookup by name, with the
same behavior as for tags in case of ambiguity.  The last patch implements
map lookup by name.

Changelogs:
  Changes in v2:
    - Fix buffer overflow after realloc.
    - Add example output to commit message.
    - Properly close JSON arrays on errors.
    - Fix style errors (line breaks, for loops, exit labels, type for
      tagname).
    - Move do_show code for argc == 2 to do_show_subset functions.
    - Rebase.

Paul Chaignon (3):
  bpftool: match several programs with same tag
  bpftool: match programs by name
  bpftool: match maps by name

 .../bpf/bpftool/Documentation/bpftool-map.rst |  12 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  18 +-
 tools/bpf/bpftool/bash-completion/bpftool     | 145 ++++++-
 tools/bpf/bpftool/main.h                      |   4 +-
 tools/bpf/bpftool/map.c                       | 384 +++++++++++++----
 tools/bpf/bpftool/prog.c                      | 388 ++++++++++++------
 6 files changed, 737 insertions(+), 214 deletions(-)

-- 
2.24.0

