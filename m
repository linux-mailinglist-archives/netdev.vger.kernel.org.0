Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205FF2CCAD
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfE1Qxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:53:37 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3078 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfE1Qxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 12:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:To:From:
        Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W3bTiEXJe02XZR8c0KAc2dB3IT0sCWBL02aXsHcqIaE=; b=dl3QIQtlxoUyldCY1x//3gwIHN
        IYLDJF6hAW2CNiTKyEVCjaF/8ucNS3agGWOkJmgBmlDGu9fHtmk8+oWFQ0q2xpP1k8+32KNRl4cHI
        txr9jBvOTMzT6y7p6xIfuAFmhTdUAZaZH9VCzl6uLsVimauDvdgcJltYjXopwR1m2RDU=;
Received: from [fd06:8443:81a1:74b0::212] (port=4962 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hVfM0-00034K-K3; Tue, 28 May 2019 18:53:36 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hVfLM-0003gA-GM; Tue, 28 May 2019 18:52:56 +0200
Message-ID: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
Subject: [RFC][PATCH kernel_bpf] honor CAP_NET_ADMIN for BPF_PROG_LOAD
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 28 May 2019 18:53:10 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[sorry for crossposting but this affects both lists]

BPF_PROG_TYPE_SCHED_CLS and BPF_PROG_TYPE_XDP should be allowed
for CAP_NET_ADMIN capability. Nearly everything one can do with
these program types can be done some other way with CAP_NET_ADMIN
capability (e.g. NFQUEUE), but only slower.

This change is similar in behaviour to the /proc/sys/net
CAP_NET_ADMIN exemption.

Overall chances are of increased security as network related
applications do no longer require to keep CAP_SYS_ADMIN
admin capability for network related eBPF operations.

It may well be that other program types than BPF_PROG_TYPE_XDP
and BPF_PROG_TYPE_SCHED_CLS do need the same exemption, though
I do not have sufficient knowledge of other program types
to be able to decide this.

Preloading BPF programs is not possible in case of application
modified or generated BPF programs, so this is no alternative.
The verifier does prevent the BPF program from doing harmful
things anyway.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/kernel/bpf/syscall.c	2019-05-28 18:00:40.472841432 +0200
+++ b/kernel/bpf/syscall.c	2019-05-28 18:17:50.162811510 +0200
@@ -1561,8 +1561,13 @@ static int bpf_prog_load(union bpf_attr
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	    !capable(CAP_SYS_ADMIN)) {
+		if (type != BPF_PROG_TYPE_SCHED_CLS &&
+		    type != BPF_PROG_TYPE_XDP)
+			return -EPERM;
+		if(!capable(CAP_NET_ADMIN))
+			return -EPERM;
+	}
 
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach_type(type, attr->expected_attach_type))

