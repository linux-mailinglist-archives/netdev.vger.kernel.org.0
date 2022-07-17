Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F672577296
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 02:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiGQAre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 20:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQArd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 20:47:33 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12C718353;
        Sat, 16 Jul 2022 17:47:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id m16so10846596edb.11;
        Sat, 16 Jul 2022 17:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l7bhK+yH8qPDx9ouvwOKxIBbwCcGqm09mHsiooe+B/g=;
        b=cgZNz5yEDoqf3BvIHwXAGTF3k51NWbEgAW1h4GCEGo/NB5UpfkNeWir8+Ngijr/Qcl
         XiQpxltSWV14hn0AkFXJ/FLUYFcZrov7FNnlJON8o/sJaK63KH7CLrwl36m8IFMa9pca
         8DIFGPYUrHpYRoT8rP3ftrgdJU97VoINjOTK6RJAdS2B/I/YnDEkfa+1Ncq40Y1crKIP
         vW4Fk0wR/hzLkpEVOsb3bL5e2vAq1VYHdd9LTSY/C/LeB58FUOFAX2DspwG95ExOZWx5
         mNWRy9YV7Z6+1RS/hbIik7BbwR7A+rAbvJdYJggMIWwdaFTUXKKyUf++RbIInXZNKH2P
         f+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l7bhK+yH8qPDx9ouvwOKxIBbwCcGqm09mHsiooe+B/g=;
        b=nCBg6G6dDmB/xNj1Fg9yR04IOuxvwVt9UgO+T7pcRMJJbl4QbymQ6h/klPBXkKD25P
         LHMUi2nNuiW5Wa3hxW5d+CmGgK/6ANAHCQ2clisuYV6RrmPyfzlKsxKS2+uMM2KkUw1p
         elxccm6ASbLkx8GMDoa7giXHPNVXNWFT5uef8tRDwATvkmSfW9Ek41cSIztqzbxbRg6B
         tzmS4yBQAKsnKCkfA7j0ptMscj9/YqHmAzID3hAwyzSpEfC/f5ZkS0/cn3cAQZnd1jrN
         5hN79wWlmoU3CPHOoG8088aVW52g9FW1jQE62H5Wyqfw64Pm1kEOCEy6fVPrJ/CbS5nT
         HIvw==
X-Gm-Message-State: AJIora+RzztlJam4U23YPpGel+DL0j9ijMeqWD9L6Q3WdTQ6plqYk8ip
        FgcKBQfqyBpzuQ1CEk5Zh1w=
X-Google-Smtp-Source: AGRyM1slzObPVTRw6t0WuWNhOK2/XfDQakyo4UNLogwe+bSF3rZzRLpH5Wtgl6xME9nBbRB7AJQ3JA==
X-Received: by 2002:a05:6402:430f:b0:43a:d521:bda with SMTP id m15-20020a056402430f00b0043ad5210bdamr29226956edc.69.1658018849156;
        Sat, 16 Jul 2022 17:47:29 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id ku2-20020a170907788200b0072b21cab5a5sm3735937ejc.133.2022.07.16.17.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 17:47:28 -0700 (PDT)
Date:   Sun, 17 Jul 2022 03:47:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/6] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220717004725.ngix64ou2mz566is@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-6-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707152930.1789437-6-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 05:29:29PM +0200, Hans Schultz wrote:
> This implementation for the Marvell mv88e6xxx chip series,
> is based on handling ATU miss violations occurring when packets
> ingress on a port that is locked. The mac address triggering
> the ATU miss violation will be added to the ATU with a zero-DPV,
> and is then communicated through switchdev to the bridge module,
> which adds a fdb entry with the fdb locked flag set. The entry
> is kept according to the bridges ageing time, thus simulating a
> dynamic entry.
> 
> As this is essentially a form of CPU based learning, the amount
> of locked entries will be limited by a hardcoded value for now,
> so as to prevent DOS attacks.
> 
> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> ---
>  static void assert_reg_lock(struct mv88e6xxx_chip *chip)
>  {
> @@ -919,6 +920,13 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
>  	if (err)
>  		dev_err(chip->dev,
>  			"p%d: failed to force MAC link down\n", port);
> +	else
> +		if (mv88e6xxx_port_is_locked(chip, port)) {
> +			err = mv88e6xxx_atu_locked_entry_flush(ds, port);
> +			if (err)
> +				dev_err(chip->dev,
> +					"p%d: failed to clear locked entries\n", port);
> +		}
>  }
>  
>  static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
> @@ -1685,6 +1693,12 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err;
>  
> +	if (mv88e6xxx_port_is_locked(chip, port))
> +		err = mv88e6xxx_atu_locked_entry_flush(ds, port);
> +	if (err)

