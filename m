Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B087EDC403
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389955AbfJRLdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 07:33:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:52338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729803AbfJRLdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 07:33:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 263DEAFC3;
        Fri, 18 Oct 2019 11:33:30 +0000 (UTC)
To:     netdev@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>
From:   Jiri Wiesner <jwiesner@suse.com>
Subject: ipvlan forces promisc mode on vmxnet3 master
Message-ID: <08cbc498-4e21-4e8e-260f-29831db07510@suse.com>
Date:   Fri, 18 Oct 2019 13:33:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a problem when ipvlan slaves are created on a master device 
that is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver 
does not support unicast address filtering. When ipvlan_open() brings up 
an ipvlan device, the ipvlan driver calls dev_uc_add() to add the 
hardware address of the vmxnet3 master device to the unicast address 
list, phy_dev->uc. This inevitably leads to the master device being 
forced into promiscuous mode by __dev_set_rx_mode().

I have, so far, failed to find any purpose in calling dev_uc_add() from 
ipvlan_open(). Promiscuous mode is switched on the master despite the 
fact that there is still only one hardware address that the master 
device should use for filtering. The comment above struct net_device 
describes the uc_promisc member as a "counter, that indicates, that 
promiscuous mode has been enabled due to the need to listen to 
additional unicast addresses in a device that does not implement 
ndo_set_rx_mode()". Moreover, the design of ipvlan guarantees that only 
the hardware address of a master device, phy_dev->dev_addr, will be used 
to transmit and receive all packets from its slaves.

So, my question is: Could removing the calls to dev_uc_add() and 
dev_uc_del() from ipvlan_open() and ipvlan_stop(), respectively, be a 
viable solution for cases when the ipvlan driver is used with a master 
device that does not support unicast filtering?
Kind Regards,
Jiri
