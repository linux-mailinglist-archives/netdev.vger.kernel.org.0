Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F74455CBA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhKRNfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:35:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:35670 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhKRNfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:35:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 63C66649C7;
        Thu, 18 Nov 2021 14:30:16 +0100 (CET)
Date:   Thu, 18 Nov 2021 14:32:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.1 release
Message-ID: <YZZV42ERgpDbk/zL@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FkOIYs09g3NxOPaL"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FkOIYs09g3NxOPaL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.1

This release contains new features available up to the Linux kernel
5.16-rc1 release:

* Reduce memory footprint when loading large sets/maps.
* Speed up reload of large sets/maps.
* Speed up listing of specific tables in large ruleset, eg. large ruleset
  with ~100k lines.

     # nft list ruleset &> /dev/null
     real    0m3,049s
     user    0m2,080s
     sys     0m0,968s

    - Listing per table is now faster:

     # nft list table nat &> /dev/null
     real    0m1,969s
     user    0m1,412s
     sys     0m0,556s

     # nft list table filter &> /dev/null
     real    0m0,697s
     user    0m0,478s
     sys     0m0,220s

  Same speed up applies to listing specific chains/sets/maps.

* Speed up --terse option when listing a ruleset large sets/maps.
* Print raw payload expression in hexadecimal, eg. @ll,0,8 & 0x80 == 0x80

* egress hook support (available since 5.16-rc1).

  table netdev filter {
        chain egress {
                type filter hook egress devices = { eth0, eth1 } priority 0;
                meta priority set ip saddr map { 192.168.10.2 : abcd:2, 192.168.10.3 : abcd:3 }
        }
  }

* Allow to match and update bytes at inner header/payload offset
  (available  since 5.16-rc1).

  # nft add rule x y @ih,32,32 0x14000000 counter
  # nft add rule x y @ih,32,32 set 0x14000000 counter

... and fixes:

- Fix split declaration of set accross different files using the
  nested notation.
- Fix crash in python support with two instances of nftables handler.
- Fix incorrect range to prefix conversion.
- Fix -T/--numeric-time
- Incorrect meta protocol dependency removal in bridge, netdev and
  inet families.
- Unbreak support for older kernels (tested with Linux kernel 4.9.x)
- Optimize prefix match only for matching on big-endian.
- Restore use of variables with queue statement, eg. queue num $myq bypass
- Honor insert command and rule position handle in monitor mode.
- Bogus error in dynamic NAT map, eg.
- Disallow setuid on the nft executable.

  #nft add rule nat x y meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th

- Fix combination of map, concatenation with intervals and stateful
  expressions, eg.

  table ip filter {
       map forwport {
               type ipv4_addr . inet_proto . inet_service : verdict
               flags interval
               counter
               elements = { 10.133.89.138 . tcp . 8081 counter packets 0 bytes 0 : accept }
       }

       chain FORWARD {
               type filter hook forward priority filter; policy drop;
               iifname "enp0s8" ip daddr . ip protocol . th dport vmap @forwport counter
       }
  }

- Fix incorrect vlan offset when matching and updating tag, eg.

  # nft add rule bridge filter forward vlan id 100 vlan id set 200

- Fix use of constant in dynamic set, eg.

  table inet t {
       set s {
               type ipv4_addr . inet_service
               size 65536
               flags dynamic,timeout
               elements = { 192.168.7.1 . 22 }
       }

       chain c {
               type filter hook input priority 0;
               tcp dport 21 add @s { ip saddr . 22 timeout 1m }
       }
  }

... and incremental documentation updates.

The autotools build system now defaults to libedit/editline for the
nft --interactive shell.

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.2.1 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--FkOIYs09g3NxOPaL
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.1.txt"
Content-Transfer-Encoding: 8bit

Chris Arges (1):
      cache: ensure evaluate_cache_list flags are set correctly

Duncan Roe (1):
      doc: libnflog handles `log group`, not libnfq

Florian Westphal (7):
      parser: permit symbolic define for 'queue num' again
      payload: don't adjust offsets of autogenerated dependency expressions
      netlink: dynset: set compound expr dtype based on set key definition
      tests: shell: auto-removal of chain hook on netns removal
      main: _exit() if setuid
      doc: update ct timeout section with the state names
      monitor: do not call interval_map_decompose() for concat intervals

