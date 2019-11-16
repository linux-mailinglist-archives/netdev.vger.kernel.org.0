Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BEEFEB4D
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 10:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKPJPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 04:15:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726814AbfKPJPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 04:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573895730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QDu18Mloig89ndXoAMZhBaSvzIzoluShQUmKSI/WsHU=;
        b=gtSL5XA18psX68LS9QO1iNITFUpsdGXr8KfmLvFY5rZffjsFCxLkuvxptqky3OZ6TYGohe
        BxNI7C19m3JwKuoiwGpEOHvWCALE08fA9IZk3taOwo/re4L9zrYSP0w3DBKAK9hQLJpwnU
        8kXimbrrE8uto/oxup3tSyPXyhLZV5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-mqWu2DZ5NwmAAzOwrC-eug-1; Sat, 16 Nov 2019 04:15:26 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4F351005500;
        Sat, 16 Nov 2019 09:15:24 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-32.ams2.redhat.com [10.36.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 999C05DDB3;
        Sat, 16 Nov 2019 09:15:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/2] net: introduce and use route hint
Date:   Sat, 16 Nov 2019 10:14:49 +0100
Message-Id: <cover.1573893340.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: mqWu2DZ5NwmAAzOwrC-eug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series leverages the listification infrastructure to avoid
unnecessary route lookup on ingress packets. In absence of policy routing,
packets with equal daddr will usually land on the same dst.

When processing packet bursts (lists) we can easily reference the previous
dst entry. When we hit the 'same destination' condition we can avoid the
route lookup, coping the already available dst.

Detailed performance numbers are available in the individual commit message=
s.

Paolo Abeni (2):
  ipv6: introduce and uses route look hints for list input
  ipv4: use dst hint for ipv4 list receive

 include/net/route.h  | 11 +++++++++++
 net/ipv4/ip_input.c  | 29 ++++++++++++++++++++++++-----
 net/ipv4/route.c     | 38 ++++++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_input.c | 30 ++++++++++++++++++++++++++----
 4 files changed, 99 insertions(+), 9 deletions(-)

--=20
2.21.0

