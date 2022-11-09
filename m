Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE5623242
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKISTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKIST2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:19:28 -0500
Received: from smtpcmd0871.aruba.it (smtpcmd0871.aruba.it [62.149.156.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB76B1740C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:19:26 -0800 (PST)
Received: from [192.168.1.56] ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id spfXo2TiJckLQspfXo5jOW; Wed, 09 Nov 2022 19:19:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668017965; bh=i4g2WrPHI04TnmhwPKRIsLCy+QjzHirNb5DAdbj1tqg=;
        h=Date:MIME-Version:Subject:To:From:Content-Type;
        b=AEiTsqxN14aLs8vZQJsTJiD8YQRJ6bYcDqYzzKaK3GpP6sKP+4YBthksKIlX75SzU
         VXWdC2fmUE0X4sV3E6f4ZkP5nUgb2WmZo+vZ4EWxulgPepANPIJAzgK6FDck+VfBm4
         yjA8JgdfXW5/7DKQhRDT8bIVpqjW74jGRctoNjOuFP4kWGFn12J4Y+DZGZ3+abR+er
         3MnG2eS3DPpBnU2eMaLKJY3nMYRw53Dlnu1r+YXOI+7tSAZt+S8CkDp5rJDS4lrz0q
         gfaGZs9OhJk2f0YLZfz8e+vy1WaCImUeyL2OgiU5VqmcG8Oqata6hHrFiQrynbCDBQ
         b+WOBR/pwHhpA==
Message-ID: <1c6ce1f3-a116-7a17-145e-712113a99f1e@enneenne.com>
Date:   Wed, 9 Nov 2022 19:19:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net br_netlink.c:y allow non "disabled" state for
 !netif_oper_up() links
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221109152410.3572632-1-giometti@enneenne.com>
 <20221109152410.3572632-2-giometti@enneenne.com> <Y2vkwYyivfTqAfEp@lunn.ch>
From:   Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <Y2vkwYyivfTqAfEp@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHOYSgXjvG1zuiYogB57uNerpGEft1EzyybsKZu7vK7wDM6j++VMhub4M8cJwVq/PYmp7eAmDuJdBy328h8me6vLEdibdVMXvv+1VC65mawbaKwM9TK2
 heLwSKTIfAbR2GibLe8VLW3l/WRCoqgagbaSfFIMVk1ONsGsKkMlw83WN1zNrMQEGpkSUw7CJ/EZma7SQq+zQzTiASmVdEa677W51pfG8Rqqsw7/WnVLv8bC
 PHYenFa3fIPxGaQ25MC/ODdfGx94aO0ItKCPHr4HKQN8vArNSuDiAbloZkQ/FLSzo/FWaRUIv4t7TcpAVB1JZ0cqXcr54Ma+lqgE9/u1SRMrFDbI9wNJ2y3h
 jCQbDYqX
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/22 18:34, Andrew Lunn wrote:
> On Wed, Nov 09, 2022 at 04:24:10PM +0100, Rodolfo Giometti wrote:
>> A generic loop-free network protocol (such as STP or MRP and others) may
>> require that a link not in an operational state be into a non "disabled"
>> state (such as listening).
>>
>> For example MRP states that a MRM should set into a "BLOCKED" state (which is
>> equivalent to the LISTENING state for Linux bridges) one of its ring
>> connection if it detects that this connection is "DOWN" (that is the
>> NO-CARRIER status).
> 
> Does MRP explain Why?
> 
> This change seems odd, and "Because the standard says so" is not the
> best of explanations.

A MRM instance has two ports: primary port (PRM_RPort) and secondary port 
(SEC_RPort).

When both ports are UP (that is the CARRIER is on) the MRM is into the 
Ring_closed state and the PRM_RPort is in forwarding state while the SEC_RPort 
is in blocking state (remember that MRP blocking is equal to Linux bridge 
listening).

If the PRM_RPort losts its carrier and the link goes down the normative states that:

- ports role swap (PRM_RPort becomes SEC_RPort and vice versa).

- SEC_RPort must be set into blocking state.

- PRM_RPort must be set into forwarding state.

Then the MRM moves into a new state called Primary-UP. In this state, when the 
SEC_RPort returns to UP state (that is the CARRIER is up) it's returns into the 
Ring_closed state where both ports have the right status, that is the PRM_RPort 
is in forwarding state while the SEC_RPort is in blocking state.

This is just an example of one single case, but consider that, in general, when 
the carrier is lost the port state is moved into blocking so that when the 
carrier returns the port it's already into the right state.

Hope it's clearer now.

However, despite this special case, I think that kernel code should implement 
mechanisms and not policies, shouldn't it? If user space needs a non operational 
port (that is with no carrier) into the listening state, why we should prevent it?

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti

