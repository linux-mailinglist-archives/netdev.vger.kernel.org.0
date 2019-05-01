Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E098310857
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEANiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:38:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65390 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfEANiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:38:16 -0400
Received: from fsav105.sakura.ne.jp (fsav105.sakura.ne.jp [27.133.134.232])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x41Dc8sd054344;
        Wed, 1 May 2019 22:38:08 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav105.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav105.sakura.ne.jp);
 Wed, 01 May 2019 22:38:08 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav105.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x41Dc3fD054316
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 1 May 2019 22:38:07 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Julian Anastasov <ja@ssi.bg>, Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
Date:   Wed, 1 May 2019 22:38:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/04/30 3:43, David Ahern wrote:
>> The attached patch adds a tracepoint to notifier_call_chain. If you have
>> KALLSYMS enabled it will show the order of the function handlers:
>>
>> perf record -e notifier:* -a -g &
>>
>> ip netns del <NAME>
>> <wait a few seconds>
>>
>> fg
>> <ctrl-c on perf-record>
>>
>> perf script
>>
> 
> with the header file this time.
> 

What is the intent of your patch? I can see that many notifiers are called. But
how does this help identify which event is responsible for dropping the refcount?

a.out  6898 [003]    54.809503: notifier:notifier_call_chain: val 17 fcn ffffffff822de9b0 name ip_vs_dst_event
a.out  6898 [003]    54.809512: notifier:notifier_call_chain: val 17 fcn ffffffff821a1060 name rtnetlink_event
a.out  6898 [003]    54.809516: notifier:notifier_call_chain: val 17 fcn ffffffff812c8830 name dev_map_notification
a.out  6898 [003]    54.809520: notifier:notifier_call_chain: val 17 fcn ffffffff81f89a00 name netdevice_event
a.out  6898 [003]    54.809523: notifier:notifier_call_chain: val 17 fcn ffffffff821b8c70 name fib_rules_event
a.out  6898 [003]    54.809525: notifier:notifier_call_chain: val 17 fcn ffffffff821c11e0 name netprio_device_event
a.out  6898 [003]    54.809530: notifier:notifier_call_chain: val 17 fcn ffffffff826012b0 name wext_netdev_notifier_call
a.out  6898 [003]    54.809533: notifier:notifier_call_chain: val 17 fcn ffffffff8261b980 name netdev_notify
a.out  6898 [003]    54.809536: notifier:notifier_call_chain: val 17 fcn ffffffff826a4e10 name netlbl_unlhsh_netdev_handler
a.out  6898 [003]    54.809538: notifier:notifier_call_chain: val 17 fcn ffffffff826d5900 name cfg802154_netdev_notifier_call
a.out  6898 [003]    54.809542: notifier:notifier_call_chain: val 17 fcn ffffffff826e1fa0 name netdev_notify
a.out  6898 [003]    54.809546: notifier:notifier_call_chain: val 17 fcn ffffffff82331910 name arp_netdev_event
a.out  6898 [003]    54.809548: notifier:notifier_call_chain: val 17 fcn ffffffff823389c0 name inetdev_event
a.out  6898 [003]    54.809551: notifier:notifier_call_chain: val 17 fcn ffffffff82343370 name fib_netdev_event
a.out  6898 [003]    54.809555: notifier:notifier_call_chain: val 17 fcn ffffffff82399140 name xfrm_dev_event
a.out  6898 [003]    54.809557: notifier:notifier_call_chain: val 17 fcn ffffffff8233dec0 name igmp_netdev_event
a.out  6898 [003]    54.809560: notifier:notifier_call_chain: val 17 fcn ffffffff82353c00 name ipmr_device_event
a.out  6898 [003]    54.809564: notifier:notifier_call_chain: val 17 fcn ffffffff825a9440 name cfg80211_netdev_notifier_call
a.out  6898 [003]    54.809569: notifier:notifier_call_chain: val 17 fcn ffffffff8168a060 name sel_netif_netdev_notifier_handler
a.out  6898 [003]    54.809573: notifier:notifier_call_chain: val 17 fcn ffffffff81baec70 name bond_netdev_event
a.out  6898 [003]    54.809576: notifier:notifier_call_chain: val 17 fcn ffffffff81bbb230 name ipvlan_device_event
a.out  6898 [003]    54.809579: notifier:notifier_call_chain: val 17 fcn ffffffff81bbc890 name ipvtap_device_event
a.out  6898 [003]    54.809581: notifier:notifier_call_chain: val 17 fcn ffffffff81bbe550 name macsec_notify
a.out  6898 [003]    54.809583: notifier:notifier_call_chain: val 17 fcn ffffffff81bc4240 name macvlan_device_event
a.out  6898 [003]    54.809585: notifier:notifier_call_chain: val 17 fcn ffffffff81bc56a0 name macvtap_device_event
a.out  6898 [003]    54.809589: notifier:notifier_call_chain: val 17 fcn ffffffff81bd3370 name team_device_event
a.out  6898 [003]    54.809591: notifier:notifier_call_chain: val 17 fcn ffffffff81bdb890 name tun_device_event
a.out  6898 [003]    54.809593: notifier:notifier_call_chain: val 17 fcn ffffffff81bf5bf0 name vrf_device_event
a.out  6898 [003]    54.809596: notifier:notifier_call_chain: val 17 fcn ffffffff81c8cb80 name bpq_device_event
a.out  6898 [003]    54.809599: notifier:notifier_call_chain: val 17 fcn ffffffff81c96e40 name pppoe_device_event
a.out  6898 [003]    54.809601: notifier:notifier_call_chain: val 17 fcn ffffffff81c9b380 name hdlc_device_event
a.out  6898 [003]    54.809603: notifier:notifier_call_chain: val 17 fcn ffffffff81ca06a0 name dlci_dev_event
a.out  6898 [003]    54.809605: notifier:notifier_call_chain: val 17 fcn ffffffff81ca12c0 name lapbeth_device_event
a.out  6898 [003]    54.809608: notifier:notifier_call_chain: val 17 fcn ffffffff81fa90f0 name cma_netdev_callback
a.out  6898 [003]    54.809611: notifier:notifier_call_chain: val 17 fcn ffffffff81fee6a0 name ipoib_netdev_event
a.out  6898 [003]    54.809613: notifier:notifier_call_chain: val 17 fcn ffffffff821c0e20 name dropmon_net_event
a.out  6898 [003]    54.809615: notifier:notifier_call_chain: val 17 fcn ffffffff821c5d80 name failover_event
a.out  6898 [003]    54.809618: notifier:notifier_call_chain: val 17 fcn ffffffff821e3a60 name mirred_device_event
a.out  6898 [003]    54.809620: notifier:notifier_call_chain: val 17 fcn ffffffff8223a930 name nfqnl_rcv_dev_event
a.out  6898 [003]    54.809623: notifier:notifier_call_chain: val 17 fcn ffffffff82273bd0 name nf_tables_netdev_event
a.out  6898 [003]    54.809625: notifier:notifier_call_chain: val 17 fcn ffffffff822667c0 name nf_tables_flowtable_event
a.out  6898 [003]    54.809628: notifier:notifier_call_chain: val 17 fcn ffffffff8227ef40 name flow_offload_netdev_event
a.out  6898 [003]    54.809630: notifier:notifier_call_chain: val 17 fcn ffffffff82260e40 name masq_device_event
a.out  6898 [003]    54.809632: notifier:notifier_call_chain: val 17 fcn ffffffff82290560 name tee_netdev_event
a.out  6898 [003]    54.809635: notifier:notifier_call_chain: val 17 fcn ffffffff8236dcd0 name clusterip_netdev_event
a.out  6898 [003]    54.809637: notifier:notifier_call_chain: val 17 fcn ffffffff82385210 name tls_dev_event
a.out  6898 [003]    54.809641: notifier:notifier_call_chain: val 17 fcn ffffffff823e99b0 name ip6mr_device_event
a.out  6898 [003]    54.809644: notifier:notifier_call_chain: val 17 fcn ffffffff823b9300 name addrconf_notify
a.out  6898 [003]    54.809647: notifier:notifier_call_chain: val 17 fcn ffffffff823d9200 name ipv6_mc_netdev_event
a.out  6898 [003]    54.809650: notifier:notifier_call_chain: val 17 fcn ffffffff82419160 name packet_notifier
a.out  6898 [003]    54.809653: notifier:notifier_call_chain: val 17 fcn ffffffff824255f0 name br_device_event
a.out  6898 [003]    54.809656: notifier:notifier_call_chain: val 17 fcn ffffffff8243e6e0 name brnf_device_event
a.out  6898 [003]    54.809658: notifier:notifier_call_chain: val 17 fcn ffffffff8244c220 name dsa_slave_netdevice_event
a.out  6898 [003]    54.809660: notifier:notifier_call_chain: val 17 fcn ffffffff8244df10 name x25_device_event
a.out  6898 [003]    54.809662: notifier:notifier_call_chain: val 17 fcn ffffffff824562a0 name nr_device_event
a.out  6898 [003]    54.809665: notifier:notifier_call_chain: val 17 fcn ffffffff8245bd20 name rose_device_event
a.out  6898 [003]    54.809667: notifier:notifier_call_chain: val 17 fcn ffffffff82466e40 name ax25_device_event
a.out  6898 [003]    54.809669: notifier:notifier_call_chain: val 17 fcn ffffffff8246b8a0 name can_notifier
a.out  6898 [003]    54.809672: notifier:notifier_call_chain: val 17 fcn ffffffff82470860 name cgw_notifier
a.out  6898 [003]    54.809674: notifier:notifier_call_chain: val 17 fcn ffffffff824c08b0 name device_event
a.out  6898 [003]    54.809677: notifier:notifier_call_chain: val 17 fcn ffffffff825355a0 name clip_device_event
a.out  6898 [003]    54.809680: notifier:notifier_call_chain: val 17 fcn ffffffff825481c0 name vlan_device_event
a.out  6898 [003]    54.809682: notifier:notifier_call_chain: val 17 fcn ffffffff8267bde0 name tipc_l2_device_event
a.out  6898 [003]    54.809684: notifier:notifier_call_chain: val 17 fcn ffffffff826ab0e0 name smc_pnet_netdev_event
a.out  6898 [003]    54.809687: notifier:notifier_call_chain: val 17 fcn ffffffff826c3220 name caif_device_notify
a.out  6898 [003]    54.809689: notifier:notifier_call_chain: val 17 fcn ffffffff826cb4b0 name cfusbl_device_notify
a.out  6898 [003]    54.809691: notifier:notifier_call_chain: val 17 fcn ffffffff826cf280 name lowpan_event
a.out  6898 [003]    54.809694: notifier:notifier_call_chain: val 17 fcn ffffffff826def50 name lowpan_device_event
a.out  6898 [003]    54.809696: notifier:notifier_call_chain: val 17 fcn ffffffff827178d0 name batadv_hard_if_event
a.out  6898 [003]    54.809700: notifier:notifier_call_chain: val 17 fcn ffffffff8274a0c0 name dp_device_event
a.out  6898 [003]    54.809704: notifier:notifier_call_chain: val 17 fcn ffffffff827631d0 name mpls_dev_notify
a.out  6898 [003]    54.809706: notifier:notifier_call_chain: val 17 fcn ffffffff82765180 name hsr_netdev_notify
a.out  6898 [003]    54.809708: notifier:notifier_call_chain: val 17 fcn ffffffff81bc6cc0 name netconsole_netdev_event
a.out  6898 [003]    54.809711: notifier:notifier_call_chain: val 17 fcn ffffffff81bec840 name vxlan_netdevice_event
a.out  6898 [003]    54.809713: notifier:notifier_call_chain: val 17 fcn ffffffff81bf0c60 name geneve_netdevice_event
a.out  6898 [003]    54.809717: notifier:notifier_call_chain: val 17 fcn ffffffff82025700 name rxe_notify
a.out  6898 [003]    54.809719: notifier:notifier_call_chain: val 17 fcn ffffffff823cc0d0 name ndisc_netdev_event
a.out  6898 [003]    54.809722: notifier:notifier_call_chain: val 17 fcn ffffffff823bde70 name ip6_route_dev_notify
a.out  6898 [003]    54.809803: notifier:notifier_call_chain: val 5 fcn ffffffff822de9b0 name ip_vs_dst_event
a.out  6898 [003]    54.809805: notifier:notifier_call_chain: val 5 fcn ffffffff821a1060 name rtnetlink_event
a.out  6898 [003]    54.809807: notifier:notifier_call_chain: val 5 fcn ffffffff812c8830 name dev_map_notification
a.out  6898 [003]    54.809810: notifier:notifier_call_chain: val 5 fcn ffffffff81f89a00 name netdevice_event
a.out  6898 [003]    54.809812: notifier:notifier_call_chain: val 5 fcn ffffffff821b8c70 name fib_rules_event
a.out  6898 [003]    54.809815: notifier:notifier_call_chain: val 5 fcn ffffffff821c11e0 name netprio_device_event
a.out  6898 [003]    54.809817: notifier:notifier_call_chain: val 5 fcn ffffffff826012b0 name wext_netdev_notifier_call
a.out  6898 [003]    54.809819: notifier:notifier_call_chain: val 5 fcn ffffffff8261b980 name netdev_notify
a.out  6898 [003]    54.809821: notifier:notifier_call_chain: val 5 fcn ffffffff826a4e10 name netlbl_unlhsh_netdev_handler
a.out  6898 [003]    54.809823: notifier:notifier_call_chain: val 5 fcn ffffffff826d5900 name cfg802154_netdev_notifier_call
a.out  6898 [003]    54.809825: notifier:notifier_call_chain: val 5 fcn ffffffff826e1fa0 name netdev_notify
a.out  6898 [003]    54.809828: notifier:notifier_call_chain: val 5 fcn ffffffff82331910 name arp_netdev_event
a.out  6898 [003]    54.809829: notifier:notifier_call_chain: val 5 fcn ffffffff823389c0 name inetdev_event
a.out  6898 [003]    54.809851: notifier:notifier_call_chain: val 5 fcn ffffffff82343370 name fib_netdev_event
a.out  6898 [003]    54.809854: notifier:notifier_call_chain: val 5 fcn ffffffff82399140 name xfrm_dev_event
a.out  6898 [003]    54.809856: notifier:notifier_call_chain: val 5 fcn ffffffff8233dec0 name igmp_netdev_event
a.out  6898 [003]    54.809858: notifier:notifier_call_chain: val 5 fcn ffffffff82353c00 name ipmr_device_event
a.out  6898 [003]    54.809860: notifier:notifier_call_chain: val 5 fcn ffffffff825a9440 name cfg80211_netdev_notifier_call
a.out  6898 [003]    54.809863: notifier:notifier_call_chain: val 5 fcn ffffffff8168a060 name sel_netif_netdev_notifier_handler
a.out  6898 [003]    54.809866: notifier:notifier_call_chain: val 5 fcn ffffffff81baec70 name bond_netdev_event
a.out  6898 [003]    54.809868: notifier:notifier_call_chain: val 5 fcn ffffffff81bbb230 name ipvlan_device_event
a.out  6898 [003]    54.809870: notifier:notifier_call_chain: val 5 fcn ffffffff81bbc890 name ipvtap_device_event
a.out  6898 [003]    54.809872: notifier:notifier_call_chain: val 5 fcn ffffffff81bbe550 name macsec_notify
a.out  6898 [003]    54.809874: notifier:notifier_call_chain: val 5 fcn ffffffff81bc4240 name macvlan_device_event
a.out  6898 [003]    54.809875: notifier:notifier_call_chain: val 5 fcn ffffffff81bc56a0 name macvtap_device_event
a.out  6898 [003]    54.809878: notifier:notifier_call_chain: val 5 fcn ffffffff81bd3370 name team_device_event
a.out  6898 [003]    54.809880: notifier:notifier_call_chain: val 5 fcn ffffffff81bdb890 name tun_device_event
a.out  6898 [003]    54.809882: notifier:notifier_call_chain: val 5 fcn ffffffff81bf5bf0 name vrf_device_event
a.out  6898 [003]    54.809884: notifier:notifier_call_chain: val 5 fcn ffffffff81c8cb80 name bpq_device_event
a.out  6898 [003]    54.809886: notifier:notifier_call_chain: val 5 fcn ffffffff81c96e40 name pppoe_device_event
a.out  6898 [003]    54.809888: notifier:notifier_call_chain: val 5 fcn ffffffff81c9b380 name hdlc_device_event
a.out  6898 [003]    54.809890: notifier:notifier_call_chain: val 5 fcn ffffffff81ca06a0 name dlci_dev_event
a.out  6898 [003]    54.809892: notifier:notifier_call_chain: val 5 fcn ffffffff81ca12c0 name lapbeth_device_event
a.out  6898 [003]    54.809894: notifier:notifier_call_chain: val 5 fcn ffffffff81fa90f0 name cma_netdev_callback
a.out  6898 [003]    54.809896: notifier:notifier_call_chain: val 5 fcn ffffffff81fee6a0 name ipoib_netdev_event
a.out  6898 [003]    54.809898: notifier:notifier_call_chain: val 5 fcn ffffffff821c0e20 name dropmon_net_event
a.out  6898 [003]    54.809900: notifier:notifier_call_chain: val 5 fcn ffffffff821c5d80 name failover_event
a.out  6898 [003]    54.809902: notifier:notifier_call_chain: val 5 fcn ffffffff821e3a60 name mirred_device_event
a.out  6898 [003]    54.809904: notifier:notifier_call_chain: val 5 fcn ffffffff8223a930 name nfqnl_rcv_dev_event
a.out  6898 [003]    54.809906: notifier:notifier_call_chain: val 5 fcn ffffffff82273bd0 name nf_tables_netdev_event
a.out  6898 [003]    54.809908: notifier:notifier_call_chain: val 5 fcn ffffffff822667c0 name nf_tables_flowtable_event
a.out  6898 [003]    54.809911: notifier:notifier_call_chain: val 5 fcn ffffffff8227ef40 name flow_offload_netdev_event
a.out  6898 [003]    54.809913: notifier:notifier_call_chain: val 5 fcn ffffffff82260e40 name masq_device_event
a.out  6898 [003]    54.809914: notifier:notifier_call_chain: val 5 fcn ffffffff82290560 name tee_netdev_event
a.out  6898 [003]    54.809917: notifier:notifier_call_chain: val 5 fcn ffffffff8236dcd0 name clusterip_netdev_event
a.out  6898 [003]    54.809919: notifier:notifier_call_chain: val 5 fcn ffffffff82385210 name tls_dev_event
a.out  6898 [003]    54.809921: notifier:notifier_call_chain: val 5 fcn ffffffff823e99b0 name ip6mr_device_event
a.out  6898 [003]    54.809923: notifier:notifier_call_chain: val 5 fcn ffffffff823b9300 name addrconf_notify
a.out  6898 [003]    54.809956: notifier:notifier_call_chain: val 5 fcn ffffffff823d9200 name ipv6_mc_netdev_event
a.out  6898 [003]    54.809959: notifier:notifier_call_chain: val 5 fcn ffffffff82419160 name packet_notifier
a.out  6898 [003]    54.809961: notifier:notifier_call_chain: val 5 fcn ffffffff824255f0 name br_device_event
a.out  6898 [003]    54.809964: notifier:notifier_call_chain: val 5 fcn ffffffff8243e6e0 name brnf_device_event
a.out  6898 [003]    54.809966: notifier:notifier_call_chain: val 5 fcn ffffffff8244c220 name dsa_slave_netdevice_event
a.out  6898 [003]    54.809968: notifier:notifier_call_chain: val 5 fcn ffffffff8244df10 name x25_device_event
a.out  6898 [003]    54.809970: notifier:notifier_call_chain: val 5 fcn ffffffff824562a0 name nr_device_event
a.out  6898 [003]    54.809972: notifier:notifier_call_chain: val 5 fcn ffffffff8245bd20 name rose_device_event
a.out  6898 [003]    54.809974: notifier:notifier_call_chain: val 5 fcn ffffffff82466e40 name ax25_device_event
a.out  6898 [003]    54.809976: notifier:notifier_call_chain: val 5 fcn ffffffff8246b8a0 name can_notifier
a.out  6898 [003]    54.809978: notifier:notifier_call_chain: val 5 fcn ffffffff82470860 name cgw_notifier
a.out  6898 [003]    54.809980: notifier:notifier_call_chain: val 5 fcn ffffffff824c08b0 name device_event
a.out  6898 [003]    54.809982: notifier:notifier_call_chain: val 5 fcn ffffffff825355a0 name clip_device_event
a.out  6898 [003]    54.809984: notifier:notifier_call_chain: val 5 fcn ffffffff825481c0 name vlan_device_event
a.out  6898 [003]    54.809986: notifier:notifier_call_chain: val 5 fcn ffffffff8267bde0 name tipc_l2_device_event
a.out  6898 [003]    54.809988: notifier:notifier_call_chain: val 5 fcn ffffffff826ab0e0 name smc_pnet_netdev_event
a.out  6898 [003]    54.809991: notifier:notifier_call_chain: val 5 fcn ffffffff826c3220 name caif_device_notify
a.out  6898 [003]    54.809993: notifier:notifier_call_chain: val 5 fcn ffffffff826cb4b0 name cfusbl_device_notify
a.out  6898 [003]    54.809995: notifier:notifier_call_chain: val 5 fcn ffffffff826cf280 name lowpan_event
a.out  6898 [003]    54.809997: notifier:notifier_call_chain: val 5 fcn ffffffff826def50 name lowpan_device_event
a.out  6898 [003]    54.809999: notifier:notifier_call_chain: val 5 fcn ffffffff827178d0 name batadv_hard_if_event
a.out  6898 [003]    54.810001: notifier:notifier_call_chain: val 5 fcn ffffffff8274a0c0 name dp_device_event
a.out  6898 [003]    54.810003: notifier:notifier_call_chain: val 5 fcn ffffffff827631d0 name mpls_dev_notify
a.out  6898 [003]    54.810012: notifier:notifier_call_chain: val 5 fcn ffffffff82765180 name hsr_netdev_notify
a.out  6898 [003]    54.810014: notifier:notifier_call_chain: val 5 fcn ffffffff81bc6cc0 name netconsole_netdev_event
a.out  6898 [003]    54.810017: notifier:notifier_call_chain: val 5 fcn ffffffff81bec840 name vxlan_netdevice_event
a.out  6898 [003]    54.810020: notifier:notifier_call_chain: val 5 fcn ffffffff81bf0c60 name geneve_netdevice_event
a.out  6898 [003]    54.810022: notifier:notifier_call_chain: val 5 fcn ffffffff82025700 name rxe_notify
a.out  6898 [003]    54.810024: notifier:notifier_call_chain: val 5 fcn ffffffff823cc0d0 name ndisc_netdev_event
a.out  6898 [003]    54.810027: notifier:notifier_call_chain: val 5 fcn ffffffff823bde70 name ip6_route_dev_notify
(...snipped...)
a.out 17698 [002]    76.174214: notifier:notifier_call_chain: val 6 fcn ffffffff824c08b0 name device_event
a.out 17698 [002]    76.174215: notifier:notifier_call_chain: val 6 fcn ffffffff825355a0 name clip_device_event
a.out 17698 [002]    76.174217: notifier:notifier_call_chain: val 6 fcn ffffffff825481c0 name vlan_device_event
a.out 17698 [002]    76.174219: notifier:notifier_call_chain: val 6 fcn ffffffff8267bde0 name tipc_l2_device_event
a.out 17698 [002]    76.174221: notifier:notifier_call_chain: val 6 fcn ffffffff826ab0e0 name smc_pnet_netdev_event
a.out 17698 [002]    76.174224: notifier:notifier_call_chain: val 6 fcn ffffffff826c3220 name caif_device_notify
a.out 17698 [002]    76.174226: notifier:notifier_call_chain: val 6 fcn ffffffff826cb4b0 name cfusbl_device_notify
a.out 17698 [002]    76.174227: notifier:notifier_call_chain: val 6 fcn ffffffff826cf280 name lowpan_event
a.out 17698 [002]    76.174229: notifier:notifier_call_chain: val 6 fcn ffffffff826def50 name lowpan_device_event
a.out 17698 [002]    76.174231: notifier:notifier_call_chain: val 6 fcn ffffffff827178d0 name batadv_hard_if_event
a.out 17698 [002]    76.174257: notifier:notifier_call_chain: val 6 fcn ffffffff8274a0c0 name dp_device_event
a.out 17698 [002]    76.174259: notifier:notifier_call_chain: val 6 fcn ffffffff827631d0 name mpls_dev_notify
a.out 17698 [002]    76.174264: notifier:notifier_call_chain: val 6 fcn ffffffff82765180 name hsr_netdev_notify
a.out 17698 [002]    76.174266: notifier:notifier_call_chain: val 6 fcn ffffffff81bc6cc0 name netconsole_netdev_event
a.out 17698 [002]    76.174268: notifier:notifier_call_chain: val 6 fcn ffffffff81bec840 name vxlan_netdevice_event
a.out 17698 [002]    76.174270: notifier:notifier_call_chain: val 6 fcn ffffffff81bf0c60 name geneve_netdevice_event
a.out 17698 [002]    76.174273: notifier:notifier_call_chain: val 6 fcn ffffffff82025700 name rxe_notify
a.out 17698 [002]    76.174274: notifier:notifier_call_chain: val 6 fcn ffffffff823cc0d0 name ndisc_netdev_event
a.out 17698 [002]    76.174276: notifier:notifier_call_chain: val 6 fcn ffffffff823bde70 name ip6_route_dev_notify
kworker/u128:32  4366 [001]    76.297089: notifier:notifier_call_chain: val 6 fcn ffffffff822de9b0 name ip_vs_dst_event
kworker/u128:32  4366 [001]    76.297095: notifier:notifier_call_chain: val 6 fcn ffffffff821a1060 name rtnetlink_event
kworker/u128:32  4366 [001]    76.297098: notifier:notifier_call_chain: val 6 fcn ffffffff812c8830 name dev_map_notification
kworker/u128:32  4366 [001]    76.297101: notifier:notifier_call_chain: val 6 fcn ffffffff81f89a00 name netdevice_event
kworker/u128:32  4366 [001]    76.297104: notifier:notifier_call_chain: val 6 fcn ffffffff821b8c70 name fib_rules_event
kworker/u128:32  4366 [001]    76.297107: notifier:notifier_call_chain: val 6 fcn ffffffff821c11e0 name netprio_device_event
kworker/u128:32  4366 [001]    76.297111: notifier:notifier_call_chain: val 6 fcn ffffffff826012b0 name wext_netdev_notifier_call
kworker/u128:32  4366 [001]    76.297115: notifier:notifier_call_chain: val 6 fcn ffffffff8261b980 name netdev_notify
kworker/u128:32  4366 [001]    76.297117: notifier:notifier_call_chain: val 6 fcn ffffffff826a4e10 name netlbl_unlhsh_netdev_handler
kworker/u128:32  4366 [001]    76.297119: notifier:notifier_call_chain: val 6 fcn ffffffff826d5900 name cfg802154_netdev_notifier_call
kworker/u128:32  4366 [001]    76.297123: notifier:notifier_call_chain: val 6 fcn ffffffff826e1fa0 name netdev_notify
kworker/u128:32  4366 [001]    76.297126: notifier:notifier_call_chain: val 6 fcn ffffffff82331910 name arp_netdev_event
kworker/u128:32  4366 [001]    76.297128: notifier:notifier_call_chain: val 6 fcn ffffffff823389c0 name inetdev_event
kworker/u128:32  4366 [001]    76.297146: notifier:notifier_call_chain: val 6 fcn ffffffff82343370 name fib_netdev_event
kworker/u128:32  4366 [001]    76.297221: notifier:notifier_call_chain: val 6 fcn ffffffff82399140 name xfrm_dev_event
(...snipped...)
kworker/u128:32  4366 [002]    86.837244: notifier:notifier_call_chain: val 6 fcn ffffffff822de9b0 name ip_vs_dst_event
kworker/u128:32  4366 [002]    86.837260: notifier:notifier_call_chain: val 6 fcn ffffffff821a1060 name rtnetlink_event
kworker/u128:32  4366 [002]    86.837269: notifier:notifier_call_chain: val 6 fcn ffffffff812c8830 name dev_map_notification
kworker/u128:32  4366 [002]    86.837278: notifier:notifier_call_chain: val 6 fcn ffffffff81f89a00 name netdevice_event
kworker/u128:32  4366 [002]    86.837284: notifier:notifier_call_chain: val 6 fcn ffffffff821b8c70 name fib_rules_event
kworker/u128:32  4366 [002]    86.837293: notifier:notifier_call_chain: val 6 fcn ffffffff821c11e0 name netprio_device_event
kworker/u128:32  4366 [002]    86.837305: notifier:notifier_call_chain: val 6 fcn ffffffff826012b0 name wext_netdev_notifier_call
kworker/u128:32  4366 [002]    86.837315: notifier:notifier_call_chain: val 6 fcn ffffffff8261b980 name netdev_notify
kworker/u128:32  4366 [002]    86.837321: notifier:notifier_call_chain: val 6 fcn ffffffff826a4e10 name netlbl_unlhsh_netdev_handler
kworker/u128:32  4366 [002]    86.837327: notifier:notifier_call_chain: val 6 fcn ffffffff826d5900 name cfg802154_netdev_notifier_call
kworker/u128:32  4366 [002]    86.837335: notifier:notifier_call_chain: val 6 fcn ffffffff826e1fa0 name netdev_notify
kworker/u128:32  4366 [002]    86.837344: notifier:notifier_call_chain: val 6 fcn ffffffff82331910 name arp_netdev_event
kworker/u128:32  4366 [002]    86.837348: notifier:notifier_call_chain: val 6 fcn ffffffff823389c0 name inetdev_event
kworker/u128:32  4366 [002]    86.837355: notifier:notifier_call_chain: val 6 fcn ffffffff82343370 name fib_netdev_event
kworker/u128:32  4366 [002]    86.837736: notifier:notifier_call_chain: val 6 fcn ffffffff82399140 name xfrm_dev_event
kworker/u128:32  4366 [002]    86.837743: notifier:notifier_call_chain: val 6 fcn ffffffff8233dec0 name igmp_netdev_event
kworker/u128:32  4366 [002]    86.837750: notifier:notifier_call_chain: val 6 fcn ffffffff82353c00 name ipmr_device_event
kworker/u128:32  4366 [002]    86.837761: notifier:notifier_call_chain: val 6 fcn ffffffff825a9440 name cfg80211_netdev_notifier_call
kworker/u128:32  4366 [002]    86.837772: notifier:notifier_call_chain: val 6 fcn ffffffff8168a060 name sel_netif_netdev_notifier_handler
kworker/u128:32  4366 [002]    86.837782: notifier:notifier_call_chain: val 6 fcn ffffffff81baec70 name bond_netdev_event
kworker/u128:32  4366 [002]    86.837789: notifier:notifier_call_chain: val 6 fcn ffffffff81bbb230 name ipvlan_device_event
kworker/u128:32  4366 [002]    86.837796: notifier:notifier_call_chain: val 6 fcn ffffffff81bbc890 name ipvtap_device_event
kworker/u128:32  4366 [002]    86.837799: notifier:notifier_call_chain: val 6 fcn ffffffff81bbe550 name macsec_notify
kworker/u128:32  4366 [002]    86.837804: notifier:notifier_call_chain: val 6 fcn ffffffff81bc4240 name macvlan_device_event
kworker/u128:32  4366 [002]    86.837808: notifier:notifier_call_chain: val 6 fcn ffffffff81bc56a0 name macvtap_device_event
kworker/u128:32  4366 [002]    86.837816: notifier:notifier_call_chain: val 6 fcn ffffffff81bd3370 name team_device_event
kworker/u128:32  4366 [002]    86.837821: notifier:notifier_call_chain: val 6 fcn ffffffff81bdb890 name tun_device_event
kworker/u128:32  4366 [002]    86.837826: notifier:notifier_call_chain: val 6 fcn ffffffff81bf5bf0 name vrf_device_event
kworker/u128:32  4366 [002]    86.837834: notifier:notifier_call_chain: val 6 fcn ffffffff81c8cb80 name bpq_device_event
kworker/u128:32  4366 [002]    86.837841: notifier:notifier_call_chain: val 6 fcn ffffffff81c96e40 name pppoe_device_event
kworker/u128:32  4366 [002]    86.837845: notifier:notifier_call_chain: val 6 fcn ffffffff81c9b380 name hdlc_device_event
kworker/u128:32  4366 [002]    86.837850: notifier:notifier_call_chain: val 6 fcn ffffffff81ca06a0 name dlci_dev_event
kworker/u128:32  4366 [002]    86.837855: notifier:notifier_call_chain: val 6 fcn ffffffff81ca12c0 name lapbeth_device_event
kworker/u128:32  4366 [002]    86.837862: notifier:notifier_call_chain: val 6 fcn ffffffff81fa90f0 name cma_netdev_callback
kworker/u128:32  4366 [002]    86.837868: notifier:notifier_call_chain: val 6 fcn ffffffff81fee6a0 name ipoib_netdev_event
kworker/u128:32  4366 [002]    86.837875: notifier:notifier_call_chain: val 6 fcn ffffffff821c0e20 name dropmon_net_event
kworker/u128:32  4366 [002]    86.837896: notifier:notifier_call_chain: val 6 fcn ffffffff821c5d80 name failover_event
kworker/u128:32  4366 [002]    86.837903: notifier:notifier_call_chain: val 6 fcn ffffffff821e3a60 name mirred_device_event
kworker/u128:32  4366 [002]    86.837909: notifier:notifier_call_chain: val 6 fcn ffffffff8223a930 name nfqnl_rcv_dev_event
kworker/u128:32  4366 [002]    86.837918: notifier:notifier_call_chain: val 6 fcn ffffffff82273bd0 name nf_tables_netdev_event
kworker/u128:32  4366 [002]    86.837924: notifier:notifier_call_chain: val 6 fcn ffffffff822667c0 name nf_tables_flowtable_event
kworker/u128:32  4366 [002]    86.837932: notifier:notifier_call_chain: val 6 fcn ffffffff8227ef40 name flow_offload_netdev_event
kworker/u128:32  4366 [002]    86.837936: notifier:notifier_call_chain: val 6 fcn ffffffff82260e40 name masq_device_event
kworker/u128:32  4366 [002]    86.837941: notifier:notifier_call_chain: val 6 fcn ffffffff82290560 name tee_netdev_event
kworker/u128:32  4366 [002]    86.837950: notifier:notifier_call_chain: val 6 fcn ffffffff8236dcd0 name clusterip_netdev_event
kworker/u128:32  4366 [002]    86.837955: notifier:notifier_call_chain: val 6 fcn ffffffff82385210 name tls_dev_event
kworker/u128:32  4366 [002]    86.837964: notifier:notifier_call_chain: val 6 fcn ffffffff823e99b0 name ip6mr_device_event
kworker/u128:32  4366 [002]    86.837972: notifier:notifier_call_chain: val 6 fcn ffffffff823b9300 name addrconf_notify
kworker/u128:32  4366 [002]    86.837989: notifier:notifier_call_chain: val 6 fcn ffffffff823d9200 name ipv6_mc_netdev_event
kworker/u128:32  4366 [002]    86.837997: notifier:notifier_call_chain: val 6 fcn ffffffff82419160 name packet_notifier
kworker/u128:32  4366 [002]    86.838003: notifier:notifier_call_chain: val 6 fcn ffffffff824255f0 name br_device_event
kworker/u128:32  4366 [002]    86.838012: notifier:notifier_call_chain: val 6 fcn ffffffff8243e6e0 name brnf_device_event
kworker/u128:32  4366 [002]    86.838017: notifier:notifier_call_chain: val 6 fcn ffffffff8244c220 name dsa_slave_netdevice_event
kworker/u128:32  4366 [002]    86.838023: notifier:notifier_call_chain: val 6 fcn ffffffff8244df10 name x25_device_event
kworker/u128:32  4366 [002]    86.838028: notifier:notifier_call_chain: val 6 fcn ffffffff824562a0 name nr_device_event
kworker/u128:32  4366 [002]    86.838033: notifier:notifier_call_chain: val 6 fcn ffffffff8245bd20 name rose_device_event
kworker/u128:32  4366 [002]    86.838039: notifier:notifier_call_chain: val 6 fcn ffffffff82466e40 name ax25_device_event
kworker/u128:32  4366 [002]    86.838044: notifier:notifier_call_chain: val 6 fcn ffffffff8246b8a0 name can_notifier
kworker/u128:32  4366 [002]    86.838050: notifier:notifier_call_chain: val 6 fcn ffffffff82470860 name cgw_notifier
kworker/u128:32  4366 [002]    86.838056: notifier:notifier_call_chain: val 6 fcn ffffffff824c08b0 name device_event
kworker/u128:32  4366 [002]    86.838062: notifier:notifier_call_chain: val 6 fcn ffffffff825355a0 name clip_device_event
kworker/u128:32  4366 [002]    86.838067: notifier:notifier_call_chain: val 6 fcn ffffffff825481c0 name vlan_device_event
kworker/u128:32  4366 [002]    86.838073: notifier:notifier_call_chain: val 6 fcn ffffffff8267bde0 name tipc_l2_device_event
kworker/u128:32  4366 [002]    86.838079: notifier:notifier_call_chain: val 6 fcn ffffffff826ab0e0 name smc_pnet_netdev_event
kworker/u128:32  4366 [002]    86.838158: notifier:notifier_call_chain: val 6 fcn ffffffff826c3220 name caif_device_notify
kworker/u128:32  4366 [002]    86.838169: notifier:notifier_call_chain: val 6 fcn ffffffff826cb4b0 name cfusbl_device_notify
kworker/u128:32  4366 [002]    86.838174: notifier:notifier_call_chain: val 6 fcn ffffffff826cf280 name lowpan_event
kworker/u128:32  4366 [002]    86.838180: notifier:notifier_call_chain: val 6 fcn ffffffff826def50 name lowpan_device_event
kworker/u128:32  4366 [002]    86.838186: notifier:notifier_call_chain: val 6 fcn ffffffff827178d0 name batadv_hard_if_event
kworker/u128:32  4366 [002]    86.838199: notifier:notifier_call_chain: val 6 fcn ffffffff8274a0c0 name dp_device_event
kworker/u128:32  4366 [002]    86.838207: notifier:notifier_call_chain: val 6 fcn ffffffff827631d0 name mpls_dev_notify
kworker/u128:32  4366 [002]    86.838212: notifier:notifier_call_chain: val 6 fcn ffffffff82765180 name hsr_netdev_notify
kworker/u128:32  4366 [002]    86.838219: notifier:notifier_call_chain: val 6 fcn ffffffff81bc6cc0 name netconsole_netdev_event
kworker/u128:32  4366 [002]    86.838226: notifier:notifier_call_chain: val 6 fcn ffffffff81bec840 name vxlan_netdevice_event
kworker/u128:32  4366 [002]    86.838235: notifier:notifier_call_chain: val 6 fcn ffffffff81bf0c60 name geneve_netdevice_event
kworker/u128:32  4366 [002]    86.838244: notifier:notifier_call_chain: val 6 fcn ffffffff82025700 name rxe_notify
kworker/u128:32  4366 [002]    86.838250: notifier:notifier_call_chain: val 6 fcn ffffffff823cc0d0 name ndisc_netdev_event
kworker/u128:32  4366 [002]    86.838256: notifier:notifier_call_chain: val 6 fcn ffffffff823bde70 name ip6_route_dev_notify
kworker/u128:32  4366 [002]    87.985339: notifier:notifier_call_chain: val 6 fcn ffffffff822de9b0 name ip_vs_dst_event
kworker/u128:32  4366 [002]    87.985354: notifier:notifier_call_chain: val 6 fcn ffffffff821a1060 name rtnetlink_event
kworker/u128:32  4366 [002]    87.985362: notifier:notifier_call_chain: val 6 fcn ffffffff812c8830 name dev_map_notification
kworker/u128:32  4366 [002]    87.985370: notifier:notifier_call_chain: val 6 fcn ffffffff81f89a00 name netdevice_event
kworker/u128:32  4366 [002]    87.985375: notifier:notifier_call_chain: val 6 fcn ffffffff821b8c70 name fib_rules_event
kworker/u128:32  4366 [002]    87.985385: notifier:notifier_call_chain: val 6 fcn ffffffff821c11e0 name netprio_device_event
kworker/u128:32  4366 [002]    87.985396: notifier:notifier_call_chain: val 6 fcn ffffffff826012b0 name wext_netdev_notifier_call
kworker/u128:32  4366 [002]    87.985405: notifier:notifier_call_chain: val 6 fcn ffffffff8261b980 name netdev_notify
kworker/u128:32  4366 [002]    87.985411: notifier:notifier_call_chain: val 6 fcn ffffffff826a4e10 name netlbl_unlhsh_netdev_handler
kworker/u128:32  4366 [002]    87.985416: notifier:notifier_call_chain: val 6 fcn ffffffff826d5900 name cfg802154_netdev_notifier_call
kworker/u128:32  4366 [002]    87.985424: notifier:notifier_call_chain: val 6 fcn ffffffff826e1fa0 name netdev_notify
kworker/u128:32  4366 [002]    87.985433: notifier:notifier_call_chain: val 6 fcn ffffffff82331910 name arp_netdev_event
kworker/u128:32  4366 [002]    87.985437: notifier:notifier_call_chain: val 6 fcn ffffffff823389c0 name inetdev_event
kworker/u128:32  4366 [002]    87.985443: notifier:notifier_call_chain: val 6 fcn ffffffff82343370 name fib_netdev_event
kworker/u128:32  4366 [002]    87.985727: notifier:notifier_call_chain: val 6 fcn ffffffff82399140 name xfrm_dev_event
kworker/u128:32  4366 [002]    87.985733: notifier:notifier_call_chain: val 6 fcn ffffffff8233dec0 name igmp_netdev_event
kworker/u128:32  4366 [002]    87.985740: notifier:notifier_call_chain: val 6 fcn ffffffff82353c00 name ipmr_device_event
kworker/u128:32  4366 [002]    87.985751: notifier:notifier_call_chain: val 6 fcn ffffffff825a9440 name cfg80211_netdev_notifier_call
kworker/u128:32  4366 [002]    87.985762: notifier:notifier_call_chain: val 6 fcn ffffffff8168a060 name sel_netif_netdev_notifier_handler
kworker/u128:32  4366 [002]    87.985772: notifier:notifier_call_chain: val 6 fcn ffffffff81baec70 name bond_netdev_event
kworker/u128:32  4366 [002]    87.985780: notifier:notifier_call_chain: val 6 fcn ffffffff81bbb230 name ipvlan_device_event
kworker/u128:32  4366 [002]    87.985786: notifier:notifier_call_chain: val 6 fcn ffffffff81bbc890 name ipvtap_device_event
kworker/u128:32  4366 [002]    87.985789: notifier:notifier_call_chain: val 6 fcn ffffffff81bbe550 name macsec_notify
kworker/u128:32  4366 [002]    87.985794: notifier:notifier_call_chain: val 6 fcn ffffffff81bc4240 name macvlan_device_event
kworker/u128:32  4366 [002]    87.985799: notifier:notifier_call_chain: val 6 fcn ffffffff81bc56a0 name macvtap_device_event
kworker/u128:32  4366 [002]    87.985807: notifier:notifier_call_chain: val 6 fcn ffffffff81bd3370 name team_device_event
kworker/u128:32  4366 [002]    87.985812: notifier:notifier_call_chain: val 6 fcn ffffffff81bdb890 name tun_device_event
kworker/u128:32  4366 [002]    87.985817: notifier:notifier_call_chain: val 6 fcn ffffffff81bf5bf0 name vrf_device_event
kworker/u128:32  4366 [002]    87.985824: notifier:notifier_call_chain: val 6 fcn ffffffff81c8cb80 name bpq_device_event
kworker/u128:32  4366 [002]    87.985830: notifier:notifier_call_chain: val 6 fcn ffffffff81c96e40 name pppoe_device_event
kworker/u128:32  4366 [002]    87.985835: notifier:notifier_call_chain: val 6 fcn ffffffff81c9b380 name hdlc_device_event
kworker/u128:32  4366 [002]    87.985840: notifier:notifier_call_chain: val 6 fcn ffffffff81ca06a0 name dlci_dev_event
kworker/u128:32  4366 [002]    87.985845: notifier:notifier_call_chain: val 6 fcn ffffffff81ca12c0 name lapbeth_device_event
kworker/u128:32  4366 [002]    87.985852: notifier:notifier_call_chain: val 6 fcn ffffffff81fa90f0 name cma_netdev_callback
kworker/u128:32  4366 [002]    87.985857: notifier:notifier_call_chain: val 6 fcn ffffffff81fee6a0 name ipoib_netdev_event
kworker/u128:32  4366 [002]    87.985863: notifier:notifier_call_chain: val 6 fcn ffffffff821c0e20 name dropmon_net_event
kworker/u128:32  4366 [002]    87.985883: notifier:notifier_call_chain: val 6 fcn ffffffff821c5d80 name failover_event
kworker/u128:32  4366 [002]    87.985890: notifier:notifier_call_chain: val 6 fcn ffffffff821e3a60 name mirred_device_event
kworker/u128:32  4366 [002]    87.985896: notifier:notifier_call_chain: val 6 fcn ffffffff8223a930 name nfqnl_rcv_dev_event
kworker/u128:32  4366 [002]    87.985905: notifier:notifier_call_chain: val 6 fcn ffffffff82273bd0 name nf_tables_netdev_event
kworker/u128:32  4366 [002]    87.985911: notifier:notifier_call_chain: val 6 fcn ffffffff822667c0 name nf_tables_flowtable_event
kworker/u128:32  4366 [002]    87.985919: notifier:notifier_call_chain: val 6 fcn ffffffff8227ef40 name flow_offload_netdev_event
kworker/u128:32  4366 [002]    87.985923: notifier:notifier_call_chain: val 6 fcn ffffffff82260e40 name masq_device_event
kworker/u128:32  4366 [002]    87.985929: notifier:notifier_call_chain: val 6 fcn ffffffff82290560 name tee_netdev_event
kworker/u128:32  4366 [002]    87.985938: notifier:notifier_call_chain: val 6 fcn ffffffff8236dcd0 name clusterip_netdev_event
kworker/u128:32  4366 [002]    87.985943: notifier:notifier_call_chain: val 6 fcn ffffffff82385210 name tls_dev_event
kworker/u128:32  4366 [002]    87.985952: notifier:notifier_call_chain: val 6 fcn ffffffff823e99b0 name ip6mr_device_event
kworker/u128:32  4366 [002]    87.985959: notifier:notifier_call_chain: val 6 fcn ffffffff823b9300 name addrconf_notify
kworker/u128:32  4366 [002]    87.985977: notifier:notifier_call_chain: val 6 fcn ffffffff823d9200 name ipv6_mc_netdev_event
kworker/u128:32  4366 [002]    87.985984: notifier:notifier_call_chain: val 6 fcn ffffffff82419160 name packet_notifier
kworker/u128:32  4366 [002]    87.985990: notifier:notifier_call_chain: val 6 fcn ffffffff824255f0 name br_device_event
kworker/u128:32  4366 [002]    87.985999: notifier:notifier_call_chain: val 6 fcn ffffffff8243e6e0 name brnf_device_event
kworker/u128:32  4366 [002]    87.986005: notifier:notifier_call_chain: val 6 fcn ffffffff8244c220 name dsa_slave_netdevice_event
kworker/u128:32  4366 [002]    87.986011: notifier:notifier_call_chain: val 6 fcn ffffffff8244df10 name x25_device_event
kworker/u128:32  4366 [002]    87.986016: notifier:notifier_call_chain: val 6 fcn ffffffff824562a0 name nr_device_event
kworker/u128:32  4366 [002]    87.986021: notifier:notifier_call_chain: val 6 fcn ffffffff8245bd20 name rose_device_event
kworker/u128:32  4366 [002]    87.986027: notifier:notifier_call_chain: val 6 fcn ffffffff82466e40 name ax25_device_event
kworker/u128:32  4366 [002]    87.986032: notifier:notifier_call_chain: val 6 fcn ffffffff8246b8a0 name can_notifier
kworker/u128:32  4366 [002]    87.986037: notifier:notifier_call_chain: val 6 fcn ffffffff82470860 name cgw_notifier
kworker/u128:32  4366 [002]    87.986043: notifier:notifier_call_chain: val 6 fcn ffffffff824c08b0 name device_event
kworker/u128:32  4366 [002]    87.986049: notifier:notifier_call_chain: val 6 fcn ffffffff825355a0 name clip_device_event
kworker/u128:32  4366 [002]    87.986055: notifier:notifier_call_chain: val 6 fcn ffffffff825481c0 name vlan_device_event
kworker/u128:32  4366 [002]    87.986061: notifier:notifier_call_chain: val 6 fcn ffffffff8267bde0 name tipc_l2_device_event
kworker/u128:32  4366 [002]    87.986067: notifier:notifier_call_chain: val 6 fcn ffffffff826ab0e0 name smc_pnet_netdev_event
kworker/u128:32  4366 [002]    87.986076: notifier:notifier_call_chain: val 6 fcn ffffffff826c3220 name caif_device_notify
kworker/u128:32  4366 [002]    87.986081: notifier:notifier_call_chain: val 6 fcn ffffffff826cb4b0 name cfusbl_device_notify
kworker/u128:32  4366 [002]    87.986087: notifier:notifier_call_chain: val 6 fcn ffffffff826cf280 name lowpan_event
kworker/u128:32  4366 [002]    87.986092: notifier:notifier_call_chain: val 6 fcn ffffffff826def50 name lowpan_device_event
kworker/u128:32  4366 [002]    87.986097: notifier:notifier_call_chain: val 6 fcn ffffffff827178d0 name batadv_hard_if_event
kworker/u128:32  4366 [002]    87.986109: notifier:notifier_call_chain: val 6 fcn ffffffff8274a0c0 name dp_device_event
kworker/u128:32  4366 [002]    87.986117: notifier:notifier_call_chain: val 6 fcn ffffffff827631d0 name mpls_dev_notify
kworker/u128:32  4366 [002]    87.986123: notifier:notifier_call_chain: val 6 fcn ffffffff82765180 name hsr_netdev_notify
kworker/u128:32  4366 [002]    87.986128: notifier:notifier_call_chain: val 6 fcn ffffffff81bc6cc0 name netconsole_netdev_event
kworker/u128:32  4366 [002]    87.986136: notifier:notifier_call_chain: val 6 fcn ffffffff81bec840 name vxlan_netdevice_event
kworker/u128:32  4366 [002]    87.986144: notifier:notifier_call_chain: val 6 fcn ffffffff81bf0c60 name geneve_netdevice_event
kworker/u128:32  4366 [002]    87.986153: notifier:notifier_call_chain: val 6 fcn ffffffff82025700 name rxe_notify
kworker/u128:32  4366 [002]    87.986159: notifier:notifier_call_chain: val 6 fcn ffffffff823cc0d0 name ndisc_netdev_event
kworker/u128:32  4366 [002]    87.986165: notifier:notifier_call_chain: val 6 fcn ffffffff823bde70 name ip6_route_dev_notify
