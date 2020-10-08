Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939092871D1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgJHJsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHJsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:48:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE29C061755;
        Thu,  8 Oct 2020 02:48:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so3835912pgk.4;
        Thu, 08 Oct 2020 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZEpfchtPlSN6NaVHvp0J/53pPQ0OVmTy9xX4+EJUKNw=;
        b=fPjd5S4WWhVW89Mtfqs1QjrCL/kXd0fKNXZ1eRFm+xBSOnSEEwxS0Oy5WlSDhp76bH
         LVfK5CizUWFTie8TSKdluLiDnsmq/8BFjQBAzSR+Bj+jfrKjVWMKIiHguypiSTZm8Uax
         Vy0419viQKehfTizIOANr7fRYQfCr7pqtwclXanA6CpW3lZwAYwtvC6/KjBYsOftzH6B
         fgNvTXboHcp9Z8vwhh6afC07GtP+/4LGCbfIYozSvRDj4wZFv6UdqJz73NiW93Ugnam8
         WfSZIZS0HCY5+FI2vYw1I8vO779Kr3XX5FDTRg8sF1bW8lHDPMjr7aSZHuc0WrxJenpD
         iwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZEpfchtPlSN6NaVHvp0J/53pPQ0OVmTy9xX4+EJUKNw=;
        b=NFlUff4b2KA/573wtrE8SiCVnAx1ldsT/FiutUpk7MJ0Zm9MgLW9ra5wyBauKoxMBD
         95X7C8yieZSDvZq0uso5z61OAkKQ0QsF2SvWDUgqyFsKVnAXSIGPEZxf//GYw9F6Uw93
         C8d/tUhnLZIXsr/mfDW5OtkibK17ktAsZzYhapr3zUXlPOQC2LWBGvrV1m/yyyDvMMNo
         nVMveOoSOevOcHRq6vD1dd9RBUkRjq3QyMkPI91lF1z+VugElJxcytE2akz2XGM1OqPl
         yiHshu3ch8IfFM51BALjQg/b+tKZIySGQz9G/QjYw6quGeHU7mhIrOM8QRuO8SOqNLDJ
         w+9g==
X-Gm-Message-State: AOAM531tIIH2ksxxEvmqB3jDam4/sy7inJ4QtisnHCaLeeOwGwaiDCX0
        ySfV/R32EMp31qPoVJ470Pm9ocWZdrg=
X-Google-Smtp-Source: ABdhPJy+OpasCQZdBOEAM5N8VMaT3gCDh1YhXgPHLZmit4wUE18iez6W45eddUuHw+Un7K9tscB3TA==
X-Received: by 2002:a17:90a:ff06:: with SMTP id ce6mr7074588pjb.38.1602150501732;
        Thu, 08 Oct 2020 02:48:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c7sm6646476pfj.84.2020.10.08.02.48.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:48:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 00/17] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Date:   Thu,  8 Oct 2020 17:47:56 +0800
Message-Id: <cover.1602150362.git.lucien.xin@gmail.com>
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
    Encapsulation of SCTP from draft-tuexen-tsvwg-sctp-udp-encaps-cons-03,
    noticed by Michael.

Xin Long (17):
  udp: check udp sock encap_type in __udp_lib_err
  udp6: move the mss check after udp gso tunnel processing
  udp: do checksum properly in skb_udp_tunnel_segment
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

 include/linux/sctp.h         |  20 ++++++
 include/net/netns/sctp.h     |   8 +++
 include/net/sctp/constants.h |   2 +
 include/net/sctp/sctp.h      |   9 ++-
 include/net/sctp/sm.h        |   4 ++
 include/net/sctp/structs.h   |  14 ++--
 include/uapi/linux/sctp.h    |   7 ++
 net/ipv4/udp.c               |   2 +-
 net/ipv4/udp_offload.c       |  16 +++--
 net/ipv6/udp.c               |   2 +-
 net/ipv6/udp_offload.c       | 154 +++++++++++++++++++++----------------------
 net/sctp/associola.c         |   4 ++
 net/sctp/ipv6.c              |  44 +++++++++----
 net/sctp/output.c            |  22 +++----
 net/sctp/protocol.c          | 148 +++++++++++++++++++++++++++++++++++++----
 net/sctp/sm_make_chunk.c     |  21 ++++++
 net/sctp/sm_statefuns.c      |  52 +++++++++++++++
 net/sctp/socket.c            | 112 +++++++++++++++++++++++++++++++
 net/sctp/sysctl.c            |  59 +++++++++++++++++
 19 files changed, 572 insertions(+), 128 deletions(-)

-- 
2.1.0

