Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4015D19A5B4
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 08:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbgDAG5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 02:57:37 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:37716 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731764AbgDAG5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 02:57:36 -0400
Received: by mail-yb1-f171.google.com with SMTP id n2so11298408ybg.4
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 23:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=92zncqgi58to5wHJKOD0e7zkfEuj7QsygWR1Z75H6sU=;
        b=iu0/+7y4bad2+h2ooBY7MLwaPernTBotRzZKtt3pS/z+0noTiG0+BvxukAfIxlM/Vy
         EdiVetrWqPsNs0qfVl2fjuqB/9DvMC+4vL2jzRGopja7cer9vVVcxeoIqMSMfAmW37Lf
         BOW/reBCWYhnH7EeDvlW6PQi9k8xFAH5lxpk/2G91hCVO5eMo0QPM+S218EaORYWAMDz
         3ETu0zuOjcbQyJ4YVZSc8pqGqIvBCr442i1zbt1E9sAlKN/EhU3Gny1IJHFZDMYgcGMx
         aMvhatTwIpdF1tlG1+J6q8j0k0X5gLvthmT2cF5hjZIoMkUbQluR384T+VDjlLG+nl8r
         YFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=92zncqgi58to5wHJKOD0e7zkfEuj7QsygWR1Z75H6sU=;
        b=asWvzhK6JoVe6juRSxwwEDqr5KOuMv7ai3DYNy6a6iACVSaG+dc2ZFBWmEIrXG3VIt
         ayjbwnrz9b0cLGH+CVgpodLB+reNKXfD9Md4IlhqacqnzVY+VY8Q82kgdnHXFMwNsmtH
         SNdmHq9C/8kHcaQNw97ndsUK+UfhpljlwEBSrGjlA/0eX52/Xla97F0oPzQuAOHQWagG
         HLXluIfC6NEjLyv8KtPjEufz2P8cy7HhO3MNZORQxBRHdumlhjuLu6MrMwb8vEgNK4qq
         Jb2sVC1wxm0dJmQgfFTttmUdlfwMoFof45iTKeMMw3GamSHhjWAPri3Yoj5QBWjT5Sfr
         06AQ==
X-Gm-Message-State: ANhLgQ3iwxZJmxCcaflIl0/kl41o0qS31UG1O5oCnU2Hi1+WL441xKr3
        nlNvoFHakEUzgVjZJ0D/dYizeSP5dX/jxsstQmjeHaJ8m6Y=
X-Google-Smtp-Source: ADFU+vsvpRh2knreF390c9xNsMU0dqB+9jP8YwKxtvFimWaOb8cQAwq9I2Nn97kQGNJkDaymV1wZdTw54sFSDtBUWMQ=
X-Received: by 2002:a25:3d83:: with SMTP id k125mr35876195yba.239.1585724255211;
 Tue, 31 Mar 2020 23:57:35 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Majer <stefan.majer@gmail.com>
Date:   Wed, 1 Apr 2020 08:57:24 +0200
Message-ID: <CADdPHGsD4b5GNoLy3aPQndkA84P_m33o-G1kP7F7Xkhterw0Vw@mail.gmail.com>
Subject: PATCH: Error message if set memlock=infinite failed during bpf load
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Executing ip vrf exec <vrfname> command sometimes fails with:

bpf: Failed to load program: Operation not permitted

This error message might be misleading because the underlying reason can be
that memlock limit is to small.

It is already implemented to set memlock to infinite, but without
error handling.

With this patch at least a warning is printed out to inform the user
what might be the root cause.


Signed-off-by: Stefan Majer <stefan.majer@gmail.com>

diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf4..210830d9 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1416,8 +1416,8 @@ static void bpf_init_env(void)
  .rlim_max = RLIM_INFINITY,
  };

- /* Don't bother in case we fail! */
- setrlimit(RLIMIT_MEMLOCK, &limit);
+ if (!setrlimit(RLIMIT_MEMLOCK, &limit))
+ fprintf(stderr, "Continue without setting ulimit memlock=infinity.
Error:%s\n", strerror(errno));

  if (!bpf_get_work_dir(BPF_PROG_TYPE_UNSPEC))
  fprintf(stderr, "Continuing without mounted eBPF fs. Too old kernel?\n");

-- 
Stefan Majer
