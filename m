Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDAEE068F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbfJVOgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:36:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:60374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726915AbfJVOgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 10:36:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC66DB022;
        Tue, 22 Oct 2019 14:36:05 +0000 (UTC)
Date:   Tue, 22 Oct 2019 16:36:04 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, ltp@lists.linux.it,
        Richard Palethorpe <rpalethorpe@suse.de>
Subject: EPERM failures for repeated runs
Message-ID: <20191022143604.GA18468@rei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
Lately we started to write BPF testcases for LTP and after writing a
first few tests we found out that running more than a few in a row
causes them to fail with EPERM.

The culprit is deferred cleanup of the bpf maps that are locked in the
memory, see:

http://lists.linux.it/pipermail/ltp/2019-August/013349.html

We worked around that by bumping the limit for the tests in:

https://github.com/linux-test-project/ltp/commit/85c4e886b357f7844f6ab8ec5719168c38703a76

But it looks like this value will not scale, especially for
architectures that have larger than 4k pages, running four BPF tests in
a row still fails on ppc64le even with the increased limit.

Perhaps I'm naive but can't we check, in the kernel, if there is
deferred cleanup in progress if we fail to lock memory for a map and
retry once it's done?

Or is this intended behavior and should we retry on EPERM in userspace?

-- 
Cyril Hrubis
chrubis@suse.cz
