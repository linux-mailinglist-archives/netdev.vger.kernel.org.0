Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE83235B5
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhBXCbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:31:19 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:49950 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhBXCbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 21:31:16 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11O2T8Ol007907; Wed, 24 Feb 2021 11:29:08 +0900
X-Iguazu-Qid: 2wGr679RacnKPlRcjF
X-Iguazu-QSIG: v=2; s=0; t=1614133747; q=2wGr679RacnKPlRcjF; m=lewnf22wFduvpaYWiRWJ6OTJHJavVD/UVkShodXURF0=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1113) id 11O2T6VZ037785
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Feb 2021 11:29:06 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 19D8F1000AC;
        Wed, 24 Feb 2021 11:29:06 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11O2T5i2020118;
        Wed, 24 Feb 2021 11:29:05 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen\, Anthony L" <anthony.l.nguyen@intel.com>,
        "daichi1.fukui\@toshiba.co.jp" <daichi1.fukui@toshiba.co.jp>,
        "nobuhiro1.iwamatsu\@toshiba.co.jp" 
        <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Corinna Vinschen <vinschen@redhat.com>,
        "Brown\, Aaron F" <aaron.f.brown@intel.com>,
        "Keller\, Jacob E" <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log message
References: <20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp>
        <c5d7ccb5804b46eea2ef9fe29c66720f@intel.com>
Date:   Wed, 24 Feb 2021 11:28:59 +0900
In-Reply-To: <c5d7ccb5804b46eea2ef9fe29c66720f@intel.com> (Jacob E. Keller's
        message of "Wed, 10 Feb 2021 01:46:46 +0000")
X-TSB-HOP: ON
Message-ID: <87blcaw650.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[
  * dropping Jeff Kirsher as his email is bouncing
  * Adding networking maintainers
]

"Keller, Jacob E" <jacob.e.keller@intel.com> writes:

>> -----Original Message-----
>> From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
>> Sent: Tuesday, February 09, 2021 5:35 PM
>> To: netdev@vger.kernel.org
>> Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
>> <anthony.l.nguyen@intel.com>; daichi1.fukui@toshiba.co.jp;
>> nobuhiro1.iwamatsu@toshiba.co.jp; Corinna Vinschen <vinschen@redhat.com>;
>> Keller, Jacob E <jacob.e.keller@intel.com>; Brown, Aaron F
>> <aaron.f.brown@intel.com>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Subject: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log
>> message
>> 
>> From: Corinna Vinschen <vinschen@redhat.com>
>> 
>> commit 2643e6e90210e16c978919617170089b7c2164f7 upstream
>> 
>> TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
>> every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
>> secs on 80576 (45 bit SYSTIM).
>> 
>> This wrap event sets the TSICR.SysWrap bit unconditionally.
>> 
>> However, checking TSIM at interrupt time shows that this event does not
>> actually cause the interrupt.  Rather, it's just bycatch while the
>> actual interrupt is caused by, for instance, TSICR.TXTS.
>> 
>> The conclusion is that the SYS WRAP is actually expected, so the
>> "unexpected SYS WRAP" message is entirely bogus and just helps to
>> confuse users.  Drop it.
>> 
>> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
>> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
>> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>> Hi,
>> 
>> A customer reported that the following message appears in the kernel
>> logs every 1100s -
>> 
>>     igb 0000:01:00.1: unexpected SYS WRAP
>> 
>> As the systems have large uptimes the messages are crowding the logs.
>> 
>> The message was dropped in
>> commit 2643e6e90210e16c ("igb: Remove incorrect "unexpected SYS WRAP" log
>> message")
>> in v4.14.
>> 
>> Please consider applying to patch to v4.4 and v4.9 stable kernels - it
>> applies cleanly to both the trees.
>> 
>> Thanks,
>> Punit
>> 
>
> It makes sense to me for htis to apply to those stable trees as well.

Thanks Jake.

Networking maintainers - It's been a couple of weeks this patch is on
the list. Is there anything else that needs to be done for it to be
picked up for stable?

Thanks,
Punit

