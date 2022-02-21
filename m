Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E1F4BE96E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379908AbiBUQKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:10:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379902AbiBUQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:10:05 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E68A220E7;
        Mon, 21 Feb 2022 08:09:40 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 18D6D6022B;
        Mon, 21 Feb 2022 17:08:42 +0100 (CET)
Date:   Mon, 21 Feb 2022 17:09:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.2 release
Message-ID: <YhO5Pn+6+dgAgSd9@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="idxEts+FEiNamxS2"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--idxEts+FEiNamxS2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.2

This release contains new features available up to the Linux kernel
5.17-rc release:

* New ruleset optimization -o/--optimize option. You can combine this
  option with the dry run mode (--check) to review the proposed ruleset
  updates without actually loading the ruleset, e.g.

        # nft -c -o -f ruleset.test
        Merging:
                 ruleset.nft:16:3-37:           ip daddr 192.168.0.1 counter accept
                 ruleset.nft:17:3-37:           ip daddr 192.168.0.2 counter accept
                 ruleset.nft:18:3-37:           ip daddr 192.168.0.3 counter accept
        into:
                 ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept

  This option also coalesces rules using concatenation+set, e.g.

      meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
      meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept

   into:

      meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.3, eth1 . 1.1.1.2 . 2.2.2.5 } accept

   and it uses verdict maps to coalesce rules with same selectors but different
   verdicts, e.g.

      ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
      ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop

   into:

      ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop }

- Support for ip and tcp options and sctp chunks in sets, e.g.

        set s5 {
               typeof ip option ra value
               elements = { 1, 1024 }
        }

        set s7 {
               typeof sctp chunk init num-inbound-streams
               elements = { 1, 4 }
        }

        chain c5 {
               ip option ra value @s5 accept
        }

        chain c7 {
               sctp chunk init num-inbound-streams @s7 accept
        }

- Support for tcp fastopen, md5sig and mptcp options.

- mp-tcp subtype matching support, e.g.

        tcp option mptcp subtype 1

- Improved kernel-side filtering via listing options.

- complete JSON support for flowtables.

... this release also include fixes (highlights):

- fix --terse option with anonymous sets.
- fix crash with `nft describe' on invalid field or datatype.
- Big Endian fixes for ct expiration, meta sk{u,g}uid, meta hour,
  ct label, meta {i,o}ifname with wildcard, payload matching with
  bitmasks.
- allow for quote strings as device names in flowtable declarations.
- ethernet matching with reject, e.g.

        ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject

- turn on dynamic flag if rule dynamically updates a set.

... and incremental documentation updates.

This release also includes libnftables C example code now available
under the examples/ folder.

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

--idxEts+FEiNamxS2
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.2.txt"
Content-Transfer-Encoding: 8bit

Eugene Crosser (1):
      netlink: Use abort() in case of netlink_abi_error

Florian Westphal (24):
      exthdr: fix type number saved in udata
      netlink_delinearize: use correct member type
      netlink_delinearize: rename misleading variable
      netlink_delinearize: binop: make accesses to expr->left/right conditional
      tcpopt: remove KIND keyword
      scanner: add tcp flex scope
      parser: split tcp option rules
      tcpopt: add md5sig, fastopen and mptcp options
      tests: py: add test cases for md5sig, fastopen and mptcp mnemonics
      mptcp: add subtype matching
      exthdr: fix tcpopt_find_template to use length after mask adjustment
      tests: py: add tcp subtype match test cases
      ipopt: drop unused 'ptr' argument
      exthdr: support ip/tcp options and sctp chunks in typeof expressions
      iptopt: fix crash with invalid field/type combo
      tests: add shift+and typeof test cases
      payload: skip templates with meta key set
      netlink_delinearize: and/shift postprocessing
      netlink_delinearize: zero shift removal
      evaluate: attempt to set_eval flag if dynamic updates requested
      src: silence compiler warnings
      json: add flow statement json export + parser
      parser_json: fix flowtable device datatype
      parser_json: permit empty device list

Jeremy Sowden (18):
      proto: short-circuit loops over upper protocols
      evaluate: correct typo's
      evaluate: reject: support ethernet as L2 protocol for inet table
      tests: shell: remove stray debug flag.
      build: fix autoconf warnings
      build: remove scanner.c and parser_bison.c with `maintainer-clean`
      tests: py: fix inet/sets.t netdev payload
      tests: py: fix inet/ip.t payloads
      tests: py: fix inet/ip_tcp.t test
      netlink_delinearize: fix typo
      src: remove arithmetic on booleans
      src: reduce indentation
      src: simplify logic governing storing payload dependencies
      tests: py: fix inet/ip.t bridge payload
      src: add a helper that returns a payload dependency for a particular base
      src: store more than one payload dependency
      tests: py: remove redundant payload expressions
      tests: shell: remove redundant payload expressions

Pablo Neira Ayuso (30):
      cache: do not skip populating anonymous set with -t
      mnl: different signedness compilation warning
      cli: remove #include <editline/history.h>
      cli: save history on ctrl-d with editline
      tests: shell: extend catchall tests for maps
      proto: revisit short-circuit loops over upper protocols
      erec: expose print_location() and line_location()
      src: error reporting with -f and read from stdin
      src: remove '$' in symbol_expr_print
      src: add ruleset optimization infrastructure
      optimize: merge rules with same selectors into a concatenation
      optimize: merge same selector with different verdict into verdict map
      optimize: merge several selectors with different verdict into verdict map
      src: do not use the nft_cache_filter object from mnl.c
      cache: do not set error code twice
      cache: add helper function to fill up the rule cache
      src: 'nft list chain' prints anonymous chains correctly
      libnftables: use xrealloc()
      parser_bison: missing synproxy support in map declarations
      optimize: add __expr_cmp()
      optimize: merge verdict maps with same lookup key
      optimize: check for payload base and offset when searching for mergers
      optimize: do not merge raw payload expressions
      iface: handle EINTR case when creating the cache
      examples: add libnftables example program
      examples: load ruleset from JSON
      netlink: check key is EXPR_CONCAT before accessing field
      segtree: memleak get element command
      build: Bump version to 1.0.2
      build: missing SUBIRS update

Phil Sutter (18):
      tests/py: Avoid duplicate records in *.got files
      exthdr: Fix for segfault with unknown exthdr
      mnl: Fix for missing info in rule dumps
      src: Fix payload statement mask on Big Endian
      meta: Fix {g,u}id_type on Big Endian
      meta: Fix hour_type size
      datatype: Fix size of time_type
      ct: Fix ct label value parser
      netlink_delinearize: Fix for escaped asterisk strings on Big Endian
      cache: Filter tables on kernel side
      cache: Filter rule list on kernel side
      cache: Filter chain list on kernel side
      cache: Filter set list on server side
      cache: Support filtering for a specific flowtable
      tests: py: Test connlimit statement
      scanner: Move 'maps' keyword into list cmd scope
      scanner: Some time units are only used in limit scope
      scanner: rt: Move seg-left keyword into scope

Pierre Ducroquet (1):
      doc: add undefine and redefine keywords

Stijn Tintel (1):
      parser: allow quoted string in flowtable_expr_member

Štěpán Němec (1):
      tests: shell: better parameters for the interval stack overflow test


--idxEts+FEiNamxS2--
