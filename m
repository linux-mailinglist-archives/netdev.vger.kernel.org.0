Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D87351AD2
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhDASDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235199AbhDAR7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BNxjjSggvaGqqbW1N4ymXDNSnuDdNSwnCnFTODCH6lA=;
        b=I54DA7wNYJBnTsvF1Xwia/U//rH/RCDUQaSTavRmZKU867feRo8GSRdv9yaEqby4hVr9bk
        tphcoukwA+xO5CbcNndmm+cWZSJ6C57K2KzsCVH1cqZCc+zh8IgN2LKtWg+23ucDHCvagh
        xekyGxg6dU1uFT14di2jeqi+E1MlTCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-OHCYwUDDMwSCGkcnNMIA3g-1; Thu, 01 Apr 2021 12:58:09 -0400
X-MC-Unique: OHCYwUDDMwSCGkcnNMIA3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D5A7190B2A0;
        Thu,  1 Apr 2021 16:58:08 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-240.ams2.redhat.com [10.36.114.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C67BD19C46;
        Thu,  1 Apr 2021 16:58:06 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] mptcp: mptcp: fix deadlock in mptcp{,6}_release
Date:   Thu,  1 Apr 2021 18:57:43 +0200
Message-Id: <cover.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller has reported a few deadlock triggered by
mptcp{,6}_release.

These patches address the issue in the easy way - blocking
the relevant, multicast related, sockopt options on MPTCP
sockets.

Note that later on net-next we are going to revert patch 1/2,
as a part of a larger MPTCP sockopt implementation refactor 

Paolo Abeni (2):
  mptcp: forbit mcast-related sockopt on MPTCP sockets
  mptcp: revert "mptcp: provide subflow aware release function"

 net/mptcp/protocol.c | 100 ++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 53 deletions(-)

-- 
2.26.2

