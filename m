Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6A96539D2
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 00:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiLUXa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 18:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiLUXa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 18:30:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4A1E253;
        Wed, 21 Dec 2022 15:30:55 -0800 (PST)
Date:   Thu, 22 Dec 2022 00:30:52 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.6 release
Message-ID: <Y6OXLMinA/lCWNsB@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+r3PbvtDuakQOpYM"
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+r3PbvtDuakQOpYM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.6

This release contains enhancements and fixes:

- Fixes for the -o/--optimize, run this --optimize option to automagically
  compact your ruleset using sets, maps and concatenations.

eg.

     # cat ruleset.nft
     table ip x {
            chain y {
                   type filter hook input priority filter; policy drop;
                   meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
                   meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.4 accept
                   meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.3.0/24 accept
                   meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.4.0-2.2.4.10 accept
                   meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
            }
     }
     # nft -o -c -f ruleset.nft
     Merging:
     ruleset.nft:4:17-74:                 meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
     ruleset.nft:5:17-74:                 meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.4 accept
     ruleset.nft:6:17-77:                 meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.3.0/24 accept
     ruleset.nft:7:17-83:                 meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.4.0-2.2.4.10 accept
     ruleset.nft:8:17-74:                 meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.5 accept
     into:
             iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.3, eth1 . 1.1.1.2 . 2.2.2.4, eth1 . 1.1.1.2 . 2.2.3.0/24, eth1 . 1.1.1.2 . 2.2.4.0-2.2.4.10, eth2 . 1.1.1.3 . 2.2.2.5 } accept

+ The optimizer also compacts ruleset representations that already use simple
  sets, to turn them into set with concatenations, eg.

     # cat ruleset.nft
     table ip filter {
            chain input {
                   type filter hook input priority filter; policy drop;
                   iifname "lo" accept
                   ct state established,related accept comment "In traffic we originate, we trust"
                   iifname "enp0s31f6" ip saddr { 209.115.181.102, 216.197.228.230 } ip daddr 10.0.0.149 udp sport 123 udp dport 32768-65535 accept
                   iifname "enp0s31f6" ip saddr { 64.59.144.17, 64.59.150.133 } ip daddr 10.0.0.149 udp sport 53 udp dport 32768-65535 accept
           }
     }
     # nft -o -c -f ruleset.nft
     Merging:
     ruleset.nft:6:22-149:                      iifname "enp0s31f6" ip saddr { 209.115.181.102, 216.197.228.230 } ip daddr 10.0.0.149 udp sport 123 udp dport 32768-65535 accept
     ruleset.nft:7:22-143:                      iifname "enp0s31f6" ip saddr { 64.59.144.17, 64.59.150.133 } ip daddr 10.0.0.149 udp sport 53 udp dport 32768-65535 accept
     into:
                iifname . ip saddr . ip daddr . udp sport . udp dport { enp0s31f6 . 209.115.181.102 . 10.0.0.149 . 123 . 32768-65535, enp0s31f6 . 216.197.228.230 . 10.0.0.149 . 123 . 32768-65535, enp0s31f6 . 64.59.144.17 . 10.0.0.149 . 53 . 32768-65535, enp0s31f6 . 64.59.150.133 . 10.0.0.149 . 53 . 32768-65535 } accept

- Fix bytecode generation for concatenation of intervals where selectors use
  different byteorder datatypes, eg. IPv4 (network byte order) and meta mark
  (host byte order).

    table ip x {
           map w {
                 typeof ip saddr . meta mark : verdict
                 flags interval
                 counter
                 elements = {
                         127.0.0.1-127.0.0.4 . 0x123434-0xb00122 : accept,
                         192.168.0.10-192.168.1.20 . 0x0000aa00-0x0000aaff : accept,
                 }
          }
          chain k {
                 type filter hook input priority filter; policy drop;
                 ip saddr . meta mark vmap @w
          }
    }

- fix match of uncommon protocol matches with raw expressions, eg.

     meta l4proto 91 @th,400,16 0x0 accept

