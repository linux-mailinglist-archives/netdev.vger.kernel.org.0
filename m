Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9685D222F1A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGPXfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgGPXfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:35:17 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0959C207E8;
        Thu, 16 Jul 2020 22:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937816;
        bh=4lqM8fbe+l0p5rRK1uHJW36r73ciPMzmX+L6OP8CQDY=;
        h=From:To:Cc:Subject:Date:From;
        b=P+/M+2tliioKfzwZGtrBCf8yDZ/s9VBRPeDlaJo08ELtDLQaSYJ9r24FDL2BVRPIP
         ThbGwT7xfYks4giIAC6iH0GMZUJ3RFvGWaSzon+Pty0Zyr8r55V1x2Pwfe8TiQaccM
         ECR4dZG3Nn08ocuIeTuI3oz2H6nNTj6kEcb7wlzY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH v2 net-next 0/6] rework mvneta napi_poll loop for XDP multi-buffers
Date:   Fri, 17 Jul 2020 00:16:28 +0200
Message-Id: <cover.1594936660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework mvneta_rx_swbm routine in order to process all rx descriptors before
building the skb or run the xdp program attached to the interface.
Introduce xdp_get_shared_info_from_{buff,frame} utility routines to get the
skb_shared_info pointer from xdp_buff or xdp_frame.
This is a preliminary series to enable multi-buffers and jumbo frames for XDP
according to [1]

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org

Changes since v1:
- rely on skb_frag_* utility routines to access page/offset/len of the xdp multi-buffer

Lorenzo Bianconi (6):
  xdp: introduce xdp_get_shared_info_from_{buff,frame} utility routines
  net: mvneta: move skb build after descriptors processing
  net: mvneta: move mvneta_run_xdp after descriptors processing
  net: mvneta: drop all fragments in XDP_DROP
  net: mvneta: get rid of skb in mvneta_rx_queue
  net: mvneta: move rxq->left_size on the stack

 drivers/net/ethernet/marvell/mvneta.c | 221 ++++++++++++++------------
 include/net/xdp.h                     |  15 ++
 2 files changed, 138 insertions(+), 98 deletions(-)

-- 
2.26.2

