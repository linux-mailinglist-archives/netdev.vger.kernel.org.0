Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDF0CD94D
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfJFV3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 17:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbfJFV3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 17:29:01 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCC4E2077B
        for <netdev@vger.kernel.org>; Sun,  6 Oct 2019 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570397340;
        bh=ltsKrEnfriugzI1UYJjJQZy2PDHrvjGmABrB0ebZvTY=;
        h=From:To:Subject:Date:From;
        b=obNty9AbTccbQDUHVr5JMiKDIZYnNY/BfKebVwZICMK1w0xCdzz88n1x0tc+VqqN+
         hQ8deWE1NcHWvnwnAW8sCXABJdx9XkHIU25LIOEKQhydAdgVE12NMpzZdXjq/umWnh
         QcCwnGtVyWfVELBeIPABceG8/o38+F/P52c1bEEE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Subject: [PATCH net 0/4] llc: fix sk_buff refcounting
Date:   Sun,  6 Oct 2019 14:24:23 -0700
Message-Id: <20191006212427.427682-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Patches 1-2 fix the memory leaks that syzbot has reported in net/llc:

	memory leak in llc_ui_create (2)
	memory leak in llc_ui_sendmsg
	memory leak in llc_conn_ac_send_sabme_cmd_p_set_x

Patches 3-4 fix related bugs that I noticed while reading this code.

Note: I've tested that this fixes the syzbot bugs, but otherwise I don't
know of any way to test this code.

Eric Biggers (4):
  llc: fix sk_buff leak in llc_sap_state_process()
  llc: fix sk_buff leak in llc_conn_service()
  llc: fix another potential sk_buff leak in llc_ui_sendmsg()
  llc: fix sk_buff refcounting in llc_conn_state_process()

 include/net/llc_conn.h |  2 +-
 net/llc/af_llc.c       | 34 ++++++++++++---------
 net/llc/llc_c_ac.c     |  8 +++--
 net/llc/llc_conn.c     | 67 +++++++++++-------------------------------
 net/llc/llc_if.c       | 12 +++++---
 net/llc/llc_s_ac.c     | 12 ++++++--
 net/llc/llc_sap.c      | 23 +++++----------
 7 files changed, 69 insertions(+), 89 deletions(-)

-- 
2.23.0

