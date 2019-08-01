Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E287D256
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbfHAApO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:45:14 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:46570 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfHAApO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:45:14 -0400
Received: by mail-pf1-f178.google.com with SMTP id c3so9667431pfa.13
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/N06suFqQG/VUR1RT9/8JxihrYyE4RhXxxatZIyfBts=;
        b=ULdMFEwUsbE46yE3nf1nJntUAjiy6CYuOeCvLp7GvEm0IIYo2Vc4dK8JKyWeuAIRDq
         HvpjyCQ8WR4DkXktnYTzTmMW5V9ovloJVLSqCAf7UG//Gfwibd2T4g3GNeiiKvd9X1Kt
         ZiWwXDmr+Z5CvJOmBKthS2QkAhVZgOa5nzOrTMa+vqzRbgtbUZYKuuPw8M0EO2P18PTp
         Flm2A/9qCX+VnRra7lccSkV0HppSR76PhSuMTvvCAJN24cHhQC6BQDqFdMW69Jiz0B4K
         n/K1pWtXzgyCfbwoZZLWNWy9C7gAInqH33jvF6emrYTfBdfNJftq7UgRUAE3iQ7V5YGx
         /J/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/N06suFqQG/VUR1RT9/8JxihrYyE4RhXxxatZIyfBts=;
        b=XN4dkr1JaFGCXjP8q2hAqbmHB0b04ICA8B5GlhMMCvtd7rHjU82KjvPk47KoEmkAS3
         ulf2BIKSXkEkVYWSBeqsXnZ6KgvgdEg62ccQnFrwl8iofrcwsnnaB6LPUDIwi+3XW9xr
         QMI9WAdcFxIHEbCDYGUp5lePC1ZyJ2ZdQaX0XN0KGLAhB2NqY+xE9jSwrLkOsVpgRWNo
         KzlWUpfmHcmNqQGajjWqUB6fh9pm7uqoyGMeTK4ZF03aOZhSqF9Jr/mQLbcxXVXPfdkx
         1ZAkxtgCw7S5qJxDeI0dSaGqg7j9zpHt4NXr8Y5C2u4qbxOYDLALdsSHUlDu5M90MHvD
         vy/g==
X-Gm-Message-State: APjAAAUI1vBKFJUZKZrjm6cEUwnWqPKY9TOV4okpZvbkOo0LTO5ADV81
        wAiadnxtavF0IwN7lgS2861RLSwY
X-Google-Smtp-Source: APXvYqytJ+Y1Fjt46vhnIx43VvSIRlhYB3GAAd4I4sqyT9lZLVkSDasacvsIKotE0P4k4KHDam775Q==
X-Received: by 2002:a17:90a:2041:: with SMTP id n59mr5389306pjc.6.1564620313264;
        Wed, 31 Jul 2019 17:45:13 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f32sm2435978pgb.21.2019.07.31.17.45.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 17:45:12 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiri@resnulli.us, chrism@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 0/4] Revert tc batchsize feature
Date:   Wed, 31 Jul 2019 17:45:02 -0700
Message-Id: <20190801004506.9049-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The batchsize feature of tc might save a few cycles but it
is a maintaince nightmare, it has uninitialized variables and
poor error handling. 

This patch set reverts back to the original state.
Please don't resubmit original code. Go back to the drawing
board and do something generic.  For example, the routing
daemons have figured out that by using multiple threads and
turning off the netlink ACK they can update millions of routes
quickly.

Stephen Hemminger (4):
  Revert "tc: Remove pointless assignments in batch()"
  Revert "tc: flush after each command in batch mode"
  Revert "tc: fix batch force option"
  Revert "tc: Add batchsize feature for filter and actions"

 tc/m_action.c  |  65 ++++++----------
 tc/tc.c        | 201 ++++---------------------------------------------
 tc/tc_common.h |   7 +-
 tc/tc_filter.c | 129 ++++++++++++-------------------
 4 files changed, 87 insertions(+), 315 deletions(-)

