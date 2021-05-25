Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79A9390B38
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhEYVVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:21:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46932 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhEYVVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 17:21:08 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C8FA46433F;
        Tue, 25 May 2021 23:18:35 +0200 (CEST)
Date:   Tue, 25 May 2021 23:19:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 0.9.9 release
Message-ID: <20210525211934.GA23501@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.9.9

This release contains fixes, documentation updates and new features
available up to the Linux kernel 5.13-rc1 release. Highlights:

* Flowtable hardware offload support [1]: add a new 'offload' flag that
  turns on the flowtable hardware fastpath.

    table ip global {
            flowtable f {
                    hook ingress priority filter + 1
                    devices = { lan3, lan0, wan }
                    flags offload
            }

            chain forward {
                    type filter hook forward priority filter; policy accept;
                    ip protocol { tcp, udp } flow add @f
            }

            chain post {
                    type nat hook postrouting priority filter; policy accept;
                    oifname "wan" masquerade
            }
    }

  [1] https://www.kernel.org/doc/html/latest/networking/nf_flowtable.html

* Support for the table owner flag. This new flag allows a process to
  own a table in exclusivity. The owner process name is show as a
  comment. The table can be either removed by the owner process
  (explicit removal) or when the owner process is terminated.

    table ip x { # progname nft
            flags owner

            chain y {
                    type filter hook input priority filter; policy accept;
                    counter packets 1 bytes 309
            }
    }

  The example above shows a ruleset that is owned by nft which is
  running in interactive mode, ie. nft -i

* 802.1ad (QinQ) support:

  - Check that outer ethertype is 8021ad and outer vlan id is 321
  ... ether type 802.1ad vlan id 342

  - Check that outer ethertype is 8021ad and vlan id is 1 and inner
    ethertype is 802.1q and vlan id is 2, finally check that this
    QinQ frame encapsulates an IP packet.

  ... ether type 8021ad vlan id 1 vlan type 8021q vlan id 2 vlan type ip counter

* cgroupsv2 support.

  - Check for that socket cgroupv2 ancestor level 1 is matching "system.slice"
  ... socket cgroupv2 level 1 "system.slice"

* match on SCTP packet chunks (available since the upcoming 5.14 release)

  - match if chunk type 'data' exists
  ... sctp chunk data exists
  - match on chunk type 'data' field 'type'
  ... sctp chunk data type 0

* x2 speed up time to load ruleset (via -f).
* Speed up time to print ruleset listing.

* Shortcut to check for set/unset bits in flags.

  - Check that snat and dnat ct status bits are unset.
  ... ct status ! snat,dnat

  - Check that the syn bit is set in the syn,ack bitmask
  ... tcp flags syn / syn,ack

  - Check that the fin and rst bits are not set in the syn,ack,fin,rst bitmask
  ... tcp flags != fin,rst / syn,ack,fin,rst

* Allow to use verdict in set/map typeof definitions

  add map x m { typeof iifname . ip protocol . th dport : verdict ;}

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

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-0.9.9.txt"
Content-Transfer-Encoding: 8bit

Dominick Grift (1):
      files: improve secmark.nft example

Eric Garver (1):
      json: init parser state for every new buffer/file

Florian Westphal (54):
      json: fix icmpv6.t test cases
      json: limit: set default burst to 5
      json: ct: add missing rule
      json: icmp: refresh json output
      json: icmp: move expected parts to json.output
      json: ct: add missing test input
      exthdr: remove tcp dependency for tcp option matching
      src: evaluate: reset context maxlen value before prio evaluation
      tests: add icmp/6 test where dependency should be left alone
      payload: check icmp dependency before removing previous icmp expression
      testcases: move two dump files to correct location
      tests: add empty dynamic set
      evaluate: do not crash if dynamic set has no statements
      trace: do not remove icmp type from packet dump
      tests: extend dtype test case to cover expression with integer type
      evaluate: pick data element byte order, not dtype one
      evaluate: set evaluation context for set elements
      src: allow use of 'verdict' in typeof definitions
      parser: re-enable support for concatentation on map RHS
      parser: squash duplicated spec/specid rules
      parser: compact map RHS type
      parser: compact ct obj list types
      scanner: remove unused tokens
      scanner: introduce start condition stack
      scanner: queue: move to own scope
      scanner: ipsec: move to own scope
      scanner: rt: move to own scope
      scanner: socket: move to own scope
      scanner: ct: move to own scope
      scanner: ip: move to own scope
      scanner: ip6: move to own scope
      scanner: add fib scope
      scanner: add ether scope
      scanner: arp: move to own scope
      scanner: remove saddr/daddr from initial state
      scanner: vlan: move to own scope
      scanner: limit: move to own scope
      scanner: quota: move to own scope
      scanner: move until,over,used keywords away from init state
      scanner: secmark: move to own scope
      scanner: avoid -fasan heap overflow warnings
      scanner: add support for scope nesting
      scanner: counter: move to own scope
      scanner: log: move to own scope
      parser: add missing scope_close annotation for RT keyword
      parser: fix scope closure of COUNTER token
      netlink: don't crash when set elements are not evaluated as expected
      src: vlan: allow matching vlan id insider 802.1ad frame
      proto: add 8021ad as mnemonic for IEEE 802.1AD (0x88a8) ether type
      payload: be careful on vlan dependency removal
      tests: add 8021.AD vlan test cases
      proto: replace vlan ether type with 8021q
      evaluate: check if nat statement map specifies a transport header expr
      doc: tiny spelling fix in stateful object section s/an/a

