Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D916610B74D
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfK0URz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:17:55 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36292 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfK0URz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:17:55 -0500
Received: by mail-lf1-f65.google.com with SMTP id f16so18220227lfm.3
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWnzn2pe2sgG+LM5w/Mnl6XExRWVUiFSE8X/ZiWOAVc=;
        b=WU/5oGDgft/V8GlIir0ifCIf3gaUnhu4LufOQEywoRjY2lNsYQfwSCmhlSn/qYJcaa
         JJAlZmMw3B6jcM2IiELqyT6UoZn77/9YXScc1V2/Mo+QYX9UXQVEhmlAo5XuMVxhCoT8
         oXNfYalDh/IjV6HXfJ38rfHft3wQ4V0zekRwTTowmrf8KqXMR5mblVYf68tI22WKNVr/
         7DMhCWegWX7cBqH4VoAMRKuxLtPdDdXVGu7MminRGQw7sioP4WaQ9ED6a+Iaa3YxCGD5
         UpOuh8yEfliO8tvxWj5EQe1PpegmnLD1ikGbdsEVDKMbnPyBFeRR14CT9BHcTb0m6NWW
         0VJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWnzn2pe2sgG+LM5w/Mnl6XExRWVUiFSE8X/ZiWOAVc=;
        b=TmcuSvdOpeCEuxd1JtOj6T7WkpRJ8cfOJNdEcKn9F3495x5Lu24/L8ek8nQNlinfI9
         wysGPMQa0eHG04TPblZ0UymVlwIRVnDF8hS+1Fyt0/rrkPYUvjnTzgWkTpR/vBXBLXM4
         Ah+uV6FbP4oQw+j0G8E8WRLoXqXBTpJ3XeX4jvsHsKCZh2NQRTabqgiX92dkSp06uOmH
         9M4KtwmNFLo6jzfTjr3BG6h60TpMsdOci58LzIbWT4BNR5WmxSNZ2A3jOKY2nVdoryUs
         yGgVdoV+PQye6juJOOn0t+5JEvcAqXeSXXzoAz5tByan7K+H71Z8eYnac5g/S+hiZICl
         PHvA==
X-Gm-Message-State: APjAAAWDUGcPKtOKvFaOZ0Je0uCXC4ca7eVlWiKZ8Q7nGHj/JSbqF+OS
        rOoZ5LT/kJwQiF8MGwyXEny3V6EyL9s=
X-Google-Smtp-Source: APXvYqyqEKpBvkX8rHj6rf5PQ3PPfl3agadfBqgrviEpPiRID9mXjBijOm/27syUX2flxZR81OA6hA==
X-Received: by 2002:a19:c3ca:: with SMTP id t193mr16973002lff.40.1574885873584;
        Wed, 27 Nov 2019 12:17:53 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.17.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:17:52 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/8] net: tls: fix scatter-gather list issues
Date:   Wed, 27 Nov 2019 12:16:38 -0800
Message-Id: <20191127201646.25455-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series kicked of by a syzbot report fixes three issues around
scatter gather handling in the TLS code. First patch fixes a use-
-after-free situation which may occur if record was freed on error.
This could have already happened in BPF paths, and patch 2 now makes
the same condition occur in non-BPF code.

Patch 2 fixes the problem spotted by syzbot. If encryption failed
we have to clean the end markings from scatter gather list. As
suggested by John the patch frees the record entirely and caller
may retry copying data from user space buffer again.

Third patch fixes a bug in the TLS 1.3 code spotted while working
on patch 2. TLS 1.3 may effectively overflow the SG list which
leads to the BUG() in sg_page() being triggered.

Patch 4 adds a test case which triggers this bug reliably.

Next two patches are small cleanups of dead code and code which
makes dangerous assumptions.

Last but not least two minor improvements to the sockmap tests.

Tested:
 - bpf/test_sockmap
 - net/tls
 - syzbot repro (which used error injection, hence no direct
   selftest is added to preserve it).

Jakub Kicinski (8):
  net/tls: take into account that bpf_exec_tx_verdict() may free the
    record
  net/tls: free the record on encryption error
  net: skmsg: fix TLS 1.3 crash with full sk_msg
  selftests/tls: add a test for fragmented messages
  net/tls: remove the dead inplace_crypto code
  net/tls: use sg_next() to walk sg entries
  selftests: bpf: test_sockmap: handle file creation failures gracefully
  selftests: bpf: correct perror strings

 include/linux/skmsg.h                      | 28 +++++-----
 include/net/tls.h                          |  3 +-
 net/core/filter.c                          |  8 +--
 net/core/skmsg.c                           |  2 +-
 net/ipv4/tcp_bpf.c                         |  2 +-
 net/tls/tls_main.c                         | 13 +----
 net/tls/tls_sw.c                           | 32 +++++++-----
 tools/testing/selftests/bpf/test_sockmap.c | 47 ++++++++++-------
 tools/testing/selftests/bpf/xdping.c       |  2 +-
 tools/testing/selftests/net/tls.c          | 60 ++++++++++++++++++++++
 10 files changed, 131 insertions(+), 66 deletions(-)

-- 
2.23.0

