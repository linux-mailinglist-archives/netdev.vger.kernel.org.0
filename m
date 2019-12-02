Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F28610F201
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfLBVRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:17:42 -0500
Received: from correo.us.es ([193.147.175.20]:60954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbfLBVRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 16:17:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 400868C3C61
        for <netdev@vger.kernel.org>; Mon,  2 Dec 2019 22:17:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CC25DA70C
        for <netdev@vger.kernel.org>; Mon,  2 Dec 2019 22:17:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 213C1DA709; Mon,  2 Dec 2019 22:17:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 829AADA702;
        Mon,  2 Dec 2019 22:17:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 22:17:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5BA2042EE38E;
        Mon,  2 Dec 2019 22:17:36 +0100 (CET)
Date:   Mon, 2 Dec 2019 22:17:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, lwn@lwn.net
Subject: [ANNOUNCE] nftables 0.9.3 release
Message-ID: <20191202211737.xvmd6e6xxj4xvvjl@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2truwrxgbgynyywq"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2truwrxgbgynyywq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 0.9.3

This release contains fixes and new features available up to the
upcoming Linux kernel 5.5-rc release.

* time matching support. You can combine this with ranges to match
  on specify date ranges:

  meta time \"2019-12-24 16:00\" - \"2020-01-02 7:00\"

  Hour ranges can be used too:

  meta hour \"17:00\" - \"19:00\"

  You can also match on a specificy week day:

  meta day \"Fri\"

  New -T option allows for printing time in seconds since Unix epoch.

* secmark restore / save support, eg.

  ct secmark set meta secmark
  meta secmark set ct secmark

* synproxy map support to improve scalability, eg.

 table ip foo {
            synproxy https-synproxy {
                    mss 1460
                    wscale 7
                    timestamp sack-perm
            }

            synproxy other-synproxy {
                    mss 1460
                    wscale 5
            }

            chain pre {
                    type filter hook prerouting priority raw; policy accept;
                    tcp dport 8888 tcp flags syn notrack
            }

            chain bar {
                    type filter hook forward priority filter; policy accept;
                    ct state invalid,untracked synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
            }
  }

  iptables requires one single rule per backend which might limit
  scalability in case of many backend servers.

* Dynamic set element deletion from the packet path, eg.

  nft add rule ... delete @set5 { ip6 saddr . ip6 daddr }

  to delete an entry from the set via rule based on the user-defined
  matching criteria.

* meta bridge vlan id and protocol matching, eg.

        meta ibrpvid 100
        meta ibrvproto vlan

  to match on the vlan over bridge device metadata.

* New -t/--terse option to exclude set elements from the ruleset listing:

 # nft -t list ruleset
 table ip x {
        set y {
                type ipv4_addr
        }
 }

 instead of:

 # nft list ruleset
 table ip x {
        set y {
                type ipv4_addr
                elements = { 192.168.10.2, 192.168.20.1,
                             192.168.4.4, 192.168.2.34 }
        }
 }

 Useful in case your set contains many elements.

* Multidevice chain in netdev family (available since upcoming 5.5-rc)

  add table netdev x
  add chain netdev x y { \
        type filter hook ingress devices = { eth0, eth1 } priority 0;
  }

  to consolidate common filter policies for several netdevices from
  the ingress path.

* description support for data types, eg.

 # nft describe ipv4_addr
 datatype ipv4_addr (IPv4 address) (basetype integer), 32 bits

* linenoise support for cli via --with-cli=linenoise, ie.

  ./configure --with-cli=linenoise

  as alternative to libreadline.

* manpage documentation updates.

* ... and bugfixes.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.3
ftp://ftp.netfilter.org/pub/nftables/

To build the code, libnftnl 1.1.4 and libmnl >= 1.0.3 are required:

* http://netfilter.org/projects/libnftnl/index.html
* http://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* http://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--2truwrxgbgynyywq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-nftables-0.9.3.txt"
Content-Transfer-Encoding: 8bit

Ander Juaristi (4):
      netfilter: support for element deletion
      evaluate: New internal helper __expr_evaluate_range
      meta: Introduce new conditions 'time', 'day' and 'hour'
      tests: add meta time test cases

Christian Göttsche (3):
      statement: make secmark statements idempotent
      src: add ability to set/get secmarks to/from connection
      files: add example secmark config

Eric Garver (6):
      cache: fix --echo with index/position
      tests: shell: check that rule add with index works with echo
      tests: shell: verify huge transaction returns expected number of rules
      tests: shell: add huge JSON transaction
      tests: shell: add huge transaction from firewalld
      parser_json: fix crash on insert rule to bad references

Eric Jallot (10):
      src: secmark: fix brace indentation and missing quotes in selctx output
      src: parser_json: fix crash while restoring secmark object
      src: obj: fix memleak in handle_free()
      tests: shell: fix failed tests due to missing quotes
      obj: fix memleak in parser_bison.y
      flowtable: fix memleak in exit path
      src: flowtable: add support for named flowtable listing
      doc: fix missing family in plural forms list command.
      src: flowtable: add support for delete command by handle
      scanner: fix out-of-bound memory write in include_file()

Fernando Fernandez Mancera (5):
      netlink_delinearize: fix wrong conversion to "list" in ct mark
      src: add synproxy stateful object support
      json: fix type mismatch on "ct expect" json exporting
      json: tests: fix typo in ct expectation json test
      tests: add stateful object update operation test

Florian Westphal (6):
      src: json: add support for element deletion
      src: evaluate: catch invalid 'meta day' values in eval step
      evaluate: flag fwd and queue statements as terminal
      src: meter: avoid double-space in list ruleset output
      tests: check we can use "dynamic" set for lookups
      expression: extend 'nft describe' to allow listing data types

Jeremy Sowden (11):
      configure: remove unused AC_SUBST macros.
      cli: remove unused declaration.
      cli: add linenoise CLI implementation.
      src: use `-T` as the short option for `--numeric-time`.
      src: add --terse to suppress output of set elements.
      doc: add missing output flag documentation.
      main: add missing `OPT_NUMERIC_PROTO` long option.
      main: remove duplicate output flag assignment.
      py: add missing output flags.
      src: add and use `set_is_meter` helper
      doc: fix inconsistency in set statement documentation.

Michal Rostecki (1):
      mnl: Fix -Wimplicit-function-declaration warnings

Pablo Neira Ayuso (15):
      tests: shell: use-after-free from abort path
      mnl: fix --echo buffer size again
      libnftables: use-after-free in exit path
      mnl: do not cache sender buffer size
      tests: shell: delete flowtable after flush chain
      libnftables: memleak when list of commands is empty
      segtree: always close interval in non-anonymous sets
      datatype: display description for header field < 8 bits
      src: define flowtable device compound as a list
      src: restore --echo with anonymous sets
      src: add multidevice support for netdev chain
      tests: shell: set reference from variable definition
      segtree: restore automerge
      netlink: off-by-one write in netdev chain device array
      build: Bump version to v0.9.3

Phil Sutter (25):
      parser_bison: Fix 'exists' keyword on Big Endian
      mnl: Don't use nftnl_set_set()
      monitor: Add missing newline to error message
      tests/monitor: Fix for changed ct timeout format
      rule: Fix for single line ct timeout printing
      parser_json: Fix checking of parse_policy() return code
      tproxy: Add missing error checking when parsing from netlink
      main: Fix for misleading error with negative chain priority
      Revert "main: Fix for misleading error with negative chain priority"
      tests/py: Fix test script for Python3 tempfile
      mnl: Replace use of untyped nftnl data setters
      doc: Drop incorrect requirement for nft configs
      libnftables: Store top_scope in struct nft_ctx
      meta: Rewrite hour_type_print()
      segtree: Check ranges when deleting elements
      segtree: Fix get element for little endian ranges
      cache: Reduce caching for get command
      parser_bison: Avoid set references in odd places
      files: Install sample scripts from files/examples
      files: Drop shebangs from config files
      scanner: Introduce numberstring
      nft.8: Describe numgen expression
      nft.8: Fix nat family spec position
      tests/py: Set a fixed timezone in nft-test.py
      segtree: Fix add and delete of element in same batch

Sergei Trofimovich (1):
      nftables: don't crash in 'list ruleset' if policy is not set

Sven Auhagen (1):
      mnl: remove artifical cap on 8 devices per flowtable

wenxu (1):
      meta: add ibrpvid and ibrvproto support


--2truwrxgbgynyywq--
