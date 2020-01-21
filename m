Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2590114451F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUT3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:29:14 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:23612 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgAUT3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1579634949;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=vPvdJUwPaxhFdaK3SDi9GFlbWcswk6F/jC/SrfgsGSc=;
        b=b1iFSSOKCN93TIsyFGO5yH0M5cBxN1ZvdBP0ug46xQvJFV9i3pDECxYaay5Jog39v1
        0F4lYGWIZqf0Ku7C95svG+bDSKh49lDs/X58MDJJ7jYixoDil4R2HxOadvM3pURpgS/d
        vIUHA5nx8/nzdSx1xpiZ/JiLM2NnnhCUrC19ycmCvUOMCUj+GPhHcYQcbsRaFsDkVcN3
        vPPOSxmFgzTMjXrxh6JlpPovD0LRuFUsWVRdQznPSliszMGw+g0rA941Zdssq9aPVpyZ
        TJb3GcnhEfpYrb/kmqRWvLc3xkwSrVhCmJ+ooFCaaTUdmaqLnpORYtSGlsta1/4slzt9
        8x3Q==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h5kyA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.40.177]
        by smtp.strato.de (RZmta 46.1.5 DYNA|AUTH)
        with ESMTPSA id t040cew0LJSv5f3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 21 Jan 2020 20:28:57 +0100 (CET)
Subject: Re: general protection fault in can_rx_register
To:     Dmitry Vyukov <dvyukov@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        o.rempel@pengutronix.de,
        syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
References: <00000000000030dddb059c562a3f@google.com>
 <55ad363b-1723-28aa-78b1-8aba5565247e@hartkopp.net>
 <20200120091146.GD11138@x1.vandijck-laurijssen.be>
 <CACT4Y+a+GusEA1Gs+z67uWjtwBRp_s7P4Wd_SMmgpCREnDu3kg@mail.gmail.com>
 <8332ec7f-2235-fdf6-9bda-71f789c57b37@hartkopp.net>
 <2a676c0e-20f2-61b5-c72b-f51947bafc7d@hartkopp.net>
 <20200121083035.GD14537@x1.vandijck-laurijssen.be>
 <20200121185407.GA13462@x1.vandijck-laurijssen.be>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <a04209c8-747b-6116-d915-21c285f48730@hartkopp.net>
Date:   Tue, 21 Jan 2020 20:28:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121185407.GA13462@x1.vandijck-laurijssen.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On 21/01/2020 19.54, Kurt Van Dijck wrote:
> On di, 21 jan 2020 09:30:35 +0100, Kurt Van Dijck wrote:
>> On ma, 20 jan 2020 23:35:16 +0100, Oliver Hartkopp wrote:


>>> But it is still open why dev->ml_priv is not set correctly in vxcan.c as all
>>> the settings for .priv_size and in vxcan_setup look fine.
>>
>> Maybe I got completely lost:
>> Shouldn't can_ml_priv and vxcan_priv not be similar?
>> Where is the dev_rcv_lists in the vxcan case?
> 
> I indeed got completely lost. vxcan_priv & can_ml_priv form together the
> private part. I continue looking

I added some more debug output:

@@ -463,6 +463,10 @@ int can_rx_register(struct net *net, struct 
net_device *dev, canid_t can_id,
         spin_lock_bh(&net->can.rcvlists_lock);

         dev_rcv_lists = can_dev_rcv_lists_find(net, dev);
+       if (!dev_rcv_lists) {
+               pr_err("dev_rcv_lists == NULL! %p (%s)\n", dev, dev->name);
+               goto out_unlock;
+       }
         rcv_list = can_rcv_list_find(&can_id, &mask, dev_rcv_lists);

         rcv->can_id = can_id;


and the output becomes:

[ 1814.644087] bond5130: (slave vxcan1): The slave device specified does 
not support setting the MAC address
[ 1814.644106] bond5130: (slave vxcan1): Error -22 calling dev_set_mtu
[ 1814.648867] bond5128: (slave vxcan1): The slave device specified does 
not support setting the MAC address
[ 1814.648904] bond5128: (slave vxcan1): Error -22 calling dev_set_mtu
[ 1814.649124] dev_rcv_lists == NULL! 000000008e41fb06 (bond5128)
[ 1814.696420] bond5129: (slave vxcan1): The slave device specified does 
not support setting the MAC address
[ 1814.696438] bond5129: (slave vxcan1): Error -22 calling dev_set_mtu

So it's not the vxcan1 netdev that causes the issue but (sporadically!!) 
the bonding netdev.

Interesting enough that the bonding device bond5128 obviously passes the

        if (dev && dev->type != ARPHRD_CAN)
                 return -ENODEV;
test.

?!?

Regards,
Oliver
