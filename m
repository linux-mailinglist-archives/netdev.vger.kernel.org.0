Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79A8689BAA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjBCObN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjBCObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:31:08 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885BA92C32
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:30:40 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bk15so15787961ejb.9
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 06:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0m2g8+GVf0ZZ1nhk/AEBKCt2TzchdbQ0OMGRYPpZQk=;
        b=lCNTPvRnftJlnMW1PsKFs1qObEJoHevEIpzC1N4wE3eG5QKK1Y/MrBZECgNNqllhie
         8j/x3rKmkp6VZtX9Fq/LI+D7kcS/FEgNqNnEVX2IBdI/SXzqX5wQrPoYBBpZ/CqrD7Hz
         DDp8sYlcOu2dw9MtKvccwr2bHn7f28zkA5knI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0m2g8+GVf0ZZ1nhk/AEBKCt2TzchdbQ0OMGRYPpZQk=;
        b=dGLug1ObU8fbvDgMqoCziX+rYD58bbiWffsHyoJ31hyi7itvPQJLcbfVoLvlF/xeSO
         86IT8KvRYg3b54Kl9ukwGpDqzeSAeZRcBz4L4a1kszU3AGZL/ZhArA13o7TQ7HS8s3Qn
         5Hwgifa/1xLWVNOAcw8NqyC+w52jRTNGgNCRV18RMHvwFsIdSYuc9kDXpSPO/DM/6jMb
         +Iqxik2HE6+cKKr2GmSJKE9VbqwG/RoyWsx29YIlmApIlsUfPgL9Pko5tJhFrCbF8Csf
         2GxKlxvtF7q3mjgZmh2ZBMhSRMf0wnTKEoPMO50huziLQtv6Vr2kgyxaOoOWGoD8v3s4
         JKFw==
X-Gm-Message-State: AO0yUKVVwTnrV1yiAB9FhlVjD8l0j8wBVR7hmQPmDhiXYVwQI0c0cu5/
        fdM7s/f7pU7FbDOUEYZq58QfOA==
X-Google-Smtp-Source: AK7set9b/U3Bez6JHqWNmBQmWFMha+36vVqTjXrRrnN6Fvttj+ni2rvrsKpk5Jr0O9GHE7WqEdPguw==
X-Received: by 2002:a17:907:2c49:b0:887:2248:efd5 with SMTP id hf9-20020a1709072c4900b008872248efd5mr11117214ejc.77.1675434639078;
        Fri, 03 Feb 2023 06:30:39 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id v17-20020a17090690d100b007b935641971sm1453388ejw.5.2023.02.03.06.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 06:30:38 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Fri, 03 Feb 2023 14:30:28 +0000
Subject: [PATCH net-next v2 2/2] tap: tap_open(): correctly initialize
 socket uid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230131-tuntap-sk-uid-v2-2-29ec15592813@diag.uniroma1.it>
References: <20230131-tuntap-sk-uid-v2-0-29ec15592813@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v2-0-29ec15592813@diag.uniroma1.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675434637; l=1520;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=gy2uiWU+PZfZz9OqZCMOyGDsAY8Cohp72Vz0gjwoRSU=;
 b=I5uI/ctAlIL+vpLvAGhqXmr6UYyQq5x15ou5M9lz55gdMajDJ0SPh1qD0snm9fz5Qz0uW+1Qfo9m
 vxkBOjG5CjUnZdckJw8zrbHWm3rSNNP0iTKvR0RsYYrHWUS9+bh/
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tap_open() passes a `struct socket` embedded in a `struct
tap_queue` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with
padding bytes between `int vnet_hdr_sz` and `struct tap_dev __rcu
*tap` in `struct tap_queue`, which makes the uid of all tap sockets 0,
i.e., the root one.  Fix the assignment by overriding it with the
correct uid.

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 drivers/net/tap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a2be1994b389..145c3f84fac4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -538,6 +538,10 @@ static int tap_open(struct inode *inode, struct file *file)
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
 	q->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
+	/* Assign sk_uid from the inode argument, since q->sock
+	 * passed to sock_init_data() has no corresponding inode
+	 */
+	q->sk.sk_uid = inode->i_uid;
 
 	/*
 	 * so far only KVM virtio_net uses tap, enable zero copy between

-- 
2.25.1