Jeremy Sowden (6):
      rule: remove fake stateless output of named counters
      rule: fix stateless output after listing sets containing counters
      rule: replace three conditionals with one
      parser: add new `limit_bytes` rule
      parser: add `limit_rate_pkts` and `limit_rate_bytes` rules
      parser: extend limit syntax

Lukas Wunner (2):
      tests: py: Move netdev-specific tests to appropriate subdirectory
      src: Support netdev egress hook

Pablo Neira Ayuso (54):
      src: queue: consolidate queue statement syntax
      tests: shell: add nft-f/0022variables_0 dump file
      cache: skip set element netlink dump for add/delete element command
      cache: provide a empty list for flowtables and objects when request fails
      netlink_delinearize: incorrect meta protocol dependency kill
      netlink_delinearize: incorrect meta protocol dependency kill again
      rule: remove redundant meta protocol from the evaluation step
      datatype: time_print() ignores -T
      include: add NFT_CTX_OUTPUT_NUMERIC_TIME to NFT_CTX_OUTPUT_NUMERIC_ALL
      doc: Missing NFT_CTX_OUTPUT_NUMERIC_SYMBOL in libnftables documentation
      doc: refer to ulogd manpage
      meta: skip -T for hour and date format
      netlink: rework range_expr_to_prefix()
      doc: nfnetlink_log allows one single process through unicast
      src: revert hashtable for expression handlers
      tests: py: update ct expiration
      doc: fix synopsis of named counter, quota and ct {helper,timeout,expect}
      netlink: reset temporary set element stmt list after list splice
      monitor: display rule position handle
      monitor: honor NLM_F_APPEND flag for rules
      tests: monitor: update insert and replace commands
      monitor: honor NLM_F_EXCL netlink flag
      evaluate: check for concatenation in set data datatype
      evaluate: check for missing transport protocol match in nat map with concatenations
      cache: set on cache flags for nested notation
      cache: finer grain cache population for list commands
      cache: filter out tables that are not requested
      cache: filter out sets and maps that are not requested
      cache: unset NFT_CACHE_SETELEM with --terse listing
      configure: default to libedit for cli
      cache: always set on NFT_CACHE_REFRESH for listing
      cache: honor filter in set listing commands
      cache: honor table in set filtering
      cache: disable NFT_CACHE_SETELEM_BIT on --terse listing only
      tests: shell: add testcase for --terse
      evaluate: postpone transport protocol match check after nat expression evaluation
      datatype: add xinteger_type alias to print in hexadecimal
      src: raw payload match and mangle on inner header / payload data
      tests: py: remove verdict from closing end interval
      mnl: do not build nftnl_set element list
      evaluate: clone variable expression if there is more than one reference
      evaluate: grab reference in set expression evaluation
      tests: py: update rawpayload.t.json
      cache: move list filter under struct
      cache: do not populate cache if it is going to be flushed
      cache: missing family in cache filtering
      cache: filter out rules by chain
      tests: py: missing ip/dnat.t json updates
      tests: py: missing ip/snat.t json updates
      tests: py: missing json output update in ip6/meta.t
      tests: py: remove netdev coverage in ip/ip_tcp.t
      parser: allow for string raw payload base
      parser_json: add raw payload inner header match support
      build: Bump version to 1.0.1

Phil Sutter (5):
      tests: json_echo: Print errors to stderr
      tests: monitor: Print errors to stderr
      tests: monitor: Continue on error
      parser_json: Fix error reporting for invalid syntax
      tests: shell: Fix bogus testsuite failure with 250Hz

Xiao Liang (2):
      src: Optimize prefix match only if is big-endian
      src: Check range bounds before converting to prefix

Štěpán Němec (7):
      doc: libnftables-json: make the example valid libnftables JSON input
      tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")
      tests: run-tests.sh: ensure non-zero exit when $failed != 0
      tests: shell: README: copy edit
      tests: shell: README: $NFT does not have to be a path to a binary
      tests: shell: README: clarify test file name convention
      tests: shell: $NFT needs to be invoked unquoted


--FkOIYs09g3NxOPaL--
