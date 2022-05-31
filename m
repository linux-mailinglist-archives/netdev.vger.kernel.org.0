Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA9538E96
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 12:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245560AbiEaKNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 06:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245552AbiEaKNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 06:13:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0519A663F8;
        Tue, 31 May 2022 03:13:26 -0700 (PDT)
Date:   Tue, 31 May 2022 12:13:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.3 release
Message-ID: <YpXqQ4C5dvBKtefP@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="umzEErp07L3qL6f/"
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--umzEErp07L3qL6f/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.3

This release contains new features available up to the Linux kernel 5.18 release:

* Support for wildcard interface name matching with sets:

     table inet testifsets {
        set simple_wild {
               type ifname
               flags interval
               elements = { "abcdef*",
                            "othername",
                            "ppp0" }
        }

        chain v4icmp {
                type filter hook input priority 0; policy accept;
                iifname @simple_wild counter packets 0 bytes 0
                iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
        }
     }

* Support for runtime auto-merge of set elements. So far, the
  auto-merge routine could only coalesce elements in the set
  declaration.

     # cat ruleset.nft
     table ip x {
        set y {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { 1.2.3.0, 1.2.3.255, 1.2.3.0/24,
                             3.3.3.3, 4.4.4.4, 4.4.4.4-4.4.4.8,
                             3.3.3.4, 3.3.3.5 }
        }
     }
     # nft -f ruleset.nft
     table ip x {
        set y {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { 1.2.3.0/24, 3.3.3.3-3.3.3.5,
                             4.4.4.4-4.4.4.8 }
        }
     }

  with this update, incremental runtime updates are also supported:

     # nft add element ip x y { 1.2.3.0-1.2.4.255, 3.3.3.6 }
     # nft list ruleset
     table ip x {
        set y {
                type ipv4_addr
                flags interval
                auto-merge
                elements = { 1.2.3.0-1.2.4.255, 3.3.3.3-3.3.3.6,
                             4.4.4.4-4.4.4.8 }
        }
     }

   as shown above, new elements are merged into existing intervals
   whenever possible.

   This also supports for incremental runtime element removals that
   result in adjusting/splitting the existing intervals.

* Enhancements for the ruleset optimization -o/--optimize option which
  allows to coalesce several NAT rules into map:

     # cat ruleset.nft
     table ip x {
            chain y {
                    type nat hook postrouting priority srcnat; policy drop;
                    ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
                    ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
            }
     }

     # nft -o -c -f ruleset.nft
     Merging:
     ruleset.nft:4:3-52:                ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
     ruleset.nft:5:3-52:                ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
     into:
            snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 : 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }

  This infrastructure also learnt how to coalesce raw expressions into maps, for example:

     # cat ruleset.nft
     table ip x {
            [...]

            chain nat_dns_acme {
                    udp length 47-63 @th,160,128 0x0e373135363130333131303735353203 goto nat_dns_dnstc
                    udp length 62-78 @th,160,128 0x0e31393032383939353831343037320e goto nat_dns_this_5301
                    udp length 62-78 @th,160,128 0x0e31363436323733373931323934300e goto nat_dns_saturn_5301
                    udp length 62-78 @th,160,128 0x0e32393535373539353636383732310e goto nat_dns_saturn_5302
                    udp length 62-78 @th,160,128 0x0e38353439353637323038363633390e goto nat_dns_saturn_5303
                    drop
            }
     }

  When invoking 'nft' to request an optimization, several rules result
  in a map:

     # nft -c -o -f ruleset.
     Merging:
     ruleset.nft:8:17-98:                 udp length 47-63 @th,160,128 0x0e373135363130333131303735353203 goto nat_dns_dnstc
     ruleset.nft:9:17-102:                 udp length 62-78 @th,160,128 0x0e31393032383939353831343037320e goto nat_dns_this_5301
     ruleset.nft:10:17-104:                 udp length 62-78 @th,160,128 0x0e31363436323733373931323934300e goto nat_dns_saturn_5301
     ruleset.nft:11:17-104:                 udp length 62-78 @th,160,128 0x0e32393535373539353636383732310e goto nat_dns_saturn_5302
     ruleset.nft:12:17-104:                 udp length 62-78 @th,160,128 0x0e38353439353637323038363633390e goto nat_dns_saturn_5303
     into:
        udp length . @th,160,128 vmap { 47-63 . 0x0e373135363130333131303735353203 : goto nat_dns_dnstc, 62-78 . 0x0e31393032383939353831343037320e : goto nat_dns_this_5301, 62-78 . 0x0e31363436323733373931323934300e : goto nat_dns_saturn_5301, 62-78 . 0x0e32393535373539353636383732310e : goto nat_dns_saturn_5302, 62-78 . 0x0e38353439353637323038363633390e : goto nat_dns_saturn_5303 }

* Support for raw expressions in concatenations. For example, in anonymous sets:

     # nft add rule x y ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }

  And, in explicit set declarations:

     table x {
            set y {
                    typeof ip saddr . @ih,32,32
                    elements = { 1.1.1.1 . 0x14 }
            }
     }

  (inner header/payload matching @ih keywork requires Linux kernel >= 5.16).

* Support for integer type protocol header fields in concatenations.

  For example, the udp length field relies on the integer datatype as
  shown by the 'nft describe' command:

     # nft describe udp length
     payload expression, datatype integer (integer), 16 bits

  you can now use it in set and map declarations through 'typeof':

     table inet t {
            map m1 {
                    typeof udp length . @ih,32,32 : verdict
                    flags interval
                    elements = { 20-80 . 0x14 : accept,
                                 1-10 . 0xa : drop }
            }

            chain c {
                    type filter hook input priority 0; policy drop;
                    udp length . @ih,32,32 vmap @m1
            }
     }

