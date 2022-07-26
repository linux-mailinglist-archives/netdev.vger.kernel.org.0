Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD875819AD
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiGZSZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiGZSZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:25:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18F214021;
        Tue, 26 Jul 2022 11:25:28 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id id17so9253274wmb.1;
        Tue, 26 Jul 2022 11:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eL31OvkZUAyrlwyFeqU3KWReKbezeGtO4fmJhiZIKUA=;
        b=DKgRAQAljMzRejI/Iqoga92jt8KLooDGUU6w8bP4NnAmJnWUunCKzdjPeIzvUD+z6H
         cex/ymmOE78UU9o3QQYKjLKubtveotwoxyj2bU2AKsdvcQri4l/Z0v56/MycUMxhKRrc
         aTR7mdaYI8TEttUhnB87s52+opS7LKPRsMQsiO4pxk3EAOqwMzQgabhiz0Du/woaK9ph
         rpKIW7KFoo/hIFZukktgmGPiYllpv4MRIpcn0VAusqF7pahO4Hn/S0QbS/2d6xskm7Qq
         d+7WXydc1INdzUNifqP/0wvAslRxpMFbtkgebTfmlCMQbafUsSRpZwDP1Ig2U7k2ZSob
         NTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eL31OvkZUAyrlwyFeqU3KWReKbezeGtO4fmJhiZIKUA=;
        b=PahFhkl+0X5KUlaV+T2q8k3Us+kGcWDyisJgQzTlx02KYTZ9lO+6gOoGX/i/qbfCSo
         E+SC/RulZksXf58iJUg9rbi0Vt6+s3dOYOcgfX+kPIvsBnR0j3yUJyeOEAvQZu+Kjg5A
         JJEvPIs3lJ5Gj6e4uvVEMzT9Ddhb0HHmEAg9IiaEjoLnRjdIez8XIUkb312QMx/19Z8h
         Fl43oUG9cITAaiElcz2MxFCkvHDvQIxW9jLXkKzQZD4IBw+VVd5Q7205EG8KypByVAp9
         /xRK9hWuF6nZms2C9GTk0r/HR8mPRUH0Czv3M9fhUFV2asJQ8tZSJIntwW7hwCb5JVHs
         9UwA==
X-Gm-Message-State: AJIora8kRbh+RW2OoJaWjilD/D5RbaQeoqdHg+mw1L0+7FLqPFj4yfBY
        YRyvyc/sQBq77h0MLetLRG4=
X-Google-Smtp-Source: AGRyM1s61eF6VPjOS/mNVSTCLaMz0eqjD3U+jUmS4DEhrWuGUCvhY/0xOhPgV4V9CZIXu3/gqGfKYA==
X-Received: by 2002:a7b:c401:0:b0:3a2:ca58:85bc with SMTP id k1-20020a7bc401000000b003a2ca5885bcmr339502wmi.156.1658859927169;
        Tue, 26 Jul 2022 11:25:27 -0700 (PDT)
Received: from ubuntu-f6bvp.. (lfbn-idf1-1-596-24.w86-242.abo.wanadoo.fr. [86.242.59.24])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c058900b0039c54bb28f2sm19768331wmd.36.2022.07.26.11.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 11:25:26 -0700 (PDT)
Sender: Bernard Pidoux <bernard.f6bvp@gmail.com>
From:   Bernard Pidoux <f6bvp@free.fr>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, duoming@zju.edu.cn, edumazet@google.com,
        f6bvp@free.fr, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org
Subject: [PATCH 1/1] [PATCH] net: rose: fix unregistered netdevice: waiting for rose0 to become free
Date:   Tue, 26 Jul 2022 20:25:18 +0200
Message-Id: <20220726182518.47047-1-f6bvp@free.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220722103750.1938776d@kernel.org>
References: <20220722103750.1938776d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the context.

This patch adds dev_put(dev) in order to allow removal of rose module
after use of AX25 and ROSE via rose0 device.

Otherwise when trying to remove rose module via rmmod rose an infinite
loop message was displayed on all consoles with xx being a random number.

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

...

With the patch it is ok to rmmod rose.

This bug appeared with kernel 4.10 and has been only partially repaired by adding two dev_put(dev).

Signed-off-by: Bernard Pidoux <f6bvp@free.fr>

---
 net/rose/af_rose.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc3..4163171ce3a6 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -711,6 +711,8 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	rose_insert_socket(sk);
 
 	sock_reset_flag(sk, SOCK_ZAPPED);
+	
+	dev_put(dev);
 
 	return 0;
 }
-- 
2.34.1

[master da21d19e920d] [PATCH] net: rose: fix unregistered netdevice: waiting for rose0 to become free
 Date: Mon Jul 18 16:23:54 2022 +0200
 1 file changed, 2 insertions(+)

