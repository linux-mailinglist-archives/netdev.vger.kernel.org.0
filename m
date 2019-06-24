Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E72518FA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbfFXQtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:49:23 -0400
Received: from mail.us.es ([193.147.175.20]:60710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731993AbfFXQtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 12:49:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D14D26D4E6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 18:49:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B41BDDA70D
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 18:49:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A95E1DA70B; Mon, 24 Jun 2019 18:49:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-107.0 required=7.5 tests=ALL_TRUSTED,BAYES_80,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C314DA703;
        Mon, 24 Jun 2019 18:49:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Jun 2019 18:49:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 62F474265A2F;
        Mon, 24 Jun 2019 18:49:11 +0200 (CEST)
Date:   Mon, 24 Jun 2019 18:49:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 0.9.1 release
Message-ID: <20190624164910.defehs5giqziqnir@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hvxqkqszzuewk4v5"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hvxqkqszzuewk4v5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi!

The Netfilter project proudly presents:

        nftables 0.9.1

This release contains fixes and new features, available up with Linux
kernels >= 5.2.

* IPsec support, which allows matching on IPsec tunnel/beet addresses in xfrm
  state associated with a packet, IPsec request id and the SPI, eg.

        ... ipsec in ip saddr 192.168.1.0/24
        ... ipsec out ip6 daddr @endpoints
        ... ipsec in spi 1-65536

  You can also check if the route performs ipsec tunneling, eg.

        filter output rt ipsec missing drop

  otherwise, drop it.

* IGMP matching support, eg.

        # nft add rule netdev foo bar igmp type membership-query counter drop

  If you want to drop IGMP membership queries from the ingress path.

* Use variable to define jump / goto chain, eg.

        define dest = ber

        add table ip foo
        add chain ip foo bar {type filter hook input priority 0;}
        add chain ip foo ber
        add rule ip foo ber counter
        add rule ip foo bar jump $dest

* Operating System fingerprint (osf) support, eg.

        ... meta mark set osf ttl skip name map { "Linux" : 0x1,
                                                  "Windows" : 0x2,
                                                  "MacOS" : 0x3,
                                                  "unknown" : 0x0 }

  This allows you to mark packets based on the guessed OS. If osf does
  not guess the OS, then traffic falls under the "unknown" OS type. Note
  that the example above skips TTL header field checks.

  You can also check for specific OS version:

        ... osf ttl skip version "Linux:4.20"

  This passive fingerprinting is based on the OS definitions available
  through the pf.os file.

* ARP sender and target IPv4 address matching, eg.

        table arp x {
                chain y {
                        type filter hook input priority filter; policy accept;
                        arp saddr ip 192.168.2.1 counter packets 1 bytes 46
                }
        }

  this updates rule counters for ARP packets originated from the
  192.168.2.1 address.

* transparent proxy support (tproxy), eg.

        table ip x {
                chain y {
                        type filter hook prerouting priority -150; policy accept;
                        tcp dport 80 tproxy to :8080
                }
        }

* socket mark support, to retrieve the socket mark that is set via setsockopt()
  with SO_MARK by the process, eg.

        table inet x {
                chain y {
                        type filter hook prerouting priority -150; policy accept;
                        tcp dport 8080 mark set socket mark
                }
        }

* Support for textual chain priorities, eg.

        nft add table ip x
        nft add chain ip x raw { type filter hook prerouting priority raw; }
        nft add chain ip x filter { type filter hook prerouting priority filter; }
        nft add chain ip x filter_later { type filter hook prerouting priority filter + 10; }

   which are listed in textual priority by default. You can disable this
   via -y option, eg. nft -y list ruleset.

* Secmark support, eg.

        # nft add secmark inet filter sshtag \"system_u:object_r:ssh_server_packet_t:s0\"

  This defines the "sshtag" for this secctx context string, then, you
  can use it from rules to set the secmark:

        # nft add rule inet filter input tcp dport 22 meta secmark set "sshtag"

  you may also combine this with maps:

        # nft add map inet filter secmapping { type inet_service : secmark\; }
        # nft add element inet filter secmapping { 22 : "sshtag" }
        # nft add rule inet filter input meta secmark set tcp dport map @secmapping

* Honor /etc/services, eg.

        # nft add rule x y tcp dport \"ssh\"
        # nft list ruleset -l
        table x {
                chain y {
                        ...
                        tcp dport "ssh"
                }
        }

  You can list this numerically via -S option.

* Interface kind support, eg.

        add rule inet raw prerouting meta iifkind "vrf" accept

  oifkind is also available from the output path.

* Improve support for dynamic set updates, though explicit dynamic flag for
  set updates from the packet path. Syntax has been also updated, eg.

        # cat dynamic-sets.nft
        add table x
        add set x s { type ipv4_addr; size 128; timeout 30s; flags dynamic; }
        add chain x y { type filter hook input priority 0; }
        add rule x y update @s { ip saddr }

  This ruleset updates the set 's' by adding IPv4 source addresses. For
  each packets seen, the timer is refreshed, after 30 seconds of no
  packets seen for this address, this entry expires.

        # nft -f dynamic-sets.nft
        # nft list set x s
        table ip x {
                set s {
                        type ipv4_addr
                        size 128
                        flags dynamic,timeout
                        timeout 30s
                        elements = { 47.215.7.47 expires 26s484ms,
                                     112.212.124.247 expires 25s268ms }
                }
        }

  use this 'dynamic' flag to indicate the kernel that this set will be
  updated from the packet path.

  You can also combine this with stateful expressions, eg.

        table ip x {
                set xyz {
                        type ipv4_addr
                        size 65535
                        flags dynamic,timeout
                        timeout 1h
                }

                chain y {
                        type filter hook output priority filter; policy accept;
                        update @xyz { ip daddr counter } counter
                }
        }

  where each entry in 'xyz' gets a counter.

* Support for connection tracking timeout policies, this allows
  to attach specific timeout policies to flows, eg.

        table ip filter {
                ct timeout agressive-tcp {
                        protocol tcp;
                        l3proto ip;
                        policy = {established: 100, close_wait: 4, close: 4}
                }
                chain output {
                        ...
                        tcp dport 8888 ct timeout set "agressive-tcp"
                }
        }

  that allows you to override the default timeout policy
  (via /proc/sys/net/netfilter/nf_conntrack_*_timeout_* sysctl) for
  packets going to TCP dport 8888.

* NAT support for the inet family, eg.

        table inet nat {
                ...
                ip6 daddr dead::2::1 dnat to dead:2::99
        }

* Improved error reporting through misspell suggestions:

        # nft add table filter
        # nft add chain filtre test
        Error: No such file or directory; did you mean table â€˜filterâ€™ in family ip?
        add chain filtre test
                  ^^^^^^

* Print default policy in traces, eg.

        # nft add rule x y meta nftrace set 1
        # nft monitor trace
        trace id 6f2db0af ip x y packet: ...
        trace id 6f2db0af ip x y rule meta nftrace set 1 (verdict continue)
        trace id 6f2db0af ip x y verdict continue
        trace id 6f2db0af ip x y policy accept

* Allow interface names in sets, eg.

        set sc {
               type inet_service . ifname
               elements = { "ssh" . "eth0" }
        }

* Update flowtable rule syntax.

        # nft add table x
        # nft add flowtable x ft { hook ingress priority 0\; devices = { eth0, wlan0 }\; }
        ...
        # nft add rule x forward ip protocol { tcp, udp } flow add @ft

  Prefer 'flow add @ft' for consistency with set and map syntax.

* Improved JSON support.

* Very simple python class which gives access to libnftables API via
  ctypes module.

* A few library documentation updates, see:

        man(3) libnftables
        man(5) libnftables-json

* And memory and file descriptor leak fixes, improved cache logic, among
  many other changes behind the scene...

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.1
ftp://ftp.netfilter.org/pub/nftables/

To build the code, libnftnl 1.1.3 and libmnl >= 1.0.3 are required:

* http://netfilter.org/projects/libnftnl/index.html
* http://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* http://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature request, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--hvxqkqszzuewk4v5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-nftables-0.9.1.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero Gonzalez (1):
      tests: fix return codes

Arushi Singhal (6):
      nftables: Fix typos/Grammatical Errors
      nftables: tests: shell: Replace "%" with "#" or "$"
      nft: doc: Convert man page source to asciidoc
      doc: correct some typos in asciidoc
      nft: doc: fix typos in asciidoc
      nft: doc: fix make distcheck

Christian Göttsche (1):
      src: add support for setting secmark

Duncan Roe (10):
      doc: Remove UTF8(?) sequences
      doc: resolve run-together IPv6 address specification headers
      doc: Miscellaneous spelling fixes
      doc: Changes following detailed comparison with last XML version
      doc: user niggles
      doc: Remove double-spacing in text
      doc: Add script to build PDF files
      rule: Fix build failure in rule.c
      doc: Re-work RULES:add/insert/replace to read better.
      doc: libnftables.adoc misc cleanups

Eric Garver (5):
      parser_json: default to unspecified l3proto for ct helper/timeout
      parser_json: fix off by one index on rule add/replace
      parser_json: fix crash on add rule to bad references
      py: fix missing decode/encode of strings
      src: update cache if cmd is more specific

Eric Leblond (8):
      configure.ac: better message when a2x is missing
      configure.ac: remove useless braces in messages
      configure.ac: docbook2man invalid syntax error
      python: installation of binding via make install
      python: set license and author in nftables.py
      doc: fix make distcheck
      tests/py: minor cleaning
      tests/py: fix import when run from other directory

Fernando Fernandez Mancera (23):
      src: fix a typo in socket.h
      src: introduce passive OS fingerprint matching
      tests: py: add test cases for "osf" matching
      doc: add osf expression to man page
      test: py: fix osf testcases warning
      src: use NFT_OSF_MAXGENRELEN instead of IFNAMSIZ in osf.c
      tests: improve test cases for osf
      files: osf: copy iptables/utils/pf.os into nftables tree
      src: mnl: make nft_mnl_talk() public
      src: osf: import nfnl_osf.c to load osf fingerprints
      src: osf: load pf.os from expr_evaluate_osf()
      include: add missing xfrm.h to Makefile.am
      osf: add ttl option support
      doc: osf: add ttl option to man page
      doc: update nft list plural form parameters
      osf: add version fingerprint support
      json: osf: add version json support
      tests: py: add osf tests with versions
      doc: add osf version option to man page
      files: osf: update pf.os with newer OS fingerprints
      files: pf.os: merge the signatures splitted by version
      src: Introduce chain_expr in jump and goto statements
      src: Allow goto and jump to a variable

Florian Westphal (52):
      datatype: add stolen verdict
      src: trace: fix policy printing
      rule: limit: don't print default burst value
      doc: describe dynamic flag and caveats for packet-path updates
      nft: set: print dynamic flag when set
      tests: check ifname use in concatenated sets
      tests: add test case for rename-to-same-name
      src: meta: always prefix 'meta' for almost all tokens
      doc: remove nft.xml from CLEANFILES
      parser: avoid nf_key_proto redefinitions
      src: osf: add json support
      src: tproxy: relax family restrictions
      src: tproxy: add json support
      tests: fix json output for osf, socket and tproxy expressions
      proto: fix icmp/icmpv6 code datatype
      evaluate: throw distinct error if map exists but contains no objects
      src: rt: add support to check if route will perform ipsec transformation
      src: rename meta secpath to meta ipsec
      documentation: clarify iif vs. iifname
      xt: pass octx to translate function
      xt: always build with a minimal support for xt match/target decode
      tests: add test case for rule replacement expression deactivation
      xt: fix build when libxtables is not installed
      xt: fix build with --with-xtables
      rule: fix object listing when no table is given
      tests: shell: add test case for leaking of stateful object refcount
      tests: shell: change all test scripts to return 0
      tests: shell: fix up redefine test case
      tests: shell: remove RETURNCODE_SEPARATOR
      src: fix netdev family device name parsing
      payload: refine payload expr merging
      mnl: name is ignored when deleting a table
      doc: fix non-working example
      tests: fix up expected payloads after expr merge change
      src: expr: add and use expr_name helper
      src: payload: export and use payload_expr_cmp
      src: expr: add and use internal expr_ops helper
      src: expr: add expression etype
      src: expr: remove expr_ops from struct expr
      src: expr: fix build failure with json support
      doc: update goto/jump help text
      segtree: fix crash when debug mode is active
      tests: add test case for anon set abort.
      src: add nat support for the inet family
      src: fix double free on xt stmt destruction
      tests: shell: avoid single-value anon sets
      tests: py: remove single-value-anon-set test cases
      datatype: fix print of raw numerical symbol values
      tests: add missing json arp operation output
      netlink_delinerize: remove network header dep for reject statement also in bridge family
      src: statement: disable reject statement type omission for bridge
      src: prefer meta protocol as bridge l3 dependency

Harsha Sharma (6):
      rule: list only the table containing object
      tests: shell: add tests for listing objects
      src: add ct timeout support
      tests: py: add ct timeout tests
      tests: shell: add tests for ct timeout objects
      doc: Document ct timeout support

Jan Engelhardt (1):
      doc: grammar fixes

Laura Garcia Liebana (2):
      json: fix json_events_cb() declaration when libjansson is not present
      parser_json: fix segfault in translating string to nft object

Loganaden Velvindron (1):
      proto: support for draft-ietf-tsvwg-le-phb-10.txt

Luis Ressel (2):
      configure.ac: Fix a2x check
      configure.ac: Clean up AC_ARG_{WITH, ENABLE} invocations, s/==/=/

Máté Eckl (18):
      doc: Add socket expression to man page
      doc: nft.txt: Wrap extra long lines to 80 chars
      doc: data-types.txt: Wrap extra long lines to 80 chars
      doc: payload-expression.txt: Wrap extra long lines to 80 chars
      doc: primary-expression.txt: Wrap extra long lines to 80 chars
      doc: stateful-objects.txt: Wrap extra long lines to 80 chars
      doc: statements.txt: Wrap extra long lines to 80 chars
      src: Add tproxy support
      tests: py: Add test cases for tproxy support
      doc: Add tproxy statement to man page
      src: Expose socket mark via socket expression
      doc: fix syntax for RULES
      doc: Add comment possibility to man page
      src: Set/print standard chain prios with textual names
      src: Make invalid chain priority error more specific
      test: shell: Test cases for standard chain prios
      test: shell: Test cases for standard prios for flowtables
      src: add ipsec (xfrm) expression

Pablo Neira Ayuso (145):
      tests: build: cover --with-json too
      src: add dynamic flag and use it
      src: add --literal option
      doc: update manpage to document --literal option
      evaluate: skip evaluation of datatype concatenations
      tests: shell: validate maximum chain depth
      include: add missing osf.h
      parser_bison: allow to use new osf expression from assignment statement
      tests: py: test osf with sets
      tests: shell: validate too deep jumpstack from basechain
      tests: shell: fix 0012different_defines_0 with meta mark
      tests: shell: missing modules in cleanup path
      build: remove PDF documentation generation
      statement: incorrect spacing in set reference
      rule: do not print elements in dynamically populated sets with `-s'
      src: simplify map statement
      src: integrate stateful expressions into sets and maps
      src: honor /etc/services
      tests: build: no need for root to run build tests
      tests: build: run make distcheck from fresh clone
      tests: build: run make on each ./configure option
      tests: shell: missing dump for 0017ct_timeout_obj_0
      nfnl_osf: display debugging information from --debug=mnl
      segtree: bogus range via get set element on existing elements
      segtree: disantangle get_set_interval_end()
      segtree: memleak in get_set_decompose()
      rule: fix memleak in do_get_setelems()
      segtree: stop iteration on existing elements in case range is found
      netlink: remove markup json parsing code
      src: get rid of netlink_genid_get()
      mnl: remove alloc_nftnl_table()
      mnl: remove alloc_nftnl_chain()
      mnl: remove alloc_nftnl_rule()
      mnl: remove alloc_nftnl_set()
      src: remove netlink_flush_table()
      src: remove netlink_flush_chain()
      segtree: incorrect handling of last element in get_set_decompose()
      segtree: set proper error cause on existing elements
      src: remove opts field from struct xt_stmt
      evaluate: bogus bail out with raw expression from dynamic sets
      src: pass struct nft_ctx through struct eval_ctx
      src: pass struct nft_ctx through struct netlink_ctx
      netlink: reset mnl_socket field in struct nft_ctx on EINTR
      src: move socket open and reopen to mnl.c
      mnl: remove alloc_nftnl_obj()
      mnl: use either name or handle to refer to objects
      mnl: remove alloc_nftnl_flowtable()
      netlink: remove netlink_batch_send()
      evaluate: do not pass EXPR_SET_ELEM to stmt_evaluate_arg() for set/map evaluation
      evaluate: stmt_evaluate_map() needs right hand side evaluation too
      src: Revert --literal, add -S/--service
      src: add nft_ctx_output_{get,set}_stateless() to nft_ctx_output_{get,flags}_flags
      src: add nft_ctx_output_{get,set}_handle() to nft_ctx_output_{get,set}_flags
      src: add nft_ctx_output_{get,set}_json() to nft_ctx_output_{get,set}_flags
      src: add nft_ctx_output_{get,set}_echo() to nft_ctx_output_{get,set}_flags
      src: default to numeric UID and GID listing
      src: add NFT_CTX_OUTPUT_NUMERIC_PROTO
      src: add -y to priority base chain nummerically
      src: get rid of nft_ctx_output_{get,set}_numeric()
      src: add -p to print layer 4 protocol numerically
      expression: always print range expression numerically
      doc: remove unnecessary extra asterisk at the end of option line
      src: introduce simple hints on incorrect table
      src: introduce simple hints on incorrect chain
      src: introduce simple hints on incorrect set
      utils: remove type checks in min() and max()
      src: provide suggestion for misspelled object name
      misspell: add distance threshold for suggestions
      src: introduce simple hints on incorrect object
      src: introduce simple hints on incorrect identifier
      doc: nft: document ct count
      parser: bail out on incorrect burst unit
      src: remove deprecated code for export/import commands
      doc: refer to meta protocol in icmp and icmpv6
      src: add igmp support
      include: add cplusplus guards for extern
      tests: shell: exercise abort path with anonymous set that is bound to rule
      tests: shell: flush after rule deletion
      segtree: remove dummy debug_octx
      segtree: add missing non-matching segment to set in flat representation
      evaluate: misleading error reporting with sets and maps
      tests: shell: bogus EBUSY in set deletion after flush
      tests: shell: bogus ENOENT on element deletion in interval set
      tests: shell: bogus EBUSY on helper deletion from transaction
      parser_bison: no need for statement separator for ct object commands
      src: file descriptor leak in include_file()
      build: missing misspell.h in Makefile.am
      src: use 'flow add' syntax
      evaluate: skip binary transfer for named sets
      parser_bison: missing tproxy syntax with port only for inet family
      evaluate: improve error reporting in tproxy with inet family
      ct: use nft_print() instead of printf()
      parser_bison: type_identifier string memleak
      src: missing destroy function in statement definitions
      src: memleak in expressions
      segtree: fix memleak in interval_map_decompose()
      Revert "proto: support for draft-ietf-tsvwg-le-phb-10.txt"
      include: refresh nf_tables.h cached copy
      src: use definitions in include/linux/netfilter/nf_tables.h
      include: refresh nf_tables.h cached copy
      Revert "tests: py: remove single-value-anon-set test cases"
      Revert "tests: shell: avoid single-value anon sets"
      src: support for arp sender and target ethernet and IPv4 addresses
      src: add cache_is_complete() and cache_is_updated()
      tests: replace single element sets
      mnl: add mnl_set_rcvbuffer() and use it
      mnl: mnl_set_rcvbuffer() skips buffer size update if it is too small
      mnl: call mnl_set_sndbuffer() from mnl_batch_talk()
      mnl: add mnl_nft_batch_to_msg()
      mnl: estimate receiver buffer size
      mnl: mnl_batch_talk() returns -1 on internal netlink errors
      erec: remove double \n on error when internal_netlink is used
      src: dynamic input_descriptor allocation
      src: perform evaluation after parsing
      src: Display parser and evaluate errors in one shot
      src: single cache_update() call to build cache before evaluation
      src: generation ID is 32-bit long
      rule: ensure cache consistency
      evaluate: use-after-free in implicit set
      libnftables: keep evaluating until parser_max_errors
      mnl: bogus error when running monitor mode
      libnftables: check for errors after evaluations
      src: invalid read when importing chain name
      src: invalid read when importing chain name (trace and json)
      expression: use expr_clone() from verdict_expr_clone()
      netlink_delinearize: release expressions in context registers
      netlink_delinearize: release expression before calling netlink_parse_concat_expr()
      parser_bison: free chain name after creating constant expression
      src: add reference counter for dynamic datatypes
      datatype: dtype_clone() should clone flags too
      netlink_delinearize: use-after-free in expr_postprocess_string()
      evaluate: use-after-free in meter
      evaluate: update byteorder only for implicit maps
      evaluate: double datatype_free() with dynamic integer datatypes
      cache: do not populate the cache in case of flush ruleset command
      src: remove useless parameter from cache_flush()
      tests: shell: cannot use handle for non-existing rule in kernel
      rule: skip cache population from do_command_monitor()
      netlink: remove netlink_list_table()
      src: add cache level flags
      evaluate: allow get/list/flush dynamic sets and maps via list command
      evaluate: do not allow to list/flush anonymous sets via list command
      rule: do not suggest anonymous sets on mispelling errors
      ct: support for NFT_CT_{SRC,DST}_{IP,IP6}
      build: Bump version to v0.9.1

Phil Sutter (112):
      JSON: Call verdict maps 'vmap' in JSON as well
      tests/py: Fix JSON for flowtable tests
      JSON: Don't print burst if equal to 5
      JSON: Add support for socket expression
      JSON: Add support for connlimit statement
      JSON: Support latest enhancements of fwd statement
      doc: Add JSON schema documentation
      doc: Add libnftables man page
      doc: Fix typo in Makefile.am
      libnftables: Fix exit_cookie()
      libnftables: Simplify nft_run_cmd_from_buffer footprint
      scanner: Do not convert tabs into spaces
      doc: libnftables-json: Review asciidoc syntax
      Makefile: Introduce Make_global.am
      netlink_delinearize: Refactor meta_may_dependency_kill()
      evaluate: reject: Allow icmpx in inet/bridge families
      json: Fix compile error
      tests: py: Fix coloring of differences
      doc: Document implicit dependency creation for icmp/icmpv6
      doc: Improve example in libnftables-json(5)
      doc: Review libnftables-json.adoc
      JSON: Make meta statement/expression extensible
      JSON: Review verdict statement and expression
      JSON: Review payload expression
      JSON: Rename (v)map expression properties
      JSON: Rename mangle statement properties
      JSON: Make match op mandatory, introduce 'in' operator
      JSON: Add metainfo object to all output
      py: trivial: Fix typo in comment string
      parser_json: Fix crash in error reporting
      tests/py: Make nft-test.py a little more robust
      src: Fix literal check for inet_service type
      tests/py: Check differing rule output for sanity
      json: Fix datatype_json() for literal level
      json: Make inet_service_type_json() respect literal level
      json: Print range expressions numerically
      tests/py: Fix JSON for icmp*.t
      nft.8: Update meta pkt_type value description
      doc: Review man page building in Makefile.am
      parser_bison: Fix for chain prio name 'out'
      tests: shell: Fix indenting in 0021prio_0
      tests: shell: Drop one-time use variables in 0021prio_0
      tests: shell: Improve gen_chains() in 0021prio_0
      tests: shell: Improve performance of 0021prio_0
      tests: shell: Test 'get element' command
      parser_bison: Fix for ECN keyword in LHS of relational
      tests/py: Add missing JSON bits for inet/meta.t
      json: Drop unused symbolic_constant_json() stub
      json: Add ct timeout support
      monitor: Drop fake XML support
      monitor: Drop 'update table' and 'update chain' cases
      monitor: Fix printing of ct objects
      monitor: Use libnftables JSON output
      tests: monitor: Test JSON output as well
      Fix memleak in netlink_parse_fwd() error path
      libnftables: Fix memleak in nft_parse_bison_filename()
      parser_json: Fix for ineffective family value checks
      json: Fix memleak in dup_stmt_json()
      tests: shell: Extend get element test
      include: Fix comment for struct eval_ctx
      json: Fix osf ttl support
      json: Fix for recent changes to context structs
      mnl: Improve error checking in mnl_nft_event_listener()
      json: Work around segfault when encountering xt stmt
      tests/shell: Add testcase for cache update problems
      JSON: Add support for echo option
      nft.8: Document log level audit
      py: Adjust Nftables class to output flags changes
      doc: Fix for make distcheck
      nft.8: Clarify 'index' option of add rule command
      src: Reject 'export vm json' command
      libnftables: Print errors before freeing commands
      parser_json: Duplicate chain name when parsing jump verdict
      parser_json: Use xstrdup() when parsing rule comment
      json: Fix memleaks in echo support
      parser_json: Respect base chain priority
      parser_json: Rewrite echo support
      doc: Add minimal description of (v)map statements
      parser_json: Disallow ct helper as type to map to
      tests: monitor: Adjust to changed events ordering
      tests/py: Fix error messages in chain_delete()
      parser_json: Fix typo in ct timeout policy parser
      parser_json: Fix parser for list maps command
      src: use UDATA defines from libnftnl
      py: Fix gitignore of lib/ directory
      doc: Review man page synopses
      json: Support nat in inet family
      parser_json: Fix igmp support
      netlink: Fix printing of zero-length prefixes
      tests/py: Fix JSON equivalents of osf tests
      json: Fix tproxy support regarding latest changes
      parser_json: Fix ct timeout object support
      tests/py: Fix JSON expected output after expr merge change
      tests/py: Fix JSON expected output for icmpv6 code values
      parser_json: Fix and simplify verdict expression parsing
      tests/shell: Test large transaction with echo output
      mnl: Initialize fd_set before select(), not after
      mnl: Simplify mnl_batch_talk()
      py: Implement JSON validation in nftables module
      tests/py: Support JSON validation
      src: Fix cache_flush() in cache_needs_more() logic
      libnftables: Drop cache in error case
      cache: Fix evaluation for rules with index reference
      tests/json_echo: Drop needless workaround
      rule: Introduce rule_lookup_by_index()
      src: Make cache_is_complete() public
      src: Support intra-transaction rule references
      tests/py: Fix JSON equivalents
      tests/py: Add missing arp.t JSON equivalents
      tests/shell: Fix warning from awk call
      tests/shell: Print unified diffs in dump errors
      monitor: Accept -j flag

Rosen Penev (1):
      gmputil: Add missing header for va_list

Shekhar Sharma (1):
      tests: json_echo: convert to py3

Ville Skyttä (1):
      doc: Spelling and grammar fixes

wenxu (1):
      meta: add iifkind and oifkind support


--hvxqkqszzuewk4v5--
