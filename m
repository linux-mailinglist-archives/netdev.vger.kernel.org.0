Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F36B81AB
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjCMTW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCMTW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:22:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C20BC1EFF1;
        Mon, 13 Mar 2023 12:22:01 -0700 (PDT)
Date:   Mon, 13 Mar 2023 20:21:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.7 release
Message-ID: <ZA931rfLiLHx1KjD@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HdaEK2XXNW/pfm7h"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HdaEK2XXNW/pfm7h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.7

This release contains enhancements and fixes such as:

- Support for vxlan/geneve/gre/gretap matching. This allows for simple
  matching expressions on inner headers such matching on the VxLAN
  encapsulated IPv4 header fields as well as:

      ... udp dport 4789 vxlan ip protocol udp
      ... udp dport 4789 vxlan ip saddr 1.2.3.0/24

  This also works with sets and it can also be combined with
  concatenations, such as:

      ... udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }

  This allows you to define a stateless filtering policy on the ingress hook
  without requiring the classic data path round trip to first decapsulate
  the VxLAN header and then filter from the vxlan0 netdevice.

  This new feature requires Linux kernel >= 6.2.

- auto-merge support for partial set element deletion. This allows you
  to partially delete an element or a subrange in an existing range.

      # nft list ruleset
      table ip x {
          set y {
              typeof tcp dport
              flags interval
              auto-merge
              elements = { 24-30, 40-50 }
          }
      }

  Then, delete element 25 which is contained in the 24-30 range:

      # nft delete element ip x y { 25 }
      # nft list ruleset
      table ip x {
          set y {
              typeof tcp dport
              flags interval
              auto-merge
              elements = { 24, 26-30, 40-50 }
          }
      }

  This requires the following two kernel fixes:

   5d235d6ce75c ("netfilter: nft_set_rbtree: skip elements in transaction from garbage collection")
   c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")

  which are already scheduled for -stable kernel releases >= 5.10.

- Allow for NAT mapping with concatenation and ranges. This release
  fixes mixed use of singleton concatenation and concatenation with
  ranges, eg.

  table ip nat {
      chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;
          dnat to ip daddr . tcp dport map { 10.1.1.136 . 80 : 1.1.2.69 . 1024, 10.1.1.10-10.1.1.20 . 8888-8889 : 1.1.2.69 . 2048-2049 } persistent
     }
  }

  The example above shows how to define a destination nat mapping using the IPv4
  destination address and the TCP destination port as key for the map lookup.
  The 'persistent' flag tells the nat core to select the destination IPv4 address
  specified as an IPv4 range through hashing the IPv4 source and destination
  (to evenly distribute the load). If no IPv4 range is specified, then nat core
  selects the singleton IPv4 destination address.

- Support for the lastuse statement. This allows you to know the last time a
  rule or set element has be used:

  table ip x {
      set y {
          typeof ip daddr . tcp dport
          size 65535
          flags dynamic,timeout
          last
          timeout 1h
      }

      chain z {
          type filter hook output priority filter; policy accept;
          update @y { ip daddr . tcp dport }
      }
  }
  # nft list set ip x y
  table ip x {
      set y {
          typeof ip daddr . tcp dport
          size 65535
          flags dynamic,timeout
          last
          timeout 1h
          elements = { 172.217.17.14 . 443 last used 1s591ms timeout 1h expires 59m58s409ms,
                       172.67.69.19 . 443 last used 4s636ms timeout 1h expires 59m55s364ms,
                       142.250.201.72 . 443 last used 4s748ms timeout 1h expires 59m55s252ms,
                       172.67.70.134 . 443 last used 4s688ms timeout 1h expires 59m55s312ms,
                       35.241.9.150 . 443 last used 5s204ms timeout 1h expires 59m54s796ms,
                       138.201.122.174 . 443 last used 4s537ms timeout 1h expires 59m55s463ms,
                       34.160.144.191 . 443 last used 5s205ms timeout 1h expires 59m54s795ms,
                       130.211.23.194 . 443 last used 4s436ms timeout 1h expires 59m55s564ms }
         }
  }

  This feature is available since Linux kernel >= 5.14. This requires the
  following kernel fix:

  860e874290fb ("netfilter: nft_last: copy content when cloning expression")

  which is already scheduled for -stable Linux kernel release.

- Support for quota in sets. The following example shows how to define an
  (optional) quota per IPv4 destination address:

  table netdev x {
      set y {
          typeof ip daddr
          size 65535
          quota over 10000 mbytes
      }

      chain y {
          type filter hook egress device "eth0" priority filter; policy accept;
          ip daddr @y drop
      }
  }

  Then, add a quota for 8.8.8.8.

  # nft add element inet x y { 8.8.8.8 }
  # ping -c 2 8.8.8.8
  PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
  64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=8.14 ms
  64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=7.82 ms

  --- 8.8.8.8 ping statistics ---
  2 packets transmitted, 2 received, 0% packet loss, time 1001ms
  rtt min/avg/max/mdev = 7.824/7.980/8.136/0.156 ms
  # nft list ruleset
  table netdev x {
      set y {
          type ipv4_addr
          size 65535
          quota over 10000 mbytes
          elements = { 8.8.8.8 quota over 10000 mbytes used 196 bytes }
      }

      chain y {
          type filter hook egress device "eth0" priority filter; policy accept;
          ip daddr @y drop
      }
  }

  you also can override the default set-defined quota per element:

  # nft add element inet x y { 1.2.3.5 quota 5000 mbytes }

