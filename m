Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3F12A1E7
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfLXODp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:03:45 -0500
Received: from foss.arm.com ([217.140.110.172]:52286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfLXODo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:03:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 489DB1FB;
        Tue, 24 Dec 2019 06:03:44 -0800 (PST)
Received: from [10.0.2.15] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0488F3F534;
        Tue, 24 Dec 2019 06:03:42 -0800 (PST)
To:     linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        tee-dev@lists.linaro.org, netdev@vger.kernel.org
From:   Valentin Schneider <valentin.schneider@arm.com>
Subject: 5.5-rc1 regression with BNXT firmware driver
Cc:     vikas.gupta@broadcom.com, jakub.kicinski@netronome.com,
        sheetal.tigadoli@broadcom.com, davem@davemloft.net,
        Vincent Guittot <vincent.guittot@linaro.org>
Message-ID: <86d05f68-e644-8b05-3154-4658813e986e@arm.com>
Date:   Tue, 24 Dec 2019 14:03:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been hunting down some hackbench regression between 5.4-rc8 and 5.5-rc1
on my Juno r0, one of the offenders seems to be:

  246880958ac9 ("firmware: broadcom: add OP-TEE based BNXT f/w manager")

This is tested on a kernel built with defconfig (TEE_BNXT_FW gets selected)
and with:

  echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
  ./perf stat --null --sync --repeat 200 ./hackbench

The regression is easily reproducible on my end, this is 3 runs of the above
comparing the patch and its parent:

  -PATCH:
  0.71062 +- 0.00150 seconds time elapsed  ( +-  0.21% )                                                                                                                                                      
  0.71121 +- 0.00181 seconds time elapsed  ( +-  0.25% )                                                                                                                                                      
  0.71277 +- 0.00181 seconds time elapsed  ( +-  0.25% )  

  +PATCH:
  0.72556 +- 0.00174 seconds time elapsed  ( +-  0.24% )                                                                                                                                                      
  0.72695 +- 0.00192 seconds time elapsed  ( +-  0.26% )                                                                                                                                                      
  0.72559 +- 0.00178 seconds time elapsed  ( +-  0.25% ) 


AIUI Vincent found something different while hunting down a similar
regression:

  df323337e507 ("apparmor: Use a memory pool instead per-CPU caches")

but it seems this one is another cause. Seeing as this involves security
stuff the overhead may be acceptable, nevertheless now that I have some
reproducer I figured I'd send this out.

Cheers,
Valentin
