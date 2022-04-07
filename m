Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE134F7EFB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240775AbiDGMbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbiDGMbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:31:00 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F78D9EBA
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:29:00 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH v3 net-next 0/4] rtnetlink: improve ALT_IFNAME config and fix dangerous GROUP usage
Date:   Thu,  7 Apr 2022 14:25:55 +0200
Message-Id: <20220407122559.27515-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The primary goal of this patchset is to fix/improve IFLA_ALT_IFNAME
attribute, since previous code was never working for newlink/setlink.
ip-link command is probably getting interface index before, and was not
using this feature.

Third commit forbids dangerous calls when both IFNAME and GROUP are
given, since it can introduce unexpected behaviour when IFNAME does not
match any interface.

Changes in v2:
  * Remove ifname argument in rtnl_dev_get/do_setlink
    functions (simplify code)
  * Use a boolean to avoid condition duplication in __rtnl_newlink

Changes in v3:
  * Simplify rtnl_dev_get signature

Changes in v4:
  * Rename link_lookup to link_specified


Florent Fourcot (4):
  rtnetlink: enable alt_ifname for setlink/newlink
  rtnetlink: return ENODEV when IFLA_ALT_IFNAME is used in dellink
  rtnetlink: return ENODEV when ifname does not exist and group is given
  rtnetlink: return EINVAL when request cannot succeed

 net/core/rtnetlink.c | 91 ++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

-- 
2.30.2

