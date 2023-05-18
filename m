Return-Path: <netdev+bounces-3768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EFF0708AA4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 23:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58BBA2819B7
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224C81F170;
	Thu, 18 May 2023 21:38:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13927134C8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 21:38:52 +0000 (UTC)
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CECF0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:38:51 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
	id CE04F5B1A658; Thu, 18 May 2023 14:17:53 -0700 (PDT)
From: Stefan Roesch <shr@devkernel.io>
To: io-uring@vger.kernel.org,
	kernel-team@fb.com
Cc: shr@devkernel.io,
	axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	olivier@trillion01.com
Subject: [PATCH v13 0/7] io_uring: add napi busy polling support 
Date: Thu, 18 May 2023 14:17:44 -0700
Message-Id: <20230518211751.3492982-1-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
	SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
- V13:
  - split off __napi_busy_loop() from napi_busy_loop()
  - introduce napi_busy_loop_no_lock()
  - use napi_busy_loop_no_lock in io_napi_blocking_busy_loop
- V12:
  - introduce io_napi_hash_find()
  - use rcu for changes to the hash table
  - use rcu for searching if a napi id is in the napi hash table
  - use rcu hlist functions for adding and removing items from the hash
    table
  - add stale entry detection in __io_napi_do_busy_loop and remove stale
    entries in io_napi_blocking_busy_loop() and io_napi_sqpoll_busy_loop(=
)
  - create io_napi_remove_stale() and __io_napi_remove_stale()
  - __io_napi_do_busy_loop() takes additional loop_end_arg and does stale
    entry detection
  - io_napi_multi_busy_loop is removed. Logic is moved to
    io_napi_blocking_busy_loop()
  - io_napi_free uses rcu function to free
  - io_napi_busy_loop no longer splices
  - io_napi_sqpoll_busy_poll uses rcu
- V11:
  - Fixed long comment lines and whitespace issues
  - Refactor new code io_cqring_wait()
  - Refactor io_napi_adjust_timeout() and remove adjust_timeout
  - Rename io_napi_adjust_timeout to __io_napi_adjust_timeout
  - Add new function io_napi_adjust_timeout
  - Cleanup calls to list_is_singular() in io_napi_multi_busy_loop()
    and io_napi_blocking_busy_loop()
  - Cleanup io_napi_busy_loop_should_end()
  - Rename __io_napi_busy_loop to __io_napi_do_busy_loop()=20
- V10:
  - Refreshed to io-uring/for-6.4
  - Repeated performance measurements for 6.4 (same/similar results)
- V9:
  - refreshed to io-uring/for-6.3
  - folded patch 2 and 3 into patch 4
  - fixed commit description for last 2 patches
  - fixed some whitespace issues
  - removed io_napi_busy_loop_on helper
  - removed io_napi_setup_busy helper
  - renamed io_napi_end_busy_loop to io_napi_busy_loop
  - removed NAPI_LIST_HEAD macro
  - split io_napi_blocking_busy_loop into two functions
  - added io_napi function
  - comment for sqpoll check
- V8:
  - added new file napi.c and add napi functions to this file
  - added NAPI_LIST_HEAD function so no ifdef is necessary
  - added io_napi_init and io_napi_free function
  - added io_napi_setup_busy loop helper function
  - added io_napi_adjust_busy_loop helper function
  - added io_napi_end_busy_loop helper function
  - added io_napi_sqpoll_busy_poll helper function
  - some of the definitions in napi.h are macros to avoid ifdef
    definitions in io_uring.c, poll.c and sqpoll.c
  - changed signature of io_napi_add function
  - changed size of hashtable to 16. The number of entries is limited
    by the number of nic queues.
  - Removed ternary in io_napi_blocking_busy_loop
  - Rewrote io_napi_blocking_busy_loop to make it more readable
  - Split off 3 more patches
- V7:
  - allow unregister with NULL value for arg parameter
  - return -EOPNOTSUPP if CONFIG_NET_RX_BUSY_POLL is not enabled
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



Stefan Roesch (7):
  net: split off __napi_busy_poll from napi_busy_poll
  net: introduce napi_busy_loop_rcu()
  io-uring: move io_wait_queue definition to header file
  io-uring: add napi busy poll support
  io-uring: add sqpoll support for napi busy poll
  io_uring: add register/unregister napi function
  io_uring: add prefer busy poll to register and unregister napi api

 include/linux/io_uring_types.h |  11 ++
 include/net/busy_poll.h        |   4 +
 include/uapi/linux/io_uring.h  |  12 ++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |  38 ++--
 io_uring/io_uring.h            |  26 +++
 io_uring/napi.c                | 336 +++++++++++++++++++++++++++++++++
 io_uring/napi.h                |  98 ++++++++++
 io_uring/poll.c                |   2 +
 io_uring/sqpoll.c              |   4 +
 net/core/dev.c                 | 137 +++++++++-----
 11 files changed, 605 insertions(+), 64 deletions(-)
 create mode 100644 io_uring/napi.c
 create mode 100644 io_uring/napi.h


base-commit: d2b7fa6174bc4260e496cbf84375c73636914641
--=20
2.39.1


