Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD05FCD1C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJLV0k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 17:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJLV0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:26:39 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB200C3540
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:26:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 63D4B14111F
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:26:36 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id NF29S5IWq9DW for <netdev@vger.kernel.org>;
        Wed, 12 Oct 2022 23:26:31 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 1E55A141056
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:26:31 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id ACD7B61494; Wed, 12 Oct 2022 23:26:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id A74A96138A
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:26:24 +0200 (CEST)
Date:   Wed, 12 Oct 2022 23:26:24 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: qdisc_watchdog_schedule_range_ns granularity
Message-ID: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

next thing ☺

For my “faked extra latency” I sometimes need to reschedule to
future, when all queued-up packets have receive timestamps in
the future. For this, I have been using:

	qdisc_watchdog_schedule_range_ns(&q->watchdog, rs, 0);

Where rs is the smallest in-the-future enqueue timestamp.

However it was observed that this can add quite a lot more extra
delay than planned, I saw single-digit millisecond figures, which
IMHO is already a lot, but a coworker saw around 17 ms, which is
definitely too much.

What is the granularity of qdisc watchdogs, and how can I aim at
being called again for dequeueing in more precise fashion? I would
prefer to being called within 1 ms, 2 if it must absolutely be, of
the timestamp passed.

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
