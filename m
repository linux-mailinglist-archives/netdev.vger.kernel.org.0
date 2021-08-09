Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B8D3E4FAC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbhHIXAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhHIXAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 19:00:11 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BDFC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 15:59:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oz16so15625219ejc.7
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 15:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8Qn4J43lMwsjtvWH8gyR3VB/gVX9syUDRFP38FtmuwU=;
        b=KRSrQxyMgaxBwf+uUwXbhlcZhTRXInkIqWYzWqJBf1pc3OsCtCaLcN43KmN/AW5zPg
         4/uQs2vm4S/IcglCSllIpKfURRKiZqnboEgi6QJVaR90qje7I/c5gXOQtehug1O+W7Zt
         haEJJ0JNzBQWTPxC0lIzTjNCzZeVFCmG+dTL7n2b5XiT65TzJvuUPUO9o/vqAB5nJHuP
         EbhOfhsqOr+CevG0XP+JbpGCeY/OzFdz0ZXLJ/nR2zR2AIw/CBMosbVFq0LpFuFewsVo
         0qiXxE93svJ/+UDKLNfAe2uoJzgkucgAMKyCgaQXxvYjUsae+1RIJ4ZclSNKMwWOH82W
         NNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8Qn4J43lMwsjtvWH8gyR3VB/gVX9syUDRFP38FtmuwU=;
        b=EhUC+3E7pqMryC4pWXMb2tgxfxUj8MHZv2Rv5SEvreZs7juoBGzKBpsFnw+3ipI5DT
         UxKr5QEaK06aerB4EdU2+/vl3Rw33lEnBDsL4GgP5ZMDqblok6UWoJd3MqQGYfHxPHMk
         N2sgEh4bJ9yWzBcgsSeFsT7ZcUu3bQgDPY77aBlcXsviM1uBFNEr7UBBFAvvNajcL4dD
         QzZ09CCZk+i1Ya000xdQGAQDCJ0zAXuSFSsozZsch7VZPxk4TZM7LM7mN3XRJWZr9R8X
         dbui0CFN0lP1TmsKRD1kG1YK4dASMoAN2ORdUsI4K4F3RNSqExuWviZzxne3YYUOsMFm
         mphQ==
X-Gm-Message-State: AOAM5315PIJHT3Fop2a/cYHls2viHb8F3afMG/x5VrjiwwbQdkkmfjZw
        LkYDXBJagqeFndOcYwPajucYebDHK9A/pw==
X-Google-Smtp-Source: ABdhPJy8ConIC0KTbI1KPmX4Vj+MTTXNrXsTkRUNGaKnPIr/7SJlULUaM9v98Jinl91HiKAzQzU39g==
X-Received: by 2002:a17:906:31cf:: with SMTP id f15mr25154307ejf.272.1628549989385;
        Mon, 09 Aug 2021 15:59:49 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id z70sm4389270ede.76.2021.08.09.15.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:59:49 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:59:47 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/7] net: dsa: microchip: ksz8795: Fix VLAN untagged flag
 change on deletion
Message-ID: <20210809225946.GE17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN is deleted from a port, the flags in struct
switchdev_obj_port_vlan are always 0.  ksz8_port_vlan_del() copies the
BRIDGE_VLAN_INFO_UNTAGGED flag to the port's Tag Removal flag, and
therefore always clears it.

In case there are multiple VLANs configured as untagged on this port -
which seems useless, but is allowed - deleting one of them changes the
remaining VLANs to be tagged.

It's only ever necessary to change this flag when a VLAN is added to
the port, so leave it unchanged in ksz8_port_vlan_del().

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 045786f4e29e..7a3d0d137ed1 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1208,7 +1208,6 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
 	u16 data, pvid;
 	u8 fid, member, valid;
@@ -1219,8 +1218,6 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid = pvid & 0xFFF;
 
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
-
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
-- 
2.20.1

