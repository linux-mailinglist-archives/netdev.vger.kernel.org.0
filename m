Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEBB587A69
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiHBKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiHBKNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:13:51 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9354B48D;
        Tue,  2 Aug 2022 03:13:49 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6F5291884456;
        Tue,  2 Aug 2022 10:13:47 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 3FCBB25032B7;
        Tue,  2 Aug 2022 10:13:47 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 367BAA1E00B9; Tue,  2 Aug 2022 10:13:47 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 02 Aug 2022 12:13:47 +0200
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
Subject: Re: [PATCH v4 net-next 2/6] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220708085403.sk7znfad3x2mnxeh@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-3-netdev@kapio-technology.com>
 <20220708085403.sk7znfad3x2mnxeh@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <0d884212b8df03e5cf03c4b2e5ea3e3d@kapio-technology.com>
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

On 2022-07-08 10:54, Vladimir Oltean wrote:

>>  	struct dsa_db db;
>>  };
>> 
>> @@ -131,6 +132,7 @@ struct dsa_switchdev_event_work {
>>  	unsigned char addr[ETH_ALEN];
>>  	u16 vid;
>>  	bool host_addr;
>> +	bool is_locked;
> 
> drop
> 
>>  };
>> 
>>  enum dsa_standalone_event {
>> @@ -232,7 +234,7 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
>>  		       const struct switchdev_vlan_msti *msti);
>>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
>>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
>> -		     u16 vid);
>> +		     u16 vid, bool is_locked);
> 
> drop
> 
>>  int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
>>  		     u16 vid);
>>  int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 3738f2d40a0b..8bdac9aabe5d 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -35,6 +35,7 @@ static void dsa_port_notify_bridge_fdb_flush(const 
>> struct dsa_port *dp, u16 vid)
>>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>>  	struct switchdev_notifier_fdb_info info = {
>>  		.vid = vid,
>> +		.is_locked = false,
> 
> drop
> 
>>  	};
>> 
>>  	/* When the port becomes standalone it has already left the bridge.
>> @@ -950,12 +951,13 @@ int dsa_port_mtu_change(struct dsa_port *dp, int 
>> new_mtu)
>>  }
>> 
>>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
>> -		     u16 vid)
>> +		     u16 vid, bool is_locked)
> 
> drop
> 
>>  {
>>  	struct dsa_notifier_fdb_info info = {
>>  		.dp = dp,
>>  		.addr = addr,
>>  		.vid = vid,
>> +		.is_locked = is_locked,
> 
> drop
> 
>>  		.db = {
>>  			.type = DSA_DB_BRIDGE,
>>  			.bridge = *dp->bridge,
>> @@ -979,6 +981,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const 
>> unsigned char *addr,
>>  		.dp = dp,
>>  		.addr = addr,
>>  		.vid = vid,
>> +		.is_locked = false,
> 
> drop
> 
>>  		.db = {
>>  			.type = DSA_DB_BRIDGE,
>>  			.bridge = *dp->bridge,
>> @@ -999,6 +1002,7 @@ static int dsa_port_host_fdb_add(struct dsa_port 
>> *dp,
>>  		.dp = dp,
>>  		.addr = addr,
>>  		.vid = vid,
>> +		.is_locked = false,
> 
> drop
> 
>>  		.db = db,
>>  	};
>> 
>> @@ -1050,6 +1054,7 @@ static int dsa_port_host_fdb_del(struct dsa_port 
>> *dp,
>>  		.dp = dp,
>>  		.addr = addr,
>>  		.vid = vid,
>> +		.is_locked = false,
> 
> drop
> 
>>  		.db = db,
>>  	};
>> 
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 801a5d445833..905b15e4eab9 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -2784,6 +2784,7 @@ static void 
>> dsa_slave_switchdev_event_work(struct work_struct *work)
>>  		container_of(work, struct dsa_switchdev_event_work, work);
>>  	const unsigned char *addr = switchdev_work->addr;
>>  	struct net_device *dev = switchdev_work->dev;
>> +	bool is_locked = switchdev_work->is_locked;
> 
> drop
> 
>>  	u16 vid = switchdev_work->vid;
>>  	struct dsa_switch *ds;
>>  	struct dsa_port *dp;
>> @@ -2799,7 +2800,7 @@ static void 
>> dsa_slave_switchdev_event_work(struct work_struct *work)
>>  		else if (dp->lag)
>>  			err = dsa_port_lag_fdb_add(dp, addr, vid);
>>  		else
>> -			err = dsa_port_fdb_add(dp, addr, vid);
>> +			err = dsa_port_fdb_add(dp, addr, vid, is_locked);
> 
> drop
> 
>>  		if (err) {
>>  			dev_err(ds->dev,
>>  				"port %d failed to add %pM vid %d to fdb: %d\n",
>> @@ -2907,6 +2908,7 @@ static int dsa_slave_fdb_event(struct net_device 
>> *dev,
>>  	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
>>  	switchdev_work->vid = fdb_info->vid;
>>  	switchdev_work->host_addr = host_addr;
>> +	switchdev_work->is_locked = fdb_info->is_locked;
> 
> drop
> 
>> 
>>  	dsa_schedule_work(&switchdev_work->work);
>> 
>> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
>> index 2b56218fc57c..32b1e7ac6373 100644
>> --- a/net/dsa/switch.c
>> +++ b/net/dsa/switch.c
>> @@ -234,7 +234,7 @@ static int dsa_port_do_mdb_del(struct dsa_port 
>> *dp,
>>  }
>> 
>>  static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned 
>> char *addr,
>> -			       u16 vid, struct dsa_db db)
>> +			       u16 vid, bool is_locked, struct dsa_db db)
> 
> drop
> 
>>  {
>>  	struct dsa_switch *ds = dp->ds;
>>  	struct dsa_mac_addr *a;
>> @@ -398,7 +398,7 @@ static int dsa_switch_host_fdb_add(struct 
>> dsa_switch *ds,
>>  	dsa_switch_for_each_port(dp, ds) {
>>  		if (dsa_port_host_address_match(dp, info->dp)) {
>>  			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
>> -						  info->db);
>> +						  false, info->db);
> 
> drop
> 
>>  			if (err)
>>  				break;
>>  		}
>> @@ -437,7 +437,7 @@ static int dsa_switch_fdb_add(struct dsa_switch 
>> *ds,
>>  	if (!ds->ops->port_fdb_add)
>>  		return -EOPNOTSUPP;
>> 
>> -	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
>> +	return dsa_port_do_fdb_add(dp, info->addr, info->vid, 
>> info->is_locked, info->db);
> 
> drop
> 
>>  }
>> 
>>  static int dsa_switch_fdb_del(struct dsa_switch *ds,
>> --
>> 2.30.2
>> 

Hi Vladimir and Ido,

I can either ignore locked entries early or late in the dsa/switchdev 
layers.

If I ignore early, I think it should be in br_switchdev_fdb_notify() in 
net/bridge/br_switchdev.c.
If I ignore late, I would think that it should be jut before sending it 
to the driver(s), e.g. in dsa_port_do_fdb_add() in net/dsa/switch.c.

There is of course pros and cons of both options, but if the flag is 
never to be sent to the driver, then it should be ignored early.

If ignored late most of this patch should not be dropped.
