Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9629713A0B6
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 06:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgANFhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 00:37:08 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:9358
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgANFhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 00:37:07 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 79EDF20498;
        Tue, 14 Jan 2020 05:37:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jan 2020 06:37:03 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     khc@pm.waw.pl, davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
Organization: TDT AG
In-Reply-To: <20200113055316.4e811276@cakuba>
References: <20200113124551.2570-1-ms@dev.tdt.de>
 <20200113055316.4e811276@cakuba>
Message-ID: <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-13 14:53, Jakub Kicinski wrote:
> On Mon, 13 Jan 2020 13:45:50 +0100, Martin Schiller wrote:
>> This enables you to configure mode (DTE/DCE), Modulo, Window, T1, T2, 
>> N2 via
>> sethdlc (which needs to be patched as well).
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> 
>> diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
>> index 5643675ff724..b28051eba736 100644
>> --- a/drivers/net/wan/hdlc_x25.c
>> +++ b/drivers/net/wan/hdlc_x25.c
>> @@ -21,8 +21,17 @@
>>  #include <linux/skbuff.h>
>>  #include <net/x25device.h>
>> 
>> +struct x25_state {
>> +	x25_hdlc_proto settings;
>> +};
>> +
>>  static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
>> 
>> +static inline struct x25_state* state(hdlc_device *hdlc)
> 
> Please no more static inlines in source files. Compiler will know what
> to do.

OK, i will remove the "inline". I've just used it, because it's also
in the hdlc_fr.c and hdlc_cisco.c code.

> 
>> +{
>> +	return (struct x25_state *)hdlc->state;
>> +}
>> +
>>  /* These functions are callbacks called by LAPB layer */
>> 
>>  static void x25_connect_disconnect(struct net_device *dev, int 
>> reason, int code)
> 
>> @@ -186,6 +217,9 @@ static struct hdlc_proto proto = {
>> 
>>  static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
>>  {
>> +	x25_hdlc_proto __user *x25_s = ifr->ifr_settings.ifs_ifsu.x25;
>> +	const size_t size = sizeof(x25_hdlc_proto);
>> +	x25_hdlc_proto new_settings;
>>  	hdlc_device *hdlc = dev_to_hdlc(dev);
>>  	int result;
>> 
>> @@ -194,7 +228,13 @@ static int x25_ioctl(struct net_device *dev, 
>> struct ifreq *ifr)
>>  		if (dev_to_hdlc(dev)->proto != &proto)
>>  			return -EINVAL;
>>  		ifr->ifr_settings.type = IF_PROTO_X25;
>> -		return 0; /* return protocol only, no settable parameters */
>> +		if (ifr->ifr_settings.size < size) {
>> +			ifr->ifr_settings.size = size; /* data size wanted */
>> +			return -ENOBUFS;
>> +		}
>> +		if (copy_to_user(x25_s, &state(hdlc)->settings, size))
>> +			return -EFAULT;
>> +		return 0;
>> 
>>  	case IF_PROTO_X25:
>>  		if (!capable(CAP_NET_ADMIN))
>> @@ -203,12 +243,35 @@ static int x25_ioctl(struct net_device *dev, 
>> struct ifreq *ifr)
>>  		if (dev->flags & IFF_UP)
>>  			return -EBUSY;
>> 
>> +		if (copy_from_user(&new_settings, x25_s, size))
>> +			return -EFAULT;
>> +
>> +		if ((new_settings.dce != 0 &&
>> +		     new_settings.dce != 1) ||
>> +		    (new_settings.modulo != 8 &&
>> +		     new_settings.modulo != 128) ||
>> +		    new_settings.window < 1 ||
>> +		    (new_settings.modulo == 8 &&
>> +		     new_settings.window > 7) ||
>> +		    (new_settings.modulo == 128 &&
>> +		     new_settings.window > 127) ||
>> +		    new_settings.t1 < 1 ||
>> +		    new_settings.t1 > 255 ||
>> +		    new_settings.t2 < 1 ||
>> +		    new_settings.t2 > 255 ||
>> +		    new_settings.n2 < 1 ||
>> +		    new_settings.n2 > 255)
>> +			return -EINVAL;
>> +
>>  		result=hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
>>  		if (result)
>>  			return result;
>> 
>> -		if ((result = attach_hdlc_protocol(dev, &proto, 0)))
>> +		if ((result = attach_hdlc_protocol(dev, &proto,
>> +						   sizeof(struct x25_state))))
>>  			return result;
>> +
>> +		memcpy(&state(hdlc)->settings, &new_settings, size);
>>  		dev->type = ARPHRD_X25;
>>  		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
>>  		netif_dormant_off(dev);
>> diff --git a/include/uapi/linux/hdlc/ioctl.h 
>> b/include/uapi/linux/hdlc/ioctl.h
>> index 0fe4238e8246..3656ce8b8af0 100644
>> --- a/include/uapi/linux/hdlc/ioctl.h
>> +++ b/include/uapi/linux/hdlc/ioctl.h
>> @@ -3,7 +3,7 @@
>>  #define __HDLC_IOCTL_H__
>> 
>> 
>> -#define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc 
>> utility */
>> +#define GENERIC_HDLC_VERSION 5	/* For synchronization with sethdlc 
>> utility */
> 
> What's the backward compatibility story in this code?

Well, I thought I have to increment the version to keep the kernel code
and the sethdlc utility in sync (like the comment says).

> 
> The IOCTL handling at least looks like it may start returning errors
> to existing user space which could have expected the parameters to
> IF_PROTO_X25 (other than just ifr_settings.type) to be ignored.

I could also try to implement it without incrementing the version by
looking at ifr_settings.size and using the former defaults if the size
doesn't match.


> 
>>  #define CLOCK_DEFAULT   0	/* Default setting */
>>  #define CLOCK_EXT	1	/* External TX and RX clock - DTE */

