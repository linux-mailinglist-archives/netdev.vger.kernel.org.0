Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B506108311
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 12:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKXLOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 06:14:46 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:63775 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfKXLOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 06:14:46 -0500
Received: from [192.168.1.6] (unknown [116.226.206.212])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DB3184163E;
        Sun, 24 Nov 2019 19:14:37 +0800 (CST)
Subject: Re: Question about flow table offload in mlx5e
To:     Paul Blakey <paulb@mellanox.com>
Cc:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
 <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <f0552f13-ae5d-7082-9f68-0358d560c073@ucloud.cn>
 <VI1PR05MB34224DF57470AE3CC46F2CACCF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <746ba973-3c58-31f8-42ce-db880fd1d8f4@ucloud.cn>
 <VI1PR05MB3422BEDAB38E12C26DF7C6C6CF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <64285654-bc9a-c76e-5875-dc6e434dc4d4@ucloud.cn>
 <AM4PR05MB3411EE998E04B7AA9E0081F0CF4B0@AM4PR05MB3411.eurprd05.prod.outlook.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <4b3d1d50-5a7a-5d15-4090-d4e6c17d2d83@ucloud.cn>
Date:   Sun, 24 Nov 2019 19:14:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <AM4PR05MB3411EE998E04B7AA9E0081F0CF4B0@AM4PR05MB3411.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVk5VQk1MQkJCQkhOSk5LSk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PD46KBw*Ojg1Vg0OAhgCATNR
        Lk9PCQNVSlVKTkxPTkJPS0xCSU5CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SU1VSUtNVUlKSVlXWQgBWUFKT0lOSjcG
X-HM-Tid: 0a6e9d1ee54b2086kuqydb3184163e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sorry for miss some information, There is a real remote and the mac always available.  Not just one packets can't be offloaded. ALL the syn packets with repeated can't be offloaded.  But if there is no the last filter rule. All syn packets can be offload

