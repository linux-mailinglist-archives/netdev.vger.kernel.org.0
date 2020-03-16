Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50C9186658
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbgCPIXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:23:09 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:64120 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729996AbgCPIXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:23:09 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BACDF41881;
        Mon, 16 Mar 2020 16:23:03 +0800 (CST)
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   wenxu <wenxu@ucloud.cn>
Subject: ct_act can't offload in hardware
Message-ID: <bdb0ae4d-b488-b305-4146-e938e8b560f4@ucloud.cn>
Date:   Mon, 16 Mar 2020 16:23:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVDTUpCQkJMTktKSExISFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nkk6Txw*CzgyEh0CEiMqLlYi
        HAkwCU1VSlVKTkNPSE9NQkNIQkpMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUlNSjcG
X-HM-Tid: 0a70e2706d9a2086kuqybacdf41881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi paul,


I test the ct offload with  tc  in net-next branch and meet some problem


gre_sys is a getap device.

# tc filter add dev gre_sys ingress prio 2 chain 0 proto ip flower  enc_dst_ip 172.168.152.75 enc_src_ip 172.168.152.208 enc_key_id 1000 enc_tos 0x0/ff dst_ip 1.1.1.7 ct_state -trk action ct zone 1 nat pipe action goto chain 1

The rule show is not_in_hw

# tc filter ls dev gre_sys ingress

filter protocol ip pref 2 flower chain 0
filter protocol ip pref 2 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 1.1.1.7
  enc_dst_ip 172.168.152.75
  enc_src_ip 172.168.152.208
  enc_key_id 1000
  enc_tos 0x0/ff
  ct_state -trk
  not_in_hw
    action order 1: ct zone 1 nat pipe
     index 1 ref 1 bind 1
 
    action order 2: gact action goto chain 1
     random type none pass val 0
     index 1 ref 1 bind 1


# dmesg

mlx5_core 0000:81:00.0 net2: Chains on tunnel devices isn't supported without register metadata support

I update the fw to 16.27.1016 and also the problem is exist.

# ethtool -i net2

driver: mlx5e_rep
version: 5.6.0-rc5+
firmware-version: 16.27.1016 (MT_0000000080)
expansion-rom-version:
bus-info: 0000:81:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

Are there aome method to enable the register metadata support?


BR

wenxu

