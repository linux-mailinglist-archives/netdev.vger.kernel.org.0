Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A548A1DD472
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgEURbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:31:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:15617 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgEURbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:31:08 -0400
IronPort-SDR: IMux9/kVmQ8NJSq1B1d9KVHan1VRxO6B58vmWtE8JfyBFW+9on8uJj34Ux0yUDe2EUJacA16Ga
 vL1x82tco/aw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 10:31:08 -0700
IronPort-SDR: F94NVCnpCaNRrEz7m/VNldnTyVNsaF2AbHZr3ceZ7Gm7xTylqL1koadhz58w3uIM8YFw3j8Iuu
 57MPK5XrutMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="466982409"
Received: from chadcour-mobl.amr.corp.intel.com (HELO ellie) ([10.212.132.196])
  by fmsmga006.fm.intel.com with ESMTP; 21 May 2020 10:31:07 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
Date:   Thu, 21 May 2020 10:31:07 -0700
Message-ID: <87r1vdkxes.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

> This RFC series add support for Parallel Redundancy Protocol (PRP)
> as defined in IEC-62439-3 in the kernel networking subsystem. PRP 
> Uses a Redundancy Control Trailer (RCT) the format of which is
> similar to HSR Tag. This is used for implementing redundancy.
> RCT consists of 6 bytes similar to HSR tag and contain following
> fields:-
>
> - 16-bit sequence number (SeqNr);
> - 4-bit LAN identifier (LanId);
> - 12 bit frame size (LSDUsize);
> - 16-bit suffix (PRPsuffix). 
>
> The PRPsuffix identifies PRP frames and distinguishes PRP frames
> from other protocols that also append a trailer to their useful
> data. The LSDUsize field allows the receiver to distinguish PRP
> frames from random, nonredundant frames as an additional check.
> LSDUsize is the size of the Ethernet payload inclusive of the
> RCT. Sequence number along with LanId is used for duplicate
> detection and discard.
>
> PRP node is also known as Dual Attached Node (DAN-P) since it
> is typically attached to two different LAN for redundancy.
> DAN-P duplicates each of L2 frames and send it over the two
> Ethernet links. Each outgoing frame is appended with RCT.
> Unlike HSR, these are added to the end of L2 frame and may be
> treated as padding by bridges and therefore would be work with
> traditional bridges or switches, where as HSR wouldn't as Tag
> is prefixed to the Ethenet frame. At the remote end, these are
> received and the duplicate frame is discarded before the stripped
> frame is send up the networking stack. Like HSR, PRP also sends
> periodic Supervision frames to the network. These frames are
> received and MAC address from the SV frames are populated in a
> database called Node Table. The above functions are grouped into
> a block called Link Redundancy Entity (LRE) in the IEC spec.
>
> As there are many similarities between HSR and PRP protocols,
> this patch re-use the code from HSR driver to implement PRP
> driver. As many part of the code can be re-used, this patch
> introduces a new common API definitions for both protocols and
> propose to obsolete the existing HSR defines in
> include/uapi/linux/if_link.h. New definitions are prefixed 
> with a HSR_PRP prefix. Similarly include/uapi/linux/hsr_netlink.h
> is proposed to be replaced with include/uapi/linux/hsr_prp_netlink.h
> which also uses the HSR_PRP prefix. The netlink socket interface
> code is migrated (as well as the iproute2 being sent as a follow up
> patch) to use the new API definitions. To re-use the code,
> following are done as a preparatory patch before adding the PRP
> functionality:-
>
>   - prefix all common code with hsr_prp
>   - net/hsr -> renamed to net/hsr-prp
>   - All common struct types, constants, functions renamed with
>     hsr{HSR}_prp{PRP} prefix.

I don't really like these prefixes, I am thinking of when support for
IEEE 802.1CB is added, do we rename this to "hsr_prp_frer"?

And it gets even more complicated, and using 802.1CB you can configure
the tagging method and the stream identification function so a system
can interoperate in a HSR or PRP network.

So, I see this as different methods of achieving the same result, which
makes me think that the different "methods/types" (HSR and PRP in your
case) should be basically different implementations of a "struct
hsr_ops" interface. With this hsr_ops something like this:

   struct hsr_ops {
          int (*handle_frame)()
          int (*add_port)()
          int (*remove_port)()
          int (*setup)()
          void (*teardown)()
   };

