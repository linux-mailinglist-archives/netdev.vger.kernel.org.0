Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B716014F703
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBAHTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:19:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35860 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgBAHTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 02:19:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so11301264wru.3;
        Fri, 31 Jan 2020 23:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=a4YGHjeW+FS/gT2mdKHcX4rSVsghU4AOTnAqHzu5t/M=;
        b=JU5GJgKpZqNt0ibU6XmAhK5HF2roAL0W8JhEZib2PXLJaHFwokT/hLqj47A/0LOiPm
         i/JgsDirW6qWcYNJiZSBgditteM3QQvf1c+ZZhrInn4Y1Fgy+qvew3imCN7h2wvFqaze
         nGhnsh3HeiSsqH9lcfXqfxfR8F1laOB1R77kLrJdp+k85pU8rIzyrwCKtgw+hHkG0FvN
         eYo32SyRtvz83/K8jR+sRTltl/yAgBFefb7ZZtAo4nEedgHJMWdoEPXA4BeM3B9fUmyU
         RkqZS7oaeUl9ZUHPWaZu6MJisNRweNs0IjwmsaM9XjxTOzS0hW83el45SVeKiZwxh1Oh
         d4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=a4YGHjeW+FS/gT2mdKHcX4rSVsghU4AOTnAqHzu5t/M=;
        b=p90WhIgBBH4f0RWpCNWMQaEZn469lUSnTyqR0HdN8CLJ+SCwVSBRfNyCUF0/nDWgZc
         w47EGrdXZuz61E/RVynca/dpjdQcmMwsK07ROzE6OjUu1uHqe3Wg96niARAvJuQBsMrX
         Jpw+UiKaTzHctnXN8Qp2Up69AALUJHpUBeflTlUrJrAhJrNjh3DogZGD6kyYwihCkMS8
         7OvRdjry3jJY+/WseLjNXSl+7HL7syPKbHzfKUcrcyEFZXbPysIxTD8zTCxkwgQ4X5M+
         WHZJhq+dUbSzNn+8QbEGuaXnI++Cs8YtKoJv289jZ2h+a68V+E11JOOZyL2chr6heUFO
         3UDA==
X-Gm-Message-State: APjAAAXE5z5lZv6/uSgpiqjSPq/9pEqIFlRQM63t+OVWG7KQp+uqcSkF
        zkT+F6s3MRQumLozasCoK7E=
X-Google-Smtp-Source: APXvYqzZKs/K8Aj7nj0oTwd+arbpby0UnG1bOyQp6Sxt92+Dfkn+Zca5Fh+4+dKrbxgPmhpNwfFU6Q==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr3092900wrs.200.1580541550762;
        Fri, 31 Jan 2020 23:19:10 -0800 (PST)
Received: from localhost.localdomain (cable-158-181-93-24.cust.telecolumbus.net. [158.181.93.24])
        by smtp.gmail.com with ESMTPSA id o4sm664286wrw.15.2020.01.31.23.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 23:19:10 -0800 (PST)
From:   sj38.park@gmail.com
To:     eric.dumazet@gmail.com, edumazet@google.com
Cc:     davem@davemloft.net, aams@amazon.com, ncardwell@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org, ycheng@google.com,
        David.Laight@ACULAB.COM, sj38.park@gmail.com,
        SeongJae Park <sjpark@amazon.de>
Subject: [PATCH v2 0/2] Fix reconnection latency caused by FIN/ACK handling race
Date:   Sat,  1 Feb 2020 07:18:57 +0000
Message-Id: <20200201071859.4231-1-sj38.park@gmail.com>
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

    $ git clone git://github.com/sjp38/linux -b patches/finack_lat/v2

The web is also available:
https://github.com/sjp38/linux/tree/patches/finack_lat/v2


Patchset History
----------------

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
 tools/testing/selftests/net/.gitignore     |   2 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/fin_ack_lat.c  | 151 +++++++++++++++++++++
 tools/testing/selftests/net/fin_ack_lat.sh |  35 +++++
 5 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/fin_ack_lat.c
 create mode 100755 tools/testing/selftests/net/fin_ack_lat.sh

-- 
2.17.1

