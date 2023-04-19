Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8BE6E7E13
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjDSPTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjDSPTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:19:38 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5A4486;
        Wed, 19 Apr 2023 08:19:12 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id ei23so4702681qtb.2;
        Wed, 19 Apr 2023 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681917395; x=1684509395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CdauQ/Rmbgxp2/jRo5uY0DdrwR55PkweyR5uZ5V4258=;
        b=b67I4CdIp80I7qCE+cTV8+p6ScNgipDpMuQYR1CMfyM4y8MtilG3n5X4KzTeQv7h4X
         IdHHoHLiMtZ5KrzKMqcPly1RDXxh1ESr3+35eTqB9SyMFNZER9c8h8CMDtrrXVRbztom
         13ch0xM5waGe/UEM7P366vXHDvTR3X9Y9+r94AtTI9Nrv7PmrSaAKclq8KsW9Xk24Jdt
         Z4RN1/stiEEp6RpKtetWr+OSxeKizBfZotOQcCo0z4BJ+oogx5lek2PUY1MuTvWSfGwk
         PTkWcLbHCzIVzj0gfDAMpA9eDkzpAeHcRaNyGsGHZvbxk3E/DH1F26MStgg6rl9tHn98
         GLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917395; x=1684509395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CdauQ/Rmbgxp2/jRo5uY0DdrwR55PkweyR5uZ5V4258=;
        b=D1b9CEC8W+hOLJ2dukhiWdabIcWEwekWm4n5Fh7RcP892RkLiax0bdpy2kIkJ4IGqD
         YIA/5gq7wv/MTXCoMu8Q14xxJ1XdyjkyIAQHBT53XpFtwtwD9DTKUVrEqu3Q5lnQCEUa
         Hp1qcsjB9frHyzz/GQ9V3YQ+eWC16gJuZCBrRrYiBi7Y084h/kbqp2Ihrh0MietzCtij
         eJz7puYBSqddGMVG1qEsI7duK7xS3hyq9QYBABG6RzpfybrvzGzTcTfWcYbL8AtEylYd
         rExxxbAAvlLj/H/mYfZ1IXxX7BxGTzOLfTRFWIO2tmlARhHng4KxuW/BlFYcY9eclokK
         E/KQ==
X-Gm-Message-State: AAQBX9dZjByvYjqMBPR2B9mYEMlJRn9amfXXQokQdChsIxNt3NZ2Sdht
        5G1VyvzaYxFoc+RVd/1gIfEMN/nuopaBbw==
X-Google-Smtp-Source: AKy350bTCANRwIYs1kwfRndbZWC2E2axE7gT8yVekM7Z7U4SRwYyDP1Rnejfy/R+UVhymMV41SqEpw==
X-Received: by 2002:a05:622a:1010:b0:3e6:55b2:35e with SMTP id d16-20020a05622a101000b003e655b2035emr8252496qte.26.1681917394959;
        Wed, 19 Apr 2023 08:16:34 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v11-20020a05620a0f0b00b007469b5bc2c4sm4753336qkl.13.2023.04.19.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:16:34 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 0/6] sctp: fix a plenty of flexible-array-nested warnings
Date:   Wed, 19 Apr 2023 11:16:27 -0400
Message-Id: <cover.1681917361.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo noticed a compile warning in SCTP,

../net/sctp/stream_sched_fc.c: note: in included file (through ../include/net/sctp/sctp.h):
../include/net/sctp/structs.h:335:41: warning: array of flexible structures

But not only this, there are actually quite a lot of such warnings in
some SCTP structs. This patchset fixes most of warnings by deleting
these nested flexible array members.

After this patchset, there are still some warnings left:

  # make C=2 CF="-Wflexible-array-nested" M=./net/sctp/
  ./include/net/sctp/structs.h:1145:41: warning: nested flexible array
  ./include/uapi/linux/sctp.h:641:34: warning: nested flexible array
  ./include/uapi/linux/sctp.h:643:34: warning: nested flexible array
  ./include/uapi/linux/sctp.h:644:33: warning: nested flexible array
  ./include/uapi/linux/sctp.h:650:40: warning: nested flexible array
  ./include/uapi/linux/sctp.h:653:39: warning: nested flexible array

the 1st is caused by __data[] in struct ip_options, not in SCTP;
the others are in uapi, and we should not touch them.

Note that instead of completely deleting it, we just leave it as a
comment in the struct, signalling to the reader that we do expect
such variable parameters over there, as Marcelo suggested.

Xin Long (6):
  sctp: delete the nested flexible array params
  sctp: delete the nested flexible array skip
  sctp: delete the nested flexible array variable
  sctp: delete the nested flexible array peer_init
  sctp: delete the nested flexible array hmac
  sctp: delete the nested flexible array payload

 include/linux/sctp.h         | 18 +++++++++---------
 include/net/sctp/sctp.h      | 12 ++++++------
 include/net/sctp/structs.h   |  2 +-
 net/sctp/associola.c         |  5 +++--
 net/sctp/auth.c              |  2 +-
 net/sctp/input.c             |  2 +-
 net/sctp/outqueue.c          | 11 +++++++----
 net/sctp/sm_make_chunk.c     | 22 +++++++++++-----------
 net/sctp/sm_sideeffect.c     |  3 +--
 net/sctp/sm_statefuns.c      | 14 ++++++--------
 net/sctp/stream.c            |  2 +-
 net/sctp/stream_interleave.c |  4 ++--
 12 files changed, 49 insertions(+), 48 deletions(-)

-- 
2.39.1

