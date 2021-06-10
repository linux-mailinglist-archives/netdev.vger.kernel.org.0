Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA2F3A2990
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJKrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:47:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5485 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhFJKrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:47:14 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G10ss2tqKzZfXP;
        Thu, 10 Jun 2021 18:42:25 +0800 (CST)
Received: from dggpemm500009.china.huawei.com (7.185.36.225) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 18:45:16 +0800
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemm500009.china.huawei.com (7.185.36.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 18:45:15 +0800
Subject: Re: [PATCH -next] netlabel: Fix memory leak in netlbl_mgmt_add_common
To:     Dongliang Mu <mudongliangabcd@gmail.com>
References: <20210610020108.1356361-1-liushixin2@huawei.com>
 <CAD-N9QWypyEa65-sz3rrtM2o5xzQd_5kJPyC4n+nK5JTviQvEQ@mail.gmail.com>
CC:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   Liu Shixin <liushixin2@huawei.com>
Message-ID: <ea1c6878-94d4-63ba-5dea-1190c146581d@huawei.com>
Date:   Thu, 10 Jun 2021 18:45:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAD-N9QWypyEa65-sz3rrtM2o5xzQd_5kJPyC4n+nK5JTviQvEQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500009.china.huawei.com (7.185.36.225)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/10 11:08, Dongliang Mu wrote:
> On Thu, Jun 10, 2021 at 9:31 AM Liu Shixin <liushixin2@huawei.com> wrote:
>> Hulk Robot reported memory leak in netlbl_mgmt_add_common.
>> The problem is non-freed map in case of netlbl_domhsh_add() failed.
>>
>> BUG: memory leak
>> unreferenced object 0xffff888100ab7080 (size 96):
>>   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
>>   hex dump (first 32 bytes):
>>     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
>>   backtrace:
>>     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
>>     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
>>     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
>>     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
>>     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
>>     [<0000000020e96fdd>] genl_rcv+0x24/0x40
>>     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
>>     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
>>     [<000000006e43415f>] sock_sendmsg+0x139/0x170
>>     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
>>     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
>>     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
>>     [<00000000643ac172>] do_syscall_64+0x37/0x90
>>     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
>> ---
>>  net/netlabel/netlabel_mgmt.c | 20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
>> index e664ab990941..e7f00c0f441e 100644
>> --- a/net/netlabel/netlabel_mgmt.c
>> +++ b/net/netlabel/netlabel_mgmt.c
>> @@ -191,6 +191,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>>                 entry->family = AF_INET;
>>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>>                 entry->def.addrsel = addrmap;
>> +
>> +               ret_val = netlbl_domhsh_add(entry, audit_info);
>> +               if (ret_val != 0) {
>> +                       kfree(map);
>> +                       goto add_free_addrmap;
>> +               }
>>  #if IS_ENABLED(CONFIG_IPV6)
>>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
>>                 struct in6_addr *addr;
>> @@ -243,13 +249,19 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>>                 entry->family = AF_INET6;
>>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>>                 entry->def.addrsel = addrmap;
>> +
>> +               ret_val = netlbl_domhsh_add(entry, audit_info);
>> +               if (ret_val != 0) {
>> +                       kfree(map);
>> +                       goto add_free_addrmap;
>> +               }
>>  #endif /* IPv6 */
>> +       } else {
>> +               ret_val = netlbl_domhsh_add(entry, audit_info);
>> +               if (ret_val != 0)
>> +                       goto add_free_addrmap;
>>         }
>>
>> -       ret_val = netlbl_domhsh_add(entry, audit_info);
>> -       if (ret_val != 0)
>> -               goto add_free_addrmap;
>> -
> Hi Shixin,
>
> I have a small suggestion about this patch: you can move the variable
> map out of if/else if branches, like the following code snippet.
>
> Be aware to assign the variable map to NULL at first. Then kfree in
> the last else branch will do nothing.
>
> I don't test the following diff, if there are any issues, please let me know.
>
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index ca52f5085989..1824bcd2272b 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -78,6 +78,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>  {
>         int ret_val = -EINVAL;
>         struct netlbl_domaddr_map *addrmap = NULL;
> +       struct netlbl_domaddr4_map *map = NULL;
>         struct cipso_v4_doi *cipsov4 = NULL;
>  #if IS_ENABLED(CONFIG_IPV6)
>         struct calipso_doi *calipso = NULL;
> @@ -147,7 +148,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>         if (info->attrs[NLBL_MGMT_A_IPV4ADDR]) {
>                 struct in_addr *addr;
>                 struct in_addr *mask;
> -               struct netlbl_domaddr4_map *map;
>
>                 addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
>                 if (addrmap == NULL) {
> @@ -195,7 +195,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
>                 struct in6_addr *addr;
>                 struct in6_addr *mask;
> -               struct netlbl_domaddr6_map *map;
>
>                 addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
>                 if (addrmap == NULL) {
> @@ -247,8 +246,10 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>         }
>
>         ret_val = netlbl_domhsh_add(entry, audit_info);
> -       if (ret_val != 0)
> +       if (ret_val != 0) {
> +               kfree(map);
>                 goto add_free_addrmap;
> +       }
>
>         return 0;
>
The type of map can be struct netlbl_domaddr4_map or struct netlbl_domaddr6_map
under different conditions. It seems like I can't put them together simply.

Thanks,
>
>
>
>>         return 0;
>>
>>  add_free_addrmap:
>> --
>> 2.18.0.huawei.25
>>
> .
>

