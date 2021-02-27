Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AF9326B18
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhB0CAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhB0CAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:00:45 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B4DC06174A;
        Fri, 26 Feb 2021 18:00:04 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r23so12791862ljh.1;
        Fri, 26 Feb 2021 18:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=aP1ZJOFRaX2M0sQyaI//Zc1AQIVHAc229PEVbc1yw9o=;
        b=W/Xhm9WmLgiYp29eSCuf6ip4/cez6zU4czyJq7tPVgqb0DnqN4ELfF2f8xkv6bW/+F
         BsOcr9kTj+oIACRNDxyXsK7zG4o7OqhVPjiDfyWVGPbuN3t1jk4VgikGZ7fR4+j5fCA5
         ttlyCzzX/rsPwpMHYRenRLoErr30PeYA4ps/X+ldHqjia8aO5IFOtnjvPjQnInUS9Ah1
         o9fItYo8pHodp8JGPB1Y+ScKUiKvbsOxVv6R2/jACusGwgzGBupr/h3OKd0cFIsoSEPP
         RHU247RRqcjU/FE9bgra1WnC1ocV/CgA6OenU0SkRqU1Vx2luFiIvx3hWNu6crFjTG2v
         ISxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aP1ZJOFRaX2M0sQyaI//Zc1AQIVHAc229PEVbc1yw9o=;
        b=gtKwv+P3CmqxYVTZ6bih3ClW10Gb0Z8zTp+C//vtXkJMDwllGGYkCYxdHKn5sIPZGh
         Bj39HRoiVl6fnTpyKXVX8w1twwA6s128FoWgeX/1ZH4a+7ioJ6gVGMcRvD3K8KWGw6HR
         9gbewcuRiW42RdJnIG4WyZTm6ngl8sf2GJPctOFkP4+PZxmo/8AwjKbwjqMqYutc7nO/
         //GnqBmHkVjT7VhWKuMgj0xxcLE1t2RCwUAXuXhd2fodqVfc6bjawQZq9+moT9NgDIaX
         /cWSSCTbXFtXh8zRh3SvP7SQ6NI7pZMWotIuHHInPOLDRXwI24hoYin0+SOSQ5q8vW9m
         T8XA==
X-Gm-Message-State: AOAM532I7yuYLfNLUeFmxvPsJY/318kRA4NWo6/VYfp9InSOfCpaeyyj
        u8wdekKkQgC6jRNbYZVDoYJvDhhc/rT7gh9oTjo=
X-Google-Smtp-Source: ABdhPJwc+GcS5sipYdfWnLWJlnO5Pkd1v3elzVQ3n5dnaD+LwXFsGpgLg6F8slag57QBU6g7E9xiHVjFIMAHxGHpjb8=
X-Received: by 2002:a2e:894d:: with SMTP id b13mr3136736ljk.44.1614391202278;
 Fri, 26 Feb 2021 18:00:02 -0800 (PST)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Feb 2021 17:59:50 -0800
Message-ID: <CAADnVQLfu8L06R96fHV9-7055yVwVQe=7vrHeHkTxN4tuqyCsw@mail.gmail.com>
Subject: sk_lookup + test_bprm = huge delay
To:     KP Singh <kpsingh@google.com>, Lorenz Bauer <lmb@cloudflare.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi KP, Lorenz,

I need your help to debug a huge delay I'm seeing while running the test_progs.

To debug it I've added the following printf-s:

diff --git a/tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
b/tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
index 2559bb775762..cdd2182c83a2 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
@@ -66,8 +66,10 @@ static int run_set_secureexec(int map_fd, int secureexec)
                 * If the value of TMPDIR is set, the bash command returns 10
                 * and if the value is unset, it returns 20.
                 */
+               null_fd = open("/dev/console", O_WRONLY);
+               dprintf(null_fd, "before_bash\n");
                execle("/bin/bash", "bash", "-c",
-                      "[[ -z \"${TMPDIR}\" ]] || exit 10 && exit 20", NULL,
+                      "echo running_bash > /dev/console;[[ -z
\"${TMPDIR}\" ]] || exit 10 && exit 20", NULL,
                       bash_envp);
                exit(errno);
        } else if (child_pid > 0) {

Then I do:
./test_progs -n 127
before_bash
running_bash
before_bash
running_bash
#127 test_bprm_opts:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

and it takes a split second to execute. There is no visible delay.

But when I run it as:
./test_progs -n 98,127
#98 sk_lookup:OK
before_bash
// huge delay here
running_bash
before_bash
running_bash
#127 test_bprm_opts:OK
Summary: 2/46 PASSED, 0 SKIPPED, 0 FAILED

real    0m51.414s
user    0m0.808s
sys    0m35.731s

All 50 seconds are spent waiting after "before_bash" line is printed.
Something is drastically delaying execle("/bin/bash").

But replacing arg0 of "bash" with "sh" makes it fast !
execle("/bin/bash", "sh"
                               ^^ instead of "bash".
I cannot explain all this at all.

sk_lookup test doing some netns and forking "ip",
but why would that slow down "bash" startup time?
And why would bash start quickly if it thinks that it's name is "sh" ?

For giggles I've tried:
execle("/bin/bash", "foobar"
and it's also slow.

Crazy ideas are welcome :)
