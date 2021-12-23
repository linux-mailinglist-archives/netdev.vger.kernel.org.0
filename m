Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44047E585
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349000AbhLWPkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhLWPki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FC2C061401;
        Thu, 23 Dec 2021 07:40:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id j6so22816509edw.12;
        Thu, 23 Dec 2021 07:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VN5DjBldGlzDJVzdm42BGJQfYgB980z8sQ1pCGHh4HI=;
        b=c1RwKamPbwRltUar/a5GTleNsAX08BeOIarDk0+CVirHZdZhkXnmxpt4gKLwzyELt3
         cTLpvPF7aInLrCG6H75O19gnVDe8HMz9D6Y9Aty9p70eSjjdcziDXDHr8pv1pkiRu2Nx
         lwCag90FbYCDgeLU03eFdGAyRGYn3PDjpKY9Xt4DBcLd0oG80gHfWjYjHrMgb52rgBf8
         oJ6IXkuIdsmOkj+tDh1vIGt0gQiEshPqAYFa9mBizLqPP5juhYhgB2/60/Lhjz2SNmOc
         Gdq/BXEZonRwdX4jvlRYbR7P/KuYiqqeY7K307pgKkVVA4OBk8qC4x1MZbcnA16IM5IU
         +6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VN5DjBldGlzDJVzdm42BGJQfYgB980z8sQ1pCGHh4HI=;
        b=GSPy3JjKBvPHN5uz3uki4VeoN+g5apIQGewldRKlsfyuXJxKqRs0c+EvKDsXZMmT62
         JJBXsYxzlT2lL3weogr/jyuuEMPuEWUbU/q2DksPnTLQCS0NBH9ZMhKhj94kBbInzBTL
         5TMlUMRj62pcHfflsLkfOEMK1P+XBoP9IzqmrPLX8PdxbuNiz+hOsROq/dWD3+w+V9Ta
         f3G67WKAM4TxPhzAxhhkE3UrNoEI+hbOZGT3Rzu2G0EKneN8l2/Htn9QYvLrsZnhpA0z
         Prsru5F3try7YdkUuGIE9B/3BvaREQk+6GyHQzWr59zdgMscRh8vu5ymGb0XukQeRv5/
         ldGA==
X-Gm-Message-State: AOAM533zmxlz3+x9Nl4XbOgSov2YDuexbMyBW2Z1O85ibNTS92mDIHUj
        YM1Nfwz0ywpelQpgRRTHLKE=
X-Google-Smtp-Source: ABdhPJzXZrQwP+oHugkr/cOW2JSwZSrs+nFky72t4L5CcwNh+nkD0+SYPKB2aJTe+t8Bqsj26uqKTg==
X-Received: by 2002:a17:906:517:: with SMTP id j23mr2249808eja.453.1640274036518;
        Thu, 23 Dec 2021 07:40:36 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:35 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/19] tcp: Initial support for RFC5925 auth option
Date:   Thu, 23 Dec 2021 17:39:55 +0200
Message-Id: <cover.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to TCP-MD5 in functionality but it's sufficiently
different that packet formats and interfaces are incompatible.
Compared to TCP-MD5 more algorithms are supported and multiple keys
can be used on the same connection but there is still no negotiation
mechanism.

Expected use-case is protecting long-duration BGP/LDP connections
between routers using pre-shared keys. The goal of this series is to
allow routers using the Linux TCP stack to interoperate with vendors
such as Cisco and Juniper.

Both algorithms described in RFC5926 are implemented but the code is not
very easily extensible beyond that. In particular there are several code
paths making stack allocations based on RFC5926 maximum, those would
have to be increased. Support for arbitrary algorithms was requested
in reply to previous posts but I believe there is no real use case for
that.

The current implementation is somewhat loose regarding configuration:
* Overlaping MKTs can be configured despite what RFC5925 says
* Current key can be deleted. RFC says this shouldn't be allowed but
enforcing this belongs at an admin shell rather than in the kernel.
* If multiple keys are valid for a destination the kernel picks one
in an unpredictable manner (this can be overridden).

These conditions could be tightened but it is not clear the kernel
should spend effort to prevent misconfiguration from userspace.

The major change in this version is switching from per-socket to
per-netns keys. This is quite a large change and means that keys can
leak if not explicitly removed but the expected usecase is long-lived
routing daemon anyway. The fact that key management no longer needs
to be duplicate on listen sockets and active connection actually
simplifies them.

The TCP_AUTHOPT option still needs to be enabled for each individual
socket in order for AO keys to take effect.

Here are some known flaws and limitations:

* Crypto API is used with buffers on the stack and inside struct sock,
this might not work on all arches. I'm currently only testing x64 VMs
* Interaction with TCP-MD5 not tested in all corners.
* Interaction with FASTOPEN not tested and unlikely to work because
sequence number assumptions for syn/ack.
* No way to limit keys on a per-port basis (used to be implicit with
per-socket keys).
* Not clear if crypto_ahash_setkey might sleep. If some implementation
do that then maybe they could be excluded through alloc flags.
* Traffic key is not cached (reducing performance)
* No caching or hashing for key lookups so this will scale poorly with
many keys

