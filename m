Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734374E1E87
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 01:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343940AbiCUAv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 20:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiCUAv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 20:51:57 -0400
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Mar 2022 17:50:32 PDT
Received: from mail.grenz-bonn.de (mail.grenz-bonn.de [89.163.210.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D213F52
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 17:50:32 -0700 (PDT)
Received: from deepthought.bosswg.de (ip-095-222-226-040.um34.pools.vodafone-ip.de [95.222.226.40])
        by mail.grenz-bonn.de (Postfix) with ESMTPSA id 8F957F7146
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 01:42:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grenz-bonn.de;
        s=201905; t=1647823346; x=1647996146;
        bh=3Lo/rk57tAoduAPxFlMFSd9JuMBIzpEv2F2AW4Iac2k=; l=1145;
        h=From:To:Date:From;
        b=wviIcsXkTcdvlV2OqxkDFK3b3JtZmPFpz8YryPyDiBhDMO0TIWJ95bxqMAQbHiznd
         gs/B4Vd4TGgJrWr2mlM1C26UIdA2v7jHbhXa+zQDgGhWdAvXqAn1VNf6o5zrLKilcw
         NK9FV5oysAEOzDaItqJHK3oEHslBN9BypKndDWDd8yi73bT6Vc9CMG9FNjlJJ62I80
         3S7tSjz3QIM3g8N+OqSmijqAg3xrnU8y/Rz5Yf6V+5GvXyrQWM+RCOtYstqhzjnpD0
         J62YoRaq+Gxma6I/+f4epRAkqnD6UsYQaBDCdD/DGwTXELu0X28DIZAn96+CQrMewj
         8cKhgVa4nOYCg==
From:   Christoph Grenz <christophg+lkml@grenz-bonn.de>
To:     netdev@vger.kernel.org
Subject: netfilter masquerade source address selection doesn't account for PBR
Date:   Mon, 21 Mar 2022 01:42:25 +0100
Message-ID: <5790795.VsPgYW4pTa@deepthought.bosswg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I noticed that the masquerade target for IPv4 doesn't account for policy based 
routing when selecting the new source address.

E.g. if you have two public IP addresses 203.0.113.1 and 203.0.113.2 
configured and masquerade traffic coming from interfaces veth0 and veth1 and 
you want to select the outgoing public IP address based on the incoming 
interface, then neither of these commands influence the source address 
selection:

ip route add default via [...] src 203.0.113.2 table 101
ip rule add iif veth1 table 101 priority 101

ip route add default via [...] src 203.0.113.2 table 101
ip rule add from 192.168.1.0/24 table 101 priority 101

As far as I read the code, the source address is selected in 
nf_nat_masquerade.c using

newsrc = inet_select_addr(out, nh, RT_SCOPE_UNIVERSE);

and this seems to select an address as it would for a locally generated 
packet. Policies other than the preferred source address take effect as they 
are handled elsewhere.

The only workaround I found is explicitly using SNAT instead of MASQ.

Is this an oversight or expected behavior?

Best regards
Christoph Grenz



