Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E373F1F3A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhHSRhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:37:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhHSRhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 13:37:12 -0400
Received: from netfilter.org (unknown [213.94.13.0])
        by mail.netfilter.org (Postfix) with ESMTPSA id 88C216002F;
        Thu, 19 Aug 2021 19:35:45 +0200 (CEST)
Date:   Thu, 19 Aug 2021 19:36:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.0 release
Message-ID: <20210819173626.GA1776@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.0

This release contains fixes, documentation updates and new features
available up to the Linux kernel 5.13 release, more specifically:

* Catch-all set element support: This allows users to define the
  special wildcard set element for anything else not defined in
  the set.

  table x {
        map blocklist {
                type ipv4_addr : verdict
                flags interval
                elements = { 192.168.0.0/16 : accept, 10.0.0.0/8 : accept, * : drop }
        }

        chain y {
                type filter hook prerouting priority 0; policy accept;
                ip saddr vmap @blocklist
        }
  }

  [ this feature is actually supported since 0.9.9, but it was not
    included in the previous release announcement. ]

* Define variables from the command line through --define:

  # cat test.nft
  table netdev x {
        chain y {
               type filter hook ingress devices = $dev priority 0; policy drop;
        }
  }
  # nft --define dev="{ eth0, eth1 }" -f test.nft

* Allow to use stateful expressions in maps:

  table inet filter {
       map portmap {
               type inet_service : verdict
               counter
               elements = { 22 counter packets 0 bytes 0 : jump ssh_input, * counter packets 0 bytes 0 : drop }
       }

       chain ssh_input {
       }

       chain wan_input {
               tcp dport vmap @portmap
       }

       chain prerouting {
               type filter hook prerouting priority raw; policy accept;
               iif vmap { "lo" : jump wan_input }
       }
  }

* Add command to list the netfilter hooks pipeline for a given packet
  family. If device is specified, then ingress path is also included.

     # nft list hooks ip device eth0
     family ip {
            hook ingress {
                    +0000000010 chain netdev x y [nf_tables]
                    +0000000300 chain inet m w  [nf_tables]
            }
            hook input {
                    -0000000100 chain ip a b [nf_tables]
                    +0000000300 chain inet m z [nf_tables]
            }
            hook forward {
                    -0000000225 selinux_ipv4_forward
                     0000000000 chain ip a c [nf_tables]
            }
            hook output {
                    -0000000225 selinux_ipv4_output
            }
            hook postrouting {
                    +0000000225 selinux_ipv4_postroute
            }
     }

* Allow to combine jhash, symhash and numgen expressions with the
  queue statement, to fan out packets to userspace queues via
  nfnetlink_queue.

  ... queue to symhash mod 65536
  ... queue flags bypass to numgen inc mod 65536
  ... queue to jhash oif . meta mark mod 32

  You can also combine it with maps, to select the userspace queue
  based on any other singleton key or concatenations:

  ... queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }

* Expand variable containing set into multiple mappings

  define interfaces = { eth0, eth1 }

  table ip x {
        chain y {
                type filter hook input priority 0; policy accept;
                iifname vmap { lo : accept, $interfaces : drop }
        }
 }
 # nft -f x.nft
 # nft list ruleset
 table ip x {
       chain y {
                type filter hook input priority 0; policy accept;
                iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
        }
 }

* Allow to combine verdict maps with interval concatenations

 # nft add rule x y tcp dport . ip saddr vmap { 1025-65535 . 192.168.10.2 : accept }

* Simplify syntax for NAT mappings. You can specify an IP range:

 ... snat to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }

 Or a specific IP and port.

 ... dnat to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }

  Or a combination of range of IP addresses and ports.

 ... dnat to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2-10.141.10.5 . 8888-8999 }

And bugfixes.

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.9

To build the code, libnftnl >= 1.2.0 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.0.txt"

Duncan Roe (1):
      build: get `make distcheck` to pass again

Florian Westphal (26):
      json: fix base chain output
      json: fix parse of flagcmp expression
      tests/py: fix error message
      json: catchall element support
      tests: py: update netdev reject test file
      tests: ct: prefer normal cmp
      tests: remove redundant test cases
      evaluate: remove anon sets with exactly one element
      tests: add test case for removal of anon sets with only a single element
      scanner: add list cmd parser scope
      src: add support for base hook dumping
      doc: add LISTING section
      json: tests: fix vlan.t cfi test case
      json: tests: add missing concat test case
      netlink_delinearize: add missing icmp id/sequence support
      payload: do not remove icmp echo dependency
      tests: add a icmp-reply only and icmpv6 id test cases
      evaluate: fix hash expression maxval
      parser: restrict queue num expressiveness
      src: add queue expr and flags to queue_stmt_alloc
      parser: add queue_stmt_compat
      parser: new queue flag input format
      src: queue: allow use of arbitrary queue expressions
      tests: extend queue testcases for new sreg support
      src: queue: allow use of MAP statement for queue number retrieval
      netlink_delinarize: don't check for set element if set is not populated