Kernel build robot pointed this out too, but it's worth repeating to
make sure it doesn't get missed. If the port isn't locked, this function
returns a junk integer from the stack which isn't zero, so it's treated
as an error code.

> +		dev_err(chip->ds->dev, "p%d: failed to clear locked entries: %d\n",
> +			port, err);
> +
>  	mv88e6xxx_reg_lock(chip);
>  	err = mv88e6xxx_port_fast_age_fid(chip, port, 0);
>  	mv88e6xxx_reg_unlock(chip);
> @@ -1721,11 +1735,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>  	return err;
>  }
>  
>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>  			    bool locked)
>  {
> @@ -1257,13 +1270,18 @@ int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>  	if (err)
>  		return err;
>  
> -	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
> -	if (err)
> -		return err;
> +	if (!locked) {
> +		err = mv88e6xxx_atu_locked_entry_flush(chip->ds, port);

Did you re-run the selftest with v4? Because this deadlocks due to the
double reg_lock illustrated below:

+ vrf_name=vlan1
+ ip vrf exec vlan1 ping 192.0.2.2 -c 10 -i 0.1 -w 5
+ check_err 1 'Ping did not work after locking port and adding FDB entry'
+ local err=1
+ local 'msg=Ping did not work after locking port and adding FDB entry'
+ [[ 0 -eq 0 ]]
+ [[ 1 -ne 0 ]]
+ RET=1
+ retmsg='Ping did not work after locking port and adding FDB entry'
+ bridge link set dev lan2 locked off
[  733.273994]
[  733.275515] ============================================
[  733.280823] WARNING: possible recursive locking detected
[  733.286133] 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3293 Not tainted
[  733.292311] --------------------------------------------
[  733.297613] kworker/0:0/601 is trying to acquire lock:
[  733.302751] ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4}, at: mv88e6xxx_atu_locked_entry_purge+0x70/0x1a4
[  733.312524]
[  733.312524] but task is already holding lock:
[  733.318351] ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4}, at: mv88e6xxx_port_bridge_flags+0x48/0x234
[  733.327674]
[  733.327674] other info that might help us debug this:
[  733.334198]  Possible unsafe locking scenario:
[  733.334198]
[  733.340109]        CPU0
[  733.342549]        ----
[  733.344990]   lock(&chip->reg_lock);
[  733.348567]   lock(&chip->reg_lock);
[  733.352149]
[  733.352149]  *** DEADLOCK ***
[  733.352149]
[  733.358063]  May be due to missing lock nesting notation
[  733.358063]
[  733.364846] 6 locks held by kworker/0:0/601:
[  733.369115]  #0: ffff00000000b748 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c4
[  733.378541]  #1: ffff80000c43bdc8 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c4
[  733.387966]  #2: ffff80000b020cb0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x1c/0x30
[  733.395660]  #3: ffff80000b073370 ((switchdev_blocking_notif_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x34/0xa0
[  733.407432]  #4: ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4}, at: mv88e6xxx_port_bridge_flags+0x48/0x234
[  733.417202]  #5: ffff00000213e0f0 (&p->ale_list_lock){+.+.}-{4:4}, at: mv88e6xxx_atu_locked_entry_flush+0x4c/0xc0
[  733.427495]
[  733.427495] stack backtrace:
[  733.431858] CPU: 0 PID: 601 Comm: kworker/0:0 Not tainted 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3293
[  733.440992] Hardware name: CZ.NIC Turris Mox Board (DT)
[  733.446219] Workqueue: events switchdev_deferred_process_work
[  733.451982] Call trace:
[  733.454424]  dump_backtrace.part.0+0xcc/0xe0
[  733.458702]  show_stack+0x18/0x6c
[  733.462028]  dump_stack_lvl+0x8c/0xb8
[  733.465703]  dump_stack+0x18/0x34
[  733.469029]  __lock_acquire+0x1074/0x1fd0
[  733.473052]  lock_acquire.part.0+0xe4/0x220
[  733.477244]  lock_acquire+0x68/0x8c
[  733.480744]  __mutex_lock+0x9c/0x460
[  733.484332]  mutex_lock_nested+0x40/0x50
[  733.488268]  mv88e6xxx_atu_locked_entry_purge+0x70/0x1a4
[  733.493592]  mv88e6xxx_atu_locked_entry_flush+0x7c/0xc0
[  733.498827]  mv88e6xxx_port_set_lock+0xfc/0x10c
[  733.503374]  mv88e6xxx_port_bridge_flags+0x200/0x234
[  733.508351]  dsa_port_bridge_flags+0x44/0xe0
[  733.512635]  dsa_slave_port_attr_set+0x1ec/0x230
[  733.517268]  __switchdev_handle_port_attr_set+0x58/0x100
[  733.522594]  switchdev_handle_port_attr_set+0x10/0x24
[  733.527659]  dsa_slave_switchdev_blocking_event+0x8c/0xd4
[  733.533074]  blocking_notifier_call_chain+0x6c/0xa0
[  733.537968]  switchdev_port_attr_notify.constprop.0+0x4c/0xb0
[  733.543729]  switchdev_port_attr_set_deferred+0x24/0x80
[  733.548967]  switchdev_deferred_process+0x90/0x164
[  733.553774]  switchdev_deferred_process_work+0x14/0x2c
[  733.558926]  process_one_work+0x28c/0x6c4
[  733.562949]  worker_thread+0x74/0x450
[  733.566623]  kthread+0x118/0x11c
[  733.569860]  ret_from_fork+0x10/0x20
++ mac_get lan1
++ local if_name=lan1
++ jq -r '.[]["address"]'
++ ip -j link show dev lan1

