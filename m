Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDF399485
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFBU3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBU3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:29:44 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159B9C061756
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 13:27:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x73so3104982pfc.8
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 13:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIZNwarF6dxowAlJnu/euGWQJ/DCZEKi8RX1cLE3XwY=;
        b=Z29cQUT1u4Ruq2SmaNGdbhoTrg5E1p9PRbg1JPKW4xbPOEDsM4XXkQZ5kbNnxuBW5D
         2E+DiTHf5lbtsSPPQ62UgMiz3bd9ETPPxAP9nCUi3uONdQB7SxblJHfyIAMrpb4p62hH
         tDZ3EuzVPa+ougVa3uJXMXi25ocfLBS9TKC98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIZNwarF6dxowAlJnu/euGWQJ/DCZEKi8RX1cLE3XwY=;
        b=PC6k8bGyM65ruMjvr88+KZ0RqbVAbGjtlixv+sN3bB8rHJiuhs6qaFfusVb/WZU+j5
         9iyoaQmfA+v9TZ1qjOs19a/HBGclBUXKhBXJH+HO+egMI682Tw1520dHBDzZTKLfZfAU
         0y2jHxJ9JpjJgoAbGvNpzSXYbtKQ5Pcz8t5fKpAaf9Y8ZW36lLv5+GvU1GkkIZv+DD3N
         1c2UVuvjf2IJWdMAl7VsklNLYN+r/xPaBao5DlfmIDEik1wdVRMBbPoQiGY47ZpnN2CJ
         CJJj0gHXjyH0tnx09N+ExArHJ1C3wXHpYNYImPU+iJBeRK8Ye2OwkGe8gDaf+JEmUmmy
         PH+g==
X-Gm-Message-State: AOAM5326GSqVcvBn+G5Z2ypM3uNubtLpxKrnKDzOMRFlbeoIg/HUQ24j
        /a52ds3KdogCvARNfWcasPIuog==
X-Google-Smtp-Source: ABdhPJx4kdIDojs7PJXi3sg5skx6t7uFGam5IAIWurMMhyZ8wNgAgppAdKXTkt8F9XvtkOcyJDN9og==
X-Received: by 2002:a63:cd11:: with SMTP id i17mr11533244pgg.348.1622665665582;
        Wed, 02 Jun 2021 13:27:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l128sm585740pgl.18.2021.06.02.13.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 13:27:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Di Zhu <zhudi21@huawei.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net: vlan: Avoid using strncpy()
Date:   Wed,  2 Jun 2021 13:27:41 -0700
Message-Id: <20210602202741.4078789-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=88816f8807de23dfa0b0dd3e00a4510275a736b2; i=E6vyLUaKYvlfizHY96CoIZkTnxuv3thEHFef0cl9Wew=; m=qgZWEVcHV6EOQQGK82kq1AwupK+IS9seUUAKn+Svxnk=; p=Vau8YbH5AGuE9RMmHWWxXTFxNJzGEGEyDbqLpLODzzE=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC36b0ACgkQiXL039xtwCY27RAAlUK AybI2ga1SMQVVI05kppeQdyQdJGd1fiHoKTIkxE02jQ60jDyZ+x4EHQtLQKXXvnz0O50BKglH7YuF LbBWPeHxxqdL4bqbCqbmO5XT+AiJ8PVcWRXBV9QMO8Ejct5BmzmQ50M9O//qVzXh/ogDMc+pWS9fG VMijkpEjvQQ+ID5wGgGPbIehjIbiyRdKINNf6674FsRCnkonFsmE24Ls+hhc+tT4uO+ndb1a+xuha 0hscBZLYVBR1DRHwZNCHUpJIsdUQ5UgSoUFeOx86wcAQZiEAMP0uS0OBs5MdHTG5qle+KOpFCnrw9 9vJQMFFmtyG028U1kxCg3N4nO27JiJ6fx8LO1BAOICxSQjysPH+isJAdWZoDVSdxQgoCDI2PAkDWb 4+YU3xcgcixf6H672T2Pbz8NrRNX6tT1SgeHmkbPHG1GiP7tis3Z1QEe3fWtC3VDUAAB2U91t2Oyd xfTN9FEKuH/q5Ji+4Ui/rHVQWvni2hBMtrSKtcB69jieuq5BS2HwGFgx7XwlOD8VocoZ9hKBvLAhN itw7/v9bOSLzjpGhmjowlmSOq8wytMhxnCJvBTfITrWQWl8OxOMdZ8pACFsecZGmCCpiTX1ikUtvH d4MZsbvKABfmZLxMxgzMqWkPgtbONMO83uf336pEsFLuhTXCA0v8/oQo6KnZ5F9M=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use strscpy_pad() instead of strncpy() which is considered deprecated:
https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/8021q/vlan.c     | 3 ++-
 net/8021q/vlan.h     | 3 ++-
 net/8021q/vlan_dev.c | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index fb3d3262dc1a..4cdf8416869d 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -638,7 +638,8 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 
 	case GET_VLAN_REALDEV_NAME_CMD:
 		err = 0;
-		vlan_dev_get_realdev_name(dev, args.u.device2);
+		vlan_dev_get_realdev_name(dev, args.u.device2,
+					  sizeof(args.u.device2));
 		if (copy_to_user(arg, &args,
 				 sizeof(struct vlan_ioctl_args)))
 			err = -EFAULT;
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index fa3ad3d4d58c..e3f6ff05a528 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -129,7 +129,8 @@ void vlan_dev_set_ingress_priority(const struct net_device *dev,
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
 int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
-void vlan_dev_get_realdev_name(const struct net_device *dev, char *result);
+void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
+			       size_t size);
 
 int vlan_check_real_dev(struct net_device *real_dev,
 			__be16 protocol, u16 vlan_id,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4db3f0621959..a0367b37512d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -239,9 +239,9 @@ int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
 	return 0;
 }
 
-void vlan_dev_get_realdev_name(const struct net_device *dev, char *result)
+void vlan_dev_get_realdev_name(const struct net_device *dev, char *result, size_t size)
 {
-	strncpy(result, vlan_dev_priv(dev)->real_dev->name, 23);
+	strscpy_pad(result, vlan_dev_priv(dev)->real_dev->name, size);
 }
 
 bool vlan_dev_inherit_address(struct net_device *dev,
@@ -360,7 +360,7 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ifreq ifrr;
 	int err = -EOPNOTSUPP;
 
-	strncpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
+	strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
 	ifrr.ifr_ifru = ifr->ifr_ifru;
 
 	switch (cmd) {
-- 
2.25.1

