Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19E12106D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLPRBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:01:43 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLPRBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:01:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNAP18M8lYxEc+cokob3lpdLDn7isLNKyIrcB6+tZKSn1+ftb0bbzF2pJ5n3w57PFelN/f7Xm4sRJOhKG646FAEct37crnWrZ83/WcDJbFbEYnL3XMtJ/QTa/51ysnMLxKIwT6FuuIcLey7HZgGenycu0YS+WNKCtKLTvGCNH2GKmIFJVo8Ph5FU/N0G8GviCCxRpQjYXi3OROV6MQhstjOWMllfdHgKdSiRW3VBQ3ks1+UiJH21+W+bCCBp0ML2JBE6a/hF66yULKMagtFMHWSEcGQsNi7nftTPKcl4yxDyb7gDmFLfzb106wexQeSFichRAk6Kyfo3TqFgjC4dJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFy1Dk03HDwn0JX0qz984GIH8Tq1HfTZqfJpGAZgncM=;
 b=e4I6qB/uk81+KlhpDlDxsjxGSUbw3nF6weqS0d378yq33BIgjq3BDlZh6uBsblgrNF3Y04t05z8x/4OsMz6xfXqQi9qmVaVS9k1N4Kago0olvcALhQNWdK7FS3yPi8MG/WkNEgxmZHZqix9tij6O2AF6lNXo7j/tJCAC78ayGjqkOVUflnFTpPyq4t3wVxPsmBl7b18RNrEfG2FUpqzcYnno8zOpZnTCVg4AEikiwwErKGikMPYtw7H+2JfZT1rGmBloBREKCrU7xSIYEckDgF3pytl7DnMUwW7kK1WM3TQw9rRFtckfQqjOniKGre+xshA4kwmLMDrJm2VTSC/Nug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFy1Dk03HDwn0JX0qz984GIH8Tq1HfTZqfJpGAZgncM=;
 b=kn79lte74g1Ie0yPcS7wrhzG2M+g79Krj9neJoHP2ZAtQkm5uvDcI4zavUsyS6s8n7Z5Vu8jZgdAouJCLk+nKOTEEEBNfQeqgK8FLIisnPUChmbu0P/+uMndpI4MxHW3C5k8ijLT4IzNBO+2/FdB3Q0BQDrubeCCKCyMaTT5PCk=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:37 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:37 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next mlxsw v1 00/10] Add a new Qdisc, ETS
