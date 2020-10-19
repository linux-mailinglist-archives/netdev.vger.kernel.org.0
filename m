Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD34029272D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgJSMZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgJSMZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:25:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDC7C0613CE;
        Mon, 19 Oct 2020 05:25:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so5934907pgk.4;
        Mon, 19 Oct 2020 05:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=By2GR9vzJp/xRv9eT99/+c+sLmkLzzgGZ0ccjQX/ZTk=;
        b=NgUNFZmnUc4FPUBlQ0g+Cdo6HsuFaGEwJBRJRn+dbqFCi1FIP7S6/cSyEFBrV9ojad
         FuKTQLycJiZYMRlB8gMGCA5oyykfx0QkFcOt6zKWdYR0ZOJSKyzrHXiH86d1pp7LYW9j
         Ms9bU0SA2vEAjs09ylNevJDuRzAQZ/dhgAG2eBblDcvi27aguATGvLGw36u5pP9+Urc6
         L6t6vWrUIVH1QAzNT5L1f0OqRMcskWtZE1uvboX2ry/dqRhLi6iEfDEkj/+OJ0vCl2vb
         U1g1TopkEIehs9RivUkN0w2OiURTKdXwCQNG/iXHJNxZUjblWMrUR35+EwoiTD33Twum
         WwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=By2GR9vzJp/xRv9eT99/+c+sLmkLzzgGZ0ccjQX/ZTk=;
        b=V63II2DXfU/hRs3UVxYrb+wEYQWSmRcMks8Vl5bRP6Q4Skb0GHzjF0chb9lM+awo5T
         cQcQeXlufa/Dmq8RcB4Wlj+lSRcUuZINAVp+iX4pp8+KiJwSNGQYgDt8G+leklvBOQcD
         b6mtLNNwC7FpLADLMLSGBrotoI9Xge3nmQBeZO0aeXzJ572eU01w+Jic7sdDj/KV+HAC
         Rev9ghJY9KRzdse8pl9J2m0lTBgeRdp9nVxZU2AJrrN+O/mGI0p7MyUOGJhg6ABXAFvR
         /Lqd8d7M4u4VHenYtfwfogTn3S3NvtD1KX837KlJPAm6I27uvaKc2Md5nE7VckDVi+m4
         X4BA==
X-Gm-Message-State: AOAM533PvxUaJnhd4/viUK6NUOVeRQODjHkoZOr2DjFr7Tyd1XPNm4A6
        +vzOW42geAabRzxvL5U5Rob76/CwcxM=
X-Google-Smtp-Source: ABdhPJxC1IQDIFy4jKJeidpylId72/QlcENiaxLxwjEcJtz1bPNQoE4Ze8HDhlUzyX4FCJ9kXMuqWQ==
X-Received: by 2002:a65:688a:: with SMTP id e10mr14091047pgt.347.1603110341786;
        Mon, 19 Oct 2020 05:25:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 198sm11827884pfy.41.2020.10.19.05.25.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:25:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 00/16] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Date:   Mon, 19 Oct 2020 20:25:17 +0800
Message-Id: <cover.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Description From the RFC:

   The Main Reasons:

   o  To allow SCTP traffic to pass through legacy NATs, which do not
      provide native SCTP support as specified in [BEHAVE] and
      [NATSUPP].

   o  To allow SCTP to be implemented on hosts that do not provide
      direct access to the IP layer.  In particular, applications can
      use their own SCTP implementation if the operating system does not
      provide one.

   Implementation Notes:

   UDP-encapsulated SCTP is normally communicated between SCTP stacks
   using the IANA-assigned UDP port number 9899 (sctp-tunneling) on both
   ends.  There are circumstances where other ports may be used on
   either end, and it might be required to use ports other than the
   registered port.

   Each SCTP stack uses a single local UDP encapsulation port number as
   the destination port for all its incoming SCTP packets, this greatly
   simplifies implementation design.

   An SCTP implementation supporting UDP encapsulation MUST maintain a
   remote UDP encapsulation port number per destination address for each
   SCTP association.  Again, because the remote stack may be using ports
   other than the well-known port, each port may be different from each
   stack.  However, because of remapping of ports by NATs, the remote
   ports associated with different remote IP addresses may not be
   identical, even if they are associated with the same stack.

   Because the well-known port might not be used, implementations need
   to allow other port numbers to be specified as a local or remote UDP
   encapsulation port number through APIs.

