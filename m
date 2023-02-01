Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48513687115
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 23:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBAWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 17:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjBAWkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 17:40:15 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37472CC60
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 14:40:11 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id C32D860FCAB6; Wed,  1 Feb 2023 14:23:25 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        Stefan Roesch <shr@meta.com>
Subject: [PATCH v6 0/3] io_uring: add napi busy polling support 
Date:   Wed,  1 Feb 2023 14:22:51 -0800
Message-Id: <20230201222254.744422-1-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Roesch <shr@meta.com>

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. This list is
used to determine which napi id's enabled busy polling. For faster
access it also adds a hash table.

When a new napi id is added, the hash table is used to locate if
the napi id has already been added. When processing the busy poll
loop the list is used to process the individual elements.

io-uring allows specifying two parameters:
- busy poll timeout and
- prefer busy poll to call of io_napi_busy_loop()
This sets the above parameters for the ring. The settings are passed
with a new structure io_uring_napi.

There is also a corresponding liburing patch series, which enables this
feature. The name of the series is "liburing: add add api for napi busy
poll timeout". It also contains two programs to test the this.

Testing has shown that the round-trip times are reduced to 38us from
55us by enabling napi busy polling with a busy poll timeout of 100us.
More detailled results are part of the commit message of the first
patch.


Changes:
- V6:
  - Add a hash table on top of the list for faster access during the
    add operation. The linked list and the hash table use the same
    data structure
- V5:
  - Refreshed to 6.1-rc6
  - Use copy_from_user instead of memdup/kfree
  - Removed the moving of napi_busy_poll_to
  - Return -EINVAL if any of the reserved or padded fields are not 0.
- V4:
  - Pass structure for napi config, instead of individual parameters
- V3:
  - Refreshed to 6.1-rc5
  - Added a new io-uring api for the prefer napi busy poll api and wire
    it to io_napi_busy_loop().
  - Removed the unregister (implemented as register)
  - Added more performance results to the first commit message.
- V2:
  - Add missing defines if CONFIG_NET_RX_BUSY_POLL is not defined
  - Changes signature of function io_napi_add_list to static inline
    if CONFIG_NET_RX_BUSY_POLL is not defined
  - define some functions as static



Stefan Roesch (3):
  io_uring: add napi busy polling support
  io_uring: add api to set / get napi configuration.
  io_uring: add api to set napi prefer busy poll

 include/linux/io_uring_types.h |  10 ++
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/io_uring.c            | 300 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  23 +++
 io_uring/poll.c                |   2 +
 io_uring/sqpoll.c              |  17 ++
 6 files changed, 364 insertions(+)
 create mode 100644 io_uring/napi.h


base-commit: c0b67534c95c537f7a506a06b98e5e85d72e2b7d
--=20
2.30.2

