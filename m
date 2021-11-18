Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB62455927
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbhKRKkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245737AbhKRKjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:39:01 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDDCC06120C
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:35:48 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a9so10578180wrr.8
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=yvn8rsCpK1/5zympBMn1S8RUdkJrZuTqZi9VIdDb2CI=;
        b=P+95QK4r5QrqxKNwOnS65fekAMheYSh55G0d9y7kVPTyTDHTOGtbqII74WpA4KC9H8
         R013GcPK05xCloCnOd2m08/xOCSoOmB8/voW8FRXnWFljxnyLU1FfVxs5hFSFZ5d567f
         u/PfpT+q05Iz79zvBH1byEONAoznn9mpTWgIFXdDdegBOmGZ463oB3wv5mEE/HNe1/gk
         3cWBFW5c8/KM9i2bJvWFzOkX1j8X3OiqhS0MF67hEfq3DtvufgPEz6Uwck99O9yESrqE
         N79yLzF1R/42EPjMhvo1x1DGj9XI8dRQercSIVNapucxPVYO/SQkWq5Pl6d9CGS1aWW3
         5z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yvn8rsCpK1/5zympBMn1S8RUdkJrZuTqZi9VIdDb2CI=;
        b=Wf1X8sBUlnQigNydG7aRqRiQuX2QxsP74Jus7dqRUnJBTlRuC+2hQxnK7h7w93jBGS
         nSrDuIKC5h9hBXUU1UikSdsN+o741/HPpLgELgNfhmMd7qKbrgAhGhhZA+J8ndgaOpO/
         Um4h/0pqLGxF5GiSGuCMq1cXoRvTCFeQhQRq3fmQ9X9K3ibtFgUFuT8QUMS9OQxQ+omJ
         FIS1bD+bdYXFgVh5aYn2SR4sScWdM6nyCfcxPM2RAc6MwnfO9mkJigwJBuRVAdjnDSmH
         vXa96E2NfsbYvZzsPQKYn8+lGST2eR7xALoVkTnzIqoS8un8eZMm3EuG0wuFL8emeTHL
         Qgrg==
X-Gm-Message-State: AOAM532UrK7Av7oD543VJGXNEG+ugbFa1uco00oeS8HA9rVFL8CIjw+I
        Km2QtX9OiilC1jcbei95KoZxWs680rEXVbrHZAuQ6ASu8Tw=
X-Google-Smtp-Source: ABdhPJxaxLpza1cdlNMwvrYO3nNTFoxarl5w+6d/JjGIgUbBdcotzcX+zVRX1s9Qr2LV6hN02YJrPFHVnhjBHWY1BrI=
X-Received: by 2002:a5d:530e:: with SMTP id e14mr29398697wrv.12.1637231747420;
 Thu, 18 Nov 2021 02:35:47 -0800 (PST)
MIME-Version: 1.0
From:   Juhamatti Kuusisaari <juhamatk@gmail.com>
Date:   Thu, 18 Nov 2021 12:35:36 +0200
Message-ID: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
Subject: IPv6 Router Advertisement Router Preference (RFC 4191) behavior issue
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have been testing IPv6 Router Advertisement Default Router
Preference on 5.1X and it seems it is not honoured by the Linux
networking stack. Whenever a new default router preference with a
higher or lower preference value is received, a new default gateway is
added as an ECMP route in the routing table with equal weight. This is
a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
preference value should be preferred. This part seems to be missing
from the Linux implementation.

The problem has existed apparently for a while, see below discussion
for reference:
https://serverfault.com/questions/768932/can-linux-be-made-to-honour-ipv6-route-advertisement-preferences

I am happy to test any improvements to this, in case someone takes a look.

Thanks!
--
 Juhamatti
