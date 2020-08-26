Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EE3253860
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHZTkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZTkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 15:40:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F10B2076C;
        Wed, 26 Aug 2020 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598470810;
        bh=ARCsePM4U5cyGQ9q5wju6jf2KfGwFsdgiSLmv/UNiHs=;
        h=From:To:Cc:Subject:Date:From;
        b=gSdxup9OjHoCBLMpN/XCh0FMkwP1ZXrabGp04v8EaWkpu0yXC1xERAO3jFJcXRBDj
         VA4V5xduBPzSulmdqC/hEncnT8MwVmvOl8TeXc7Ui6dEPXelES7154wyZxjXU3ydS5
         H2cv4ilepDcwakAck7YT3zQ4YopS/rgXgxln6Y8M=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     eric.dumazet@gmail.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] net: fix netpoll crash with bnxt
Date:   Wed, 26 Aug 2020 12:40:05 -0700
Message-Id: <20200826194007.1962762-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Rob run into crashes when using XDP on bnxt. Upon investigation
it turns out that during driver reconfig irq core produces
a warning message when IRQs are requested. This triggers netpoll,
which in turn accesses uninitialized driver state. Same crash can
also be triggered on this platform by changing the number of rings.

Looks like we have two missing pieces here, netif_napi_add() has
to make sure we start out with netpoll blocked. The driver also
has to be more careful about when napi gets enabled.

Tested XDP and channel count changes, the warning message no longer
causes a crash. Not sure if the memory barriers added in patch 1
are necessary, but it seems we should have them.

Jakub Kicinski (2):
  net: disable netpoll on fresh napis
  bnxt: don't enable NAPI until rings are ready

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++--------
 net/core/dev.c                            |  3 ++-
 net/core/netpoll.c                        |  2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

-- 
2.26.2