I've tentatively fixed this in my tree by taking the register lock more
localized to the sub-functions of mv88e6xxx_port_bridge_flags(), and not
taking it at caller side for mv88e6xxx_port_set_lock(), but rather
letting the callee take it:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7b57ac121589..ec5954f32774 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6557,41 +6557,47 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err = -EOPNOTSUPP;
 
-	mv88e6xxx_reg_lock(chip);
-
 	if (flags.mask & BR_LEARNING) {
 		bool learning = !!(flags.val & BR_LEARNING);
 		u16 pav = learning ? (1 << port) : 0;
 
+		mv88e6xxx_reg_lock(chip);
 		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	if (flags.mask & BR_FLOOD) {
 		bool unicast = !!(flags.val & BR_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = chip->info->ops->port_set_ucast_flood(chip, port,
 							    unicast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	if (flags.mask & BR_MCAST_FLOOD) {
 		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = chip->info->ops->port_set_mcast_flood(chip, port,
 							    multicast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	if (flags.mask & BR_BCAST_FLOOD) {
 		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
-			goto out;
+			return err;
 	}
 
 	if (flags.mask & BR_PORT_LOCKED) {
@@ -6599,10 +6605,8 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 
 		err = mv88e6xxx_port_set_lock(chip, port, locked);
 		if (err)
-			goto out;
+			return err;
 	}
-out:
-	mv88e6xxx_reg_unlock(chip);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 5e4d5e9265a4..2a60aded6fbe 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1222,15 +1222,19 @@ int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 	u16 reg;
 	int err;
 
+	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
-	if (err)
+	if (err) {
+		mv88e6xxx_reg_unlock(chip);
 		return err;
+	}
 
 	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
 	if (locked)
 		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
 
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
+	mv88e6xxx_reg_unlock(chip);
 	if (err)
 		return err;
 
@@ -1247,7 +1251,11 @@ int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
 	}
 
-	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
 }
 
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,

> +		if (err)
> +			return err;
> +	}
>  
> -	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> -	if (locked)
> -		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> +	reg = 0;
> +	if (locked) {
> +		reg = (1 << port);
> +		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
> +			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> +	}
>  
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index e0a705d82019..5c1d485e7442 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -231,6 +231,7 @@
>  #define MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT		0x2000
>  #define MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG	0x1000
>  #define MV88E6XXX_PORT_ASSOC_VECTOR_REFRESH_LOCKED	0x0800
> +#define MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK		0x07ff
>  
>  /* Offset 0x0C: Port ATU Control */
>  #define MV88E6XXX_PORT_ATU_CTL		0x0c
> @@ -374,6 +375,7 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
>  int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, u16 *pvid);
>  int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
>  
> +bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port);
>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>  			    bool locked);
>  

Other than that, after going through some hoops and patching iproute2,
the switch appears to do something, I do see locked FDB entries:

[root@mox:~/.../drivers/net/dsa] # bridge fdb show dev lan2
00:01:02:03:04:01 vlan 1 locked extern_learn offload master br0 
00:01:02:03:04:02 vlan 1 master br0 permanent
00:01:02:03:04:02 master br0 permanent

however all selftests except for MAB appear to fail:

