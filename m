Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BE5F0444
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 07:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiI3Fmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 01:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiI3Fmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 01:42:42 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9468718A49A;
        Thu, 29 Sep 2022 22:42:40 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D4E701884C74;
        Fri, 30 Sep 2022 05:42:37 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id CC22E2500370;
        Fri, 30 Sep 2022 05:42:37 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BB3929EC0010; Fri, 30 Sep 2022 05:42:37 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 30 Sep 2022 07:42:37 +0200
From:   netdev@kapio-technology.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
In-Reply-To: <20220929112744.27cc969b@kernel.org>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220929091036.3812327f@kernel.org>
 <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
 <20220929112744.27cc969b@kernel.org>
User-Agent: Gigahost Webmail
Message-ID: <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-29 20:27, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 18:37:09 +0200 netdev@kapio-technology.com wrote:
>> On 2022-09-29 18:10, Jakub Kicinski wrote:
>> > On Wed, 28 Sep 2022 17:02:47 +0200 Hans Schultz wrote:
>> >> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>> >>
>> >> This patch set extends the locked port feature for devices
>> >> that are behind a locked port, but do not have the ability to
>> >> authorize themselves as a supplicant using IEEE 802.1X.
>> >> Such devices can be printers, meters or anything related to
>> >> fixed installations. Instead of 802.1X authorization, devices
>> >> can get access based on their MAC addresses being whitelisted.
>> >
>> > Try a allmodconfig build on latest net-next, seems broken.

Obviously my method of selecting all switchcore drivers with sub-options 
under menuconfig was not sufficient, and I didn't know of the 
allmodconfig option, otherwise I would have used it.

So the question is if I should repost the fixed patch-set or I need to 
make a new version?

Anyhow I hope that there will not be problems when running the 
selftests, as I have not been able to do so with my system, so there can 
be more that needs to be changed.

If anyone needs it, here is the compile fix patch:

diff --git a/drivers/net/dsa/qca/qca8k-common.c 
b/drivers/net/dsa/qca/qca8k-common.c
index 0c5f49de6729..e26a9a483955 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -809,7 +809,7 @@ int qca8k_port_fdb_add(struct dsa_switch *ds, int 
port,

  int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
  		       const unsigned char *addr, u16 vid,
-		       struct dsa_db db)
+		       u16 fdb_flags, struct dsa_db db)
  {
  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
  	u16 port_mask = BIT(port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c 
b/drivers/net/dsa/sja1105/sja1105_main.c
index 1f12a5b89c91..526177813d53 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1938,7 +1938,7 @@ static void sja1105_fast_age(struct dsa_switch 
*ds, int port)

  		u64_to_ether_addr(l2_lookup.macaddr, macaddr);

-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, 0, db);
  		if (rc) {
  			dev_err(ds->dev,
  				"Failed to delete FDB entry %pM vid %lld: %pe\n",
@@ -1952,14 +1952,14 @@ static int sja1105_mdb_add(struct dsa_switch 
*ds, int port,
  			   const struct switchdev_obj_port_mdb *mdb,
  			   struct dsa_db db)
  {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, false, db);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, 0, db);
  }

  static int sja1105_mdb_del(struct dsa_switch *ds, int port,
  			   const struct switchdev_obj_port_mdb *mdb,
  			   struct dsa_db db)
  {
-	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, 0, db);
  }

  /* Common function for unicast and broadcast flood configuration.
