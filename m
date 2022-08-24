Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABC559FDEF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbiHXPLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238039AbiHXPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:11:24 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135B085FF8
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:11:22 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 1F8E6FF804;
        Wed, 24 Aug 2022 15:11:15 +0000 (UTC)
Message-ID: <7d8df50d-48a9-3a14-786d-1e1452a1e73b@ovn.org>
Date:   Wed, 24 Aug 2022 17:11:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Cc:     dev@openvswitch.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, i.maximets@ovn.org,
        Aaron Conole <aconole@redhat.com>
Content-Language: en-US
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
References: <20220823151241.497501-1-andrey.zhadchenko@virtuozzo.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: fix memory leak at failed
 datapath creation
In-Reply-To: <20220823151241.497501-1-andrey.zhadchenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 17:12, Andrey Zhadchenko via dev wrote:
> ovs_dp_cmd_new()->ovs_dp_change()->ovs_dp_set_upcall_portids()
> allocates array via kmalloc.
> If for some reason new_vport() fails during ovs_dp_cmd_new()
> dp->upcall_portids must be freed.
> Add missing kfree.
> 
> Kmemleak example:
> unreferenced object 0xffff88800c382500 (size 64):
>   comm "dump_state", pid 323, jiffies 4294955418 (age 104.347s)
>   hex dump (first 32 bytes):
>     5e c2 79 e4 1f 7a 38 c7 09 21 38 0c 80 88 ff ff  ^.y..z8..!8.....
>     03 00 00 00 0a 00 00 00 14 00 00 00 28 00 00 00  ............(...
>   backtrace:
>     [<0000000071bebc9f>] ovs_dp_set_upcall_portids+0x38/0xa0
>     [<000000000187d8bd>] ovs_dp_change+0x63/0xe0
>     [<000000002397e446>] ovs_dp_cmd_new+0x1f0/0x380
>     [<00000000aa06f36e>] genl_family_rcv_msg_doit+0xea/0x150
>     [<000000008f583bc4>] genl_rcv_msg+0xdc/0x1e0
>     [<00000000fa10e377>] netlink_rcv_skb+0x50/0x100
>     [<000000004959cece>] genl_rcv+0x24/0x40
>     [<000000004699ac7f>] netlink_unicast+0x23e/0x360
>     [<00000000c153573e>] netlink_sendmsg+0x24e/0x4b0
>     [<000000006f4aa380>] sock_sendmsg+0x62/0x70
>     [<00000000d0068654>] ____sys_sendmsg+0x230/0x270
>     [<0000000012dacf7d>] ___sys_sendmsg+0x88/0xd0
>     [<0000000011776020>] __sys_sendmsg+0x59/0xa0
>     [<000000002e8f2dc1>] do_syscall_64+0x3b/0x90
>     [<000000003243e7cb>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: b83d23a2a38b ("openvswitch: Introduce per-cpu upcall dispatch")
> Acked-by: Aaron Conole <aconole@redhat.com>
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> ---
>  net/openvswitch/datapath.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 7e8a39a35627..3eb1dc435276 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1802,7 +1802,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  				ovs_dp_reset_user_features(skb, info);
>  		}
>  
> -		goto err_unlock_and_destroy_meters;
> +		goto err_destroy_pids;
>  	}
>  
>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
> @@ -1817,6 +1817,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>  	return 0;
>  
> +err_destroy_pids:
> +	if (rcu_dereference_raw(dp->upcall_portids))
> +		kfree(rcu_dereference_raw(dp->upcall_portids));

kfree() as all typical implementations of free()-like functions
should be perfectly fine to call with a NULL argument.

Also, dereferencing RCU pointer twice is a bad pattern.  I know,
it's not a real problem here, since no other threads seen that
pointer yet.  But it's probably better to avoid bad patterns
anyway, as someone may copy it in the future to other place where
it will be a problem.

Best regards, Ilya Maximets.
