Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF04215C74
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgGFRAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:00:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40014 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729478AbgGFRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594054818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OjkZPREvKip3rVS6iZU65nBkLJdMZelkk5lBM6xndR0=;
        b=IjQboEkdosXf6M0PkdnUFbvdI2uO1SCgy5dqgixHV9lPBdhw65j5yEnccHcADypStviOZq
        LhK3me2bFmjXC/9qKuXs7IBGbuN8caEyKCR+IexxY3AGUIsswtbx8oscht03AAkNsZBP93
        Rdxrc0EqtJjLi0aLs0dmf2NFHxXaecg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-pvjmzEPGO5C6GIwqNZljAQ-1; Mon, 06 Jul 2020 13:00:15 -0400
X-MC-Unique: pvjmzEPGO5C6GIwqNZljAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EBEA64A74;
        Mon,  6 Jul 2020 17:00:14 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 653FE60F8D;
        Mon,  6 Jul 2020 17:00:07 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7139E300019CC;
        Mon,  6 Jul 2020 19:00:06 +0200 (CEST)
Subject: [PATCH bpf-next V2 0/2] BPF selftests test runner 'test_progs' use
 proper shell exit codes
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        vkabatov@redhat.com, jbenc@redhat.com, yhs@fb.com, kafai@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 06 Jul 2020 19:00:06 +0200
Message-ID: <159405478968.1091613.16934652228902650021.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset makes it easier to use test_progs from shell scripts, by using
proper shell exit codes. The process's exit status should be a number
between 0 and 255 as defined in man exit(3) else it will be masked to comply.

Shell exit codes used by programs should be below 127. As 127 and above are
used for indicating signals. E.g. 139 means 11=SIGSEGV $((139 & 127))=11.
POSIX defines in man wait(3p) signal check if WIFSIGNALED(STATUS) and
WTERMSIG(139)=11. (Hint: cmd 'kill -l' list signals and their numbers).

Using Segmentation fault as an example, as these have happened before with
different tests (that are part of test_progs). CI people writing these
shell-scripts could pickup these hints and report them, if that makes sense.

---

Jesper Dangaard Brouer (2):
      selftests/bpf: test_progs use another shell exit on non-actions
      selftests/bpf: test_progs avoid minus shell exit codes


 tools/testing/selftests/bpf/test_progs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--

