Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1583D6B95
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 03:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhG0A7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 20:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhG0A7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 20:59:42 -0400
Received: from tulum.helixd.com (unknown [IPv6:2604:4500:0:9::b0fd:3c92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D9C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 18:40:04 -0700 (PDT)
Received: from [IPv6:2600:8801:8800:12e8:12e:8d0e:775b:1aa3] (unknown [IPv6:2600:8801:8800:12e8:12e:8d0e:775b:1aa3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id E3BCB20777;
        Mon, 26 Jul 2021 18:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627350000;
        bh=625Tcktxu8SmCM3WTWYyA5+Rmsdnrf3Gq4dZLeviBF4=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=Y0itbjJifwnNMGSPHEMkuKSwEJ3srFavgzRucNKJ5vQqghIlnEaxckMmotSBe+peC
         Vkaj0Nx/dwU7bY5iWfj3oMYZejXbLLz+4GS3EymV5BOl3buCWfbhCw3KLmqCzGQtuA
         pUXZjaokNVEp5YdhdxIHHXo/8a3itJkAU/dGwEQs=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch> <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
Message-ID: <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
Date:   Mon, 26 Jul 2021 18:39:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/21 7:36 PM, Dario Alcocer wrote:
> On 7/24/21 7:26 PM, Dario Alcocer wrote:
>> On 7/24/21 10:34 AM, Andrew Lunn wrote:
>>> You might want to enable dbg prints in driver/nets/phy/phy.c, so you
>>> can see the state machine changes.
>>
>> Great suggestion. I added the following to the boot options:
>>
>> dyndbg="file net/dsa/* +p; file drivers/net/phy/phy.c +p"
>>
>> The relevant messages collected from the system log are below. 
>> Interestingly, all of the ports go from UP to NOLINK. In addition, 
>> "breaking chain for DSA event 7" is reported, once for each port.

Andrew,

As I mentioned before, the system log shows that each switch port link 
state goes from UP to NOLINK when "ip link set DEVNAME up" runs.

Since you suggested it's probably a PHY problem, I used kernel tracing 
to track PHY-related calls in the following files:

* drivers/net/phy/phylink.c
* drivers/net/phy/marvell.c
* net/dsa/port.c

I set up the kernel tracing before trying to bring up the lan1 interface:

root@dali:~# mount -t tracefs tracefs /sys/kernel/tracing
root@dali:~# echo 0 > /sys/kernel/tracing/tracing_on
root@dali:~# echo function_graph > /sys/kernel/tracing/current_tracer
root@dali:~# echo phylink_\* > /sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo dsa_port_phylink_\* >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo m88e1510_probe >> /sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_config_init >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo m88e1510_config_aneg >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_read_status >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_ack_interrupt >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_config_intr >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo m88e1121_did_interrupt >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo genphy_resume >> /sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo genphy_suspend >> /sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_read_page >> /sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_write_page >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_get_sset_count >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo marvell_get_strings >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo m88e1540_get_tunable >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo m88e1540_set_tunable >> 
/sys/kernel/tracing/set_ftrace_filter
root@dali:~# echo 1 > /sys/kernel/tracing/tracing_on

I then tried bringing up lan1 again to see which functions would be 
called, then stopped kernel tracing:

root@dali:~# ip addr add 192.0.2.1/24 dev lan1
root@dali:~# ip link set lan1 up
[  511.763909] mv88e6085 stmmac-0:1a lan1: configuring for phy/gmii link 
mode
[  511.773082] 8021q: adding VLAN 0 to HW filter on device lan1
root@dali:~# echo 0 > /sys/kernel/tracing/tracing_on

I then dumped the trace buffer:

root@dali:~# cat /sys/kernel/tracing/trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
  1) + 10.900 us   |  phylink_ethtool_ksettings_get();
  1)   5.220 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   2.060 us    |    phylink_get_fixed_state();
  1)   1.890 us    |    phylink_get_ksettings();
  1) + 11.740 us   |  }
  1)   6.760 us    |  phylink_ethtool_ksettings_get();
  1)   4.890 us    |  phylink_ethtool_ksettings_get();
  1)   4.670 us    |  phylink_ethtool_ksettings_get();
  1) + 11.560 us   |  phylink_ethtool_ksettings_get();
  1)   5.060 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   2.010 us    |    phylink_get_fixed_state();
  1)   1.810 us    |    phylink_get_ksettings();
  1) + 12.140 us   |  }
  1)   5.890 us    |  phylink_ethtool_ksettings_get();
  1)   5.300 us    |  phylink_ethtool_ksettings_get();
  1)   4.630 us    |  phylink_ethtool_ksettings_get();
  1) + 10.070 us   |  phylink_ethtool_ksettings_get();
  1)   5.100 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   1.910 us    |    phylink_get_fixed_state();
  1)   1.840 us    |    phylink_get_ksettings();
  1) + 12.120 us   |  }
  1)   5.910 us    |  phylink_ethtool_ksettings_get();
  1)   5.410 us    |  phylink_ethtool_ksettings_get();
  1)   4.630 us    |  phylink_ethtool_ksettings_get();
  1) + 10.560 us   |  phylink_ethtool_ksettings_get();
  1)   4.620 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   1.920 us    |    phylink_get_fixed_state();
  1)   1.930 us    |    phylink_get_ksettings();
  1) + 12.370 us   |  }
  1)   5.290 us    |  phylink_ethtool_ksettings_get();
  1)   4.570 us    |  phylink_ethtool_ksettings_get();
  1)   4.500 us    |  phylink_ethtool_ksettings_get();
  0)               |  phylink_start() {
  0)   2.510 us    |    phylink_resolve_flow();
  0)               |    phylink_mac_config() {
  0)   2.260 us    |      dsa_port_phylink_mac_config();
  0)   5.830 us    |    }
  0) + 14.740 us   |    phylink_run_resolve.part.0();
  0)               |    genphy_resume() {
  ------------------------------------------
  0)     ip-626     =>   kworker-20
  ------------------------------------------

  0)               |  phylink_resolve() {
  0)   1.860 us    |    phylink_resolve_flow();
  0)   6.800 us    |  }
  ------------------------------------------
  0)   kworker-20   =>     ip-626
  ------------------------------------------

  0) # 1818.330 us |    } /* genphy_resume */
  0) # 8730.320 us |  } /* phylink_start */
  ------------------------------------------
  0)     ip-626     =>   kworker-20
  ------------------------------------------

  0)               |  m88e1510_config_aneg() {
  0) # 1871.880 us |    marvell_read_page();
  0) # 1807.480 us |    marvell_write_page();
  0) # 1804.300 us |    marvell_write_page();
  0) * 42803.07 us |  }
  0) * 13283.95 us |  marvell_read_status();
  0)               |  phylink_phy_change() {
  0)   3.990 us    |    phylink_run_resolve.part.0();
  0)   8.930 us    |  }
  0)               |  phylink_resolve() {
  0)   2.110 us    |    phylink_resolve_flow();
  0)   6.320 us    |  }
  1) + 11.280 us   |  phylink_ethtool_ksettings_get();
  1)   4.560 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   2.180 us    |    phylink_get_fixed_state();
  1)   1.960 us    |    phylink_get_ksettings();
  1) + 12.620 us   |  }
  1)   5.290 us    |  phylink_ethtool_ksettings_get();
  1)   4.980 us    |  phylink_ethtool_ksettings_get();
  1)   5.000 us    |  phylink_ethtool_ksettings_get();
  1) + 10.430 us   |  phylink_ethtool_ksettings_get();
  1)   4.860 us    |  phylink_ethtool_ksettings_get();
  1)               |  phylink_ethtool_ksettings_get() {
  1)   2.070 us    |    phylink_get_fixed_state();
  1)   1.950 us    |    phylink_get_ksettings();
  1) + 12.090 us   |  }
  1)   5.310 us    |  phylink_ethtool_ksettings_get();
  1)   5.110 us    |  phylink_ethtool_ksettings_get();
  1)   4.730 us    |  phylink_ethtool_ksettings_get();

I filtered the output to see which specific calls are made when checking 
the port link status:

root@dali:~# cat /sys/kernel/tracing/trace | fgrep '|' | cut -d '|' -f 2 
| sort | uniq

       dsa_port_phylink_mac_config();
     genphy_resume() {
     marvell_read_page();
     marvell_write_page();
     phylink_get_fixed_state();
     phylink_get_ksettings();
     phylink_mac_config() {
     phylink_resolve_flow();
     phylink_run_resolve.part.0();
     }
     } /* genphy_resume */
   m88e1510_config_aneg() {
   marvell_read_status();
   phylink_ethtool_ksettings_get() {
   phylink_ethtool_ksettings_get();
   phylink_phy_change() {
   phylink_resolve() {
   phylink_start() {
   }
   } /* phylink_start */
root@dali:~#

I will focus on adding more tracing to these specific functions, in 
hopes of narrowing down the link issue further.

Let me know if you have any other suggestions, in case I missed something.

Thanks!

