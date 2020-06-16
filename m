Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21BA1FA651
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 04:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFPCNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 22:13:24 -0400
Received: from mail-m971.mail.163.com ([123.126.97.1]:36370 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgFPCNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 22:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=s4XBV
        yv9DADyKucbpsy8uo0V7CPIYGBYSyMQ4h1ImtI=; b=Z5b+s9+K+TNo75YbRnwN/
        19Lq+RWejaVHbnUHrm3uUpLV4tvv2O5s9dy7uQhFmEUGij3BTS5ZWfDgnYNGYX7c
        gde/ZWcM2bXwmc0XQb+GESuL81Ypl8NaL/RHJDhUTS0c8Qu8z3/8ekFY1jzs/+Gd
        B/RBybhqWoxap3V/LiXR9U=
Received: from ubuntu.localdomain (unknown [42.238.20.186])
        by smtp1 (Coremail) with SMTP id GdxpCgAHbSuvKuheUlW4DA--.473S3;
        Tue, 16 Jun 2020 10:13:06 +0800 (CST)
From:   Xidong Wang <wangxidong_97@163.com>
To:     Xidong Wang <wangxidong_97@163.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] openvswitch: fix infoleak in conntrack
Date:   Mon, 15 Jun 2020 19:13:01 -0700
Message-Id: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAHbSuvKuheUlW4DA--.473S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyxtr45Zr1DJw48Zr45GFg_yoWfJFX_KF
        Z5Jw1kur15AFs5Kw4jqF4xAr1kJ34xZFZ3Xr17Zay7Gw10qwn3WF18Wa97uFy8uF1YvFW7
        Z3sIvwsrCa4akjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUULiStUUUUU==
X-Originating-IP: [42.238.20.186]
X-CM-SenderInfo: pzdqw5xlgr0wrbzxqiywtou0bp/1tbizQJF81c7KrzyxQAAs0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xidongwang <wangxidong_97@163.com>

The stack object “zone_limit” has 3 members. In function
ovs_ct_limit_get_default_limit(), the member "count" is
not initialized and sent out via “nla_put_nohdr”.

Signed-off-by: xidongwang <wangxidong_97@163.com>
---
 net/openvswitch/conntrack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4340f25..1b7820a 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2020,6 +2020,7 @@ static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 {
 	struct ovs_zone_limit zone_limit;
 	int err;
+	memset(&zone_limit, 0, sizeof(zone_limit));
 
 	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
 	zone_limit.limit = info->default_limit;
-- 
2.7.4

