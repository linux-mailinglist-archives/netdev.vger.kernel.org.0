Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7878E29A9F9
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418295AbgJ0Kpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:45:31 -0400
Received: from correo.us.es ([193.147.175.20]:37862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1417967AbgJ0KpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 06:45:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B47F9D164F
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:45:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A09B7DA7B9
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:45:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 964B0DA793; Tue, 27 Oct 2020 11:45:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA6B3DA78A;
        Tue, 27 Oct 2020 11:45:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Oct 2020 11:45:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9A11942EF42C;
        Tue, 27 Oct 2020 11:45:12 +0100 (CET)
Date:   Tue, 27 Oct 2020 11:45:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 0.9.7 release
Message-ID: <20201027104512.GA30322@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.9.7

This release contains fixes and new features available up to the Linux
kernel 5.10-rc1 release.

* Support for implicit chain, e.g.

  table inet x {
        chain y {
             type filter hook input priority 0;
             tcp dport 22 jump {
                    ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
                    ip6 saddr ::1/128 accept;
             }
        }
  }

  This allows you to group rules without the need for an explicit
  chain definition.

* Support for ingress inet chains:

    table inet filter {
            chain ingress {
                    type filter hook ingress device "veth0" priority filter; policy accept;
            }
            chain input {
                    type filter hook input priority filter; policy accept;
            }
            chain forward {
                    type filter hook forward priority filter; policy accept;
            }
    }

  The inet family supports the ingress hook since Linux kernel 5.10-rc1,
  to filter IPv4 and IPv6 packet at the same location as the netdev ingress
  hook. This inet hook allows you to share sets and maps between the usual
  prerouting, input, forward, output, postrouting and this ingress hook.

* Support for reject from prerouting chain:

  table inet x {
      chain y {
            type filter hook prerouting priority 0; policy accept;

            tcp dport 22 reject with tcp reset
      }
  }

* Support for --terse option in json

  # nft --terse -j list ruleset

* Display set counters in json

  # nft -j list set

* Support for the reset command with json, ie.

  # nft -j reset counters

* Match on wildcard socket listeners, eg.

  table inet x {
       chain y {
             type filter hook prerouting priority -150; policy accept;
             socket transparent 1 socket wildcard 0 mark set 0x00000001
       }
  }

* Get elements from maps:

  # nft get element inet filter test "{ 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x42 }"
  table inet filter {
        map test {
                type ipv4_addr . ether_addr . inet_service : mark
                flags interval,timeout
                elements = { 18.51.100.17 . ad:c1:ac:c0:ce:c0 . 3761 : 0x00000042 }
        }
  }

* Allow to specify comments in sets, eg.

   table ip x {
        set s {
                type ipv4_addr;
                comment "list of unwanted traffic by IP address"
                elements = { 1.1.1.1, 1.2.3.4 }
        }
   }

  You can also specify comments in tables and stateful objects (such
  as quota, limit and counters).

* Support for defining empty sets in variables:

  define BASE_ALLOWED_INCOMING_TCP_PORTS = {22, 80, 443}
  define EXTRA_ALLOWED_INCOMING_TCP_PORTS = {}

  table inet x {
       chain y {
            type filter hook input priority 0; policy drop;
            ct state new tcp dport { $BASE_ALLOWED_INCOMING_TCP_PORTS, $EXTRA_ALLOWED_INCOMING_TCP_PORTS } counter accept
       }
  }

* Allow to use variables in the log prefix string.

  define foo= "state"
  define bar = "match"

  table x {
        chain y {
            ct state invalid log prefix "invalid $foo $bar:"
        }
  }

* Allow to use variables in chain and flowtable definitions, e.g.

  define if_main = lo

  table netdev x {
        chain y {
            type filter hook ingress device $if_main priority -500; policy accept;
        }
  }

* Allow to define negative values in variables:

  define post = -10
  define for = "filter - 100"

  table inet global {
      chain forward {
          type filter hook prerouting priority $for
          policy accept
      }
      chain postrouting {
          type filter hook postrouting priority $post
          policy accept
      }
  }

* Improved error reporting on statements:

   # nft add rule x y jump test
   Error: Could not process rule: No such file or directory
   add rule x y jump test
                     ^^^^

   This error is displayed in case that the 'test' chain does not exist.

* Support for SCTP stateless NAT.

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.7

To build the code, libnftnl >= 1.1.8 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Have fun.

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-0.9.7.txt"

Arturo Borrero Gonzalez (1):
      nft: rearrange help output to group related options together

Balazs Scheidler (5):
      socket: add support for "wildcard" key
      src/scanner.l: fix whitespace issue for the TRANSPARENT keyword
      doc: added documentation on "socket wildcard"
      tests: added "socket wildcard" testcases
      tests: allow tests/monitor to use a custom nft executable

Devin Bayer (1):
      nft: migrate man page examples with `meter` directive to sets

Florian Westphal (9):
      doc: revisit meta/rt primary expressions and ct statement
      monitor: print "dormant" flag in monitor mode
      tests: extend existing dormat test case to catch a kernel bug
      evaluate: permit get element on maps
      netlink: fix concat range expansion in map case
      tests: extend 0043concatenated_ranges_0 to cover maps too
      nftables: dump raw element info from libnftnl when netlink debugging is on
      proto: add sctp crc32 checksum fixup
      segtree: copy expr data to closing element

Gopal Yadav (2):
      json: Combining --terse with --json has no effect
      Solves Bug 1462 - `nft -j list set` does not show counters

Jeremy Sowden (3):
      tests: py: add missing JSON output for ct test.
      tests: py: correct order of set elements in test JSON output.
      tests: py: add missing test JSON output for TCP flag tests.

Jindrich Makovicka (1):
      libnftables: avoid repeated command list traversal on errors

Jose M. Guisado Gomez (6):
      src: fix obj list output when reset command
      src: add comment support for set declarations
      src: add comment support when adding tables
      src: add comment support for objects
      parser_bison: fail when specifying multiple comments
      src: add comment support for chains

Pablo Neira Ayuso (45):
      src: Allow for empty set variable definition
      segtree: zap element statement when decomposing interval
      src: use expression to store the log prefix
      src: allow for variables in the log prefix string
      datatype: convert chain name from gmp value to string
      src: support for implicit chain bindings
      parser_bison: memleak in log prefix string
      evaluate: UAF in stmt_evaluate_log_prefix()
      tests: shell: chmod 755 testcases/chains/0030create_0
      src: allow to use variables in flowtable and chain devices
      evaluate: use evaluate_expr_variable() for chain policy evaluation
      tests: shell: remove check for reject from prerouting
      rule: flush set cache before flush command
      rule: missing map command expansion
      evaluate: replace variable expression by the value expression
      src: allow for negative value in variable definitions
      evaluate: bail out with concatenations and singleton values
      evaluate: flush set cache from the evaluation phase
      src: remove cache lookups after the evaluation phase
      evaluate: remove table from cache on delete table
      parser_bison: memleak symbol redefinition
      evaluate: memleak in invalid default policy definition
      evaluate: UAF in hook priority expression
      netlink_delinearize: transform binary operation to prefix only with values
      evaluate: disregard ct address matching without family
      segtree: memleaks in interval_map_decompose()
      src: cache gets out of sync in interactive mode
      src: add comment support for map too
      mergesort: unbreak listing with binops
      src: add expression handler hashtable
      src: add chain hashtable cache
      mergesort: find base value expression type via recursion
      mnl: larger receive socket buffer for netlink errors
      tests: py: flush log file output before running each command
      evaluate: remove one indent level in __expr_evaluate_payload()
      src: context tracking for multiple transport protocols
      src: ingress inet support
      doc: nft.8: describe inet ingress hook
      rule: larger number of error locations
      src: constify location parameter in cmd_add_loc()
      src: improve rule error reporting
      segtree: UAF in interval_map_decompose()
      monitor: do not print generation ID with --echo
      Revert "monitor: do not print generation ID with --echo"
      build: Bump version to v0.9.7

Phil Sutter (4):
      doc: Document notrack statement
      json: Expect refcount increment by json_array_extend()
      evaluate: Reject quoted strings containing only wildcard
      json: Fix memleak in set_dtype_json()

Stefano Brivio (5):
      tests: Run in separate network namespace, don't break connectivity
      tests: shell: Allow wrappers to be passed as nft command
      tests: 0043concatenated_ranges_0: Fix checks for add/delete failures
      tests: 0044interval_overlap_0: Repeat insertion tests with timeout
      tests: sets: Check rbtree overlap detection after tree rotations


--8t9RHnE3ZwKMSgU+--
