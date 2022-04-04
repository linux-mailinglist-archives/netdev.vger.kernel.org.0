Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA17F4F1A8B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379023AbiDDVSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380283AbiDDTaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 15:30:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2F526AD7
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 12:28:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r10so6620617eda.1
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 12:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=wa7lPoqjG7W28REyUbnmvBMu8jYAIkXefO5oZvcBbAE=;
        b=h+kl/mDoUineHM/lre/IzQZBL3UUmH8fb9RrIRtPKLSpWbCxiy4BfoKwTPJT1rUasG
         ZHllKd65M/UmjKUa7GvyS76oliEtrJupk6hB2Bb6alphV77zA50N6NHat/vSKIZe1mjU
         VHJsD8+piShkmHGZcF0BpB18Nx5SCz3T6Kam905MrmH9G78aHCZRBD6GwCC+DSnyxbkL
         qLiYTXoVkDpIDfzywwrGFAvG64Ih4EZGS6cHy2abTCRGl8s/8lRlwkBj9bLMCG9pYuYa
         prgd3aUaehZJFtvxbA6yc9fyKlgppFuOG7ojajJpH4b8jYN/ORS7fO9iytZ9dRT85/Fv
         D2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=wa7lPoqjG7W28REyUbnmvBMu8jYAIkXefO5oZvcBbAE=;
        b=pTbSTy3rrCYUwhT9mnwm1/xGlYTJyeRZy1chotqnSTI+qXeS3XgE+nVEabyE4iwNZ1
         ibk5DRVKuG6iQEh58WnJyRLWJ7FW0Lz4msqDwjwcSDj3YC1bJyn53eh/t8V4UQ8Z+qUT
         bS1fGI4CjFHuQo3ic8hhUKbZfLi3I08HMkpzhsH6goFgKqByKTs3C0txDDUl/Gg4cz3T
         ys0WKwfe2HpkAmLO5rsi7ZNW/YitGU/q5fJp/d/L5+/EEhwQgns8GrnmE8NzmeDsO8U2
         id9Eqpft4bZojkL1m2sOiPC1nRMWNwhG7vEDVWYBQnhK4pHsz/HIrJ6aODqX/UuWfOW+
         YAKg==
X-Gm-Message-State: AOAM533eCcgiqnDdb6V5StmXxw6vUHc6bvEF5TdmPOe9o3/ycC2m03I2
        lNDcDwAAdbxUfcNRC6ubqUaEyA00vD8=
X-Google-Smtp-Source: ABdhPJzPvJemHhNxZIQoDO6Y9JvZ2Sl6ppnMtvSOJg7gvIlILYTkyW+BcP/iR7t35kMyWmCS4dZxlg==
X-Received: by 2002:a05:6402:5cd:b0:419:7753:acfb with SMTP id n13-20020a05640205cd00b004197753acfbmr1738261edx.131.1649100490410;
        Mon, 04 Apr 2022 12:28:10 -0700 (PDT)
Received: from smtpclient.apple (2001-1ae9-370-2000--da09.ip6.tmcz.cz. [2001:1ae9:370:2000::da09])
        by smtp.gmail.com with ESMTPSA id dn4-20020a17090794c400b006dbec4f4acbsm4764513ejc.6.2022.04.04.12.28.08
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Apr 2022 12:28:10 -0700 (PDT)
From:   Matej Zachar <zachar.matej@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: [DSA] fallback PTP to master port when switch does not support it
Message-Id: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
Date:   Mon, 4 Apr 2022 21:28:08 +0200
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Hi,

in my embedded setup I have CPU (master) port with full PTP support =
connected to the onboard switch (without PTP support) through DSA. As =
the ioctl and ts_info is passed to the switch driver I made small change =
to fallback to the master net_device. This however requires that the =
switch which does not support PTP must not implement .get_ts_info and =
.port_hwtstamp_get/set from dsa_switch_ops struct.

Do you think this is good approach - I=E2=80=99m happy to work on patch =
if it makes sense.

I understand that better solution would be to have PTP capable switch, =
but thats not the situation on this board.

Thank you,
Matej.


diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index =
65b125bb3b8606e35e5a4a5963c04543266c6114..c78b202e86f3b12d2046de718fd5a1dd=
cec277cd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -251,16 +251,25 @@ static int dsa_slave_ioctl(struct net_device *dev, =
struct ifreq *ifr, int cmd)
 	struct dsa_slave_priv *p =3D netdev_priv(dev);
 	struct dsa_switch *ds =3D p->dp->ds;
 	int port =3D p->dp->index;
+	struct net_device *master =3D dsa_slave_to_master(dev);
=20
 	/* Pass through to switch driver if it supports timestamping */
 	switch (cmd) {
 	case SIOCGHWTSTAMP:
 		if (ds->ops->port_hwtstamp_get)
 			return ds->ops->port_hwtstamp_get(ds, port, =
ifr);
+
+		if (master->netdev_ops->ndo_do_ioctl)
+			return master->netdev_ops->ndo_do_ioctl(master, =
ifr, cmd);
+
 		break;
 	case SIOCSHWTSTAMP:
 		if (ds->ops->port_hwtstamp_set)
 			return ds->ops->port_hwtstamp_set(ds, port, =
ifr);
+
+		if (master->netdev_ops->ndo_do_ioctl)
+			return master->netdev_ops->ndo_do_ioctl(master, =
ifr, cmd);
+
 		break;
 	}
=20
@@ -1292,11 +1303,12 @@ static int dsa_slave_get_ts_info(struct =
net_device *dev,
 {
 	struct dsa_slave_priv *p =3D netdev_priv(dev);
 	struct dsa_switch *ds =3D p->dp->ds;
+	struct net_device *master =3D dsa_slave_to_master(dev);
=20
-	if (!ds->ops->get_ts_info)
-		return -EOPNOTSUPP;
+	if (ds->ops->get_ts_info)
+		return ds->ops->get_ts_info(ds, p->dp->index, ts);
=20
-	return ds->ops->get_ts_info(ds, p->dp->index, ts);
+	return master->ethtool_ops->get_ts_info(master, ts);
 }
=20
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 =
proto,=