There is relatively little code sharing with the TCP_MD5SIG feature and
earlier versions shared even less. Unlike MD5 the AO feature is kept
separate from the rest of the TCP code and reusing code would require
many unrelated cleanup changes.

I'm not convinced that "authopt" is particularly good naming convention,
this name is a personal invention that does not appear anywhere else.
The RFC calls this "tcp-ao". Perhaps TCP_AOSIG would be a better name
and it would also make the close connection to TCP_MD5SIG more visible?

Some testing support is included in nettest and fcnal-test.sh, similar
to the current level of tcp-md5 testing.

A more elaborate test suite using pytest and scapy is available out of
tree: https://github.com/cdleonard/tcp-authopt-test That test suite is
much larger that the kernel code and did not receive many comments in
previous ports so I will attempt to push it separately (if at all).

Changes for frr (old): https://github.com/FRRouting/frr/pull/9442
That PR was made early for ABI feedback, it has many issues.

Changes for yabgp (old): https://github.com/cdleonard/yabgp/commits/tcp_authopt
This can be used for easy interoperability testing with cisco/juniper/etc.
Would need updates for global keys to avoid leaks

Changes since PATCH v3:
* Made keys global (per-netns rather than per-sock).
* Add /proc/net/tcp_authopt with a table of keys (not sockets).
* Fix part of the shash/ahash conversion having slipped from patch 3 to patch 5
* Fix tcp_parse_sig_options assigning NULL incorrectly when both MD5 and AO
are disabled (kernel build robot)
* Fix sparse endianness warnings in prefix match (kernel build robot)
* Fix several incorrect RCU annotations reported by sparse (kernel build robot)
Link: https://lore.kernel.org/netdev/cover.1638962992.git.cdleonard@gmail.com/

Changes since PATCH v2:
* Protect tcp_authopt_alg_get/put_tfm with local_bh_disable instead of
preempt_disable. This caused signature corruption when send path executing
with BH enabled was interrupted by recv.
* Fix accepted keyids not configured locally as "unexpected". If any key
is configured that matches the peer then traffic MUST be signed.
* Fix issues related to sne rollover during handshake itself. (Francesco)
* Implement and test prefixlen (David)
* Replace shash with ahash and reuse some of the MD5 code (Dmitry)
* Parse md5+ao options only once in the same function (Dmitry)
* Pass tcp_authopt_info into inbound check path, this avoids second rcu
dereference for same packet.
* Pass tcp_request_socket into inbound check path instead of just listen
socket. This is required for SNE rollover during handshake and clearifies
ISN handling.
* Do not allow disabling via sysctl after enabling once, this is difficult
to support well (David)
* Verbose check for sysctl_tcp_authopt (Dmitry)
* Use netif_index_is_l3_master (David)
* Cleanup ipvx_addr_match (David)
* Add a #define tcp_authopt_needed to wrap static key usage because it looks
nicer.
* Replace rcu_read_lock with rcu_dereference_protected in SNE updates (Eric)
* Remove test suite
Link: https://lore.kernel.org/netdev/cover.1635784253.git.cdleonard@gmail.com/

Changes since PATCH v1:
* Implement Sequence Number Extension
* Implement l3index for vrf: TCP_AUTHOPT_KEY_IFINDEX as equivalent of
TCP_MD5SIG_FLAG_IFINDEX
* Expand TCP-AO tests in fcnal-test.sh to near-parity with md5.
* Show addr/port on failure similar to md5 
* Remove tox dependency from test suite (create venv directly)
* Switch default pytest output format to TAP (kselftest standard)
* Fix _copy_from_sockptr_tolerant stack corruption on short sockopts.
This was covered in test but error was invisible without STACKPROTECTOR=y
* Fix sysctl_tcp_authopt check in tcp_get_authopt_val before memset. This
was harmless because error code is checked in getsockopt anyway.
* Fix dropping md5 packets on all sockets with AO enabled
* Fix checking (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND) instead of
key->flags in tcp_authopt_key_match_exact
* Fix PATCH 1/19 not compiling due to missing "int err" declaration
* Add ratelimited message for AO and MD5 both present
* Export all symbols required by CONFIG_IPV6=m (again)
* Fix compilation with CONFIG_TCP_AUTHOPT=y CONFIG_TCP_MD5SIG=n
* Fix checkpatch issues
* Pass -rrequirements.txt to tox to avoid dependency variation.
Link: https://lore.kernel.org/netdev/cover.1632240523.git.cdleonard@gmail.com/

