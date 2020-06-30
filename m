Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B1120FCB6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgF3TY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgF3TY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:24:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5791C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:24:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jqLsD-0001iv-Sr; Tue, 30 Jun 2020 21:24:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>
Subject: [PATCH net-next 0/2] mptcp: add receive buffer auto-tuning
Date:   Tue, 30 Jun 2020 21:24:43 +0200
Message-Id: <20200630192445.18333-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch extends the test script to allow for reproducible results.
Second patch adds receive auto-tuning.  Its based on what TCP is doing,
only difference is that we use the largest RTT of any of the subflows
and that we will update all subflows with the new value.

Else, we get spurious packet drops because the mptcp work queue might
not be able to move packets from subflow socket to master socket
fast enough.  Without the adjustment, TCP may drop the packets because
the subflow socket is over its rcvbuffer limit.

Florian Westphal (2):
      selftests: mptcp: add option to specify size of file to transfer
      mptcp: add receive buffer auto-tuning

 net/mptcp/protocol.c                               | 123 +++++++++++++++++++--
 net/mptcp/protocol.h                               |   7 ++
 net/mptcp/subflow.c                                |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  52 ++++++---
 4 files changed, 166 insertions(+), 21 deletions(-)