[root@mox:~/.../drivers/net/dsa] # ./bridge_locked_port.sh lan1 lan2 lan3 lan4
[ 2394.084584] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 2398.984189] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
RTNETLINK answers: File exists
TEST: Locked port ipv4                                              [FAIL]
        Ping did not work after locking port and adding FDB entry
[ 2410.452638] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 2415.366824] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
RTNETLINK answers: File exists
TEST: Locked port ipv6                                              [FAIL]
        Ping6 did not work after locking port and adding FDB entry
[ 2425.653013] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2425.663784] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2425.752771] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2425.853188] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2425.954193] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2426.054593] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2426.155646] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2426.256733] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2426.357159] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2426.457638] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2427.354018] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 2430.679471] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 33 callbacks suppressed
[ 2430.679502] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2430.723742] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2430.783752] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2430.887742] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2430.991738] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2431.095714] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2431.199505] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2431.303700] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2431.407707] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2431.511674] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
RTNETLINK answers: File exists
[ 2435.683201] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 28 callbacks suppressed
[ 2435.683232] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2435.787060] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2435.891223] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2435.995249] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.099218] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.203215] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.307207] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.411175] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.515179] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2436.619220] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2440.712164] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 26 callbacks suppressed
[ 2440.712194] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2440.812777] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2440.913630] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2441.014523] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2441.114196] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 2441.214961] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
TEST: Locked port vlan                                              [FAIL]
        Ping through vlan did not work after locking port and adding FDB entry
[ 2443.945008] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 2448.131708] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
TEST: Locked port MAB                                               [ OK ]
[ 2455.139841] mv88e6085 d0032004.mdio-mii:10 lan3: Link is Down
[ 2455.158623] br0: port 2(lan3) entered disabled state
[ 2455.288477] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Down
[ 2455.309996] br0: port 1(lan2) entered disabled state
[ 2455.446341] device lan3 left promiscuous mode
[ 2455.452208] br0: port 2(lan3) entered disabled state
[ 2455.574232] device lan2 left promiscuous mode
[ 2455.580378] br0: port 1(lan2) entered disabled state
[ 2455.906058] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Down
[ 2456.069399] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Down

Compare this to the same selftest, run just before applying the
mv88e6xxx MAB patch:

TEST: Locked port ipv4                                              [ OK ]
TEST: Locked port ipv6                                              [ OK ]
[  119.080114] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.091009] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.180557] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.280916] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.381256] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.481618] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.581993] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.682416] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.782799] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.883177] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.100262] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 33 callbacks suppressed
[  124.100293] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.136182] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.204408] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.312440] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.416384] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.520361] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.624347] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.728344] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.832336] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  124.936341] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.014610] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 20 callbacks suppressed
[  130.014637] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.118292] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.219203] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.324289] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.335695] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.424680] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.525600] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.626466] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.728275] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.829422] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
TEST: Locked port vlan                                              [ OK ]
[  133.926477] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.028380] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.132571] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.244056] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.344703] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.448416] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.552692] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.656642] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.760786] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  134.864605] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  139.247209] mv88e6xxx_g1_atu_prob_irq_thread_fn: 41 callbacks suppressed
[  139.247241] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[  144.358773] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
TEST: Locked port MAB                                               [FAIL]
        MAB: No locked fdb entry after ping on locked port

In other words, this patch set makes MAB work and breaks everything else.
I'm willing to investigate exactly what is it that breaks the other
selftest, but not today. It may be related to the "RTNETLINK answers: File exists"
messages, which themselves come from the commands
| bridge fdb add 00:01:02:03:04:01 dev lan2 master static

If I were to randomly guess at almost 4AM in the morning, it has to do with
"bridge fdb add" rather than the "bridge fdb replace" that's used for
the MAB selftest. The fact I pointed out a few revisions ago, that MAB
needs to be opt-in, is now coming back to bite us. Since it's not
opt-in, the mv88e6xxx driver always creates locked FDB entries, and when
we try to "bridge fdb add", the kernel says "hey, the FDB entry is
already there!". Is that it?

As for how to opt into MAB. Hmm. MAB seems to be essentially CPU
assisted learning, which creates locked FDB entries. I wonder whether we
should reconsider the position that address learning makes no sense on
locked ports, and say that "+locked -learning" means no MAB, and
"+locked +learning" means MAB? This would make a bunch of things more
natural to handle in the kernel, and would also give us the opt-in we need.



Side note, the VTU and ATU member violation printks annoy me so badly.
They aren't stating something super useful and they're a DoS attack
vector in itself, even if they're rate limited. I wonder whether we
could just turn the prints into a set of ethtool counters and call it a day?
