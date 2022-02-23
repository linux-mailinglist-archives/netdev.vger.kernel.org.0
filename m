Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407BC4C0777
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiBWB4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiBWB4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:56:11 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFC6140D0;
        Tue, 22 Feb 2022 17:55:44 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K3Jx34jmPz9snW;
        Wed, 23 Feb 2022 09:53:59 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 09:55:42 +0800
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
 <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
 <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
 <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
 <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
 <124e1c43-95a8-1aad-c781-b43eba09984a@huawei.com>
Message-ID: <07a69043-8a8a-814e-0cb8-de2fe1557bc5@huawei.com>
Date:   Wed, 23 Feb 2022 09:55:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <124e1c43-95a8-1aad-c781-b43eba09984a@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> On Mon, Feb 21, 2022 at 6:06 PM Ziyang Xuan (William)
>> <william.xuanziyang@huawei.com> wrote:
>>>
>>>> On Mon, Feb 21, 2022 at 07:43:18AM -0800, Eric Dumazet wrote:
>>>>>
>>>>> Herbert, do you recall why only a decrease was taken into consideration ?
>>>>
>>>> Because we shouldn't override administrative settings of the MTU
>>>> on the vlan device, unless we have to because of an MTU reduction
>>>> on the underlying device.
>>>>
>>>> Yes this is not perfect if the admin never set an MTU to start with
>>>> but as we don't have a way of telling whether the admin has or has
>>>> not changed the MTU setting, the safest course of action is to do
>>>> nothing in that case.
>>> If the admin has changed the vlan device MTU smaller than the underlying
>>> device MTU firstly, then changed the underlying device MTU smaller than
>>> the vlan device MTU secondly. The admin's configuration has been overridden.
>>> Can we consider that the admin's configuration for the vlan device MTU has
>>> been invalid and disappeared after the second change? I think so.
>>
>> The answer is no.
>>
>> Herbert is saying:
>>
>> ip link add link eth1 dev eth1.100 type vlan id 100
>> ...
>> ip link set eth1.100 mtu 800
>> ..
>> ip link set eth1 mtu 256
>> ip link set eth1 mtu 1500
>>
>> -> we do not want eth1.100 mtu being set back to 1500, this might
>> break applications, depending on old kernel feature.
>>  Eventually, setting back to 800 seems ok.
> 
> It seem that setting back to 800 more reasonable. We can record user
> setting MTU by interface ndo_change_mtu() in struct vlan_dev_priv.
> 

I attempt to record user setting MTU for vlan device. Use the recorded
MTU to restore when uderlying device change the MTU from smaller to
bigger than recorded vlan device MTU. The modification as following:

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 2be4dd7e90a9..b8970e90a279 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -163,6 +163,7 @@ struct netpoll;
  *     @vlan_proto: VLAN encapsulation protocol
  *     @vlan_id: VLAN identifier
  *     @flags: device flags
+ *     @mtu: user setting MTU
  *     @real_dev: underlying netdevice
  *     @dev_tracker: refcount tracker for @real_dev reference
  *     @real_dev_addr: address of underlying netdevice
@@ -179,6 +180,8 @@ struct vlan_dev_priv {
        u16                                     vlan_id;
        u16                                     flags;

+       u32                                     mtu;
+
        struct net_device                       *real_dev;
        netdevice_tracker                       dev_tracker;

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 788076b002b3..492ef88923c2 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -365,6 +365,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
        struct net_device *dev = netdev_notifier_info_to_dev(ptr);
        struct vlan_group *grp;
        struct vlan_info *vlan_info;
+       unsigned int new_mtu;
        int i, flgs;
        struct net_device *vlandev;
        struct vlan_dev_priv *vlan;
@@ -419,10 +420,10 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,

        case NETDEV_CHANGEMTU:
                vlan_group_for_each_dev(grp, i, vlandev) {
-                       if (vlandev->mtu <= dev->mtu)
-                               continue;
+                       vlan = vlan_dev_priv(vlandev);
+                       new_mtu = (!vlan->mtu || dev->mtu < vlan->mtu) ? dev->mtu : vlan->mtu;

-                       dev_set_mtu(vlandev, dev->mtu);
+                       dev_set_mtu(vlandev, new_mtu);
                }
                break;

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index d1902828a18a..66c2b64d1ece 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -140,7 +140,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,

 static int vlan_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
-       struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+       struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
+       struct net_device *real_dev = vlan->real_dev;
        unsigned int max_mtu = real_dev->mtu;

        if (netif_reduces_vlan_mtu(real_dev))
@@ -148,8 +149,15 @@ static int vlan_dev_change_mtu(struct net_device *dev, int new_mtu)
        if (max_mtu < new_mtu)
                return -ERANGE;

-       dev->mtu = new_mtu;
+       /* Identify user MTU change different from the underlying devcie
+        * NETDEV_CHANGEMTU event. Record user setting MTU in mtu member
+        * of struct vlan_dev_priv.
+        */
+       if ((!vlan->mtu && new_mtu != real_dev->mtu) ||
+           (dev->mtu == vlan->mtu && vlan->mtu < real_dev->mtu))
+               vlan->mtu = new_mtu;

+       dev->mtu = new_mtu;
        return 0;
 }


I test it  in various combination scenarios. I found it can not cover one
scenario because user setting can not arrive vlan module codes. For example:

ip link add link eth1 dev eth1.100 type vlan id 100 // eth1.100 MTU 1500
ip link set eth1.100 mtu 1500 // success no error

When new_mtu equal to orig_mtu, user setting operation can not arrive lower
vlan module, vlan module can not perceive, so we can not record the setting.

Before my colleague point that the above setting is not error for user, I
always think that it is invalid setting. But I think his opinion makes sense.

So what do you think about the above setting?

>>
>> If you want this new feature, we need to record in eth1.100 device
>> that no admin ever changed the mtu,
>> as Herbert suggested.
>>
>> Then, it is okay to upgrade the vlan mtu (but still is a behavioral
>> change that _could_ break some scripts)
>>
>> Thank you.
>> .
>>
> .
> 
