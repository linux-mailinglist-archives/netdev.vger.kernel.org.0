Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A9019ADDA
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgDAObV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:31:21 -0400
Received: from correo.us.es ([193.147.175.20]:59574 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733036AbgDAObV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 10:31:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DAE9F2591
        for <netdev@vger.kernel.org>; Wed,  1 Apr 2020 16:31:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76C4F132C8A
        for <netdev@vger.kernel.org>; Wed,  1 Apr 2020 16:31:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B7DD132C87; Wed,  1 Apr 2020 16:31:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1E3E132C88;
        Wed,  1 Apr 2020 16:31:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 16:31:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A06BB4301DE1;
        Wed,  1 Apr 2020 16:31:14 +0200 (CEST)
Date:   Wed, 1 Apr 2020 16:31:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, lwn@lwn.net
Subject: [ANNOUNCE] nftables 0.9.4 release
Message-ID: <20200401143114.yfdfej6bldpk5inx@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ozz3egdkljbuonck"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ozz3egdkljbuonck
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi!

The Netfilter project proudly presents:

        nftables 0.9.4

This release contains fixes and new features available up to the Linux
kernel 5.6 release.

* Support for ranges in concatenations (requires Linux kernel >= 5.6),
  e.g.

    table ip foo {
           set whitelist {
                   type ipv4_addr . ipv4_addr . inet_service
                   flags interval
                   elements = { 192.168.10.35-192.168.10.40 . 192.68.11.123-192.168.11.125 . 80 }
           }

           chain bar {
                   type filter hook prerouting priority filter; policy drop;
                   ip saddr . ip daddr . tcp dport @whitelist accept
           }
    }

  This creates a `whitelist' set whose elements are a concatenation.
  The interval flag specifies that this set might include ranges in
  concatenations. The example above is accepting all traffic coming
  from 192.168.10.35 to 192.168.10.40 (both addresses in the range
  are included), destination to 192.68.10.123 and TCP destination
  port 80.

* typeof support for sets. You can use typeof to specify the datatype
  of the selector in sets, e.g.

     table ip foo {
            set whitelist {
                    typeof ip saddr
                    elements = { 192.168.10.35, 192.168.10.101, 192.168.10.135 }
            }

            chain bar {
                    type filter hook prerouting priority filter; policy drop;
                    ip daddr @whitelist accept
            }
     }

  You can also use typeof in maps:

     table ip foo {
            map addr2mark {
                typeof ip saddr : meta mark
                elements = { 192.168.10.35 : 0x00000001, 192.168.10.135 : 0x00000002 }
            }
     }

* NAT mappings with concatenations. This allows you to specify the address
  and port to be used in the NAT mangling from maps, eg.

      nft add rule ip nat pre dnat ip addr . port to ip saddr map { 1.1.1.1 : 2.2.2.2 . 30 }

  You can also use this new feature with named sets:

      nft add map ip nat destinations { type ipv4_addr . inet_service : ipv4_addr . inet_service \; }
      nft add rule ip nat pre dnat ip addr . port to ip saddr . tcp dport map @destinations

* Hardware offload support: Your nic driver must include support for this
  infrastructure. You have to enable offload via ethtool:

     # ethtool -K eth0 hw-tc-offload on

  Then, in nftables, you have to turn on the offload flag in the basechain
  definition.

     # cat file.nft
     table netdev x {
            chain y {
                type filter hook ingress device eth0 priority 10; flags offload;
                ip saddr 192.168.30.20 drop
            }
     }
     # nft -f file.nft

  Just a simple example to drop all traffic coming from 192.168.30.20
  from the hardware. The Linux host see no packets at all from
  192.168.30.20 after this since the nic filters out the packets.

  As of kernel 5.6, supported features are:

  - Matching on:
    -- packet header fields.
    -- input interface.

  - Actions available are:
    -- accept / drop action.
    -- Duplicate packet to port through `dup'.
    -- Mirror packet to port through `fwd'.

* Enhancements to improve location-based error reporting, e.g.

     # nft delete rule ip y z handle 7
     Error: Could not process rule: No such file or directory
     delete rule ip y z handle 7
                    ^

  In this example above, the table `y' does not exist in your system.

     # nft delete rule ip x x handle 7
     Error: Could not process rule: No such file or directory
     delete rule ip x x handle 7
                               ^

  This means that rule handle 7 does not exist.

     # nft delete table twst
     Error: No such file or directory; did you mean table ‘test’ in family ip?
     delete table twst
                  ^^^^

  If you delete a table whose name has been mistyped, error reporting
  includes a suggestion.

* Match on the slave interface through `meta sdif' and `meta
  sdifname', e.g.

        ... meta sdifname vrf1 ...

* Support for right and left shifts:

        ... meta mark set meta mark lshift 1 or 0x1 ...

  This example shows how to shift one bit left the existing packet
  mark and set the less significant bit to 1.

* New -V option to display extended version information, including
  compile time options:

     # nft -V
       nftables v0.9.4 (Jive at Five)
          cli:          readline
          json:         yes
          minigmp:      no
          libxtables:   yes

* manpage documentation updates.

* ... and bugfixes.

See ChangeLog that comes attached to this email for more details.

= Caveat =

This new version enforces options before commands, ie.

     # nft list ruleset -a
     Error: syntax error, options must be specified before commands
     nft list ruleset -a
        ^             ~~

Just place the option before the command:

     # nft -a list ruleset
     ... [ ruleset listing here ] ...

Make sure to update your scripts.

You can download this new release from:

http://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.4
ftp://ftp.netfilter.org/pub/nftables/

To build the code, libnftnl 1.1.6 and libmnl >= 1.0.3 are required:

* http://netfilter.org/projects/libnftnl/index.html
* http://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* http://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--ozz3egdkljbuonck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-nftables-0.9.4.txt"

Arturo Borrero Gonzalez (1):
      py: load the SONAME-versioned shared object

Benjamin Poirier (1):
      doc: Fix typo in IGMP section

Duncan Roe (1):
      doc: Clarify conditions under which a reject verdict is permissible

Florian Westphal (22):
      parser: add a helper for concat expression handling
      src: store expr, not dtype to track data in sets
      src: add "typeof" build/parse/print support
      mnl: round up the map data size too
      tests: add typeof test cases
      evaluate: print a hint about 'typeof' syntax on 0 keylen
      doc: mention 'typeof' as alternative to 'type' keyword
      meta: add slave device matching
      xfrm: spi is big-endian
      src: maps: update data expression dtype based on set
      evaluate: print correct statement name on family mismatch
      tests: 0034get_element_0: do not discard stderr
      tests: shell: avoid spurious failure when running in host namespace
      expression: use common code for expr_ops/expr_ops_by_type
      tests: add initial nat map test
      evaluate: process concat expressions when used as mapped-to expr
      netlink: handle concatenations on set elements mappings
      evaluate: add two new helpers
      src: allow nat maps containing both ip(6) address and port
      tests: nat: add and use maps with both address and service
      expressions: concat: add typeof support
      tests: update nat_addr_port with typeof+concat maps

Jan Engelhardt (1):
      src: compute mnemonic port name much easier

Jeremy Sowden (28):
      evaluate: fix expr_set_context call for shift binops.
      include: nf_tables: correct bitwise header comment.
      Update gitignore.
      src: white-space fixes.
      netlink_delinearize: fix typo.
      netlink_delinearize: remove commented out pr_debug statement.
      include: update nf_tables.h.
      netlink: add support for handling shift expressions.
      parser: add parenthesized statement expressions.
      evaluate: correct variable name.
      evaluate: change shift byte-order to host-endian.
      tests: shell: add bit-shift tests.
      tests: py: add missing JSON output.
      tests: py: add bit-shift tests.
      evaluate: add separate variables for lshift and xor binops.
      evaluate: simplify calculation of payload size.
      evaluate: don't evaluate payloads twice.
      evaluate: convert the byte-order of payload statement arguments.
      evaluate: no need to swap byte-order for values of fewer than 16 bits.
      netlink_delinearize: set shift RHS byte-order.
      src: fix leaks.
      main: add more information to `nft -V`.
      main: remove duplicates from option string.
      parser_bison: fix rshift statement expression.
      main: include '-d' in help.
      main: include '--reversedns' in help.
      main: interpolate default include path into help format-string.
      main: use one data-structure to initialize getopt_long(3) arguments and help.

Laurent Fasnacht (7):
      scanner: move the file descriptor to be in the input_descriptor structure
      scanner: move indesc list append in scanner_push_indesc
      scanner: remove parser_state->indescs static array
      Inclusion depth was computed incorrectly for glob includes.
      scanner: fix indesc_list stack to be in the correct order
      scanner: remove parser_state->indesc_idx
      tests: shell: add test for glob includes

Luis Ressel (1):
      netlink: Show the handles of unknown rules in "nft monitor trace"

Pablo Neira Ayuso (53):
      include: add nf_tables_compat.h to tarballs
      build: nftables 0.9.3 depends on libnftnl 1.1.5
      segtree: don't remove nul-root element from interval set
      proto: add proto_desc_id enumeration
      expr: add expr_ops_by_type()
      parser: add typeof keyword for declarations
      meta: add parse and build userdata interface
      exthdr: add exthdr_desc_id enum and use it
      exthdr: add parse and build userdata interface
      socket: add parse and build userdata interface
      osf: add parse and build userdata interface
      ct: add parse and build userdata interface
      numgen: add parse and build userdata interface
      hash: add parse and build userdata interface
      rt: add parse and build userdata interface
      fib: add parse and build userdata interface
      xfrm: add parse and build userdata interface
      main: enforce options before commands
      scanner: incorrect error reporting after file inclusion
      tests: shell: delete flowtable after flushing chain
      main: restore --debug
      evaluate: better error notice when interval flag is not set on
      tests: shell: set lookup and set update
      tests: shell: update list of rmmod modules
      tests: shell: validate error reporting with include and glob
      scanner: use list_is_first() from scanner_pop_indesc()
      parser: incorrect handle location
      src: initial extended netlink error reporting
      src: combine extended netlink error reporting with mispelling support
      mnl: extended error support for create command
      src: improve error reporting when setting policy on non-base chain
      src: improve error reporting when remove rules
      parser_bison: memleak in device parser
      mnl: do not use expr->identifier to fetch device name
      src: nat concatenation support with anonymous maps
      tests: shell: adjust tests to new nat concatenation syntax
      evaluate: stmt_evaluate_nat_map() only if stmt->nat.ipportmap == true
      src: support for offload chain flag
      netlink: remove unused parameter from netlink_gen_stmt_stateful()
      src: support for restoring element counters
      evaluate: add range specified flag setting (missing NF_NAT_RANGE_PROTO_SPECIFIED)
      src: support for counter in set definition
      tests: py: update nat expressions payload to include proto flags
      include: resync nf_tables.h cache copy
      src: add support for flowtable counter
      evaluate: display error if set statement is missing
      rule: add hook_spec
      parser_bison: store location of basechain definition
      evaluate: improve error reporting in netdev ingress chain
      evaluate: check for device in non-netdev chains
      parser_bison: simplify error in chain type and hook
      main: swap json and gmp fields in nft -V
      build: Bump version to v0.9.4

Phil Sutter (20):
      monitor: Do not decompose non-anonymous sets
      monitor: Fix for use after free when printing map elements
      tests: monitor: Support running individual test cases
      monitor: Fix output for ranges in anonymous sets
      tests: shell: Search diff tool once and for all
      cache: Fix for doubled output after reset command
      netlink: Fix leak in unterminated string deserializer
      netlink: Fix leaks in netlink_parse_cmp()
      netlink: Avoid potential NULL-pointer deref in netlink_gen_payload_stmt()
      tests: json_echo: Fix for Python3
      tests: json_echo: Support testing host binaries
      tests: monitor: Support testing host's nft binary
      tests: py: Support testing host binaries
      doc: nft.8: Describe element commands in their own section
      doc: nft.8: Mention wildcard interface matching
      scanner: Extend asteriskstring definition
      tests/py: Fix JSON output for changed timezone
      parser_json: Support ranges in concat expressions
      tests/py: Add tests involving concatenated ranges
      tests/py: Move tcpopt.t to any/ directory

Stefano Brivio (5):
      include: resync nf_tables.h cache copy
      src: Add support for NFTNL_SET_DESC_CONCAT
      src: Add support for concatenated set ranges
      tests: Introduce test for set with concatenated ranges
      tests: shell: Introduce test for insertion of overlapping and non-overlapping ranges

nl6720 (1):
      doc: Remove repeated paragraph and fix typo


--ozz3egdkljbuonck--
