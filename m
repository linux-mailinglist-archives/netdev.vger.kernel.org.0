Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50A9595D8D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiHPNlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiHPNle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA5E75FEA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660657291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HojF8xQDqjPycN8F1tM6BoPC6Kr90xBpJgnkgFRMbN4=;
        b=AS3yBpOWgz2l13AsObposuFjiP1D0DAjFdR+fJ3jjPZw8rxqL3a3DpBevFbNWKRWFsRXSx
        SIdXTRG1H6YS1dBU7SOB4IP+hhDkQ9iV6FOZTJzStPgBuM9TevOOyF1zuaWDWqKQHA607H
        LBKzqCebBY1KQxgL0E6QAGGeTE1yRT0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-TG2cgh3kPTakJcv_aGHm_Q-1; Tue, 16 Aug 2022 09:41:29 -0400
X-MC-Unique: TG2cgh3kPTakJcv_aGHm_Q-1
Received: by mail-qt1-f199.google.com with SMTP id e30-20020ac8011e000000b00342f61e67aeso8340847qtg.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HojF8xQDqjPycN8F1tM6BoPC6Kr90xBpJgnkgFRMbN4=;
        b=JMfGjXnJ2yaRO9Vc/+3vmzGzYNpHr9RwuE1bqNSntflCFtM9pXgoXlx/N7HUbxV2HG
         NlAGMVaOirkwioAIepZEj6BC3vAYJBjOj0iU6MW3Rq4HFja2THKa5wzsD8lnr3dEeZ+c
         /b7mEb41bv/Kln0JJVDRkEsLYfnbOaEEZHlVWsEFtgkAPsXD7/x1PhujxrSjjpSnukYs
         TPcssRHl6ndeF7C1Ws15IZ6iER8W5gGfLKknqVE2PA5g/7j9/w3K5htbxnZYJ0ljh8Tz
         xBmGEEXs/LbJmYGO+5gpPTTcVx1vrDsQDhg27iQUYEIYWsrO1RhyiR+NEvoZZI3SNSG8
         mgYg==
X-Gm-Message-State: ACgBeo3fSQt2TWbvz+AKvoIz4Nlc+8Qe2bwutXLYIpHoFzBz3823LM7l
        IIeQRN15kuJj6cKFGfMmhHA4Us/xqqZPb7VnpkikgZ1P1K0zxudd03oX8uL3ylU2KwLJZMuY5p1
        v4lqGUiM38GclscFE
X-Received: by 2002:a05:622a:18a3:b0:343:5a0b:4884 with SMTP id v35-20020a05622a18a300b003435a0b4884mr18881134qtc.396.1660657287717;
        Tue, 16 Aug 2022 06:41:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7/XnqL08o4gV66q7PF+HLU1re1fOaCsTZdcrXzc98AiasccD9nyC3mvDzO7EghclDphq7Pvw==
X-Received: by 2002:a05:622a:18a3:b0:343:5a0b:4884 with SMTP id v35-20020a05622a18a300b003435a0b4884mr18881109qtc.396.1660657287400;
        Tue, 16 Aug 2022 06:41:27 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id cp5-20020a05622a420500b0031f41ea94easm10020381qtb.28.2022.08.16.06.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 06:41:27 -0700 (PDT)
Message-ID: <3d55690a-8932-4560-4267-ab28816fdb47@redhat.com>
Date:   Tue, 16 Aug 2022 09:41:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v3 2/2] bonding: 802.3ad: fix no transmission of
 LACPDUs
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, liuhangbin@gmail.com,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <cover.1660572700.git.jtoppins@redhat.com>
 <0639f1e3d366c5098d561a947fd416fa5277e7f4.1660572700.git.jtoppins@redhat.com>
 <17000.1660655501@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <17000.1660655501@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/22 09:11, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> This is caused by the global variable ad_ticks_per_sec being zero as
>> demonstrated by the reproducer script discussed below. This causes
>> all timer values in __ad_timer_to_ticks to be zero, resulting
>> in the periodic timer to never fire.
>>
>> To reproduce:
>> Run the script in
>> `tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh` which
>> puts bonding into a state where it never transmits LACPDUs.
>>
>> line 44: ip link add fbond type bond mode 4 miimon 200 \
>>             xmit_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
>> setting bond param: ad_actor_sys_prio
>> given:
>>     params.ad_actor_system = 0
>> call stack:
>>     bond_option_ad_actor_sys_prio()
>>     -> bond_3ad_update_ad_actor_settings()
>>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>>             params.ad_actor_system == 0
>> results:
>>      ad.system.sys_mac_addr = bond->dev->dev_addr
>>
>> line 48: ip link set fbond address 52:54:00:3B:7C:A6
>> setting bond MAC addr
>> call stack:
>>     bond->dev->dev_addr = new_mac
>>
>> line 52: ip link set fbond type bond ad_actor_sys_prio 65535
>> setting bond param: ad_actor_sys_prio
>> given:
>>     params.ad_actor_system = 0
>> call stack:
>>     bond_option_ad_actor_sys_prio()
>>     -> bond_3ad_update_ad_actor_settings()
>>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>>             params.ad_actor_system == 0
>> results:
>>      ad.system.sys_mac_addr = bond->dev->dev_addr
>>
>> line 60: ip link set veth1-bond down master fbond
>> given:
>>     params.ad_actor_system = 0
>>     params.mode = BOND_MODE_8023AD
>>     ad.system.sys_mac_addr == bond->dev->dev_addr
>> call stack:
>>     bond_enslave
>>     -> bond_3ad_initialize(); because first slave
>>        -> if ad.system.sys_mac_addr != bond->dev->dev_addr
>>           return
>> results:
>>      Nothing is run in bond_3ad_initialize() because dev_add equals
>>      sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
>>      never initialized anywhere else.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>>
>> Notes:
>>     v2:
>>      * split this fix from the reproducer
>>     v3:
>>      * rebased to latest net/master
>>
>> drivers/net/bonding/bond_3ad.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>> index d7fb33c078e8..957d30db6f95 100644
>> --- a/drivers/net/bonding/bond_3ad.c
>> +++ b/drivers/net/bonding/bond_3ad.c
>> @@ -84,7 +84,8 @@ enum ad_link_speed_type {
>> static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
>> 	0, 0, 0, 0, 0, 0
>> };
>> -static u16 ad_ticks_per_sec;
>> +
>> +static u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
>> static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
> 
> 	I still feel like this is kind of a hack, as it's not really
> fixing bond_3ad_initialize to actually work (which is the real problem
> as I understand it).  If it's ok to skip all that for this case, then
> why do we ever need to call bond_3ad_initialize?
> 

