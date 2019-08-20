Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FDE95C36
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfHTKZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:25:46 -0400
Received: from first.geanix.com ([116.203.34.67]:38454 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfHTKZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 06:25:46 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id BC73E27D;
        Tue, 20 Aug 2019 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1566296738; bh=PRBYncQeB/7wv/3IPKIG7SGi1FMdOrcMuXs2yWJPv4o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EjNBWoFa7C2ioJ3zDKywM2NbCpZEYLXxB9kounRGbdrZADSWoRkvd7+k8TJUcwUrc
         +FxIPgvMzDF6XUCRJHTddPiwVgk8FK2HPXJHQc0Y5OxF9iJw1N5zKH8dbaD2P6ghZB
         YiXQ1UGNcPK//pe//qIaaFMlhhOEBdyFRfTLFQ+rx56k+LBBGdvxuycPHLMWoI2lu5
         5C7PQBxgKJgZ9VSl2v4/HNWGVz0CNd8X5dINCer9UXsdOWYJIfD+SYQyM0Jt++Q6Gv
         +uoIy8tNhKBc8ghrDKGGvMrQmxs6iuVwlAGhk8dRobpKAewwaIGxGlCFMFQO9zpDYs
         tQ9S0vpLhwXwg==
Subject: Re: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
Date:   Tue, 20 Aug 2019 12:25:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816081749.19300-2-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/08/2019 10.20, Joakim Zhang wrote:
> As reproted by Sean Nyekjaer below:
> When suspending, when there is still can traffic on the interfaces the
> flexcan immediately wakes the platform again. As it should :-). But it
> throws this error msg:
> [ 3169.378661] PM: noirq suspend of devices failed
> 
> On the way down to suspend the interface that throws the error message does
> call flexcan_suspend but fails to call flexcan_noirq_suspend. That means the
> flexcan_enter_stop_mode is called, but on the way out of suspend the driver
> only calls flexcan_resume and skips flexcan_noirq_resume, thus it doesn't call
> flexcan_exit_stop_mode. This leaves the flexcan in stop mode, and with the
> current driver it can't recover from this even with a soft reboot, it requires
> a hard reboot.
> 
> The best way to exit stop mode is in Wake Up interrupt context, and then
> suspend() and resume() functions can be symmetric. However, stop mode
> request and ack will be controlled by SCU(System Control Unit) firmware(manage
> clock,power,stop mode, etc. by Cortex-M4 core) in coming i.MX8(QM/QXP). And SCU
> firmware interface can't be available in interrupt context.
> 
> For compatibillity, the wake up mechanism can't be symmetric, so we need
> in_stop_mode hack.
> 
> Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
> Reported-by: Sean Nyekjaer <sean@geanix.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> 

Unfortunatly it's still possible to reproduce the deadlock with this 
patch...

[  689.921717] flexcan: probe of 2094000.flexcan failed with error -110

My test setup:
PC with CAN-USB dongle connected to can0 and can1.

PC:
$ while true; do cansend can0 '123#DEADBEEF'; done

iMX6ull:
root@iwg26:~# systemctl suspend 
 

[  365.858054] systemd[1]: Reached target Sleep.
root@iwg26:~# [  365.939826] systemd[1]: Starting Suspend...
[  366.115839] systemd-sleep[248]: Suspending system...
[  366.517949] dpm_run_callback(): platform_pm_suspend+0x0/0x5c returns -110
[  366.518249] PM: Device 2094000.flexcan failed to suspend: error -110
[  366.518406] PM: Some devices failed to suspend, or early wake event 
detected
[  366.732162] dpm_run_callback(): platform_pm_suspend+0x0/0x5c returns -110
[  366.732285] PM: Device 2090000.flexcan failed to suspend: error -110
[  366.732330] PM: Some devices failed to suspend, or early wake event 
detected
[  366.890637] systemd-sleep[248]: System resumed.
[  366.923062] systemd[1]: Started Suspend.
[  366.942819] systemd[1]: sleep.target: Unit not needed anymore. Stopping.
[  366.954791] systemd[1]: Stopped target Sleep.
[  366.962402] systemd[1]: Reached target Suspend.
[  366.977546] systemd-logind[135]: Operation 'sleep' finished.
[  366.979194] systemd[1]: suspend.target: Unit not needed anymore. 
Stopping.
[  366.993831] systemd[1]: Stopped target Suspend.
[  367.139972] systemd-networkd[220]: usb0: Lost carrier
[  367.294077] systemd-networkd[220]: usb0: Gained carrier

