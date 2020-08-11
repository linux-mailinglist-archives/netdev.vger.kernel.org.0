Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B344E241FBB
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 20:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHKSdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 14:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgHKSde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 14:33:34 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943DDC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:33:34 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bs17so9836137edb.1
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZoULUu91R536X4EAdla5O7lxYyN53fyTfSMXg980JA=;
        b=HwCjvu9ghpisNveNU98mhTaa5Rf0+3FJ9gNm2hRpzVfma225oPoc2gPYcF2q2D1pR1
         YYmgqNwmgmX1zPlIymaPGVmt2trY8d2pYZSDHPSWwyXRkdkObKNIEY3V867ufS7Mpj7h
         Utp5LU3hpHbJsjB8w9yb4uBDXFl66gBFB/U9N/Shtbltr28JE286t8u4mUYu0pKEtJkB
         0jL69PaRboLtUEbkNEG00NUiIS/yXLdBaSq5n5MprbJmgRQnZFETSguPl0avpdgl7SFU
         2wjLcV6NwKr/rxEKExCN6lm3pTGYRi4KlDJoIX5D0wGEYDo7r0gnIg0BCpLTGGCz6ark
         f1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZoULUu91R536X4EAdla5O7lxYyN53fyTfSMXg980JA=;
        b=obHTgq2PE/CiFyI953aRPWeFI9qyo+1dYCbGcFNKl66K9sj5TIe9LVnIqv5H6mJmC8
         cPbjV7etzir8VVo5fzpEwdm9AiLTLBmrraY9RlU/ICImIhalD3B+nztJqWPuYbG+p8QY
         uKS03yLj+JkkP+3DAk2vQ6sy+egk2lOG7W/TGuatFZHin4fCGDv5P1qMz0OHRr4RmwC0
         YUGATBYdlFjxXdvT+/7vMQbFb3o1rZmTs3W+rg5mNgtX8lLjETEEp3A0E6cVSs+OBwfB
         yqCAqSnfOHSx/N7zoGjkRKriKEPlymx/XpiZepuWb8p7iuaT2SSB6e5cwEBxeozSfE92
         SSJw==
X-Gm-Message-State: AOAM532eq0mQXM/hLcbkdVAfTv8IjeRLghCXv1o8BL3iQqAqYUXiWyQn
        8VLCXRXvldktVL0EzVYYs0zGOA==
X-Google-Smtp-Source: ABdhPJyxZCxr6/SIExSpsGzhUSnyB2195KeNWWnXLp46nLap735+g4R9QYigNNzv9QnW3OYpjSa/Ng==
X-Received: by 2002:a50:e611:: with SMTP id y17mr26554863edm.376.1597170812945;
        Tue, 11 Aug 2020 11:33:32 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14xncxzsvibs41.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:9d04:d01e:8e99:1111])
        by smtp.gmail.com with ESMTPSA id ch24sm15350222ejb.7.2020.08.11.11.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 11:33:32 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        KOVACS Krisztian <hidden@balabit.hu>
Cc:     Tim Froidcoeur <tim.froidcoeur@tessares.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v4 0/2] net: initialize fastreuse on inet_inherit_port
Date:   Tue, 11 Aug 2020 20:33:22 +0200
Message-Id: <20200811183325.42748-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
behaviour or in the incorrect reuse of a bind.

the kernel keeps track for each bind_bucket if all sockets in the
bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
These flags allow skipping the costly bind_conflict check when possible
(meaning when all sockets have the proper SO_REUSE option).

For every socket added to a bind_bucket, these flags need to be updated.
As soon as a socket that does not support reuse is added, the flag is
set to false and will never go back to true, unless the bind_bucket is
deleted.

Note that there is no mechanism to re-evaluate these flags when a socket
is removed (this might make sense when removing a socket that would not
allow reuse; this leaves room for a future patch).

For this optimization to work, it is mandatory that these flags are
properly initialized and updated.

When a child socket is created from a listen socket in
__inet_inherit_port, the TPROXY case could create a new bind bucket
without properly initializing these flags, thus preventing the
optimization to work. Alternatively, a socket not allowing reuse could
be added to an existing bind bucket without updating the flags, causing
bind_conflict to never be called as it should.

Patch 1/2 refactors the fastreuse update code in inet_csk_get_port into a
small helper function, making the actual fix tiny and easier to understand.

Patch 2/2 calls this new helper when __inet_inherit_port decides to create
a new bind_bucket or use a different bind_bucket than the one of the listen
socket.

v4: - rebase on latest linux/net master branch
v3: - remove company disclaimer from automatic signature
v2: - remove unnecessary cast

Tim Froidcoeur (2):
  net: refactor bind_bucket fastreuse into helper
  net: initialize fastreuse on inet_inherit_port

 include/net/inet_connection_sock.h |  4 ++
 net/ipv4/inet_connection_sock.c    | 97 ++++++++++++++++--------------
 net/ipv4/inet_hashtables.c         |  1 +
 3 files changed, 58 insertions(+), 44 deletions(-)

--
2.25.1
