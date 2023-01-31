Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFF2682F0C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjAaOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjAaOUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:20:37 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110331D921;
        Tue, 31 Jan 2023 06:20:36 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qw12so26134928ejc.2;
        Tue, 31 Jan 2023 06:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nVBmiYiYPs6Oa6XcLvsYrvHcRCbEE7kM/cPMb1XwWXI=;
        b=h1mo+nPagVMmKtLS37LHPDUIkBa9zreqkK8+d8CklgBMP4XZuJkLTJglD8bKci7qsq
         dWWBUbax+gFDEPIxP2x66jmEl5h4UctxogqpwblpI6aOm3gl9idHQVvJ/VqZ8xxG2eNb
         VWDuuTk/i5NTBnZ8TKVQ5cjfLJp8chL3uQFx0/M3Dh7ieoZx9vg7ol4XWs4dwbdI+n+E
         /+bE7MDAOvJhtThVosD2bpYxg+0J8nVp4Dq7ZJEMbqJsFQwTreY7AY/Z1Doscij64BxB
         Qd40Vk9pkEYmL9mH+MdW/KsfBzab2soYM0JkqUhvG0WRtbTmzIhZGzLRt+XRruVOvV7W
         bGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nVBmiYiYPs6Oa6XcLvsYrvHcRCbEE7kM/cPMb1XwWXI=;
        b=j82/DO5/VB17zNiJ6pyovzanzA9nLQVblALR5T1AF49Rc9YDJYTjs60K2EPrMlqvGt
         DNLyhzr2v7v+OXjS4HH/WWSDEZexGSWhfMeNi3RPz1PMCHXnort6v0Y5SWCLvTcvl1gk
         ttgP+vGYgpX3WRPrl14cwDUMkG/YyuugijlacI/G6nTWD4r0flgS0EsuXFvU9pJ3SGHS
         6Y5vlEW9UV+ovjLfbOhYbr54EeBYzMfMRyN3+wIm/3J1sadYo615FCmrM3B9mpmuh/V1
         L0VJ5Wh2qO2zwzfktMpeST+tNl7J853whrMm6zNaa9U2MARHDsSW/gmhahRYrz7oqcIV
         Nf1g==
X-Gm-Message-State: AO0yUKXUkgyoCwaYIgkk9gha1YjhxdR3oHTQSn0DyT1BlrdoakTD7Cf2
        NSEduJk3a7i3QQk0adh4Hbg=
X-Google-Smtp-Source: AK7set8hYqvGPk7DR0V5AAhZJzyAkPR0z/qjrj4D9DH/dwo/o74aLTE6Zu7DnqhUEw8jaFZUJqv5yg==
X-Received: by 2002:a17:906:f192:b0:878:7ef1:4a20 with SMTP id gs18-20020a170906f19200b008787ef14a20mr17375244ejb.4.1675174834642;
        Tue, 31 Jan 2023 06:20:34 -0800 (PST)
Received: from sakura.myxoz.lan (81-230-97-204-no2390.tbcn.telia.com. [81.230.97.204])
        by smtp.gmail.com with ESMTPSA id fm19-20020a1709072ad300b007c10d47e748sm8368868ejc.36.2023.01.31.06.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:20:34 -0800 (PST)
Message-ID: <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
Subject: [PATCH v2] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 15:20:33 +0100
In-Reply-To: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reports that act_len in kalmia_send_init_packet() is
uninitialized. Fix this by initializing it to 0.

Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B37=
30")
Reported-and-tested-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.c=
om
Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>
---
v1 -> v2
* Minor alteration of commit message.
* Added 'reported-and-tested-by' which is attributed to syzbot.

 drivers/net/usb/kalmia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 9f2b70ef39aa..b158fb7bf66a 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -56,7 +56,7 @@ static int
 kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 	u8 *buffer, u8 expected_len)
 {
-	int act_len;
+	int act_len =3D 0;
 	int status;
=20
 	netdev_dbg(dev->net, "Sending init packet");
--=20
2.39.1


