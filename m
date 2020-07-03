Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB01213487
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGCGyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:54:54 -0400
Received: from mail.loongson.cn ([114.242.206.163]:36348 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725648AbgGCGyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 02:54:54 -0400
Received: from [10.130.0.66] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxf90x1v5eeQZPAA--.832S3;
        Fri, 03 Jul 2020 14:54:42 +0800 (CST)
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
To:     Jakub Kicinski <kuba@kernel.org>,
        "Christian Benvenuti (benve)" <benve@cisco.com>
References: <20200623.143311.995885759487352025.davem@davemloft.net>
 <20200623.152626.2206118203643133195.davem@davemloft.net>
 <7533075e-0e8e-2fde-c8fa-72e2ea222176@loongson.cn>
 <20200623.202324.442008830004872069.davem@davemloft.net>
 <70519029-1cfa-5fce-52f3-cfb13bf00f7d@loongson.cn>
 <BYAPR11MB37994715A3DD8259DF16A34DBA950@BYAPR11MB3799.namprd11.prod.outlook.com>
 <20200624095903.71a01271@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Cc:     David Miller <davem@davemloft.net>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lixuefeng@loongson.cn" <lixuefeng@loongson.cn>,
        "yangtiezhu@loongson.cn" <yangtiezhu@loongson.cn>
From:   Kaige Li <likaige@loongson.cn>
Message-ID: <71243f6a-561f-4fa1-be03-3e1589497ea4@loongson.cn>
Date:   Fri, 3 Jul 2020 14:54:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200624095903.71a01271@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxf90x1v5eeQZPAA--.832S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWkXFy8CFW5Wr47KryrCrg_yoW8WF48pF
        sYgayrKF40qr1kXw4DCw18C3y2ya1jk34DGw45Z3s29F4DXr9FgryUtr43WFWUuFW7Jr17
        Jwn7Aa4Ivayjv3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxkIecxEwVAFwVW8AwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfUnc_TUUUUU
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/25/2020 12:59 AM, Jakub Kicinski wrote:
> On Wed, 24 Jun 2020 06:32:36 +0000 Christian Benvenuti (benve) wrote:
>> We/Cisco will also look into it, hopefully a small code reorg will be sufficient.

Hi, Christian:

I have seen some submissions and codes, and feel that spin_lock is unnecessary in enci_reset.<https://lore.kernel.org/patchwork/project/lkml/list/?submitter=28441>

<https://lore.kernel.org/patchwork/project/lkml/list/?submitter=28441>

Some key submissions are as follows.

Tue Sep 16 00:17:11 2008

git show 01f2e4ead. we can see that spin_lock is just in here:

+       spin_lock(&enic->devcmd_lock);

+       vnic_dev_hang_notify(enic->vdev);

+       spin_unlock(&enic->devcmd_lock);



Sat Aug 17 06:47:40 2013

git show 0b038566c: Add an interface for USNIC to interact with firmware.

Before commit-id: 0b038566c, spin_lock is not used in enic_reset. rtnl_lock() is enough. And 0b038566c add a interface: enic_api_devcmd_proxy_by_index.

Enic_api_devcmd_proxy_by_index is just used in ./drivers/infiniband/hw/usnic/usnic_fwd.c:50, which is added in 2183b990.

+       spin_lock(&enic->enic_api_lock);

         enic_dev_hang_notify(enic);


         enic_dev_set_ig_vlan_rewrite_mode(enic);

         enic_open(enic->netdev);

+       spin_unlock(&enic->enic_api_lock);

By analyzing enic_api_lock, it's mainly used for locking vnic_dev_cmd(vdev, cmd, a0, a1, wait). And enic_reset didn't call to vnic_dev_cmd.

So, I think spin_lock may be deleted in enci_reset. What do you think? Or you have better advice.

Thank you.

> Make sure you enable CONFIG_DEBUG_ATOMIC_SLEEP when you test.

