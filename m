Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9541A6D0
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 08:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfEKGNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 02:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfEKGNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 02:13:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 18448307CDC7;
        Sat, 11 May 2019 06:13:01 +0000 (UTC)
Received: from Hades.local (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D65B17A72;
        Sat, 11 May 2019 06:12:59 +0000 (UTC)
Subject: Re: [PATCH] bonding: fix arp_validate toggling in active-backup mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190510215709.19162-1-jarod@redhat.com>
 <26675.1557528809@famine>
From:   Jarod Wilson <jarod@redhat.com>
Message-ID: <2033e768-9e35-ac89-c526-4c28fc3f747e@redhat.com>
Date:   Sat, 11 May 2019 02:12:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <26675.1557528809@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sat, 11 May 2019 06:13:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/19 6:53 PM, Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
>> There's currently a problem with toggling arp_validate on and off with an
>> active-backup bond. At the moment, you can start up a bond, like so:
>>
>> modprobe bonding mode=1 arp_interval=100 arp_validate=0 arp_ip_targets=192.168.1.1
>> ip link set bond0 down
>> echo "ens4f0" > /sys/class/net/bond0/bonding/slaves
>> echo "ens4f1" > /sys/class/net/bond0/bonding/slaves
>> ip link set bond0 up
>> ip addr add 192.168.1.2/24 dev bond0
>>
>> Pings to 192.168.1.1 work just fine. Now turn on arp_validate:
>>
>> echo 1 > /sys/class/net/bond0/bonding/arp_validate
>>
>> Pings to 192.168.1.1 continue to work just fine. Now when you go to turn
>> arp_validate off again, the link falls flat on it's face:
>>
>> echo 0 > /sys/class/net/bond0/bonding/arp_validate
>> dmesg
>> ...
>> [133191.911987] bond0: Setting arp_validate to none (0)
>> [133194.257793] bond0: bond_should_notify_peers: slave ens4f0
>> [133194.258031] bond0: link status definitely down for interface ens4f0, disabling it
>> [133194.259000] bond0: making interface ens4f1 the new active one
>> [133197.330130] bond0: link status definitely down for interface ens4f1, disabling it
>> [133197.331191] bond0: now running without any active interface!
>>
>> The problem lies in bond_options.c, where passing in arp_validate=0
>> results in bond->recv_probe getting set to NULL. This flies directly in
>> the face of commit 3fe68df97c7f, which says we need to set recv_probe =
>> bond_arp_recv, even if we're not using arp_validate. Said commit fixed
>> this in bond_option_arp_interval_set, but missed that we can get to that
>> same state in bond_option_arp_validate_set as well.
>>
>> One solution would be to universally set recv_probe = bond_arp_recv here
>> as well, but I don't think bond_option_arp_validate_set has any business
>> touching recv_probe at all, and that should be left to the arp_interval
>> code, so we can just make things much tidier here.
>>
>> Fixes: 3fe68df97c7f ("bonding: always set recv_probe to bond_arp_rcv in arp monitor")
> 
> 	Is the above Fixes: tag correct?  3fe68df97c7f is not the source
> of the erroneous logic being removed, which was introduced by
> 
> commit 29c4948293bfc426e52a921f4259eb3676961e81
> Author: sfeldma@cumulusnetworks.com <sfeldma@cumulusnetworks.com>
> Date:   Thu Dec 12 14:10:38 2013 -0800
> 
>      bonding: add arp_validate netlink support

I wasn't entirely sure that was the best choice for Fixes either, it was 
sort of more "Augments the Fix in", so I'd certainly have no objection 
to changing the Fixes tag to the earlier commit instead.

-- 
Jarod Wilson
jarod@redhat.com
