Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32F92FCEFE
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbhATLQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387737AbhATKmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:42:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=U6t1dHwL2h2hcfIAGf53SrGhVgGdK1fB6Xe92SBL0p0=;
        b=SrGV/v3/FNuTHxpgV1Way/uYRIIwD5NPu5HciUYB5X09GuS7kaDtOLyQZ4/bfXPai31/EF
        PGlsyHdL8oZof2v1aQzv6nPr8rs0UcBymeubNA2WeZwtDBGEZArDkUajk6wRS3FZwSo+3u
        j3c93QxyWlLRbEpFSoKkdgsVbWfyVtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-9IO_YI-mMWO7PHKrhhKwgg-1; Wed, 20 Jan 2021 05:41:13 -0500
X-MC-Unique: 9IO_YI-mMWO7PHKrhhKwgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D7DBAFA81;
        Wed, 20 Jan 2021 10:41:12 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 188A860C6A;
        Wed, 20 Jan 2021 10:41:10 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 0/5] mptcp: re-enable sndbuf autotune
Date:   Wed, 20 Jan 2021 11:40:35 +0100
Message-Id: <cover.1610991949.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sendbuffer autotuning was unintentionally disabled as a
side effect of the recent workqueue removal refactor. These
patches re-enable id, with some extra care: with autotuning
enable/large send buffer we need a more accurate packet
scheduler to be able to use efficiently the available
subflow bandwidth, especially when the subflows have
different capacities.

The first patch cleans-up subflow socket handling, making
the actual re-enable (patch 2) simpler.

Patches 3 and 4 improve the packet scheduler, to better cope
with non trivial scenarios and large send buffer. 

Finally patch 5 adds and uses some infrastructure to avoid
the workqueue usage for the packet scheduler operations introduced
by the previous patches.

Paolo Abeni (5):
  mptcp: always graft subflow socket to parent
  mptcp: re-enable sndbuf autotune
  mptcp: do not queue excessive data on subflows
  mptcp: schedule work for better snd subflow selection
  mptcp: implement delegated actions

 net/mptcp/protocol.c | 176 ++++++++++++++++++++++++++++---------------
 net/mptcp/protocol.h |  72 ++++++++++++++++++
 net/mptcp/subflow.c  |  49 +++++++++++-
 3 files changed, 234 insertions(+), 63 deletions(-)

-- 
2.26.2

