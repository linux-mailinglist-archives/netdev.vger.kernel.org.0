Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37533192464
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCYJmk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 05:42:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48267 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgCYJmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:42:40 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jH2YY-00004r-HV
        for netdev@vger.kernel.org; Wed, 25 Mar 2020 09:42:38 +0000
Received: by mail-pj1-f69.google.com with SMTP id z5so1176697pjq.9
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 02:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WEm/Oq7JATNH4WpMbMOCRGSUs1m+s06ist0t7Zd6Gyc=;
        b=KKBylm/8p0OCxJbVqOLXtO7lsHx/UUsdJAcqmrpx0QgeWvXw03joJnPQr3sbusjDoT
         /5lRPNLT7dkHKOgf4dABV1EjQiUEPGJPfDpUMhycTLZWuecsYYtucVdXsZAOQ/vNAzmP
         B8BHPw8mhLFc2sXJJtz5F+LrvYG4keNPQ0iCjpGRvIUuTMoDwpzJiWE+5kf/8eYoDvHa
         jFH1j4mTQ3YSHWqjnjiZbqbh0BWxpFfBabVDL7v1U3Ltv3fDBFrf5S/1qCRCoUkGY9eM
         EBqeiE7sZXTHbmoeirF8BMgU/b+YkqajGuoChkvReQJl6YPs9M+OyeDcygn8ELUIGy+d
         gSoA==
X-Gm-Message-State: ANhLgQ3/GmrzBRqQXnxLOvCv5hKv+44rjuPe/U0nZ/ZwYp7SJAxwdyUJ
        Acd5UWv9pzi5ihx+OD0v0nMKDNvQ4OqsEtlTvKNwlncaBUObIYzwo1ZDAfwhyoC4FlLbDKkEq9l
        knTf7jfBDDbUgVMOdFEXFYsLPdsAwRbt3NA==
X-Received: by 2002:a65:4544:: with SMTP id x4mr2187635pgr.388.1585129356916;
        Wed, 25 Mar 2020 02:42:36 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvj90gfcJU2r68Oskg+mmyv4M+UId2JeQ2EkaQMMLSubnjDUsbz8zp/Sd05+Pt1LoN+2fiWQQ==
X-Received: by 2002:a65:4544:: with SMTP id x4mr2187604pgr.388.1585129356561;
        Wed, 25 Mar 2020 02:42:36 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id c1sm4168751pje.24.2020.03.25.02.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 02:42:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
 rtnl_lock()
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <309B89C4C689E141A5FF6A0C5FB2118B97224361@ORSMSX103.amr.corp.intel.com>
Date:   Wed, 25 Mar 2020 17:42:33 +0800
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4A655203-7609-434C-9225-269A39AD5B35@canonical.com>
References: <20200207101005.4454-1-kai.heng.feng@canonical.com>
 <309B89C4C689E141A5FF6A0C5FB2118B971F9210@ORSMSX103.amr.corp.intel.com>
 <3CA021B0-FEB8-4DAA-9CF2-224F305A8C8A@canonical.com>
 <309B89C4C689E141A5FF6A0C5FB2118B97224361@ORSMSX103.amr.corp.intel.com>
To:     "Brown, Aaron F" <aaron.f.brown@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aaron,

> On Mar 20, 2020, at 15:00, Brown, Aaron F <aaron.f.brown@intel.com> wrote:
> 
>> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Sent: Monday, February 24, 2020 3:02 AM
>> To: Brown, Aaron F <aaron.f.brown@intel.com>
>> Cc: davem@davemloft.net; mkubecek@suse.cz; Kirsher, Jeffrey T
>> <jeffrey.t.kirsher@intel.com>; open list:NETWORKING DRIVERS
>> <netdev@vger.kernel.org>; moderated list:INTEL ETHERNET DRIVERS <intel-
>> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
>> Subject: Re: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
>> rtnl_lock()
>> 
>> 
>> 
>>> On Feb 22, 2020, at 08:30, Brown, Aaron F <aaron.f.brown@intel.com> wrote:
>>> 
>>> 
>>> 
>>>> -----Original Message-----
>>>> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>>>> Kai-Heng Feng
>>>> Sent: Friday, February 7, 2020 2:10 AM
>>>> To: davem@davemloft.net; mkubecek@suse.cz; Kirsher, Jeffrey T
>>>> <jeffrey.t.kirsher@intel.com>
>>>> Cc: open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; Kai-Heng
>>>> Feng <kai.heng.feng@canonical.com>; moderated list:INTEL ETHERNET
>>>> DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
>>>> kernel@vger.kernel.org>
>>>> Subject: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
>>>> rtnl_lock()
>>>> 
>>>> Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>>> fixed race condition between close and power management ops by using
>>>> rtnl_lock().
>>>> 
>>>> However we can achieve the same by using device_lock() since all power
>>>> management ops are protected by device_lock().
>>>> 
>>>> This fix is a preparation for next patch, to prevent a dead lock under
>>>> rtnl_lock() when calling runtime resume routine.
>>>> 
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>> ---
>>>> v3:
>>>> - Fix unreleased lock reported by 0-day test bot.
>>>> v2:
>>>> - No change.
>>>> 
>>>> drivers/net/ethernet/intel/igb/igb_main.c | 14 ++++++++------
>>>> 1 file changed, 8 insertions(+), 6 deletions(-)
>>> 
>>> This patch introduces the following call trace / RIP when I sleep / resume (via
>> rtcwake) a system that has an igb port with link up:  I'm not sure if it introduces
>> the issue or just exposes / displays it as it only shows up on the first sleep /
>> resume cycle and the systems I have that were stable for many sleep / resume
>> cycles (arbitrarily 50+) continue to be so.
>> 
>> I can't reproduce the issue here.
>> 
> 
> I just got back to looking at the igb driver and  found a similar call trace / RIP with this patch.  Turns out any of my igb systems will freeze if the igb driver is unloaded while the interface is logically up with link.  The system continues to run if I switch to another console, but any attempt to look at the network (ifconfig, ethtool, etc...) makes that other session freeze up.  Then about 5 minutes later a trace appears on the screen and continues to do so every few minutes.  Here's what I pulled out of the system log for this instance:

Yes I can reproduce the bug by removing the module while link is up.
I am currently finding a fix for this issue.

Kai-Heng

