Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96EB273028
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgIURDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729104AbgIURDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:03:02 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C50C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 10:03:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so4993669pfo.12
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 10:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8W8um3OIG6ggsXPfAYJ4d/daqvL2tijxQxq/X64q5kY=;
        b=qVJ4/Kc/vh6Ylu6Ofb//n9bjJruSMURy5b9Q9zyz05feFnxVfYxsepOj13B5n0Y1jm
         ED2R5dc+9ubTLbKLTckeM++81PEsdnvRzyWNISVZueg2jhmXskrcAaS4hzl8sNY+UXZ9
         f/x9XT77XNpAVHOwrY4x1zziECJzQ8AwCdlEwM8rZr+nPlBaojXOegrn5jgVMwqNPia4
         1XALyd7m7jTUokZqEXP3QnVjiI1rf2D43QHyhiH+7a1vAZsM8PfIIbgFYM6nZa5jzKFS
         56AVtZkol6PQYHOWK1Q++PRSUQHbhG/T+tOq++8qbRofpEWfuhubayTyiUjX4uV1ssrS
         VtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8W8um3OIG6ggsXPfAYJ4d/daqvL2tijxQxq/X64q5kY=;
        b=S9uwdfu7HGhph+038OT09iLCpc3xXjJSF/fpuCGoAUXWRTQrv+u8td5gt7wwaFq+N1
         2VXiCXGpnHdaLk/tylilH+5LPaooILvi9hFIgU93+NkBZIdZtGMQoezwwwbyZSvAGoAJ
         NT54WuwnLPc1+2rP/efoNgAIgtcXo69k4d9cSv3TNsRlhtY+6z1zmT6QkBX+3kguR3aH
         RfVhTyREmK+ZmxEMi+TRUms8nTkEeS6jXuy4WdeMiS3xMEvM+MvOZtgfU9qAtnkT8TKM
         CO5bFQ5OSNltB3MPbgcSrg/4QO21VX4YVygWxzjKhGFVpIv3leH2XMTIqdjdGWK2eMH2
         uqxw==
X-Gm-Message-State: AOAM530Sd+Lgjba4xxidRMg429cDvInQ40FADMyWUQVXFD4GibYeD0gx
        lUrrSG8dYJLbLLlrbaqi+sU=
X-Google-Smtp-Source: ABdhPJwVn3zgwBNmIGOCQCG2/evW7C/dVZITiaac0j77eidrO54qGA9I/K7f0TbUqgHekBwJ7qGlWg==
X-Received: by 2002:a63:2142:: with SMTP id s2mr452024pgm.332.1600707781360;
        Mon, 21 Sep 2020 10:03:01 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id z1sm8507348pgu.80.2020.09.21.10.02.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 10:03:00 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next v2 PATCH 0/2] Introduce mbox tracepoints for Octeontx2
Date:   Mon, 21 Sep 2020 22:32:40 +0530
Message-Id: <1600707762-24422-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

This patchset adds tracepoints support for mailbox.
In Octeontx2, PFs and VFs need to communicate with AF
for allocating and freeing resources. Once all the
configuration is done by AF for a PF/VF then packet I/O
can happen on PF/VF queues. When an interface
is brought up many mailbox messages are sent
to AF for initializing queues. Say a VF is brought up
then each message is sent to PF and PF forwards to
AF and response also traverses from AF to PF and then VF.
To aid debugging, tracepoints are added at places where
messages are allocated, sent and message interrupts.
Below is the trace of one of the messages from VF to AF
and AF response back to VF:

~ # echo 1 > /sys/kernel/tracing/events/rvu/enable
~ # ifconfig eth20 up
[  279.379559] eth20 NIC Link is UP 10000 Mbps Full duplex
~ # cat /sys/kernel/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 880/880   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        ifconfig-171   [000] ....   275.753345: otx2_msg_alloc: [0002:02:00.1] msg:(0x400) size:40

        ifconfig-171   [000] ...1   275.753347: otx2_msg_send: [0002:02:00.1] sent 1 msg(s) of size:48

          <idle>-0     [001] dNh1   275.753356: otx2_msg_interrupt: [0002:02:00.0] mbox interrupt VF(s) to PF (0x1)

    kworker/u9:1-90    [001] ...1   275.753364: otx2_msg_send: [0002:02:00.0] sent 1 msg(s) of size:48

    kworker/u9:1-90    [001] d.h.   275.753367: otx2_msg_interrupt: [0002:01:00.0] mbox interrupt PF(s) to AF (0x2)

    kworker/u9:2-167   [002] ....   275.753535: otx2_msg_process: [0002:01:00.0] msg:(0x400) error:0

    kworker/u9:2-167   [002] ...1   275.753537: otx2_msg_send: [0002:01:00.0] sent 1 msg(s) of size:32

          <idle>-0     [003] d.h1   275.753543: otx2_msg_interrupt: [0002:02:00.0] mbox interrupt AF to PF (0x1)

          <idle>-0     [001] d.h2   275.754376: otx2_msg_interrupt: [0002:02:00.1] mbox interrupt PF to VF (0x1)


v2 changes:
 Removed otx2_msg_err tracepoint since it is similar to devlink_hwerr
 and it will be used instead when devlink supported is added.

Subbaraya Sundeep (2):
  octeontx2-af: Introduce tracepoints for mailbox
  octeontx2-pf: Add tracepoints for PF/VF mailbox

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  11 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |  14 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  | 103 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   6 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 9 files changed, 148 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h

-- 
2.7.4

