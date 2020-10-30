Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604B02A03DB
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgJ3LQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgJ3LQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 07:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604056587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zN/2wEN1nq+6oDFes+ZSVFeU2EPzWo+1IwapIFjYhac=;
        b=XquinrHSGpyu3Rdg8QKTkkBvr6HhxFXBLzGdQSgEKO8oQEA8Oh/jqlMpdIlEqKpwdTrtxN
        2/spPjyB+xPcvkJ2D/fnTS1qkqBQ5KIDAqqNjLYHLZmHBdgs1aYNwoNOnfxmYiXFOsGS18
        rSz7+xojY+f/4kTko+GU4hVZqK0d188=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Lp4bITb-PByMuZtL0Cekjg-1; Fri, 30 Oct 2020 07:16:25 -0400
X-MC-Unique: Lp4bITb-PByMuZtL0Cekjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0AB1809DEF;
        Fri, 30 Oct 2020 11:16:23 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-14.ams2.redhat.com [10.36.114.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC71E109F192;
        Fri, 30 Oct 2020 11:16:21 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next v2 0/3] net: introduce rps_default_mask
Date:   Fri, 30 Oct 2020 12:16:00 +0100
Message-Id: <cover.1604055792.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Real-time setups try hard to ensure proper isolation between time
critical applications and e.g. network processing performed by the
network stack in softirq and RPS is used to move the softirq 
activity away from the isolated core.

If the network configuration is dynamic, with netns and devices
routinely created at run-time, enforcing the correct RPS setting
on each newly created device allowing to transient bad configuration
became complex.

These series try to address the above, introducing a new
sysctl knob: rps_default_mask. The new sysctl entry allows
configuring a systemwide RPS mask, to be enforced since receive 
queue creation time without any fourther per device configuration
required.

Additionally, a simple self-test is introduced to check the 
rps_default_mask behavior.

v1 -> v2:
 - fix sparse warning in patch 2/3

Paolo Abeni (3):
  net/sysctl: factor-out netdev_rx_queue_set_rps_mask() helper
  net/core: introduce default_rps_mask netns attribute
  self-tests: introduce self-tests for RPS default mask

 Documentation/admin-guide/sysctl/net.rst      |  6 ++
 include/linux/netdevice.h                     |  1 +
 net/core/net-sysfs.c                          | 73 +++++++++++--------
 net/core/sysctl_net_core.c                    | 58 +++++++++++++++
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/config            |  3 +
 .../testing/selftests/net/rps_default_mask.sh | 57 +++++++++++++++
 7 files changed, 169 insertions(+), 30 deletions(-)
 create mode 100755 tools/testing/selftests/net/rps_default_mask.sh

-- 
2.26.2

