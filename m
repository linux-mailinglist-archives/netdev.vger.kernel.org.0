Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD18E4FEBD3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiDMAOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiDMAOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:14:41 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF602183C;
        Tue, 12 Apr 2022 17:12:21 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id o16so316070ljp.3;
        Tue, 12 Apr 2022 17:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OPQe8Z64vrzGUtC9itK+hO8CUXeLDKwiSIbnDFvsio=;
        b=Qcl/bQDuv6FgjogykXNz3P50kh0Fny/pYqWwHCXoyf+LwCq8hN36c7caeFxWPWs9EZ
         5Qfy/1zPjwbGYW/MYYJIGOUVlALJH69RLnqH4by+WrIegLTfQlS82zU4a9Rev85yWGUt
         dQrbOxKzATK8LTefZLLR9SASz2S4sw0KF1TEc9SRasauouBDJ+waFYtWYX8KcNZ/ZLlS
         eqIXLaSDnX1C1apEMO2FWSBNnhSMse9fw+PpQ1kBlgQE2G4+z0qm+sEebIB5vOR14Kg3
         hJE6HKaRIkdqxtptxfx0jknvC+LRS1RZbnntuxZJBz+TRx97bNXFVzQ0q62QnLh3jZwi
         +z3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4OPQe8Z64vrzGUtC9itK+hO8CUXeLDKwiSIbnDFvsio=;
        b=b/dCu9qGQFYE0VrA0hjMEJaNgPihSnXYSau6lELQjDoBGmMskbSv33D3LLFbQKdCmP
         FzK0ogaPYsniEg0pX2f43AuJNQyvVhlvLyOfpra6ffRVMWOVoyNIqwHxgxSNkIosfN2q
         +vIWSwtkWwdb27Vv2lOgYYAMHKYeMs/2gvRbV50hkmmKobhors0Ii3TFyQ0W14vqNrum
         FfjRAZUYFypXU0A0cV63LXKUq1TA043mohsELB4vzJGB5o2uJQepRzEHwDtaWWxJA8DU
         CfQFzrpczfJ/6cnnQ/Di8ygfwzcWR63RsHaiSnkQjJHjRFGXyifH9Dap1ip9G57PrGU1
         zuxA==
X-Gm-Message-State: AOAM530j/EHjO0290ltfxqT7C+MuhVOCdx3IvNFdKrLOxFE39W/MVTQ7
        t2iLUYGTWcanDpYzz7f3hS2Ho15qvvX6PQ==
X-Google-Smtp-Source: ABdhPJyG9GO1U13AiTli5L9QAhS9q1HO0x593NdqIL8d8TnL+6qJ6Vm6Zjjap7s9I/b+XKcyOsfoSg==
X-Received: by 2002:a2e:9e81:0:b0:24b:4d4:aba0 with SMTP id f1-20020a2e9e81000000b0024b04d4aba0mr24977242ljk.283.1649808739436;
        Tue, 12 Apr 2022 17:12:19 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id d6-20020a2e96c6000000b0024b4cd1b611sm1611731ljj.91.2022.04.12.17.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:12:18 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v2 0/3] rndis_host: handle bogus MAC addresses in ZTE RNDIS devices
Date:   Wed, 13 Apr 2022 02:11:55 +0200
Message-Id: <20220413001158.1202194-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When porting support of ZTE MF286R to OpenWrt [1], it was discovered,
that its built-in LTE modem fails to adjust its target MAC address,
when a random MAC address is assigned to the interface, due to detection of
"locally-administered address" bit. This leads to dropping of ingress
trafficat the host. The modem uses RNDIS as its primary interface,
with some variants exposing both of them simultaneously.

Then it was discovered, that cdc_ether driver contains a fixup for that
exact issue, also appearing on CDC ECM interfaces.
I discussed how to proceed with that with Bjørn Mork at OpenWrt forum [3],
with the first approach would be to trust the locally-administered MAC
again, and add a quirk for the problematic ZTE devices, as suggested by
Kristian Evensen. before [4], but reusing the fixup from cdc_ether looks
like a safer and more generic solution.

Finally, according to Bjørn's suggestion. limit the scope of bogus MAC
addressdetection to ZTE devices, the same way as it is done in cdc_ether,
as this trait wasn't really observed outside of ZTE devices.
Do that for both flavours of RNDIS devices, with interface classes
02/02/ff and e0/01/03, as both types are reported by different modems.

[1] https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=7ac8da00609f42b8aba74b7efc6b0d055b7cef3e
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bfe9b9d2df669a57a95d641ed46eb018e204c6ce
[3] https://forum.openwrt.org/t/problem-with-modem-in-zte-mf286r/120988
[4] https://lore.kernel.org/all/CAKfDRXhDp3heiD75Lat7cr1JmY-kaJ-MS0tt7QXX=s8RFjbpUQ@mail.gmail.com/T/

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>

v2: ensure that MAC fixup is applied to all Ethernet frames in RNDIS
batch, by introducing a driver flag, and integrating the fixup inside
rndis_rx_fixup().

Lech Perczak (3):
  cdc_ether: export usbnet_cdc_zte_rx_fixup
  rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
  rndis_host: limit scope of bogus MAC address detection to ZTE devices

 drivers/net/usb/cdc_ether.c    |  3 ++-
 drivers/net/usb/rndis_host.c   | 48 ++++++++++++++++++++++++++++++----
 include/linux/usb/rndis_host.h |  1 +
 include/linux/usb/usbnet.h     |  1 +
 4 files changed, 47 insertions(+), 6 deletions(-)

-- 
2.30.2

