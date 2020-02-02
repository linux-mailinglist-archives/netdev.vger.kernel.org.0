Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573DD14FB54
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 04:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgBBDit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 22:38:49 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42386 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgBBDis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 22:38:48 -0500
Received: by mail-pg1-f194.google.com with SMTP id w21so89320pgl.9;
        Sat, 01 Feb 2020 19:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uV/djr6uE73WU9/ZzEdxqKkRdihnoCgbfPxx46DizKE=;
        b=cOQiAsVG1EfDqx5YWebjPSmGyGX5AJva6eYJpgNQPsZJHAEMnwytk8cDxnRAkl9JQ6
         M1ALHk42yzM7H3vnGDtLL5iS/D8+7s/uefI9kOdFSPrNdS12UvLsS/pCxDVWVtxPh+si
         KlRUiPA2CU53LmNeV+CYep2AmKThAUlDs06u+BM0987EWCbXiRU0r76tVBWewOyrHUKy
         wmRLIN2jNZee9GyEVgRv3jA/PCyL05ouLI+ue9p4v5Rl3eXGRyqUpezEmbF4OwpohEP1
         na3wSroImZCLPTJzQ3DQo5FL4QlPp+tzlvbK0234oL3pfXHeiHyV2rCk5IUn9aXO+jMt
         xyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uV/djr6uE73WU9/ZzEdxqKkRdihnoCgbfPxx46DizKE=;
        b=XIKa/RWKpZ0mbAj9YLn1UrecnkCbkho6stOT2HDnA+WS3lWLKtGE7ZlbEAxc/HhQ+A
         vh5vLZUlsa4skmFJJGqCG4PiRt6oOiMSvf1RjVFLM7jHXysZd0Ng+PlMK7n7anQSpUOK
         Gu+kF8Po7e5tl7TktEuL0lc24/MWZ0VMXOHilzNaYvSex3G0AU2lDVtT3OPDhtyXPoCo
         N6sEOX3D7IDavJGMkATQ64q68aTIA0W1E0vqdAWQg9mVcFZW4DTbZQvW7VojfOYF+Rb6
         1/3tuie8+odDDW4UyMhQMxM9jNYDBlpKHjG1SAxOc3BOxzotMhOh9r2+H3LiG0GynXgl
         kdoA==
X-Gm-Message-State: APjAAAU4gNJv9zNoRbWL1dIDOMFrBb/Od+sVWfLMt6Hkt8ogT47YkP13
        ZxVX/Cg5V3mfFFA1VMrCys4=
X-Google-Smtp-Source: APXvYqwxKgtiDNUrrNBcqjVjJDNBbL/jBOqTGjiv0BzqG2xWSjGEoyn32acwpqr/HWA93K9B65WAkg==
X-Received: by 2002:a63:646:: with SMTP id 67mr1493064pgg.376.1580614727920;
        Sat, 01 Feb 2020 19:38:47 -0800 (PST)
Received: from localhost.localdomain ([116.84.110.10])
        by smtp.gmail.com with ESMTPSA id iq22sm15705334pjb.9.2020.02.01.19.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 19:38:47 -0800 (PST)
From:   sj38.park@gmail.com
To:     edumazet@google.com
Cc:     sj38.park@gmail.com, David.Laight@aculab.com, aams@amazon.com,
        davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        shuah@kernel.org, sjpark@amazon.de
Subject: [PATCH v3 0/2] Fix reconnection latency caused by FIN/ACK handling race
Date:   Sun,  2 Feb 2020 03:38:25 +0000
Message-Id: <20200202033827.16304-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

When closing a connection, the two acks that required to change closing
socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
reverse order.  This is possible in RSS disabled environments such as a
connection inside a host.

For example, expected state transitions and required packets for the
disconnection will be similar to below flow.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 		<--ACK---
	 07 FIN_WAIT_2
	 08 		<--FIN/ACK---
	 09 TIME_WAIT
	 10 		---ACK-->
	 11 					LAST_ACK
	 12 CLOSED				CLOSED

In some cases such as LINGER option applied socket, the FIN and FIN/ACK will be
substituted to RST and RST/ACK, but there is no difference in the main logic.

The acks in lines 6 and 8 are the acks.  If the line 8 packet is
processed before the line 6 packet, it will be just ignored as it is not
a expected packet, and the later process of the line 6 packet will
change the status of Process A to FIN_WAIT_2, but as it has already
handled line 8 packet, it will not go to TIME_WAIT and thus will not
send the line 10 packet to Process B.  Thus, Process B will left in
CLOSE_WAIT status, as below.

	 00 (Process A)				(Process B)
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 				(<--ACK---)
	 07	  			(<--FIN/ACK---)
	 08 				(fired in right order)
	 09 		<--FIN/ACK---
	 10 		<--ACK---
	 11 		(processed in reverse order)
	 12 FIN_WAIT_2

Later, if the Process B sends SYN to Process A for reconnection using
the same port, Process A will responds with an ACK for the last flow,
which has no increased sequence number.  Thus, Process A will send RST,
wait for TIMEOUT_INIT (one second in default), and then try
reconnection.  If reconnections are frequent, the one second latency
spikes can be a big problem.  Below is a tcpdump results of the problem:

    14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644
    14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512
    14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298
    /* ONE SECOND DELAY */
    15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644

Patchset Organization
---------------------

The first patch fixes the problem by adjusting the first resend delay of
the SYN in the case.  The second one adds a user space test to reproduce
this problem.

The patches are based on the v5.5.  You can also clone the complete git
tree:

    $ git clone git://github.com/sjp38/linux -b patches/finack_lat/v3

The web is also available:
https://github.com/sjp38/linux/tree/patches/finack_lat/v3


Patchset History
----------------

From v2
(https://lore.kernel.org/linux-kselftest/20200201071859.4231-1-sj38.park@gmail.com/)
 - Use TCP_TIMEOUT_MIN as reduced delay (Neal Cardwall)
 - Add Reviewed-by and Signed-off-by from Eric Dumazet

From v1
(https://lore.kernel.org/linux-kselftest/20200131122421.23286-1-sjpark@amazon.com/)
 - Drop the trivial comment fix patch (Eric Dumazet)
 - Limit the delay adjustment to only the first SYN resend (Eric Dumazet)
 - selftest: Avoid use of hard-coded port number (Eric Dumazet)
 - Explain RST/ACK and FIN/ACK has no big difference (Neal Cardwell)

SeongJae Park (2):
  tcp: Reduce SYN resend delay if a suspicous ACK is received
  selftests: net: Add FIN_ACK processing order related latency spike
    test

 net/ipv4/tcp_input.c                       |   8 +-
 tools/testing/selftests/net/.gitignore     |   1 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/fin_ack_lat.c  | 151 +++++++++++++++++++++
 tools/testing/selftests/net/fin_ack_lat.sh |  35 +++++
 5 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/fin_ack_lat.c
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh

-- 
2.17.1