在 2019/11/24 16:46, Paul Blakey 写道:
> Hi,
>
> The syn packet might not be actually offloaded because there isn't a neighbor to resolve the destination mac for the tunnel destination ip (next hop mac).
> Try setting the neighbor via "ip neigh replace dev mlx5_p0 172.168.152.241 lladdr <next hop mac>"
> Or running ping to 172.168.152.241 before adding (or in background) the rule to resolve the mac and make available.
> I'll test it on my end.
>
>
> Thanks,
> Paul.
>
>
>> -----Original Message-----
>> From: wenxu <wenxu@ucloud.cn>
>> Sent: Friday, November 22, 2019 8:26 AM
>> To: Paul Blakey <paulb@mellanox.com>
>> Cc: pablo@netfilter.org; netdev@vger.kernel.org; Mark Bloch
>> <markb@mellanox.com>
>> Subject: Re: Question about flow table offload in mlx5e
>>
>> Hi Paul,
>>
>>
>> There are some update. I also test it through replacing mlx5e_rep_setup_tc
>> _cb with mlx5e_rep_setup_ft_cb
>>
>>
>> ifconfig mlx_p0 172.168.152.75/24 up
>>
>> ip l add dev tun1 type gretap external
>> tc qdisc add dev tun1 ingress
>> tc qdisc add dev mlx_pf0vf0 ingress
>>
>> tc filter add dev mlx_pf0vf0 pref 2 ingress  protocol ip flower skip_sw
>> ip_proto tcp dst_ip 10.0.1.241 src_ip 10.0.0.75 src_port 5002 dst_port 5001
>> tcp_flags 0/0x5  action tunnel_key set dst_ip 172.168.152.241 src_ip 0 id 1000
>> nocsum pipe action mirred egress redirect dev tun1
>>
>> tc filter add dev tun1 pref 2 ingress  protocol ip flower ip_proto tcp src_ip
>> 10.0.1.241 dst_ip 10.0.0.75 src_port 5001 dst_port 5002 tcp_flags 0/0x5
>> enc_key_id 1000 enc_src_ip 172.168.152.241 action tunnel_key unset pipe
>> action mirred egress redirect dev mlx_pf0vf0
>>
>>
>> If you run this script on the host，  and in the virtual machine  run "iperf -c
>> 10.0.1.241  -i 2  -B 10.0.0.75:5002  -t 1000"
>>
>> The tcp syn packet will not be offloaded
>>
>>
>> But if you  only run the script  without the last filter as following , The tcp syn
>> packet will be offloaded.
>>
>> ifconfig mlx_p0 172.168.152.75/24 up
>>
>> ip l add dev tun1 type gretap external
>> tc qdisc add dev tun1 ingress
>> tc qdisc add dev mlx_pf0vf0 ingress
>>
>> tc filter add dev mlx_pf0vf0 pref 2 ingress  protocol ip flower skip_sw
>> ip_proto tcp dst_ip 10.0.1.241 src_ip 10.0.0.75 src_port 5002 dst_port 5001
>> tcp_flags 0/0x5  action tunnel_key set dst_ip 172.168.152.241 src_ip 0 id 1000
>> nocsum pipe action mirred egress redirect dev tun1.
>>
>> I think there are some problem in mlx5e_rep_setup_ft_cb.
>>
>> On 11/21/2019 9:05 PM, Paul Blakey wrote:
>>
>>
>> 	I see, I will test that, and how about normal FWD rules?
>>
>> 	Paul.
>>
>>
>>
>> 		-----Original Message-----
>> 		From: wenxu <wenxu@ucloud.cn>
>> <mailto:wenxu@ucloud.cn>
>> 		Sent: Thursday, November 21, 2019 2:35 PM
>> 		To: Paul Blakey <paulb@mellanox.com>
>> <mailto:paulb@mellanox.com>
>> 		Cc: pablo@netfilter.org <mailto:pablo@netfilter.org> ;
>> netdev@vger.kernel.org <mailto:netdev@vger.kernel.org> ; Mark Bloch
>> 		<markb@mellanox.com> <mailto:markb@mellanox.com>
>> 		Subject: Re: Question about flow table offload in mlx5e
>>
>>
>> 		在 2019/11/21 19:39, Paul Blakey 写道:
>>
>> 			They are good fixes, exactly what we had when we
>> tested this, thanks.
>>
>> 			Regarding encap, I don't know what changes you did,
>> how does the encap
>>
>> 		rule look? Is it a FWD to vxlan device? If not it should be, as
>> our driver
>> 		expects that.
>> 		It is fwd to a gretap devices
>>
>>
>> 			I tried it on my setup via tc, by changing the callback
>> of tc
>>
>> 		(mlx5e_rep_setup_tc_cb) to that of ft
>> (mlx5e_rep_setup_ft_cb),
>>
>> 			and testing a vxlan encap rule:
>> 			sudo tc qdisc add dev ens1f0_0 ingress
>> 			sudo ifconfig ens1f0 7.7.7.7/24 up
>> 			sudo ip link add name vxlan0 type vxlan dev ens1f0
>> remote 7.7.7.8 dstport
>>
>> 		4789 external
>>
>> 			sudo ifconfig vxlan0 up
>> 			sudo tc filter add dev ens1f0_0 ingress prio 1 chain 0
>> protocol ip flower
>>
>> 		dst_mac aa:bb:cc:dd:ee:ff ip_proto udp skip_sw  action
>> tunnel_key set
>> 		src_ip 0.0.0.0 dst_ip 7.7.7.8 id 1234 dst_port 4789 pipe action
>> mirred egress
>> 		redirect dev vxlan
>>
>>
>> 			then tc show:
>> 			filter protocol ip pref 1 flower chain 0 handle 0x1
>> dst_mac aa:bb:cc:dd:ee:ff
>>
>> 		ip_proto udp skip_sw in_hw in_hw_count 1
>>
>> 			        tunnel_key set src_ip 0.0.0.0 dst_ip 7.7.7.8 key_id
>> 1234 dst_port 4789
>>
>> 		csum pipe
>>
>> 			        Stats: used 119 sec      0 pkt
>> 			        mirred (Egress Redirect to device vxlan0)
>> 			        Stats: used 119 sec      0 pkt
>>
>>
>> 		Can you send packet that match this offloaded flow to check
>> it is real
>> 		offloaded?
>>
>> 		In the flowtable offload with my patches both
>> TC_SETUP_BLOCK and
>> 		TC_SETUP_FT can offload the rule success
>>
>> 		But in the TC_SETUP_FT case the packet is not real offloaded.
>>
>>
>> 		I  will test like u did.
>>
>>
>>
>>
>>
>>
>> 				-----Original Message-----
>> 				From: wenxu <wenxu@ucloud.cn>
>> <mailto:wenxu@ucloud.cn>
>> 				Sent: Thursday, November 21, 2019 10:29 AM
>> 				To: Paul Blakey <paulb@mellanox.com>
>> <mailto:paulb@mellanox.com>
>> 				Cc: pablo@netfilter.org
>> <mailto:pablo@netfilter.org> ; netdev@vger.kernel.org
>> <mailto:netdev@vger.kernel.org> ; Mark Bloch
>> 				<markb@mellanox.com>
>> <mailto:markb@mellanox.com>
>> 				Subject: Re: Question about flow table
>> offload in mlx5e
>>
>>
>> 				On 11/21/2019 3:42 PM, Paul Blakey wrote:
>>
>> 					Hi,
>>
>> 					The original design was the block
>> setup to use TC_SETUP_FT type, and
>>
>> 		the
>>
>> 				tc event type to be case
>> TC_SETUP_CLSFLOWER.
>>
>> 					We will post a patch to change that. I
>> would advise to wait till we fix that
>>
>> 				😊
>>
>> 					I'm not sure how you get to this
>> function mlx5e_rep_setup_ft_cb() if it
>>
>> 		the
>>
>> 				nf_flow_table_offload ndo_setup_tc event
>> was TC_SETUP_BLOCK, and
>>
>> 		not
>>
>> 				TC_SETUP_FT.
>>
>>
>> 				Yes I change the TC_SETUP_BLOCK to
>> TC_SETUP_FT in the
>> 				nf_flow_table_offload_setup.
>>
>> 				Two fixes patch provide:
>>
>> 				http://patchwork.ozlabs.org/patch/1197818/
>>
>> 				http://patchwork.ozlabs.org/patch/1197876/
>>
>> 				So this change made by me is not correct
>> currently?
>>
>>
>> 					In our driver en_rep.c we have:
>>
>> 					-------switch (type) {
>> 					-------case TC_SETUP_BLOCK:
>> 					------->-------return
>> flow_block_cb_setup_simple(type_data,
>> 					------->------->------->------->------->---
>> ----
>>
>> 		&mlx5e_rep_block_tc_cb_list,
>>
>> 					------->------->------->------->------->---
>> ----  mlx5e_rep_setup_tc_cb,
>> 					------->------->------->------->------->---
>> ----  priv, priv, true);
>> 					-------case TC_SETUP_FT:
>> 					------->-------return
>> flow_block_cb_setup_simple(type_data,
>> 					------->------->------->------->------->---
>> ----
>>
>> 		&mlx5e_rep_block_ft_cb_list,
>>
>> 					------->------->------->------->------->---
>> ----  mlx5e_rep_setup_ft_cb,
>> 					------->------->------->------->------->---
>> ----  priv, priv, true);
>> 					-------default:
>> 					------->-------return -EOPNOTSUPP;
>> 					-------}
>>
>> 					In nf_flow_table_offload.c:
>>
>> 					-------bo.binder_type>-=
>>
>> 		FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>>
>> 					-------bo.extack>------= &extack;
>> 					-------INIT_LIST_HEAD(&bo.cb_list);
>> 					-------err = dev->netdev_ops-
>>> ndo_setup_tc(dev, TC_SETUP_BLOCK,
>> 				&bo);
>>
>> 					-------if (err < 0)
>> 					------->-------return err;
>> 					-------return
>> nf_flow_table_block_setup(flowtable, &bo, cmd);
>>
>> 					}
>>
>> 	EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
>>
>>
>> 					So unless you changed that as well,
>> you should have gotten to
>>
>> 				mlx5e_rep_setup_tc_cb and not
>> mlx5e_rep_setup_tc_ft.
>>
>> 					Regarding the encap action, there
>> should be no difference on which
>>
>> 		chain
>>
>> 				the rule is on.
>>
>>
>> 				But for the same encap rule can be real
>> offloaded when setup through
>> 				through TC_SETUP_BLOCK. But TC_SETUP_FT
>> can't.
>>
>> 				So it is the problem of TC_SETUP_FT in
>> mlx5e_rep_setup_ft_cb ?
>>
>>
>>
>>
>> 					-----Original Message-----
>> 					From: wenxu <wenxu@ucloud.cn>
>> <mailto:wenxu@ucloud.cn>
>> 					Sent: Thursday, November 21, 2019
>> 9:30 AM
>> 					To: Paul Blakey
>> <paulb@mellanox.com> <mailto:paulb@mellanox.com>
>> 					Cc: pablo@netfilter.org
>> <mailto:pablo@netfilter.org> ; netdev@vger.kernel.org
>> <mailto:netdev@vger.kernel.org> ; Mark Bloch
>> 					<markb@mellanox.com>
>> <mailto:markb@mellanox.com>
>> 					Subject: Question about flow table
>> offload in mlx5e
>>
>> 					Hi  paul,
>>
>> 					The flow table offload in the mlx5e is
>> based on TC_SETUP_FT.
>>
>>
>> 					It is almost the same as
>> TC_SETUP_BLOCK.
>>
>> 					It just set
>> MLX5_TC_FLAG(FT_OFFLOAD) flags and change
>> 					cls_flower.common.chain_index =
>> FDB_FT_CHAIN;
>>
>> 					In following codes line 1380 and 1392
>>
>> 					1368 static int
>> mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void
>> 					*type_data,
>> 					1369                                  void *cb_priv)
>> 					1370 {
>> 					1371         struct flow_cls_offload *f =
>> type_data;
>> 					1372         struct flow_cls_offload
>> cls_flower;
>> 					1373         struct mlx5e_priv *priv =
>> cb_priv;
>> 					1374         struct mlx5_eswitch *esw;
>> 					1375         unsigned long flags;
>> 					1376         int err;
>> 					1377
>> 					1378         flags =
>> MLX5_TC_FLAG(INGRESS) |
>> 					1379
>> MLX5_TC_FLAG(ESW_OFFLOAD) |
>> 					1380
>> MLX5_TC_FLAG(FT_OFFLOAD);
>> 					1381         esw = priv->mdev-
>>> priv.eswitch;
>> 					1382
>> 					1383         switch (type) {
>> 					1384         case
>> TC_SETUP_CLSFLOWER:
>> 					1385                 if
>> (!mlx5_eswitch_prios_supported(esw) || f-
>>
>> 					common.chain_index)
>>
>> 					1386                         return -
>> EOPNOTSUPP;
>> 					1387
>> 					1388                 /* Re-use tc offload
>> path by moving the ft flow to the
>> 					1389                  * reserved ft chain.
>> 					1390                  */
>> 					1391                 memcpy(&cls_flower, f,
>> sizeof(*f));
>> 					1392
>> cls_flower.common.chain_index = FDB_FT_CHAIN;
>> 					1393                 err =
>> mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower,
>>
>> 				flags);
>>
>> 					1394                 memcpy(&f->stats,
>> &cls_flower.stats, sizeof(f->stats));
>>
>>
>> 					I want to add tunnel offload support
>> in the flow table, I  add some
>>
>> 		patches
>>
>> 				in
>>
>> 					nf_flow_table_offload.
>>
>> 					Also add the indr setup support in the
>> mlx driver. And Now I can  flow
>>
>> 				table
>>
>> 					offload with decap.
>>
>>
>> 					But I meet a problem with the encap.
>> The encap rule can be added in
>> 					hardware  successfully But it can't be
>> offloaded.
>>
>> 					But I think the rule I added is correct.
>> If I mask the line 1392. The rule
>>
>> 		also
>>
>> 				can
>>
>> 					be add success and can be offloaded.
>>
>> 					So there are some limit for encap
>> operation for FT_OFFLOAD in
>> 					FDB_FT_CHAIN?
>>
>>
>> 					BR
>>
>> 					wenxu
>>
