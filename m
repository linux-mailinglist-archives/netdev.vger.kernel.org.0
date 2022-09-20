Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22865BECA1
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiITSPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITSPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:15:33 -0400
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F444BD13;
        Tue, 20 Sep 2022 11:15:32 -0700 (PDT)
Received: by mail-qv1-f51.google.com with SMTP id y9so2631728qvo.4;
        Tue, 20 Sep 2022 11:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=DXGgRFrzenuJCQ3cBD3T9BZ4V6UBP/IlbFITLbOc4wA=;
        b=XdozD86JEDcN2edKTqxCGYhFBH6R9h+IL/8PwHX9G/hjEFr6bSFj7FV2XDSbLjGV4b
         iS+6mVWYlUoamwIJWNL0AoRfmC1E6H4HZ0HYtzpk3K5OBSJNfmk6yj/uHNntsvC35CFL
         3DK4TxpcS3NF4QVrNxEOEWIQXSMsi999+FaXthDXuOGv43YxUvt5bZeZ6ijhAAz65BK0
         2wLbtqD2Q0UAqR00xGjjcfAzmsEvirk1DnmRaHhSH9YISj/gAgO8nzG5alQLqBS/vAyb
         vV35gQWz7rjqBDZS+M5weUvhPJgfBC4uNaNu77YEIlffjrxVh9j9+sVDtYxCoObCUldB
         cA8g==
X-Gm-Message-State: ACrzQf3J61qjSsIr+v9gZh4GQ1onOrFg4/w0j9lEM+Ye0aKexsxpvkoD
        EeH6vpYrXqHfGZ0DQBQxSFzIa1g6lwH5NA==
X-Google-Smtp-Source: AMsMyM6+NVbuGAFP7iY/mBRyhepCkBT0huTttfO1iK/AqcuMOLDlG/HxSi+aTawBS7H1kQqUFSO77w==
X-Received: by 2002:a0c:f307:0:b0:4aa:a431:c184 with SMTP id j7-20020a0cf307000000b004aaa431c184mr20783836qvl.76.1663697731003;
        Tue, 20 Sep 2022 11:15:31 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id l5-20020a05620a28c500b006bc1512986esm317501qkp.97.2022.09.20.11.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 11:15:30 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id 63so4630067ybq.4;
        Tue, 20 Sep 2022 11:15:30 -0700 (PDT)
X-Received: by 2002:a05:6902:45:b0:6ae:ce15:a08d with SMTP id
 m5-20020a056902004500b006aece15a08dmr20152275ybh.380.1663697730098; Tue, 20
 Sep 2022 11:15:30 -0700 (PDT)
MIME-Version: 1.0
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Sep 2022 20:15:19 +0200
X-Gmail-Original-Message-ID: <CAMuHMdURCeAVt_2L33P197qbj3UBXLWRZH0nZvm+UJbnzBCS2A@mail.gmail.com>
Message-ID: <CAMuHMdURCeAVt_2L33P197qbj3UBXLWRZH0nZvm+UJbnzBCS2A@mail.gmail.com>
Subject: E1000e PTP crash on R-Car Gen2
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

While leaving a Renesas Koelsch development board (with R-Car M2-W SoC)
and an otherwise unused Intel E1000e Ethernet card running unattended, I
ran into a crash after 4 hours and 5 minutes of uptime:

    Unhandled fault: asynchronous external abort (0x1211) at 0x00000000
    [00000000] *pgd=80000040004003, *pmd=00000000
    Internal error: : 1211 [#1] SMP ARM
    Modules linked in:
    CPU: 0 PID: 581 Comm: kworker/0:0 Tainted: G                 N
6.0.0-rc6-koelsch-00864-g34666b5da80f #1661
    Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
    Workqueue: events e1000e_systim_overflow_work
    PC is at e1000e_read_systim+0x3c/0x1c0
    LR is at timecounter_read+0x14/0xa0

    [...]

     e1000e_read_systim from timecounter_read+0x14/0xa0
     timecounter_read from e1000e_systim_overflow_work+0x24/0x7c
     e1000e_systim_overflow_work from process_one_work+0x2f0/0x4c4
     process_one_work from worker_thread+0x240/0x2d0
     worker_thread from kthread+0xd0/0xe0
     kthread from ret_from_fork+0x14/0x34

    [...]

    BUG: workqueue lockup - pool cpus=0 node=0 flags=0x0 nice=0 stuck for 39s!

    [...]

This happened when checking if the time counter overflowed, which is done
from a workqueue periodically (E1000_SYSTIM_OVERFLOW_PERIOD = 4 hours).
The asynchronous external abort is a typical symptom of accessing a
device's hardware registers (in this case the PCIe controller) while the
device's clock is disabled, so presumably the workqueue ran while the
device was runtime-suspended.

I don't know much about how and when Linux uses PTP, but I did notice
drivers/net/ethernet/intel/e1000e/netdev.c makes several pm_runtime_*()
calls (but not in e1000e_read_systim()), while
drivers/net/ethernet/intel/e1000e/ptp.c makes none.

Unfortunately I haven't managed to reproduce the problem (even with
E1000_SYSTIM_OVERFLOW_PERIOD reduced), so probably there is a race
condition somewhere.

Thanks for your comments!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
