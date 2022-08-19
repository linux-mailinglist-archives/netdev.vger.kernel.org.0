Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF54C599C22
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349018AbiHSMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbiHSMoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:44:02 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A272C2E9C6;
        Fri, 19 Aug 2022 05:43:56 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D00811884F89;
        Fri, 19 Aug 2022 12:43:27 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 980F72503314;
        Fri, 19 Aug 2022 12:43:24 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 18BE8A1A5528; Fri, 19 Aug 2022 08:28:10 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 19 Aug 2022 10:28:09 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
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
In-Reply-To: <20220717004725.ngix64ou2mz566is@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-6-netdev@kapio-technology.com>
 <20220717004725.ngix64ou2mz566is@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <b6d95362926772bb513022ad8a45282d@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-17 02:47, Vladimir Oltean wrote:
>> @@ -1721,11 +1735,11 @@ static int mv88e6xxx_vtu_get(struct 
>> mv88e6xxx_chip *chip, u16 vid,
>>  	return err;
>>  }
>> 
>>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>>  			    bool locked)
>>  {
>> @@ -1257,13 +1270,18 @@ int mv88e6xxx_port_set_lock(struct 
>> mv88e6xxx_chip *chip, int port,
>>  	if (err)
>>  		return err;
>> 
>> -	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, 
>> &reg);
>> -	if (err)
>> -		return err;
>> +	if (!locked) {
>> +		err = mv88e6xxx_atu_locked_entry_flush(chip->ds, port);
> 
> Did you re-run the selftest with v4? Because this deadlocks due to the
> double reg_lock illustrated below:

I did some selftest, but I didn't experience the problem of the double 
chip lock as it only happens on unlock which is only called where the 
MAB test ends.

> 
> + vrf_name=vlan1
> + ip vrf exec vlan1 ping 192.0.2.2 -c 10 -i 0.1 -w 5
> + check_err 1 'Ping did not work after locking port and adding FDB 
> entry'
> + local err=1
> + local 'msg=Ping did not work after locking port and adding FDB entry'
> + [[ 0 -eq 0 ]]
> + [[ 1 -ne 0 ]]
> + RET=1
> + retmsg='Ping did not work after locking port and adding FDB entry'
> + bridge link set dev lan2 locked off
> [  733.273994]
> [  733.275515] ============================================
> [  733.280823] WARNING: possible recursive locking detected
> [  733.286133] 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3293 Not tainted
> [  733.292311] --------------------------------------------
> [  733.297613] kworker/0:0/601 is trying to acquire lock:
> [  733.302751] ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4}, at:
> mv88e6xxx_atu_locked_entry_purge+0x70/0x1a4
> [  733.312524]
> [  733.312524] but task is already holding lock:
> [  733.318351] ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4}, at:
> mv88e6xxx_port_bridge_flags+0x48/0x234
> [  733.327674]
> [  733.327674] other info that might help us debug this:
> [  733.334198]  Possible unsafe locking scenario:
> [  733.334198]
> [  733.340109]        CPU0
> [  733.342549]        ----
> [  733.344990]   lock(&chip->reg_lock);
> [  733.348567]   lock(&chip->reg_lock);
> [  733.352149]
> [  733.352149]  *** DEADLOCK ***
> [  733.352149]
> [  733.358063]  May be due to missing lock nesting notation
> [  733.358063]
> [  733.364846] 6 locks held by kworker/0:0/601:
> [  733.369115]  #0: ffff00000000b748
> ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c4
> [  733.378541]  #1: ffff80000c43bdc8
> (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x1f4/0x6c4
> [  733.387966]  #2: ffff80000b020cb0 (rtnl_mutex){+.+.}-{4:4}, at:
> rtnl_lock+0x1c/0x30
> [  733.395660]  #3: ffff80000b073370
> ((switchdev_blocking_notif_chain).rwsem){++++}-{4:4}, at:
> blocking_notifier_call_chain+0x34/0xa0
> [  733.407432]  #4: ffff00000213c110 (&chip->reg_lock){+.+.}-{4:4},
> at: mv88e6xxx_port_bridge_flags+0x48/0x234
> [  733.417202]  #5: ffff00000213e0f0 (&p->ale_list_lock){+.+.}-{4:4},
> at: mv88e6xxx_atu_locked_entry_flush+0x4c/0xc0
> [  733.427495]
> [  733.427495] stack backtrace:
> [  733.431858] CPU: 0 PID: 601 Comm: kworker/0:0 Not tainted
> 5.19.0-rc6-07010-ga9b9500ffaac-dirty #3293
> [  733.440992] Hardware name: CZ.NIC Turris Mox Board (DT)
> [  733.446219] Workqueue: events switchdev_deferred_process_work
> [  733.451982] Call trace:
> [  733.454424]  dump_backtrace.part.0+0xcc/0xe0
> [  733.458702]  show_stack+0x18/0x6c
> [  733.462028]  dump_stack_lvl+0x8c/0xb8
> [  733.465703]  dump_stack+0x18/0x34
> [  733.469029]  __lock_acquire+0x1074/0x1fd0
> [  733.473052]  lock_acquire.part.0+0xe4/0x220
> [  733.477244]  lock_acquire+0x68/0x8c
> [  733.480744]  __mutex_lock+0x9c/0x460
> [  733.484332]  mutex_lock_nested+0x40/0x50
> [  733.488268]  mv88e6xxx_atu_locked_entry_purge+0x70/0x1a4
> [  733.493592]  mv88e6xxx_atu_locked_entry_flush+0x7c/0xc0
> [  733.498827]  mv88e6xxx_port_set_lock+0xfc/0x10c
> [  733.503374]  mv88e6xxx_port_bridge_flags+0x200/0x234
> [  733.508351]  dsa_port_bridge_flags+0x44/0xe0
> [  733.512635]  dsa_slave_port_attr_set+0x1ec/0x230
> [  733.517268]  __switchdev_handle_port_attr_set+0x58/0x100
> [  733.522594]  switchdev_handle_port_attr_set+0x10/0x24
> [  733.527659]  dsa_slave_switchdev_blocking_event+0x8c/0xd4
> [  733.533074]  blocking_notifier_call_chain+0x6c/0xa0
> [  733.537968]  switchdev_port_attr_notify.constprop.0+0x4c/0xb0
> [  733.543729]  switchdev_port_attr_set_deferred+0x24/0x80
> [  733.548967]  switchdev_deferred_process+0x90/0x164
> [  733.553774]  switchdev_deferred_process_work+0x14/0x2c
> [  733.558926]  process_one_work+0x28c/0x6c4
> [  733.562949]  worker_thread+0x74/0x450
> [  733.566623]  kthread+0x118/0x11c
> [  733.569860]  ret_from_fork+0x10/0x20
> ++ mac_get lan1
> ++ local if_name=lan1
> ++ jq -r '.[]["address"]'
> ++ ip -j link show dev lan1
> 
> I've tentatively fixed this in my tree by taking the register lock more
> localized to the sub-functions of mv88e6xxx_port_bridge_flags(), and 
> not
> taking it at caller side for mv88e6xxx_port_set_lock(), but rather
> letting the callee take it:

Yes, the double chip lock came from calling 
mv88e6xxx_atu_locked_entry_flush() in mv88e6xxx_port_set_lock() that is 
called from mv88e6xxx_port_bridge_flags() whic has the lock taken. I 
have fixed this now, but when I unlock a port with locked entries, I 
cannot have notify the bridge to clear the same locked entries by having 
mv88e6xxx_atu_locked_entry_flush() calling with the notify on, thus 
taking the rtnl lock, as this also results in a double lock.
To remove the locked entries in the bridge FDB it is then necessary as I 
see it, to take the link down or have a userspace daemon clear them. I 
hope that is okay if documented?

> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c 
> b/drivers/net/dsa/mv88e6xxx/chip.c
> index 7b57ac121589..ec5954f32774 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -6557,41 +6557,47 @@ static int mv88e6xxx_port_bridge_flags(struct
> dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int err = -EOPNOTSUPP;
> 
> -	mv88e6xxx_reg_lock(chip);
> -
>  	if (flags.mask & BR_LEARNING) {
>  		bool learning = !!(flags.val & BR_LEARNING);
>  		u16 pav = learning ? (1 << port) : 0;
> 
> +		mv88e6xxx_reg_lock(chip);
>  		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
> +		mv88e6xxx_reg_unlock(chip);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> 
>  	if (flags.mask & BR_FLOOD) {
>  		bool unicast = !!(flags.val & BR_FLOOD);
> 
> +		mv88e6xxx_reg_lock(chip);
>  		err = chip->info->ops->port_set_ucast_flood(chip, port,
>  							    unicast);
> +		mv88e6xxx_reg_unlock(chip);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> 
>  	if (flags.mask & BR_MCAST_FLOOD) {
>  		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
> 
> +		mv88e6xxx_reg_lock(chip);
>  		err = chip->info->ops->port_set_mcast_flood(chip, port,
>  							    multicast);
> +		mv88e6xxx_reg_unlock(chip);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> 
>  	if (flags.mask & BR_BCAST_FLOOD) {
>  		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
> 
> +		mv88e6xxx_reg_lock(chip);
>  		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
> +		mv88e6xxx_reg_unlock(chip);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> 
>  	if (flags.mask & BR_PORT_LOCKED) {
> @@ -6599,10 +6605,8 @@ static int mv88e6xxx_port_bridge_flags(struct
> dsa_switch *ds, int port,
> 
>  		err = mv88e6xxx_port_set_lock(chip, port, locked);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> -out:
> -	mv88e6xxx_reg_unlock(chip);
> 
>  	return err;
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c 
> b/drivers/net/dsa/mv88e6xxx/port.c
> index 5e4d5e9265a4..2a60aded6fbe 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1222,15 +1222,19 @@ int mv88e6xxx_port_set_lock(struct
> mv88e6xxx_chip *chip, int port,
>  	u16 reg;
>  	int err;
> 
> +	mv88e6xxx_reg_lock(chip);
>  	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
> -	if (err)
> +	if (err) {
> +		mv88e6xxx_reg_unlock(chip);
>  		return err;
> +	}
> 
>  	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
>  	if (locked)
>  		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
> 
>  	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
> +	mv88e6xxx_reg_unlock(chip);
>  	if (err)
>  		return err;
> 
> @@ -1247,7 +1251,11 @@ int mv88e6xxx_port_set_lock(struct
> mv88e6xxx_chip *chip, int port,
>  			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>  	}
> 
> -	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, 
> reg);
> +	mv88e6xxx_reg_lock(chip);
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, 
> reg);
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
>  }
> 
>  int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int 
> port,
> 
>> +		if (err)
>> +			return err;
>> +	}
>> 
>> -	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>> -	if (locked)
>> -		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>> +	reg = 0;
>> +	if (locked) {
>> +		reg = (1 << port);
>> +		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
>> +			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>> +	}
>> 
>>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, 
>> reg);
>>  }
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.h 
>> b/drivers/net/dsa/mv88e6xxx/port.h
>> index e0a705d82019..5c1d485e7442 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.h
>> +++ b/drivers/net/dsa/mv88e6xxx/port.h
>> @@ -231,6 +231,7 @@
>>  #define MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT		0x2000
>>  #define MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG	0x1000
>>  #define MV88E6XXX_PORT_ASSOC_VECTOR_REFRESH_LOCKED	0x0800
>> +#define MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK		0x07ff
>> 
>>  /* Offset 0x0C: Port ATU Control */
>>  #define MV88E6XXX_PORT_ATU_CTL		0x0c
>> @@ -374,6 +375,7 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip 
>> *chip, int port, u16 fid);
>>  int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, 
>> u16 *pvid);
>>  int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, 
>> u16 pvid);
>> 
>> +bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port);
>>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>>  			    bool locked);
>> 
