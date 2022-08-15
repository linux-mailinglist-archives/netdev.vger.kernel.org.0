Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5F594BF5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiHPBXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238278AbiHPBXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:23:11 -0400
Received: from forward107j.mail.yandex.net (forward107j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118DE1C6AF9
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:13:31 -0700 (PDT)
Received: from iva3-6d6b5ab252da.qloud-c.yandex.net (iva3-6d6b5ab252da.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:c19:0:640:6d6b:5ab2])
        by forward107j.mail.yandex.net (Yandex) with ESMTP id 3A02088612E;
        Tue, 16 Aug 2022 00:13:24 +0300 (MSK)
Received: by iva3-6d6b5ab252da.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id hxrdzVdp77-DMiqtBJc;
        Tue, 16 Aug 2022 00:13:23 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660598003;
        bh=fyXKRnx1m8N4N19/XOGePikxGATxA7OoWeZ+Crlro3Y=;
        h=Date:Message-ID:Cc:To:Subject:From;
        b=UDs9dnR6pDA4XozblW1b0c+7T1CMlRUPqpaU2xszyAlRwLhxUzixCDH50plfYwC2G
         X4KSNbPN+9Gd9yBDKCdvOq55LOAlBQ+ta1KNlORu1Qcm2J7Cghf1QrxMmS/bz6RuMQ
         vwj8z9HbcoJKS9p9UZakrioOuX2BVuwJOwicq3sk=
Authentication-Results: iva3-6d6b5ab252da.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
From:   Kirill Tkhai <tkhai@ya.ru>
Subject: [PATCH v2 0/2] unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of
 receive queue skbs
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, viro@zeniv.linux.org.uk,
        tkhai@ya.ru
Message-ID: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
Date:   Tue, 16 Aug 2022 00:13:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a fd owning a counter of some critical resource, say, of a mount,
it's impossible to umount that mount and disconnect related block device.
That fd may be contained in some unix socket receive queue skb.

Despite we have an interface for detecting such the sockets queues
(/proc/[PID]/fdinfo/[fd] shows non-zero scm_fds count if so) and
it's possible to kill that process to release the counter, the problem is
that there may be several processes, and it's not a good thing to kill
each of them.

This patch adds a simple interface to grab files from receive queue,
so the caller may analyze them, and even do that recursively, if grabbed
file is unix socket itself. So, the described above problem may be solved
by this ioctl() in pair with pidfd_getfd().

Note, that the existing recvmsg(,,MSG_PEEK) is not suitable for that
purpose, since it modifies peek offset inside socket, and this results
in a problem in case of examined process uses peek offset itself.
Additional ptrace freezing of that task plus ioctl(SO_PEEK_OFF) won't help
too, since that socket may relate to several tasks, and there is no
reliable and non-racy way to detect that. Also, if the caller of such
trick will die, the examined task will remain frozen forever. The new
suggested ioctl(SIOCUNIXGRABFDS) does not have such problems.

The realization of ioctl(SIOCUNIXGRABFDS) is pretty simple. The only
interesting thing is protocol with userspace. Firstly, we let userspace
to know the number of all files in receive queue skbs. Then we receive
fds one by one starting from requested offset. We return number of
received fds if there is a successfully received fd, and this number
may be less in case of error or desired fds number lack. Userspace
may detect that situations by comparison of returned value and
out.nr_all minus in.nr_skip. Looking over different variant this one
looks the best for me (I considered returning error in case of error
and there is a received fd. Also I considered returning number of
received files as one more member in struct unix_ioc_grab_fds).

v2: Add "[PATCH 1/2] fs: Export __receive_fd()" to make receive_fd_user() be visible in [2/2] patch, when af_unix is module.
---

Kirill Tkhai (2):
      fs: Export __receive_fd()
      af_unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of receive queue skbs


 fs/file.c               |    1 +
 include/uapi/linux/un.h |   12 ++++++++
 net/unix/af_unix.c      |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

--
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
