Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D703E4FB0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 01:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhHIXAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhHIXAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 19:00:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF09C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 16:00:18 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b15so7690688ejg.10
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R/UdCYZCVR4mjo6B5/QmX6kXXoyFbU1YPunfol2qSgA=;
        b=OF/OYnn6/YR6r77VKmCIq84XLu5DNMhZFxv/LFbDRo07PooME9/85XZU4+5ee+Ht40
         ICKuMPyOocuGgpKaKYp1U7rPZTjgn00u6SuEFq1xZab8ADDD6jS+Df4Wov8vQ8j38gv/
         dI6y2GS/EtJeWR39m0sg/eApUef3RgN23R++xAy/koU9s2F73hy9ascv8vljRBT8Sz78
         R6axkZwHjGrAaCxdTeU7gKN7LbQtGnkg8Rt4Zkwxhb36YzZCSxliPC8bJuNW1QjB18Eo
         mq3A9ayao671W7SFJuFLHQOWKE8ticSsDya3b27QTlDh18397xNMgP8lMy782Q2oeuP6
         VtGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R/UdCYZCVR4mjo6B5/QmX6kXXoyFbU1YPunfol2qSgA=;
        b=ZqaXO79hQygXmUIV/WPl2/fl8yyb2SaKHpGsYPiVRZ7Ob4YZQ6oFmrTjxPE6EDUGpg
         gnjlPkEY3aVE5/WnG/0b+Q2ctOJHm+ThgGnR+3y8vNmWzJafhDBbyEVrbjMVuI6gaWRL
         r6kn8b8eidvazkeBguAIZ5ozEyH0utZTawhY0i+wGLspEA5RA3qByY1aCPmqLlkerUhH
         /+q9Q+yljC4wFY7xEMYIGcrUQjkC00zhuqe8CifkS1dlupVT53aGMkRHgvx8y76fynOJ
         i+ApOlIto0P5FZDFv3daR4tnm6keKBkb/D1vNIYV4FM6bpUBQDW6XshhSGx0oG1ie5su
         Fl8g==
X-Gm-Message-State: AOAM532ZWWjMokMoDH8Z+MdMwYBp3IrgwAmnQCC1ZOfkLwQ4ICK8SMON
        dbt71+zQbQMTZFaVGgJeXwAVVw==
X-Google-Smtp-Source: ABdhPJwUrJQOW+b0EdhOT4z2/x0+wptC+QwasZq4CQz0v8qOMZD2V4APihRg5ya3hVYiZCTA2XXJTA==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr24663178ejb.139.1628550017546;
        Mon, 09 Aug 2021 16:00:17 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id y23sm6283778ejp.115.2021.08.09.16.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:00:17 -0700 (PDT)
Date:   Tue, 10 Aug 2021 01:00:15 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 7/7] net: dsa: microchip: ksz8795: Don't use phy_port_cnt
 in VLAN table lookup
Message-ID: <20210809230014.GH17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The magic number 4 in VLAN table lookup was the number of entries we
can read and write at once.  Using phy_port_cnt here doesn't make
sense and presumably broke VLAN filtering for 3-port switches.  Change
it back to 4.

Fixes: 4ce2a984abd8 ("net: dsa: microchip: ksz8795: use phy_port_cnt ...")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 891eaeb62ad0..4a6a3838418f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -687,8 +687,8 @@ static void ksz8_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	shifts = ksz8->shifts;
 
 	ksz8_r_table(dev, TABLE_VLAN, addr, &data);
-	addr *= dev->phy_port_cnt;
-	for (i = 0; i < dev->phy_port_cnt; i++) {
+	addr *= 4;
+	for (i = 0; i < 4; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
 		data >>= shifts[VLAN_TABLE];
 	}
@@ -702,7 +702,7 @@ static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
+	addr = vid / 4;
 	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	*vlan = data[index];
@@ -716,7 +716,7 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / dev->phy_port_cnt;
+	addr = vid / 4;
 	index = vid & 3;
 	ksz8_r_table(dev, TABLE_VLAN, addr, &buf);
 	data[index] = vlan;
-- 
2.20.1