- Allow to use constant in set statement. The following example shows how to
  add a set element from datapath as a concatenation of the Ethernet
  destination address and a (constant) VLAN id (see VLAN id 123 is used below).

      table netdev t {
          set s {
              typeof ether saddr . vlan id
              size 2048
              flags dynamic,timeout
              timeout 1m
          }

          chain c {
              type filter hook ingress device eth0 priority 0; policy accept;
              ether type != 8021q update @s { ether daddr . 123 } counter
          }
      }


- New destroy command (it requires Linux kernel >= 6.3-rc), which allows to
  inconditionally remove objects, because the delete command hits ENOENT if
  the object does not exists.

      destroy table ip filter

- fix ct proto-src and proto-dst when used from set/map statements. These are
  the equivalent representation to th sport and th dport to access conntrack
  tuple. The following example shows how to populate a map from the datapath:

      table ip foo {
          map pinned {
              typeof ip saddr . ct original proto-dst : ip daddr . tcp dport
              size 65535
              flags dynamic,timeout
              timeout 6m
          }

          chain pre {
              type filter hook prerouting priority 0; policy accept;
              meta l4proto tcp update @pinned { ip saddr . ct original proto-dst : ip daddr . tcp dport }
          }
      }

- fixes for the new -o/--optimize which allows you to optimize your ruleset.
- fix set elements deletion triggering a crash in previous releases.
- fix parsing of invalid invalid octal strings.
- ... and manpage updates.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.5 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--HdaEK2XXNW/pfm7h
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.7.txt"
Content-Transfer-Encoding: 8bit

Fernando F. Mancera (1):
      src: add support to command "destroy"

Florian Westphal (1):
      evaluate: set eval ctx for add/update statements with integer constants

Jeremy Sowden (4):
      scanner: treat invalid octal strings as strings
      netlink_delinearize: add postprocessing for payload binops
      evaluate: relax type-checking for integer arguments in mark statements
      src: fix a couple of typo's in comments

Máté Eckl (1):
      src: Update copyright header to GPLv2+ in socket.c

Pablo Neira Ayuso (43):
      evaluate: fix shift exponent underflow in concatenation evaluation
      ct: use inet_service_type for proto-src and proto-dst
      src: Add GPLv2+ header to .c files of recent creation
      src: add eval_proto_ctx()
      src: add dl_proto_ctx()
      src: add vxlan matching support
      tests: py: add vxlan tests
      tests: shell: add vxlan set tests
      doc: add vxlan matching expression
      src: display (inner) tag in --debug=proto-ctx
      src: add gre support
      tests: py: add gre tests
      doc: add gre matching expression
      src: add geneve matching support
      tests: py: add geneve tests
      doc: add geneve matching expression
      src: add gretap support
      tests: py: add gretap tests
      doc: add gretap matching expression
      optimize: payload expression requires inner_desc comparison
      intervals: restrict check missing elements fix to sets with no auto-merge
      tests: shell: extend runtime set element automerge to cover partial deletions
      optimize: wrap code to build concatenation in helper function
      optimize: fix incorrect expansion into concatenation with verdict map
      optimize: select merge criteria based on candidates rules
      rule: add helper function to expand chain rules into commands
      rule: expand standalone chain that contains rules
      optimize: ignore existing nat mapping
      evaluate: print error on missing family in nat statement
      evaluate: infer family from mapping
      optimize: infer family for nat mapping
      src: use start condition with new destroy command
      parser_bison: missing close scope in destroy start condition
      tests: shell: cover rule insertion by index
      src: expand table command before evaluation
      evaluate: expand value to range when nat mapping contains intervals
      src: add last statement
      parser_bison: allow to use quota in sets
      cache: fetch more objects when resetting rule
      tests: shell: use bash in 0011reset_0
      src: improve error reporting for unsupported chain type
      cmd: move command functions to src/cmd.c
      build: Bump version to 1.0.7

Phil Sutter (10):
      optimize: Clarify chain_optimize() array allocations
      optimize: Do not return garbage from stack
      netlink: Fix for potential NULL-pointer deref
      meta: parse_iso_date() returns boolean
      mnl: dump_nf_hooks() leaks memory in error path
      Implement 'reset rule' and 'reset rules' commands
      netlink_delinearize: Sanitize concat data element decoding
      doc: nft.8: Document lower priority limit for nat type chains
      xt: Fix fallback printing for extensions matching keywords
      Reject invalid chain priority values in user space


--HdaEK2XXNW/pfm7h--