Changes since RFCv3:
* Implement TCP_AUTHOPT handling for timewait and reset replies. Write
tests to execute these paths by injecting packets with scapy
* Handle combining md5 and authopt: if both are configured use authopt.
* Fix locking issues around send_key, introduced in on of the later patches.
* Handle IPv4-mapped-IPv6 addresses: it used to be that an ipv4 SYN sent
to an ipv6 socket with TCP-AO triggered WARN
* Implement un-namespaced sysctl disabled this feature by default
* Allocate new key before removing any old one in setsockopt (Dmitry)
* Remove tcp_authopt_key_info.local_id because it's no longer used (Dmitry)
* Propagate errors from TCP_AUTHOPT getsockopt (Dmitry)
* Fix no-longer-correct TCP_AUTHOPT_KEY_DEL docs (Dmitry)
* Simplify crypto allocation (Eric)
* Use kzmalloc instead of __GFP_ZERO (Eric)
* Add static_key_false tcp_authopt_needed (Eric)
* Clear authopt_info copied from oldsk in __tcp_authopt_openreq (Eric)
* Replace memcmp in ipv4 and ipv6 addr comparisons (Eric)
* Export symbols for CONFIG_IPV6=m (kernel test robot)
* Mark more functions static (kernel test robot)
* Fix build with CONFIG_PROVE_RCU_LIST=y (kernel test robot)
Link: https://lore.kernel.org/netdev/cover.1629840814.git.cdleonard@gmail.com/

Changes since RFCv2:
* Removed local_id from ABI and match on send_id/recv_id/addr
* Add all relevant out-of-tree tests to tools/testing/selftests
* Return an error instead of ignoring unknown flags, hopefully this makes
it easier to extend.
* Check sk_family before __tcp_authopt_info_get_or_create in tcp_set_authopt_key
* Use sock_owned_by_me instead of WARN_ON(!lockdep_sock_is_held(sk))
* Fix some intermediate build failures reported by kbuild robot
* Improve documentation
Link: https://lore.kernel.org/netdev/cover.1628544649.git.cdleonard@gmail.com/
 
Changes since RFC:
* Split into per-topic commits for ease of review. The intermediate
commits compile with a few "unused function" warnings and don't do
anything useful by themselves.
* Add ABI documention including kernel-doc on uapi
* Fix lockdep warnings from crypto by creating pools with one shash for
each cpu
* Accept short options to setsockopt by padding with zeros; this
approach allows increasing the size of the structs in the future.
* Support for aes-128-cmac-96
* Support for binding addresses to keys in a way similar to old tcp_md5
* Add support for retrieving received keyid/rnextkeyid and controling
the keyid/rnextkeyid being sent.
Link: https://lore.kernel.org/netdev/01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com/

Leonard Crestez (19):
  tcp: authopt: Initial support and key management
  docs: Add user documentation for tcp_authopt
  tcp: authopt: Add crypto initialization
  tcp: md5: Refactor tcp_sig_hash_skb_data for AO
  tcp: authopt: Compute packet signatures
  tcp: authopt: Hook into tcp core
  tcp: authopt: Disable via sysctl by default
  tcp: authopt: Implement Sequence Number Extension
  tcp: ipv6: Add AO signing for tcp_v6_send_response
  tcp: authopt: Add support for signing skb-less replies
  tcp: ipv4: Add AO signing for skb-less replies
  tcp: authopt: Add key selection controls
  tcp: authopt: Add initial l3index support
  tcp: authopt: Add NOSEND/NORECV flags
  tcp: authopt: Add prefixlen support
  tcp: authopt: Add /proc/net/tcp_authopt listing all keys
  selftests: nettest: Rename md5_prefix to key_addr_prefix
  selftests: nettest: Initial tcp_authopt support
  selftests: net/fcnal: Initial tcp_authopt support

 Documentation/networking/index.rst        |    1 +
 Documentation/networking/ip-sysctl.rst    |    6 +
 Documentation/networking/tcp_authopt.rst  |   88 +
 include/linux/tcp.h                       |    9 +
 include/net/net_namespace.h               |    4 +
 include/net/netns/tcp_authopt.h           |   12 +
 include/net/tcp.h                         |   27 +-
 include/net/tcp_authopt.h                 |  323 ++++
 include/uapi/linux/snmp.h                 |    1 +
 include/uapi/linux/tcp.h                  |  137 ++
 net/ipv4/Kconfig                          |   14 +
 net/ipv4/Makefile                         |    1 +
 net/ipv4/proc.c                           |    1 +
 net/ipv4/sysctl_net_ipv4.c                |   39 +
 net/ipv4/tcp.c                            |   68 +-
 net/ipv4/tcp_authopt.c                    | 1799 +++++++++++++++++++++
 net/ipv4/tcp_input.c                      |   41 +-
 net/ipv4/tcp_ipv4.c                       |  138 +-
 net/ipv4/tcp_minisocks.c                  |   12 +
 net/ipv4/tcp_output.c                     |   86 +-
 net/ipv6/tcp_ipv6.c                       |  110 +-
 tools/testing/selftests/net/fcnal-test.sh |  329 +++-
 tools/testing/selftests/net/nettest.c     |  204 ++-
 23 files changed, 3364 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/networking/tcp_authopt.rst
 create mode 100644 include/net/netns/tcp_authopt.h
 create mode 100644 include/net/tcp_authopt.h
 create mode 100644 net/ipv4/tcp_authopt.c


base-commit: f4f2970dfd87e5132c436e6125148914596a9863
-- 
2.25.1

