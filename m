Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C4166BD81
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjAPMHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAPMHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:07:51 -0500
X-Greylist: delayed 2406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 04:07:49 PST
Received: from mail.qult.net (unknown [78.193.33.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2466B1CF5C
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 04:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=green-communications.fr; s=x; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ua+b1whHcAfFdXdpnTdJUOdplVMi5daW6nUcFn/QYPU=; b=vs/IR1rQypjzoBGusRy/UkClLG
        NBnvKnOagzZOVy6sC8oteo8lQBI9+K+yySj6Sr/XfLaKHGBOZzQ9vON00px91W1mwBZZHU2kGtR/n
        j5LVQPobL90eLBEdt+0UVYYKW2cU+rCPZ3q5IlJgFcP0M/qWnVQY9QVLQUupdoPHgw1s=;
Received: from zenon.in.qult.net ([192.168.64.1])
        by mail.qult.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <ignacy.gawedzki@green-communications.fr>)
        id 1pHNeQ-0006Y3-S1
        for netdev@vger.kernel.org; Mon, 16 Jan 2023 12:27:42 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.96)
        (envelope-from <ignacy.gawedzki@green-communications.fr>)
        id 1pHNeN-0068Rc-2E
        for netdev@vger.kernel.org;
        Mon, 16 Jan 2023 12:27:39 +0100
Date:   Mon, 16 Jan 2023 12:27:39 +0100
From:   Ignacy =?utf-8?B?R2F3xJlkemtp?= 
        <ignacy.gawedzki@green-communications.fr>
To:     netdev@vger.kernel.org
Subject: Much higher CPU usage when generating UDP vs. TCP traffic
Message-ID: <20230116112739.ritnefwxhc5nyfqi@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,KHOP_HELO_FCRDNS,MAY_BE_FORGED,PDS_RDNS_DYNAMIC_FP,
        RCVD_IN_PBL,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4876]
        *  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
        *      [78.193.33.39 listed in zen.spamhaus.org]
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  1.0 RDNS_DYNAMIC Delivered to internal network by host with
        *      dynamic-looking rDNS
        *  0.0 PDS_RDNS_DYNAMIC_FP RDNS_DYNAMIC with FP steps
        *  0.0 MAY_BE_FORGED Relay IP's reverse DNS does not resolve to IP
        *  0.0 KHOP_HELO_FCRDNS Relay HELO differs from its IP's reverse DNS
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

While running some network performance tests, I discovered that the
CPU usage when generating UDP traffic is much higher than when
generating TCP traffic.  Note that no significant difference of CPU
usage was observed when simply forwarding UDP vs. TCP traffic.

This happens on Ethernet, on Wi-Fi, even on veth links (but not on the
loopback interface), so it seems unrelated to any specific hardware
driver.  BTW this difference in CPU usage decreases quite notably when
generating UDP paquets of maximum size, resulting in 64 KiB IP paquest
getting immediately fragmented to fit a standard MTU of 1500 bytes.

On platforms with more modest CPU resources, such as SoCs, this
results in much lower maximum achievable throughput in UDP vs. TCP.
Even more so with some Wi-Fi 6 drivers that seem to eat a significant
portion of CPU on their own.

I observed this happening on older kernels as well as the head of
wireless.git.  Disabling any hardware offloading doesn't change much
if anything at all.

This was really unexpected to me, since I always assumed the
processing of UDP is much simpler than that of TCP.  So I eventually
resolved to write to this list, hoping that some knowledgeable person
could shed some light on the matter.

Many thanks in advance,

Ignacy

-- 
Ignacy Gawêdzki
R&D Engineer
Green Communications
