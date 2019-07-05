Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12C660C7C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfGEUlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:41:20 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35488 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:41:20 -0400
Received: by mail-oi1-f194.google.com with SMTP id a127so7999729oii.2;
        Fri, 05 Jul 2019 13:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9oh07kJUZMEQmkUtGac/tlJsPmWRKPEi2PyfWbAHi8=;
        b=lTJhy59O+20pFN9B4Svqv+YZgf0KaSBDMDlj2ZWFRBZHMcFDiFtaG3eniahJbcjGLM
         aQw22L3Hud9w+a/aN7M0Y2falUKTp+0rrt+jruekyl6jvBQC/cCgux9lvjAekPiWM05L
         xfGhzT0y/ert8q5BaG7ie6kYCqVIJ2pbdJ/Mnc2UcZCaQJCrc259PTi0LI4ymWToOtvH
         3YsY74YwjFilXvJ++ODqbfUCMG4CwzIcdFfmsRDncGReeRGwp92mj9U4468UKjLn+IjA
         A+3hEF70rS7Myj0gTQhuemYy2VuIE4PRmaXpOutVJZtd+y6M3Rk+QOJu62pfpxHZT5KI
         ufHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9oh07kJUZMEQmkUtGac/tlJsPmWRKPEi2PyfWbAHi8=;
        b=BWedCazLGhR5Osqt+Gnwj1FFIl9R2kf0PJFUtEpH4E9lkPCe3F5j4k2/HhTZ6hTyOx
         gnQulXILqw1eBt84MA7CnyerbwIaxr0y4PkExS0N16as/7VZNrTrzoSOZx5tmigiorwH
         4LqmAVDezEYjT/JbZ8QNXntWBMLmCmjrUGWtMsQXkG1T7MTzKtaDaZo30DxBdEGHpsIO
         Jq/V5ATjsSrQsuwjiW56/PxZZc8UEsz1WQ9DigtEhAPCT8m/CJedd5ZMCGWdaOben5re
         NxK2HaE+BPH60QLLSvGQ0RzaJ8vGEsTjA9J7RYNrDrONhSQPyKaPJDYCZp1mgsr6zkJl
         NQIA==
X-Gm-Message-State: APjAAAU7SBmohYWRqfbu2V60Wr4bm8kJfdWxEIVtJCQED7qLx9svapxy
        P8PL0UUdxvRm5BpD5qU2boo=
X-Google-Smtp-Source: APXvYqyJKpL6z8YsY5rdCCHBSSU5cC7EMVZ74+PzMgEm/GJ5faCwzUqYBruyMY3eRr7/BbQ1RXj18A==
X-Received: by 2002:aca:b788:: with SMTP id h130mr3202843oif.85.1562359279480;
        Fri, 05 Jul 2019 13:41:19 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:91ff:fe99:7fe5])
        by smtp.gmail.com with ESMTPSA id q82sm3059229oif.30.2019.07.05.13.41.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 13:41:19 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH bpf-next 0/2]  libbpf: add an option to reuse maps when loading a program
Date:   Fri,  5 Jul 2019 20:40:37 +0000
Message-Id: <cover.1562359091.git.a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following two patches add an option for users to reuse existing maps when
loading a program using the bpf_prog_load_xattr function.  A user can specify a
directory containing pinned maps inside the bpf_prog_load_attr structure, and in
this case the bpf_prog_load_xattr function will replace (bpf_map__reuse_fd) all
maps defined in the object with file descriptors obtained from corresponding
entries from the specified directory.

Anton Protopopov (2):
  bpf, libbpf: add a new API bpf_object__reuse_maps()
  bpf, libbpf: add an option to reuse existing maps in bpf_prog_load_xattr

 tools/lib/bpf/libbpf.c   | 42 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  3 +++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 46 insertions(+)

--
2.19.1
