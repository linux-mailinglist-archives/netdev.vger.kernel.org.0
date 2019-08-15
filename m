Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07478EB43
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbfHOMO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:14:28 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36778 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfHOMO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:14:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id j17so1510040lfp.3
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3641LUEd2HTKkMH20tZOF7R9VgBmsqyi1CgXFKzq1iI=;
        b=E7+mvnclwFQf1QTthc7TSa/woOJoODcphCGG4gThBjwyHFGxAUTVQ4sb+1zeH7XAgR
         3FqMc8iSzjNFsAAdzrjtfoiBkOg/gEVnjyoY/SOVVODua0fGf8hW6Cr117wxwFMrqZ/b
         yIROJrH+8HVfZuM40aSRHgfr0opGr1qfNM0K5PU6rUugeE4uvycQzeRb9jpxT3cQVR/a
         SkCzl4Rg5V4UaCcHmir+8BjwdByEIdm94fQzCkW6JdVryww/Wi8owh5FRSS/K55R3uJI
         ZjPnmbjs7VAESgtQ+iocnno+9xe6FPUw0DPiyXJQstYgmEzaqJ7h1GBV6gBxRTbyprgp
         jF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3641LUEd2HTKkMH20tZOF7R9VgBmsqyi1CgXFKzq1iI=;
        b=inoMotZKSdTzG5JfJxSR7PFBs44o2W0wbG9mmGs7P4df6IG1/4ZeR7WCCDRA6JYJxR
         6G4+BC7zU9WzkVYuilF/EVYYhQZWEbxjsWhKL3ICLRIA2TGGWtrYfZyXqJ/jTogZdGz1
         M7zw3PrSXSPo2Rsr+SFdm1txiMQlWgFWhuxWeYB+4l94psxZBzjovEg8EgK1LvGat+gU
         exoCZCV85ILhRwUmyO9AxDUlrk/STXtXleJoPX0gdv1O1j0yRzSI9l7CDSa+PcnOo1IU
         A7Yw9wafvlbSinsZ0lRqc8Xh07Gzo7nGcSflYhTKWHh9ylv13Jt7RelEAxU7x+DapZlB
         RXnA==
X-Gm-Message-State: APjAAAXACDBSFbfy/qUqT9wRGCPMlQ9Q5ZUO+YMKXYI+nYI+6xO+mdQ5
        Ra0MfcYOYt8HBInUwJqXgsLaAA==
X-Google-Smtp-Source: APXvYqwc1fHMTfO4vUn3h27ylZ766i4Vt8r1xGmqoV11zEwrHFD04iCc59LCx2NOik+HmR7nluXWxA==
X-Received: by 2002:ac2:4242:: with SMTP id m2mr2186751lfl.121.1565871266139;
        Thu, 15 Aug 2019 05:14:26 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id q25sm462060ljg.30.2019.08.15.05.14.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 05:14:25 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc:     davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next v2 0/3] xdpsock: allow mmap2 usage for 32bits
Date:   Thu, 15 Aug 2019 15:13:53 +0300
Message-Id: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains several improvements for af_xdp socket umem
mappings for 32bit systems. Also, there is one more patch outside of
this series that on linux-next tree and related to mmap2 af_xdp umem
offsets: "mm: mmap: increase sockets maximum memory size pgoff for 32bits"
https://lkml.org/lkml/2019/8/12/549

Based on bpf-next/master

Prev: https://lkml.org/lkml/2019/8/13/437

v2..v1:
	- replaced "libbpf: add asm/unistd.h to xsk to get __NR_mmap2" on
	 "libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2
	 syscall"
	- use vmap along with page_address to avoid overkill
	- define mmap syscall trace5 for mmap if defined

Ivan Khoronzhuk (3):
  libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2 syscall
  xdp: xdp_umem: replace kmap on vmap for umem map
  samples: bpf: syscal_nrs: use mmap2 if defined

 net/xdp/xdp_umem.c         | 36 +++++++++++++++++++++++-----
 samples/bpf/syscall_nrs.c  |  6 +++++
 samples/bpf/tracex5_kern.c | 13 ++++++++++
 tools/lib/bpf/Makefile     |  1 +
 tools/lib/bpf/xsk.c        | 49 +++++++++++---------------------------
 5 files changed, 64 insertions(+), 41 deletions(-)

-- 
2.17.1

