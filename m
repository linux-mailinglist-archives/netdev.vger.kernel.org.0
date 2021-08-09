Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD113E4FAE
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhHIXAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbhHIXAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 19:00:21 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F3DC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 16:00:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id d6so27092576edt.7
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 16:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZFAFMdmrH+/a1aLUISnFDqOH+TO/ApDMconZApETk6Q=;
        b=dXrFg+RoTGioZPjnME/xLm2aa/RVg7f16c8IO7/2HN+NRKK/u49qW0XDZU8yd8KSWi
         mqkHYZKgUIXQWFyojAvCsueOIZuqRT38MDvnb0i6jKgTE1Q/SdI+jt+DUHO8+B5yaaZO
         3nvQECOohNzmM/VfIlDV5A4t1ugYysuBb/QBgbvaGIk/Y8CMh3L9a9sXdjXPqPqhTgMv
         3YeNv6iiVJBRxAH9whHklaU68Ue2JnsZ65s0YdumdGQkuTJVlsstcc+dOhfMMCnoL/6q
         /et7FezuTXUz83JYNMY/7zqXwLfw/tlPzH5I/TvT/MVVrkaG/YZHTGtGF3+f/r6KxPlG
         ztyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZFAFMdmrH+/a1aLUISnFDqOH+TO/ApDMconZApETk6Q=;
        b=BcencARKjFfgSLE5cJispns59WGDagyMO9/2ak1vf3BwYAWGc9QXgewz6VDkWDFyA+
         4NP3OVKuyXA5/3gsjuEyPwOZ7oQO2yzMggb/usqcHcoM1xI5+wLMNF7FxGWhIwdEFWBl
         6RINjBgr0qdnJAN+4TQTPSDJ0EthEZckdegjlfaZWVuxwuWbawoUtlCBLvVghzvxUZee
         dn2O7ID30SBoY82ZWkXBqLc4XnFl9L1dWKK2MIXOTvsHBPqaqjpQhrPHmbdZceabExmY
         HNip2eB6STgcKa+JJUdb3vEP5ljwLlhS0ygvcowVgXcbSBvx7409/P+ptWj/2WCOqnUO
         vAuA==
X-Gm-Message-State: AOAM533OLGUc5bFwwXLfYjvpbcKd/djBrhdp6XX6Voc+2ET+5DvdeUc+
        IDVlzVERKSzG7xXWq9cVzOzdMg==
X-Google-Smtp-Source: ABdhPJwr87XKrKk89bByeJnP9Fkt5bt/LR7yUfkeGUXUSMWDlr3KW1W4jN4uinAdUudaoXa55gqClQ==
X-Received: by 2002:a05:6402:361:: with SMTP id s1mr893442edw.172.1628549999249;
        Mon, 09 Aug 2021 15:59:59 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id j5sm8616086edv.10.2021.08.09.15.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:59:58 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:59:57 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 5/7] net: dsa: microchip: ksz8795: Use software untagging
 on CPU port
Message-ID: <20210809225956.GF17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the CPU port, we can support both tagged and untagged VLANs at the
same time by doing any necessary untagging in software rather than
hardware.  To enable that, keep the CPU port's Remove Tag flag cleared
and set the dsa_switch::untag_bridge_pvid flag.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7a3d0d137ed1..ddfe9cd6b7bd 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1150,8 +1150,10 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 	/* If a VLAN is added with untagged flag different from the
 	 * port's Remove Tag flag, we need to change the latter.
 	 * Ignore VID 0, which is always untagged.
+	 * Ignore CPU port, which will always be tagged.
 	 */
-	if (untagged != p->remove_tag && vlan->vid != 0) {
+	if (untagged != p->remove_tag && vlan->vid != 0 &&
+	    port != dev->cpu_port) {
 		unsigned int vid;
 
 		/* Reject attempts to add a VLAN that requires the
@@ -1767,6 +1769,11 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt;
 
+	/* We rely on software untagging on the CPU port, so that we
+	 * can support both tagged and untagged VLANs
+	 */
+	dev->ds->untag_bridge_pvid = true;
+
 	return 0;
 }
 
-- 
2.20.1