>
> Please review this and provide me feedback so that I can work to
> incorporate them and send a formal patch series for this. As this
> series impacts user space, I am not sure if this is the right
> approach to introduce a new definitions and obsolete the old
> API definitions for HSR. The current approach is choosen
> to avoid redundant code in iproute2 and in the netlink driver
> code (hsr_netlink.c). Other approach we discussed internally was
> to Keep the HSR prefix in the user space and kernel code, but
> live with the redundant code in the iproute2 and hsr netlink
> code. Would like to hear from you what is the best way to add
> this feature to networking core. If there is any other
> alternative approach possible, I would like to hear about the
> same.

Why redudant code is needed in the netlink parts and in iproute2 when
keeping the hsr prefix?

>
> The patch was tested using two TI AM57x IDK boards which are
> connected back to back over two CPSW ports. 
>
> Script used for creating the hsr/prp interface is given below
> and uses the ip link command. Also provided logs from the tests
> I have executed for your reference. 
>
> iproute2 related patches will follow soon....
>
> Murali Karicheri
> Texas Instruments
>
> ============ setup.sh =================================================
> #!/bin/sh
> if [ $# -lt 4 ]
> then
>        echo "setup-cpsw.sh <hsr/prp> <MAC-Address of slave-A>"
>        echo "  <ip address for hsr/prp interface>"
>        echo "  <if_name of hsr/prp interface>"
>        exit
> fi
>
> if [ "$1" != "hsr" ] && [ "$1" != "prp" ]
> then
>        echo "use hsr or prp as first argument"
>        exit
> fi
>
> if_a=eth2
> if_b=eth3
> if_name=$4
>
> ifconfig $if_a down
> ifconfig $if_b down
> ifconfig $if_a hw ether $2
> ifconfig $if_b hw ether $2
> ifconfig $if_a up
> ifconfig $if_b up
>
> echo "Setting up $if_name with MAC address $2 for slaves and IP address $3"
> echo "          using $if_a and $if_b"
>
> if [ "$1" = "hsr" ]; then
>        options="version 1"
> else
>        options=""
> fi
>
> ip link add name $if_name type $1 slave1 $if_a slave2 $if_b supervision 0 $options
> ifconfig $if_name $3 up
> ==================================================================================
> PRP Logs:
>
> DUT-1 : https://pastebin.ubuntu.com/p/hhsRjTQpcr/
> DUT-2 : https://pastebin.ubuntu.com/p/snPFKhnpk4/
>
> HSR Logs:
>
> DUT-1 : https://pastebin.ubuntu.com/p/FZPNc6Nwdm/
> DUT-2 : https://pastebin.ubuntu.com/p/CtV4ZVS3Yd/
>
> Murali Karicheri (13):
>   net: hsr: Re-use Kconfig option to support PRP
>   net: hsr: rename hsr directory to hsr-prp to introduce PRP
>   net: hsr: rename files to introduce PRP support
>   net: hsr: rename hsr variable inside struct hsr_port to priv
>   net: hsr: rename hsr_port_get_hsr() to hsr_prp_get_port()
>   net: hsr: some renaming to introduce PRP driver support
>   net: hsr: introduce common uapi include/definitions for HSR and PRP
>   net: hsr: migrate HSR netlink socket code to use new common API
>   net: hsr: move re-usable code for PRP to hsr_prp_netlink.c
>   net: hsr: add netlink socket interface for PRP
>   net: prp: add supervision frame generation and handling support
>   net: prp: add packet handling support
>   net: prp: enhance debugfs to display PRP specific info in node table
>
>  MAINTAINERS                                   |   2 +-
>  include/uapi/linux/hsr_netlink.h              |   3 +
>  include/uapi/linux/hsr_prp_netlink.h          |  50 ++
>  include/uapi/linux/if_link.h                  |  19 +
>  net/Kconfig                                   |   2 +-
>  net/Makefile                                  |   2 +-
>  net/hsr-prp/Kconfig                           |  37 ++
>  net/hsr-prp/Makefile                          |  11 +
>  net/hsr-prp/hsr_netlink.c                     | 202 +++++++
>  net/{hsr => hsr-prp}/hsr_netlink.h            |  15 +-
>  .../hsr_prp_debugfs.c}                        |  82 +--
>  net/hsr-prp/hsr_prp_device.c                  | 562 ++++++++++++++++++
>  net/hsr-prp/hsr_prp_device.h                  |  23 +
>  net/hsr-prp/hsr_prp_forward.c                 | 558 +++++++++++++++++
>  .../hsr_prp_forward.h}                        |  10 +-
>  .../hsr_prp_framereg.c}                       | 323 +++++-----
>  net/hsr-prp/hsr_prp_framereg.h                |  68 +++
>  net/hsr-prp/hsr_prp_main.c                    | 194 ++++++
>  net/hsr-prp/hsr_prp_main.h                    | 289 +++++++++
>  net/hsr-prp/hsr_prp_netlink.c                 | 365 ++++++++++++
>  net/hsr-prp/hsr_prp_netlink.h                 |  28 +
>  net/hsr-prp/hsr_prp_slave.c                   | 222 +++++++
>  net/hsr-prp/hsr_prp_slave.h                   |  37 ++
>  net/hsr-prp/prp_netlink.c                     | 141 +++++
>  net/hsr-prp/prp_netlink.h                     |  27 +
>  net/hsr/Kconfig                               |  29 -
>  net/hsr/Makefile                              |  10 -
>  net/hsr/hsr_device.c                          | 509 ----------------
>  net/hsr/hsr_device.h                          |  22 -
>  net/hsr/hsr_forward.c                         | 379 ------------
>  net/hsr/hsr_framereg.h                        |  62 --
>  net/hsr/hsr_main.c                            | 154 -----
>  net/hsr/hsr_main.h                            | 188 ------
>  net/hsr/hsr_netlink.c                         | 514 ----------------
>  net/hsr/hsr_slave.c                           | 198 ------
>  net/hsr/hsr_slave.h                           |  33 -
>  36 files changed, 3084 insertions(+), 2286 deletions(-)
>  create mode 100644 include/uapi/linux/hsr_prp_netlink.h
>  create mode 100644 net/hsr-prp/Kconfig
>  create mode 100644 net/hsr-prp/Makefile
>  create mode 100644 net/hsr-prp/hsr_netlink.c
>  rename net/{hsr => hsr-prp}/hsr_netlink.h (58%)
>  rename net/{hsr/hsr_debugfs.c => hsr-prp/hsr_prp_debugfs.c} (52%)
>  create mode 100644 net/hsr-prp/hsr_prp_device.c
>  create mode 100644 net/hsr-prp/hsr_prp_device.h
>  create mode 100644 net/hsr-prp/hsr_prp_forward.c
>  rename net/{hsr/hsr_forward.h => hsr-prp/hsr_prp_forward.h} (50%)
>  rename net/{hsr/hsr_framereg.c => hsr-prp/hsr_prp_framereg.c} (56%)
>  create mode 100644 net/hsr-prp/hsr_prp_framereg.h
>  create mode 100644 net/hsr-prp/hsr_prp_main.c
>  create mode 100644 net/hsr-prp/hsr_prp_main.h
>  create mode 100644 net/hsr-prp/hsr_prp_netlink.c
>  create mode 100644 net/hsr-prp/hsr_prp_netlink.h
>  create mode 100644 net/hsr-prp/hsr_prp_slave.c
>  create mode 100644 net/hsr-prp/hsr_prp_slave.h
>  create mode 100644 net/hsr-prp/prp_netlink.c
>  create mode 100644 net/hsr-prp/prp_netlink.h
>  delete mode 100644 net/hsr/Kconfig
>  delete mode 100644 net/hsr/Makefile
>  delete mode 100644 net/hsr/hsr_device.c
>  delete mode 100644 net/hsr/hsr_device.h
>  delete mode 100644 net/hsr/hsr_forward.c
>  delete mode 100644 net/hsr/hsr_framereg.h
>  delete mode 100644 net/hsr/hsr_main.c
>  delete mode 100644 net/hsr/hsr_main.h
>  delete mode 100644 net/hsr/hsr_netlink.c
>  delete mode 100644 net/hsr/hsr_slave.c
>  delete mode 100644 net/hsr/hsr_slave.h
>
> -- 
> 2.17.1
>

-- 
Vinicius
