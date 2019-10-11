Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E40D3B1C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfJKI3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:29:50 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:39857 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKI3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:29:50 -0400
Received: by mail-lj1-f174.google.com with SMTP id y3so8955767ljj.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 01:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nmdN7JMNTYscQBNR+E6gnmp9TFuIjTpURDuQtDu+M4=;
        b=n7u2TRWNa8qxxSFP1TwtwI0Su6xhZ9xX4XDfCGGz4usGI1NpGKzsW/FtgucGHfwI1y
         3yGfl/HTCTBxHRyrvDJ5P0Wi9gTlNvzFotCMy4wtAmZqSYSNPqZSu61DCYzgkKXwjToO
         Db8LZXHEosk7MaGKGE6M0FPVPNlNKLiH/0yzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nmdN7JMNTYscQBNR+E6gnmp9TFuIjTpURDuQtDu+M4=;
        b=L98hxRSuoRYxd43lSVx0LK6HEksGum+5n+jyeFCcVxmfU4SWuXITWXrBgLFATzZH1N
         w9CgHawuAOTlCoOpX839RuHO99+P9AxXEAVz3dSnbooQvRJXwpvhIntgerIJrQE4B/y+
         6PHSjb/iMiZ2drKVNd8C7N0OLjDcIb6vFbt35WmR/eQ2yGG4CzkuTyq/OumTuZKBktHt
         OdbRINxSNCwZOP1dGOGEgeaSo1wVTkZV3ziJqN8JwPWGMriioM5VAg60F40fOp/+Xmse
         2S+WY1mvWxA5jojkKoYWgkfYrvPdexQcVeO/i4l0BtO16G1pdcGy5K807ZsjFZKxmT/k
         tD5g==
X-Gm-Message-State: APjAAAUiH9pvp47cAxu2Ib2pftTAXLiMIklGVBFirCn/RV1oIg6tzKcH
        fOcnvgYqDXpdkK/8Ir2lJA1arbnYJgy1Mg==
X-Google-Smtp-Source: APXvYqyCnKNdd5sWBsH5XbyhBusHqKTGyY1Y7HhI2kSe5CnqmCRvFgD/hycIF5bzYsMHzU17/phdow==
X-Received: by 2002:a2e:8ec2:: with SMTP id e2mr7906155ljl.126.1570782587831;
        Fri, 11 Oct 2019 01:29:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h25sm2240656lfj.81.2019.10.11.01.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 01:29:47 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v3 0/2] Atomic flow dissector updates
Date:   Fri, 11 Oct 2019 10:29:44 +0200
Message-Id: <20191011082946.22695-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set changes how bpf(BPF_PROG_ATTACH) operates on flow dissector
hook when there is already a program attached. After this change the user
is allowed to update the program in a single syscall. Please see the first
patch for rationale.

v1 -> v2:

- Don't use CHECK macro which expects BPF program run duration, which we
  don't track in attach/detach tests. Suggested by Stanislav Fomichev.

- Test re-attaching flow dissector in both root and non-root network
  namespace. Suggested by Stanislav Fomichev.

v2 -> v3:

- Rebased onto recent bpf-next 63098555cfe0 ("Merge branch
  'bpf-romap-known-scalars'").


Jakub Sitnicki (2):
  flow_dissector: Allow updating the flow dissector program atomically
  selftests/bpf: Check that flow dissector can be re-attached

 net/core/flow_dissector.c                     |  10 +-
 .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
 2 files changed, 134 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c

-- 
2.20.1

