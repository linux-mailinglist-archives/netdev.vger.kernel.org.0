Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9BD4C7855
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbiB1Svy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiB1Svx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:51:53 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8AB54CD5F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:51:14 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-014-115-047.89.14.pool.telefonica.de [89.14.115.47])
        by linux.microsoft.com (Postfix) with ESMTPSA id D40C320B7178;
        Mon, 28 Feb 2022 10:51:13 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D40C320B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646074274;
        bh=1aPXMRV2znKTCmolVOZlfGNm0/0z+jOHxnJNKnRd3IY=;
        h=From:Subject:To:Cc:Date:From;
        b=ab/VcFsB1THfG+EyXd22YwAP5g3jX+JiolEa5MMNsM8zfI77wvWBIZwKwTPkb/XiV
         hZPZV1iKzS4rRq+WahAH7CA1iU94TgQ5q1k7LqTnr9JldU6YngbUc1Vq8Bj7s6Rs5m
         Rqu5amPyMP6SMHUOMpdl0X8EKIcR+EDXkgYo/Eqw=
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Subject: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return error"
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
Cc:     Kai Lueke <kailuke@microsoft.com>
Message-ID: <447cf566-8b6e-80d2-b20d-c20ccd89bdb9@linux.microsoft.com>
Date:   Mon, 28 Feb 2022 19:51:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 8dce43919566f06e865f7e8949f5c10d8c2493f5 because it
breaks userspace (e.g., Cilium is affected because it used id 0 for the
dummy state https://github.com/cilium/cilium/pull/18789).

Signed-off-by: Kai Lueke <kailuke@microsoft.com>
---
 net/xfrm/xfrm_interface.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 57448fc519fc..41de46b5ffa9 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -637,16 +637,11 @@ static int xfrmi_newlink(struct net *src_net,
struct net_device *dev,
             struct netlink_ext_ack *extack)
 {
     struct net *net = dev_net(dev);
-    struct xfrm_if_parms p = {};
+    struct xfrm_if_parms p;
     struct xfrm_if *xi;
     int err;
 
     xfrmi_netlink_parms(data, &p);
-    if (!p.if_id) {
-        NL_SET_ERR_MSG(extack, "if_id must be non zero");
-        return -EINVAL;
-    }
-
     xi = xfrmi_locate(net, &p);
     if (xi)
         return -EEXIST;
@@ -671,12 +666,7 @@ static int xfrmi_changelink(struct net_device *dev,
struct nlattr *tb[],
 {
     struct xfrm_if *xi = netdev_priv(dev);
     struct net *net = xi->net;
-    struct xfrm_if_parms p = {};
-
-    if (!p.if_id) {
-        NL_SET_ERR_MSG(extack, "if_id must be non zero");
-        return -EINVAL;
-    }
+    struct xfrm_if_parms p;
 
     xfrmi_netlink_parms(data, &p);
     xi = xfrmi_locate(net, &p);
-- 
2.35.1

