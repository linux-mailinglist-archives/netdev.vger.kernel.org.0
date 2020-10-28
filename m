Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5F29D42F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgJ1VuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727983AbgJ1VuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kCjuSxD9PWZ01VVieZeWYp+pKTX2nJJcX5fTmYsnD+Y=;
        b=HULJ/owdcOsYOgsCchfyqQzMicgIHgSRACKfyAkoXdrrXDOSBYmLVvF7y7A3Vw8EX8GQWo
        0ja1i2jN5T0Opo36ytYGJa49mOA2kPGVThMmy+eUqiqLK4YylatCyfMQwyJHjGVrlJ4ElO
        yHZLGdFcH8JYMwAvJmwgYddwb8h1lTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-yCYzPnDJMtGOtDjH2bl5VA-1; Wed, 28 Oct 2020 13:46:57 -0400
X-MC-Unique: yCYzPnDJMtGOtDjH2bl5VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD83EAD22B;
        Wed, 28 Oct 2020 17:46:32 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-68.ams2.redhat.com [10.36.115.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA3C46FEE6;
        Wed, 28 Oct 2020 17:46:20 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH net-next 0/3] net: introduce rps_default_mask
Date:   Wed, 28 Oct 2020 18:46:00 +0100
Message-Id: <cover.1603906564.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Paolo Abeni (3):
  net/sysctl: factor-out netdev_rx_queue_set_rps_mask() helper
  net/core: introduce default_rps_mask netns attribute
  self-tests: introduce self-tests for RPS default mask

 Documentation/admin-guide/sysctl/net.rst      |  6 ++
 net/core/net-sysfs.c                          | 75 +++++++++++--------
 net/core/sysctl_net_core.c                    | 58 ++++++++++++++
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/config            |  3 +
 .../testing/selftests/net/rps_default_mask.sh | 57 ++++++++++++++
 6 files changed, 170 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/net/rps_default_mask.sh

-- 
2.26.2

