Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368E820B6EE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgFZR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:27:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbgFZR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593192428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y+EqkHhZOPIBxR+QDj7Zty6OskdxX+Ma6e695FyuAE8=;
        b=ItsYI5tifxCeuLHYm+vWSHGywW85fDYZuSuw8rIEnSgENGHM9RJGWCoVb/4IWR2ceoQ++v
        SYPqIpJz9NxFrih/9NBfg/S5mKXEYtajwDyIKUE5O2gmXWIwijT1rAAucghyjV5WC8j4/n
        U1vHsEdUdNZXFn9w5fyD77VhiC1shMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-u6GsI7G2P_mmF3WtqlU6cQ-1; Fri, 26 Jun 2020 13:27:06 -0400
X-MC-Unique: u6GsI7G2P_mmF3WtqlU6cQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 310BD10059A2;
        Fri, 26 Jun 2020 17:27:05 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E52D51C8;
        Fri, 26 Jun 2020 17:27:00 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, teigland@redhat.com, ccaulfie@redhat.com,
        cluster-devel@redhat.com, netdev@vger.kernel.org,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCHv2 dlm-next 0/3] fs: dlm: add support to set skb mark value
Date:   Fri, 26 Jun 2020 13:26:47 -0400
Message-Id: <20200626172650.115224-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series adds support for setting the skb mark value as socket
option. It's not possible yet to change this after the socket is
created, although the mark value can be changed afterwards.

How to test it:

1. Setup mark values

echo 0xcafe > /sys/kernel/config/dlm/cluster/mark
echo 0xbeef > /sys/kernel/config/dlm/cluster/comms/2/mark

Note: setting a mark value for local node has no effect.

2. Add some skb mark classifier:

tc qdisc add dev $DEV root handle 1: htb
tc filter add dev $DEV parent 1: u32 match mark 0xcafe 0xffffffff action ok
tc filter add dev $DEV parent 1: u32 match mark 0xbeef 0xffffffff action ok

3. Mount e.g. gfs2

4. dump stats:

tc -s -d filter show dev $DEV

5. Open e.g. wireshark and check the success rate of stats

I have also patches for dlm user space to set these values via
dlm controld.

- Alex

changes since v2:

- rebase on current dlm/next branch
- because rebase it's necessary now to add PATCH 1/3. Please netdev
  maintainers, reply if it's okay to merge this one patch into dlm/next.
  Due other patches in dlm/next it's as well not possible to merge
  everything in net-next. Thanks.

Alexander Aring (3):
  net: sock: add sock_set_mark
  fs: dlm: set skb mark for listen socket
  fs: dlm: set skb mark per peer socket

 fs/dlm/config.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/dlm/config.h    |  2 ++
 fs/dlm/lowcomms.c  | 19 +++++++++++++++++++
 include/net/sock.h |  1 +
 net/core/sock.c    |  8 ++++++++
 5 files changed, 74 insertions(+)

-- 
2.26.2

