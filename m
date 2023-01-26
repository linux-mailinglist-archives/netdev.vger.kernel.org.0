Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEC67C228
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 02:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbjAZBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 20:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbjAZBC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 20:02:26 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC365CFF6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:02:23 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id F010A50453C;
        Thu, 26 Jan 2023 03:56:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru F010A50453C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674694619; bh=6b9j39uEVOxkTQZhu0hEE8TAeetpFBH6OF5858c8Kfg=;
        h=From:To:Cc:Subject:Date:From;
        b=KWXZ/7rRdcDhHK6WoCLzb1R5mP0i+8R3qnqFG/tpjr8gfuORDPCsFTDERM3qJym/V
         2JlBxXYaWDp6x780BdUYGOqNfHfVmJJNUurwiaGJwg1weQMe543w71Ym0EUibDc/jZ
         8f/rofJ1MRTGA42KTmpPYNmfZ/5gyGiIw0+RxOBE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@meta.com>, netdev@vger.kernel.org
Subject: [PATCH net v3 0/2] mlx5: ptp fifo bugfixes
Date:   Thu, 26 Jan 2023 04:02:04 +0300
Message-Id: <20230126010206.13483-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@meta.com>

Simple FIFO implementation for PTP queue has several bugs which lead to
use-after-free and skb leaks. This series fixes the issues and adds new
checks for this FIFO implementation to uncover the same problems in
future.

v2 -> v3:
  Rearrange patches order and rephrase commit messages
  Remove counters as Gal confirmed FW bug, use KERN_ERR message instead
  Provide proper budget to napi_consume_skb as Jakub suggested
v1 -> v2:
  Update Fixes tag to proper commit.
  Change debug line to avoid double print of function name


Vadim Fedorenko (2):
  mlx5: fix skb leak while fifo resync and push
  mlx5: fix possible ptp queue fifo use-after-free

 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  9 +++++--
 2 files changed, 26 insertions(+), 8 deletions(-)

-- 
2.27.0

