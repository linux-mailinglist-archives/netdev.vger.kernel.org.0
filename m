Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097DE16FA61
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgBZJPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:02 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60756 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgBZJPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smT-0001MH-2J; Wed, 26 Feb 2020 10:15:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/7] mptcp: update mptcp ack sequence outside of recv path
Date:   Wed, 26 Feb 2020 10:14:45 +0100
Message-Id: <20200226091452.1116-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series moves mptcp-level ack sequence update outside of the recvmsg path.
Current approach has two problems:

1. There is delay between arrival of new data and the time we can ack
   this data.
2. If userspace doesn't call recv for some time, mptcp ack_seq is not
   updated at all, even if this data is queued in the subflow socket
   receive queue.

Move skbs from the subflow socket receive queue to the mptcp-level
receive queue, updating the mptcp-level ack sequence and have recv
take skbs from the mptcp-level receive queue.

The first place where we will attempt to update the mptcp level acks
is from the subflows' data_ready callback, even before we make userspace
aware of new data.

Because of possible deadlock (we need to take the mptcp socket lock
while already holding the subflow sockets lock), we may still need to
defer the mptcp-level ack update.  In such case, this work will be either
done from work queue or recv path, depending on which runs sooner.

In order to avoid pointless scheduling of the work queue, work
will be queued from the mptcp sockets lock release callback.
This allows to detect when the socket owner did drain the subflow
socket receive queue.

Please see individual patches for more information.

Florian Westphal (5):
      mptcp: add and use mptcp_data_ready helper
      mptcp: update mptcp ack sequence from work queue
      mptcp: add rmem queue accounting
      mptcp: remove mptcp_read_actor
      mptcp: avoid work queue scheduling if possible

Paolo Abeni (2):
      mptcp: add work queue skeleton
      mptcp: defer work schedule until mptcp lock is released

 net/mptcp/protocol.c | 364 ++++++++++++++++++++++++++++++++++++++-------------
 net/mptcp/protocol.h |   9 +-
 net/mptcp/subflow.c  |  32 ++---
 3 files changed, 289 insertions(+), 116 deletions(-)

