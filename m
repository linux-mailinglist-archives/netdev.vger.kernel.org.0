Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F12F880F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbhAOWA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:00:28 -0500
Received: from correo.us.es ([193.147.175.20]:32820 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbhAOWA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 17:00:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A2721C4381
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 22:58:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ECE00DA78C
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 22:58:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E25D6DA78A; Fri, 15 Jan 2021 22:58:57 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BB5BDA72F;
        Fri, 15 Jan 2021 22:58:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Jan 2021 22:58:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1D40B42DF560;
        Fri, 15 Jan 2021 22:58:55 +0100 (CET)
Date:   Fri, 15 Jan 2021 22:59:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 0.9.8 release
Message-ID: <20210115215942.GA20205@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.9.8

This release contains fixes, documentation updates and new features
available up to the Linux kernel 5.11-rc1 release.

* Complete support for matching ICMP header content fields.

  ... icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
  ... icmpv6 type packet-too-big icmpv6 mtu 1280

* Add raw tcp option match support

  ... tcp option @42,16,4

  where you can specify @kind,offset,length

* Allow to check for the presence of any tcp option

  ... tcp option 42 exists

* Support for reject traffic from the ingress chain:

  table netdev x {
      chain y {
            type filter hook ingress device eth0 priority 0; policy accept;

            tcp dport 22 reject with tcp reset
      }
  }

* Optimized bytecode generation for prefix match

# nft --debug=netlink x y ip saddr 192.168.2.0/24
ip
  [ payload load 3b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x0002a8c0 ]

Resulting in two instructions instead of three (bitwise is removed on
byte-boundaries).

* Support for several statements per set element. The example below
  updates a set from the packet path (dynamic set), and it shows how
  to ratelimit first then count packets that go through per set element.

  table ip x {
       set y {
               type ipv4_addr
               size 65535
               flags dynamic,timeout
               timeout 1h
       }

       chain z {
               type filter hook output priority filter; policy accept;
               update @y { ip daddr limit rate 1/second counter }
       }
  }

  You can also use the multi-statement support for (non-dynamic) sets.

  table ip x {
       set y {
               type ipv4_addr
               limit rate 1/second counter
               elements = { 1.1.1.1, 4.4.4.4, 5.5.5.5 }
       }

       chain y {
               type filter hook output priority filter; policy accept;
               ip daddr @y
       }
  }

  In this case, you can add new elements from the control plane:

  # nft add element x y { 6.6.6.6 }

  which run the specified rate limit and counter statements.

  This requires a Linux kernel >= 5.11-rc1.

* editline support for nft -i (CLI), you can enable it at compile time:

        ./configure --with-cli=editline

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.8

To build the code, libnftnl >= 1.1.9 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-0.9.8.txt"

Florian Westphal (23):
      tests: json: add missing test case output
      tests: avoid warning and add missing json test cases
      json: add missing nat_type flag and netmap nat flag
      json: fix ip6 dnat test case after range to prefix transformation change
      parser: merge sack-perm/sack-permitted and maxseg/mss
      tcpopts: clean up parser -> tcpopt.c plumbing
      tcpopt: rename noop to nop
      tcpopt: split tcpopt_hdr_fields into per-option enum
      tcpopt: allow to check for presence of any tcp option
      tcp: add raw tcp option match support
      json: tcp: add raw tcp option match support
      exthdr: remove unused proto_key member from struct
      proto: reduce size of proto_desc structure
      src: add auto-dependencies for ipv4 icmp
      tests: fix exepcted payload of icmp expressions
      src: add auto-dependencies for ipv6 icmp6
      tests: fix exepcted payload of icmpv6 expressions
      payload: auto-remove simple icmp/icmpv6 dependency expressions
      tests: icmp, icmpv6: avoid remaining warnings
      tests: ip: add one test case to cover both id and sequence
      tests: icmp, icmpv6: check we don't add second dependency
      nft: trace: print packet unconditionally
      json: don't leave dangling pointers on hlist

Jeremy Sowden (3):
      doc: correct chain name in example of adding a rule
      tests: py: remove duplicate payloads.
      tests: py: update format of registers in bitwise payloads.

Jose M. Guisado Gomez (5):
      evaluate: add netdev support for reject default
      tests: py: add netdev folder and reject.t icmp cases
      src: enable json echo output when reading native syntax
      monitor: add assignment check for json_echo
      monitor: fix formatting of if statements

Pablo Neira Ayuso (19):
      tests: shell: exercise validation with nft -c
      parser_bison: allow to restore limit from dynamic set
      mnl: reply netlink error message might be larger than MNL_SOCKET_BUFFER_SIZE
      src: report EPERM for non-root users
      parser_bison: double close_scope() call for implicit chains
      tests: shell: timeouts later than 23 days
      build: search for python3
      src: add support for multi-statement in dynamic sets and maps
      src: add set element multi-statement support
      src: disallow burst 0 in ratelimits
      tests: shell: set element multi-statement support
      src: set on flags to request multi-statement support
      cli: add libedit support
      cli: use plain readline() interface with libedit
      main: fix typo in cli definition
      include: resync nf_tables.h cache copy
      segtree: honor set element expiration
      evaluate: disallow ct original {s,d}ddr from maps
      build: Bump version to v0.9.8

Phil Sutter (8):
      tests/shell: Improve fix in sets/0036add_set_element_expiration_0
      src: Support odd-sized payload matches
      src: Optimize prefix matches on byte-boundaries
      proto: Fix ARP header field ordering
      json: echo: Speedup seqnum_to_json()
      json: Fix seqnum_to_json() functionality
      doc: Document 'dccp type' match
      tests: py: Fix for changed concatenated ranges output


--AhhlLboLdkugWU4S--
