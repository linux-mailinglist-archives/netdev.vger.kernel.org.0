Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3588358F5CF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbiHKCXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiHKCXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7428D3FC;
        Wed, 10 Aug 2022 19:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E78CBB81EF7;
        Thu, 11 Aug 2022 02:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F50C433D6;
        Thu, 11 Aug 2022 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660184590;
        bh=mv/XXchJz6Vmj56lja0YTvebF5FIdz+LcprxdGAVBvU=;
        h=From:To:Cc:Subject:Date:From;
        b=RpdhGCC2/sAbyO5YLgwzvYzfonqlJ4b0EWDvPt8mxqgHP12ql+jlc+/dtuHEAAdEC
         E63Q2onk//Nj4OWyiUIbgCXn6AyjGFQ7AR6niStSWHxQ8YLvSWqsPWFaTRzvwwg1Xo
         u/WIgowjqEtnWFrH3BMJERgC90sxzVt61p5QeLSerywiVo1FBkw3OS1O7vagXCbR5G
         4Itf0lyfIcL5f7dPJd4ynVg30CPa84pp+E97/WTYpG/7IjaGoxoLjtjRKqt3L++d9m
         U18Xc6PBJdum+I/oEXyn3lr+rzRLR8ZIRT4o/EeZmxmbyfL7y8z3Em1xrAeMC1hVnd
         +eRjpClImJChg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Date:   Wed, 10 Aug 2022 19:23:00 -0700
Message-Id: <20220811022304.583300-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink seems simple and reasonable to those who understand it.
It appears cumbersome and arcane to those who don't.

This RFC introduces machine readable netlink protocol descriptions
in YAML, in an attempt to make creation of truly generic netlink
libraries a possibility. Truly generic netlink library here means
a library which does not require changes to support a new family
or a new operation.

Each YAML spec lists attributes and operations the family supports.
The specs are fully standalone, meaning that there is no dependency
on existing uAPI headers in C. Numeric values of all attribute types,
operations, enums, and defines and listed in the spec (or unambiguous).
This property removes the need to manually translate the headers for
languages which are not compatible with C.

The expectation is that the spec can be used to either dynamically
translate between whatever types the high level language likes (see
the Python example below) or codegen a complete libarary / bindings
for a netlink family at compilation time (like popular RPC libraries
do).

Currently only genetlink is supported, but the "old netlink" should
be supportable as well (I don't need it myself).

On the kernel side the YAML spec can be used to generate:
 - the C uAPI header
 - documentation of the protocol as a ReST file
 - policy tables for input attribute validation
 - operation tables

We can also codegen parsers and dump helpers, but right now the level
of "creativity & cleverness" when it comes to netlink parsing is so
high it's quite hard to generalize it for most families without major
refactoring.

Being able to generate the header, documentation and policy tables
should balance out the extra effort of writing the YAML spec.

Here is a Python example I promised earlier:

  ynl = YnlFamily("path/to/ethtool.yaml")
  channels = ynl.channels_get({'header': {'dev_name': 'eni1np1'}})

If the call was successful "channels" will hold a standard Python dict,
e.g.:

  {'header': {'dev_index': 6, 'dev_name': 'eni1np1'},
   'combined_max': 1,
   'combined_count': 1}

for a netdevsim device with a single combined queue.

YnlFamily is an implementation of a YAML <> netlink translator (patch 3).
It takes a path to the YAML spec - hopefully one day we will make
the YAMLs themselves uAPI and distribute them like we distribute
C headers. Or get them distributed to a standard search path another
way. Until then, the YNL library needs a full path to the YAML spec and
application has to worry about the distribution of those.

The YnlFamily reads all the info it needs from the spec, resolves
the genetlink family id, and creates methods based on the spec.
channels_get is such a dynamically-generated method (i.e. grep for
channels_get in the python code shows nothing). The method can be called
passing a standard Python dict as an argument. YNL will look up each key
in the YAML spec and render the appropriate binary (netlink TLV)
representation of the value. It then talks thru a netlink socket
to the kernel, and deserilizes the response, converting the netlink
TLVs into Python types and constructing a dictionary.

Again, the YNL code is completely generic and has no knowledge specific
to ethtool. It's fairly simple an incomplete (in terms of types
for example), I wrote it this afternoon. I'm also pretty bad at Python,
but it's the only language I can type which allows the method
magic, so please don't judge :) I have a rather more complete codegen
for C, with support for notifications, kernel -> user policy/type
verification, resolving extack attr offsets into a path
of attribute names etc, etc. But that stuff needs polishing and
is less suitable for an RFC.

The ability for a high level language like Python to talk to the kernel
so easily, without ctypes, manually packing structs, copy'n'pasting
values for defines etc. excites me more than C codegen, anyway.


Patch 1 adds a bit of documentation under Documentation/, it talks
more about the schemas themselves.

Patch 2 contains the YAML schema for the YAML specs.

Patch 3 adds the YNL Python library.

Patch 4 adds a sample schema for ethtool channels and a demo script.


Jakub Kicinski (4):
  ynl: add intro docs for the concept
  ynl: add the schema for the schemas
  ynl: add a sample python library
  ynl: add a sample user for ethtool

 Documentation/index.rst                     |   1 +
 Documentation/netlink/bindings/ethtool.yaml | 115 +++++++
 Documentation/netlink/index.rst             |  13 +
 Documentation/netlink/netlink-bindings.rst  | 104 ++++++
 Documentation/netlink/schema.yaml           | 242 ++++++++++++++
 tools/net/ynl/samples/ethtool.py            |  30 ++
 tools/net/ynl/samples/ynl.py                | 342 ++++++++++++++++++++
 7 files changed, 847 insertions(+)
 create mode 100644 Documentation/netlink/bindings/ethtool.yaml
 create mode 100644 Documentation/netlink/index.rst
 create mode 100644 Documentation/netlink/netlink-bindings.rst
 create mode 100644 Documentation/netlink/schema.yaml
 create mode 100755 tools/net/ynl/samples/ethtool.py
 create mode 100644 tools/net/ynl/samples/ynl.py

-- 
2.37.1

