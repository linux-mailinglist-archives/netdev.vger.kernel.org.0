Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFFC3E4FAF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhHIXAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhHIXAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 19:00:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF3C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 16:00:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id k9so9841117edr.10
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 16:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NOh/1O8Aw6ygmV6lKbU6J3+Rn+aV91ycDEv4lb7aQdc=;
        b=EGDPRyp6I3GogJ7QpXQYc8Rn7zYcFiUDCoVgiFpWDEgjd41dsrmJWQeeUgi54tVTmY
         D/QO9UuUMKh8tRXix+CjM12bcgHbNR+bOPLHrqY0OUY3suOuTqkqpzUGeuBM9W4zcsYZ
         9XWPMJKYV58XvdOJBkOzfpNIAaCr1Ma9J7ndUP4xp0tOdx8N/pZcf7ncu9dZprG2L0H5
         gcSZNh4aFAcihDNV/37FJvAPW16MqO8PDdVS5amUp4VEhDir+z75bgKYfc3YOvLa0zqQ
         F7JfkFjrwl4ufDM7sshKWwTh7Z/J55APsrtq4sk4q9bzq5h5/kfBExcW1r4LoTuzrIuO
         Aqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NOh/1O8Aw6ygmV6lKbU6J3+Rn+aV91ycDEv4lb7aQdc=;
        b=rwL5Ii6wLs6ObEtVXvQEM2M1dVMy3XkAOB0OtpctQjKE93Uwwwl6Dpb+yfNTL/zuKd
         E1Pz8EseOZ8wUxmaHEGETJnBlOW1TPSOjMxDuh0BHoCZXvcFz1qVPsNR+asRMAjMtwKZ
         Faz66M2OSGcgjgtZp/hF7/NoQ3EIGO5mfPqu0ySK19ttPzApHttp/nN23RjkmGVWa9ER
         gZ643BBwie8Jt5ISYof3A11Uy3I98VLowvPfnlv3CUaArToNXPm2wUJRmsa6DZg/o0pF
         aortNjDuCIleSk5s889FZrmLKhwsS35sfI6Rl37BbG3MQ81mWjnPDuWPc7bBQvxX+UxF
         wmZA==
X-Gm-Message-State: AOAM531svvJJVaT8eS8fNcHUWjjfHDbk8rhxcjK/isgmg2x9BxOHhAA1
        Rfqz+guwygW0xLaGzkkfaHqKwg==
X-Google-Smtp-Source: ABdhPJwNALmc/GIkgBUSutVXWqGrCqshy32UNwMnKDwvItSwGtP3eSRdlcR6RtxAdey5d19FrBPssQ==
X-Received: by 2002:aa7:d593:: with SMTP id r19mr869345edq.372.1628550008337;
        Mon, 09 Aug 2021 16:00:08 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id g10sm6250280ejj.44.2021.08.09.16.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:00:08 -0700 (PDT)
Date:   Tue, 10 Aug 2021 01:00:06 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 6/7] net: dsa: microchip: ksz8795: Fix VLAN filtering
Message-ID: <20210809230005.GG17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ksz8_port_vlan_filtering() sets or clears the VLAN Enable
hardware flag.  That controls discarding of packets with a VID that
has not been enabled for any port on the switch.

Since it is a global flag, set the dsa_switch::vlan_filtering_is_global
flag so that the DSA core understands this can't be controlled per
port.

When VLAN filtering is enabled, the switch should also discard packets
with a VID that's not enabled on the ingress port.  Set or clear each
external port's VLAN Ingress Filter flag in ksz8_port_vlan_filtering()
to make that happen.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ddfe9cd6b7bd..891eaeb62ad0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1119,8 +1119,14 @@ static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
+	/* Discard packets with VID not enabled on the switch */
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
+	/* Discard packets with VID not enabled on the ingress port */
+	for (port = 0; port < dev->phy_port_cnt; ++port)
+		ksz_port_cfg(dev, port, REG_PORT_CTRL_2, PORT_INGRESS_FILTER,
+			     flag);
+
 	return 0;
 }
 
@@ -1774,6 +1780,11 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	 */
 	dev->ds->untag_bridge_pvid = true;
 
+	/* VLAN filtering is partly controlled by the global VLAN
+	 * Enable flag
+	 */
+	dev->ds->vlan_filtering_is_global = true;
+
 	return 0;
 }
 
-- 
2.20.1

