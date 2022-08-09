Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7170C58E080
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbiHITyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345109AbiHITyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:54:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEA162250A;
        Tue,  9 Aug 2022 12:54:41 -0700 (PDT)
Date:   Tue, 9 Aug 2022 21:54:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.5 release
Message-ID: <YvK7fkPf6P52MV+w@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fzRi0kwIlpLps75v"
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fzRi0kwIlpLps75v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.5

This release contains bugfixes (highlights):

- Fixes for the -o/--optimize, run this --optimize option to automagically
  compact your ruleset using sets, maps and concatenations, eg.

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

- Fix ethernet and vlan concatenations, eg. define a dynamic set which
  is populated from the packet path.

     add table netdev x
     add chain netdev x y { type filter hook ingress device enp0s25 priority 0; }
     add set netdev x macset { typeof ether daddr . vlan id; flags dynamic,timeout; }
     add rule netdev x y update @macset { ether daddr . vlan id timeout 60s }

  or simply match using a concatenation:

     add rule netdev x y ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 } counter accept

- Fix ruleset listing with interface wildcard map, eg.

     table inet filter {
        chain INPUT {
            iifname vmap {
                "eth0" : jump input_lan,
                "wg*" : jump input_vpn
            }
        }
        chain input_lan {}
        chain input_vpn {}
     }

- Fix several regressions in the input lexer which broke valid rulesets.
- Fix slowdown with large lists of singleton interval elements.
- Fix set automerge feature for large lists of singleton interval elements.
- Fix bogus error reporting for exact overlaps.
- Fix segfault when adding elements to invalid set.
- fix device parsing in netdev family in json.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.2.3 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--fzRi0kwIlpLps75v
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.5.txt"

Florian Westphal (12):
      Revert "scanner: flags: move to own scope"
      parser: add missing synproxy scope closure
      scanner: don't pop active flex scanner scope
      scanner: allow prefix in ip6 scope
      netlink_delinearize: allow postprocessing on concatenated elements
      netlink_delinearize: postprocess binary ands in concatenations
      proto: track full stack of seen l2 protocols, not just cumulative offset
      debug: dump the l2 protocol stack
      tests: add a test case for ether and vlan listing
      netlink_delinearize: also postprocess OP_AND in set element context
      evaluate: search stacked header list for matching payload dep
      src: allow anon set concatenation with ether and vlan

Jo-Philipp Wich (1):
      meta: don't use non-POSIX formats in strptime()

Oleksandr Natalenko (1):
      src: proto: support DF, LE PHB, VA for DSCP

Pablo Neira Ayuso (38):
      tests: shell: runtime set element automerge
      rule: collapse set element commands
      intervals: do not report exact overlaps for new elements
      intervals: do not empty cache for maps
      optimize: do not compare relational expression rhs when collecting statements
      optimize: do not merge rules with set reference in rhs
      optimize: do not print stateful information
      optimize: remove comment after merging
      optimize: fix reject statement
      optimize: fix verdict map merging
      optimize: add osf expression support
      optimize: add xfrm expression support
      optimize: add fib expression support
      optimize: add binop expression support
      optimize: add numgen expression support
      optimize: add hash expression support
      optimize: add unsupported statement
      tests: shell: run -c -o on ruleset
      optimize: only merge OP_IMPLICIT and OP_EQ relational
      optimize: assume verdict is same when rules have no verdict
      optimize: limit statement is not supported yet
      libnftables: release top level scope
      netlink_delinearize: memleak when parsing concatenation data
      intervals: fix crash when trying to remove element in empty set
      intervals: check for EXPR_F_REMOVE in case of element mismatch
      parser_bison: fix error location for set elements
      src: remove NFT_NLATTR_LOC_MAX limit for netlink location error reporting
      mnl: store netlink error location for set elements
      segtree: fix map listing with interface wildcard
      evaluate: report missing interval flag when using prefix/range in concatenation
      cache: release pending rules when chain binding lookup fails
      rule: crash when uncollapsing command with unexisting table or set
      cache: prepare nft_cache_evaluate() to return error
      cache: validate handle string length
      cache: report an error message if cache initialization fails
      parser_json: fix device parsing in netdev family
      tests/py: disable arp family for queue statement
      build: Bump version to 1.0.5

Peter Tirsek (1):
      evaluate: fix segfault when adding elements to invalid set

Phil Sutter (3):
      intervals: Do not sort cached set elements over and over again
      tests/py: Add a test for failing ipsec after counter
      doc: Document limitations of ipsec expression with xfrm_interface


--fzRi0kwIlpLps75v--
