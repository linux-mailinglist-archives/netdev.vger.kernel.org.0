Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D76193C17
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgCZJnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:43:40 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:39060 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZJnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:43:39 -0400
Received: by mail-vs1-f74.google.com with SMTP id q26so854719vsr.6
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=dmiWJfcFArH3DaEi3dpMdj42oTYOcC0kdTvCmD78p68=;
        b=aBT1fAQcaANpMHna5XzK0PMInthUCghzt1nyEZxdWdxcSaiim1rr9N3Llc/wzV0vc5
         D8tJm2/h/oh4yG2A7MO4+g8AQb6dHtnzrOl+ezkof/9RkxxAJDCiOpsDmufnJoX0DEbP
         UBu4EvDtugcev/4MAFkSdk+ikV/qDDOvVrVS67M2ooYl3KuZbR98m1QdYdxEgWL0Yv8y
         uxtfdw8ly1Wb4Bcc+L66sh1US7dpglY37ZkKUb1Qclzj/Z7xsEB/i3G0GRRr4eaAWgUE
         frEa7IC4ukUrh6bPwGAF/G9+t0oFBYKDB0j1FOJzWLYcg66MCe4FEO/geONAEo3rRC5l
         3eXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=dmiWJfcFArH3DaEi3dpMdj42oTYOcC0kdTvCmD78p68=;
        b=V+eJh5oxv7wu/8wotWYm2e/MD/p76Sm16m+KWkkHjOsbrAC5ymVi8wGfA6e6UYEBy0
         LIrqSphmuX4d4jh1shP2Y8vykEPk/VNNZ6Eb8J+9JNTbon7o9pZSjKNTzq1XswGHpQlK
         MuaNYdesDl/gy8cijn/P9jiL4GgE/GLuxHe/Gb1IIHna7PsLGrNurWx/2g+EFVhHJYiP
         gXRr74omnp4Mzljz9ZVM1b2d4Cyj+jct2mlVNSwlpdN4JcQL1efcgJF7uH1/7nbBt/DW
         /GuNwXaN7OvAKIerDhnsTAPhm5sh5bGJhsL4v4xs6Bul5Yh9sUoFrybXPTVzOPjJH7bQ
         oOKg==
X-Gm-Message-State: ANhLgQ3z6r75L+HpG/2ylL8AAeJUw0Pn57FH6Dbf73NcwrwHetb7yDAg
        hZ+L2Aa246bR2c8mTCDBDO0LOmZW/5DWujs=
X-Google-Smtp-Source: ADFU+vvmZ9znUYYQDvEEts1i+c8TTOB7X7IRx7cRu2gQmqW9OmG4lpk2AKD25hPmn+0I3ybKaKLQRNNfB272C1c=
X-Received: by 2002:a67:2284:: with SMTP id i126mr5910228vsi.223.1585215818327;
 Thu, 26 Mar 2020 02:43:38 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:42:52 +0100
Message-Id: <20200326094252.157914-1-brambonne@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address generation
From:   "=?UTF-8?q?Bram=20Bonn=C3=A9?=" <brambonne@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     netdev@vger.kernel.org,
        "=?UTF-8?q?Bram=20Bonn=C3=A9?=" <brambonne@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Jeffrey Vanderstoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the IN6_ADDR_GEN_MODE_STABLE_PRIVACY address
generation mode to use the software-defined MAC address (dev_addr)
rather than the permanent, hardware-defined MAC address (perm_addr) of
the interface when generating IPv6 link-local addresses.

This ensures that the IPv6 link-local address changes in line with the
MAC address when per-network MAC address randomization is used,
providing the expected privacy guarantees.

When no MAC address randomization is used, dev_addr corresponds to
perm_addr, and IN6_ADDR_GEN_MODE_STABLE_PRIVACY behaves as before.

When MAC address randomization is used, this makes the MAC address
fulfill the role of both the Net_Iface and the (optional) Network_ID
parameters in RFC7217.

Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Jeffrey Vanderstoep <jeffv@google.com>
Signed-off-by: Bram Bonn=C3=A9 <brambonne@google.com>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5b9de773ce73..cd69a4331246 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3252,7 +3252,7 @@ static int ipv6_generate_stable_address(struct in6_ad=
dr *address,
 	sha_init(digest);
 	memset(&data, 0, sizeof(data));
 	memset(workspace, 0, sizeof(workspace));
-	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
+	memcpy(data.hwaddr, idev->dev->dev_addr, idev->dev->addr_len);
 	data.prefix[0] =3D address->s6_addr32[0];
 	data.prefix[1] =3D address->s6_addr32[1];
 	data.secret =3D secret;
--=20
2.25.1.696.g5e7596f4ac-goog

