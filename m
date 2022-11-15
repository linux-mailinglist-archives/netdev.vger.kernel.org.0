Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1305062922A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiKOHJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbiKOHJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:26 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD91BC81
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:18 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id ED85615F0F5D; Mon, 14 Nov 2022 23:09:04 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v3 0/3] io_uring: add napi busy polling support
Date:   Mon, 14 Nov 2022 23:08:57 -0800
Message-Id: <20221115070900.1788837-1-shr@devkernel.io>
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

This adds the napi busy polling support in io_uring.c. It adds a new
napi_list to the io_ring_ctx structure. This list contains the list of
napi_id's that are currently enabled for busy polling. This list is
used to determine which napi id's enabled busy polling.

To set the new napi busy poll timeout, a new io-uring api has been
added. It sets the napi busy poll timeout for the corresponding ring.

There is also a corresponding liburing patch series, which enables this
feature. The name of the series is "liburing: add add api for napi busy
poll timeout". It also contains two programs to test the this.

Testing has shown that the round-trip times are reduced to 38us from
55us by enabling napi busy polling with a busy poll timeout of 100us.


Changes:
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


Signed-off-by: Stefan Roesch <shr@devkernel.io>

Stefan Roesch (3):
  io_uring: add napi busy polling support
  io_uring: add api to set napi busy poll timeout.
  io_uring: add api to set napi prefer busy poll

 include/linux/io_uring_types.h |   8 +
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/io_uring.c            | 278 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  22 +++
 io_uring/poll.c                |   3 +
 io_uring/sqpoll.c              |  10 ++
 6 files changed, 325 insertions(+)
 create mode 100644 io_uring/napi.h


base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
--=20
2.30.2