Patches:

   This patchset is using the udp4/6 tunnel APIs to implement the UDP
   Encapsulation of SCTP with not much change in SCTP protocol stack
   and with all current SCTP features keeped in Linux Kernel.

   1 - 4: Fix some UDP issues that may be triggered by SCTP over UDP.
   5 - 7: Process incoming UDP encapsulated packets and ICMP packets.
   8 -10: Remote encap port's update by sysctl, sockopt and packets.
   11-14: Process outgoing pakects with UDP encapsulated and its GSO.
   15-16: Add the part from draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
      17: Enable this feature.

Tests:

  - lksctp-tools/src/func_tests with UDP Encapsulation enabled/disabled:

      Both make v4test and v6test passed.

  - sctp-tests with UDP Encapsulation enabled/disabled:

      repeatability/procdumps/sctpdiag/gsomtuchange/extoverflow/
      sctphashtable passed. Others failed as expected due to those
      "iptables -p sctp" rules.

  - netperf on lo/netns/virtio_net, with gso enabled/disabled and
    with ip_checksum enabled/disabled, with UDP Encapsulation
    enabled/disabled:

      No clear performance dropped.

v1->v2:
  - Fix some incorrect code in the patches 5,6,8,10,11,13,14,17, suggested
    by Marcelo.
  - Append two patches 15-16 to add the Additional Considerations for UDP
    Encapsulation of SCTP from draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
v2->v3:
  - remove the cleanup code in patch 2, suggested by Willem.
  - remove the patch 3 and fix the checksum in the new patch 3 after
    talking with Paolo, Marcelo and Guillaume.
  - add 'select NET_UDP_TUNNEL' in patch 4 to solve a compiling error.
  - fix __be16 type cast warning in patch 8.
  - fix the wrong endian orders when setting values in 14,16.
v3->v4:
  - add entries in ip-sysctl.rst in patch 7,16, as Marcelo Suggested.
  - not create udp socks when udp_port is set to 0 in patch 16, as
    Marcelo noticed.

Xin Long (16):
  udp: check udp sock encap_type in __udp_lib_err
  udp6: move the mss check after udp gso tunnel processing
  udp: support sctp over udp in skb_udp_tunnel_segment
  sctp: create udp4 sock and add its encap_rcv
  sctp: create udp6 sock and set its encap_rcv
  sctp: add encap_err_lookup for udp encap socks
  sctp: add encap_port for netns sock asoc and transport
  sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
  sctp: allow changing transport encap_port by peer packets
  sctp: add udphdr to overhead when udp_port is set
  sctp: call sk_setup_caps in sctp_packet_transmit instead
  sctp: support for sending packet over udp4 sock
  sctp: support for sending packet over udp6 sock
  sctp: add the error cause for new encapsulation port restart
  sctp: handle the init chunk matching an existing asoc
  sctp: enable udp tunneling socks

 Documentation/networking/ip-sysctl.rst |  15 ++++
 include/linux/sctp.h                   |  20 +++++
 include/net/netns/sctp.h               |   8 ++
 include/net/sctp/constants.h           |   2 +
 include/net/sctp/sctp.h                |   9 +-
 include/net/sctp/sm.h                  |   4 +
 include/net/sctp/structs.h             |  14 ++--
 include/uapi/linux/sctp.h              |   7 ++
 net/ipv4/udp.c                         |   2 +-
 net/ipv4/udp_offload.c                 |   3 +
 net/ipv6/udp.c                         |   2 +-
 net/ipv6/udp_offload.c                 |   8 +-
 net/sctp/Kconfig                       |   1 +
 net/sctp/associola.c                   |   4 +
 net/sctp/ipv6.c                        |  44 +++++++---
 net/sctp/offload.c                     |   6 +-
 net/sctp/output.c                      |  22 +++--
 net/sctp/protocol.c                    | 148 ++++++++++++++++++++++++++++++---
 net/sctp/sm_make_chunk.c               |  21 +++++
 net/sctp/sm_statefuns.c                |  52 ++++++++++++
 net/sctp/socket.c                      | 116 ++++++++++++++++++++++++++
 net/sctp/sysctl.c                      |  62 ++++++++++++++
 22 files changed, 520 insertions(+), 50 deletions(-)

-- 
2.1.0