Kerin Millar (1):
      json: Print warnings to stderr rather than stdout

Pablo Neira Ayuso (59):
      statement: connlimit: remove extra whitespace in print function
      doc: nft: ct id does not allow for original|reply
      json: missing catchall expression stub with ./configure --without-json
      rule: rework CMD_OBJ_SETELEMS logic
      cmd: check for table mismatch first in error reporting
      netlink: quick sort array of devices
      src: add vlan dei
      evaluate: restore interval + concatenation in anonymous set
      evaluate: add set to cache once
      src: add xzalloc_array() and use it to allocate the expression hashtable
      src: replace opencoded NFT_SET_ANONYMOUS set flag check by set_is_anonymous()
      tests: shell: extend connlimit test
      tests: shell: cover split chain reference across tables
      evaluate: do not skip mapping elements
      evaluate: unbreak verdict maps with implicit map with interval concatenations
      evaluate: memleak in binary operation transfer to RHS
      netlink_delinearize: memleak in string netlink postprocessing
      segtree: memleak in error path of the set to segtree conversion
      netlink_delinearize: memleak when listing ct event rule
      parser_bison: memleak in osf flags
      rule: memleak of list of timeout policies
      evaluate: fix maps with key and data concatenations
      libnftables: fix memleak when first message in batch is used to report error
      parser_bison: string memleak in YYERROR path
      parser_bison: memleak in rate limit parser
      rule: obj_free() releases timeout state string
      cmd: incorrect table location in error reporting
      cmd: incorrect error reporting when table declaration exists
      netlink_delinearize: stmt and expr error path memleaks
      src: remove STMT_NAT_F_INTERVAL flags and interval keyword
      src: infer NAT mapping with concatenation from set
      src: support for nat with interval concatenation
      tests: py: extend coverage for dnat with classic range representation
      src: add --define key=value
      evaluate: fix inet nat with no layer 3 info
      libnftables: missing nft_ctx_add_var() symbol map update
      tests: py: add dnat to port without defining destination address
      parser_bison: missing initialization of ct timeout policy list
      parser_json: inconditionally initialize ct timeout list
      src: fix nft_ctx_clear_include_paths in libnftables.map
      src: expose nft_ctx_clear_vars as API
      parser_bison: stateful statement support in map
      parser_bison: parse number as reject icmp code
      src: promote 'reject with icmp CODE' syntax
      evaluate: error reporting for missing statements in set/map declaration
      tests: py: update new reject with icmp code syntax leftover
      tests: py: missing json update for numeric reject with icmp numeric
      expression: missing != in flagcmp expression print function
      netlink_linearize: incorrect netlink bytecode with binary operation and flags
      evaluate: disallow negation with binary operation
      tests: py: idempotent tcp flags & syn != 0 to tcp flag syn
      netlink_delinearize: skip flags / mask notation for singleton bitmask
      tests: py: tcp flags & (fin | syn | rst | ack) == syn
      tests: py: check more flag match transformations to compact syntax
      mnl: revisit hook listing
      tcpopt: bogus assertion on undefined options
      evaluate: expand variable containing set into multiple mappings
      netlink_delinearize: skip flags / mask notation for singleton bitmask again
      build: Bump version to v1.0.0

Phil Sutter (13):
      segtree: Fix segfault when restoring a huge interval set
      parser_bison: Fix for implicit declaration of isalnum
      parser_json: Fix for memleak in tcp option error path
      evaluate: Mark fall through case in str2hooknum()
      json: Drop pointless assignment in exthdr_expr_json()
      netlink: Avoid memleak in error path of netlink_delinearize_set()
      netlink: Avoid memleak in error path of netlink_delinearize_chain()
      netlink: Avoid memleak in error path of netlink_delinearize_table()
      netlink: Avoid memleak in error path of netlink_delinearize_obj()
      netlink_delinearize: Fix suspicious calloc() call
      rule: Fix for potential off-by-one in cmd_add_loc()
      tests: shell: Fix bogus testsuite failure with 100Hz
      tests/py: Make netns spawning more robust


--opJtzjQTFsWo+cga--
