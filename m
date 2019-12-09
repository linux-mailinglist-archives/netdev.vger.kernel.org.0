Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12DD116A78
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfLIKEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:04:13 -0500
Received: from relay.sw.ru ([185.231.240.75]:57720 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfLIKEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 05:04:12 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104] helo=localhost.localdomain)
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1ieFt9-0002QA-J7; Mon, 09 Dec 2019 13:03:35 +0300
Subject: [PATCH net-next v2 0/2] unix: Show number of scm files in fdinfo
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, axboe@kernel.dk,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de, ktkhai@virtuozzo.com
Date:   Mon, 09 Dec 2019 13:03:34 +0300
Message-ID: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: Pass correct argument to locked in patch [2/2].

Unix sockets like a block box. You never know what is pending there:
there may be a file descriptor holding a mount or a block device,
or there may be whole universes with namespaces, sockets with receive
queues full of sockets etc.

The patchset makes number of pending scm files be visible in fdinfo.
This may be useful to determine, that socket should be investigated
or which task should be killed to put a reference counter on a resourse.

$cat /proc/[pid]/fdinfo/[unix_sk_fd] | grep scm_fds
scm_fds: 1

---

Kirill Tkhai (2):
      net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]
      unix: Show number of pending scm files of receive queue in fdinfo


 include/linux/net.h   |    1 +
 include/net/af_unix.h |    5 ++++
 net/socket.c          |   12 +++++++++++
 net/unix/af_unix.c    |   56 +++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 69 insertions(+), 5 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>

