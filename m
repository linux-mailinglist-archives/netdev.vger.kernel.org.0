Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80A6CA672
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjC0NuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 09:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjC0NuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 09:50:07 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31796EB2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:48:40 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id l18so6346057oic.13
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 06:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679924919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=igil1WZYegfO/w18+3ibNZPSlYSnfb+L+MbkfU46b9o=;
        b=OorUpNI50troS4oGlzQDqwTpL8FY1ux3BbtEVNJ/HaFoar5bDAXYkFUyTaCd9S1p3e
         kt11HNKrra/9WYP/NDWvk+NEmHWuLgngJSLch/tJtlsjlvZPerOKVy79e7Vt3cFKWBbg
         zZzZpDgP5NbfAwgRpfTqy7XGa/N97YLWnpODcswisZ+dPm54o4FQQlrp1a0Hy803jRvm
         567sRFAVBAk8Mns6etBtVU7VhVrQHz3JWz0eWFBm2rgOLbimCUfgQC9DIqe/5jj60x64
         f9n4PLrL8qAV2nSgfVQ+gxbcY2+hBCDKCaxmwuAXQgPUECj3UE4Rw4glTE5SRe1cGSS4
         b5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679924919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igil1WZYegfO/w18+3ibNZPSlYSnfb+L+MbkfU46b9o=;
        b=46F/L4XX5WyH6eRut3O+/C1jJ1z22fOaub0OXKy1ghctW+2aMl5lGICueV5MbHMssu
         +f8oQ1rzEDoSlm6H+0HzpRAg2AX7G4fyzYQU/PL7oZkwbHEzd1r5W/+USAoy1UxzCbQ1
         Ilw2gZGbk56rYVgTPeocvoAtQFPQOCa35xWwZ36ak8HCS5aHsS2shHnfL9rfO6pfGzgW
         1rvrSK/ZXGPuW9LOqL55E6OjPPiEhHjYkJ67ZFEs/wKf0x075NTV1UyVylEhtXET5vAd
         +Vo5TU1EElMH4i2TPUQu71JTOt9xZqCvqigDn8DpnBKUJBiLki0L33cMXnVcsBUJSSKi
         77Eg==
X-Gm-Message-State: AO0yUKUa8hJJEip3fIwbdMUYsXZpwuIlOi71tBGUHW++TrNSlQ4Qht+N
        skgNCyhMcsGn06y3qynhx8w5Qd/A25bd8A==
X-Google-Smtp-Source: AK7set8gF835n4sNWMZiMUO1qt6UsDrY/YvARxNKJuXsBNUndGdkGN1LtilHvh/A0qyupcWZKagWlg==
X-Received: by 2002:a05:6808:e8f:b0:383:b431:a725 with SMTP id k15-20020a0568080e8f00b00383b431a725mr6129473oil.1.1679924919485;
        Mon, 27 Mar 2023 06:48:39 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b69:de8b:f499:6d30:72c8])
        by smtp.gmail.com with ESMTPSA id q6-20020acad906000000b003876369bd0asm4565658oig.19.2023.03.27.06.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:48:39 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     andrew@lunn.ch
Cc:     olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, steffen@innosonix.de,
        Fabio Estevam <festevam@denx.de>
Subject: [RFC] net: dsa: mv88e6xxx disable IGMP snooping on cpu port
Date:   Mon, 27 Mar 2023 10:48:32 -0300
Message-Id: <20230327134832.216867-1-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Bätz <steffen@innosonix.de>

Don't enable IGMP snooping on CPU ports because the IGMP JOIN
packet would never forward to the next bridge, but loop back to
the actual cpu port.

The mv88e6320 manual describes the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP
bit as follows:

"IGMP and MLD Snooping. When this bit is set to a one and this port
receives an IPv4 IGMP frame or an IPv6MLD frame, the frame is switched
to the CPU port overriding the destination ports determined by the DA
mapping.
When this bit is cleared to a zero IGMP/MLD frames are not treated
specially.
IGMP/MLD Snooping is intended to be used on Normal Network or Provider
ports only (see Frame Mode bits
below) and only if Cut Through (88E6632 only) is disabled on the port
(Port offset 0x1F) as the IPv6 Snoop point may be after byte 64."

If this bit is set (it was set at ALL ports), the mv88e6320 will snoop
for any IGMP messages, and route them to the configured CPU port. This
will hinder any outgoing IGMP messages from the CPU from leaving the
switch, since they are immediately looped back to the CPU itself.

Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b73d1d6747b7..af098d65ed71 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3354,9 +3354,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Don't enable IGMP snooping on CPU ports because the IGMP JOIN
+	 * packet would never forward to the next bridge, but loop back to
+	 * the actual cpu port.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
-- 
2.34.1

