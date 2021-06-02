Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12D399492
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFBUe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:34:26 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43715 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:34:25 -0400
Received: by mail-pg1-f178.google.com with SMTP id e22so3231772pgv.10
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 13:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSLR915keJcdTviRaDzw8PP4+JBptlr8rMLWUQhfRuo=;
        b=Sb/s5Ta+iWJ5VwUoH6Abdz1NLrs8aMm55RMVQ67D7La3FWEIqrHgfSBfa8W9bx5cAZ
         Zg1zqJkllqfjVy7sOZx5DrIvRS+EOU7CVDLSmqE3oI8EsH/w3nQVF/bdQFxntxPabOHH
         ff4aOrt12y6LQLBvevJNH6p4ITV3poo70Yj1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSLR915keJcdTviRaDzw8PP4+JBptlr8rMLWUQhfRuo=;
        b=ilafgWvVtBfj1+hVRxeqoAfTbcZsYu9AwS0fzyz9SeST/sM9VIhwmCHoNuAh+Wu7/W
         3ZUNXIUbviOrq/xUbQ+3H0as7DlTqRwb1eTDHCvfuus7BLrU5dtr28wgOBRu80Nt2r6i
         Q6/IZ1lwhQmwRJ3mQY8DxZkqRNCp2q6L1lIXzwnUKFqvRv7IzBechvGg1hXfOyQvqKrG
         YomOpzMmpNyn6g33uyiE8KMWmgB96Gk5R/py89SbCgmvpa1EQIT07G1X9jXVFj3AOWD7
         cQXWAwmzWwKMYNUR/AkVYiBQ5di1h6Qjft0iG4T32YGPO2Ce+POQ2c7L1HTSY3T0AQOK
         JqUg==
X-Gm-Message-State: AOAM531CQt9WD5QdlBJ61TkZagiQQzI2MGkrJ9Vxx87ZP2F5YO9BNI3R
        HRqi6NoNgTVnJfqRog6wmTcdkg==
X-Google-Smtp-Source: ABdhPJwkeG+5ULmlupCWiLWWBtxNfWEoWmRN5lTAgQJBBL8sKP395AQjhB6kTa9TliCZh2v4p5ivbQ==
X-Received: by 2002:aa7:8a12:0:b029:2ea:2690:7d66 with SMTP id m18-20020aa78a120000b02902ea26907d66mr3778613pfa.8.1622665902194;
        Wed, 02 Jun 2021 13:31:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p6sm378047pfh.166.2021.06.02.13.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 13:31:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] net: bonding: Use strscpy() instead of manually-truncated strncpy()
Date:   Wed,  2 Jun 2021 13:31:38 -0700
Message-Id: <20210602203138.4082470-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=a8037d5f76b0c6b374a5a7856a0340dda096eca9; i=+jq1hjyNarBiZF1iCP+ld51I3zySb92TJIxasbU5Dvg=; m=EBWMWbArZClnv/4HRsZOTu5Fjt37QDxBNb2o2f6hgzg=; p=cV40uWr3yIccruWHZ5/NoNE/0PYjMA+rbgzhfh1qkcQ=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC36qoACgkQiXL039xtwCasChAAqty 3o0rpXgX99jLLZM6+nDi1Y4rVnaI/j8VHgpBnSTmV48Io6oefI1DQnbiCCKMgzDMbpKypc3ut3532 lGKnU06nhaWIVv4vnrRTIZ1kRWAqp2EasUmIDSRzFhZEc3U5KN7wVNFpPnoTzntll0XNAiXHSdY1X xp8g1i32h4JtjWc+81pX6qm6rr1FuMIEjNnOnQdSGpa8J/l4f+i8aXyOYOltGLur417CDm4DOf6Ev 7pao129MpTIFuFb7mxM6NrKTeZsSb3U2BuHcyg3dyHGw3N6FcqZS0WKLFKp4jnGMrNh/QiwOEqN2G oGqxaahWJriHjfV4Tjop4SFVvd0sOVCfVxFyBHquV3n9NohQPFwUov5uQ/weW/cmgNskKyLqnUvbw 1gMF0wvTIvYHrlIas9bhnLNQNWFt5QwTDX5DZm8boZQJjPbBjib8+iDXAb2nTxQUeztOM9imtCTo8 KzYFRtMvA4ENZhJHX8IotRzSc5HF/HJwINvfhBpGxYugYYy3l50OoCLITqBEKhHEM5pBtOX5zxLKg i5zNhjLTEZFVttGz8yprauY8dx+DR6xsv4U88Q3n14tu7hMCYM3DnYQAZoQD6hspcMdtVznldecbM QonsnJ6ReUixWzQxDyAsJztvOGVIeP70m4VyDVZ5Esfq86hE0IIaPPCBV15zudto=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence this warning by just using strscpy_pad() directly:

>> drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
    4877 |   strncpy(params->primary, primary, IFNAMSIZ);
         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Additionally replace other strncpy() uses, as it is considered deprecated:
https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202102150705.fdR6obB0-lkp@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - switch to strscpy_pad() and replace earlier strncpy() too
v1: https://lore.kernel.org/lkml/20210602181133.3326856-1-keescook@chromium.org
---
 drivers/net/bonding/bond_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c5a646d06102..e9cb716ad849 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -620,7 +620,7 @@ static int bond_check_dev_link(struct bonding *bond,
 		 */
 
 		/* Yes, the mii is overlaid on the ifreq.ifr_ifru */
-		strncpy(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
+		strscpy_pad(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
 		mii = if_mii(&ifr);
 		if (ioctl(slave_dev, &ifr, SIOCGMIIPHY) == 0) {
 			mii->reg_num = MII_BMSR;
@@ -5329,10 +5329,8 @@ static int bond_check_params(struct bond_params *params)
 			(struct reciprocal_value) { 0 };
 	}
 
-	if (primary) {
-		strncpy(params->primary, primary, IFNAMSIZ);
-		params->primary[IFNAMSIZ - 1] = 0;
-	}
+	if (primary)
+		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
 
-- 
2.25.1

