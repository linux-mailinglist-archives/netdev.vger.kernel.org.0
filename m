Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569A32C4E8D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 06:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbgKZF56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 00:57:58 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:19219 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387863AbgKZF56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 00:57:58 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAHv-000AYz-QN; Thu, 26 Nov 2020 06:57:51 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kiAHu-000AYo-VI; Thu, 26 Nov 2020 06:57:50 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id A1F9E240041;
        Thu, 26 Nov 2020 06:57:50 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 1A759240040;
        Thu, 26 Nov 2020 06:57:50 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 77508200F6;
        Thu, 26 Nov 2020 06:57:44 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 06:57:44 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net,
        xie.he.0141@gmail.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/5] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <20201125134925.26d851f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201124093938.22012-1-ms@dev.tdt.de>
 <20201124093938.22012-3-ms@dev.tdt.de>
 <20201125134925.26d851f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <82d7a9cb1375a24c8cf26615f71ca99b@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1606370271-00001F6B-90FFE692/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-25 22:49, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 10:39:35 +0100 Martin Schiller wrote:
>> This patch allows layer2 (LAPB) to react to netdev events itself and
>> avoids the detour via layer3 (X.25).
>> 
>> 1. Establish layer2 on NETDEV_UP events, if the carrier is already up.
>> 
>> 2. Call lapb_disconnect_request() on NETDEV_GOING_DOWN events to 
>> signal
>>    the peer that the connection will go down.
>>    (Only when the carrier is up.)
>> 
>> 3. When a NETDEV_DOWN event occur, clear all queues, enter state
>>    LAPB_STATE_0 and stop all timers.
>> 
>> 4. The NETDEV_CHANGE event makes it possible to handle carrier loss 
>> and
>>    detection.
>> 
>>    In case of Carrier Loss, clear all queues, enter state LAPB_STATE_0
>>    and stop all timers.
>> 
>>    In case of Carrier Detection, we start timer t1 on a DCE interface,
>>    and on a DTE interface we change to state LAPB_STATE_1 and start
>>    sending SABM(E).
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> 
>> +/* Handle device status changes. */
>> +static int lapb_device_event(struct notifier_block *this, unsigned 
>> long event,
>> +			     void *ptr)
>> +{
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct lapb_cb *lapb;
>> +
>> +	if (!net_eq(dev_net(dev), &init_net))
>> +		return NOTIFY_DONE;
>> +
>> +	if (dev->type == ARPHRD_X25) {
> 
> Flip condition, save indentation.
> 
> 	if (dev->type != ARPHRD_X25)
> 		return NOTIFY_DONE;
> 
> You can also pull out of all the cases:
> 
> 	lapb = lapb_devtostruct(dev);
> 	if (!lapb)
> 		return NOTIFY_DONE;
> 
> right?
> 
>> +		switch (event) {
>> +		case NETDEV_UP:
>> +			lapb_dbg(0, "(%p) Interface up: %s\n", dev,
>> +				 dev->name);
>> +
>> +			if (netif_carrier_ok(dev)) {
>> +				lapb = lapb_devtostruct(dev);
>> +				if (!lapb)
>> +					break;
> 
>>  static int __init lapb_init(void)
>>  {
>> +	register_netdevice_notifier(&lapb_dev_notifier);
> 
> This can fail, so:
> 
> 	return register_netdevice_notifier(&lapb_dev_notifier);
> 
>>  	return 0;
>>  }
>> 
>>  static void __exit lapb_exit(void)
>>  {
>>  	WARN_ON(!list_empty(&lapb_list));
>> +
>> +	unregister_netdevice_notifier(&lapb_dev_notifier);
>>  }
>> 
>>  MODULE_AUTHOR("Jonathan Naylor <g4klx@g4klx.demon.co.uk>");

Thanks for your hints! I will send an update.
