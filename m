Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3427CFCC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgI2NtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgI2NtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:49:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC59C061755;
        Tue, 29 Sep 2020 06:49:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id j19so1540232pjl.4;
        Tue, 29 Sep 2020 06:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Uejk8bq5YwYgJrQjV7qbZZOHir+mrgZTfhTCuObO9uk=;
        b=Tc3XP710csc641IUcjlFtSHxj7Il3FpT7AbGw3UVH7cfYZlekp+fDRLLTyxjkWxS+D
         sD3lFcyLx7G1PURmLk0jArG5dxyGe/5hmJPLFKPIspiAE0ppD73EXpMRPRar1L2mOxk8
         GvBJNBHRVZhHwmqchUVKokm5JGI9PLR6eXvzeuOgW4xVkyCdKxczpzSLVzhpX884U5IG
         makx5BIkPsWEkT6TNKXrt6VV/ozMKBRSQ81MEJjfjunAmSjzXlq6j7AROdPoaTlH0TfU
         nziqDTd613r+gs3QC8y4TAhUmIt0eENthtYR1u9soyWigLI6LjiFmz7mYF2r/2BlN2Yd
         6OlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Uejk8bq5YwYgJrQjV7qbZZOHir+mrgZTfhTCuObO9uk=;
        b=iWS3AvOYhz0y+SVEdZ/Tw+Gvz0FUOmQnFDu8nH0+lEOK6BN0WCsRgQcenxBBu1wlq9
         cKOvacAakb9X6u7jXnBfQ7YDzmCdDtAYN+iUuTSI6oPT9e1CtkRvGuDnr/XteH6+E/bO
         C+NF/WyJGjv5KR26x1leR12IrPh3vHdRHAMi4djKkrdYXxrJhSBGTOuS4GnRu/YGk/YS
         xejsl5gznAwDcpgDahzgKNdxPJt8Fjyunw8VwNcSR2tUt4wlV4ctvii/favCtLZQLQvt
         FEaYW+5uyJqV/Af1SE8hGhQQDGA/xCJdDPTRNW8WKWpK2IyFY4lipTBMzZtTJ0Z7q9mn
         IKmA==
X-Gm-Message-State: AOAM530hlzYx6U6yHvgLW7sAQC2ALs7ciAOO/7NMSbTafaBY4ce37Xs2
        xGnC/jAnun9UkdsGS9txpZFhX56YHMI=
X-Google-Smtp-Source: ABdhPJyXJush1XadIHr5opMPEgtl+N/tHFVW4aELBrVXGdgOzGUsfLsyVmYlp7gGyrMEXVB05QdL9g==
X-Received: by 2002:a17:90a:3984:: with SMTP id z4mr3832166pjb.131.1601387357111;
        Tue, 29 Sep 2020 06:49:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q4sm5582463pjl.28.2020.09.29.06.49.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:49:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP Encapsulation of SCTP
Date:   Tue, 29 Sep 2020 21:48:52 +0800
Message-Id: <cover.1601387231.git.lucien.xin@gmail.com>
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
      15: Enable this feature.

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

Xin Long (15):
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
  sctp: enable udp tunneling socks

 include/net/netns/sctp.h     |   8 +++
 include/net/sctp/constants.h |   2 +
 include/net/sctp/sctp.h      |   9 ++-
 include/net/sctp/sm.h        |   1 +
 include/net/sctp/structs.h   |  13 ++--
 include/uapi/linux/sctp.h    |   7 ++
 net/ipv4/udp.c               |   2 +-
 net/ipv4/udp_offload.c       |  16 +++--
 net/ipv6/udp.c               |   2 +-
 net/ipv6/udp_offload.c       | 154 +++++++++++++++++++++----------------------
 net/sctp/associola.c         |   4 ++
 net/sctp/ipv6.c              |  48 ++++++++++----
 net/sctp/output.c            |  22 +++----
 net/sctp/protocol.c          | 145 ++++++++++++++++++++++++++++++++++++----
 net/sctp/sm_make_chunk.c     |   1 +
 net/sctp/sm_statefuns.c      |   2 +
 net/sctp/socket.c            | 111 +++++++++++++++++++++++++++++++
 net/sctp/sysctl.c            |  53 +++++++++++++++
 18 files changed, 471 insertions(+), 129 deletions(-)

-- 
2.1.0

