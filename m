Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C505BEE03
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiITTse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiITTsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:48:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5189C6CD3F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:48:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so3064073ybs.17
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date;
        bh=Kt/NYkqtgW6B+FoKQiYCh36VQldSm8N5HzcLdnIZkxc=;
        b=ralO8EQdOVIjLNaKmYeMAqvtHh1dYvt/aDgS6Qjo3cbVdaEt9esndaAXzbyPjyw7Hc
         Z6l3kKpdXI7RIqE/ErgFJgdWGFICMB2TFOsWQEB0gfDliER8n7qYExCreOX5Qr8UzvMG
         +jMALdZpmSLxR1k/DQ4BECZNR5bF5YfPf745sN9hCO2SfHF3BteO4MVTEmpr23iVtL3r
         UGGFUmjz8Z776FiwNsl5ahcuj5DNTrvC9sIVVxinB4hzIinRQmlMs0HG+8dwQwZF4Mwl
         qX3WwxqG4rxuo62nB4mdKgz8RisepP7knb5opHxhgx2jb/mvGs0aL8r54GTGJIwvPLro
         AlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date;
        bh=Kt/NYkqtgW6B+FoKQiYCh36VQldSm8N5HzcLdnIZkxc=;
        b=CPQDQ/sl54RwPKib5UIw0eVDOkYlhWa0PZ6A5qT8lSu2gowOe8WuzP/Zzimf6DSzW0
         GRq7GeMbI/t/x9f2GCFQKrdK0y93OzQUGXMrBZulkDqSLD+UVOJhbwH6OVNSx97lyoWu
         JBsYwP6Kpqm0lusrRvZ3zIevXRoYYMzU5uvhz//oFqRlNPll6Geul/mncJSSLitX4pUn
         thbCy+hOLuUjgPh7/f+SvOeNNlT/hlLdXM3IC3iaFAc8M09YutXCTkyrhYD0UZh+luX8
         NTiMsc6HGVC/NOXUxRE4RSfv7BTxfqDH8XITXfIHYajLTDp77/vb+Ib9x03fbqrXv7Jg
         a5Ag==
X-Gm-Message-State: ACrzQf19PBUh0m3mQBWoueIz99D1J53tXMu+Ugt2+fVxZUfw4N85wqBh
        y+Gxsdm1fLZ6iuwH5hOBmdFOJLY3WQ==
X-Google-Smtp-Source: AMsMyM503hU3Tg5/KmftTXLMtj/g9jB/HcIxsLD8g/1mGVZtZ80x/tL+xDSnM4vnYAZ1ZVpAwYgXeprO3Q==
X-Received: from prohr-desktop.mtv.corp.google.com ([2620:15c:211:200:80fc:5cbf:acb:ddac])
 (user=prohr job=sendgmr) by 2002:a0d:df46:0:b0:345:22d9:f5c1 with SMTP id
 i67-20020a0ddf46000000b0034522d9f5c1mr20510567ywe.239.1663703311638; Tue, 20
 Sep 2022 12:48:31 -0700 (PDT)
Date:   Tue, 20 Sep 2022 12:48:25 -0700
In-Reply-To: <20220920083621.18219c3d@hermes.local>
Mime-Version: 1.0
References: <20220920083621.18219c3d@hermes.local>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920194825.31820-1-prohr@google.com>
Subject: [PATCH v2] tun: support not enabling carrier in TUNSETIFF
From:   Patrick Rohr <prohr@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Patrick Rohr <prohr@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for not enabling carrier during TUNSETIFF
interface creation by specifying the IFF_NO_CARRIER flag.

Our tests make heavy use of tun interfaces. In some scenarios, the test
process creates the interface but another process brings it up after the
interface is discovered via netlink notification. In that case, it is
not possible to create a tun/tap interface with carrier off without it
racing against the bring up. Immediately setting carrier off via
TUNSETCARRIER is still too late.

Signed-off-by: Patrick Rohr <prohr@google.com>
Cc: Maciej =C5=BBenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/tun.c           | 9 ++++++---
 include/uapi/linux/if_tun.h | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 259b2b84b2b3..db736b944016 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2828,7 +2828,10 @@ static int tun_set_iff(struct net *net, struct file =
*file, struct ifreq *ifr)
 		rcu_assign_pointer(tfile->tun, tun);
 	}
=20
-	netif_carrier_on(tun->dev);
+	if (ifr->ifr_flags & IFF_NO_CARRIER)
+		netif_carrier_off(tun->dev);
+	else
+		netif_carrier_on(tun->dev);
=20
 	/* Make sure persistent devices do not get stuck in
 	 * xoff state.
@@ -3056,8 +3059,8 @@ static long __tun_chr_ioctl(struct file *file, unsign=
ed int cmd,
 		 * This is needed because we never checked for invalid flags on
 		 * TUNSETIFF.
 		 */
-		return put_user(IFF_TUN | IFF_TAP | TUN_FEATURES,
-				(unsigned int __user*)argp);
+		return put_user(IFF_TUN | IFF_TAP | IFF_NO_CARRIER |
+				TUN_FEATURES, (unsigned int __user*)argp);
 	} else if (cmd =3D=3D TUNSETQUEUE) {
 		return tun_set_queue(file, &ifr);
 	} else if (cmd =3D=3D SIOCGSKNS) {
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 2ec07de1d73b..b6d7b868f290 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -67,6 +67,8 @@
 #define IFF_TAP		0x0002
 #define IFF_NAPI	0x0010
 #define IFF_NAPI_FRAGS	0x0020
+/* Used in TUNSETIFF to bring up tun/tap without carrier */
+#define IFF_NO_CARRIER	0x0040
 #define IFF_NO_PI	0x1000
 /* This flag has no real effect */
 #define IFF_ONE_QUEUE	0x2000
--=20
2.37.3.968.ga6b4b080e4-goog

