Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1340A47FA7F
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 07:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhL0GUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 01:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhL0GUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 01:20:43 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB3FC06173E;
        Sun, 26 Dec 2021 22:20:42 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso4367995pje.0;
        Sun, 26 Dec 2021 22:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q3qnlUPyv7j+2lJxGhadY9VPUX1fm9lkgG1YxnakR3w=;
        b=fG4YEC8gkL+8kyTxVDpZWworuNLYPFs1uw5jTPZheRMvFcPLozXaaH9gmzbVfF4ZcL
         Q5bKSdqyx6qQMm8Rw2ewDyAE5/7BMNcOhf+vVhdE8g/x9cE6LM0z4n/sdmQNxlWn9Ka1
         aXRCT/hFL4BYE4PYDddefck5uLzsiqoHeYEzFqflzp5BdJOWJimBoE+EtrHAV2yU15Hu
         3JSErgkUIl5wqrnZHJgYDkAhPILbUSO8OBkxavI+HiL7qrVuDEH0Xk5tAtpceSMW3QUU
         Wt8fVlm+i+hLjFa6/ccGcQghsmbeaghyhVj5QdQoEDSroC7ocpJAmhdnCD/EqovR2nIj
         4IZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q3qnlUPyv7j+2lJxGhadY9VPUX1fm9lkgG1YxnakR3w=;
        b=Paq6nxulpbp6P/RbEMMnxSEqqCVfaKdJQgamM5ChZ+pAP5VLhGWH1m0QhIVgz51nx9
         P4wZylybr/k0KLW5WuGgwiVbtNIDndBvkVFkBvsRIrTXK8l1lJtbgxVDZv9crjD+CymS
         g716SQKU+/8qlU5VqmTgH4adwI5HXdm4uHt6dbn8ulZHVu1JvBU76RrSJu0JdF4IZTYs
         Bzh4YNEw6Wwt3d+KHt3TWPAyV60eJ6u2F9GLt3Ds6x69oAoJzVHSCTFhUdPT0eor1tHJ
         oVU3FNLO4rbPXhwGG7EOJ11jL3y5iIHZVP4E2ZQuFOomqM6rEHrEZj9GoZRt7hr160/e
         56mQ==
X-Gm-Message-State: AOAM531U4U6fxm7QO+5AAAsVErqtLvR1Z7tIQdqogDnQxQ4ROF7P8qno
        X/e+6JhqgvUfiXlXkPvlvlg=
X-Google-Smtp-Source: ABdhPJw1GG9gLyD2Ok10MtSX9QuV/UAuAGC+v80GKFDIGZ3WICJnHGXVaPUt+9vLkXa3ttaaqj/cdw==
X-Received: by 2002:a17:90b:3803:: with SMTP id mq3mr16071698pjb.46.1640586042554;
        Sun, 26 Dec 2021 22:20:42 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j23sm13143890pga.59.2021.12.26.22.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 22:20:42 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH] net: bpf: handle return value of BPF_CGROUP_RUN_PROG_INET4_POST_BIND()
Date:   Mon, 27 Dec 2021 14:20:35 +0800
Message-Id: <20211227062035.3224982-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The return value of BPF_CGROUP_RUN_PROG_INET4_POST_BIND() in
__inet_bind() is not handled properly. While the return value
is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
exit:

	err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
	if (err) {
		inet->inet_saddr = inet->inet_rcv_saddr = 0;
		goto out_release_sock;
	}

Let's take UDP for example and see what will happen. For UDP
socket, it will be added to 'udp_prot.h.udp_table->hash' and
'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
called success. If 'inet->inet_rcv_saddr' is specified here,
then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
to (because inet_saddr is changed to 0), and UDP packet received
will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
specified here, the sock will work fine, as it can receive packet
properly, which is wired, as the 'bind()' is already failed.

I'm not sure what should do here, maybe we should unhash the sock
for UDP? Therefor, user can try to bind another port?

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/af_inet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 04067b249bf3..9e5710f40a39 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -530,7 +530,14 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		if (!(flags & BIND_FROM_BPF)) {
 			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
 			if (err) {
+				if (sk->sk_prot == &udp_prot)
+					sk->sk_prot->unhash(sk);
+				else if (sk->sk_prot == &tcp_prot)
+					inet_put_port(sk);
+
 				inet->inet_saddr = inet->inet_rcv_saddr = 0;
+				err = -EPERM;
+
 				goto out_release_sock;
 			}
 		}
-- 
2.30.2