* Allow to reset TCP options (requires Linux kernel >= 5.18):

     tcp flags syn reset tcp option sack-perm

* Speed up chain listing command, ie. nft list chain x y

... this release also includes fixes (highlights):

- fix invalid listing in verdict maps
- several fixes for -o/--optimize (added in previous 1.0.2 release).
- fix anonymous object maps, for example:

      table inet filter {
             ct helper sip-5060u {
                     type "sip" protocol udp
                     l3proto ip
             }

             ct helper sip-5060t {
                     type "sip" protocol tcp
                     l3proto ip
             }

             chain input {
                     type filter hook input priority filter; policy accept;
                     ct helper set ip protocol . th dport map { udp . 10000-20000 : "sip-5060u", tcp . 10000-20000 : "sip-5060t" }
             }
      }

- fix build problems in nftables-1.0.2 tarball.
- fix JSON chain listing (https://bugzilla.netfilter.org/show_bug.cgi?id=1580)

... and incremental documentation updates.

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

--umzEErp07L3qL6f/
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.3.txt"

Chander Govindarajan (2):
      json: update json output ordering to place rules after chains
      nft: simplify chain lookup in do_list_chain

Florian Westphal (20):
      tests: add test case for flowtable with owner flag
      src: add tcp option reset support
      evaluate: init cmd pointer for new on-stack context
      src: copy field_count for anonymous object maps as well
      evaluate: make byteorder conversion on string base type a no-op
      evaluate: keep prefix expression length
      segtree: split prefix and range creation to a helper function
      evaluate: string prefix expression must retain original length
      src: make interval sets work with string datatypes
      segtree: add string "range" reversal support
      tests: add testcases for interface names in sets
      segtree: use correct byte order for 'element get'
      segtree: add support for get element with sets that contain ifnames
      netlink: remove unused argument from helper function
      src: allow use of base integer types as set keys in concatenations
      tests: add concat test case with integer base type subkey
      src: fix always-true assertions
      netlink: swap byteorder for host-endian concat data
      segtree: add pretty-print support for wildcard strings in concatenated sets
      sets_with_ifnames: add test case for concatenated range

Jeremy Sowden (2):
      examples: add .gitignore file
      include: add missing `#include`

Lukas Straub (2):
      meta: time: use uint64_t instead of time_t
      meta: fix compiler warning in date_type_parse()

Martin Gignac (1):
      tests: py: Add meta time tests without 'meta' keyword

Pablo Neira Ayuso (34):
      examples: compile with `make check' and add AM_CPPFLAGS
      optimize: fix vmap with anonymous sets
      optimize: more robust statement merge with vmap
      optimize: incorrect assert() for unexpected expression type
      optimize: do not merge unsupported statement expressions
      optimize: do not assume log prefix
      rule: Avoid segfault with anonymous chains
      expression: typeof verdict needs verdict datatype
      src: allow to use typeof of raw expressions in set declaration
      src: allow to use integer type header fields via typeof set declaration
      optimize: Restore optimization for raw payload expressions
      tests: py: add inet/vmap tests
      tests: py: extend meta time coverage
      src: add EXPR_F_KERNEL to identify expression in the kernel
      src: replace interval segment tree overlap and automerge
      src: remove rbtree datastructure
      mnl: update mnl_nft_setelem_del() to allow for more reuse
      intervals: add support to automerge with kernel elements
      evaluate: allow for zero length ranges
      intervals: support to partial deletion with automerge
      src: restore interval sets work with string datatypes
      intervals: unset EXPR_F_KERNEL for adjusted elements
      intervals: add elements with EXPR_F_KERNEL to purge list only
      intervals: fix deletion of multiple ranges with automerge
      intervals: build list of elements to be added from cache
      intervals: set on EXPR_F_KERNEL flag for new elements in set cache
      optimize: incorrect logic in verdict comparison
      optimize: do not clone unsupported statement
      optimize: merge nat rules with same selectors into map
      optimize: memleak in statement matrix
      intervals: deletion should adjust range not yet in the kernel
      netlink_delinearize: release last register on exit
      intervals: fix compilation --with-mini-gmp
      build: Bump version to 1.0.3

Phil Sutter (26):
      scanner: icmp{,v6}: Move to own scope
      scanner: igmp: Move to own scope
      scanner: tcp: Move to own scope
      scanner: synproxy: Move to own scope
      scanner: comp: Move to own scope.
      scanner: udp{,lite}: Move to own scope
      scanner: dccp, th: Move to own scopes
      scanner: osf: Move to own scope
      scanner: ah, esp: Move to own scopes
      scanner: dst, frag, hbh, mh: Move to own scopes
      scanner: type: Move to own scope
      scanner: rt: Extend scope over rt0, rt2 and srh
      scanner: monitor: Move to own Scope
      scanner: reset: move to own Scope
      scanner: import, export: Move to own scopes
      scanner: reject: Move to own scope
      scanner: flags: move to own scope
      scanner: policy: move to own scope
      scanner: nat: Move to own scope
      scanner: at: Move to own scope
      scanner: meta: Move to own scope
      scanner: dup, fwd, tproxy: Move to own scopes
      scanner: Fix for ipportmap nat statements
      tests: monitor: Hide temporary file names from error output
      tests: py: Don't colorize output if stderr is redirected
      intervals: Simplify element sanity checks

Sam James (2):
      libnftables.map: export new nft_ctx_{get,set}_optimize API
      build: explicitly pass --version-script to linker


--umzEErp07L3qL6f/--