The way it is currently written you still need to call 
bond_3ad_initialize() just not for setting the tick resolution. The 
issue here is ad_ticks_per_sec is used in several places to calculate 
timer periods, __ad_timer_to_ticks(), for various timers in the 802.3ad 
protocol. And if this variable, ad_ticks_per_sec, is left uninitialized 
all of these timer periods go to zero. Since the value passed in 
bond_3ad_initialize() is an immediate value I simply moved it off of the 
call stack and set the static global variable instead.

To fix bond_3ad_initialize(), probably something like the below is 
needed, but I do not understand why the guard if check was placed in 
bond_3ad_initialize().

diff --git i/drivers/net/bonding/bond_3ad.c w/drivers/net/bonding/bond_3ad.c
index d7fb33c078e8..5b5146f5c4ea 100644
--- i/drivers/net/bonding/bond_3ad.c
+++ w/drivers/net/bonding/bond_3ad.c
@@ -2005,32 +2005,21 @@ void bond_3ad_initiate_agg_selection(struct 
bonding *bond, int timeout)
   *
   * Can be called only after the mac address of the bond is set.
   */
-void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
+void bond_3ad_initialize(struct bonding *bond)
  {
-	/* check that the bond is not initialized yet */
-	if (!MAC_ADDRESS_EQUAL(&(BOND_AD_INFO(bond).system.sys_mac_addr),
-				bond->dev->dev_addr)) {
-
-		BOND_AD_INFO(bond).aggregator_identifier = 0;
-
-		BOND_AD_INFO(bond).system.sys_priority =
-			bond->params.ad_actor_sys_prio;
-		if (is_zero_ether_addr(bond->params.ad_actor_system))
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->dev->dev_addr);
-		else
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->params.ad_actor_system);
-
-		/* initialize how many times this module is called in one
-		 * second (should be about every 100ms)
-		 */
-		ad_ticks_per_sec = tick_resolution;
+	BOND_AD_INFO(bond).aggregator_identifier = 0;
+	BOND_AD_INFO(bond).system.sys_priority =
+		bond->params.ad_actor_sys_prio;
+	if (is_zero_ether_addr(bond->params.ad_actor_system))
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->dev->dev_addr);
+	else
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->params.ad_actor_system);

-		bond_3ad_initiate_agg_selection(bond,
-						AD_AGGREGATOR_SELECTION_TIMER *
-						ad_ticks_per_sec);
-	}
+	bond_3ad_initiate_agg_selection(bond,
+					AD_AGGREGATOR_SELECTION_TIMER *
+					ad_ticks_per_sec);
  }

  /**
diff --git i/drivers/net/bonding/bond_main.c 
w/drivers/net/bonding/bond_main.c
index 50e60843020c..5f56af9dc3ba 100644
--- i/drivers/net/bonding/bond_main.c
+++ w/drivers/net/bonding/bond_main.c
@@ -2078,10 +2078,10 @@ int bond_enslave(struct net_device *bond_dev, 
struct net_device *slave_dev,
  		/* if this is the first slave */
  		if (!prev_slave) {
  			SLAVE_AD_INFO(new_slave)->id = 1;
-			/* Initialize AD with the number of times that the AD timer is 
called in 1 second
-			 * can be called only after the mac address of the bond is set
+			/* can be called only after the mac address of the
+			 * bond is set
  			 */
-			bond_3ad_initialize(bond, 1000/AD_TIMER_INTERVAL);
+			bond_3ad_initialize(bond);
  		} else {
  			SLAVE_AD_INFO(new_slave)->id =
  				SLAVE_AD_INFO(prev_slave)->id + 1;
diff --git i/include/net/bond_3ad.h w/include/net/bond_3ad.h
index 184105d68294..be2992e6de5d 100644
--- i/include/net/bond_3ad.h
+++ w/include/net/bond_3ad.h
@@ -290,7 +290,7 @@ static inline const char 
*bond_3ad_churn_desc(churn_state_t state)
  }

  /* ========== AD Exported functions to the main bonding code ========== */
-void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution);
+void bond_3ad_initialize(struct bonding *bond);
  void bond_3ad_bind_slave(struct slave *slave);
  void bond_3ad_unbind_slave(struct slave *slave);
  void bond_3ad_state_machine_handler(struct work_struct *);

-Jon

