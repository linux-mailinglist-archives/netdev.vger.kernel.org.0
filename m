Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A864430D947
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhBCL4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbhBCL4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:56:12 -0500
Received: from iam.tj (soggy.cloud [IPv6:2a01:7e00:e000:151::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D862C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 03:55:27 -0800 (PST)
Received: from [IPv6:2a02:8010:4007::e86f:38d4:3289] (unknown [IPv6:2a02:8010:4007::e86f:38d4:3289])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id AFFA9340F6;
        Wed,  3 Feb 2021 11:55:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1612353325; bh=JSYIYSDCwVoclSAy1a9pV822R2G63x1Ml+TkX/LYWWY=;
        h=To:From:Subject:Cc:Date:From;
        b=cBho0foQLzA6dP3dLEUCsxZSoczMH0b6wEkiO4CvODX5wbapVKi22h/PVtavgOXtQ
         8JQD56dlxswnOBf98alj1H1ikI7SDw4jC7L1A+DAB/08KByObI9HSJw4muQcHcM1Tw
         npj2SvSlNVheI1cyAlYKPJHozXnAgiS4yZ8oRVRiV71Tz+w7Ord5sgpMdX7zSnoBoj
         bJ67ziYfW63bVHm7VMRB8rOjP/OgEqMysgHStXZUySVbxG7yiJgRgs+Pl0AE9GUSsV
         U6HNc96dPeyamSHe/aZVHZ0cH1YaqUqZLbxTDIZvmmCvVPvFEizKjD3SbMpSoUF75k
         ZzNMtsec/IxRA==
To:     netdev <netdev@vger.kernel.org>
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Subject: kernel BUG at net/core/skbuff.c:109!
Organization: Elloe CIC
Cc:     Callum O'Connor <callum.oconnor@elloe.vision>
Message-ID: <d7f38867-71d3-e91c-c71c-1dd37a4c3086@elloe.vision>
Date:   Wed, 3 Feb 2021 11:55:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a recent build (5.10.0) we've seen several hard-to-pinpoint complete
lock-ups requiring power-off restarts.

Today we found a small clue in the kernel log but unfortunately the
complete backtrace wasn't captured (presumably system froze before log
could be flushed) but I thought I should share it for investigation.

kernel BUG at net/core/skbuff.c:109!

kernel: skbuff: skb_under_panic: text:ffffffffc103c622 len:1228 put:48
head:ffffa00202858000 data:ffffa00202857ff2 tail:0x4be end:0x6c0 dev:wlp4s0
kernel: ------------[ cut here ]------------
kernel: kernel BUG at net/core/skbuff.c:109!

Obviously this ought not to happen and we'd like to discover the cause.

Whilst writing this report it happened again. Checking the logs we see
three instances of the BUG none of which capture a stack trace:

Jan 27
Feb 03 #1
Feb 03 #2

The only slight clue may be a k3s service that we were unaware was
constantly restarting and had reached 26,636 iterations just before the
Feb 03 #1 BUG. However, we removed k3s immediately after and there were
no similar clues 20 minutes later for the Feb 03 #2 BUG.

Feb 03 11:11:13 elloe001 k3s[1209978]:
time="2021-02-03T11:11:13.452745479Z" level=fatal msg="starting
kubernetes: preparing server: start cluster and https:
listen tcp 10.1.2.1:6443: bind: cannot assign requested address"
Feb 03 11:11:13 elloe001 systemd[1]: k3s-main.service: Main process
exited, code=exited, status=1/FAILURE
Feb 03 11:11:13 elloe001 systemd[1]: k3s-main.service: Failed with
result 'exit-code'.
Feb 03 11:11:13 elloe001 systemd[1]: Failed to start Lightweight Kubernetes.
Feb 03 11:11:18 elloe001 systemd[1]: k3s-dev.service: Scheduled restart
job, restart counter is at 26636.
Feb 03 11:11:18 elloe001 systemd[1]: k3s-main.service: Scheduled restart
job, restart counter is at 26636.
Feb 03 11:11:18 elloe001 systemd[1]: Stopped Lightweight Kubernetes.
Feb 03 11:11:18 elloe001 systemd[1]: Starting Lightweight Kubernetes...
Feb 03 11:11:18 elloe001 systemd[1]: Stopped Lightweight Kubernetes.
Feb 03 11:11:18 elloe001 systemd[1]: Starting Lightweight Kubernetes...

We don't think this is hardware related as we have several identical
Lenovo E495 laptops and they have never suffered this.

We don't know of any way to reproduce it at will.
