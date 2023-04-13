Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C216E0CFF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDMLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjDMLr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:47:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93441A5E9;
        Thu, 13 Apr 2023 04:47:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D7AAD75;
        Thu, 13 Apr 2023 04:48:02 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFED43F73F;
        Thu, 13 Apr 2023 04:47:16 -0700 (PDT)
From:   Kevin Brodsky <kevin.brodsky@arm.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/3] net: Finish up ->msg_control{,_user} split
Date:   Thu, 13 Apr 2023 12:47:02 +0100
Message-Id: <20230413114705.157046-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Commit 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for
->msg_control") introduced the msg_control_user and
msg_control_is_user fields in struct msghdr, to ensure that user
pointers are represented as such. It also took care of converting most
users of struct msghdr::msg_control where user pointers are involved. It
did however miss a number of cases, and some code using msg_control
inappropriately has also appeared in the meantime.

This series is attempting to complete the split, by eliminating the
remaining cases where msg_control is used when in fact a user
pointer is stored in the union (patch 1).

It also addresses a couple of issues with msg_control_is_user: one where
it is not updated as it should (patch 2), and one where it is not
initialised (patch 3).

v1..v2:
* Split out the msg_control_is_user fixes into separate patches.

v1: https://lore.kernel.org/all/20230411122625.3902339-1-kevin.brodsky@arm.com/

Thanks,
Kevin

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

Kevin Brodsky (3):
  net: Ensure ->msg_control_user is used for user buffers
  net/compat: Update msg_control_is_user when setting a kernel pointer
  net/ipv6: Initialise msg_control_is_user

 net/compat.c             | 13 +++++++------
 net/core/scm.c           |  9 ++++++---
 net/ipv4/tcp.c           |  4 ++--
 net/ipv6/ipv6_sockglue.c |  1 +
 4 files changed, 16 insertions(+), 11 deletions(-)

-- 
2.38.1

