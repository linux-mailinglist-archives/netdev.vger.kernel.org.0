Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF510E4E3
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 04:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLBDhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 22:37:11 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5526 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfLBDhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 22:37:11 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7E7DB41D2B;
        Mon,  2 Dec 2019 11:37:07 +0800 (CST)
Subject: Re: Question about flow table offload in mlx5e
From:   wenxu <wenxu@ucloud.cn>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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
 <1b13e159-1030-2ea3-f69e-578041504ee6@ucloud.cn>
 <84874b42-c525-2149-539d-e7510d15f6a6@mellanox.com>
 <dc72770c-8bc3-d302-be73-f19f9bbe269f@ucloud.cn>
 <057b0ab1-5ce3-61f0-a59e-1c316e414c84@mellanox.com>
 <4ecddff0-5ba4-51f7-1544-3d76d43b6b39@mellanox.com>
 <5ce27064-97ee-a36d-8f20-10a0afe739cf@ucloud.cn>
Message-ID: <c06ff5a3-e099-9476-7085-1cd72a9ffc56@ucloud.cn>
Date:   Mon, 2 Dec 2019 11:37:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5ce27064-97ee-a36d-8f20-10a0afe739cf@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENNS0tLSk5NT0tJTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NSI6LRw5SDgyNQEYChQcM0wP
        ATIKCiNVSlVKTkxOSU5MQ0lMTUxLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTUhDSzcG
X-HM-Tid: 0a6ec4aee8fc2086kuqy7e7db41d2b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,


Sorry for trouble you again. I think it is a problem in ft callback.

Can your help me fix it. Thx!

I did the test like you with route tc rules to ft callback.

# ifconfig mlx_p0 172.168.152.75/24 up
# ip n r 172.16.152.241 lladdr fa:fa:ff:ff:ff:ff dev mlx_p0

# ip l add dev tun1 type gretap external
# tc qdisc add dev tun1 ingress
# tc qdisc add dev mlx_pf0vf0 ingress

# tc filter add dev mlx_pf0vf0 pref 2 ingress  protocol ip flower skip_sw  action tunnel_key set dst_ip 172.168.152.241 src_ip 0 id 1000 nocsum pipe action mirred egress redirect dev tun1


In The vm:
# ifconfig eth0 10.0.0.75/24 up
# ip n r 10.0.0.77 lladdr fa:ff:ff:ff:ff:ff dev eth0

# iperf -c 10.0.0.77 -t 100 -i 2

The syn packets can be offloaded successfully.

# # tc -s filter ls dev mlx_pf0vf0 ingress
filter protocol ip pref 2 flower chain 0 
filter protocol ip pref 2 flower chain 0 handle 0x1 
  eth_type ipv4
  skip_sw
  in_hw in_hw_count 1
	action order 1: tunnel_key  set
	src_ip 0.0.0.0
	dst_ip 172.168.152.241
	key_id 1000
	nocsum pipe
	 index 1 ref 1 bind 1 installed 252 sec used 252 sec
	Action statistics:
	Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
	backlog 0b 0p requeues 0

	action order 2: mirred (Egress Redirect to device tun1) stolen
 	index 1 ref 1 bind 1 installed 252 sec used 110 sec
 	Action statistics:
	Sent 3420 bytes 11 pkt (dropped 0, overlimits 0 requeues 0) 
	Sent software 0 bytes 0 pkt
	Sent hardware 3420 bytes 11 pkt
	backlog 0b 0p requeues 0

But Then I add another decap filter on tun1:

tc filter add dev tun1 pref 2 ingress protocol ip flower enc_key_id 1000 enc_src_ip 172.168.152.241 action tunnel_key unset pipe action mirred egress redirect dev mlx_pf0vf0

# iperf -c 10.0.0.77 -t 100 -i 2

The syn packets can't be offloaded. The tc filter counter is also not increase.


# tc -s filter ls dev mlx_pf0vf0 ingress
filter protocol ip pref 2 flower chain 0 
filter protocol ip pref 2 flower chain 0 handle 0x1 
  eth_type ipv4
  skip_sw
  in_hw in_hw_count 1
	action order 1: tunnel_key  set
	src_ip 0.0.0.0
	dst_ip 172.168.152.241
	key_id 1000
	nocsum pipe
	 index 1 ref 1 bind 1 installed 320 sec used 320 sec
	Action statistics:
	Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
	backlog 0b 0p requeues 0

	action order 2: mirred (Egress Redirect to device tun1) stolen
 	index 1 ref 1 bind 1 installed 320 sec used 178 sec
 	Action statistics:
	Sent 3420 bytes 11 pkt (dropped 0, overlimits 0 requeues 0) 
	Sent software 0 bytes 0 pkt
	Sent hardware 3420 bytes 11 pkt
	backlog 0b 0p requeues 0

# tc -s filter ls dev tun1 ingress
filter protocol ip pref 2 flower chain 0 
filter protocol ip pref 2 flower chain 0 handle 0x1 
  eth_type ipv4
  enc_src_ip 172.168.152.241
  enc_key_id 1000
  in_hw in_hw_count 1
	action order 1: tunnel_key  unset pipe
	 index 2 ref 1 bind 1 installed 391 sec used 391 sec
	Action statistics:
	Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
	backlog 0b 0p requeues 0

	action order 2: mirred (Egress Redirect to device mlx_pf0vf0) stolen
 	index 2 ref 1 bind 1 installed 391 sec used 391 sec
 	Action statistics:
	Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
	backlog 0b 0p requeues 0


So there maybe some problem for ft callback setup. When there is another reverse
decap rule add in tunnel device, The encap rule will not offloaded the packets.

Expect your help Thx!


BR
wenxu








