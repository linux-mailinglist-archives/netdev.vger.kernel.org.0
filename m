Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE19C8F8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfHZGLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:11:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35211 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfHZGLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:11:16 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn20so9480312plb.2;
        Sun, 25 Aug 2019 23:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQ8V7KQdw5JCSfSPNekTuVfm5OO1JCPPgl/Rgpn3re8=;
        b=KBme8iaqhcnzlcwDy3uY3cH9m/T+YIJqeSodLY8BGqVm07b8wX8q6Jzhdh6MymsRok
         G5gVWPaxUMCh4d/ALf0XIUkqHy4x4OJEcciXcaeTAwQ9lkBkQU2eE1ExSA/v+GMNZtag
         joSQp2UWnhz87wlO6zHNk+aCgGbukxflFfIJnHtGMMryA8W8Xqkfkn1GyI3K7/VYtBMH
         D2a5My/HlTJonzjWO+vAoCDBwmYA1lRR1FoSX0ajM5rZgNZHmepEQzFv7wrf/nSnHUm+
         izgldYRYBH+0M1RMB/s5mnce/jzeQklXYLI6td+yIwbiDUSUmTknWsQtF++zfC+FKFrA
         xHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQ8V7KQdw5JCSfSPNekTuVfm5OO1JCPPgl/Rgpn3re8=;
        b=nLcr85R1fy7pPmUYvyApv1d2KZyEiAz0UDYBagkP4l7j06K1y4fa2vldw1/R/tKmGJ
         MfBpSGizAL9HdVB9hlDbmPbc0emCKlwcK9xSj3RFcTtWRdss94+BERLd0ixkce/kOU6+
         NBaWXAESH5wUJoeM5L7brhqAgZYmBaAG6pJ6m+v1R4UDqnsAKU8nE9keh6GAx7XxzL9v
         N8ty30ADQV1V+jO09ZCMKAe8QsEHGKqLxTvFVdimsq+8zAxzIzxcebV1rWfNoRTmC5Q5
         hyD8niK/FZDwnVimzMTvt41HCG+6FFwFe0OFXTOrMvRCQ9wW8DpkvwnaOzQG+dAgoK+Q
         R/2A==
X-Gm-Message-State: APjAAAWDJmB2jOeGhGneeOePYYcQ+ijkjzHS7YHLC0yzHoSLNwkg/Maj
        /5HeFsl9eIhmaZ1XSkR5N+Y=
X-Google-Smtp-Source: APXvYqycj8vBcVQwislncSPWkqoedWucbqALM6ke8xmTF3D9d5dG2hbaKo62jSZ6cQu7gnE/SA7azg==
X-Received: by 2002:a17:902:fa5:: with SMTP id 34mr1886460plz.285.1566799875850;
        Sun, 25 Aug 2019 23:11:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id d2sm9567452pjs.21.2019.08.25.23.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:11:15 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v2 0/4] xsk: various CPU barrier and {READ, WRITE}_ONCE fixes
Date:   Mon, 26 Aug 2019 08:10:49 +0200
Message-Id: <20190826061053.15996-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a four patch series of various barrier, {READ, WRITE}_ONCE
cleanups in the AF_XDP socket code. More details can be found in the
corresponding commit message.

For an AF_XDP socket, most control plane operations are done under the
control mutex (struct xdp_sock, mutex), but there are some places
where members of the struct is read outside the control mutex. This,
as pointed out by Daniel in [1], requires proper {READ,
WRITE}_ONCE-correctness [2] [3]. To address this, and to simplify the
code, the state variable (introduced by Ilya), is now used a point of
synchronization ("is the socket in a valid state, or not").


Thanks,
Björn

[1] https://lore.kernel.org/bpf/beef16bb-a09b-40f1-7dd0-c323b4b89b17@iogearbox.net/
[2] https://lwn.net/Articles/793253/
[3] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

v1->v2:
  Removed redundant dev check. (Jonathan)

Björn Töpel (4):
  xsk: avoid store-tearing when assigning queues
  xsk: add proper barriers and {READ, WRITE}_ONCE-correctness for state
  xsk: avoid store-tearing when assigning umem
  xsk: lock the control mutex in sock_diag interface

 net/xdp/xsk.c      | 61 +++++++++++++++++++++++++++++++---------------
 net/xdp/xsk_diag.c |  3 +++
 2 files changed, 45 insertions(+), 19 deletions(-)

-- 
2.20.1