Thread-Topic: [PATCH net-next mlxsw v1 00/10] Add a new Qdisc, ETS
Thread-Index: AQHVtDJ6JPi/8Zm5P0q0pMB/3bwNRQ==
Date:   Mon, 16 Dec 2019 17:01:36 +0000
Message-ID: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54be4357-3d0e-4deb-74a1-08d782499c26
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3014D727AD1C0621F4B97B72DB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(43544003)(186003)(6512007)(26005)(316002)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002)(30864003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jOB6CKiYhiBRbwPOt9QCOOzqoRSLFJmo91F5nUCfafgfTF4/CGR6tIkPnk7lNULqg4RVxfhV/fE2yiW/OHzjv5ZiggPrrSVAN/K2Eo0OG7K+RXyETY6whUCF4N9Eq3tBbyA2YTIa2OpxBTInQEsFF1yevJ8d/uxtXzvzOmUilyGCJe/8xi7n13stua66iHSc2Ygy4oN+W9nQhjydRbWdO6+gKmru2chYwpYKmrhPcOjtErdM4aPbzMUSL8aH66recNudhE08SMTD5m9+g7CKTsS077xUzIfcX3d9Rf5yJ7kYRbYK0CpXLG2KMPTEI7e1y1jVHHw6X9DjmcmjYCBDPkjTbYQyDLeyKLdL4I3Ids3j1eSkvaZHxT+TdR43pIgqTqQAIpJoAonk8KNdXwtLFLqDAp+RrjT3f1CEmwR5+2mhpDdTkQCIuWTrCb+EPhuAxEvrH6qs4q5pJH2cfHt7Wag37hht/568N5Zj3FqHIMirqP0F0hn/mGHg6WBIr7MK
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54be4357-3d0e-4deb-74a1-08d782499c26
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:37.1139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k61R39HxcinwJxMw4zGpLRhV8nIQGendGz+KknXcTUalCy5152TCMtkBuEMWX4UF/ecsa8mmR3GYKRofMAKlKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
transmission selection algorithms: strict priority, credit-based shaper,
ETS (bandwidth sharing), and vendor-specific. All these have their
corresponding knobs in DCB. But DCB does not have interfaces to configure
RED and ECN, unlike Qdiscs.

In the Qdisc land, strict priority is implemented by PRIO. Credit-based
transmission selection algorithm can then be modeled by having e.g. TBF or
CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
placing a DRR Qdisc under the last PRIO band.

The problem with this approach is that DRR on its own, as well as the
combination of PRIO and DRR, are tricky to configure and tricky to offload
to 802.1Qaz-compliant hardware. This is due to several reasons:

- As any classful Qdisc, DRR supports adding classifiers to decide in which
  class to enqueue packets. Unlike PRIO, there's however no fallback in the
  form of priomap. A way to achieve classification based on packet priority
  is e.g. like this:

    # tc filter add dev swp1 root handle 1: \
		basic match 'meta(priority eq 0)' flowid 1:10

  Expressing the priomap in this manner however forces drivers to deep dive
  into the classifier block to parse the individual rules.

  A possible solution would be to extend the classes with a "defmap" a la
  split / defmap mechanism of CBQ, and introduce this as a last resort
  classification. However, unlike priomap, this doesn't have the guarantee
  of covering all priorities. Traffic whose priority is not covered is
  dropped by DRR as unclassified. But ASICs tend to implement dropping in
  the ACL block, not in scheduling pipelines. The need to treat these
  configurations correctly (if only to decide to not offload at all)
  complicates a driver.

  It's not clear how to retrofit priomap with all its benefits to DRR
  without changing it beyond recognition.

- The interplay between PRIO and DRR is also causing problems. 802.1Qaz has
  all ETS TCs as a last resort. Switch ASICs that support ETS at all are
  likely to handle ETS traffic this way as well. However, the Linux model
  is more generic, allowing the DRR block in any band. Drivers would need
  to be careful to handle this case correctly, otherwise the offloaded
  model might not match the slow-path one.

  In a similar vein, PRIO and DRR need to agree on the list of priorities
  assigned to DRR. This is doubly problematic--the user needs to take care
  to keep the two in sync, and the driver needs to watch for any holes in
  DRR coverage and treat the traffic correctly, as discussed above.

  Note that at the time that DRR Qdisc is added, it has no classes, and
  thus any priorities assigned to that PRIO band are not covered. Thus this
  case is surprisingly rather common, and needs to be handled gracefully by
  the driver.

- Similarly due to DRR flexibility, when a Qdisc (such as RED) is attached
  below it, it is not immediately clear which TC the class represents. This
  is unlike PRIO with its straightforward classid scheme. When DRR is
  combined with PRIO, the relationship between classes and TCs gets even
  more murky.

  This is a problem for users as well: the TC mapping is rather important
  for (devlink) shared buffer configuration and (ethtool) counters.

So instead, this patch set introduces a new Qdisc, which is based on
802.1Qaz wording. It is PRIO-like in how it is configured, meaning one
needs to specify how many bands there are, how many are strict and how many
are ETS, quanta for the latter, and priomap.

The new Qdisc operates like the PRIO / DRR combo would when configured as
per the standard. The strict classes, if any, are tried for traffic first.
When there's no traffic in any of the strict queues, the ETS ones (if any)
are treated in the same way as in DRR.

The chosen interface makes the overall system both reasonably easy to
configure, and reasonably easy to offload. The extra code to support ETS in
mlxsw (which already supports PRIO) is about 150 lines, of which perhaps 20
lines is bona fide new business logic.

Credit-based shaping transmission selection algorithm can be configured by
adding a CBS Qdisc under one of the strict bands (e.g. TBF can be used to a
similar effect as well). As a non-work-conserving Qdisc, CBS can't be
hooked under the ETS bands. This is detected and handled identically to DRR
Qdisc at runtime. Note that offloading CBS is not subject of this patchset.

The patchset proceeds in four stages:

- Patches #1-#3 are cleanups.
- Patches #4 and #5 contain the new Qdisc.
- Patches #6 and #7 update mlxsw to offload the new Qdisc.
- Patches #8-#10 add selftests for ETS.

Examples:

- Add a Qdisc with 6 bands, 3 strict and 3 ETS with 45%-30%-25% weights:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 4500 3000 2500 priom=
ap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5=20

- Tweak quantum of one of the classes of the previous Qdisc:

    # tc class ch dev swp1 classid 1:4 ets quantum 1000
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 1000 3000 2500 priom=
ap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5=20
    # tc class ch dev swp1 classid 1:3 ets quantum 1000
    Error: Strict bands do not have a configurable quantum.

- Purely strict Qdisc with 1:1 mapping between priorities and TCs:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 7 7=
 7 7 7 7 7 7=20

- Use "bands" to specify number of bands explicitly. Underspecified bands
  are implicitly ETS and their quantum is taken from MTU. The following
  thus gives each band the same weight:

    # tc qdisc add dev swp1 root handle 1: \
	ets bands 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514=
 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7=20

v1:
- No changes, first upstream submission after RFC.

v3 (internal):
- This addresses review from Jiri Pirko.
- Patch #3:
    - Rename to _HR_ instead of to _HIERARCHY_.
- Patch #4:
    - pkt_sched.h: Keep all the TCA_ETS_ constants in one enum.
    - pkt_sched.h: Rename TCA_ETS_BANDS to _NBANDS, _STRICT to _NSTRICT,
      _BAND_QUANTUM to _QUANTA_BAND and _PMAP_BAND to _PRIOMAP_BAND.
    - sch_ets.c: Update to reflect the above changes. Add a new policy,
      ets_class_policy, which is used when parsing class changes.
      Currently that policy is the same as the quanta policy, but that
      might change.
    - sch_ets.c: Move MTU handling from ets_quantum_parse() to the one
      caller that makes use of it.
    - sch_ets.c: ets_qdisc_priomap_parse(): WARN_ON_ONCE on invalid
      attribute instead of returning an extack.
- Patch #6:
    - __mlxsw_sp_qdisc_ets_replace(): Pass the weights argument to this
      function in this patch already. Drop the weight computation.
    - mlxsw_sp_qdisc_prio_replace(): Rename "quanta" to "zeroes" and
      pass for the abovementioned "weights".
    - mlxsw_sp_qdisc_prio_graft(): Convert to a wrapper around
      __mlxsw_sp_qdisc_ets_graft(), instead of invoking the latter
      directly from mlxsw_sp_setup_tc_prio().
    - Update to follow the _HIERACHY_ -> _HR_ renaming.
- Patch #7:
    - __mlxsw_sp_qdisc_ets_replace(): The "weights" argument passing and
      weight computation removal are now done in a previous patch.
    - mlxsw_sp_setup_tc_ets(): Drop case TC_ETS_REPLACE, which is handled
      earlier in the function.
- Patch #3 (iproute2):
    - Add an example output to the commit message.
    - tc-ets.8: Fix output of two examples.
    - tc-ets.8: Describe default values of "bands", "quanta".
    - q_ets.c: A number of fixes in error messages.
    - q_ets.c: Comment formatting: /*padding*/ -> /* padding */
    - q_ets.c: parse_nbands: Move duplicate checking to callers.
    - q_ets.c: Don't accept both "quantum" and "quanta" as equivalent.

v2 (internal):
- This addresses review from Ido Schimmel and comments from Alexander
  Kushnarov.
- Patch #2:
    - s/coment/comment in the commit message.
- Patch #4:
    - sch_ets: ets_class_is_strict(), ets_class_id(): Constify an argument
    - ets_class_find(): RXTify
- Patch #3 (iproute2):
    - tc-ets.8: some spelling fixes
    - tc-ets.8: add another example
    - tc.8: add an ETS to "CLASSFUL QDISCS" section

v1 (internal):
- This addresses RFC reviews from Ido Schimmel and Roman Mashak, bugs found
  by Alexander Petrovskiy and myself, and other improvements.
- Patch #2:
    - Expand the explanation with an explicit example.
- Patch #4:
    - Kconfig: s/sch_drr/sch_ets/
    - sch_ets: Reorder includes to be in alphabetical order
    - sch_ets: ets_quantum_parse(): Rename the return-pointer argument
      from pquantum to quantum, and use it directly, not going through a
      local temporary.
    - sch_ets: ets_qdisc_quanta_parse(): Convert syntax of function
      argument "quanta" from an array to a pointer.
    - sch_ets: ets_qdisc_priomap_parse(): Likewise with "priomap".
    - sch_ets: ets_qdisc_quanta_parse(), ets_qdisc_priomap_parse(): Invoke
      __nla_validate_nested directly instead of nl80211_validate_nested().
    - sch_ets: ets_qdisc_quanta_parse(): WARN_ON_ONCE on invalid attribute
      instead of returning an extack.
    - sch_ets: ets_qdisc_change(): Make the last band the default one for
      unmentioned priomap priorities.
    - sch_ets: Fix a panic when an offloaded child in a bandwidth-sharing
      band notified its ETS parent.
    - sch_ets: When ungrafting, add the newly-created invisible FIFO to
      the Qdisc hash
- Patch #5:
    - pkt_cls.h: Note that quantum=3D0 signifies a strict band.
    - Fix error path handling when ets_offload_dump() fails.
- Patch #6:
    - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function arguments
      "quanta" and "priomap" from arrays to pointers.
- Patch #7:
    - __mlxsw_sp_qdisc_ets_replace(): Convert syntax of function argument
      "weights" from an array to a pointer.
- Patch #9:
    - mlxsw/sch_ets.sh: Add a comment explaining packet prioritization.
    - Adjust the whole suite to allow testing of traffic classifiers
      in addition to testing priomap.
- Patch #10:
    - Add a number of new tests to test default priomap band, overlarge
      number of bands, zeroes in quanta, and altogether missing quanta.
- Patch #1 (iproute2):
    - State motivation for inclusion of this patch in the patcheset in the
      commit message.
- Patch #3 (iproute2):
    - tc-ets.8: it is now December
    - tc-ets.8: explain inactivity WRT using non-WC Qdiscs under ETS band
    - tc-ets.8: s/flow/band in explanation of quantum
    - tc-ets.8: explain what happens with priorities not covered by priomap
    - tc-ets.8: default priomap band is now the last one
    - q_ets.c: ets_parse_opt(): Remove unnecessary initialization of
      priomap and quanta.

Petr Machata (10):
  net: pkt_cls: Clarify a comment
  mlxsw: spectrum_qdisc: Clarify a comment
  mlxsw: spectrum: Rename MLXSW_REG_QEEC_HIERARCY_* enumerators
  net: sch_ets: Add a new Qdisc
  net: sch_ets: Make the ETS qdisc offloadable
  mlxsw: spectrum_qdisc: Generalize PRIO offload to support ETS
  mlxsw: spectrum_qdisc: Support offloading of ETS Qdisc
  selftests: forwarding: Move start_/stop_traffic from mlxsw to lib.sh
  selftests: forwarding: sch_ets: Add test coverage for ETS Qdisc
  selftests: qdiscs: Add test coverage for ETS Qdisc

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  11 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  21 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |   8 +-
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 219 +++-
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  36 +-
 include/uapi/linux/pkt_sched.h                |  17 +
 net/sched/Kconfig                             |  11 +
 net/sched/Makefile                            |   1 +
 net/sched/sch_ets.c                           | 802 +++++++++++++++
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  46 +-
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |  67 ++
 tools/testing/selftests/net/forwarding/lib.sh |  18 +
 .../selftests/net/forwarding/sch_ets.sh       |  44 +
 .../selftests/net/forwarding/sch_ets_core.sh  | 300 ++++++
 .../selftests/net/forwarding/sch_ets_tests.sh | 227 +++++
 .../tc-testing/tc-tests/qdiscs/ets.json       | 940 ++++++++++++++++++
 18 files changed, 2700 insertions(+), 71 deletions(-)
 create mode 100644 net/sched/sch_ets.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh
 create mode 100755 tools/testing/selftests/net/forwarding/sch_ets.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_core.sh
 create mode 100644 tools/testing/selftests/net/forwarding/sch_ets_tests.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ets.=
json

--=20
2.20.1

