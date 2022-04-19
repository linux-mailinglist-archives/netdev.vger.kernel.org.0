Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26A0506B76
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiDSLxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiDSLxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:53:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B7A34B85
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F06B81807
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 11:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B075C385A7;
        Tue, 19 Apr 2022 11:50:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MwG1pqzO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650369048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hZpCfo5w+qpRGtcccpAOoB1uvttYpk90OyGKn2lEFE=;
        b=MwG1pqzO0HvuejPbSEZOqiZ2mlZuxIN5dBIJRt69jE93UWAMlFLREGgOaxz46kiPqtBPl8
        e/3Z8C2vzSAzv8LlUsVDhG38QYay1lGsZlsURFkYcEIyhRU99JrN+pIeSUmkljUjE+hMqT
        OMJjngnt0ol+FBWxC6qimsDb5HZEHv4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33d0cfac (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 19 Apr 2022 11:50:48 +0000 (UTC)
Date:   Tue, 19 Apr 2022 13:50:46 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com
Subject: Re: [PATCH v5 net-next 0/4] rtnetlink: improve ALT_IFNAME config and
 fix dangerous GROUP usage
Message-ID: <Yl6iFqPFrdvD1wam@zx2c4.com>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florent,

On Fri, Apr 15, 2022 at 06:53:26PM +0200, Florent Fourcot wrote:
> First commit forbids dangerous calls when both IFNAME and GROUP are
> given, since it can introduce unexpected behaviour when IFNAME does not
> match any interface.
> 
> Second patch achieves primary goal of this patchset to fix/improve
> IFLA_ALT_IFNAME attribute, since previous code was never working for
> newlink/setlink. ip-link command is probably getting interface index
> before, and was not using this feature.
> 
> Last two patches are improving error code on corner cases.

This was just merged to net-next and appears to have broken the
wireguard test suite over on https://build.wireguard.com/

[+] Launching tests...
[    0.796066] init.sh (28) used greatest stack depth: 29152 bytes left
[    0.803809] ip (29) used greatest stack depth: 28544 bytes left
[+] ip netns add wg-test-27-0
[+] ip netns add wg-test-27-1
[    0.842841] ip (32) used greatest stack depth: 27512 bytes left
[+] ip netns add wg-test-27-2
[+] NS0: ip link set up dev lo
[+] NS0: ip link add dev wg0 type wireguard
[    0.896074] ip (35) used greatest stack depth: 27152 bytes left
Command "add" is unknown, try "ip link help".
[+] NS0: ip link del dev wg0
[+] NS0: ip link del dev wg1
[+] NS1: ip link del dev wg0
[+] NS1: ip link del dev wg1
[+] NS2: ip link del dev wg0
[+] NS2: ip link del dev wg1
[+] ip netns del wg-test-27-1
[+] ip netns del wg-test-27-2
[+] ip netns del wg-test-27-0
[-] Tests failed with exit code 255! ☹

So apparently something goes wrong with "ip link add dev wg0 type
wireguard". Not quite sure what yet, though. You can try it for yourself
with:

    make -C tools/testing/selftests/wireguard/qemu -j$(nproc)

Jason