Frank Wunderlich (1):
      nftables: add flags offload to flowtable

Jan Engelhardt (1):
      files: move example files away from /etc

Laura Garcia Liebana (1):
      parser: allow to load stateful ct connlimit elements in sets

Marco Oliverio (1):
      cache: check errno before invoking cache_release()

Pablo Neira Ayuso (62):
      evaluate: disallow ct original {s,d}ddr from concatenations
      src: add negation match on singleton bitmask value
      tests: shell: extend 0025empty_dynset_0 to cover multi-statement support
      evaluate: incorrect usage of stmt_binary_error() in reject
      table: rework flags printing
      table: support for the table owner flag
      mnl: remove nft_mnl_socket_reopen()
      cache: memleak list of chain
      expression: memleak in verdict_expr_parse_udata()
      src: move remaining cache functions in rule.c to cache.c
      segtree: release single element already contained in an interval
      tests: shell: flowtable add after delete in batch
      tests: shell: fix 0025empty_dynset_0
      doc: no need to define a set in ct state
      src: add datatype->describe()
      rule: remove semicolon in flowtable offload
      mnl: do not set flowtable flags twice
      parser_bison: simplify flowtable offload flag parser
      cache: rename chain_htable to cache_chain_ht
      src: split chain list in table
      evaluate: use chain hashtable for lookups
      cache: statify chain_cache_dump()
      cache: check for NULL chain in cache_init()
      cache: add hashtable cache for sets
      cache: bail out if chain list cannot be fetched from kernel
      Makefile: missing owner.h file
      parser_bison: missing relational operation on flag list
      tests: shell: remove missing modules
      src: unbreak deletion by table handle
      rule: skip fuzzy lookup for unexisting 64-bit handle
      src: pass chain name to chain_cache_find()
      src: consolidate nft_cache infrastructure
      src: consolidate object cache infrastructure
      cache: add hashtable cache for object
      cache: add hashtable cache for flowtable
      cache: add set_cache_del() and use it
      evaluate: add set to the cache
      evaluate: add flowtable to the cache
      cache: missing table cache for several policy objects
      evaluate: add object to the cache
      cache: add hashtable cache for table
      evaluate: remove chain from cache on delete chain command
      evaluate: remove set from cache on delete set command
      evaluate: remove flowtable from cache on delete flowtable command
      evaluate: remove object from cache on delete object command
      src: add cgroupsv2 support
      parser_bison: add set_elem_key_expr rule
      src: add set element catch-all support
      evaluate: don't crash on set definition with incorrect datatype
      tests: shell: don't assume fixed handle value in cache/0008_delete_by_handle_0
      netlink_delinearize: fix binary operation postprocessing with sets
      parser_bison: add shortcut syntax for matching flags without binary operations
      src: use PRIu64 format
      datatype: skip cgroupv2 rootfs in listing
      doc: document cgroupv2
      libnftables: location-based error reporting for chain type
      cmd: typo in chain fuzzy lookup
      rule: skip exact matches on fuzzy lookup
      evaluate: allow == and != in the new shortcut syntax to match for flags
      expression: display an error on unknown datatype
      include: missing sctp_chunk.h in Makefile.am
      build: Bump version to v0.9.9

Pavel Tikhomirov (1):
      nftables: xt: fix misprint in nft_xt_compatible_revision

Phil Sutter (18):
      reject: Fix for missing dependencies in netdev family
      reject: Unify inet, netdev and bridge delinearization
      json: limit: Always include burst value
      json: Do not abbreviate reject statement object
      tests/py: Write dissenting payload into the right file
      tests/py: Add a test sanitizer and fix its findings
      erec: Sanitize erec location indesc
      monitor: Don't print newgen message with JSON output
      tests/py: Adjust payloads for fixed nat statement dumps
      mnl: Set NFTNL_SET_DATA_TYPE before dumping set elements
      tests/py: Fix for missing JSON equivalent in any/ct.t.json
      mnl: Increase BATCH_PAGE_SIZE to support huge rulesets
      doc: Reduce size of NAT statement synopsis
      scanner: sctp: Move to own scope
      json: Simplify non-tcpopt exthdr printing a bit
      exthdr: Implement SCTP Chunk matching
      doc: nft.8: Extend monitor description by trace
      expr_postprocess: Avoid an unintended fall through

Simon Ruderich (4):
      doc: add * to include example to actually include files
      doc: remove duplicate tables in synproxy example
      doc: move drop rule on a separate line in blackhole example
      doc: use symbolic names for chain priorities

Stefano Brivio (2):
      segtree: Fix range_mask_len() for subnet ranges exceeding unsigned int
      tests: Introduce 0043_concatenated_ranges_1 for subnets of different sizes

Štěpán Němec (3):
      tests: monitor: use correct $nft value in EXIT trap
      main: fix nft --help output fallout from 719e4427
      doc: nft: fix some typos and formatting issues


--mP3DRpeJDSE+ciuQ--
