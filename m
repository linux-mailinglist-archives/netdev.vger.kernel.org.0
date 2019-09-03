Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1FFA7622
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 23:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfICV0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 17:26:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:58077 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfICV0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 17:26:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 14:26:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,464,1559545200"; 
   d="scan'208";a="383234073"
Received: from ellie.jf.intel.com (HELO ellie) ([10.24.13.22])
  by fmsmga006.fm.intel.com with ESMTP; 03 Sep 2019 14:26:45 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
In-Reply-To: <CA+h21hpCAJhE8xhsgDQ55_MUUiesV=uVY4tD=TzaCE6wynUPoQ@mail.gmail.com>
References: <20190903010817.GA13595@embeddedor> <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com> <CA+h21hpCAJhE8xhsgDQ55_MUUiesV=uVY4tD=TzaCE6wynUPoQ@mail.gmail.com>
Date:   Tue, 03 Sep 2019 14:26:45 -0700
Message-ID: <8736hd9ilm.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

> Right. And while we're at it, there's still the potential
> division-by-zero problem which I still don't know how to solve without
> implementing a full-blown __ethtool_get_link_ksettings parser that
> checks against all the possible outputs it can have under the "no
> carrier" condition - see "[RFC PATCH 1/1] phylink: Set speed to
> SPEED_UNKNOWN when there is no PHY connected" for details.
> And there's also a third fix to be made: the netdev_dbg should be made
> to print "speed" instead of "ecmd.base.speed".

For the ksettings part I am thinking on adding something like this to
ethtool.c. Do you think anything is missing (apart from the
documentation)?

->

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e43..d37c80b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -177,6 +177,9 @@ void ethtool_convert_legacy_u32_to_link_mode(unsigned long *dst,
 bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 				     const unsigned long *src);
 
+u32 ethtool_link_ksettings_to_speed(const struct ethtool_link_ksettings *settings,
+				    u32 default_speed);
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @get_drvinfo: Report driver/device information.  Should only set the
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69..80e3db3 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -539,6 +539,18 @@ struct ethtool_link_usettings {
 	} link_modes;
 };
 
+u32 ethtool_link_ksettings_to_speed(const struct ethtool_link_ksettings *settings,
+				   u32 default_speed)
+{
+	if (settings->base.speed == SPEED_UNKNOWN)
+		return default_speed;
+
+	if (settings->base.speed == 0)
+		return default_speed;
+
+	return settings->base.speed;
+}
+
 /* Internal kernel helper to query a device ethtool_link_settings. */
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
