Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61934570AA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhKSObm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:31:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhKSObl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637332119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K5J74Mu1G8wQTJihUKx9JZPZVqeHh/vB5/vkuhev9ow=;
        b=Sm82mHamtoPsA0/tvX3LJeqdLRgIwOZq7paAlITuxwYrkso9BCaA7SklwpiyDa9csfFRps
        tvjK9uTuygMjvHzC9OtLkkOJS/rHGTnHODIVTeePMuekacIBUzY89KNDxkqb0rtjn/asJY
        4qPjPzx9WkALADUA3HWqXgFag6x+C5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-Hx1sGePdNgioga9QVRFqwA-1; Fri, 19 Nov 2021 09:28:38 -0500
X-MC-Unique: Hx1sGePdNgioga9QVRFqwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AA86802E62;
        Fri, 19 Nov 2021 14:28:37 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FFE160657;
        Fri, 19 Nov 2021 14:28:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 0/2] mptcp: fix 3rd ack rtx timer
Date:   Fri, 19 Nov 2021 15:27:53 +0100
Message-Id: <cover.1637331462.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric noted that the MPTCP code do the wrong thing to schedule
the MPJ 3rd ack timer. He also provided a patch to address the
issues (patch 1/2).

To fix for good the MPJ 3rd ack retransmission timer, we additionally
need to set it after the current ack is transmitted (patch 2/2)

Note that the bug went unnotice so far because all the related
tests required some running data transfer, and that causes
MPTCP-level ack even on the opening MPJ subflow. We now have
explicit packet drill coverage for this code path.

Eric Dumazet (1):
  mptcp: fix delack timer

Paolo Abeni (1):
  mptcp: use delegate action to schedule 3rd ack retrans

 net/mptcp/options.c  | 32 ++++++++-------------------
 net/mptcp/protocol.c | 51 ++++++++++++++++++++++++++++++++++++--------
 net/mptcp/protocol.h | 17 ++++++++-------
 3 files changed, 60 insertions(+), 40 deletions(-)

-- 
2.33.1

