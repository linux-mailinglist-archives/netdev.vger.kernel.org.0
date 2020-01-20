Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F064143422
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgATWfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:35:31 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:30780 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgATWfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1579559728;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:References:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=KGocXKFbjNvf1reVOuA05/9wsguBPo3pEkM+yQaN6GY=;
        b=ihrTIgA+lMdkmhtpqH+yRNQACFRvq39uA3bZGMoVT+9PSeKqQMrAUEEx+EF8UmFbj2
        CoeTMf5Ysw+pnBC1Ls1CWKc8BbmWCDV2fh7GtOU3iLhhlwwdo49Va3PkpA9Plj3oHvn6
        pebLoRl0p0SpudNhkaQvJtFcmMAns+4CevzX/PxWOJFH+P3UvCnIlu2SstJtEFLzV7Yu
        +ZQNCKKpHzijq7tI6z3IOsGaei0xcj6/2aOBH71WzIZF8ggsrUD9umlQ+hUIAAx1HL4O
        1fTTFBt7E830u55c7Onr1UE5GzmvGvLEXAKVKYkX9OD+eNr2+IOoQN6+gg1n9UWa9NUV
        9gQA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVsh5lUkl"
X-RZG-CLASS-ID: mo00
Received: from [192.168.40.177]
        by smtp.strato.de (RZmta 46.1.5 DYNA|AUTH)
        with ESMTPSA id t040cew0KMZG2Rm
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 20 Jan 2020 23:35:16 +0100 (CET)
Subject: Re: general protection fault in can_rx_register
From:   Oliver Hartkopp <socketcan@hartkopp.net>
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
Message-ID: <2a676c0e-20f2-61b5-c72b-f51947bafc7d@hartkopp.net>
Date:   Mon, 20 Jan 2020 23:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8332ec7f-2235-fdf6-9bda-71f789c57b37@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Answering myself ...

On 20/01/2020 23.02, Oliver Hartkopp wrote:

> 
> Added some code to check whether dev->ml_priv is NULL:
> 
> ~/linux$ git diff
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 128d37a4c2e0..6fb4ae4c359e 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -463,6 +463,10 @@ int can_rx_register(struct net *net, struct 
> net_device *dev, canid_t can_id,
>          spin_lock_bh(&net->can.rcvlists_lock);
> 
>          dev_rcv_lists = can_dev_rcv_lists_find(net, dev);
> +       if (!dev_rcv_lists) {
> +               pr_err("dev_rcv_lists == NULL! %p\n", dev);
> +               goto out_unlock;
> +       }
>          rcv_list = can_rcv_list_find(&can_id, &mask, dev_rcv_lists);
> 
>          rcv->can_id = can_id;
> @@ -479,6 +483,7 @@ int can_rx_register(struct net *net, struct 
> net_device *dev, canid_t can_id,
>          rcv_lists_stats->rcv_entries++;
>          rcv_lists_stats->rcv_entries_max = 
> max(rcv_lists_stats->rcv_entries_max,
> 
> rcv_lists_stats->rcv_entries);
> +out_unlock:
>          spin_unlock_bh(&net->can.rcvlists_lock);
> 
>          return err;
> 
> And the output (after some time) is:
> 
> [  758.505841] netlink: 'crash': attribute type 1 has an invalid length.
> [  758.508045] bond7148: (slave vxcan1): The slave device specified does 
> not support setting the MAC address
> [  758.508057] bond7148: (slave vxcan1): Error -22 calling dev_set_mtu
> [  758.532025] bond10413: (slave vxcan1): The slave device specified 
> does not support setting the MAC address
> [  758.532043] bond10413: (slave vxcan1): Error -22 calling dev_set_mtu
> [  758.532254] dev_rcv_lists == NULL! 000000006b9d257f
> [  758.547392] netlink: 'crash': attribute type 1 has an invalid length.
> [  758.549310] bond7145: (slave vxcan1): The slave device specified does 
> not support setting the MAC address
> [  758.549313] bond7145: (slave vxcan1): Error -22 calling dev_set_mtu
> [  758.550464] netlink: 'crash': attribute type 1 has an invalid length.
> [  758.552301] bond7146: (slave vxcan1): The slave device specified does 
> not support setting the MAC address
> 
> So we can see that we get a ml_priv pointer which is NULL which should 
> not be possible due to this:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/can/dev.c#n743 

This reference doesn't point to the right code as vxcan has its own 
handling do assign ml_priv in vxcan.c .

> Btw. the variable 'size' is set two times at the top of 
> alloc_candev_mqs() depending on echo_skb_max. This looks wrong.

No. It looks right as I did not get behind the ALIGN() macro at first sight.

But it is still open why dev->ml_priv is not set correctly in vxcan.c as 
all the settings for .priv_size and in vxcan_setup look fine.

Best regards,
Oliver
