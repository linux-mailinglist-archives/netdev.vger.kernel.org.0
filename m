Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF89B98EE4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfHVJNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:13:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45423 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbfHVJNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:13:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id w26so3507687pfq.12;
        Thu, 22 Aug 2019 02:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ve0kUU0qLNwm3Q2yOn7y3CVKdgXEFZVbDWzW0GPjgmI=;
        b=ASnyzlgJImrl3SY34M109XDvGmS88DXNdoAahO+0aZunVQLBvS/x2MDzG+MDnWL8Gf
         rT0b3XVQxkFcTrKPfreKTT1VjSOfJabA5r9wxkOyW5rQOE2Lnb8OxmKbZrV5DKp/hsl6
         C3qpeb9Vh7qjZ4hKH86f4F8G0op0aitP/mqChNX2txxaijZA+edJzYcVUdY4TCdnH+sB
         AUmuLSkei15zF7OU679f3x96KogpmD5mSzW3i2hZacvsfCXohvNS23egnczIdl64Ga4F
         /yNo/zl4It5kypgGEonnHpFRq+odupqereYLb7rZ9uaTUFuHgssRQvD0OQJP8SRzANU/
         IwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ve0kUU0qLNwm3Q2yOn7y3CVKdgXEFZVbDWzW0GPjgmI=;
        b=XFV7RVXC3zTwL8nhbXmVungyU3EB6IN94owL6JA/9OC4FY3KyQgLej9eeIIIASEoKJ
         PsfsvfN6B6B+b2UrlxTt3gMgve1UxO/Xgo+d7hOvA8bX8HKY7i3xqcKHioakJCKJZERF
         82VLRszu8/ahisPs0yETr0AQf5Rcf9SRG2SOza0kKzrNfxVq7sma4nK4u7r25G8Xs3cv
         iltYyEbSfITfhmQgtEVBvoBWdCEeR9IC8xOS9TkoyhX5sPXnSni5ABmRu9PMDtPRNMbs
         D/v0VHYYGZdpnOGG4HRQqJY53QXVKqdj3e1i1qIGCT4qIQ2IZFy01MPdjqeNsaw+BLq0
         oQbw==
X-Gm-Message-State: APjAAAXD1S1MsqNJrS3OV+kmi19E940kuEj3fTOn79tNvIMJYderB4Bg
        Ldcf5urQvSTzUehHrvUeKfFLuUkx5KKlvw==
X-Google-Smtp-Source: APXvYqznyliqc24rWRQaD3BHBVkFHNO6+xyjgDNVtgxDBPfyJ0MEKfI9VPpElo+JLarrlu+iinH5Dg==
X-Received: by 2002:aa7:9d07:: with SMTP id k7mr39643968pfp.94.1566465222507;
        Thu, 22 Aug 2019 02:13:42 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id w207sm28414754pff.93.2019.08.22.02.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:13:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next 0/4] xsk: various CPU barrier and {READ, WRITE}_ONCE fixes
Date:   Thu, 22 Aug 2019 11:13:02 +0200
Message-Id: <20190822091306.20581-1-bjorn.topel@gmail.com>
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

Björn Töpel (4):
  xsk: avoid store-tearing when assigning queues
  xsk: add proper barriers and {READ, WRITE}_ONCE-correctness for state
  xsk: avoid store-tearing when assigning umem
  xsk: lock the control mutex in sock_diag interface

 net/xdp/xsk.c      | 61 ++++++++++++++++++++++++++++++++--------------
 net/xdp/xsk_diag.c |  3 +++
 2 files changed, 46 insertions(+), 18 deletions(-)

-- 
2.20.1