root@iwg26:~# candump can0 | head -n 2 

   can0  123   [4]  DE AD BE EF
   can0  123   [4]  DE AD BE EF
root@iwg26:~# candump can1 | head -n 2 

   can1  123   [4]  DE AD BE EF
   can1  123   [4]  DE AD BE EF
root@iwg26:~# systemctl suspend 

root@iwg26:~# [  385.106658] systemd[1]: Reached target Sleep.
[  385.147602] systemd[1]: Starting Suspend...
[  385.246421] systemd-sleep[260]: Suspending system...
[  385.634733] dpm_run_callback(): platform_pm_suspend+0x0/0x5c returns -110
[  385.634855] PM: Device 2090000.flexcan failed to suspend: error -110
[  385.634897] PM: Some devices failed to suspend, or early wake event 
detected
[  385.856251] PM: noirq suspend of devices failed
[  385.998364] systemd-sleep[260]: System resumed.
[  386.023390] systemd[1]: Started Suspend.
[  386.031570] systemd[1]: sleep.target: Unit not needed anymore. Stopping.
[  386.055886] systemd[1]: Stopped target Sleep.
[  386.061430] systemd[1]: Reached target Suspend.
[  386.066142] systemd[1]: suspend.target: Unit not needed anymore. 
Stopping.
[  386.112575] systemd-networkd[220]: usb0: Lost carrier
[  386.116797] systemd-logind[135]: Operation 'sleep' finished.
[  386.146161] systemd[1]: Stopped target Suspend.
[  386.260866] systemd-networkd[220]: usb0: Gained carrier
root@iwg26:~# candump can0 | head -n 2
   can0  123   [4]  DE AD BE EF
   can0  123   [4]  DE AD BE EF
root@iwg26:~# candump can1 | head -n 2 

   can1  123   [4]  DE AD BE EF
   can1  123   [4]  DE AD BE EF
root@iwg26:~# systemctl suspend 

[  396.919303] systemd[1]: Reached target Sleep.
root@iwg26:~# [  396.964722] systemd[1]: Starting Suspend...
[  397.067336] systemd-sleep[268]: Suspending system...
[  397.574571] PM: noirq suspend of devices failed
[  397.834731] PM: noirq suspend of devices failed
[  397.807996] systemd-networkd[220]: usb0: Lost carrier
[  398.156295] dpm_run_callback(): platform_pm_suspend+0x0/0x5c returns -110
[  398.156339] PM: Device 2094000.flexcan failed to suspend: error -110
[  398.156509] PM: Some devices failed to suspend, or early wake event 
detected
[  398.053555] systemd-sleep[268]: Failed to write /sys/power/state: 
Device or resource busy
[  398.074751] systemd[1]: systemd-suspend.service: Main process exited, 
code=exited, status=1/FAILURE
[  398.076779] systemd[1]: systemd-suspend.service: Failed with result 
'exit-code'.
[  398.109255] systemd[1]: Failed to start Suspend.
[  398.118704] systemd[1]: Dependency failed for Suspend.
[  398.136283] systemd-logind[135]: Operation 'sleep' finished.
[  398.137770] systemd[1]: suspend.target: Job suspend.target/start 
failed with result 'dependency'.
[  398.139105] systemd[1]: sleep.target: Unit not needed anymore. Stopping.
[  398.167590] systemd[1]: Stopped target Sleep.
[  398.201558] systemd-networkd[220]: usb0: Gained carrier

root@iwg26:~# candump can0 | head -n 2
   can0  123   [4]  DE AD BE EF
   can0  123   [4]  DE AD BE EF
root@iwg26:~# candump can1 | head -n 2

nothing on can1 anymore :-(

root@iwg26:~# rmmod flexcan
[  622.884746] systemd-networkd[220]: can1: Lost carrier
[  623.046766] systemd-networkd[220]: can0: Lost carrier
root@iwg26:~# insmod /mnt/flexcan.ko
[  628.323981] flexcan 2094000.flexcan: registering netdev failed

and can1 fails to register with:
[  628.347485] flexcan: probe of 2094000.flexcan failed with error -110

/Sean
