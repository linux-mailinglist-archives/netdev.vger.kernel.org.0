Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE97C2D462F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732372AbgLIP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:57:40 -0500
Received: from david.siemens.de ([192.35.17.14]:58483 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730402AbgLIP5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 10:57:36 -0500
Received: from mail1.siemens.de (mail1.siemens.de [139.23.33.14])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id 0B9EbMbS007438
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 15:37:22 +0100
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.34])
        by mail1.siemens.de (8.15.2/8.15.2) with ESMTP id 0B9EbGp0002581;
        Wed, 9 Dec 2020 15:37:16 +0100
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Mao Wenan <maowenan@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Ines Molzahn <ines.molzahn@siemens.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: [PATCH 0/3] Add sending TX hardware timestamp for TC ETF Qdisc
Date:   Wed,  9 Dec 2020 15:37:03 +0100
Message-Id: <20201209143707.13503-1-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for TX sending hardware timestamp with
 Traffic control Earliest TxTime First (ETF) Qdisc.

Why do we need additional timestamp?
Current ETF requires to synchronization the system clock
to the PTP Hardware clock (PHC) we want to send through.
But there are cases that we can not synchronize the system clock with
the desired NIC PHC.
1. We use several NICs with several PTP domains that our device
   is not allowed to be PTP master of.
2. We are using another clock source which we need for our system.
   Yet our device is not allowed to be PTP master.

Regardless of the exact topology, as the Linux tradition is to allow
the user the freedom to choose,
we propose a patch that will add a hardware timestamp to the packet.
The TC-ETF will use the first timestamp and compare it with
the system clock while send the packet to the network interface driver
with that hardware timestamp that is correlated with the PHC.

Note 1: we do encourage the users to synchronize the system clock with
  a PTP clock. Synchronizing the system clock with a PTP clock will
  reduce the frequency difference of the PHC and the system clock,
  increase the accurecy and may enable the user to reduce the ETF delta.

Note 2: In our network usage models sending a frame has to be very
  precise in relation to the PHC. Our user application does have
  the exact send time as of PHC perspective so it is able
  to provide the hw timestamp.

Note 3: The user can estimate the clocks conversion error done
  in the user application and add it to the delta setting of the ETF.

The patches contain:
 1. A new flag for the SO_TXTIME socket option.
 2. A new cmsg header, SCM_HW_TXTIME to pass the TX hardware timestamp.
 3. Add the hardware timestamp to the socket cookie and to the inet cork.
 4. As ETF Qdisc is irrelevant to TCP, ignore the TCP.
 5. A new flag to the ETF Qdisc setting that mandate
    the use of the hardware timestamp in the SKB.
 6. The ETF sort packets according to hardware timestamp,
    Yet pass the packet to network interface driver based
    on the system clock timestamp.

Note 4: The socket buffer hardware timestamp is used by
      the network interface driver to send the actual sending timestamp
      back to the application. The timestamp is used by the TC ETF
      before the socket buffer arrives in the network interface driver.

Erez Geva (3):
  Add TX sending hardware timestamp.
  Pass TX sending hardware timestamp to a socket's buffer.
  The TC ETF Qdisc pass the hardware timestamp to the interface driver.

 include/net/inet_sock.h           |  1 +
 include/net/sock.h                |  2 ++
 include/uapi/asm-generic/socket.h |  3 ++
 include/uapi/linux/net_tstamp.h   |  3 +-
 include/uapi/linux/pkt_sched.h    |  1 +
 net/core/sock.c                   |  9 +++++
 net/ipv4/ip_output.c              |  2 ++
 net/ipv4/raw.c                    |  1 +
 net/ipv6/ip6_output.c             |  2 ++
 net/ipv6/raw.c                    |  1 +
 net/packet/af_packet.c            |  3 ++
 net/sched/sch_etf.c               | 59 +++++++++++++++++++++++++------
 12 files changed, 75 insertions(+), 12 deletions(-)


base-commit: b65054597872ce3aefbc6a666385eabdf9e288da
-- 
2.20.1

