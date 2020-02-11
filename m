Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7275F158CA2
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 11:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgBKKYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 05:24:10 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56092 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgBKKYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 05:24:10 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01BAO3JI080604;
        Tue, 11 Feb 2020 04:24:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581416643;
        bh=IT0XtP14rOcxVvIjEkJLAVhnV8MbpGdBDYqA20Ogvvg=;
        h=To:CC:From:Subject:Date;
        b=ieDwTSX3jBi/zU1u4phaOZr/3Ii8HGFTXg5HGFMr7ljayvLceHG8Ur/umMkvypjRh
         QAQk97bS+itM9Sg0T+qBvIFm/dBtzumU10HinzZarwXkKrmUxTzv/JcfNi8oIXIkIW
         SvftF7u0/x73WxmsKAgW8ob+31xkdvsU5ZvYCsdk=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01BAO2kT021354;
        Tue, 11 Feb 2020 04:24:03 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 11
 Feb 2020 04:24:02 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 11 Feb 2020 04:24:03 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01BAO08Y044972;
        Tue, 11 Feb 2020 04:24:01 -0600
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>
CC:     <linux-rt-users@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Question about kthread_mod_delayed_work() allowed context
Message-ID: <cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com>
Date:   Tue, 11 Feb 2020 12:23:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I'd like to ask question about allowed calling context for kthread_mod_delayed_work().

The comment to kthread_mod_delayed_work() says:

  * This function is safe to call from any context including IRQ handler.
  * See __kthread_cancel_work() and kthread_delayed_work_timer_fn()
  * for details.
  */

But it has del_timer_sync() inside which seems can't be called from hard_irq context:
kthread_mod_delayed_work()
   |-__kthread_cancel_work()
      |- del_timer_sync()
	|- WARN_ON(in_irq() && !(timer->flags & TIMER_IRQSAFE));

My use case is related to PTP processing using PTP auxiliary worker:
(commit d9535cb7b760 ("ptp: introduce ptp auxiliary worker")):
  - periodic work A is started and res-schedules itself for every dtX
  - on IRQ - the work A need to be scheduled immediately

Any advice on how to proceed?
Can kthread_queue_work() be used even if there is delayed work is
scheduled already (in general, don't care if work A will be executed one
more time after timer expiration)?

-- 
Best regards,
grygorii