- unbreak insertion of rules with intervals:

     insert rule x y tcp sport { 3478-3497, 16384-16387 } counter accept

- enhancements for the JSON API, including support for statements in sets and
  maps, and asorted fixes.
- extensions for the python nftables library to allow to load ruleset and
  perform dry run, support for external definition of variables, among others.
- allow to intercalate comments in set elements.
- allow for zero burst in byte ratelimits.
- fix element collapse routine when same set name and different family is used.
- ... and manpage updates.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.4 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--+r3PbvtDuakQOpYM
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.6.txt"

Alex Forster (1):
      json: fix 'add flowtable' command

Derek Hageman (1):
      rule: check address family in set collapse

Fernando Fernandez Mancera (8):
      json: add set statement list support
      json: add table map statement support
      json: fix json schema version verification
      json: fix empty statement list output in sets and maps
      json: add secmark object reference support
      json: add stateful object comment support
      py: support variables management and fix formatting
      doc: add nft_ctx_add_var() and nft_ctx_clear_vars() docs

Florian Westphal (11):
      tests: shell: check for a tainted kernel
      expr: update EXPR_MAX and add missing comments
      evaluate: un-break rule insert with intervals
      evaluate: allow implicit ether -> vlan dep
      doc: mention vlan matching in ip/ip6/inet families
      evaluate: add ethernet header size offset for implicit vlan dependency
      tests: py: add vlan test case for ip/inet family
      netlink_delinearize: fix decoding of concat data element
      netlink_linearize: fix timeout with map updates
      tests: add a test case for map update from packet path with concat
      doc: add/update can be used with maps too

Harald Welte (1):
      doc: payload-expression.txt: Mention that 'ih' exists

Jeremy Sowden (3):
      segtree: refactor decomposition of closed intervals
      segtree: fix decomposition of unclosed intervals containing address prefixes
      doc, src: make some spelling and grammatical improvements

Michael Braun (1):
      concat with dynamically sized fields like vlan id

Pablo Neira Ayuso (31):
      optimize: merging concatenation is unsupported
      optimize: check for mergeable rules
      optimize: expand implicit set element when merging into concatenation
      src: allow burst 0 for byte ratelimit and use it as default
      tests/py: missing userdata in netlink payload
      include: resync nf_tables.h cache copy
      evaluate: bogus datatype assertion in binary operation evaluation
      evaluate: datatype memleak after binop transfer
      parser_bison: display too many levels of nesting error
      rule: do not display handle for implicit chain
      netlink_delinearize: do not transfer binary operation to non-anonymous sets
      tests: shell: deletion from interval concatenation
      netlink_delinearize: complete payload expression in payload statement
      payload: do not kill dependency for proto_unknown
      optimize: handle prefix and range when merging into set + concatenation
      doc: document a few reset commands supported by the parser
      doc: no reset support for limit
      monitor: missing cache and set handle initialization
      src: support for selectors with different byteorder with interval concatenations
      doc: statements: fwd supports for sending packets via neighbouring layer
      scanner: munch full comment lines
      tests: py: missing json for different byteorder selector with interval concatenation
      netlink: swap byteorder of value component in concatenation of intervals
      evaluate: do not crash on runaway number of concatenation components
      netlink: statify __netlink_gen_data()
      netlink: add function to generate set element key data
      netlink: unfold function to generate concatenations for keys and data
      scanner: match full comment line in case of tie
      evaluate: fix compilation warning
      owner: Fix potential array out of bounds access
      build: Bump version to 1.0.6

Peter Collinson (1):
      py: extend python API to support libnftables API

Phil Sutter (9):
      doc: nft.8: Add missing '-T' in synopsis
      erec: Dump locations' expressions only if set
      monitor: Sanitize startup race condition
      Warn for tables with compat expressions in rules
      Makefile: Create LZMA-compressed dist-files
      xt: Delay libxtables access until translation
      xt: Purify enum nft_xt_type
      xt: Rewrite unsupported compat expression dumping
      xt: Fall back to generic printing from translation

Xiao Liang (1):
      src: Don't parse string as verdict in map


--+r3PbvtDuakQOpYM--
