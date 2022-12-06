Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381EF643B54
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiLFCf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiLFCf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:35:26 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA3D1DDF3;
        Mon,  5 Dec 2022 18:35:20 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NR4Jj5q33z4xVnZ;
        Tue,  6 Dec 2022 10:35:17 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl2.zte.com.cn with SMTP id 2B62Z6gN001419;
        Tue, 6 Dec 2022 10:35:06 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 6 Dec 2022 10:35:07 +0800 (CST)
Date:   Tue, 6 Dec 2022 10:35:07 +0800 (CST)
X-Zmail-TransId: 2b04638eaa5bffffffffd04e9db0
X-Mailer: Zmail v1.0
Message-ID: <202212061035074041030@zte.com.cn>
In-Reply-To: <20221205175314.0487527a@kernel.org>
References: 202212031612057505056@zte.com.cn,20221205175314.0487527a@kernel.org
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kuba@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0XSBuZXQ6IHJlY29yZCB0aW1lcyBvZiBuZXRkZXZfYnVkZ2V0IGV4aGF1c3RlZA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B62Z6gN001419
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 638EAA65.001 by FangMail milter!
X-FangMail-Envelope: 1670294118/4NR4Jj5q33z4xVnZ/638EAA65.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638EAA65.001/4NR4Jj5q33z4xVnZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Dec 2022 09:53:05 +0800 (CST) kuba@kernel.org wrote:
> time_squeeze is extremely noisy and annoyingly useless,
> we need to understand exactly what you're doing before
> we accept any changes to this core piece of code.

The author of "Replace 2 jiffies with sysctl netdev_budget_usecs
to enable softirq tuning" is Matthew Whitehead, he said this in
git log: Constants used for tuning are generally a bad idea, especially
as hardware changes over time...For example, a very fast machine
might tune this to 1000 microseconds, while my regression testing
486DX-25 needs it to be 4000 microseconds on a nearly idle network
to prevent time_squeeze from being incremented.

And on my systems there are huge packets on the intranet, and we
came accross with lots of time_squeeze. The idea is that, netdev_budget*
are selections between throughput and real-time. If we care throughput
and not care real-time so much, we may want bigger netdev_budget*.

In this scenario, we want to tune netdev_budget* and see their effect
separately.

By the way, if netdev_budget* are useless, should they be deleted?

Thanks.
