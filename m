Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF7D618A2A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiKCVEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiKCVEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:04:40 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371CF26F9
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:04:40 -0700 (PDT)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 4C267C4F609; Thu,  3 Nov 2022 13:39:54 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v1 0/2] io_uring: add napi busy polling support
Date:   Thu,  3 Nov 2022 13:39:37 -0700
Message-Id: <20221103203939.667307-1-shr@devkernel.io>
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

Signed-off-by: Stefan Roesch <shr@devkernel.io>

Stefan Roesch (2):
  io_uring: add napi busy polling support
  io_uring: add api to set napi busy poll timeout.

 include/linux/io_uring_types.h |   6 +
 include/uapi/linux/io_uring.h  |   4 +
 io_uring/io_uring.c            | 255 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  22 +++
 io_uring/poll.c                |   3 +
 io_uring/sqpoll.c              |   9 ++
 6 files changed, 299 insertions(+)
 create mode 100644 io_uring/napi.h


base-commit: 8f71a2b3f435f29b787537d1abedaa7d8ebe6647
--=20
2.30.2

