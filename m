Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8ED6C5E8C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCWFNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCWFM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:12:57 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0732F1EFC6;
        Wed, 22 Mar 2023 22:12:53 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 32N5BK2V014589;
        Thu, 23 Mar 2023 13:11:20 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.111] (192.168.1.111) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Thu, 23 Mar 2023
 13:11:20 +0800
Message-ID: <f71f1f59-f729-2c8c-f6da-8474be2074b1@fintek.com.tw>
Date:   Thu, 23 Mar 2023 13:11:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH V2] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>,
        <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <frank.jungclaus@esd.eu>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hpeter+linux_kernel@gmail.com>
References: <20230321081152.26510-1-peter_hong@fintek.com.tw>
 <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.111]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27520.000
X-TM-AS-Result: No-12.115600-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E//9O/B1c/Qy3UVR7WQKpLPC/ExpXrHizx6km1x+yMYzb4E
        LhML5UNkRMOrk8OCzo763zLdqQn7vdBUMX40Rzs4FWovz5bBLuaycrvYxo9Kp1kFotLUdLsqsmc
        +HzD5HmjrVITpd9hVjw3ukX1phG3AnpdzfoA7wedC4WIP7GtYLBgff28UuvIT9mqZiOfja88kKo
        BDEWGB+2ChicyzmckEYt5+J3IIlN5lJTodqNqEzs36paW7ZnFoyeUl7aCTy8hmimiikJEPRKPFj
        JEFr+olA6QGdvwfwZZ3M7/Jzxffcd0H8LFZNFG7bkV4e2xSge5F8NDAs67gVTiVFRh82bGNCo8h
        O50wCrYi0tLziQzeNT6Qrn3xh/cy
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.115600-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27520.000
X-TM-SNTS-SMTP: AF440AECAECE3698103DAC244E9705E57134ED1A605F97D33B1C7BC8FCEDAE842000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 32N5BK2V014589
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

Vincent MAILHOL 於 2023/3/21 下午 11:50 寫道:
>> +static netdev_tx_t f81604_start_xmit(struct sk_buff *skb,
>> +                                    struct net_device *netdev)
>> +{
>> +       struct can_frame *cf = (struct can_frame *)skb->data;
>> +       struct f81604_port_priv *priv = netdev_priv(netdev);
>> +       struct net_device_stats *stats = &netdev->stats;
>> +       int status;
>> +       u8 *ptr;
>> +       u32 id;
>> +
>> +       if (can_dropped_invalid_skb(netdev, skb))
>> +               return NETDEV_TX_OK;
>> +
>> +       netif_stop_queue(netdev);
>> +
>> +       ptr = priv->bulk_write_buffer;
>> +       memset(ptr, 0, F81604_DATA_SIZE);
>> +
>> +       ptr[0] = F81604_CMD_DATA;
>> +       ptr[1] = min_t(u8, cf->can_dlc & 0xf, 8);
>> +
>> +       if (cf->can_id & CAN_EFF_FLAG) {
>> +               id = (cf->can_id & CAN_ERR_MASK) << 3;
>> +               ptr[1] |= F81604_EFF_BIT;
>> +               ptr[2] = (id >> 24) & 0xff;
>> +               ptr[3] = (id >> 16) & 0xff;
>> +               ptr[4] = (id >> 8) & 0xff;
>> +               ptr[5] = (id >> 0) & 0xff;
>> +               memcpy(&ptr[6], cf->data, ptr[1]);
> Rather than manipulating an opaque u8 array, please declare a
> structure with explicit names.

I had try to declare a struct like below and refactoring code :

struct f81604_bulk_data {
     u8 cmd;
     u8 dlc;

     union {
         struct {
             u8 id1, id2;
             u8 data[CAN_MAX_DLEN];
         } sff;

         struct {
             u8 id1, id2, id3, id4;
             u8 data[CAN_MAX_DLEN];
         } eff;
     };
} __attribute__((packed));

This struct can used in TX/RX bulk in/out. Is it ok?

> +static int f81604_prepare_urbs(struct net_device *netdev)
> +{
> +       static const u8 bulk_in_addr[F81604_MAX_DEV] = { 0x82, 0x84 };
> +       static const u8 bulk_out_addr[F81604_MAX_DEV] = { 0x01, 0x03 };
> +       static const u8 int_in_addr[F81604_MAX_DEV] = { 0x81, 0x83 };
> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> +       int id = netdev->dev_id;
> +       int i;
> +
> +       /* initialize to NULL for error recovery */
> +       for (i = 0; i < F81604_MAX_RX_URBS; ++i)
> +               priv->read_urb[i] = NULL;
> priv was allocated with devm_kzalloc() so it should already be zeroed,
> right? What is the purpose of this loop?

This operation due to following condition:
     f81604_open() -> f81604_close() -> f81604_open() failed.

We had used  devm_kzalloc() in f81604_probe(), so first f81604_open() all
pointers are NULL. But after f81604_close() then f81604_open() second
times, the URB pointers are not NULLed, it'll makes error on 2nd 
f81604_open()
with fail.

>> +/* Called by the usb core when driver is unloaded or device is removed */
>> +static void f81604_disconnect(struct usb_interface *intf)
>> +{
>> +       struct f81604_priv *priv = usb_get_intfdata(intf);
>> +       int i;
>> +
>> +       for (i = 0; i < F81604_MAX_DEV; ++i) {
>> +               if (!priv->netdev[i])
>> +                       continue;
>> +
>> +               unregister_netdev(priv->netdev[i]);
>> +               free_candev(priv->netdev[i]);
>> +       }
>   i> +}

Is typo here?

Thanks.

