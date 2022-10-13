Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CDB5FE3A9
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 23:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJMVBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 17:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJMVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 17:01:32 -0400
X-Greylist: delayed 3104 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 14:01:30 PDT
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C8E1793A2;
        Thu, 13 Oct 2022 14:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ev9JakADx7qAtKKTcOpWroMdgabdypUWFXx+WaEhjLY=; b=jemgowjT34NhSYPsto4A7+PiOa
        hiCpmJgylUDr9Wwphni+var0FQS38aF0EBSmBBQpPk2EQItk+65Jl+UwOL2+56Ur4rv9Zc/qLzB/9
        Oe7vmIyirA9A0SVmdTTZhmB9iUfUA8u0tmhDTJ7VLHRslNC/717dGsOAHEAqPxA2XtXs=;
Received: from [88.117.56.108] (helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oj4WH-0003m5-LE; Thu, 13 Oct 2022 22:09:29 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] samples/bpf: Fix map interation in xdp1_user
Date:   Thu, 13 Oct 2022 22:09:22 +0200
Message-Id: <20221013200922.17167-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF map iteration in xdp1_user results in endless loop without any
output, because the return value of bpf_map_get_next_key() is checked
against the wrong value.

Other call locations of bpf_map_get_next_key() check for equal 0 for
continuing the iteration. xdp1_user checks against unequal -1. This is
wrong for a function which can return arbitrary negative errno values,
because a return value of e.g. -2 results in an endless loop.

With this fix xdp1_user is printing statistics again:
proto 0:          1 pkt/s
proto 0:          1 pkt/s
proto 17:     107383 pkt/s
proto 17:     881655 pkt/s
proto 17:     882083 pkt/s
proto 17:     881758 pkt/s

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 samples/bpf/xdp1_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index ac370e638fa3..281dc964de8d 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -51,7 +51,7 @@ static void poll_stats(int map_fd, int interval)
 
 		sleep(interval);
 
-		while (bpf_map_get_next_key(map_fd, &key, &key) != -1) {
+		while (bpf_map_get_next_key(map_fd, &key, &key) == 0) {
 			__u64 sum = 0;
 
 			assert(bpf_map_lookup_elem(map_fd, &key, values) == 0);
-- 
2.30.2

